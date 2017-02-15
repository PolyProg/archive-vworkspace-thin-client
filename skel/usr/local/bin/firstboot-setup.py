#!/usr/bin/env python3

import logging
from subprocess import check_call, check_output, DEVNULL, CalledProcessError

import sys

__author__ = "Benjamin Schubert <ben.c.schubert@gmail.com>"

logger = logging.getLogger(__name__)

RESET_SEQ = "\033[0m"
COLOR_SEQ = "\033[1;{}m"
BOLD_SEQ = "\033[1m"


class ColoredFormatter(logging.Formatter):
    AVAILABLE_COLORS = {
        name: COLOR_SEQ.format(index + 30)
        for index, name in enumerate(["BLACK", "RED", "GREEN", "YELLOW", "BLUE", "MAGENTA", "CYAN", "WHITE"])
        }

    DEFAULT_LEVEL_COLORS = {
        'WARNING': "YELLOW",
        'INFO': "WHITE",
        'DEBUG': "CYAN",
        'ERROR': "RED"
    }

    def __init__(self, fmt, datefmt=None, level_colors=None):
        fmt = fmt.replace("$RESET", RESET_SEQ).replace("$BOLD", BOLD_SEQ)
        for color, seq in self.AVAILABLE_COLORS.items():
            fmt = fmt.replace("${}".format(color), seq)

        super().__init__(fmt, datefmt, "{")

        if level_colors is None:
            level_colors = self.DEFAULT_LEVEL_COLORS

        self.level_colors = level_colors

    def format(self, record):
        fmt = self._fmt.replace("$LEVEL", self.AVAILABLE_COLORS[self.level_colors[record.levelname]])
        if self.usesTime():
            record.asctime = self.formatTime(record, self.datefmt)
        record.message = record.getMessage()
        return fmt.format(**record.__dict__)


def setup_logging():
    logger.setLevel(logging.INFO)
    formatter = ColoredFormatter("[$BLACK{asctime}$RESET] $LEVEL{message}$RESET", '%H:%M:%S')
    handler = logging.StreamHandler(sys.stderr)

    handler.setFormatter(formatter)
    logger.addHandler(handler)


def setup_keyboard():
    try:
        while True:
            check_call(["system-config-keyboard"])

            while True:
                res = input("Are you sure of your choice ? [y/N]").lower()
                if res == "y":
                    return
                elif res == "n" or res == "":
                    break
                else:
                    print("Invalid answer. Got {}".format(res))
    except FileNotFoundError:
        logger.error("system-config-keyboard is not installed, please install it. Aborting.")
        exit(1)


def check_wifi_availability():
    logger.info("Checking wifi availability ...")

    available_wifis = []
    output = check_output(["nmcli", "device", "show"]).decode().split("\n\n")
    for entry in output:
        network = entry.split("\n")

        for line in network:
            if line.startswith("GENERAL.TYPE") and "wifi" in line:
                available_wifis.append(network[0].split(" ")[-1])

    if available_wifis:
        logger.info("Found following interfaces supporting wifi : {}".format(",".join(available_wifis)))
    else:
        logger.error("No interface with wifi support was found. Please contact a staff member.")
        exit(1)


def check_laptop_is_charging():
    logger.info("Checking whether a power source is plugged in ...")
    while True:
        info = check_output(["acpi", "-b"]).decode()

        if "Discharging" in info:
            logger.warning("Your laptop is discharging. You should plug it in")

            while True:
                res = input("Do you want to recheck if your laptop is charging ? [Y/n]").lower()
                if res == "y" or res == "":
                    break
                elif res == "n":
                    return
                else:
                    print("Invalid answer. Got {}".format(res))
        else:
            break


def check_connected_to_internet():
    logger.info("Checking internet connection ...")
    try:
        check_call(["ping", "-c", "3", "www.google.com"], stdout=DEVNULL)
    except CalledProcessError:
        logging.warning("Not connected to the internet.")
        check_wifi_availability()


def main():
    setup_logging()
    logger.info("System up, launching setup")
    setup_keyboard()
    check_connected_to_internet()
    check_laptop_is_charging()


if __name__ == '__main__':
    main()

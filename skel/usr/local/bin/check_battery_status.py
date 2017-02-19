#!/usr/bin/env python3


import re
import subprocess

import time


acpi_output = re.compile(r"^.*\: (\w+), (\w+)")


def notify(title, message=None):
    cmd = ["notify-send", title]

    if message is not None:
        cmd.append(message)
    subprocess.call(cmd)


def get_battery_status():
    acpi = subprocess.check_output(["acpi", "-b"]).decode()
    first_line = acpi.split("\n")[0]

    info = re.match(acpi_output, first_line)
    return info.group(1), int(info.group(2))


def main():
    laptop_charging = True

    while True:
        status, percent = get_battery_status()

        if status == "Discharging" and laptop_charging:
            laptop_charging = False
            notify("Your laptop is now discharging", "Battery left : {}%".format(percent))
        elif status == "Charging" and not laptop_charging:
            laptop_charging = True
            notify("Laptop now charging")
        elif status == "Discharging" and percent < 25:
            notify("Your battery is running low", "{}% left".format(percent))

        time.sleep(10)


if __name__ == '__main__':
    main()

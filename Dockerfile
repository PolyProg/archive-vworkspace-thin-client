FROM fedora:latest

MAINTAINER "Benjamin Schubert <ben.c.schubert@gmail.com>"

RUN dnf --assumeyes update && \
    dnf --assumeyes install pykickstart lorax anaconda
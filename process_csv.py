#!/usr/bin/env python3
import csv
import sys


def main():
    src = csv.DictReader(sys.stdin)
    dst = csv.DictWriter(sys.stdout, fieldnames=src.fieldnames)

    dst.writeheader()
    for record in src:
        dst.writerow(process_record(record))


def process_record(record):
    return {key: replace_newline(value, key) for key, value in record.items()}


def replace_newline(value, key):
    separator = ", " if ("," not in value or key.casefold() == "address") else "; "
    return value.replace("\n", separator)


if __name__ == "__main__":
    sys.exit(main())

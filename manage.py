#!/usr/bin/env python3

import subprocess
from argparse import ArgumentParser, Namespace


def get_argparser() -> ArgumentParser:
    parser = ArgumentParser()

    subparsers = parser.add_subparsers()

    parser_dump = subparsers.add_parser(
        "dump", help="Update dotfiles from current install"
    )
    parser_dump.set_defaults(func=cmd_dump)

    return parser


def main():
    args = get_argparser().parse_args()
    args.func(args)


def cmd_dump(args: Namespace):
    print("Dumping Brewfile")
    subprocess.check_output(["brew", "bundle", "dump", "--describe", "--force"])


if __name__ == "__main__":
    main()

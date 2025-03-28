#!/usr/bin/env python3

import json
import subprocess
from argparse import ArgumentParser, Namespace
from collections import defaultdict
from dataclasses import asdict, dataclass
from pathlib import Path

PATH_DEFAULTS = Path("osx-defaults.json")


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
    print("Dumping System Settings")
    defaults = read_osx_defaults(from_system=True)
    write_osx_defaults(defaults)

    print("Dumping Brewfile")
    subprocess.check_output(["brew", "bundle", "dump", "--describe", "--force"])


@dataclass
class DefaultValue:
    dtype: str
    value: str


@dataclass
class OsxDefaults:
    # Map of namespace -> keys we want to dump or sync.
    dump: dict[str, list[str]]

    # Actual dumped values
    values: defaultdict[str, dict[str, DefaultValue]]


def read_osx_defaults(from_system: bool = False) -> OsxDefaults:
    with PATH_DEFAULTS.open("r") as f:
        content = json.load(f)

    defaults = OsxDefaults(
        dump=content["dump"],
        values=defaultdict(
            dict,
            {
                ns: {k: DefaultValue(v["dtype"], v["value"]) for k, v in keys.items()}
                for ns, keys in content.get("values", {}).items()
            },
        ),
    )

    if from_system:
        for ns, keys in defaults.dump.items():
            for key in keys:
                dtype = subprocess.check_output(
                    ["defaults", "read-type", ns, key], text=True
                )
                dtype = dtype.removeprefix("Type is ").strip()
                val = subprocess.check_output(
                    ["defaults", "read", ns, key], text=True
                ).strip()

                defaults.values[ns][key] = DefaultValue(dtype, val)

    return defaults


def write_osx_defaults(defaults: OsxDefaults):
    with PATH_DEFAULTS.open("w") as f:
        data = asdict(defaults)
        json.dump(data, f, indent=2)


if __name__ == "__main__":
    main()

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

    parser_apply = subparsers.add_parser("apply", help="Apply dumped settings")
    parser_apply.set_defaults(func=cmd_apply)

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


def cmd_apply(args):
    print("Applying System Settings")
    defaults = read_osx_defaults()
    apply_osx_defaults(defaults)

    # print("Installing Brewfile")
    # subprocess.check_output(["brew", "bundle", "install"])


@dataclass
class DefaultValue:
    dtype: str
    value: str

    def to_args(self) -> tuple[str, str]:
        if self.dtype == "boolean":
            val = "true" if self.value == "1" else "false"
        else:
            val = self.value

        return ("-" + self.dtype, val)


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
                try:
                    dtype = subprocess.check_output(
                        ["defaults", "read-type", ns, key], text=True
                    )
                    dtype = dtype.removeprefix("Type is ").strip()
                    val = subprocess.check_output(
                        ["defaults", "read", ns, key], text=True
                    ).strip()

                    defaults.values[ns][key] = DefaultValue(dtype, val)
                except subprocess.CalledProcessError as e:
                    print(e.output)

    return defaults


def write_osx_defaults(defaults: OsxDefaults):
    with PATH_DEFAULTS.open("w") as f:
        data = asdict(defaults)
        json.dump(data, f, indent=2)


def apply_osx_defaults(defaults: OsxDefaults):
    for ns, keys in defaults.values.items():
        for key, val in keys.items():
            subprocess.check_output(["defaults", "write", ns, key, *val.to_args()])


if __name__ == "__main__":
    main()

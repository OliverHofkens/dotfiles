#!/usr/bin/env python3
"""Convert newly-imported FLACs to lossy, archive the masters to MEGA and the
homeserver, then delete the local copies once both are verified.

Env vars (set in ~/dotfiles/.envrc, not hardcoded here since this repo is
public): FLAC_ARCHIVE_SSH_TARGET (required), FLAC_ARCHIVE_LOCAL_DIR,
FLAC_ARCHIVE_REMOTE_PATH, FLAC_ARCHIVE_MEGA_PATH (see defaults below).
"""

import argparse
import os
import shutil
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path

DEFAULT_LOCAL_DIR = "~/FlacArchive/Music"
DEFAULT_REMOTE_PATH = "/failsafe/media/flac"
DEFAULT_MEGA_PATH = "/FlacArchive"


@dataclass
class Config:
    local_dir: Path
    ssh_target: str
    remote_path: str
    mega_path: str


def get_argparser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument(
        "--skip-convert",
        action="store_true",
        help="Skip `beet convert`; assume FLAC_ARCHIVE_LOCAL_DIR is already populated",
    )
    parser.add_argument("--skip-mega", action="store_true", help="Skip pushing to MEGA")
    parser.add_argument(
        "--skip-homeserver", action="store_true", help="Skip pushing to the homeserver"
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would happen without pushing, deleting, or converting anything",
    )
    parser.add_argument(
        "--yes",
        "-y",
        action="store_true",
        help="Skip the confirmation prompt before deleting local files",
    )
    return parser


def load_config() -> Config:
    ssh_target = os.environ.get("FLAC_ARCHIVE_SSH_TARGET")
    if not ssh_target:
        print(
            "FLAC_ARCHIVE_SSH_TARGET is not set. Set it to your homeserver's SSH\n"
            "target (e.g. 'oliver@roon.home.arpa' or an IP) in ~/dotfiles/.envrc.",
            file=sys.stderr,
        )
        sys.exit(1)

    local_dir = Path(
        os.environ.get("FLAC_ARCHIVE_LOCAL_DIR", DEFAULT_LOCAL_DIR)
    ).expanduser()

    return Config(
        local_dir=local_dir,
        ssh_target=ssh_target,
        remote_path=os.environ.get("FLAC_ARCHIVE_REMOTE_PATH", DEFAULT_REMOTE_PATH),
        mega_path=os.environ.get("FLAC_ARCHIVE_MEGA_PATH", DEFAULT_MEGA_PATH),
    )


def main() -> None:
    sys.stdout.reconfigure(line_buffering=True)

    args = get_argparser().parse_args()
    config = load_config()

    if not args.skip_convert:
        if not run_beet_convert(dry_run=args.dry_run):
            print("beet convert failed, aborting.", file=sys.stderr)
            sys.exit(1)

    if not config.local_dir.is_dir():
        print(f"Nothing to archive: {config.local_dir} does not exist.")
        return

    local_count = count_local_files(config.local_dir)
    if local_count == 0:
        print(f"Nothing new to archive in {config.local_dir}.")
        return

    print(f"Found {local_count} local file(s) in {config.local_dir} to archive.")

    if not args.skip_mega:
        if not push_to_mega(config, local_count, dry_run=args.dry_run):
            print(
                "MEGA push failed or could not be verified, aborting.", file=sys.stderr
            )
            sys.exit(1)

    if not args.skip_homeserver:
        if not push_to_homeserver(config, local_count, dry_run=args.dry_run):
            print(
                "Homeserver push failed or could not be verified, aborting.",
                file=sys.stderr,
            )
            sys.exit(1)

    if args.dry_run:
        print("\nDry run: no local files were deleted.")
        return

    delete_local_files(config.local_dir, local_count, skip_confirm=args.yes)


def run_beet_convert(dry_run: bool) -> bool:
    # format:flac matches only not-yet-converted items, so this is
    # idempotent. A bare `-a -y` would reprocess the whole library and
    # overwrite already-archived masters with lossy copies.
    cmd = ["beet", "convert", "-a", "format:flac"]
    cmd += ["-p"] if dry_run else ["-k", "-y"]
    print(f"$ {' '.join(cmd)}")
    return subprocess.run(cmd).returncode == 0


def count_local_files(local_dir: Path) -> int:
    return sum(1 for p in local_dir.rglob("*") if p.is_file())


def push_to_mega(config: Config, local_count: int, dry_run: bool) -> bool:
    remote_before = count_mega_files(config.mega_path)

    if dry_run:
        print(
            f"[dry-run] Would `mega-put -c {config.local_dir} {config.mega_path}` "
            f"({local_count} local file(s))"
        )
        return True

    cmd = ["mega-put", "-c", str(config.local_dir), config.mega_path]
    print(f"$ {' '.join(cmd)}")
    if subprocess.run(cmd).returncode != 0:
        return False

    remote_after = count_mega_files(config.mega_path)
    delta = remote_after - remote_before
    if delta != local_count:
        print(
            f"MEGA file count only went up by {delta}, expected {local_count} "
            f"(before={remote_before}, after={remote_after}).",
            file=sys.stderr,
        )
        return False

    print(f"Verified on MEGA: {config.mega_path} gained {delta} file(s).")
    return True


def count_mega_files(mega_path: str) -> int:
    result = subprocess.run(
        ["mega-find", mega_path, "--type=f"], capture_output=True, text=True
    )
    if result.returncode != 0:
        return 0
    return len(result.stdout.splitlines())


def push_to_homeserver(config: Config, local_count: int, dry_run: bool) -> bool:
    remote_before = count_remote_files(config.ssh_target, config.remote_path)

    src = f"{config.local_dir}/"
    dst = f"{config.ssh_target}:{config.remote_path}/"
    cmd = ["rsync", "-a"]
    if dry_run:
        cmd.append("--dry-run")
        cmd.append("--itemize-changes")
    cmd += [src, dst]

    print(f"$ {' '.join(cmd)}")
    if subprocess.run(cmd).returncode != 0:
        return False

    if dry_run:
        return True

    remote_after = count_remote_files(config.ssh_target, config.remote_path)
    delta = remote_after - remote_before
    if delta != local_count:
        print(
            f"Homeserver file count only went up by {delta}, expected {local_count} "
            f"(before={remote_before}, after={remote_after}).",
            file=sys.stderr,
        )
        return False

    print(f"Verified on homeserver: {config.remote_path} gained {delta} file(s).")
    return True


def count_remote_files(ssh_target: str, remote_path: str) -> int:
    result = subprocess.run(
        ["ssh", ssh_target, "find", remote_path, "-type", "f"],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        return 0
    return len(result.stdout.splitlines())


def delete_local_files(local_dir: Path, local_count: int, skip_confirm: bool) -> None:
    # Safe because mega-put/rsync only ever add files remotely, and we've
    # just verified both counts went up by local_count.
    if not skip_confirm:
        prompt = (
            f"\nDelete {local_count} local file(s) under {local_dir} now that "
            "both backups are verified? [y/N] "
        )
        answer = input(prompt).strip().lower()
        if answer not in ("y", "yes"):
            print("Aborted, local files were not deleted.")
            return

    for entry in local_dir.iterdir():
        if entry.is_dir():
            shutil.rmtree(entry)
        else:
            entry.unlink()
    print(f"Deleted {local_count} local file(s) from {local_dir}.")


if __name__ == "__main__":
    main()

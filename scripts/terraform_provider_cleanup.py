#!/usr/bin/env python3
"""Recursively find `.terraform` directories and delete outdated provider
versions to reclaim disk space.

Terraform (0.13+) caches every provider version it has ever used under:

    <project>/.terraform/providers/<registry>/<namespace>/<type>/<version>/<os_arch>/...

This script walks a directory tree looking for `.terraform` folders, groups
provider version directories by their provider (registry/namespace/type),
and deletes all but the newest `--keep` version(s) of each provider.
"""

import argparse
import os
import re
import shutil
import sys
from dataclasses import dataclass, field
from pathlib import Path

VERSION_RE = re.compile(r"^\d+(\.\d+)*([-.].+)?$")


@dataclass
class ProviderGroup:
    # Directory containing one subdirectory per version, e.g.
    # .terraform/providers/registry.terraform.io/hashicorp/aws
    path: Path

    # Version directory names -> parsed sort key, newest first.
    versions: list[str] = field(default_factory=list)

    def name(self) -> str:
        return str(self.path)


@dataclass
class DeletionCandidate:
    path: Path
    provider: str
    version: str
    size_bytes: int


def get_argparser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "root",
        nargs="?",
        default=".",
        help="Directory to recursively scan for .terraform folders (default: %(default)s)",
    )
    parser.add_argument(
        "--keep",
        type=int,
        default=1,
        metavar="N",
        help="Number of newest provider versions to keep per provider (default: %(default)s)",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Only report what would be deleted, without deleting or prompting",
    )
    parser.add_argument(
        "--yes",
        action="store_true",
        help="Skip the confirmation prompt and delete immediately",
    )
    return parser


def main() -> None:
    args = get_argparser().parse_args()

    if args.keep < 1:
        print("--keep must be at least 1", file=sys.stderr)
        sys.exit(1)

    root = Path(args.root).expanduser().resolve()
    if not root.is_dir():
        print(f"Not a directory: {root}", file=sys.stderr)
        sys.exit(1)

    terraform_dirs = find_terraform_dirs(root)
    if not terraform_dirs:
        print(f"No .terraform directories found under {root}")
        return

    candidates: list[DeletionCandidate] = []
    for tf_dir in terraform_dirs:
        providers_dir = tf_dir / "providers"
        if not providers_dir.is_dir():
            continue

        for group in find_provider_groups(providers_dir):
            outdated = group.versions[args.keep :]
            for version in outdated:
                version_dir = group.path / version
                candidates.append(
                    DeletionCandidate(
                        path=version_dir,
                        provider=str(group.path.relative_to(root)),
                        version=version,
                        size_bytes=dir_size(version_dir),
                    )
                )

    if not candidates:
        print(f"No outdated provider versions found under {root} (--keep={args.keep})")
        return

    print_report(candidates)

    if args.dry_run:
        print("\nDry run: no files were deleted.")
        return

    if not args.yes:
        total_size = sum(c.size_bytes for c in candidates)
        prompt = (
            f"\nDelete {len(candidates)} outdated provider version(s) "
            f"totaling {human_size(total_size)}? [y/N] "
        )
        answer = input(prompt).strip().lower()
        if answer not in ("y", "yes"):
            print("Aborted, nothing was deleted.")
            return

    delete_candidates(candidates)


def find_terraform_dirs(root: Path) -> list[Path]:
    """Find all `.terraform` directories under root, without descending into
    an already-found `.terraform` directory."""
    found: list[Path] = []
    for dirpath, dirnames, _filenames in os.walk(root):
        if ".terraform" in dirnames:
            found.append(Path(dirpath) / ".terraform")
            dirnames.remove(".terraform")
    return found


def find_provider_groups(providers_dir: Path) -> list[ProviderGroup]:
    """Walk a `.terraform/providers` directory and find every directory whose
    immediate subdirectories are all version-looking names, sorted newest
    first."""
    groups: list[ProviderGroup] = []

    for dirpath, dirnames, _filenames in os.walk(providers_dir):
        if not dirnames:
            continue

        if all(VERSION_RE.match(name) for name in dirnames):
            sorted_versions = sorted(dirnames, key=version_key, reverse=True)
            groups.append(ProviderGroup(path=Path(dirpath), versions=sorted_versions))
            # These directories are versions, not further provider nesting.
            dirnames.clear()

    return groups


def version_key(version: str) -> tuple:
    """Parse a version string into a tuple usable for sorting, e.g.
    '5.31.0' -> (5, 31, 0). Non-numeric/pre-release suffixes sort lower than
    a plain release of the same numeric prefix."""
    main_part = re.split(r"[-+]", version, maxsplit=1)[0]
    parts = []
    for chunk in main_part.split("."):
        if chunk.isdigit():
            parts.append(int(chunk))
        else:
            parts.append(-1)

    is_prerelease = "-" in version
    # Plain releases should sort above pre-releases with the same numeric
    # prefix, so use `is_prerelease` (False < True) as a tiebreaker.
    return (tuple(parts), not is_prerelease)


def dir_size(path: Path) -> int:
    total = 0
    for dirpath, _dirnames, filenames in os.walk(path):
        for filename in filenames:
            file_path = Path(dirpath) / filename
            try:
                total += file_path.stat().st_size
            except OSError:
                pass
    return total


def human_size(size_bytes: int) -> str:
    size = float(size_bytes)
    for unit in ("B", "KB", "MB", "GB", "TB"):
        if size < 1024 or unit == "TB":
            return f"{size:.1f} {unit}"
        size /= 1024
    return f"{size:.1f} TB"


def print_report(candidates: list[DeletionCandidate]) -> None:
    print(f"Found {len(candidates)} outdated provider version(s):\n")
    for candidate in candidates:
        print(
            f"  {candidate.provider}/{candidate.version}  "
            f"({human_size(candidate.size_bytes)})  -> {candidate.path}"
        )

    total_size = sum(c.size_bytes for c in candidates)
    print(f"\nTotal reclaimable space: {human_size(total_size)}")


def delete_candidates(candidates: list[DeletionCandidate]) -> None:
    for candidate in candidates:
        try:
            shutil.rmtree(candidate.path)
            print(f"Deleted {candidate.path}")
        except OSError as e:
            print(f"Failed to delete {candidate.path}: {e}", file=sys.stderr)


if __name__ == "__main__":
    main()

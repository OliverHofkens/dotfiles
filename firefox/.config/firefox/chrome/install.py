#!/usr/bin/env python3
import platform
from pathlib import Path

PROFILE_DIRS = {
    "Linux": "~/.mozilla/firefox/",
    "Darwin": "~/Library/Application Support/Firefox/Profiles/",
    "Windows": "~\\AppData\\Roaming\\Mozilla\\Firefox\\Profiles\\"
}

profile_dir = Path(PROFILE_DIRS[platform.system()]).expanduser().resolve()
default_profile_dir = next(d for d in profile_dir.iterdir() if d.is_dir() and d.name.endswith(".default"))

userchrome_target = default_profile_dir / "chrome" / "userChrome.css"
userchrome_source = (Path(__file__).parent / "userChrome.css").resolve()
print(f"Symlinking {userchrome_target} to {userchrome_source}")
userchrome_target.symlink_to(userchrome_source)

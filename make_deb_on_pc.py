#!/usr/bin/env python3
"""
Create a .deb package on Windows (or any PC) when you already have P7.dylib.
Use this after you get P7.dylib (e.g. from GitHub Actions artifact).

Usage:
  1. Put P7.dylib in this folder (same folder as this script).
  2. Run:  python make_deb_on_pc.py
  3. You get: P7_1.0_iphoneos-arm.deb and P7_1.0_iphoneos-arm_rootless.deb
"""

import io
import os
import gzip
import shutil
import tarfile
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
DEB_DIR = SCRIPT_DIR / "deb"
DEB_ROOTLESS = SCRIPT_DIR / "deb_rootless"
DYLIB = SCRIPT_DIR / "P7.dylib"


def write_ar_file(output_path, members):
    """Write an ar archive (used by .deb). members = [(name, bytes), ...]"""
    with open(output_path, "wb") as f:
        f.write(b"!<arch>\n")
        for name, data in members:
            name = name.encode("ascii").ljust(16)[:16]
            size = len(data)
            # ar header: name(16) mtime(12) uid(6) gid(6) mode(8) size(10) fmag(2)
            mtime = b"0" * 12
            uid = b"0" * 6
            gid = b"0" * 6
            mode = b"100644" + b" " * 2
            size_str = str(size).encode("ascii").ljust(10)[:10]
            f.write(name + mtime + uid + gid + mode + size_str + b"`\n")
            f.write(data)
            if size % 2:
                f.write(b"\n")


def make_tar_gz(files_list):
    """files_list = [(arcname, path_or_bytes), ...]. Returns gzipped tar bytes."""
    buf = io.BytesIO()
    with tarfile.open(fileobj=buf, mode="w:") as tar:
        for arcname, content in files_list:
            if isinstance(content, (str, Path)):
                tar.add(content, arcname=arcname)
            else:
                ti = tarfile.TarInfo(arcname)
                ti.size = len(content)
                tar.addfile(ti, io.BytesIO(content))
    return gzip.compress(buf.getvalue(), mtime=0)


def build_deb(variant="classic"):
    if variant == "classic":
        base = SCRIPT_DIR / "p7_deb_build"
        lib_dir = base / "Library" / "MobileSubstrate" / "DynamicLibraries"
        plist_src = DEB_DIR / "Library" / "MobileSubstrate" / "DynamicLibraries" / "P7.plist"
        out_deb = SCRIPT_DIR / "P7_1.0_iphoneos-arm.deb"
    else:
        base = SCRIPT_DIR / "p7_rootless_build"
        lib_dir = base / "var" / "jb" / "Library" / "MobileSubstrate" / "DynamicLibraries"
        plist_src = DEB_ROOTLESS / "var" / "jb" / "Library" / "MobileSubstrate" / "DynamicLibraries" / "P7.plist"
        out_deb = SCRIPT_DIR / "P7_1.0_iphoneos-arm_rootless.deb"

    if base.exists():
        shutil.rmtree(base)
    base.mkdir(parents=True)
    (base / "DEBIAN").mkdir()
    lib_dir.mkdir(parents=True)

    control_path = base / "DEBIAN" / "control"
    shutil.copy(DEB_DIR / "DEBIAN" / "control", control_path)
    shutil.copy(DYLIB, lib_dir / "P7.dylib")
    shutil.copy(plist_src, lib_dir / "P7.plist")

    # control.tar.gz
    control_tar = make_tar_gz([
        ("./control", control_path),
    ])
    # data.tar.gz — all files under base except DEBIAN
    data_files = []
    for root, dirs, files in os.walk(base):
        for f in files:
            full = Path(root) / f
            rel = full.relative_to(base)
            if rel.parts[0] == "DEBIAN":
                continue
            data_files.append((("./" + str(rel).replace("\\", "/"), full)))
    data_tar = make_tar_gz(data_files)

    write_ar_file(out_deb, [
        ("debian-binary", b"2.0\n"),
        ("control.tar.gz", control_tar),
        ("data.tar.gz", data_tar),
    ])
    print("Created:", out_deb)
    shutil.rmtree(base)


def main():
    if not DYLIB.exists():
        print("ERROR: P7.dylib not found in:", SCRIPT_DIR)
        print("Get P7.dylib from GitHub Actions (see BUILD_AND_INSTALL.md) or build on a Mac.")
        return 1
    if not (DEB_DIR / "DEBIAN" / "control").exists():
        print("ERROR: deb/DEBIAN/control not found.")
        return 1
    build_deb("classic")
    build_deb("rootless")
    print("Done. Copy the .deb to your iPhone and install with Filza/Sileo.")
    return 0


if __name__ == "__main__":
    exit(main())

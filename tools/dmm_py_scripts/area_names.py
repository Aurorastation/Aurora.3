"""
Resolve /area type paths to their in-game `name` by scanning the .dm code (with inheritance).

Useful e.g. for things that build tags from `get_area(src)` (like the button control
map markers), where two areas sharing a display name would collide.

Examples (run from repo root):
    # names of all areas used in a map, flagging names shared with other area types
    python tools/dmm_py_scripts/area_names.py --map maps/sccv_horizon/sccv_horizon.dmm

    # all area types sharing a name with another area type
    python tools/dmm_py_scripts/area_names.py --duplicates

    # specific areas
    python tools/dmm_py_scripts/area_names.py /area/horizon/medical/psych /area/horizon/security/office

As a library: `names, resolve = area_names.load(); resolve("/area/foo")`.
Only simple `/area/path` + tab-indented `name = "..."` definitions are understood;
unresolved areas print as None.
"""

import argparse
import collections
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import dmm_utils as du  # noqa: E402

NAME_RE = re.compile(r'^\tname\s*=\s*(".*")\s*(//.*)?$')


def load(roots=("code", "maps")):
    """Returns (dict area_path -> resolved raw name or None, resolve(path) function)."""
    defs = {}
    for root in roots:
        for dirpath, _, files in os.walk(os.path.join(du.REPO_DIR, root)):
            for f in files:
                if not f.endswith(".dm"):
                    continue
                cur = None
                with open(os.path.join(dirpath, f), encoding="utf-8", errors="replace") as fh:
                    for line in fh:
                        line = line.rstrip("\n").rstrip("\r")
                        if line.startswith("/area"):
                            head = re.split(r"[\s{]", line, maxsplit=1)[0]
                            if "(" in head or "/proc/" in head or "/verb/" in head:
                                cur = None  # proc definition, not a type
                                continue
                            cur = head
                            defs.setdefault(cur, None)
                        elif line and not line[0].isspace():
                            cur = None
                        elif cur:
                            mt = NAME_RE.match(line)
                            if mt:
                                defs[cur] = mt.group(1)

    def resolve(path):
        while path and path.count("/") >= 2:
            if defs.get(path):
                return defs[path]
            path = path.rsplit("/", 1)[0]
        return defs.get(path)

    return {p: resolve(p) for p in defs}, resolve


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("areas", nargs="*", help="area paths to resolve")
    ap.add_argument("--map", help="resolve all areas used in this .dmm")
    ap.add_argument("--duplicates", action="store_true", help="list area types sharing a name")
    args = ap.parse_args()

    names, resolve = load()
    by_name = collections.defaultdict(list)
    for p, n in names.items():
        if n:
            by_name[n].append(p)

    areas = [du.type_arg(a) for a in args.areas]
    if args.map:
        m = du.load_map(args.map)
        areas += sorted({du.tile_area(t) for t in m.dictionary.values()} - {None})

    for a in areas:
        n = resolve(a)
        shared = [p for p in by_name.get(n, []) if p != a]
        print(f"{a}  {n}" + (f"  (shared with {len(shared)}: {', '.join(shared[:4])}{' ...' if len(shared) > 4 else ''})" if shared else ""))

    if args.duplicates:
        for n, ps in sorted(by_name.items()):
            if len(ps) > 1:
                print(f"{n}: {', '.join(sorted(ps))}")


if __name__ == "__main__":
    main()

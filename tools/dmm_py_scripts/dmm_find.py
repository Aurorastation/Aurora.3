"""
Search a .dmm map for atoms without reading the map by hand.

Examples (run from repo root):
    # every shutter with an id, and where it is
    python tools/dmm_py_scripts/dmm_find.py maps/sccv_horizon/sccv_horizon.dmm --type /obj/structure/machinery/door/blast/shutters --var id

    # everything that uses the string "medicalisolation" in any var
    python tools/dmm_py_scripts/dmm_find.py maps/sccv_horizon/sccv_horizon.dmm --value medicalisolation

    # how many airlock buttons use each specialfunctions value
    python tools/dmm_py_scripts/dmm_find.py maps/sccv_horizon/sccv_horizon.dmm --type /obj/structure/machinery/button/remote/airlock --group-by specialfunctions

Filters combine with AND. Values match either the raw map text (`"foo"`, `list(5)`, `8`)
or the unquoted string (`foo`).
"""

import argparse
import collections
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import dmm_utils as du  # noqa: E402


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("map", help="path to .dmm (absolute or relative to repo root)")
    ap.add_argument("--type", action="append", default=[], help="type path, subtypes included; repeatable (OR)")
    ap.add_argument("--exact", action="store_true", help="--type matches the exact path only, no subtypes")
    ap.add_argument("--var", action="append", default=[], metavar="NAME[=VALUE]",
                    help="atom has var NAME edited (optionally equal to VALUE); repeatable (AND)")
    ap.add_argument("--novar", action="append", default=[], metavar="NAME", help="atom does NOT have var NAME edited")
    ap.add_argument("--value", help="any var of the atom equals VALUE")
    ap.add_argument("--area", help="tile area path, subtypes included")
    ap.add_argument("--group-by", metavar="VAR", help="print counts per value of VAR (use 'type' or 'area' too)")
    ap.add_argument("--count", action="store_true", help="only print totals")
    ap.add_argument("--coords", type=int, default=3, help="max coordinates printed per key (default 3, 0 = none)")
    args = ap.parse_args()
    args.type = [du.type_arg(t) for t in args.type]
    args.area = du.type_arg(args.area) if args.area else None

    m = du.load_map(args.map)
    coords = du.key_coords(m)

    def type_ok(a):
        if not args.type:
            return True
        return any((a.path == t) if args.exact else a.isa(t) for t in args.type)

    def vars_ok(a):
        for spec in args.var:
            name, eq, value = spec.partition("=")
            if not a.has(name):
                return False
            if eq and not du.value_matches(a.get(name), value):
                return False
        if any(a.has(n) for n in args.novar):
            return False
        if args.value is not None and not any(du.value_matches(v, args.value) for _, v in a.vars):
            return False
        return True

    hits = []  # (key, area, atom)
    for key, atoms in du.iter_tiles(m):
        area = du.tile_area(atoms)
        if args.area and not du.isa(area or "", args.area):
            continue
        for a in atoms:
            if type_ok(a) and vars_ok(a):
                hits.append((key, area, a))

    placed = sum(len(coords[k]) for k, _, _ in hits)
    if args.group_by:
        c = collections.Counter()
        for key, area, a in hits:
            if args.group_by == "type":
                g = a.path
            elif args.group_by == "area":
                g = area
            else:
                g = a.get(args.group_by, "<unset>")
            c[g] += len(coords[key])
        for g, n in c.most_common():
            print(f"{n:6}  {g}")
    elif not args.count:
        for key, area, a in hits:
            cs = coords[key]
            shown = ", ".join(f"({x},{y},{z})" for x, y, z in sorted(cs)[:args.coords]) if args.coords else ""
            more = f" +{len(cs) - args.coords}" if args.coords and len(cs) > args.coords else ""
            print(f'"{du.key_name(m, key)}" x{len(cs)} {area} [{shown}{more}]')
            print(f"    {a.render()}")
    print(f"-- {len(hits)} atoms in tile definitions, {placed} placed on the map", file=sys.stderr)


if __name__ == "__main__":
    main()

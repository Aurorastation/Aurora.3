"""
Bulk-edit var edits on atoms in a .dmm map. Dry run by default; pass --write to save.

Examples (run from repo root):
    # drop redundant `dir = 2` from all shutters
    python tools/dmm_py_scripts/dmm_edit_vars.py maps/sccv_horizon/sccv_horizon.dmm --type /obj/structure/machinery/door/blast/shutters --where dir=2 --remove dir

    # rename every button with a given id
    python tools/dmm_py_scripts/dmm_edit_vars.py maps/sccv_horizon/sccv_horizon.dmm --type /obj/structure/machinery/button --where id=medicalisolation --set-str "name=Isolation Ward Shutters" --write

    # change the type path of matching atoms (vars are kept)
    python tools/dmm_py_scripts/dmm_edit_vars.py some.dmm --type /obj/old/path --exact --retype /obj/new/path --write

Identical tile definitions produced by the edit are merged automatically.
"""

import argparse
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import dmm_utils as du  # noqa: E402


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("map")
    ap.add_argument("--type", action="append", default=[], required=True, help="type path, subtypes included; repeatable (OR)")
    ap.add_argument("--exact", action="store_true", help="--type matches the exact path only")
    ap.add_argument("--where", action="append", default=[], metavar="NAME[=VALUE]", help="only atoms with this var (and value); AND")
    ap.add_argument("--remove", action="append", default=[], metavar="NAME", help="remove var edit NAME")
    ap.add_argument("--set", action="append", default=[], metavar="NAME=RAW", help='set var to raw DM text, e.g. dir=4 or name="\\"Foo\\""')
    ap.add_argument("--set-str", action="append", default=[], metavar="NAME=TEXT", help="set var to TEXT as a quoted DM string")
    ap.add_argument("--retype", metavar="PATH", help="replace the atom's type path")
    ap.add_argument("--write", action="store_true", help="save the map (otherwise dry run)")
    ap.add_argument("--show", type=int, default=10, help="print up to N example changes (default 10)")
    args = ap.parse_args()
    args.type = [du.type_arg(t) for t in args.type]
    args.retype = du.type_arg(args.retype) if args.retype else None

    sets = [s.split("=", 1) for s in args.set] + [[n, du.quote(v)] for n, v in (s.split("=", 1) for s in args.set_str)]
    m = du.load_map(args.map)
    stats = {"atoms": 0, "shown": 0}

    def match(a):
        if not any((a.path == t) if args.exact else a.isa(t) for t in args.type):
            return False
        for spec in args.where:
            name, eq, value = spec.partition("=")
            if not a.has(name) or (eq and not du.value_matches(a.get(name), value)):
                return False
        return True

    def edit(key, atoms):
        changed = False
        out = []
        for a in atoms:
            if match(a):
                b = a.copy()
                b.remove(*args.remove)
                for n, v in sets:
                    b.set(n, v)
                if args.retype:
                    b.path = args.retype
                if b.render() != a.render():
                    changed = True
                    stats["atoms"] += 1
                    if stats["shown"] < args.show:
                        stats["shown"] += 1
                        print(f'"{du.key_name(m, key)}": {a.render()}\n    -> {b.render()}')
                a = b
            out.append(a)
        return out if changed else None

    n = du.edit_tiles(m, edit)
    print(f"-- {stats['atoms']} atoms changed in {n} tile definitions", file=sys.stderr)
    if args.write and n:
        du.save_map(m, args.map)
        print("-- saved", file=sys.stderr)
    elif not args.write:
        print("-- dry run, pass --write to save", file=sys.stderr)


if __name__ == "__main__":
    main()

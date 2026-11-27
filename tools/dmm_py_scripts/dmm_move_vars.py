"""
Move var edits off matching atoms onto a new atom (e.g. a marker) added to the same tile.
Dry run by default; pass --write to save.

For every atom matching --type / --where that has at least one of the --move vars:
    - those vars are removed from the atom (kept with --copy),
    - a new --new atom is added to the tile, right after the source atom, carrying them
      (optionally under another name, `--move SRC=DEST`), plus any --new-set vars.
An identical new atom already on the tile is not added twice.

The --new type must be placeable on a map (not an ABSTRACT_TYPE); the marker paths below
are example subtypes you would define in code.

Examples (run from repo root):
    # replace var-edited access on airlocks with an access marker carrying the same access
    python tools/dmm_py_scripts/dmm_move_vars.py maps/sccv_horizon/sccv_horizon.dmm \\
        --type /obj/structure/machinery/door/airlock \\
        --move req_access --move req_one_access \\
        --new /obj/effect/map_effect/marker/access/custom_var_edited \\
        --other /obj/structure/machinery/door/firedoor --other-action skip

    # only doors with one specific access value, to a code-defined marker subtype (no vars carried)
    python tools/dmm_py_scripts/dmm_move_vars.py some.dmm --type /obj/structure/machinery/door/airlock \\
        --where "req_one_access=list(19)" --move req_one_access --drop \\
        --new /obj/effect/map_effect/marker/access/security --write

--other TYPE (repeatable) reports tiles where other atoms of TYPE are present, since a
tile marker may affect them too; --other-action skip leaves those tiles untouched.
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
    ap.add_argument("--type", action="append", default=[], required=True, help="source type path, subtypes included; repeatable (OR)")
    ap.add_argument("--exact", action="store_true", help="--type matches the exact path only")
    ap.add_argument("--where", action="append", default=[], metavar="NAME[=VALUE]", help="only source atoms with this var (and value); AND")
    ap.add_argument("--move", action="append", default=[], required=True, metavar="SRC[=DEST]",
                    help="var to move; DEST renames it on the new atom; repeatable")
    ap.add_argument("--require-all", action="store_true", help="source atom must have all --move vars (default: any)")
    ap.add_argument("--copy", action="store_true", help="keep the vars on the source atom too")
    ap.add_argument("--drop", action="store_true", help="don't carry the vars to the new atom, just remove them (use with a code subtype)")
    ap.add_argument("--new", required=True, metavar="PATH", help="type path of the atom to add")
    ap.add_argument("--new-set", action="append", default=[], metavar="NAME=RAW", help="extra raw var on the new atom")
    ap.add_argument("--new-set-str", action="append", default=[], metavar="NAME=TEXT", help="extra string var on the new atom")
    ap.add_argument("--other", action="append", default=[], metavar="TYPE", help="flag tiles that also hold other atoms of TYPE")
    ap.add_argument("--other-action", choices=["warn", "skip"], default="warn", help="what to do with flagged tiles (default warn)")
    ap.add_argument("--write", action="store_true", help="save the map (otherwise dry run)")
    ap.add_argument("--show", type=int, default=10, help="print up to N example changes (default 10)")
    args = ap.parse_args()
    args.type = [du.type_arg(t) for t in args.type]
    args.other = [du.type_arg(t) for t in args.other]
    args.new = du.type_arg(args.new)
    if args.copy and args.drop:
        ap.error("--copy and --drop together would change nothing")

    moves = [(s, d or s) for s, _, d in (m.partition("=") for m in args.move)]
    extra = [s.split("=", 1) for s in args.new_set] + [[n, du.quote(v)] for n, v in (s.split("=", 1) for s in args.new_set_str)]
    m = du.load_map(args.map)
    coords = du.key_coords(m)
    stats = {"atoms": 0, "shown": 0, "skipped": 0, "warned": 0}

    def match(a):
        if not any((a.path == t) if args.exact else a.isa(t) for t in args.type):
            return False
        for spec in args.where:
            name, eq, value = spec.partition("=")
            if not a.has(name) or (eq and not du.value_matches(a.get(name), value)):
                return False
        present = [a.has(s) for s, _ in moves]
        return all(present) if args.require_all else any(present)

    def place(key):
        cs = sorted(coords[key])
        return f'"{du.key_name(m, key)}" x{len(cs)} ' + ", ".join(f"({x},{y},{z})" for x, y, z in cs[:3]) + (" ..." if len(cs) > 3 else "")

    def edit(key, atoms):
        sources = [a for a in atoms if match(a)]
        if not sources:
            return None
        others = [a for a in atoms if a not in sources and any(a.isa(t) for t in args.other)]
        if others:
            verb = "skipped" if args.other_action == "skip" else "warning"
            print(f"-- {verb}: {place(key)} also has " + ", ".join(a.render() for a in others), file=sys.stderr)
            if args.other_action == "skip":
                stats["skipped"] += 1
                return None
            stats["warned"] += 1
        if len(sources) > 1:
            print(f"-- warning: {place(key)} has {len(sources)} source atoms; each new atom may affect all of them", file=sys.stderr)

        out = []
        existing = {a.render() for a in atoms}
        for a in atoms:
            if a not in sources:
                out.append(a)
                continue
            new = du.Atom(args.new)
            if not args.drop:
                for s, d in moves:
                    if a.has(s):
                        new.set(d, a.get(s))
            for n, v in extra:
                new.set(n, v)
            b = a.copy()
            if not args.copy:
                b.remove(*(s for s, _ in moves))
            out.append(b)
            if new.render() not in existing:
                existing.add(new.render())
                out.append(new)
            stats["atoms"] += 1
            if stats["shown"] < args.show:
                stats["shown"] += 1
                print(f"{place(key)}\n    {a.render()}\n    -> {b.render()}\n    +  {new.render()}")
        return out

    n = du.edit_tiles(m, edit)
    print(f"-- {stats['atoms']} atoms changed in {n} tile definitions"
          f" ({stats['warned']} flagged by --other, {stats['skipped']} skipped)", file=sys.stderr)
    if args.write and n:
        du.save_map(m, args.map)
        print("-- saved", file=sys.stderr)
    elif not args.write:
        print("-- dry run, pass --write to save", file=sys.stderr)


if __name__ == "__main__":
    main()

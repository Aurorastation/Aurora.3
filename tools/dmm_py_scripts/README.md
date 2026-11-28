# DMM Python Scripts

Small Python tools for searching and bulk-editing `.dmm` maps from the command line,
without opening the map in an editor or reading the (often huge) map file by hand.

They build on [`tools/mapmerge2/dmm.py`](../mapmerge2/dmm.py) for loading and saving,
so saved maps are TGM-formatted the same way mapmerge writes them, and an unchanged map
round-trips byte-for-byte.

## Setup

Needs Python 3 and `bidict` (from [`tools/requirements.txt`](../requirements.txt)):

```sh
python -m pip install -r tools/requirements.txt
```

Run scripts from the repo root; map paths can be absolute or relative to the repo root.
Every script has `--help` with examples.

## Scripts

| Script | What it does |
| --- | --- |
| [`dmm_utils.py`](dmm_utils.py) | Library used by the others and meant for one-off scripts: lossless atom parser (`Atom.parse` / `render`, keeps var order and string escapes), `isa()` for type paths, tile helpers (`iter_tiles`, `tile_area`, `key_coords`, `insert_before_turf`), and safe editing (`replace_tile` / `edit_tiles` merge tile definitions that become identical). |
| [`dmm_find.py`](dmm_find.py) | Search a map for atoms by type (with subtypes), edited var / var value, any var equal to a value, or area. Prints the tile key, area, coordinates and atom, or counts with `--group-by VAR` / `type` / `area`. |
| [`dmm_edit_vars.py`](dmm_edit_vars.py) | Bulk-edit matching atoms: remove vars, set vars (raw or as strings), or change the type path. Dry run unless `--write`. |
| [`dmm_move_vars.py`](dmm_move_vars.py) | Move var edits off matching atoms onto a new atom added to the same tile (e.g. var-edited `req_access` on doors -> an access marker), optionally renaming the vars or dropping them for a code subtype. `--other TYPE` warns about / skips tiles where the new atom could also affect other atoms. Dry run unless `--write`. |
| [`area_names.py`](area_names.py) | Resolve area types to their in-game `name` from the code (with inheritance), and find area types sharing a name. Useful when something keys off `get_area()` names, like the default tags of the button control map markers. |

## Examples

```sh
# everything that uses the string "medicalisolation" in any var
python tools/dmm_py_scripts/dmm_find.py maps/sccv_horizon/sccv_horizon.dmm --value medicalisolation

# count airlock buttons per specialfunctions value
python tools/dmm_py_scripts/dmm_find.py maps/sccv_horizon/sccv_horizon.dmm --type /obj/structure/machinery/button/remote/airlock --group-by specialfunctions

# remove `dir = 8` from scrubber pipes (dry run first, then --write)
python tools/dmm_py_scripts/dmm_edit_vars.py maps/sccv_horizon/sccv_horizon.dmm --type /obj/structure/machinery/atmospherics/pipe/simple/hidden/scrubbers --where dir=8 --remove dir

# move var-edited access off airlocks onto access markers, skipping tiles that also have a firedoor
python tools/dmm_py_scripts/dmm_move_vars.py maps/sccv_horizon/sccv_horizon.dmm --type /obj/structure/machinery/door/airlock --move req_access --move req_one_access --new /obj/effect/map_effect/marker/access/some_subtype --other /obj/structure/machinery/door/firedoor --other-action skip
```

Writing your own one-off script:

```python
import sys
sys.path.insert(0, "tools/dmm_py_scripts")
import dmm_utils as du

m = du.load_map("maps/sccv_horizon/sccv_horizon.dmm")

def edit(key, atoms):
    if not any(a.isa("/obj/structure/machinery/door/blast/shutters") for a in atoms):
        return None  # leave the tile alone
    return du.insert_before_turf(atoms, [du.Atom("/obj/effect/some_marker", [["name", du.quote("Foo")]])])

print(du.edit_tiles(m, edit), "tiles edited")
du.save_map(m, "maps/sccv_horizon/sccv_horizon.dmm")
```

## Notes

- Var values are raw map text: strings keep their quotes (`"foo"`), numbers, paths and lists are
  plain text. CLI value filters match either form, so `--where id=foo` and `--where 'id="foo"'` both work.
  Use `du.quote()` / `du.unquote()` when converting in your own scripts.
- Only var edits written in the map are seen, not the type's default values from code.
- Tile definitions ("keys") are shared by every tile placed with them, so an edit applies to all of
  those tiles. `key_coords()` tells you where a key is placed.
- Git Bash rewrites arguments like `/obj/foo` into `C:/Program Files/Git/obj/foo`. The scripts undo
  that for type and area arguments, but your own scripts should use `du.type_arg()` on such arguments,
  or set `MSYS_NO_PATHCONV=1`.

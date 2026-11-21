"""
Helpers for scripted reading/editing of .dmm maps.

Builds on tools/mapmerge2/dmm.py for loading/saving (so output is TGM and
identical to what mapmerge produces), and adds a lossless atom parser plus
convenience functions for searching and editing tiles.

Terminology (same as mapmerge2):
    - key:   integer id of a tile definition in the map dictionary ("aab" in the file)
    - tile:  tuple of atom strings for one key, e.g. ('/obj/foo{dir = 8}', '/turf/x', '/area/y')
    - atom:  one entry of a tile; parsed with Atom.parse() into a path and ordered vars

Values of vars are kept RAW, exactly as written in the map: strings keep their
quotes and escapes (`"\\improper Foo"`), numbers/paths/lists are plain text.

Typical use:
    import dmm_utils as du
    m = du.load_map("maps/sccv_horizon/sccv_horizon.dmm")
    for key, atoms in du.iter_tiles(m):
        ...
    du.save_map(m, path)
"""

import os
import re
import sys
import collections

_TOOLS_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _TOOLS_DIR not in sys.path:
    sys.path.insert(0, _TOOLS_DIR)

from mapmerge2 import dmm as _mm  # noqa: E402 (needs `bidict`, see tools/requirements.txt)

REPO_DIR = os.path.dirname(_TOOLS_DIR)


# ------------------------------------------------------------------ atoms

class Atom:
    """One atom of a tile: a type path plus ordered var edits (raw values)."""

    __slots__ = ("path", "vars")

    def __init__(self, path, vars=None):
        self.path = path
        self.vars = list(vars or [])  # list of [name, raw_value]

    @staticmethod
    def parse(atom):
        i = atom.find("{")
        if i == -1:
            return Atom(atom)
        path, body = atom[:i], atom[i + 1:]
        assert body.endswith("}"), atom
        body = body[:-1]
        parts, cur, in_str, esc = [], "", False, False
        for ch in body:
            if esc:
                esc = False
            elif ch == "\\":
                esc = True
            elif ch == '"':
                in_str = not in_str
            elif ch == ";" and not in_str:
                parts.append(cur)
                cur = ""
                continue
            cur += ch
        if cur.strip():
            parts.append(cur)
        vars = []
        for p in parts:
            name, _, value = p.partition("=")
            vars.append([name.strip(), value.strip()])
        return Atom(path, vars)

    def render(self):
        """Back to mapmerge2's internal atom string."""
        if not self.vars:
            return self.path
        return self.path + "{" + ";".join(f"{n} = {v}" for n, v in self.vars) + "}"

    def get(self, name, default=None):
        for n, v in self.vars:
            if n == name:
                return v
        return default

    def has(self, name):
        return any(n == name for n, _ in self.vars)

    def set(self, name, value):
        for pair in self.vars:
            if pair[0] == name:
                pair[1] = value
                return
        self.vars.append([name, value])

    def remove(self, *names):
        self.vars = [p for p in self.vars if p[0] not in names]

    def isa(self, base):
        return isa(self.path, base)

    def copy(self):
        return Atom(self.path, [list(p) for p in self.vars])

    def __repr__(self):
        return f"Atom({self.render()!r})"


def isa(path, base):
    """istype() for paths: `path` is `base` or one of its subtypes."""
    return path == base or path.startswith(base + "/")


_MSYS_RE = re.compile(r"^[A-Za-z]:[/\\].*?(/(?:area|turf|obj|mob|datum|atom)(?:/.*)?)$")


def type_arg(path):
    """
    Undo Git Bash (MSYS) path conversion of CLI args: `/obj/foo` arrives as
    `C:/Program Files/Git/obj/foo`. Use on every type path taken from argv.
    """
    m = _MSYS_RE.match(path)
    return m.group(1) if m else path


def quote(text):
    """Turn python text into a raw DM string value: quote('a"b') -> '"a\\"b"'."""
    return '"' + text.replace("\\", "\\\\").replace('"', '\\"') + '"'


def unquote(raw):
    """Inverse of quote() for string values; returns None for non-strings."""
    if len(raw) < 2 or raw[0] != '"' or raw[-1] != '"':
        return None
    out, esc = "", False
    for ch in raw[1:-1]:
        if esc:
            out += ch
            esc = False
        elif ch == "\\":
            esc = True
        else:
            out += ch
    return out


def value_matches(raw, wanted):
    """Match a raw var value against user input: exact raw, or the input as a quoted string."""
    return raw == wanted or unquote(raw) == wanted


# ------------------------------------------------------------------ map io

def resolve_path(path):
    """Accept absolute paths or paths relative to the repo root."""
    if os.path.isabs(path) or os.path.exists(path):
        return path
    return os.path.join(REPO_DIR, path)


def load_map(path):
    return _mm.DMM.from_file(resolve_path(path))


def save_map(dmm, path):
    dmm.to_file(resolve_path(path), tgm=True)


def key_name(dmm, key):
    """Integer key -> the key text used in the file (e.g. 'aab')."""
    return _mm.num_to_key(key, dmm.key_length)


def key_num(dmm, name):
    return _mm.key_to_num(name)


# ------------------------------------------------------------------ tiles

def parse_tile(tile):
    return [Atom.parse(a) for a in tile]


def render_tile(atoms):
    return tuple(a.render() if isinstance(a, Atom) else a for a in atoms)


def tile_area(atoms):
    """Area path of a tile (parsed atoms or raw strings)."""
    for a in atoms:
        p = a.path if isinstance(a, Atom) else a
        if p.startswith("/area"):
            return p
    return None


def tile_turf(atoms):
    for a in atoms:
        p = a.path if isinstance(a, Atom) else a
        if p.startswith("/turf"):
            return p
    return None


def key_coords(dmm):
    """dict key -> list of (x, y, z) where it is placed. Unused keys are absent."""
    out = collections.defaultdict(list)
    for coord, key in dmm.grid.items():
        out[key].append(coord)
    return out


def used_keys(dmm):
    return set(dmm.grid.values())


def iter_tiles(dmm, used_only=True):
    """Yield (key, [Atom, ...]) for each tile definition."""
    keys = used_keys(dmm) if used_only else None
    for key, tile in sorted(dmm.dictionary.items()):
        if keys is None or key in keys:
            yield key, parse_tile(tile)


def insert_before_turf(atoms, new_atoms):
    """Insert atoms (objs/mobs) right before the turf, keeping map atom ordering valid."""
    idx = next((i for i, a in enumerate(atoms) if (a.path if isinstance(a, Atom) else a).startswith("/turf")), len(atoms))
    return list(atoms[:idx]) + list(new_atoms) + list(atoms[idx:])


def replace_tile(dmm, key, atoms):
    """
    Set the content of tile definition `key`. If the new content is identical to
    another existing key, all grid uses are repointed to that key and `key` is
    dropped (the dictionary is a bidict and can't hold duplicates).
    Returns the key now holding the content.
    """
    new_tile = render_tile(atoms)
    if dmm.dictionary.get(key) == new_tile:
        return key
    other = dmm.dictionary.inv.get(new_tile)
    if other is not None and other != key:
        for coord, k in dmm.grid.items():
            if k == key:
                dmm.grid[coord] = other
        del dmm.dictionary[key]
        return other
    dmm.dictionary[key] = new_tile
    return key


def edit_tiles(dmm, fn, used_only=True):
    """
    Call fn(key, atoms) for each tile; if it returns a new atom list, the tile is
    replaced. Returns the number of edited tile definitions.
    """
    changes = []
    for key, atoms in iter_tiles(dmm, used_only):
        new = fn(key, atoms)
        if new is not None and render_tile(new) != dmm.dictionary[key]:
            changes.append((key, new))
    for key, new in changes:
        replace_tile(dmm, key, new)
    return len(changes)

use crate::mapmanip::core::*;

use dmmtools::dmm::{Coord3, Prefab};

/// To be used by the `tools/bapi/autowire.ps1` script.
#[no_mangle]
pub unsafe extern "system" fn autowire_ffi(c_str: *const libc::c_char) {
    let c_str = unsafe { std::ffi::CStr::from_ptr(c_str) };
    let map_path = c_str.to_str().unwrap_or_default();
    autowire(map_path);
}

const CABLE_PATH: &str = "/obj/structure/cable";

const N: i32 = 1;
const S: i32 = 2;
const E: i32 = 4;
const W: i32 = 8;

/// Returns the base cable path (like `/obj/structure/cable/red`) if `path` is an autowire helper
/// (like `/obj/structure/cable/red/autowire`) of any color.
fn autowire_base(path: &str) -> Option<&str> {
    let base = path.strip_suffix("/autowire")?;
    let color = base.strip_prefix("/obj/structure/cable/")?;
    (!color.is_empty() && !color.contains('/')).then_some(base)
}

fn is_autowire(path: &str) -> bool {
    autowire_base(path).is_some()
}

fn is_cable(path: &str) -> bool {
    path == CABLE_PATH || path.starts_with("/obj/structure/cable/")
}

/// Color of a cable, as the color segment of its path (`/obj/structure/cable/<color>/...`).
/// The base `/obj/structure/cable` type is red by default.
fn cable_color(path: &str) -> &str {
    match path.strip_prefix("/obj/structure/cable/") {
        Some(rest) => rest.split('/').next().unwrap_or("red"),
        None => "red",
    }
}

fn dir_from_name(name: &str) -> Option<i32> {
    match name {
        "north" => Some(1),
        "south" => Some(2),
        "east" => Some(4),
        "west" => Some(8),
        "northeast" => Some(5),
        "southeast" => Some(6),
        "northwest" => Some(9),
        "southwest" => Some(10),
        _ => None,
    }
}

fn parse_icon_state(icon_state: &str) -> Option<(i32, i32)> {
    let (d1, d2) = icon_state.split_once('-')?;
    Some((d1.trim().parse().ok()?, d2.trim().parse().ok()?))
}

/// Derives `(d1, d2)` from the path of the predefined cable subtypes
/// in `code/modules/power/cable_subtypes.dm`, like `/obj/structure/cable/red/corner/north_east`.
fn dirs_from_path(path: &str) -> Option<(i32, i32)> {
    let rest = path.strip_prefix("/obj/structure/cable/")?;
    let segments: Vec<&str> = rest.split('/').collect();
    // segments: [color, kind, name]
    if segments.len() != 3 {
        return None;
    }
    let (kind, name) = (segments[1], segments[2]);
    match kind {
        "knot" => Some((0, dir_from_name(name)?)),
        "down" => Some((11, dir_from_name(name)?)),
        "up" if name == "knot" => Some((12, 0)),
        "straight" | "corner" | "bend" => {
            let (a, b) = name.split_once('_')?;
            Some((dir_from_name(a)?, dir_from_name(b)?))
        }
        _ => None,
    }
}

/// Returns `(d1, d2)` of an actual (non-autowire) cable prefab, mirroring `/obj/structure/cable/New()`,
/// where `icon_state` is what decides the directions.
fn cable_dirs(prefab: &Prefab) -> (i32, i32) {
    if let Some(icon_state) = prefab.vars.get("icon_state").and_then(|c| c.as_str()) {
        if let Some(dirs) = parse_icon_state(icon_state) {
            return dirs;
        }
    }
    // base type and plain color subtypes default to "0-1"
    dirs_from_path(&prefab.path).unwrap_or((0, 1))
}

/// Whether the tile at `coord` has a cable of the given `color` that connects to a tile in direction `towards` from it,
/// or an autowire helper of that color (which connects to everything around it).
fn tile_connects_towards(umm: &GridMap, coord: Coord3, towards: i32, color: &str) -> bool {
    let Some(tile) = umm.grid.get(&coord) else {
        return false;
    };
    tile.prefabs.iter().any(|prefab| {
        if !is_cable(&prefab.path) || cable_color(&prefab.path) != color {
            false
        } else if is_autowire(&prefab.path) {
            true
        } else if is_cable(&prefab.path) {
            let (d1, d2) = cable_dirs(prefab);
            d1 == towards || d2 == towards
        } else {
            false
        }
    })
}

/// Path of a straight/corner cable subtype between two cardinal dirs.
fn segment_path(base: &str, a: i32, b: i32) -> String {
    let (a, b) = (a.min(b), a.max(b));
    let name = match (a, b) {
        (N, S) => "straight/north_south",
        (E, W) => "straight/east_west",
        (N, E) => "corner/north_east",
        (N, W) => "corner/north_west",
        (S, E) => "corner/south_east",
        (S, W) => "corner/south_west",
        _ => unreachable!("invalid cable segment {a}-{b}"),
    };
    format!("{base}/{name}")
}

fn knot_path(base: &str, d: i32) -> String {
    let name = match d {
        N => "north",
        S => "south",
        E => "east",
        W => "west",
        _ => unreachable!("invalid knot dir {d}"),
    };
    format!("{base}/knot/{name}")
}

/// Cable subtype paths that, placed together on one tile, connect exactly the given cardinal dirs.
/// Cables on the same tile connect to each other if they share a direction,
/// so junctions are built from segments that all share a common end. No knots are used for junctions,
/// as those would also connect to any machinery on the tile.
fn paths_for_connections(base: &str, mask: i32) -> Vec<String> {
    let has = |d: i32| mask & d != 0;
    let dirs: Vec<i32> = [N, S, E, W].into_iter().filter(|d| has(*d)).collect();
    match dirs.len() {
        0 => vec![],
        // dead end
        1 => vec![knot_path(base, dirs[0])],
        // straight or corner
        2 => vec![segment_path(base, dirs[0], dirs[1])],
        // t-junction: a straight through, plus a corner off one of its ends
        3 => {
            if has(N) && has(S) {
                let side = if has(E) { E } else { W };
                vec![segment_path(base, N, S), segment_path(base, N, side)]
            } else {
                let side = if has(N) { N } else { S };
                vec![segment_path(base, E, W), segment_path(base, side, E)]
            }
        }
        // 4-way: north-south, plus a corner off each end of it
        _ => vec![
            segment_path(base, N, S),
            segment_path(base, N, E),
            segment_path(base, S, W),
        ],
    }
}

pub fn autowire(map_path: &str) {
    let map_path: std::path::PathBuf = map_path.into();
    let mut umm = GridMap::from_file(&map_path).unwrap();

    // first pass: compute replacements based on the unmodified map
    let mut replacements: Vec<(Coord3, usize, Vec<String>)> = Vec::new();
    for (coord, tile) in umm.grid.iter() {
        for (index, prefab) in tile.prefabs.iter().enumerate() {
            let Some(base) = autowire_base(&prefab.path) else {
                continue;
            };

            // (neighbor offset, our dir towards it, its dir back towards us)
            let neighbors = [
                ((0, 1), N, S),
                ((0, -1), S, N),
                ((1, 0), E, W),
                ((-1, 0), W, E),
            ];
            let mut mask = 0;
            for ((dx, dy), dir, back) in neighbors {
                let neighbor = Coord3::new(coord.x + dx, coord.y + dy, coord.z);
                if tile_connects_towards(&umm, neighbor, back, cable_color(base)) {
                    mask |= dir;
                }
            }

            let paths = paths_for_connections(base, mask);
            if paths.is_empty() {
                println!(
                    "autowire at ({}, {}, {}) has nothing to connect to, leaving it as is",
                    coord.x, coord.y, coord.z
                );
                continue;
            }
            replacements.push((coord, index, paths));
        }
    }

    // second pass: apply replacements
    // within a tile, apply from the highest index down, so inserted prefabs do not shift pending indices
    replacements.sort_by_key(|(_, index, _)| std::cmp::Reverse(*index));
    for (coord, index, paths) in replacements {
        let tile = umm.grid.get_mut(&coord).unwrap();
        let mut template = tile.prefabs[index].clone();
        // directions come from the subtype path now
        template.vars.shift_remove("icon_state");
        template.vars.shift_remove("d1");
        template.vars.shift_remove("d2");

        let new_prefabs: Vec<Prefab> = paths
            .into_iter()
            .map(|path| {
                let mut prefab = template.clone();
                prefab.path = path;
                prefab
            })
            .collect();
        tile.prefabs.splice(index..=index, new_prefabs);
    }

    let umm = crate::mapmanip::core::to_dict_map(&umm).unwrap();
    let umm = crate::mapmanip::core::map_to_string(&umm).unwrap();
    std::fs::write(map_path, umm).unwrap();
}

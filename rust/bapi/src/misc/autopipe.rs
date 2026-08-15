use crate::mapmanip::core::*;

use dmmtools::dmm::{Coord3, Prefab};
use dreammaker::constants::Constant;
use itertools::Itertools;

/// To be used by the `tools/bapi/autopipe.ps1` script.
#[no_mangle]
pub unsafe extern "system" fn autopipe_ffi(c_str: *const libc::c_char) {
    let c_str = unsafe { std::ffi::CStr::from_ptr(c_str) };
    let map_path = c_str.to_str().unwrap_or_default();
    autopipe(map_path);
}

pub fn autopipe(map_path: &str) {
    let map_path: std::path::PathBuf = map_path.into();
    let mut umm = GridMap::from_file(&map_path).unwrap();

    let rows = umm.size.x;
    let cols = umm.size.y;
    let z_levels = umm.size.z;

    let autopipe_config: [(&str, &str, &str, &[&str]); 4] = [
        (
            "/obj/structure/machinery/atmospherics/pipe/simple/hidden/supply",
            "/obj/structure/machinery/atmospherics/pipe/manifold/hidden/supply",
            "/obj/structure/machinery/atmospherics/pipe/manifold4w/hidden/supply",
            &["/obj/structure/machinery/atmospherics/unary/vent_pump/on"],
        ),
        (
            "/obj/structure/machinery/atmospherics/pipe/simple/hidden/scrubbers",
            "/obj/structure/machinery/atmospherics/pipe/manifold/hidden/scrubbers",
            "/obj/structure/machinery/atmospherics/pipe/manifold4w/hidden/scrubbers",
            &["/obj/structure/machinery/atmospherics/unary/vent_scrubber/on"],
        ),
        (
            "/obj/structure/machinery/atmospherics/pipe/simple/hidden/aux",
            "/obj/structure/machinery/atmospherics/pipe/manifold/hidden/aux",
            "/obj/structure/machinery/atmospherics/pipe/manifold4w/hidden/aux",
            &[
                "/obj/structure/machinery/atmospherics/unary/vent_pump/high_volume/aux",
                "/obj/structure/machinery/atmospherics/portables_connector/aux",
            ],
        ),
        (
            "/obj/structure/machinery/atmospherics/pipe/simple/hidden/fuel",
            "/obj/structure/machinery/atmospherics/pipe/manifold/hidden/fuel",
            "/obj/structure/machinery/atmospherics/pipe/manifold4w/hidden/fuel",
            &[
                "/obj/structure/machinery/atmospherics/portables_connector/fuel",
                "/obj/structure/machinery/atmospherics/unary/engine",
                "/obj/structure/machinery/atmospherics/tank/carbon_dioxide",
            ],
        ),
    ];

    for z_level in 0..z_levels {
        for row in 0..rows {
            for col in 0..cols {
                if col == 0 || col == cols - 1 || row == 0 || row == rows - 1 {
                    continue;
                }
                let z_level = z_level + 1;
                let row = row + 1;
                let col = col + 1;

                for (pipe, mani3w, mani4w, other) in autopipe_config {
                    let atoms_n = umm
                        .grid
                        .get(&Coord3::new(row, col + 1, z_level))
                        .unwrap()
                        .prefabs
                        .clone();
                    let atoms_s = umm
                        .grid
                        .get(&Coord3::new(row, col - 1, z_level))
                        .unwrap()
                        .prefabs
                        .clone();
                    let atoms_e = umm
                        .grid
                        .get(&Coord3::new(row + 1, col, z_level))
                        .unwrap()
                        .prefabs
                        .clone();
                    let atoms_w = umm
                        .grid
                        .get(&Coord3::new(row - 1, col, z_level))
                        .unwrap()
                        .prefabs
                        .clone();

                    let any_eq_p = |l: &[&str], e: &str| l.iter().any(|t| *t == e);

                    let get_gipe_from_atoms = |atoms: &Vec<Prefab>| {
                        atoms
                            .iter()
                            .find_or_first(|a| {
                                a.path == pipe
                                    || a.path == mani3w
                                    || a.path == mani4w
                                    || any_eq_p(&other, &a.path)
                            })
                            .map(|a| {
                                (
                                    a.path.clone(),
                                    a.vars
                                        .get("dir")
                                        .unwrap_or(&Constant::Float(2f32))
                                        .to_int()
                                        .unwrap_or(2),
                                )
                            })
                            .unwrap()
                    };

                    let any_eq = |l: &[i32], e: i32| l.iter().any(|t| *t == e);

                    let (n_path, n_dir) = get_gipe_from_atoms(&atoms_n);
                    let (s_path, s_dir) = get_gipe_from_atoms(&atoms_s);
                    let (e_path, e_dir) = get_gipe_from_atoms(&atoms_e);
                    let (w_path, w_dir) = get_gipe_from_atoms(&atoms_w);

                    let connects_to_n: bool = {
                        if n_path == mani4w {
                            true
                        } else if n_path == pipe && any_eq(&[1, 2, 10, 6], n_dir) {
                            true
                        } else if n_path == mani3w && any_eq(&[1, 4, 8], n_dir) {
                            true
                        } else if any_eq_p(&other, &n_path) && any_eq(&[2], n_dir) {
                            true
                        } else {
                            false
                        }
                    };
                    let connects_to_s = {
                        if s_path == mani4w {
                            true
                        } else if s_path == pipe && any_eq(&[1, 2, 5, 9], s_dir) {
                            true
                        } else if s_path == mani3w && any_eq(&[2, 4, 8], s_dir) {
                            true
                        } else if any_eq_p(&other, &s_path) && any_eq(&[1], s_dir) {
                            true
                        } else {
                            false
                        }
                    };
                    let connects_to_e = {
                        if e_path == mani4w {
                            true
                        } else if e_path == pipe && any_eq(&[4, 8, 10, 9], e_dir) {
                            true
                        } else if e_path == mani3w && any_eq(&[1, 2, 4], e_dir) {
                            true
                        } else if any_eq_p(&other, &e_path) && any_eq(&[8], e_dir) {
                            true
                        } else {
                            false
                        }
                    };
                    let connects_to_w = {
                        if w_path == mani4w {
                            true
                        } else if w_path == pipe && any_eq(&[4, 8, 5, 6], w_dir) {
                            true
                        } else if w_path == mani3w && any_eq(&[1, 2, 8], w_dir) {
                            true
                        } else if any_eq_p(&other, &w_path) && any_eq(&[4], w_dir) {
                            true
                        } else {
                            false
                        }
                    };

                    let prototypes = umm.grid.get_mut(&Coord3::new(row, col, z_level)).unwrap();

                    for atom in prototypes.prefabs.iter_mut() {
                        if atom.path == mani4w {
                            // mani4w
                            if connects_to_n && connects_to_s && connects_to_e && connects_to_w {
                                continue;
                            }

                            // pipe straight
                            if connects_to_n && connects_to_s && !connects_to_e && !connects_to_w {
                                atom.path = pipe.to_string();
                                atom.vars.insert("dir".to_string(), Constant::Float(2f32));
                                continue;
                            }
                            if !connects_to_n && !connects_to_s && connects_to_e && connects_to_w {
                                atom.path = pipe.to_string();
                                atom.vars.insert("dir".to_string(), Constant::Float(4f32));
                                continue;
                            }

                            // pipe end
                            if (connects_to_n ^ connects_to_s) && !connects_to_e && !connects_to_w {
                                atom.path = pipe.to_string();
                                atom.vars.insert("dir".to_string(), Constant::Float(2f32));
                                continue;
                            }
                            if !connects_to_n && !connects_to_s && (connects_to_e ^ connects_to_w) {
                                atom.path = pipe.to_string();
                                atom.vars.insert("dir".to_string(), Constant::Float(4f32));
                                continue;
                            }

                            // pipe turn
                            if connects_to_n && !connects_to_s && connects_to_e && !connects_to_w {
                                atom.path = pipe.to_string();
                                atom.vars.insert("dir".to_string(), Constant::Float(5f32));
                                continue;
                            }
                            if !connects_to_n && connects_to_s && !connects_to_e && connects_to_w {
                                atom.path = pipe.to_string();
                                atom.vars.insert("dir".to_string(), Constant::Float(10f32));
                                continue;
                            }
                            if connects_to_n && !connects_to_s && !connects_to_e && connects_to_w {
                                atom.path = pipe.to_string();
                                atom.vars.insert("dir".to_string(), Constant::Float(9f32));
                                continue;
                            }
                            if !connects_to_n && connects_to_s && connects_to_e && !connects_to_w {
                                atom.path = pipe.to_string();
                                atom.vars.insert("dir".to_string(), Constant::Float(6f32));
                                continue;
                            }

                            // mani3w
                            if !connects_to_n && connects_to_s && connects_to_e && connects_to_w {
                                atom.path = mani3w.to_string();
                                atom.vars.insert("dir".to_string(), Constant::Float(1f32));
                                continue;
                            }
                            if connects_to_n && !connects_to_s && connects_to_e && connects_to_w {
                                atom.path = mani3w.to_string();
                                atom.vars.insert("dir".to_string(), Constant::Float(2f32));
                                continue;
                            }
                            if connects_to_n && connects_to_s && !connects_to_e && connects_to_w {
                                atom.path = mani3w.to_string();
                                atom.vars.insert("dir".to_string(), Constant::Float(4f32));
                                continue;
                            }
                            if connects_to_n && connects_to_s && connects_to_e && !connects_to_w {
                                atom.path = mani3w.to_string();
                                atom.vars.insert("dir".to_string(), Constant::Float(8f32));
                                continue;
                            }
                        }
                    }
                }
            }
        }
    }

    let umm = crate::mapmanip::core::to_dict_map(&umm).unwrap();
    let umm = crate::mapmanip::core::map_to_string(&umm).unwrap();
    std::fs::write(map_path, umm).unwrap();
}

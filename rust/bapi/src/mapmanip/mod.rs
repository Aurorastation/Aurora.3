pub mod core;
pub mod tools;

pub use core::GridMap;
use rand::seq::SliceRandom;
use rand::thread_rng;
use serde::{Deserialize, Serialize};

#[cfg(test)]
mod test;

/// foobar
#[derive(Serialize, Deserialize)]
#[serde(tag = "type")]
pub enum MapManipulation {
    InsertExtract {
        submap_size_x: i32,
        submap_size_y: i32,
        submaps_dmm: String,
        marker_extract: String,
        marker_insert: String,
    },
}

pub fn mapmanip_config_parse(config_path: &std::path::Path) -> Vec<MapManipulation> {
    let config = std::fs::read_to_string(config_path).unwrap();
    let config: Vec<MapManipulation> = serde_json::from_str(&config).unwrap();
    config
}

pub fn mapmanip(map: dmmtools::dmm::Map, config: &Vec<MapManipulation>) -> dmmtools::dmm::Map {
    // convert to gridmap
    let mut map = core::to_grid_map(&map);

    // go through all the manipulations in `.jsonc` config for this `.dmm`
    for manipulation in config {
        match manipulation {
            MapManipulation::InsertExtract {
                submap_size_x,
                submap_size_y,
                submaps_dmm,
                marker_extract,
                marker_insert,
            } => {
                let submap_size = dmmtools::dmm::Coord2::new(*submap_size_x, *submap_size_y);

                // get the submaps map
                let submaps_dmm: std::path::PathBuf = submaps_dmm.try_into().unwrap();
                let submaps_map = GridMap::from_file(&submaps_dmm).unwrap();

                // find all the extract markers
                let mut marker_extract_coords = vec![];
                for (coord, tile) in submaps_map.grid.iter() {
                    if tile.prefabs.iter().any(|p| p.path == *marker_extract) {
                        marker_extract_coords.push(*coord);
                    }
                }

                // find all the insert markers
                let mut marker_insert_coords = vec![];
                for (coord, tile) in submaps_map.grid.iter() {
                    if tile.prefabs.iter().any(|p| p.path == *marker_insert) {
                        marker_insert_coords.push(*coord);
                    }
                }

                // do all the extracts-inserts
                for insert_coord in marker_insert_coords {
                    let extract_coord = *marker_extract_coords
                        .choose(&mut rand::thread_rng())
                        .unwrap();
                    let extracted =
                        tools::extract_sub_map(&submaps_map, extract_coord, submap_size);

                    tools::insert_sub_map(&extracted, insert_coord, &mut map);
                }
            }
        }
    }

    core::to_dict_map(&map)
}

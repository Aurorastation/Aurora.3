pub mod core;
pub mod tools;

pub use core::GridMap;
use eyre::Context;
use rand::seq::SliceRandom;
use serde::{Deserialize, Serialize};

#[cfg(test)]
mod test;

/// foobar
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(tag = "type")]
pub enum MapManipulation {
    InsertExtract {
        submap_size_x: i64,
        submap_size_y: i64,
        submaps_dmm: String,
        marker_extract: String,
        marker_insert: String,
    },
}

pub fn mapmanip_config_parse(config_path: &std::path::Path) -> eyre::Result<Vec<MapManipulation>> {
    let config = std::fs::read_to_string(config_path)
        .wrap_err(format!("mapmanip config read err: {:?}", config_path))?;
    let config = serde_json::from_str::<Vec<MapManipulation>>(&config)
        .wrap_err(format!("mapmanip config json parse err: {:?}", config_path))?;
    Ok(config)
}

pub fn mapmanip(
    map_dir_path: &std::path::Path,
    map: dmmtools::dmm::Map,
    config: &Vec<MapManipulation>,
) -> eyre::Result<dmmtools::dmm::Map> {
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
                let submap_size = dmmtools::dmm::Coord2::new(
                    (*submap_size_x)
                        .try_into()
                        .wrap_err("invalid submap_size_x")?,
                    (*submap_size_y)
                        .try_into()
                        .wrap_err("invalid submap_size_y")?,
                );

                // get the submaps map
                let submaps_dmm: std::path::PathBuf = submaps_dmm.try_into().unwrap();
                let submaps_dmm = map_dir_path.join(submaps_dmm);
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
                for (coord, tile) in map.grid.iter() {
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

    Ok(core::to_dict_map(&map).wrap_err("failed on `to_dict_map`")?)
}

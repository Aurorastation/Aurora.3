pub mod core;
pub mod tools;

pub use core::GridMap;
use eyre::Context;
use eyre::ContextCompat;
use rand::prelude::IteratorRandom;
use serde::{Deserialize, Serialize};

#[cfg(test)]
mod test;

///
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(tag = "type")]
pub enum MapManipulation {
    SubmapExtractInsert {
        submap_size_x: i64,
        submap_size_y: i64,
        submap_size_z: i64,
        submaps_dmm: String,
        marker_extract: String,
        marker_insert: String,
        submaps_can_repeat: bool,
    },
}

pub fn mapmanip_config_parse(config_path: &std::path::Path) -> eyre::Result<Vec<MapManipulation>> {
    // read
    let config = std::fs::read_to_string(config_path)
        .wrap_err(format!("mapmanip config read err: {config_path:?}"))?;

    // strip comments
    // as the jsonc format is "json with comments"
    // but serde_json lib can only handle actual json
    let re = regex::Regex::new(r"\/\/.*")?;
    let config = re.replace_all(&config, "");

    // parse
    let config = serde_json::from_str::<Vec<MapManipulation>>(&config)
        .wrap_err(format!("mapmanip config json parse err: {config_path:?}"))?;

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
    for (n, manipulation) in config.iter().enumerate() {
        // readable index for errors
        let n = n + 1;
        let config_len = config.len();

        match manipulation {
            MapManipulation::SubmapExtractInsert {
                submap_size_x,
                submap_size_y,
                submap_size_z,
                submaps_dmm,
                marker_extract,
                marker_insert,
                submaps_can_repeat,
            } => mapmanip_submap_extract_insert(
                map_dir_path,
                &mut map,
                *submap_size_x,
                *submap_size_y,
                *submap_size_z,
                submaps_dmm,
                marker_extract,
                marker_insert,
                *submaps_can_repeat,
            )
            .wrap_err(format!(
                "submap extract insert fail;
					submaps path: {submaps_dmm:?};
					markers: {marker_extract}, {marker_insert};"
            )),
        }
        .wrap_err(format!("mapmanip fail; manip n is: {n}/{config_len}"))?;
    }

    Ok(core::to_dict_map(&map).wrap_err("failed on `to_dict_map`")?)
}

fn mapmanip_submap_extract_insert(
    map_dir_path: &std::path::Path,
    map: &mut GridMap,
    submap_size_x: i64,
    submap_size_y: i64,
    submap_size_z: i64,
    submaps_dmm: &String,
    marker_extract: &String,
    marker_insert: &String,
    submaps_can_repeat: bool,
) -> eyre::Result<()> {
    let submap_size = dmmtools::dmm::Coord3::new(
        submap_size_x.try_into().wrap_err("invalid submap_size_x")?,
        submap_size_y.try_into().wrap_err("invalid submap_size_y")?,
        submap_size_z.try_into().wrap_err("invalid submap_size_z")?,
    );

    // get the submaps map
    let submaps_dmm: std::path::PathBuf = submaps_dmm.try_into().wrap_err("invalid path")?;
    let submaps_dmm = map_dir_path.join(submaps_dmm);
    let submaps_map = GridMap::from_file(&submaps_dmm)
        .wrap_err(format!("can't read and parse submap dmm: {submaps_dmm:?}"))?;

    // find all the submap extract markers
    let mut marker_extract_coords = vec![];
    for (coord, tile) in submaps_map.grid.iter() {
        if tile.prefabs.iter().any(|p| p.path == *marker_extract) {
            marker_extract_coords.push(coord);
        }
    }

    // find all the insert markers
    let mut marker_insert_coords = vec![];
    for (coord, tile) in map.grid.iter() {
        if tile.prefabs.iter().any(|p| p.path == *marker_insert) {
            marker_insert_coords.push(coord);
        }
    }

    // do all the extracts-inserts
    for insert_coord in marker_insert_coords {
        // pick a submap
        let (extract_coord_index, extract_coord) = marker_extract_coords
            .iter()
            .cloned()
            .enumerate()
            .choose(&mut rand::thread_rng())
            .wrap_err(format!(
                "can't pick a submap to extract; no more extract markers in the submaps dmm; marker type: {marker_extract}"
            ))?;

        // if submaps should not be repeating, remove this one from the list
        if !submaps_can_repeat {
            marker_extract_coords.remove(extract_coord_index);
        }

        // extract that submap from the submap dmm
        let extracted = tools::extract_submap(&submaps_map, extract_coord, submap_size)
            .wrap_err(format!("submap extraction failed; from {extract_coord}"))?;

        // and insert the submap into the manipulated map
        tools::insert_submap(&extracted, insert_coord, map)
            .wrap_err(format!("submap insertion failed; at {insert_coord}"))?;
    }

    Ok(())
}

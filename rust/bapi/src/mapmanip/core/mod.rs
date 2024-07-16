pub mod to_dict_map;
pub use to_dict_map::to_dict_map;
pub mod to_grid_map;
pub use to_grid_map::to_grid_map;

pub mod map_to_string;
pub use map_to_string::map_to_string;

use dmmtools::dmm;

///
#[derive(Clone, Debug)]
pub struct Tile {
    ///
    pub key_suggestion: dmm::Key,
    ///
    pub prefabs: Vec<dmm::Prefab>,
}

impl Tile {
    ///
    pub fn get_area(&self) -> Option<&dmm::Prefab> {
        self.prefabs
            .iter()
            .find(|prefab| prefab.path.starts_with("/area/"))
    }

    ///
    pub fn remove_area(&mut self) -> Option<dmm::Prefab> {
        let area = self.get_area().cloned();
        if area.is_some() {
            self.prefabs
                .retain(|prefab| !prefab.path.starts_with("/area/"))
        }
        area
    }

    ///
    pub fn get_turf(&self) -> Option<&dmm::Prefab> {
        self.prefabs
            .iter()
            .find(|prefab| prefab.path.starts_with("/turf/"))
    }

    ///
    pub fn remove_turf(&mut self) -> Option<dmm::Prefab> {
        let turf = self.get_turf().cloned();
        if turf.is_some() {
            self.prefabs
                .retain(|prefab| !prefab.path.starts_with("/turf/"))
        }
        turf
    }
}

/// This is analogous to `dmmtools::dmm::Map`, but instead of being structured like dmm maps are,
/// where they have a dictionary of keys-to-prefabs and a separate grid of keys,
/// this is only a direct coord-to-prefab grid.
/// It is not memory efficient, but it allows for much greater flexibility of manipulation.
#[derive(Clone, Debug)]
pub struct GridMap {
    ///
    pub size: dmm::Coord3,
    ///
    pub grid: std::collections::BTreeMap<dmm::Coord2, crate::mapmanip::core::Tile>,
}

impl GridMap {
    pub fn from_file(path: &std::path::Path) -> Option<GridMap> {
        Some(to_grid_map(&dmm::Map::from_file(&path).ok()?))
    }
}

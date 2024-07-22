pub mod to_dict_map;
pub use to_dict_map::to_dict_map;
pub mod to_grid_map;
pub use to_grid_map::to_grid_map;

pub mod map_to_string;
pub use map_to_string::map_to_string;

use dmmtools::dmm;
use dmmtools::dmm::Coord2;

///
#[derive(Clone, Debug, Default)]
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

/// Thin abstraction over `grid::Grid`, to provide a hashmap-like interface,
/// and to translate between dmm coords (start at 1) and grid coords (start at 0).
/// The translation is so that it looks better in logs/errors/etc,
/// where shown coords would correspond to coords seen in game or in strongdmm.
#[derive(Clone, Debug)]
pub struct TileGrid {
    pub grid: grid::Grid<crate::mapmanip::core::Tile>,
}

impl TileGrid {
    pub fn new(size_x: i32, size_y: i32) -> TileGrid {
        Self {
            grid: grid::Grid::new(size_x as usize, size_y as usize),
        }
    }

    pub fn len(&self) -> usize {
        self.grid.size().0 * self.grid.size().1
    }

    pub fn iter(&self) -> impl Iterator<Item = (Coord2, &Tile)> {
        self.grid
            .indexed_iter()
            .map(|((x, y), t)| (Coord2::new((x + 1) as i32, (y + 1) as i32), t))
    }

    pub fn get_mut(&mut self, coord: &Coord2) -> Option<&mut Tile> {
        self.grid
            .get_mut((coord.x - 1) as usize, (coord.y - 1) as usize)
    }

    pub fn get(&self, coord: &Coord2) -> Option<&Tile> {
        self.grid
            .get((coord.x - 1) as usize, (coord.y - 1) as usize)
    }

    pub fn insert(&mut self, coord: &Coord2, tile: Tile) {
        *self.get_mut(coord).unwrap() = tile;
    }

    pub fn keys(&self) -> impl Iterator<Item = Coord2> + '_ {
        self.grid
            .indexed_iter()
            .map(|((x, y), _t)| Coord2::new((x + 1) as i32, (y + 1) as i32))
    }

    pub fn values(&self) -> impl Iterator<Item = &Tile> {
        self.grid.iter()
    }

    pub fn values_mut(&mut self) -> impl Iterator<Item = &mut Tile> {
        self.grid.iter_mut()
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
    pub grid: crate::mapmanip::core::TileGrid,
}

impl GridMap {
    pub fn from_file(path: &std::path::Path) -> Option<GridMap> {
        Some(to_grid_map(&dmm::Map::from_file(&path).ok()?))
    }
}

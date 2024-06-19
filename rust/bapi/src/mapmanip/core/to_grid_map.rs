use super::Tile;
use crate::mapmanip::core::GridMap;
use dmmtools::dmm::{self, Coord3};
use std::ops::Index;

fn tuple_to_size(xyz: (usize, usize, usize)) -> Coord3 {
    Coord3::new(xyz.0 as i32, xyz.1 as i32, xyz.2 as i32)
}

pub fn to_grid_map(dict_map: &dmm::Map) -> GridMap {
    let mut grid_map = GridMap {
        size: tuple_to_size(dict_map.dim_xyz()),
        grid: Default::default(),
    };

    for x in 1..grid_map.size.x + 1 {
        for y in 1..grid_map.size.y + 1 {
            let coord = dmm::Coord2::new(x, y);
            let key = dict_map.index(coord.z(1));
            let prefabs = dict_map.dictionary[key].clone();
            let tile = Tile {
                key_suggestion: *key,
                prefabs,
            };
            let coord = dmm::Coord2::new(coord.x, coord.y);
            grid_map.grid.insert(coord, tile);
        }
    }

    grid_map
}

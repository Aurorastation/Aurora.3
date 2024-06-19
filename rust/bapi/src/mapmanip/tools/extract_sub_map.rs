use crate::mapmanip::core::GridMap;
use dmmtools::dmm;
use dmmtools::dmm::Coord2;
use std::collections::BTreeMap;

/// Returns part of map of `xtr_size` and at `xtr_coord` from `src_map`.
pub fn extract_sub_map(
    src_map: &GridMap,
    xtr_coord: dmm::Coord2,
    xtr_size: dmm::Coord2,
) -> GridMap {
    let mut dst_map = GridMap {
        size: xtr_size.z(1),
        grid: BTreeMap::new(),
    };

    for x in 1..(xtr_size.x + 1) {
        for y in 1..(xtr_size.y + 1) {
            if let Some(tile) = src_map
                .grid
                .get(&Coord2::new(xtr_coord.x + x - 1, xtr_coord.y + y - 1))
            {
                dst_map.grid.insert(Coord2::new(x, y), tile.clone());
            }
        }
    }

    dst_map
}

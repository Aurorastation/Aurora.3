use crate::mapmanip::GridMap;
use dmmtools::dmm;
use dmmtools::dmm::Coord2;

/// Takes `xtr_map` and puts it at `coord` in `dst_map`.
pub fn insert_sub_map(xtr_map: &GridMap, coord: dmm::Coord2, dst_map: &mut GridMap) {
    for x in 1..(xtr_map.size.x + 1) {
        for y in 1..(xtr_map.size.y + 1) {
            let coord_src = Coord2::new(x, y);
            let coord_dst = Coord2::new(coord.x + x - 1, coord.y + y - 1);
            let tile_src = xtr_map.grid.get(&coord_src).unwrap().clone();
            if let Some(cell_dst) = dst_map.grid.get_mut(&coord_dst) {
                *cell_dst = tile_src;
            }
        }
    }
}

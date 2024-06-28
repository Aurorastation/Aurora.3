use crate::mapmanip::core::GridMap;
use dmmtools::dmm;
use dmmtools::dmm::Coord2;
use eyre::ContextCompat;
use std::collections::BTreeMap;

/// Returns part of map of `xtr_size` and at `xtr_coord` from `src_map`.
pub fn extract_submap(
    src_map: &GridMap,
    xtr_coord: dmm::Coord2,
    xtr_size: dmm::Coord2,
) -> eyre::Result<GridMap> {
    let mut dst_map = GridMap {
        size: xtr_size.z(1),
        grid: BTreeMap::new(),
    };

    for x in 1..(xtr_size.x + 1) {
        for y in 1..(xtr_size.y + 1) {
            let src_x = xtr_coord.x + x - 1;
            let src_y = xtr_coord.y + y - 1;

            let tile = src_map
                .grid
                .get(&Coord2::new(src_x, src_y))
                .wrap_err(format!(
                    "cannot extract submap; coords out of bounds; x: {src_x}; y: {src_y};"
                ))?;

            dst_map.grid.insert(Coord2::new(x, y), tile.clone());
        }
    }

    Ok(dst_map)
}

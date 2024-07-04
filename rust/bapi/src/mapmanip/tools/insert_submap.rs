use crate::mapmanip::GridMap;
use dmmtools::dmm;
use dmmtools::dmm::Coord2;
use eyre::ContextCompat;

/// Takes `src_map` and puts it at `coord` in `dst_map`.
/// Noop area and turf have special handling: `/area/template_noop` and `/turf/template_noop`.
/// If a `src` tile has noop area, then it uses the mapped in `dst` area instead of replacing it.
/// If a `src` tile has noop turf, then it uses the mapped in `dst` turf instead of replacing it,
/// and additionally also merges `src` objects and mobs with the `dst` mapped in ones.
pub fn insert_submap(
    src_map: &GridMap,
    coord: dmm::Coord2,
    dst_map: &mut GridMap,
) -> eyre::Result<()> {
    for x in 1..(src_map.size.x + 1) {
        for y in 1..(src_map.size.y + 1) {
            let coord_src = Coord2::new(x, y);
            let coord_dst = Coord2::new(coord.x + x - 1, coord.y + y - 1);

            // get src tile
            let mut tile_src = src_map
                .grid
                .get(&coord_src)
                .wrap_err(format!(
                    "src submap coord out of bounds: {coord_src}; {}; {}; {:?}",
                    src_map.size,
                    src_map.grid.len(),
                    src_map.grid.keys(),
                ))?
                .clone();

            // remove area and turf from src tile
            let tile_src_area = tile_src.remove_area().wrap_err("submap tile has no area")?;
            let tile_src_turf = tile_src.remove_turf().wrap_err("submap tile has no turf")?;

            let tile_src_area_is_noop = { tile_src_area.path == "/area/template_noop" };
            let tile_src_turf_is_noop = { tile_src_turf.path == "/turf/template_noop" };

            // get dst tile
            let tile_dst = dst_map.grid.get_mut(&coord_dst).wrap_err(format!(
                "cannot insert submap tile; coord out of bounds; x: {x}; y: {y};"
            ))?;

            // remove area and turf from dst tile
            let tile_dst_area = tile_dst.remove_area().wrap_err("map tile has no area")?;
            let tile_dst_turf = tile_dst.remove_turf().wrap_err("map tile has no turf")?;

            match (tile_src_area_is_noop, tile_src_turf_is_noop) {
                (true, true) => {
                    // both area and turf are noop
                    // append all atoms from src into dst
                    // use dst turf, and dst area
                    tile_dst.prefabs.append(&mut tile_src.prefabs);
                    tile_dst.prefabs.push(tile_dst_turf);
                    tile_dst.prefabs.push(tile_dst_area);
                }
                (true, false) => {
                    // src tile has noop area
                    // replace all dst atoms with src atoms
                    // use src turf, and dst area
                    tile_dst.prefabs = tile_src.prefabs;
                    tile_dst.prefabs.push(tile_src_turf);
                    tile_dst.prefabs.push(tile_dst_area);
                }
                (false, true) => {
                    // src tile has noop turf
                    // append all atoms from src into dst
                    // use dst turf, and src area
                    tile_dst.prefabs.append(&mut tile_src.prefabs);
                    tile_dst.prefabs.push(tile_dst_turf);
                    tile_dst.prefabs.push(tile_src_area);
                }
                (false, false) => {
                    // src tile has neither noop area nor turf
                    // the simplest case, just replace the whole dst tile with the src tile
                    // use src turf, and src area
                    tile_dst.prefabs = tile_src.prefabs;
                    tile_dst.prefabs.push(tile_src_turf);
                    tile_dst.prefabs.push(tile_src_area);
                    // do note that in dmm file format
                    // turf and area have to be the two last elements in a prefab
                }
            }
        }
    }

    Ok(())
}

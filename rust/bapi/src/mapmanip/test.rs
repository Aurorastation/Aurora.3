use dmmtools::dmm::{self, Coord2};
use itertools::Itertools;

fn print_diff(left: &str, right: &str) {
    for (i, diff) in diff::lines(&left, &right).iter().enumerate() {
        match diff {
            diff::Result::Left(l) => println!("{} diff - : {}", i, l),
            diff::Result::Both(l, r) => {
                assert_eq!(l, r);
            }
            diff::Result::Right(r) => println!("{} diff + : {}", i, r),
        }
    }
}

fn all_test_dmm() -> Vec<std::path::PathBuf> {
    std::fs::read_dir("D:/Git/dmm_parser_rs/test")
        .unwrap()
        .map(|r| r.unwrap().path())
        .filter(|p| p.extension().unwrap() == "dmm")
        .sorted()
        .collect_vec()
}

#[test]
fn grid_check() {
    let path = std::path::Path::new("D:/Git/dmm_parser_rs/test/_tiny_test_map.dmm");
    println!("path: {}", path.display());

    let grid_map = crate::core::GridMap::from_file(&path).unwrap();
    assert!(grid_map.grid[&dmm::Coord2::new(2, 1)]
        .prefabs
        .iter()
        .any(|p| p.path == "/obj/random/firstaid"));
    assert!(grid_map.grid[&dmm::Coord2::new(1, 2)]
        .prefabs
        .iter()
        .any(|p| p.path == "/obj/random/finances"));
    assert!(grid_map.grid[&dmm::Coord2::new(14, 15)]
        .prefabs
        .iter()
        .any(|p| p.path == "/obj/random/handgun"));
    assert!(grid_map.grid[&dmm::Coord2::new(15, 14)]
        .prefabs
        .iter()
        .any(|p| p.path == "/obj/random/handgun"));
}

#[test]
fn to_grid_and_back() {
    for path in all_test_dmm() {
        println!("path: {}", path.display());

        let dict_map_original = dmmtools::dmm::Map::from_file(&path).unwrap();
        let grid_map = crate::core::to_grid_map(&dict_map_original);
        let dict_map_again = crate::core::to_dict_map(&grid_map);
        let map_str_original = crate::core::map_to_string(&dict_map_original).unwrap();
        let map_str_from_grid = crate::core::map_to_string(&dict_map_again).unwrap();

        dict_map_again
            .to_file(
                &std::path::Path::new("D:/Git/dmm_parser_rs/test-out")
                    .join(path.file_name().unwrap()),
            )
            .unwrap();

        print_diff(&map_str_original, &map_str_from_grid);

        if map_str_original != map_str_from_grid {
            assert!(false);
        }
    }
}

#[test]
fn extract() {
    let path_src = std::path::Path::new("D:/Git/dmm_parser_rs/test/_tiny_test_map.dmm");
    let path_xtr = std::path::Path::new("D:/Git/dmm_parser_rs/test/extracted.dmm");
    let path_xtr_out = std::path::Path::new("D:/Git/dmm_parser_rs/test-out/extracted_out.dmm");

    let dict_map_src = dmmtools::dmm::Map::from_file(&path_src).unwrap();
    let dict_map_xtr_expected = dmmtools::dmm::Map::from_file(&path_xtr).unwrap();

    let grid_map_src = crate::core::to_grid_map(&dict_map_src);
    let grid_map_xtr =
        crate::tools::extract_sub_map(&grid_map_src, Coord2::new(4, 7), Coord2::new(10, 5));
    let grid_map_xtr_expected = crate::core::to_grid_map(&dict_map_xtr_expected);

    let dict_map_xtr = crate::core::to_dict_map(&grid_map_xtr);
    dict_map_xtr.to_file(path_xtr_out).unwrap();

    assert_eq!(
        grid_map_xtr_expected.grid.keys().collect::<Vec<_>>(),
        grid_map_xtr.grid.keys().collect::<Vec<_>>(),
    );

    for key in grid_map_xtr_expected.grid.keys() {
        let tile_xtr_expected = grid_map_xtr_expected.grid.get(key).unwrap();
        let tile_xtr = grid_map_xtr.grid.get(key).unwrap();
        assert_eq!(tile_xtr_expected.prefabs, tile_xtr.prefabs);
    }
}

#[test]
fn insert() {
    let path_xtr = std::path::Path::new("D:/Git/dmm_parser_rs/test/extracted.dmm");
    let path_dst = std::path::Path::new("D:/Git/dmm_parser_rs/test/_tiny_test_map.dmm");
    let path_dst_expected = std::path::Path::new("D:/Git/dmm_parser_rs/test/inserted.dmm");

    let grid_map_dst_expected = crate::core::GridMap::from_file(&path_dst_expected).unwrap();
    let grid_map_xtr = crate::core::GridMap::from_file(&path_xtr).unwrap();
    let mut grid_map_dst = crate::core::GridMap::from_file(&path_dst).unwrap();
    crate::tools::insert_sub_map(&grid_map_xtr, Coord2::new(6, 4), &mut grid_map_dst);

    assert_eq!(
        grid_map_dst_expected.grid.keys().collect::<Vec<_>>(),
        grid_map_dst.grid.keys().collect::<Vec<_>>(),
    );

    for key in grid_map_dst_expected.grid.keys() {
        let tile_dst_expected = grid_map_dst_expected.grid.get(key).unwrap();
        let tile_dst = grid_map_dst.grid.get(key).unwrap();
        assert_eq!(tile_dst_expected.prefabs, tile_dst.prefabs);
    }
}

#[test]
fn keys_deduplicated() {
    // make sure that if multiple tiles have the same key_suggestion
    // they get assigned different keys

    let path_src = std::path::Path::new("D:/Git/dmm_parser_rs/test/_tiny_test_map.dmm");
    let dict_map_src = dmmtools::dmm::Map::from_file(&path_src).unwrap();
    let grid_map_src = crate::core::to_grid_map(&dict_map_src);

    let mut grid_map_out = crate::core::to_grid_map(&dict_map_src);
    for tile in grid_map_out.grid.values_mut() {
        tile.key_suggestion = dmm::Key::default();
    }
    let dict_map_out = crate::core::to_dict_map(&grid_map_out);
    let grid_map_out = crate::core::to_grid_map(&dict_map_out);

    for key in grid_map_src.grid.keys() {
        let tile_src = grid_map_src.grid.get(key).unwrap();
        let tile_out = grid_map_out.grid.get(key).unwrap();
        assert_eq!(tile_src.prefabs, tile_out.prefabs);
    }

    assert_eq!(dict_map_src.dictionary.len(), dict_map_out.dictionary.len())
}

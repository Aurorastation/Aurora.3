use rand::Rng;

pub fn map_to_string(map: &dmmtools::dmm::Map) -> Option<String> {
    // let temp_dir_path = std::env::temp_dir();
    // let current_time = std::time::SystemTime::now()
    //     .duration_since(std::time::UNIX_EPOCH)
    //     .ok()?
    //     .as_millis();
    // let random_number = rand::thread_rng().gen_range(0..u128::MAX);
    // let file_path = temp_dir_path.join(format!("{}.{}.dmm", current_time, random_number));
    // map.to_file(&file_path).ok()?;
    // let map_str = std::fs::read_to_string(&file_path).ok()?;
    // let _ = std::fs::remove_file(file_path);
    // Some(map_str)
    let mut v = vec![];
    map.to_writer(&mut v).ok()?;
    let s = String::from_utf8(v).ok()?;
    Some(s)
}

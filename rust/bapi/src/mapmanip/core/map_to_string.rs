use rand::Rng;

// Converts map to string.
pub fn map_to_string(map: &dmmtools::dmm::Map) -> Option<String> {
    let mut v = vec![];
    map.to_writer(&mut v).ok()?;
    let s = String::from_utf8(v).ok()?;
    Some(s)
}

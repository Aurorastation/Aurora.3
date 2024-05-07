use byondapi::{byond_string, prelude::*};

// Panic handler that dumps info out to a text file (overwriting) if we crash.
fn setup_panic_handler() {
    std::panic::set_hook(Box::new(|info| {
        std::fs::write("./bapi_panic.txt", format!("Panic {:#?}", info)).unwrap();
    }))
}

#[byondapi::bind]
fn hello_world(_arg: ByondValue) {
    setup_panic_handler();
    Ok(ByondValue::new_str("Hello from byondapi!").unwrap())
}

pub fn map_to_string(map: &dmmtools::dmm::Map) -> Option<String> {
    let mut v = vec![];
    map.to_writer(&mut v).ok()?;
    let s = String::from_utf8(v).ok()?;
    Some(s)
}

#[byondapi::bind]
fn read_dmm_file(path: ByondValue) {
    setup_panic_handler();

    let path: String = path.get_string()?;

    if !path.ends_with(".dmm") {
        return Ok(ByondValue::null());
    }

    let path: std::path::PathBuf = path.try_into()?;

    let dmm = dmmtools::dmm::Map::from_file(&path).ok().unwrap();

    let str = map_to_string(&dmm).unwrap();

    Ok(ByondValue::new_str(str)?)
}

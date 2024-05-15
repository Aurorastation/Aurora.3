use byondapi::prelude::*;

/// Call stack trace dm method with message.
fn dm_call_stack_trace(msg: String) {
    let msg = byondapi::value::ByondValue::try_from(msg).unwrap();
    byondapi::global_call::call_global_id(
        {
            static STRING_ID: std::sync::OnceLock<u32> = std::sync::OnceLock::new();
            *STRING_ID.get_or_init(|| byondapi::byond_string::str_id_of("_stack_trace").unwrap())
        },
        &[msg],
    )
    .unwrap();
}

/// Panic handler, called on unhandled errors.
/// Writes panic info to a text file, and calls dm stack trace proc as well.
fn setup_panic_handler() {
    std::panic::set_hook(Box::new(|info| {
        let msg = format!("RUST BAPI PANIC \n {:#?}", info);
        let _ = std::fs::write("./bapi_panic.txt", msg.clone());
        crate::dm_call_stack_trace(msg);
    }))
}

/// Turns spacemandmm map object to string.
pub fn map_to_string(map: &dmmtools::dmm::Map) -> eyre::Result<String> {
    let mut v = vec![];
    map.to_writer(&mut v)?;
    let s = String::from_utf8(v)?;
    Ok(s)
}

///
#[no_mangle]
pub unsafe extern "C" fn read_dmm_file_ffi(
    argc: byondapi::sys::u4c,
    argv: *mut byondapi::value::ByondValue,
) -> byondapi::value::ByondValue {
    let args = unsafe { ::byondapi::parse_args(argc, argv) };
    match read_dmm_file(args.get(0).map(ByondValue::clone).unwrap_or_default()) {
        Ok(val) => val,
        Err(info) => {
            crate::dm_call_stack_trace(format!("RUST BAPI ERROR \n {:#?}", info));
            ByondValue::null()
        }
    }
}

///
fn read_dmm_file(path: ByondValue) -> eyre::Result<ByondValue> {
    setup_panic_handler();

    let path: String = path.get_string()?;
    let path: std::path::PathBuf = path.try_into()?;

    // some checks, just return null if path is bad for whatever reason
    if !path.is_file() || !path.exists() {
        return Ok(ByondValue::null());
    }

    // read file and parse with spacemandmm
    let dmm = dmmtools::dmm::Map::from_file(&path)?;

    // return the map converted to string
    let str = map_to_string(&dmm)?;
    Ok(ByondValue::new_str(str)?)
}

use byondapi::{byond_string, prelude::*};

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
/// Calls dm stack trace proc with panic info, and writes it out to a text file.
fn setup_panic_handler() {
    std::panic::set_hook(Box::new(|info| {
        let msg = format!("RUST BAPI PANIC \n {:#?}", info);
        crate::dm_call_stack_trace(msg.clone());
        std::fs::write("./bapi_panic.txt", msg).unwrap();
    }))
}

pub fn map_to_string(map: &dmmtools::dmm::Map) -> eyre::Result<String> {
    let mut v = vec![];
    map.to_writer(&mut v)?;
    let s = String::from_utf8(v)?;
    Ok(s)
}

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

fn read_dmm_file(path: ByondValue) -> eyre::Result<ByondValue> {
    setup_panic_handler();
    let path: String = path.get_string()?;
    // if !path.ends_with(".dmm") {
    //     return Ok(ByondValue::null());
    // }

    let path: std::path::PathBuf = path.try_into()?;
    let dmm = dmmtools::dmm::Map::from_file(&path)?;
    let str = map_to_string(&dmm)?;
    Ok(ByondValue::new_str(str)?)
}

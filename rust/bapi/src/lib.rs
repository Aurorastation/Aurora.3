use byondapi::{byond_string, prelude::*};
use std::fmt;

// Panic handler that dumps info out to a text file (overwriting) if we crash.
fn setup_panic_handler() {
    std::panic::set_hook(Box::new(|info| {
        std::fs::write("./bapi_panic.txt", format!("Panic {:#?}", info)).unwrap();
    }))
}

pub fn map_to_string(map: &dmmtools::dmm::Map) -> Option<String> {
    let mut v = vec![];
    map.to_writer(&mut v).ok()?;
    let s = String::from_utf8(v).ok()?;
    Some(s)
}

// #[byondapi::bind]
// fn read_dmm_file(path: ByondValue) {
// setup_panic_handler();

// let path: String = path.get_string()?;

// if !path.ends_with(".dmm") {
//     return Ok(ByondValue::null());
// }

// let path: std::path::PathBuf = path.try_into()?;

// let dmm = dmmtools::dmm::Map::from_file(&path).ok().unwrap();

// let str = map_to_string(&dmm).unwrap();

// Ok(ByondValue::new_str(str)?)
// }

#[no_mangle]
pub unsafe extern "C" fn read_dmm_file_ffi(
    __argc: ::byondapi::sys::u4c,
    __argv: *mut ::byondapi::value::ByondValue,
) -> ::byondapi::value::ByondValue {
    let args = unsafe { ::byondapi::parse_args(__argc, __argv) };
    match read_dmm_file(
        args.get(0usize)
            .map(::byondapi::value::ByondValue::clone)
            .unwrap_or_default(),
    ) {
        Ok(val) => val,
        Err(e) => {
            let error_string = ::byondapi::value::ByondValue::try_from({
                let res = fmt::format(format_args!("{:?}", e));
                res
            })
            .unwrap();
            ::byondapi::global_call::call_global_id(
                {
                    static STRING_ID: ::std::sync::OnceLock<u32> = ::std::sync::OnceLock::new();
                    *STRING_ID.get_or_init(|| {
                        ::byondapi::byond_string::str_id_of("_stack_trace").unwrap()
                    })
                },
                &[error_string],
            )
            .unwrap();
            ::byondapi::value::ByondValue::null()
        }
    }
}
fn read_dmm_file(path: ByondValue) -> ::eyre::Result<::byondapi::value::ByondValue> {
    setup_panic_handler();
    let path: String = path.get_string()?;
    // if !path.ends_with(".dmm") {
    //     return Ok(ByondValue::null());
    // }
    let path: std::path::PathBuf = path.try_into()?;
    let dmm = dmmtools::dmm::Map::from_file(&path)?;
    let str = map_to_string(&dmm).ok_or(byondapi::Error::UnknownByondError)?;
    Ok(ByondValue::new_str(str)?)
}

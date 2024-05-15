use byondapi::{byond_string, prelude::*};

/// Call stack trace dm method with message.
fn dm_call_stack_trace(msg: String) {
    let msg = byondapi::value::ByondValue::try_from(msg).unwrap();
    byondapi::global_call::call_global_id(
        {
            static STRING_ID: ::std::sync::OnceLock<u32> = ::std::sync::OnceLock::new();
            *STRING_ID.get_or_init(|| ::byondapi::byond_string::str_id_of("_stack_trace").unwrap())
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

pub fn map_to_string(map: &dmmtools::dmm::Map) -> Option<String> {
    let mut v = vec![];
    map.to_writer(&mut v).ok()?;
    let s = String::from_utf8(v).ok()?;
    Some(s)
}

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
                let res = std::fmt::format(format_args!("{:?}", e));
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

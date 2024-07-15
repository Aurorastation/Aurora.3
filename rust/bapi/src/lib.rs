// internal modules
mod mapmanip;

use byondapi::prelude::*;
use eyre::{Context, ContextCompat};

/// Call stack trace dm method with message.
pub(crate) fn dm_call_stack_trace(msg: String) {
    let msg = byondapi::value::ByondValue::try_from(msg).unwrap();
    // this is really ugly, cause we want to get id/ref to a proc name string
    // that is already allocated, and don't want to allocate a new string entirely
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

///
#[no_mangle]
pub unsafe extern "C" fn read_dmm_file_ffi(
    argc: byondapi::sys::u4c,
    argv: *mut byondapi::value::ByondValue,
) -> byondapi::value::ByondValue {
    setup_panic_handler();
    let args = unsafe { ::byondapi::parse_args(argc, argv) };
    match read_dmm_file(args.get(0).map(ByondValue::clone).unwrap_or_default()) {
        Ok(val) => val,
        Err(info) => {
            crate::dm_call_stack_trace(format!("RUST BAPI ERROR read_dmm_file_ffi() \n {info:#?}"));
            ByondValue::null()
        }
    }
}

///
fn read_dmm_file(path: ByondValue) -> eyre::Result<ByondValue> {
    setup_panic_handler();

    let path: String = path
        .get_string()
        .wrap_err(format!("path arg is not a string: {:?}", path))?;
    let path: std::path::PathBuf = path
        .clone()
        .try_into()
        .wrap_err(format!("path arg is not a valid file path: {}", path))?;

    // just return null if path is bad for whatever reason
    if !path.is_file() || !path.exists() {
        return Ok(ByondValue::null());
    }

    // read file and parse with spacemandmm
    let mut dmm = dmmtools::dmm::Map::from_file(&path).wrap_err(format!(
        "spacemandmm parsing error; dmm file path: {path:?}; see error from spacemandmm below for more information"
    ))?;

    // do mapmanip if defined for this dmm
    let path_mapmanip_config = {
        let mut p = path.clone();
        p.set_extension("jsonc");
        p
    };
    if path_mapmanip_config.exists() {
        // get path for dir of this dmm
        let path_dir = path.parent().wrap_err("no parent")?;
        // parse config
        let config = crate::mapmanip::mapmanip_config_parse(&path_mapmanip_config).wrap_err(
            format!("config parse fail; path: {:?}", path_mapmanip_config),
        )?;
        // do actual map manipulation
        dmm = crate::mapmanip::mapmanip(path_dir, dmm, &config)
            .wrap_err(format!("mapmanip fail; dmm file path: {path:?}"))?;
    }

    // convert the map back to a string
    let dmm = crate::mapmanip::core::map_to_string(&dmm).wrap_err(format!(
        "error in converting map back to string; dmm file path: {path:?}"
    ))?;

    // and return it
    Ok(ByondValue::new_str(dmm)?)
}

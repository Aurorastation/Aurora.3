use byondapi::global_call::call_global;
use byondapi::prelude::ByondValue;
use byondapi::threadsync::thread_sync;
use chrono::prelude::Utc;

/// Call stack trace dm method with message.
pub(crate) fn dm_call_stack_trace(msg: String) -> eyre::Result<()> {
    call_global("stack_trace", &[ByondValue::new_str(msg)?])?;

    Ok(())
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

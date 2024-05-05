use byondapi::{byond_string, prelude::*, Error};

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

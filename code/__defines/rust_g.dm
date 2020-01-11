// rust_g.dm - DM API for rust_g extension library
#define RUST_G "rust_g" 
#define WRITE_LOG(log, text) call(RUST_G, "log_write")(log, text) // Using Rust g dll to log faster with less CPU usage.
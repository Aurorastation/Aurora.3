# What is this

todo

# Other stuff

Command to compile bapi. The resulting `.dll` should be in `./rust/bapi/target/i686-pc-windows-msvc/release/...`.
The server should try to find and use the `.dll` in that location, otherwise use `./bapi.dll` in main dir.
Building either in release mode (with optimizations) or in debug (without, the default) is fine, but release `.dll` takes priority.
```
cargo build --target=i686-pc-windows-msvc
cargo build --release --target=i686-pc-windows-msvc
```


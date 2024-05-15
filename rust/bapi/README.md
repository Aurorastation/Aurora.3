# What is this

todo

# What is this `_ffi` stuff

FFI means "foreign function interface". Basically, different programming languages have very different features and mechanisms,
and if we want them to communicate, like here DM and Rust, in a way, we need to go to the lowest level possible, that being C,
as that is what basically every language can understand.

Rust functions callable from DM should end with `_ffi`, and have a very "raw" form, and do the least things possible to just call the actual Rust functions.

Rust functions that do actual things should not end with `_ffi`, and can be nice, idiomatic, Rust-like, and most importantly, safe.

# On safety

I recommend reading up on these topics related to Rust: safety, `unsafe {}`, error-handling, panics.

Safety related stuff:
- Generally, try to call stack trace dm proc on error or panic, so it fails tests and stops debugging (may need to turn on breakpoints on runtime errors).
- Panics (like `foo().unwrap();`) are caught with a panic handler that calls stack trace proc, and writes to a file.
  Panics are unrecoverable, so this is the best we can do in this case.
  Panics should not really happen though, except in a "fatal error and literally cannot proceed further" situation.
- Unhandled errors (like `foo()?;`) call stack trace proc and return null from the function.
- Some unsafety may be required, like to parse args in `_ffi` functions, but should not be present any where else.
  And if for whatever reason it is needed, it should be documented well.
- All rust code (generally, outside of `_ffi`) should be nice, safe, and idiomatic.

# Other stuff

Command to compile bapi. The resulting `.dll` should be in `./rust/bapi/target/i686-pc-windows-msvc/release/...`.
The server should try to find and use the `.dll` in that location, otherwise use `./bapi.dll` in main dir.
Building either in release mode (with optimizations) or in debug (without, the default) is fine, but release `.dll` takes priority.
```
cargo build --target=i686-pc-windows-msvc
cargo build --release --target=i686-pc-windows-msvc
```

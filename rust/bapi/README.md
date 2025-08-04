# What is this

todo

# On FFI

FFI means "foreign function interface". Basically, different languages can't easily "talk" to each other, as they have different features and mechanisms.
One exception is scripting languages (like Python or Lua), but that is neither DM nor Rust. 
If we do want them to "talk", we need to find some other language, one that is common and basic, that both DM and Rust can understand. And that is C.

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
  Errors should be propagated up, using the `eyre` library, with every function that may fail returning `eyre::Result<T>`.
- Some unsafety may be required, like to parse args in `_ffi` functions, but should not be present any where else.
  And if for whatever reason it is needed, it should be documented well.
- All rust code (generally, outside of `_ffi`) should be nice, safe, and idiomatic.

# Compiling and testing

Command to compile bapi. The resulting `.dll` should be in `./rust/bapi/target/i686-pc-windows-msvc/release/...`.
The server should try to find and use the `.dll` in that location, otherwise use `./bapi.dll` in main dir.
Building either in release mode (with optimizations) or in debug (without, the default) is fine, but release `.dll` takes priority.
```
cargo build --target=i686-pc-windows-msvc
cargo build --release --target=i686-pc-windows-msvc
```

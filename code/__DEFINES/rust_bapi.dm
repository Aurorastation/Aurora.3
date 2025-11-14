
// ------------------------------------------- .dll/.so detection

/// Global var set to bapi .dll/.so location.
/* This comment bypasses grep checks */ /var/__bapi

/// Look for .dll/.so in the build location first, then in `.`, then in standard places.
/proc/__detect_bapi()
	if(world.system_type == UNIX)
#ifdef CIBUILDING
		// CI override, use libbapi_ci.so if possible.
		if(fexists("./tools/ci/libbapi_ci.so"))
			return __bapi = "tools/ci/libbapi_ci.so"
#endif
		// First check if it's built in the usual place.
		if(fexists("./rust/bapi/target/i686-unknown-linux-gnu/release/libbapi.so"))
			return __bapi = "./rust/bapi/target/i686-unknown-linux-gnu/release/libbapi.so"
		// Then check in the current directory.
		if(fexists("./libbapi.so"))
			return __bapi = "./libbapi.so"
		// And elsewhere.
		return __bapi = "libbapi.so"
	else
		// First check if it's built in the usual place when working on it locally.
		if(fexists("./rust/bapi/target/i686-pc-windows-msvc/release/bapi.dll"))
			return __bapi = "./rust/bapi/target/i686-pc-windows-msvc/release/bapi.dll"
		// Also check the debug location if compiled without optimizations.
		if(fexists("./rust/bapi/target/i686-pc-windows-msvc/debug/bapi.dll"))
			return __bapi = "./rust/bapi/target/i686-pc-windows-msvc/debug/bapi.dll"
		// Then check in the current directory.
		if(fexists("./bapi.dll"))
			return __bapi = "./bapi.dll"
		// And elsewhere.
		return __bapi = "bapi.dll"

#define BAPI (__bapi || __detect_bapi())

#define BAPI_CALL(func, args...) call_ext(BAPI, "byond:[#func]")(args)

// ------------------------------------------- bapi functions callable from dm
// Should only call functions ending with `_ffi`.

#define bapi_read_dmm_file(arg) BAPI_CALL(read_dmm_file_ffi, arg)

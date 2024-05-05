
// Default automatic .dll/.so detection.
// Look for it in the build location first, then in `.`, then in standard places.

/* This comment bypasses grep checks */ /var/__bapi

/proc/__detect_bapi()
	if(world.system_type == UNIX)
#ifdef CIBUILDING
		// CI override, use libbapi_ci.so if possible.
		if(fexists("./tools/ci/libbapi_ci.so"))
			return __bapi = "tools/ci/libbapi_ci.so"
#endif
		// First check if it's built in the usual place.
		if(fexists("./bapi/target/i686-unknown-linux-gnu/release/libbapi.so"))
			return __bapi = "./bapi/target/i686-unknown-linux-gnu/release/libbapi.so"
		// Then check in the current directory.
		if(fexists("./libbapi.so"))
			return __bapi = "./libbapi.so"
		// And elsewhere.
		return __bapi = "libbapi.so"
	else
		// First check if it's built in the usual place.
		if(fexists("./rust/bapi/target/i686-pc-windows-msvc/release/bapi.dll"))
			return __bapi = "./rust/bapi/target/i686-pc-windows-msvc/release/bapi.dll"
		// Then check in the current directory.
		if(fexists("./bapi.dll"))
			return __bapi = "./bapi.dll"
		// And elsewhere.
		return __bapi = "bapi.dll"

#define BAPI (__bapi || __detect_bapi())

#define BAPI_CALL(func, args...) call_ext(BAPI, "byond:[#func]_ffi")(args)

// -----------------------------------------------------------------------
// -----------------------------------------------------------------------

#define bapi_hello_world(arg) BAPI_CALL("hello_world", arg)

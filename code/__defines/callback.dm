#define CALLBACK new /datum/callback

/**
 * Runs an asynchronous function, setting the waitfor to zero
 *
 * * thingtocall - The object whose function is to be called on, will be set as `src` in said function, or `GLOBAL_PROC` if the proc is a global one
 * * proctocall - The process to call, use `PROC_REF`, `TYPE_PROC_REF` or `GLOBAL_PROC_REF` according to your use case. Defines in code\__defines\byond_compat.dm
 * * ... - Parameters to pass to said proc (VARIPARAM)
 */
#define INVOKE_ASYNC ImmediateInvokeAsync

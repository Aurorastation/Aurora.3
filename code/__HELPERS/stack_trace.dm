/// Gives us the stack trace from CRASH() without ending the current proc.
/// Do not call directly, use the [stack_trace] macro instead.
/// May also be used by other tooling like from rust.
/proc/_stack_trace(message, file, line)
	CRASH("[message][WORKAROUND_IDENTIFIER][json_encode(list(file, line))][WORKAROUND_IDENTIFIER]")

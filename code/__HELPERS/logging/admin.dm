/* Items with ADMINPRIVATE prefixed are stripped from public logs. */

/// General logging for admin actions
/proc/log_admin(text, list/data)
	logger?.Log(LOG_CATEGORY_ADMIN, "ADMIN: [text]", data)

/// Logging for admin actions on or with circuits
/proc/log_admin_circuit(text, list/data)
	logger?.Log(LOG_CATEGORY_ADMIN_CIRCUIT, "ADMIN: CIRCUIT: [text]", data)

/// General logging for admin actions
/proc/log_admin_private(text, list/data)
	logger?.Log(LOG_CATEGORY_ADMIN_PRIVATE, "ADMINPRIVATE: [text]", data)

/// Logging for AdminSay (ASAY) messages
/proc/log_adminsay(text, list/data)
	logger?.Log(LOG_CATEGORY_ADMIN_PRIVATE_ASAY, "ADMINPRIVATE: ASAY: [text]", data)

/// Logging for DeachatSay (DSAY) messages
/proc/log_dsay(text, list/data)
	logger?.Log(LOG_CATEGORY_ADMIN_DSAY, "ADMIN: DSAY: [text]", data)

/**
 * Writes to a special log file if the log_suspicious_login config flag is set,
 * which is intended to contain all logins that failed under suspicious circumstances.
 *
 * Mirrors this log entry to log_access when access_log_mirror is TRUE, so this proc
 * doesn't need to be used alongside log_access and can replace it where appropriate.
 */
/proc/log_suspicious_login(text, list/data, access_log_mirror = TRUE)
	logger?.Log(LOG_CATEGORY_SUSPICIOUS_LOGIN, "SUSPICIOUS_ACCESS: [text]", data)
	if(access_log_mirror)
		log_access(text, data)

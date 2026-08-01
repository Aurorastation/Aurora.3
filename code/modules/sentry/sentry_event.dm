/**
 * # Sentry Event
 *
 * Payload builder for a single Sentry event.
 * Populated by SSsentry capture procs, then serialized via to_list() for
 * json_encode() before being sent in the envelope body.
 */
/datum/sentry_event
	/// 32-char hex UUID, stamped by SSsentry just before sending.
	var/event_id = ""
	/// ISO-8601 UTC timestamp, stamped by SSsentry just before sending.
	var/timestamp = ""
	/// Sentry level: "fatal", "error", "warning", "info", "debug".
	var/level = "error"
	/// Logical logger name shown in Sentry (e.g. "world.Error", "sql", "garbage").
	var/logger = ""
	/// Sentry environment tag, e.g. "production".
	var/environment = ""
	/// Sentry release string.
	var/release = ""
	/// Human-readable server identifier.
	var/server_name = ""

	// ---- tags & extra ----
	/// Assoc list of short indexed tags visible in Sentry's issue sidebar.
	var/list/tags
	/// Assoc list of arbitrary extra context (not indexed).
	var/list/extra

	// ---- exception fields (mutually exclusive with message) ----
	var/exc_type  = ""
	var/exc_value = ""
	var/exc_file  = ""
	var/exc_line  = 0
	/// Flat list of detail lines from error_handler's desclines (optional).
	var/list/exc_desc_lines

	// ---- message fields ----
	var/message_text = ""

	// ---- user context ----
	/// Sentry user id — either raw ckey or md5(ckey) depending on scrub setting.
	var/usr_id = ""

/datum/sentry_event/New()
	tags  = list()
	extra = list()

// ---------------------------------------------------------------------------
// Payload setters
// ---------------------------------------------------------------------------

/**
 * Populate exception fields from a BYOND /exception datum.
 * desclines is the optional list of extra context from world/Error().
 */
/datum/sentry_event/proc/set_exception(exception/e, list/desclines)
	exc_type  = e.name || "RuntimeError"
	exc_value = e.desc || ""
	exc_file  = e.file || ""
	exc_line  = e.line || 0
	if (LAZYLEN(desclines))
		exc_desc_lines = desclines.Copy()

/// Set message text for SQL-error and hard-delete style events.
/datum/sentry_event/proc/set_message(text)
	message_text = text

/// Set usr context without scrubbing (ckey sent in the clear).
/datum/sentry_event/proc/set_usr(atom/usr_ref)
	if (istype(usr_ref, /mob))
		var/mob/m = usr_ref
		usr_id = m.ckey || m.name || "unknown"
	else if (istype(usr_ref, /client))
		var/client/c = usr_ref
		usr_id = c.ckey || "unknown"

/// Set usr context with ckey hashed (md5) for PII compliance.
/datum/sentry_event/proc/set_usr_scrubbed(atom/usr_ref)
	var/raw_ckey = ""
	if (istype(usr_ref, /mob))
		var/mob/m = usr_ref
		raw_ckey = m.ckey || ""
	else if (istype(usr_ref, /client))
		var/client/c = usr_ref
		raw_ckey = c.ckey || ""
	usr_id = raw_ckey ? md5(raw_ckey) : "anonymous"

// ---------------------------------------------------------------------------
// Serialization
// ---------------------------------------------------------------------------

/**
 * Return an associative list ready for json_encode().
 * Omits empty/null fields to keep payloads lean.
 */
/datum/sentry_event/proc/to_list()
	var/list/out = list(
		"event_id"  = event_id,
		"timestamp" = timestamp,
		"platform"  = "other",
		"level"     = level
	)

	if (logger)      out["logger"]      = logger
	if (environment) out["environment"] = environment
	if (release)     out["release"]     = release
	if (server_name) out["server_name"] = server_name

	if (length(tags))  out["tags"]  = tags
	if (length(extra)) out["extra"] = extra

	if (usr_id)
		out["user"] = list("id" = usr_id)

	// --- exception payload ---
	if (exc_type)
		var/list/exc_val = list(
			"type"  = exc_type,
			"value" = exc_value
		)
		if (exc_file)
			exc_val["stacktrace"] = list(
				"frames" = list(list(
					"filename" = exc_file,
					"lineno"   = exc_line
				))
			)
		if (LAZYLEN(exc_desc_lines))
			exc_val["extra"] = list("detail" = exc_desc_lines.Join("\n"))
		out["exception"] = list("values" = list(exc_val))

	// --- message payload ---
	if (message_text)
		out["message"] = list("formatted" = message_text)

	return out

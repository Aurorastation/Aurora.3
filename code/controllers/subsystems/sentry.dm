/**
 * # SSsentry — Sentry.io Integration
 *
 * Captures runtime exceptions, SQL errors, and hard-delete overruns and
 * forwards them to sentry.io as structured events via the Sentry Envelope API.
 *
 * ## Setup
 * Copy config/example/sentry.txt to config/sentry.txt, set DSN and uncomment ENABLED.
 * The subsystem is off by default; it only activates when both ENABLED and DSN are present.
 *
 * ## Capture sites (wired elsewhere)
 * - world/Error()           → runtime exceptions    (error_handler.dm)
 * - log_exception()         → caught exceptions     (_logging.dm)
 * - log_sql()               → DB / ARGPARSE errors  (debug.dm)
 * - SSgarbage/HardDelete()  → over-threshold hard dels (garbage.dm)
 *
 * ## Kill-switch
 * After max_consecutive_failures HTTP errors the subsystem sets active = FALSE
 * and stops sending. An admin can reset it in-round via VV (set active = TRUE).
 */

SUBSYSTEM_DEF(sentry)
	name = "Sentry"
	init_order = INIT_ORDER_SENTRY
	flags = SS_NO_FIRE | SS_NO_DISPLAY

	// ---- config flags ----
	/// Master on/off switch. Set to TRUE when ENABLED + valid DSN are both present.
	var/enabled = FALSE
	/// Runtime kill-switch: flipped to FALSE after too many consecutive HTTP failures.
	var/active = TRUE
	/// Capture uncaught and caught runtime exceptions.
	var/capture_runtimes = TRUE
	/// Capture SQL errors and ARGPARSE failures.
	var/capture_sql = TRUE
	/// Capture hard-delete overruns.
	var/capture_hard_dels = TRUE
	/// Capture per-window BYOND profiler dumps as events with the raw JSON attached. Off by default — payloads are large.
	var/capture_profiler = FALSE
	/// How many of the hottest procs to include in the event extras alongside the attachment.
	var/profiler_top_n = 20
	/// Hash ckeys with md5 before sending instead of sending them in the clear.
	var/scrub_ckeys = TRUE

	// ---- DSN fields (populated by _parse_dsn) ----
	var/dsn_key = ""
	var/dsn_host = ""
	var/dsn_project_id = ""
	/// Fully constructed envelope POST URL built from the DSN.
	var/endpoint_url = ""

	// ---- event context ----
	/// Maps to Sentry's "environment" field (e.g. "production", "staging").
	var/environment = "production"
	/// Maps to Sentry's "release" field. Populated from git HEAD SHA at init.
	var/release = ""
	/// Maps to Sentry's "server_name" field.
	var/server_name = ""

	// ---- runtime state ----
	/// Per-round dedup table: erroruid (file:line) → world.time of last send.
	var/list/sent_this_round
	/// How long (in deciseconds of game time) to suppress duplicate file:line events. Defaults to 600 (60 s).
	var/dedup_window = 600
	/// Count of consecutive HTTP failures. Reset on any success.
	var/consecutive_failures = 0
	/// Kill-switch threshold.
	var/max_consecutive_failures = 10

	// Internal flag used during config loading — tracks whether ENABLED was seen.
	var/_config_enabled_flag = FALSE

// Hide DSN key from VV to avoid credential exposure.
/datum/controller/subsystem/sentry/can_vv_get(var_name)
	if (var_name == NAMEOF(src, dsn_key))
		return FALSE
	return ..()

/datum/controller/subsystem/sentry/vv_edit_var(var_name, var_value)
	if (var_name == NAMEOF(src, dsn_key))
		return FALSE
	return ..()

/datum/controller/subsystem/sentry/Initialize(timeofday)
	sent_this_round = list()
	server_name = GLOB.config?.server_name || ""

	if (fexists("config/sentry.txt"))
		GLOB.config.load("config/sentry.txt", "sentry")
	else
		log_subsystem_sentry("config/sentry.txt not found — disabled.")
		return SS_INIT_NO_NEED

	if (!_config_enabled_flag)
		log_subsystem_sentry("ENABLED not set in config/sentry.txt — disabled.")
		return SS_INIT_NO_NEED

	if (!endpoint_url)
		log_subsystem_sentry("Valid DSN not found in config/sentry.txt — disabled.")
		return SS_INIT_NO_NEED

	enabled = TRUE
	release = rustg_git_revparse("HEAD")
	log_subsystem_sentry("Initialized. env=[environment] release=[release] project=[dsn_project_id] host=[dsn_host]")
	return SS_INIT_SUCCESS

/datum/controller/subsystem/sentry/stat_entry(msg)
	msg = "enabled=[enabled] active=[active] failures=[consecutive_failures]"
	return ..()

// ---------------------------------------------------------------------------
// DSN parsing (called from configuration.dm type == "sentry" handler)
// ---------------------------------------------------------------------------

/**
 * Parse a Sentry DSN and populate dsn_key, dsn_host, dsn_project_id, endpoint_url.
 *
 * Expected format: https://KEY@HOST/PROJECT_ID
 * Returns TRUE on success, FALSE on malformed input.
 */
/datum/controller/subsystem/sentry/proc/parse_dsn(dsn)
	if (!dsn || dsn == "")
		return FALSE

	var/rest = dsn
	var/protocol = "https"

	if (findtext(rest, "https://") == 1)
		rest = copytext(rest, 9)
	else if (findtext(rest, "http://") == 1)
		rest = copytext(rest, 8)
		protocol = "http"
	else
		return FALSE

	var/at_pos = findtext(rest, "@")
	if (!at_pos)
		return FALSE

	dsn_key = copytext(rest, 1, at_pos)
	rest    = copytext(rest, at_pos + 1)

	var/slash_pos = findtext(rest, "/")
	if (!slash_pos)
		return FALSE

	dsn_host       = copytext(rest, 1, slash_pos)
	dsn_project_id = copytext(rest, slash_pos + 1)
	endpoint_url   = "[protocol]://[dsn_host]/api/[dsn_project_id]/envelope/"
	return TRUE

// ---------------------------------------------------------------------------
// Public capture API
// ---------------------------------------------------------------------------

/**
 * Capture an uncaught or caught runtime exception.
 *
 * Call from world/Error() and log_exception().
 *
 * Arguments:
 * * e         — the /exception datum
 * * desclines — optional list of extra context lines from error_handler
 * * usr_ref   — usr at time of exception (may be null)
 */
/datum/controller/subsystem/sentry/proc/capture_exception(exception/e, list/desclines, usr_ref)
	SHOULD_NOT_SLEEP(TRUE)
	if (!enabled || !active || !capture_runtimes || isnull(e))
		return

	var/erroruid = "[e.file]:[e.line]"
	// Dedup: skip if the same file:line was already sent within dedup_window deciseconds of game time.
	if (sent_this_round[erroruid] && (world.time - sent_this_round[erroruid]) < dedup_window)
		return
	sent_this_round[erroruid] = world.time

	var/datum/sentry_event/ev = new()
	ev.level  = "error"
	ev.logger = "world.Error"
	ev.set_exception(e, desclines)

	if (!isnull(usr_ref))
		if (scrub_ckeys)
			ev.set_usr_scrubbed(usr_ref)
		else
			ev.set_usr(usr_ref)

	_send_event(ev)

/**
 * Capture a message-style event (SQL error, hard delete, etc.).
 *
 * Arguments:
 * * message — human-readable description
 * * level   — Sentry severity: "error", "warning", "info"
 * * logger  — logical name shown in Sentry (e.g. "sql", "garbage")
 * * tags    — optional assoc list of short indexed tags
 * * extra   — optional assoc list of non-indexed context
 */
/datum/controller/subsystem/sentry/proc/capture_message(message, level = "error", logger = "game", list/tags, list/extra)
	SHOULD_NOT_SLEEP(TRUE)
	if (!enabled || !active)
		return

	var/datum/sentry_event/ev = new()
	ev.level  = level
	ev.logger = logger
	ev.set_message(message)

	if (tags)
		for (var/k in tags)
			ev.tags[k] = tags[k]
	if (extra)
		for (var/k in extra)
			ev.extra[k] = extra[k]

	_send_event(ev)

/**
 * Capture a BYOND profiler dump as a Sentry event with the raw JSON attached.
 *
 * Sentry's Profiling product expects sample-based stack frames; BYOND's profiler
 * is aggregated per-proc, so this ships as a regular event (logger="profiler",
 * level="info") with the top-N hottest procs in `extra` and the full JSON
 * payload as an event attachment for offline inspection.
 *
 * Arguments:
 * * profile_json — raw JSON string from world.Profile(PROFILE_REFRESH, format="json")
 * * fetch_ms     — SSprofiler fetch_cost at time of dump
 * * write_ms     — SSprofiler write_cost at time of dump
 */
/datum/controller/subsystem/sentry/proc/capture_profiler_dump(profile_json, fetch_ms, write_ms)
	SHOULD_NOT_SLEEP(TRUE)
	if (!enabled || !active || !capture_profiler)
		return
	if (!profile_json || !length(profile_json))
		return

	var/list/parsed = json_decode(profile_json)
	if (!islist(parsed))
		return

	var/list/top = _profiler_top_n(parsed, profiler_top_n)

	var/datum/sentry_event/ev = new()
	ev.level  = "info"
	ev.logger = "profiler"
	ev.set_message("Profiler dump (procs=[length(parsed)] top=[length(top)])")
	ev.tags["fetch_ms"]   = "[round(fetch_ms, 0.1)]"
	ev.tags["write_ms"]   = "[round(write_ms, 0.1)]"
	ev.tags["proc_count"] = "[length(parsed)]"
	ev.extra["top_procs"] = top

	_send_event(ev, profile_json, "profile.json", "application/json")

/// Return the top-N profiler entries by self-time, descending. Pass-through fields so format changes don't break.
/datum/controller/subsystem/sentry/proc/_profiler_top_n(list/entries, n)
	if (!islist(entries) || !length(entries))
		return list()
	var/list/sorted = entries.Copy()
	sortTim(sorted, GLOBAL_PROC_REF(cmp_sentry_profiler_self_desc))
	if (length(sorted) > n)
		sorted.Cut(n + 1)
	return sorted

/proc/cmp_sentry_profiler_self_desc(list/A, list/B)
	var/a_self = islist(A) ? A["self"] : 0
	var/b_self = islist(B) ? B["self"] : 0
	return b_self - a_self

// ---------------------------------------------------------------------------
// Internal dispatch
// ---------------------------------------------------------------------------

/datum/controller/subsystem/sentry/proc/_send_event(datum/sentry_event/ev, attachment_body = null, attachment_filename = null, attachment_content_type = null)
	SHOULD_NOT_SLEEP(TRUE)
	PRIVATE_PROC(TRUE)

	if (!enabled || !active)
		return

	// Stamp common context.
	ev.tags["round_id"]      = "[GLOB.round_id]"
	ev.tags["byond_version"] = "[world.version]"
	ev.environment = environment
	ev.server_name = server_name
	ev.release     = release

	var/envelope_body = _build_envelope(ev, attachment_body, attachment_filename, attachment_content_type)
	if (!envelope_body)
		return

	var/list/req_headers = list(
		"Content-Type"  = "application/x-sentry-envelope",
		"X-Sentry-Auth" = "Sentry sentry_version=7,sentry_key=[dsn_key],sentry_client=aurora.sentry/1.0"
	)

	if (!isnull(SShttp))
		var/datum/callback/cb = CALLBACK(src, PROC_REF(_on_response))
		SShttp.create_async_request(RUSTG_HTTP_METHOD_POST, endpoint_url, envelope_body, req_headers, cb)
	else
		// SShttp not yet available (very early runtime) — fire-and-forget directly via rust_g.
		rustg_http_request_async(RUSTG_HTTP_METHOD_POST, endpoint_url, envelope_body, json_encode(req_headers), null)

/datum/controller/subsystem/sentry/proc/_on_response(datum/http_response/res)
	PRIVATE_PROC(TRUE)

	if (!res || res.errored || (res.status_code && res.status_code >= 400))
		consecutive_failures++
		if (consecutive_failures >= max_consecutive_failures)
			active = FALSE
			var/last_err = res ? (res.errored ? "[res.error]" : "HTTP [res.status_code]") : "null response"
			log_subsystem_sentry("Kill-switch triggered after [consecutive_failures] consecutive failures. Last: [last_err]")
			admin_notice(SPAN_DANGER("Sentry kill-switch triggered after [consecutive_failures] consecutive HTTP failures ([last_err]). \
				Event reporting is disabled. Reset via VV: SSsentry → active = TRUE."), R_ADMIN|R_MOD|R_DEV)
		return

	consecutive_failures = 0

// ---------------------------------------------------------------------------
// Envelope serialization
// ---------------------------------------------------------------------------

/**
 * Build a Sentry envelope: header + event item, plus an optional attachment item.
 *
 * Layout:
 *   {envelope-header}\n
 *   {event-item-header}\n
 *   {event-payload}\n
 *   [{attachment-item-header}\n{attachment-payload}\n]   ← only when attachment_body set
 */
/datum/controller/subsystem/sentry/proc/_build_envelope(datum/sentry_event/ev, attachment_body = null, attachment_filename = null, attachment_content_type = null)
	PRIVATE_PROC(TRUE)

	ev.event_id  = _generate_event_id()
	ev.timestamp = _iso8601_now()

	var/payload_json = json_encode(ev.to_list())
	if (!payload_json)
		return null

	var/list/env_header = list(
		"event_id" = ev.event_id,
		"sent_at"  = ev.timestamp,
		"sdk"      = list("name" = "aurora.sentry", "version" = "1.0")
	)
	var/list/item_header = list(
		"type"         = "event",
		"content_type" = "application/json",
		"length"       = length(payload_json)
	)

	var/envelope = "[json_encode(env_header)]\n[json_encode(item_header)]\n[payload_json]\n"

	if (attachment_body && length(attachment_body))
		var/list/att_header = list(
			"type"            = "attachment",
			"length"          = length(attachment_body),
			"content_type"    = attachment_content_type || "application/octet-stream",
			"filename"        = attachment_filename || "attachment.bin",
			"attachment_type" = "event.attachment"
		)
		envelope += "[json_encode(att_header)]\n[attachment_body]\n"

	return envelope

/// Generate a pseudo-random 32-char hex event ID via md5.
/datum/controller/subsystem/sentry/proc/_generate_event_id()
	PRIVATE_PROC(TRUE)

	return md5("[world.time][world.realtime][rand(0, 9999999)]")

/// Return current time as ISO-8601 UTC string (YYYY-MM-DDTHH:MM:SSZ).
/datum/controller/subsystem/sentry/proc/_iso8601_now()
	PRIVATE_PROC(TRUE)

	var/t = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")
	var/space = findtext(t, " ")
	if (space)
		return "[copytext(t, 1, space)]T[copytext(t, space + 1)]Z"
	return t

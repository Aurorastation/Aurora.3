/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/**
 * Maximum number of connection records allowed to analyze.
 * Should match the value set in the browser.
 */
#define TGUI_TELEMETRY_MAX_CONNECTIONS 5

/**
 * Maximum time allocated for sending a telemetry packet.
 */
#define TGUI_TELEMETRY_RESPONSE_WINDOW (30 SECONDS)

/// Time of telemetry request
/datum/tgui_panel/var/telemetry_requested_at
/// Time of telemetry analysis completion
/datum/tgui_panel/var/telemetry_analyzed_at
/// List of previous client connections
/datum/tgui_panel/var/list/telemetry_connections

/**
 * private
 *
 * Requests some telemetry from the client.
 */
/datum/tgui_panel/proc/request_telemetry()
	telemetry_requested_at = world.time
	telemetry_analyzed_at = null
	window.send_message("telemetry/request", list(
		"limits" = list(
			"connections" = TGUI_TELEMETRY_MAX_CONNECTIONS,
		),
	))

/**
 * private
 *
 * Analyzes a telemetry packet.
 *
 * Does nothing except kick people who try to send a billion requests.
 */
/datum/tgui_panel/proc/analyze_telemetry(payload)
	if(world.time > telemetry_requested_at + TGUI_TELEMETRY_RESPONSE_WINDOW)
		message_admins("[key_name(client)] sent telemetry outside of the allocated time window.")
		return
	if(telemetry_analyzed_at)
		message_admins("[key_name(client)] sent telemetry more than once.")
		return
	telemetry_analyzed_at = world.time
	if(!payload)
		return
	telemetry_connections = payload["connections"]
	var/len = length(telemetry_connections)
	if(len == 0)
		return
	if(len > TGUI_TELEMETRY_MAX_CONNECTIONS)
		message_admins("[key_name(client)] was kicked for sending a huge telemetry payload")
		qdel(client)
		return

	var/ckey = client?.ckey
	if (!ckey)
		return

	// Convert assoc-list connections to positional format for apply_ban_mirror,
	// which reads extra_info[i][1] to extract ckeys for DB storage.
	var/list/extra_info = list()
	for(var/list/conn in telemetry_connections)
		extra_info += list(list(conn["ckey"], conn["address"], conn["computer_id"]))

	var/ban_id = 0
	for(var/list/conn in telemetry_connections)
		var/list/bdata = world.IsBanned(conn["ckey"], conn["address"], conn["computer_id"], 1, real_bans_only = TRUE, log_connection = FALSE)
		if(bdata && bdata.len && !isnull(bdata["id"]))
			ban_id = bdata["id"]
			break

	if(ban_id)
		if(!client.holder)
			log_and_message_admins("[ckey] from [client.address]-[client.computer_id] was caught bandodging. Mirror applied for ban #[ban_id], kicking shortly.")
			apply_ban_mirror(ckey, client.address, client.computer_id, ban_id, 2, extra_info)
			spawn(20)
				del(client)
		else
			log_and_message_admins("[ckey] is a staff but was caught bandodging! Ban ID: #[ban_id].")

#undef TGUI_TELEMETRY_MAX_CONNECTIONS
#undef TGUI_TELEMETRY_RESPONSE_WINDOW

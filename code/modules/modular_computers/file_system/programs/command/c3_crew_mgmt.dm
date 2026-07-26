/datum/computer_file/program/comm_control
	filename = "comm_control"
	filedesc = "C3 Crew Management"
	extended_desc = "Command-facing application for command, communications, and control of both ship and crew assets."
	program_icon_state = "comm_monitor"
	program_key_icon_state = "lightblue_key"
	color = LIGHT_COLOR_BLUE
	size = 8
	required_access_run = list(ACCESS_HEADS, ACCESS_BRIDGE_CREW)
	requires_access_to_run = PROGRAM_ACCESS_LIST_ONE
	required_access_download = list(ACCESS_HEADS, ACCESS_BRIDGE_CREW)
	requires_access_to_download = PROGRAM_ACCESS_LIST_ONE
	network_destination = "station long-range communication array"
	// The app must open during outages so command can see degraded state instead of failing to launch.
	requires_ntnet = FALSE
	available_on_ntnet = TRUE
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP | PROGRAM_TABLET | PROGRAM_SILICON_AI | PROGRAM_SILICON_ROBOT
	tgui_id = "TeamControl"
	var/intercept = FALSE
	var/can_call_shuttle = FALSE
	var/centcomm_message_cooldown = 0
	var/announcement_cooldown = 0
	var/datum/announcement/priority/crew_announcement = new

/datum/computer_file/program/comm_control/New(obj/item/modular_computer/comp, intercept_printing = FALSE, shuttle_call = FALSE)
	. = ..()
	intercept = intercept_printing
	can_call_shuttle = shuttle_call
	crew_announcement.newscast = TRUE

/datum/computer_file/program/comm_control/intercept/New(obj/item/modular_computer/comp, intercept_printing, shuttle_call)
	. = ..(comp, TRUE, shuttle_call)

/// Finds the team containing a live human, using team member records first and then the general crew record.
/datum/controller/subsystem/records/proc/get_team_for_mob(var/mob/living/carbon/human/member)
	if(!istype(member))
		return

	for(var/datum/team/team as anything in teams)
		for(var/member_key in team.member_records)
			if(team.resolve_member_live_mob(member_key) == member)
				return team

	var/datum/record/general/general_record = find_record("name", member.real_name, RECORD_GENERAL)
	if(general_record)
		return get_team_for_general_record(general_record)

/// Builds the small team status block shown on human status panels.
/datum/controller/subsystem/records/proc/get_team_status_items(var/mob/living/carbon/human/member)
	var/list/items = list()
	var/datum/team/team = get_team_for_mob(member)
	if(!team)
		return items

	items += "Team: [team.display_name]"
	if(team.get_operator_name() != "Unassigned")
		items += "Operator: [team.get_operator_name()]"
	if(team.primary_objective)
		items += "Primary Objective: [team.primary_objective]"
	if(team.secondary_objective)
		items += "Secondary Objective: [team.secondary_objective]"
	return items

/**
 * Sensor caching note:
 * C3 app intentionally reads location from a cache, not from live mob locs.
 * A single build_sensor_lookup() snapshot is built per TGUI update, keyed to sensor mob ref and crew name.
 * Roster readiness may use live mob state, but position, sector, group, and lead-position labels must come from this cached sensor path
 * so we're not churning through tons of unnecessary data.
 */
/datum/computer_file/program/comm_control/ui_data(mob/user)
	var/list/data = initial_data()
	var/ntn_comm = !!get_signal(NTNET_COMMUNICATION)

	data["authenticated"] = can_run(user)
	data["emagged"] = computer_emagged
	data["net_syscont"] = !!get_signal(NTNET_SYSTEMCONTROL)
	data["message_printing_intercepts"] = intercept
	data["have_printer"] = computer ? !!computer.nano_printer : FALSE
	data["can_call_shuttle"] = can_call_shuttle
	data["isAI"] = issilicon(user)
	data["boss_short"] = SSatlas.current_map.boss_short
	data["current_security_level"] = GLOB.security_level
	data["current_maint_all_access"] = GLOB.maint_all_access
	data["def_SEC_LEVEL_YELLOW"] = SEC_LEVEL_YELLOW
	data["def_SEC_LEVEL_BLUE"] = SEC_LEVEL_BLUE
	data["def_SEC_LEVEL_GREEN"] = SEC_LEVEL_GREEN
	data["ntnet_communications_available"] = ntn_comm
	var/obj/effect/overmap/visitable/horizon = get_horizon_sector()
	var/list/destination_data = get_available_destination_data(horizon)
	var/list/destination_sources = destination_data["sources"]
	data["destination_contacts"] = destination_data["contacts"]
	data["teams"] = list()

	data["messages"] = GLOB.comm_messages

	var/list/processed_evac_options = list()
	if(!isnull(GLOB.evacuation_controller))
		for(var/datum/evacuation_option/evac_option in GLOB.evacuation_controller.available_evac_options())
			if(evac_option.abandon_ship)
				continue
			var/list/option = list()
			option["option_text"] = evac_option.option_text
			option["option_target"] = evac_option.option_target
			option["needs_syscontrol"] = evac_option.needs_syscontrol
			option["silicon_allowed"] = evac_option.silicon_allowed
			processed_evac_options += list(option)
	data["evac_options"] = processed_evac_options

	// Build sensor data once per UI update so every team row uses one consistent NTNet snapshot.
	var/list/sensor_lookup = build_sensor_lookup(ntn_comm)
	for(var/datum/team/team as anything in SSrecords.teams)
		data["teams"] += list(build_team_data(team, sensor_lookup, ntn_comm, destination_sources, horizon))

	return data

/datum/computer_file/program/comm_control/proc/set_announcement_cooldown(var/cooldown)
	announcement_cooldown = cooldown

/datum/computer_file/program/comm_control/proc/set_centcomm_message_cooldown(var/cooldown)
	centcomm_message_cooldown = cooldown

/// Broken out into its own proc because ui_act is complex enough already.
/datum/computer_file/program/comm_control/proc/handle_command_communication_action(var/action, list/params, var/mob/user)
	var/ntn_comm = !!get_signal(NTNET_COMMUNICATION)
	var/ntn_cont = !!get_signal(NTNET_SYSTEMCONTROL)
	var/authenticated = can_run(user)
	switch(action)
		if("emergencymaint")
			if((authenticated && (isAI(user) || !issilicon(user))) && ntn_cont)
				if(GLOB.maint_all_access)
					revoke_maint_all_access()
					feedback_inc("alert_comms_maintRevoke", 1)
					log_and_message_admins("disabled emergency maintenance access")
				else
					make_maint_all_access()
					feedback_inc("alert_comms_maintGrant", 1)
					log_and_message_admins("enabled emergency maintenance access")
		if("announce")
			if(authenticated && !issilicon(user) && ntn_comm)
				if(user)
					var/obj/item/card/id/id_card = user.GetIdCard()
					crew_announcement.announcer = GetNameAndAssignmentFromId(id_card)
				else
					crew_announcement.announcer = "Unknown"
				if(announcement_cooldown)
					to_chat(user, "Please allow at least one minute to pass between announcements")
					return TRUE
				var/title_input = tgui_input_text(user, "Please choose a title for the announcement.", "Announcement Title", default = "Priority Announcement", encode = FALSE)
				if(isnull(title_input) || computer.use_check_and_message(user))
					return TRUE
				var/announcement_title = trim(title_input, MAX_MESSAGE_LEN)
				if(!announcement_title)
					announcement_title = "Priority Announcement"
				var/input = tgui_input_text(user, "Please write a message to announce to the [station_name()] crew.", "Announcement Body", multiline = TRUE, encode = FALSE)
				if(!input || computer.use_check_and_message(user))
					return TRUE
				var/was_hearing = HAS_TRAIT(computer, TRAIT_HEARING_SENSITIVE)
				if(!was_hearing)
					computer.become_hearing_sensitive()
				user.say(STRIP_HTML_FULL(input, MAX_MESSAGE_LEN))
				if(!was_hearing)
					computer.lose_hearing_sensitivity()
				var/announcement_message = computer.registered_message
				if(!announcement_message)
					return TRUE
				announcement_title = sanitizeSafe(announcement_title)
				if(!announcement_title)
					announcement_title = "Priority Announcement"
				announcement_message = sanitize(announcement_message, extra = 0)
				var/affected_zlevels = GetConnectedZlevels(GET_Z(computer))
				crew_announcement.Announce(announcement_message, announcement_title, msg_sanitized = TRUE, zlevels = affected_zlevels)
				post_comm_message(announcement_title, announcement_message)
				set_announcement_cooldown(TRUE)
				addtimer(CALLBACK(src, PROC_REF(set_announcement_cooldown), FALSE), 600)
		if("message")
			if(params["target"] == "emagged")
				if(authenticated && computer_emagged && !issilicon(user) && ntn_comm)
					if(centcomm_message_cooldown)
						to_chat(user, SPAN_WARNING("Arrays recycling. Please stand by."))
						return TRUE
					var/input = sanitize(tgui_input_text(user, "Please choose a message to transmit to \[ABNORMAL ROUTING CORDINATES\] via quantum entanglement.", "Emergency M&#e55sage", multiline = TRUE, encode = FALSE))
					if(!input || computer.use_check_and_message(user))
						return TRUE
					Syndicate_announce(input, user)
					to_chat(user, SPAN_NOTICE("Message successfully transmitted."))
					log_say("[key_name(user)] has sent a message to the syndicate: [input]")
					centcomm_message_cooldown = TRUE
					addtimer(CALLBACK(src, PROC_REF(set_centcomm_message_cooldown), FALSE), 300)
			else if(params["target"] == "regular")
				if(authenticated && !issilicon(user) && ntn_comm)
					if(centcomm_message_cooldown)
						to_chat(user, SPAN_WARNING("Arrays recycling. Please stand by."))
						return TRUE
					if(!is_relay_online())
						to_chat(user, SPAN_WARNING("No Emergency Bluespace Relay detected. Unable to transmit message."))
						return TRUE
					var/input = sanitize(tgui_input_text(user, "Please choose a message to transmit to [SSatlas.current_map.boss_name] via quantum entanglement.", "Emergency Message", multiline = TRUE, encode = FALSE))
					if(!input || computer.use_check_and_message(user))
						return TRUE
					Centcomm_announce(input, user)
					to_chat(user, SPAN_NOTICE("Message successfully transmitted."))
					log_say("[key_name(user)] has sent a message to [SSatlas.current_map.boss_short]: [input]")
					centcomm_message_cooldown = TRUE
					addtimer(CALLBACK(src, PROC_REF(set_centcomm_message_cooldown), FALSE), 300)
		if("evac")
			if(authenticated && GLOB.evacuation_controller)
				var/datum/evacuation_option/selected_evac_option = GLOB.evacuation_controller.evacuation_options[params["target"]]
				if(isnull(selected_evac_option) || !istype(selected_evac_option))
					return TRUE
				if(!selected_evac_option.silicon_allowed && issilicon(user))
					return TRUE
				if(selected_evac_option.needs_syscontrol && !ntn_cont)
					return TRUE
				var/confirm = alert("Are you sure you want to [selected_evac_option.option_desc]?", filedesc, "No", "Yes")
				if(confirm == "Yes" && !computer.use_check_and_message(user))
					GLOB.evacuation_controller.handle_evac_option(selected_evac_option.option_target, user)
		if("setstatus")
			if(authenticated && ntn_cont)
				switch(params["target"])
					if("message")
						post_display_status("message", params["line1"], params["line2"])
					if("alert")
						post_display_status("alert", params["alert"])
					else
						post_display_status(params["target"])
		if("setalert")
			if(authenticated && (!issilicon(user) || isAI(user)) && ntn_cont && ntn_comm)
				var/current_level = text2num(params["target"])
				var/confirm = tgui_alert(user, "Are you sure you want to change alert level to [num2seclevel(current_level)]?", filedesc, list("No", "Yes"))
				if(confirm == "Yes" && !computer.use_check_and_message(user, (isAI(user) ? USE_ALLOW_NON_ADJACENT : FALSE)))
					var/old_level = GLOB.security_level
					if(!current_level)
						current_level = SEC_LEVEL_GREEN
					if(current_level < SEC_LEVEL_GREEN)
						current_level = SEC_LEVEL_GREEN
					if(current_level > SEC_LEVEL_BLUE)
						current_level = SEC_LEVEL_BLUE
					set_security_level(current_level)
					if(GLOB.security_level != old_level)
						log_game("[key_name(user)] has changed the security level to [get_security_level()].")
						message_admins("[key_name_admin(user)] has changed the security level to [get_security_level()].")
						switch(GLOB.security_level)
							if(SEC_LEVEL_GREEN)
								feedback_inc("alert_comms_green", 1)
							if(SEC_LEVEL_BLUE)
								feedback_inc("alert_comms_blue", 1)
							if(SEC_LEVEL_YELLOW)
								feedback_inc("alert_comms_yellow", 1)
			else
				to_chat(user, SPAN_WARNING("You press the button, but a red light flashes and nothing happens."))
		if("printmessage")
			if(authenticated && ntn_comm)
				if(computer && computer.nano_printer)
					if(!computer.nano_printer.print_text(params["contents"], params["title"]))
						to_chat(user, SPAN_WARNING("Hardware error: Printer was unable to print the file. It may be out of paper."))
					else
						computer.visible_message(SPAN_NOTICE("\The [computer] prints out paper."))
		if("toggleintercept")
			if(authenticated && ntn_comm)
				if(computer?.nano_printer)
					intercept = !intercept
	return TRUE

/datum/computer_file/program/comm_control/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/ntn_comm = !!get_signal(NTNET_COMMUNICATION)
	var/ntn_cont = !!get_signal(NTNET_SYSTEMCONTROL)
	var/mob/user = usr
	if(!ntn_comm && !ntn_cont)
		to_chat(user, FONT_SMALL(SPAN_WARNING("\The [src] displays, \"NETWORK ERROR - Unable to connect to NTNet. Please retry. If problem persists contact your system administrator.\".")))
		return TRUE


	if(!can_run(user))
		to_chat(user, SPAN_WARNING("Authentication error: command access required."))
		return TRUE

	switch(action)
		if("emergencymaint", "announce", "message", "evac", "setstatus", "setalert", "printmessage", "toggleintercept")
			return handle_command_communication_action(action, params, user)

	// Remaining actions target a specific team; the combined command dashboard is read-only.
	var/datum/team/team = SSrecords.get_team_by_id(params["id"])
	if(!istype(team))
		return TRUE

	var/update_ui = FALSE
	switch(action)
		if("claim")
			if(!team.set_operator(user))
				to_chat(user, SPAN_WARNING("[team.display_name] is already claimed by [team.get_operator_name()]."))
			else
				to_chat(user, SPAN_NOTICE("You claim [team.display_name]."))
			update_ui = TRUE

		if("override")
			team.set_operator(user, TRUE)
			to_chat(user, SPAN_NOTICE("You override operator assignment for [team.display_name]."))
			update_ui = TRUE

		if("release")
			team.release_operator(user)
			to_chat(user, SPAN_NOTICE("You release [team.display_name]."))
			update_ui = TRUE

		if("rename_team")
			var/new_name = tgui_input_text(user, "Enter a new team name.", "Rename Team", team.display_name, max_length = MAX_NAME_LEN, encode = FALSE)
			if(!new_name || computer.use_check_and_message(user))
				return TRUE
			if(team.set_name(new_name, user))
				to_chat(user, SPAN_NOTICE("Team renamed to [team.display_name]."))
			update_ui = TRUE

		if("randomize_team_name")
			var/new_name = SSrecords.generate_team_display_name()
			if(team.set_name("Team [new_name]", user))
				to_chat(user, SPAN_NOTICE("Team renamed to [team.display_name]."))
			update_ui = TRUE

		if("add_member")
			var/list/member_choices = list()
			var/list/member_lookup = list()
			for(var/datum/record/general/general_record as anything in SSrecords.get_team_member_pool())
				var/member_key = "record:[general_record.id]"
				if(team.member_records[member_key])
					continue
				var/datum/team/current_team = SSrecords.get_team_for_general_record(general_record)
				// Existing team name in the choice warns command that selecting this person will reassign them.
				var/choice_name = current_team ? "[general_record.name] ([general_record.rank]) - [current_team.display_name] #[general_record.id]" : "[general_record.name] ([general_record.rank]) #[general_record.id]"
				member_choices += choice_name
				member_lookup[choice_name] = general_record.id
			if(!length(member_choices))
				to_chat(user, SPAN_WARNING("No additional crew records available."))
				return TRUE
			var/selected_member = tgui_input_list(user, "Select team member.", "Team Member", member_choices)
			if(!selected_member || computer.use_check_and_message(user))
				return TRUE
			if(!SSrecords.assign_general_record_to_team(team, member_lookup[selected_member], user))
				to_chat(user, SPAN_WARNING("Unable to assign selected crew record to [team.display_name]."))
			update_ui = TRUE

		if("remove_member")
			if(!SSrecords.remove_team_member(team, params["member"], user))
				to_chat(user, SPAN_WARNING("Unable to remove selected member from [team.display_name]."))
			update_ui = TRUE

		if("set_lead")
			if(!team.set_lead(params["member"], TRUE, user))
				to_chat(user, SPAN_WARNING("Unable to set team lead."))
			SSrecords.reset_manifest()
			update_ui = TRUE

		if("clear_lead")
			if(team.team_lead_member_key)
				team.set_lead(team.team_lead_member_key, FALSE, user)
				SSrecords.reset_manifest()
			update_ui = TRUE

		if("set_destination")
			var/list/destination_data = get_available_destination_data(get_horizon_sector(), TRUE)
			var/list/available_destinations = destination_data["sources"]
			var/obj/effect/overmap/visitable/selected_destination
			for(var/obj/effect/overmap/visitable/contact as anything in available_destinations)
				if("[REF(contact)]" == params["contact"])
					selected_destination = contact
					break
			if(!istype(selected_destination))
				to_chat(user, SPAN_WARNING("That destination is not currently available from SCCV Horizon sensor contacts."))
				return TRUE
			if(team.set_destination_overmap(selected_destination, user))
				to_chat(user, SPAN_NOTICE("[team.display_name] destination set to [selected_destination.name]."))
			update_ui = TRUE

		if("clear_destination")
			if(team.clear_destination_overmap(user))
				to_chat(user, SPAN_NOTICE("[team.display_name] destination cleared."))
			update_ui = TRUE

		if("set_objective")
			var/objective_slot = params["slot"]
			var/current_objective = team.get_objective_text(objective_slot)
			var/objective_text = tgui_input_text(user, "Set [team.get_objective_label(objective_slot)] objective.", "Team Objective", current_objective, max_length = 64, multiline = TRUE, encode = FALSE)
			if(!objective_text || computer.use_check_and_message(user))
				return TRUE
			if(team.set_objective(objective_slot, objective_text, user))
				// Objectives are persisted first; delivery failure only affects the reminder message.
				var/list/delivery = deliver_team_message(team, "team", "<b>[capitalize(team.get_objective_label(objective_slot))] objective:</b> [team.get_objective_text(objective_slot)]", user)
				report_delivery(user, delivery)
			update_ui = TRUE

		if("clear_objective")
			var/objective_slot = params["slot"]
			if(team.clear_objective(objective_slot, user))
				to_chat(user, SPAN_NOTICE("[capitalize(team.get_objective_label(objective_slot))] objective cleared."))
			update_ui = TRUE

		if("remind_objective")
			var/objective_slot = params["slot"]
			if(!team.log_remind_objective(objective_slot, user))
				to_chat(user, SPAN_WARNING("No [team.get_objective_label(objective_slot)] objective set."))
				return TRUE
			var/list/delivery = deliver_team_message(team, "team", "[capitalize(team.get_objective_label(objective_slot))] objective reminder: [team.get_objective_text(objective_slot)]", user)
			report_delivery(user, delivery)
			update_ui = TRUE

		if("message_team")
			var/message = tgui_input_text(user, "Message the full team.", "Team Message", max_length = 64, multiline = TRUE, encode = FALSE)
			if(!message || computer.use_check_and_message(user))
				return TRUE
			var/list/delivery = deliver_team_message(team, "team", message, user)
			report_delivery(user, delivery)
			update_ui = TRUE

		if("message_lead")
			var/message = tgui_input_text(user, "Message the team lead.", "Team Lead Message", max_length = 64, multiline = TRUE, encode = FALSE)
			if(!message || computer.use_check_and_message(user))
				return TRUE
			var/list/delivery = deliver_team_message(team, "lead", message, user)
			report_delivery(user, delivery)
			update_ui = TRUE

	if(update_ui)
		SStgui.update_uis(computer)
	return TRUE

/// Builds lookup tables from the reachable crew sensor repository for fast roster matching by ref or name.
/datum/computer_file/program/comm_control/proc/build_sensor_lookup(var/ntnet_available)
	if(!ntnet_available || !GLOB.ntnet_global)
		return build_crew_sensor_lookup()

	// Reachable z-levels are the privacy/security gate; do not build rows from live mob positions here.
	return build_crew_sensor_lookup(GLOB.ntnet_global.get_reachable_z_levels(computer.network_card, NTNET_COMMUNICATION))

/// Builds one team's TGUI model, including roster rows, group summary, destination context, and logs.
/datum/computer_file/program/comm_control/proc/build_team_data(var/datum/team/team, var/list/sensor_lookup, var/ntnet_available, var/list/destination_sources, var/obj/effect/overmap/visitable/horizon)
	var/list/roster = list()

	// Lead distance and offset are relative to lead tracking; no live coordinates are used if sensors are not tracking.
	var/list/lead_tracking
	if(team.team_lead_member_key)
		var/datum/record/general/lead_record = team.get_member_record(team.team_lead_member_key)
		var/mob/living/carbon/human/lead_member = team.resolve_member_live_mob(team.team_lead_member_key)
		lead_tracking = build_crew_tracking_sample(get_crew_sensor_data_for_member(lead_record, lead_member, sensor_lookup), horizon)
	var/group_summary = "NTNet unavailable"
	if(ntnet_available)
		if(!team.team_lead_member_key)
			group_summary = "No lead assigned"
		else
			group_summary = team.group_summary || "Group topology pending"

	for(var/member_key in team.member_records)
		var/list/row = build_roster_row(team, member_key, sensor_lookup, lead_tracking, horizon, ntnet_available)
		roster += list(row)

	var/list/logs = list()
	// Copy logs into the TGUI payload so consumers cannot mutate the team's log list through returned data.
	for(var/list/log_entry as anything in team.log_entries)
		logs += list(log_entry)

	return list(
		"id" = team.id,
		"name" = team.display_name,
		"lead" = team.get_lead_name(),
		"operator" = team.get_operator_name(),
		"primary_objective" = team.primary_objective,
		"secondary_objective" = team.secondary_objective,
		"group_summary" = group_summary,
		"destination_context" = build_destination_context(team, destination_sources, horizon),
		"roster" = roster,
		"logs" = logs
	)

/**
 * Builds one roster row. Separate proc for cleanliness, because a member's data is pulled from multiple places:
 * * Team membership
 * * Records
 * * Live mob state
 * * Suit sensor data
 * * Lead-relative positioning
 */
/datum/computer_file/program/comm_control/proc/build_roster_row(var/datum/team/team, var/member_key, var/list/sensor_lookup, var/list/lead_tracking, var/obj/effect/overmap/visitable/horizon, var/ntnet_available)
	var/datum/record/general/general_record = team.get_member_record(member_key)
	var/mob/living/carbon/human/live_member = team.resolve_member_live_mob(member_key)
	var/list/sensor_data = get_crew_sensor_data_for_member(general_record, live_member, sensor_lookup)
	var/list/tracking = build_crew_tracking_sample(sensor_data, horizon)
	var/assignment = "Unknown"
	// Records are the manifest authority; live mob and sensor assignment are fallbacks for degraded rows.
	// If we lose NTNet, we don't want to have the app just drop everything and blind the users. Instead,
	// we try to preserve last known good state and provide indication that data may be outdated.
	if(general_record && general_record.rank)
		assignment = general_record.rank
	else if(istype(live_member))
		assignment = live_member.get_assignment("Unknown", "No Job")
	else if(sensor_data && sensor_data["ass"])
		assignment = sensor_data["ass"]
	var/state = get_member_state(live_member, general_record)
	// Cache sensor mode wins because it is tied to the same sensor sample as any cached location.
	var/sensor_level = (sensor_data && !isnull(sensor_data["stype"])) ? sensor_data["stype"] : (istype(live_member) ? getsensorlevel(live_member) : SUIT_SENSOR_OFF)
	var/location_state = get_location_state(live_member, sensor_data, sensor_level, ntnet_available)
	var/sector_name = (tracking && tracking["sector_name"]) ? tracking["sector_name"] : "Unknown"
	var/member_name = general_record?.name || team.get_member_display_name(member_key)
	var/member_area = (sensor_data && sensor_data["area"]) ? sensor_data["area"] : "Unknown"
	var/member_x = sensor_data ? sensor_data["x"] : null
	var/member_y = sensor_data ? sensor_data["y"] : null
	var/member_z = sensor_data ? sensor_data["z"] : null
	var/deployed_offship = tracking ? tracking["deployed_offship"] : FALSE
	var/list/group_data = get_member_group_data(team, member_key, sensor_data, ntnet_available)

	return list(
		"key" = member_key,
		"name" = member_name,
		"assignment" = assignment,
		"is_lead" = team.team_lead_member_key == member_key,
		"state" = state,
		"location_state" = location_state,
		"area" = member_area,
		"x" = member_x,
		"y" = member_y,
		"z" = member_z,
		"sector" = sector_name,
		"deployed_offship" = deployed_offship,
		"lead_distance_band" = get_lead_distance_band_label(tracking, lead_tracking),
		"lead_offset" = get_lead_offset_label(tracking, lead_tracking),
		"group_relationship" = group_data["relationship"],
		"group_type" = group_data["group_type"],
		"group_sort" = group_data["group_sort"]
	)

/// Returns one member's published group relationship, with local visibility checks preserved.
/datum/computer_file/program/comm_control/proc/get_member_group_data(var/datum/team/team, var/member_key, var/list/sensor_data, var/ntnet_available)
	if(!ntnet_available)
		return build_group_relationship_state("NTNet unavailable", "unavailable", 5000)
	if(!team.team_lead_member_key)
		return build_group_relationship_state("No lead assigned", "unavailable", 5000)
	if(!sensor_data || sensor_data["stype"] < SUIT_SENSOR_TRACKING)
		return build_group_relationship_state("No tracking data", "untracked", 4000)

	var/list/group_data = team.group_member_states ? team.group_member_states[member_key] : null
	if(group_data)
		return group_data
	return build_group_relationship_state("Group topology pending", "unavailable", 5000)

/// Builds a compact group relationship structure for C3 app rows.
/datum/computer_file/program/comm_control/proc/build_group_relationship_state(var/relationship, var/group_type, var/group_sort)
	return list(
		"relationship" = relationship,
		"group_type" = group_type,
		"group_sort" = group_sort
	)

/// Resolves the current Horizon overmap visitable used to distinguish onboard and offship tracking.
/datum/computer_file/program/comm_control/proc/get_horizon_sector()
	if(SSatlas.current_map.overmap_visitable_type)
		return SSshuttle.ship_by_type(SSatlas.current_map.overmap_visitable_type)

/// Reports readiness state for a roster member from live mob state, client presence, and record availability.
/datum/computer_file/program/comm_control/proc/get_member_state(var/mob/living/carbon/human/live_member, var/datum/record/general/general_record)
	if(!istype(live_member))
		return istype(general_record) ? "missing" : "unknown"
	if(live_member.stat == DEAD)
		return "dead"
	if(!live_member.client)
		return "ssd"
	if(live_member.stat == UNCONSCIOUS)
		return "unconscious"
	return "conscious"

/// Explains why a member location is or is not visible from sensor cache, NTNet, jamming, and suit sensor mode.
/datum/computer_file/program/comm_control/proc/get_location_state(var/mob/living/carbon/human/live_member, var/list/sensor_data, var/sensor_level, var/ntnet_available)
	// A live jammer blocks even previously resolvable members because this label explains current visibility.
	if((istype(live_member) && within_jamming_range(live_member)) || !ntnet_available || (sensor_data && sensor_data["stype"] < SUIT_SENSOR_TRACKING))
		return "No tracking"
	if(sensor_data && sensor_data["stype"] >= SUIT_SENSOR_TRACKING)
		return "Tracking"
	if(!istype(live_member))
		return "ERR"
	return "not visible"

/// Converts individual lead-relative distance into the current display band.
/datum/computer_file/program/comm_control/proc/get_lead_distance_band_label(var/list/tracking, var/list/lead_tracking)
	if(!lead_tracking || !lead_tracking["tracking"])
		return "Unavailable"
	if(!tracking || !tracking["tracking"])
		return "No tracking"
	if(tracking["z"] != lead_tracking["z"])
		return "Separate z"

	var/distance = get_crew_tracking_distance(tracking, lead_tracking)
	if(isnull(distance))
		return "Unknown"
	if(distance <= TEAM_LEAD_BAND_CLOSE_RANGE)
		return "Close"
	if(distance <= TEAM_LEAD_BAND_EXTENDED_RANGE)
		return "Extended"
	return "Distant"

/// Builds a human-readable distance and bearing label from lead to member.
/datum/computer_file/program/comm_control/proc/get_lead_offset_distance_label(var/list/tracking, var/list/lead_tracking)
	var/distance = get_crew_tracking_distance(tracking, lead_tracking)
	if(isnull(distance))
		// Invalid tracking samples should be filtered before this point.
		return "ERR"
	var/bearing = BEARING_RELATIVE(lead_tracking["x"], lead_tracking["y"], tracking["x"], tracking["y"])
	if(bearing < 0)
		bearing += 360
	return "[distance]m [dir2text(angle2dir(bearing))]"

/// Converts member tracking into the display label shown in roster rows.
/datum/computer_file/program/comm_control/proc/get_lead_offset_label(var/list/tracking, var/list/lead_tracking)
	if(!lead_tracking || !lead_tracking["tracking"])
		return "No lead tracking"
	if(!tracking || !tracking["tracking"])
		return "No tracking"
	if(tracking["z"] == lead_tracking["z"])
		var/distance = get_crew_tracking_distance(tracking, lead_tracking)
		// Distance check comes before same-area labels so huge exterior areas still flag split teams.
		if(!isnull(distance) && distance > TEAM_LEAD_CLOSE_RANGE)
			if(tracking["area"] == lead_tracking["area"])
				return "[get_lead_offset_distance_label(tracking, lead_tracking)] (same area)"
			return get_lead_offset_distance_label(tracking, lead_tracking)
		if(tracking["area"] == lead_tracking["area"])
			return "Same area"
		return get_lead_offset_distance_label(tracking, lead_tracking)
	if(tracking["sector"] && tracking["sector"] == lead_tracking["sector"])
		return "Different z"
	return "Different contact"

/// Adds a currently selectable overmap destination contact to an associative contact/source list.
/datum/computer_file/program/comm_control/proc/add_available_destination_contact(var/list/contact_sources, var/obj/effect/overmap/visitable/contact, var/source)
	if(!istype(contact) || QDELETED(contact))
		return
	contact_sources[contact] = source

/// Returns currently selectable destination contacts and matching TGUI payload from Horizon sensors plus the default Horizon contact.
/datum/computer_file/program/comm_control/proc/get_available_destination_data(var/obj/effect/overmap/visitable/horizon, var/force_refresh = FALSE)
	var/static/list/destination_data_cache
	var/static/destination_data_cache_expires = 0
	if(!force_refresh && !isnull(destination_data_cache) && destination_data_cache_expires > world.time)
		return destination_data_cache

	var/list/contact_sources = list()
	if(istype(horizon))
		add_available_destination_contact(contact_sources, horizon, TEAM_DESTINATION_DEFAULT_SOURCE)

		if(horizon.consoles)
			for(var/obj/structure/machinery/computer/ship/sensors/sensor_console in horizon.consoles)
				for(var/obj/effect/overmap/visitable/contact as anything in sensor_console.objects_in_view)
					if(sensor_console.contact_datums[contact])
						add_available_destination_contact(contact_sources, contact, TEAM_DESTINATION_SENSOR_SOURCE)

				for(var/obj/effect/overmap/visitable/datalinked_ship as anything in sensor_console.datalink_contacts)
					var/list/datalinked_contacts = sensor_console.datalink_contacts[datalinked_ship]
					for(var/obj/effect/overmap/visitable/contact as anything in datalinked_contacts)
						if(sensor_console.contact_datums[contact])
							add_available_destination_contact(contact_sources, contact, TEAM_DESTINATION_DATALINK_SOURCE)

	destination_data_cache = list(
		"sources" = contact_sources,
		"contacts" = build_available_destination_contacts(contact_sources)
	)
	destination_data_cache_expires = world.time + 5 SECONDS
	return destination_data_cache

/// Builds the TGUI list of destination contacts command may currently assign to teams.
/datum/computer_file/program/comm_control/proc/build_available_destination_contacts(var/list/contact_sources)
	var/list/contacts = list()
	for(var/obj/effect/overmap/visitable/contact as anything in contact_sources)
		if(!istype(contact) || QDELETED(contact))
			continue
		contacts += list(list(
			"name" = contact.name,
			"ref" = "[REF(contact)]",
			"source" = contact_sources[contact]
		))
	return contacts

/// Builds destination context from stored team destination data and current legitimate Horizon sensor contacts.
/datum/computer_file/program/comm_control/proc/build_destination_context(var/datum/team/team, var/list/contact_sources, var/obj/effect/overmap/visitable/horizon)
	var/list/context = list(
		"name" = team.destination_name || "Unknown",
		"contact_status" = "unset"
	)

	var/obj/effect/overmap/visitable/contact = team.destination_overmap_ref?.resolve()
	if(!team.destination_overmap_ref)
		context["name"] = "Unset"
		return context

	if(!istype(contact) || QDELETED(contact))
		context["contact_status"] = "contact deleted"
		return context

	context["name"] = contact.name
	if(contact == horizon)
		context["contact_status"] = "default destination"
		return context

	if(contact_sources[contact])
		context["contact_status"] = "currently detected"
		return context

	context["contact_status"] = "contact lost"
	return context

/// Sends a command message to the full team or lead, aggregates delivery results, and logs degraded delivery.
/datum/computer_file/program/comm_control/proc/deliver_team_message(var/datum/team/team, var/target, var/message, var/mob/actor)
	var/list/delivery = list(
		"sent" = 0,
		"failed" = 0,
		"unknown" = 0
	)

	if(!message)
		return delivery
	message = sanitize(html_decode(message), MAX_MESSAGE_LEN, encode = FALSE)
	if(!message)
		return delivery

	var/list/member_keys = list()
	if(target == "lead")
		// A missing lead is not a hard error; it reports zero recipients and leaves an audit log.
		if(team.team_lead_member_key)
			member_keys += team.team_lead_member_key
	else
		// member_records is associative; copying it gives us stable member keys for this send pass.
		member_keys = team.member_records.Copy()

	for(var/member_key in member_keys)
		var/mob/living/carbon/human/member = team.resolve_member_live_mob(member_key)
		var/result = deliver_message_to_member(team, member, message)
		delivery[result]++

	// Log the attempted order even if some members cannot receive it, so command has a durable audit trail.
	var/action_name = target == "lead" ? "lead message set/send" : "team message set/send"
	team.append_log(action_name, actor, message)
	if(delivery["failed"] || delivery["unknown"])
		action_name = target == "lead" ? "lead message failure" : "team message failure"
		team.append_log("team message failure", actor, "[delivery["sent"]] sent, [delivery["failed"]] failed, [delivery["unknown"]] unknown.")
	return delivery

/// Attempts one team message delivery, checking live mob, NTNet communications, jamming, client state, and reachable z-levels.
/datum/computer_file/program/comm_control/proc/deliver_message_to_member(var/datum/team/team, var/mob/living/carbon/human/member, var/message)
	if(!istype(member))
		return "unknown"
	if(!get_signal(NTNET_COMMUNICATION))
		return "failed"
	if(!member.client || member.stat == DEAD)
		return "failed"
	if(within_jamming_range(member))
		return "failed"
	var/list/reachable_z_levels = GLOB.ntnet_global.get_reachable_z_levels(computer.network_card, NTNET_COMMUNICATION)
	// Live mob exists, but C3 app cannot route to that z-level through current NTNet coverage.
	if(!(GET_Z(member) in reachable_z_levels))
		return "unknown"

	var/full_message = "<b>C3 Directive - ([team.display_name]):</b> [message]"
	to_chat(member, SPAN_HIGHDANGER("<b>C3 Directive - ([team.display_name]):</b> [message]"))
	member.play_screen_text(full_message,/atom/movable/screen/text/screen_text/command_order,COLOR_RED)
	return "sent"

/// Reports aggregate delivery results back to the command operator.
/datum/computer_file/program/comm_control/proc/report_delivery(var/mob/user, var/list/delivery)
	to_chat(user, SPAN_NOTICE("Delivery: [delivery["sent"]] sent, [delivery["failed"]] failed, [delivery["unknown"]] unknown. Objectives remain stored in C3 app."))

GLOBAL_VAR_INIT(team_uid, 0)

/datum/team_cohesion_state
	/**
	 * We so fancy we even hysteresize this shit (different disjoin vs rejoin values means that if someone
	 * wiggles just barely in and out of range for group topology update, it doesnt keep forcing the UI to change.
	 *
	 * EX. if you moved 20 tiles away and are disjoined from the primary group, you won't be rejoined to that
	 * group until you step within 16. We need to see some COMMITMENT.
	 */
	var/list/edge_states
	var/published_signature
	var/pending_signature
	var/list/pending_member_states
	var/pending_since = 0

/datum/team_cohesion_state/New()
	..()
	edge_states = list()

/datum/team_cohesion_state/Destroy(force)
	edge_states = null
	pending_member_states = null
	return ..()

/datum/team_cohesion_state/proc/reset(var/clear_edges = TRUE)
	if(clear_edges || !edge_states)
		edge_states = list()
	published_signature = null
	pending_signature = null
	pending_member_states = null
	pending_since = 0

/datum/team_cohesion_state/proc/apply_candidate(var/datum/team/team, var/candidate_signature, var/candidate_summary, var/list/candidate_member_states, var/immediate = FALSE)
	if(!istype(team))
		return FALSE
	if(!candidate_signature)
		candidate_signature = "unavailable"
	if(!candidate_summary)
		candidate_summary = "Group topology unavailable"
	if(!candidate_member_states)
		candidate_member_states = list()

	if(immediate || isnull(published_signature) || candidate_signature == published_signature)
		team.group_member_states = candidate_member_states
		team.group_summary = candidate_summary
		published_signature = candidate_signature
		pending_signature = null
		pending_member_states = null
		pending_since = 0
		return TRUE

	if(candidate_signature != pending_signature)
		pending_signature = candidate_signature
		pending_member_states = candidate_member_states
		pending_since = world.time
		return FALSE

	pending_member_states = candidate_member_states
	if(world.time - pending_since < TEAM_COHESION_PUBLISH_GRACE)
		return FALSE

	team.group_member_states = pending_member_states
	team.group_summary = candidate_summary
	published_signature = candidate_signature
	pending_signature = null
	pending_member_states = null
	pending_since = 0
	return TRUE

/**
 * OORAH!
 */
/// Persistent round-local 'team' model.
/datum/team
	var/id
	/// Human-readable team name shown in Command and Communication, status panels, and manifests.
	var/display_name = "team"
	/// Weakref to the selected dest overmap object
	var/datum/weakref/destination_overmap_ref
	/// Cached name in case we lose contact or it gets deleted
	var/destination_name
	/// If we manually cleared the dest, don't try to jam it down our throats again if we lose and pick it back up.
	var/destination_manually_cleared = FALSE
	/// Weakref to the command operator currently claiming this team in Command and Communication.
	var/datum/weakref/operator_ref
	/// Member key for the assigned team lead.
	var/team_lead_member_key
	/// Associative map of member key to /datum/record/general for team membership.
	var/list/member_records
	/// Cached display names by member key so logs and UI can survive record loss
	var/list/last_known_member_display_names
	/// Stored primary objective text.
	var/primary_objective
	/// Stored secondary objective text.
	var/secondary_objective
	/// Team activity log entries for Command and Communication.
	var/list/log_entries
	/// Published group relationship keyed by member key, SSteam_cohesion biz
	var/list/group_member_states
	/// Human-readable current team topology summary.
	var/group_summary
	var/datum/team_cohesion_state/cohesion_state

/datum/team/New()
	..()
	id = "TEAM-[GLOB.team_uid++]"
	member_records = list()
	last_known_member_display_names = list()
	log_entries = list()
	reset_group_state()

/datum/team/Destroy(force)
	member_records = null
	last_known_member_display_names = null
	log_entries = null
	group_member_states = null
	QDEL_NULL(cohesion_state)
	operator_ref = null
	destination_overmap_ref = null
	return ..()

/datum/team/proc/append_log(var/action, var/actor, var/details)
	if(!log_entries)
		log_entries = list()

	var/actor_name = "System"
	if(istype(actor, /mob))
		var/mob/actor_mob = actor
		actor_name = actor_mob.real_name || actor_mob.name || "Unknown"
	else if(istext(actor))
		actor_name = actor

	log_entries += list(list(
		"time" = worldtime2text(),
		"world_time" = world.time,
		"action" = action,
		"actor" = actor_name,
		"details" = details
	))

/// Clears published and pending group topology after roster or lead changes
/datum/team/proc/reset_group_state(var/clear_edges = TRUE)
	group_member_states = list()
	if(!cohesion_state)
		cohesion_state = new()
	cohesion_state.reset(clear_edges)
	group_summary = team_lead_member_key ? "Group topology pending" : "No team lead assigned"

/// Publishes or stages a group topology candidate. Immediacy defaults false so we don't churn the UI too much.
/datum/team/proc/apply_group_candidate(var/signature, var/new_group_summary, var/list/new_group_member_states, var/immediate = FALSE)
	if(!cohesion_state)
		cohesion_state = new()
	return cohesion_state.apply_candidate(src, signature, new_group_summary, new_group_member_states, immediate)

/datum/team/proc/set_name(var/new_name, var/mob/actor)
	if(!new_name)
		return FALSE

	new_name = trim(new_name, MAX_NAME_LEN)
	if(!new_name)
		return FALSE
	if(display_name == new_name)
		return TRUE

	var/old_name = display_name || "Unknown"
	display_name = new_name
	append_log("team renamed", actor, "[old_name] -> [display_name]")
	SSrecords.reset_manifest()
	return TRUE

/// Looks up a member's general record by team member key
/datum/team/proc/get_member_record(var/member_key)
	if(!member_key || !member_records)
		return

	return member_records[member_key]

/// Resolves a member key to a live human by matching the stored general record name to human mobs
/datum/team/proc/resolve_member_live_mob(var/member_key)
	var/datum/record/general/general_record = get_member_record(member_key)
	if(!general_record?.name)
		return

	if(general_record.fingerprint && general_record.fingerprint != "Unknown")
		for(var/mob/living/carbon/human/human as anything in GLOB.human_mob_list)
			if(human.dna?.uni_identity && md5(human.dna.uni_identity) == general_record.fingerprint)
				return human

	for(var/mob/living/carbon/human/human as anything in GLOB.human_mob_list)
		if(human.real_name == general_record.name)
			return human

/// Adds or refreshes a general crew record as a team member and records the display name.
/datum/team/proc/add_member(var/datum/record/general/general_record, var/mob/actor, var/is_new = TRUE)
	if(!istype(general_record) || isnull(general_record.id))
		return FALSE

	var/member_key = "record:[general_record.id]"
	member_records[member_key] = general_record
	last_known_member_display_names[member_key] = general_record.name
	reset_group_state()

	append_log(is_new ? "member added" : "member updated", actor, general_record.name)
	return TRUE

/datum/team/proc/remove_member(var/member_key, var/mob/actor)
	if(!member_key || !member_records)
		return

	var/datum/record/general/general_record = member_records[member_key]
	if(!general_record)
		return

	if(team_lead_member_key == member_key)
		team_lead_member_key = null

	member_records -= member_key
	last_known_member_display_names -= member_key
	reset_group_state()
	append_log("member removed", actor, general_record.name)
	return general_record

/datum/team/proc/set_lead(var/member_key, var/new_lead_state, var/mob/actor)
	var/datum/record/general/general_record = member_records[member_key]
	if(!general_record)
		return FALSE

	if(!new_lead_state)
		if(team_lead_member_key == member_key)
			team_lead_member_key = null
			reset_group_state()
			append_log("lead changed", actor, "No team lead assigned.")
		return TRUE

	if(team_lead_member_key == member_key)
		return TRUE

	team_lead_member_key = member_key
	reset_group_state()
	append_log("lead changed", actor, general_record.name)
	return TRUE

/datum/team/proc/set_destination_overmap(var/obj/effect/overmap/visitable/destination_contact, var/mob/actor)
	if(!istype(destination_contact))
		return FALSE

	destination_overmap_ref = WEAKREF(destination_contact)
	destination_name = destination_contact.name
	destination_manually_cleared = FALSE
	append_log("destination changed", actor, destination_name)
	return TRUE

/datum/team/proc/clear_destination_overmap(var/mob/actor)
	if(!destination_overmap_ref && !destination_name)
		return TRUE

	var/old_destination = destination_name || "Unknown"
	destination_overmap_ref = null
	destination_name = null
	destination_manually_cleared = TRUE
	append_log("destination cleared", actor, old_destination)
	return TRUE

/datum/team/proc/apply_default_destination(var/obj/effect/overmap/visitable/default_destination)
	if(destination_manually_cleared || destination_overmap_ref || !istype(default_destination))
		return FALSE

	destination_overmap_ref = WEAKREF(default_destination)
	destination_name = default_destination.name
	return TRUE

/// Resolves the currently claimed command operator for display in C3 app and status panels.
/datum/team/proc/get_operator_name()
	var/mob/operator = operator_ref?.resolve()
	if(istype(operator))
		return operator.real_name || operator.name || "Unknown"
	return "Unassigned"

/// Resolves a team member key to a stable display name. Try for record first before trying cache before crapping out.
/datum/team/proc/get_member_display_name(var/member_key)
	var/datum/record/general/general_record = get_member_record(member_key)
	if(general_record?.name)
		return general_record.name
	if(last_known_member_display_names && last_known_member_display_names[member_key])
		return last_known_member_display_names[member_key]
	return "Unknown"

/datum/team/proc/get_lead_name()
	if(!team_lead_member_key)
		return "Unassigned"
	return get_member_display_name(team_lead_member_key)

/// Claims or force-claims operator ownership for a team, recording the action in team logs.
/datum/team/proc/set_operator(var/mob/operator, var/force = FALSE)
	if(!istype(operator))
		return FALSE

	var/mob/current_operator = operator_ref?.resolve()
	if(current_operator && current_operator != operator && !force)
		return FALSE

	operator_ref = WEAKREF(operator)
	append_log(force && current_operator && current_operator != operator ? "operator overridden" : "operator claimed", operator, get_operator_name())
	return TRUE

/datum/team/proc/release_operator(var/mob/operator)
	var/old_operator = get_operator_name()
	operator_ref = null
	append_log("operator released", operator, old_operator)
	return TRUE

/// Gets Objective text.
/datum/team/proc/get_objective_text(var/objective_slot)
	switch(objective_slot)
		if(TEAM_OBJECTIVE_PRIMARY)
			return primary_objective
		if(TEAM_OBJECTIVE_SECONDARY)
			return secondary_objective

/// Stupid spinoff proc to make logging less of a PITA.
/datum/team/proc/get_objective_label(var/objective_slot)
	switch(objective_slot)
		if(TEAM_OBJECTIVE_PRIMARY)
			return "primary"
		if(TEAM_OBJECTIVE_SECONDARY)
			return "secondary"
	return "unknown"

/datum/team/proc/set_objective(var/objective_slot, var/objective_text, var/mob/actor)
	if(!objective_text)
		return FALSE

	switch(objective_slot)
		if(TEAM_OBJECTIVE_PRIMARY)
			primary_objective = objective_text
		if(TEAM_OBJECTIVE_SECONDARY)
			secondary_objective = objective_text
		else
			return FALSE

	append_log("[get_objective_label(objective_slot)] objective set", actor, objective_text)
	SSrecords.reset_manifest()
	return TRUE

/datum/team/proc/clear_objective(var/objective_slot, var/mob/actor)
	switch(objective_slot)
		if(TEAM_OBJECTIVE_PRIMARY)
			primary_objective = null
		if(TEAM_OBJECTIVE_SECONDARY)
			secondary_objective = null
		else
			return FALSE

	append_log("[get_objective_label(objective_slot)] objective cleared", actor)
	SSrecords.reset_manifest()
	return TRUE

/// Logs an objective reminder; delivery is handled by the actual app ui_act.
/datum/team/proc/log_remind_objective(var/objective_slot, var/mob/actor)
	if(!get_objective_text(objective_slot))
		return FALSE
	if(!(objective_slot in list(TEAM_OBJECTIVE_PRIMARY, TEAM_OBJECTIVE_SECONDARY)))
		return FALSE

	append_log("[get_objective_label(objective_slot)] objective reminded", actor, get_objective_text(objective_slot))
	return TRUE

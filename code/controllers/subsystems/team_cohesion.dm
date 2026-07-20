SUBSYSTEM_DEF(team_cohesion)
	name = "Team Cohesion"
	wait = 2 SECONDS
	flags = SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/currentrun = list()
	var/list/current_sensor_lookup

/**
 * TLDR, team grouping is interpreted using pairwise connectedness, not simple vicinity.
 * TLDRTLDR, stick close? group. go far away? straggler.
 *
 * GROUPS, BANDS, OFFSETS, AND YOU
 * The team monitoring component of the Command and Communications is able to dynamically describe
 * the relative positioning of crew members within a Team by treating that Team as a graph topology.
 * (The below sketches are one-dimensional just to demonstrate; we use two-dimensional graphs in-game.)
 *
 * Consider the following arrangement of crew members:
 *  [A]   [B]   [C]        [D]                     [E]  [F]                     [G]
 *
 * Graph topology says we treat our crew members as nodes and the relationships between those nodes as edges.
 * Edges are created when crew members are close enough together. They're broken when they're too far apart.
 * A set of nodes is a graph- what we call our 'group' or 'subgroup' or 'isolate'.
 *
 * GROUPS
 * Every two seconds, the Team Cohesion subsystem checks distances between crew members within a given team.
 * If a pair of crew members are close enough, they'll form a graph, and be displayed in the app as part of
 * a GROUP. The Team Leader always composes the 'Primary Group'; in-app, any other detached clusters crew
 * members are called 'Detached Subgroups', and any separated stragglers are called 'Isolates'.
 *
 *  [A]---[B]---[C]- - - - [D]                     [E]--[F]                      [G]
 * ^----------GROUP1----------^                   ^-GROUP2-^                  ^-GROUP3-^
 *       (Primary Group)                      (Detached Subgroup)              (Isolate)
 *
 * BANDS
 * In the sketch above, crew members close together had edges marked as '---', but [D] is starting to lag behind.
 * That luckless crewmember hasn't gotten too far behind to lose membership of GROUP1, but that edge is really
 * getting too long for comfort.
 *
 * Edges are displayed in-app as 'Bands'. If the shortest edge between two nodes gets too long, you'll see that
 * crew member's "Band" column change from 'Close' to 'Extended'. This is when Command should maybe yell at you,
 * and at your Team Leader for letting you straggle.
 *
 * OFFSETS
 * No more topology. Yay. Offsets aren't managed in the Team Cohesion subsystem, but for reference, Offsets simply
 * describe the distance of the given crew member from their Team Leader and in what direction.
 */

/datum/controller/subsystem/team_cohesion/stat_entry(msg)
	msg = "T:[length(SSrecords?.teams)]"
	return ..()

/datum/controller/subsystem/team_cohesion/fire(resumed = FALSE)
	if(!SSrecords?.teams)
		return

	if(!resumed)
		src.currentrun = SSrecords.teams.Copy()
		src.current_sensor_lookup = build_sensor_lookup()

	var/list/team_run = src.currentrun
	while(length(team_run))
		var/datum/team/team = team_run[length(team_run)]
		team_run.len--

		if(istype(team) && !QDELETED(team))
			update_team(team, src.current_sensor_lookup)

		if(MC_TICK_CHECK)
			return

	src.current_sensor_lookup = null

/// Builds a global sensor lookup from NTNet-routed z-levels only; local UI signal checks still happen in C3 app.
/datum/controller/subsystem/team_cohesion/proc/build_sensor_lookup()
	if(!GLOB.ntnet_global?.check_function(NTNET_COMMUNICATION) || !GLOB.crew_repository)
		return build_crew_sensor_lookup()

	return build_crew_sensor_lookup(get_routed_z_levels())

/// Returns every z-level covered by an NTNet relay that can currently route communications to a core.
/datum/controller/subsystem/team_cohesion/proc/get_routed_z_levels()
	. = list()
	if(!GLOB.ntnet_global)
		return

	for(var/obj/structure/machinery/ntnet_relay/relay as anything in GLOB.ntnet_global.relays)
		if(relay.can_route_to_core())
			. |= relay.get_covered_z_levels()

/// Refreshes one team's cached group topology.
/datum/controller/subsystem/team_cohesion/proc/update_team(var/datum/team/team, var/list/sensor_lookup)
	var/list/member_keys = list()
	if(team?.member_records)
		for(var/member_key in team.member_records)
			member_keys += member_key
	if(!length(member_keys))
		team.apply_group_candidate("empty", "No members assigned", list(), TRUE)
		return

	if(!team.team_lead_member_key)
		team.apply_group_candidate("no_lead", "No team lead assigned", build_unavailable_group_member_states(member_keys, "No lead assigned"), TRUE)
		return

	var/list/tracking_by_key = list()
	for(var/member_key in member_keys)
		var/datum/record/general/general_record = team.get_member_record(member_key)
		var/mob/living/carbon/human/live_member = team.resolve_member_live_mob(member_key)
		var/list/tracking = build_crew_tracking_sample(get_crew_sensor_data_for_member(general_record, live_member, sensor_lookup))
		if(tracking)
			tracking_by_key[member_key] = tracking

	var/list/lead_tracking = tracking_by_key[team.team_lead_member_key]
	if(!lead_tracking || !lead_tracking["tracking"])
		team.apply_group_candidate("lead_untracked", "Lead not tracking", build_unavailable_group_member_states(member_keys, "Lead not tracking"), TRUE)
		return

	var/list/group_candidate = build_group_candidate(team, member_keys, tracking_by_key)
	if(!team.cohesion_state)
		team.cohesion_state = new()
	team.cohesion_state.edge_states = group_candidate["edge_states"]
	team.apply_group_candidate(group_candidate["signature"], group_candidate["summary"], group_candidate["member_states"])

/// Builds neutral member state rows for unavailable group states.
/datum/controller/subsystem/team_cohesion/proc/build_unavailable_group_member_states(var/list/member_keys, var/label)
	. = list()
	for(var/member_key in member_keys)
		.[member_key] = list(
			"relationship" = label,
			"group_type" = "unavailable",
			"group_sort" = 5000
		)

/// Builds one complete group topology candidate without publishing it
/datum/controller/subsystem/team_cohesion/proc/build_group_candidate(var/datum/team/team, var/list/member_keys, var/list/tracking_by_key)
	var/list/edge_graph = build_group_edge_graph(team, member_keys, tracking_by_key)
	var/list/connected_components = build_group_components(member_keys, tracking_by_key, edge_graph["adjacency"])
	var/list/component_candidate = build_group_component_candidate(team, member_keys, tracking_by_key, connected_components)

	return list(
		"edge_states" = edge_graph["edge_states"],
		"member_states" = component_candidate["member_states"],
		"summary" = component_candidate["summary"],
		"signature" = component_candidate["signature"]
	)

/// Builds pairwise proximity edges and adjacency lists from tracked team members.
/datum/controller/subsystem/team_cohesion/proc/build_group_edge_graph(var/datum/team/team, var/list/member_keys, var/list/tracking_by_key)
	var/list/adjacency = list()
	var/list/new_group_edge_states = list()
	for(var/member_key in member_keys)
		adjacency[member_key] = list()

	var/i = 1
	while(i < member_keys.len)
		var/member_key_a = member_keys[i]
		var/list/tracking_a = tracking_by_key[member_key_a]
		var/j = i + 1
		while(j <= member_keys.len)
			var/member_key_b = member_keys[j]
			var/list/tracking_b = tracking_by_key[member_key_b]
			var/pair_key = "[member_key_a]|[member_key_b]"

			if(should_group_members_connect(team, pair_key, tracking_a, tracking_b))
				new_group_edge_states[pair_key] = TRUE
				adjacency[member_key_a] += member_key_b
				adjacency[member_key_b] += member_key_a

			j++
		i++

	return list(
		"adjacency" = adjacency,
		"edge_states" = new_group_edge_states
	)

/// Builds published member labels, summary text, and topology signature from connected crew
/datum/controller/subsystem/team_cohesion/proc/build_group_component_candidate(var/datum/team/team, var/list/member_keys, var/list/tracking_by_key, var/list/connected_components)
	var/list/group_member_states = list()
	var/list/signature_parts = list()
	var/total_members = length(member_keys)
	var/leader_component_index = 0

	for(var/component_index = 1 to connected_components.len)
		var/list/component = connected_components[component_index]
		if(team.team_lead_member_key in component)
			leader_component_index = component_index
			break

	var/detached_subgroups = 0
	var/minor_detached_groups = 0
	var/isolated_members = 0
	var/untracked_members = 0
	var/leader_component_size = 0
	var/max_leader_distance = 0

	for(var/component_index = 1 to connected_components.len)
		var/list/component = connected_components[component_index]
		var/component_size = length(component)
		var/is_leader_component = component_index == leader_component_index
		var/group_type = "isolated"
		var/relationship = "Isolated"
		var/group_sort = 3000

		if(is_leader_component)
			group_type = "main_body"
			relationship = "Main body"
			group_sort = 0
			leader_component_size = component_size
			for(var/member_key in component)
				var/list/member_tracking = tracking_by_key[member_key]
				var/list/leader_tracking = tracking_by_key[team.team_lead_member_key]
				var/distance = get_crew_tracking_distance(member_tracking, leader_tracking)
				if(!isnull(distance))
					max_leader_distance = max(max_leader_distance, distance)
		else if(component_size == 1)
			isolated_members++
		else if(component_size >= TEAM_COHESION_SUBGROUP_MIN_MEMBERS && (component_size / total_members) >= TEAM_COHESION_SUBGROUP_MIN_RATIO)
			group_type = "detached_subgroup"
			relationship = "Detached subgroup"
			group_sort = 1000 - component_size
			detached_subgroups++
		else
			group_type = "minor_detached_group"
			relationship = "Minor detached group"
			group_sort = 2000 - component_size
			minor_detached_groups++

		var/group_signature_id = "component-[component_index]"
		var/display_relationship = relationship
		if(component_size > 1 && group_type in list("main_body", "detached_subgroup", "minor_detached_group"))
			display_relationship = "[relationship] ([component_size])"

		for(var/member_key in component)
			group_member_states[member_key] = list(
				"relationship" = display_relationship,
				"group_type" = group_type,
				"group_sort" = group_sort
			)
			signature_parts += "[member_key]=[group_type]:[group_signature_id]"

	for(var/member_key in member_keys)
		var/list/tracking = tracking_by_key[member_key]
		if(tracking && tracking["tracking"])
			continue

		untracked_members++
		group_member_states[member_key] = list(
			"relationship" = "No tracking data",
			"group_type" = "untracked",
			"group_sort" = 4000
		)
		signature_parts += "[member_key]=untracked"

	var/group_summary = build_group_topology(connected_components.len, detached_subgroups, minor_detached_groups, isolated_members, untracked_members, leader_component_size, max_leader_distance)
	var/signature = "[jointext(signature_parts, ";")]"
	return list(
		"member_states" = group_member_states,
		"summary" = group_summary,
		"signature" = signature
	)

/// TRUE when two tracked crew should share a graph edge this tick.
/datum/controller/subsystem/team_cohesion/proc/should_group_members_connect(var/datum/team/team, var/pair_key, var/list/tracking_a, var/list/tracking_b)
	if(!tracking_a || !tracking_b || !tracking_a["tracking"] || !tracking_b["tracking"])
		return FALSE
	if(tracking_a["z"] != tracking_b["z"])
		return FALSE

	var/distance = get_crew_tracking_distance(tracking_a, tracking_b)
	if(isnull(distance))
		return FALSE
	if(distance <= TEAM_COHESION_EDGE_CONNECT_RANGE)
		return TRUE
	var/datum/team_cohesion_state/cohesion_state = team.cohesion_state
	if(cohesion_state?.edge_states && cohesion_state.edge_states[pair_key] && distance <= TEAM_COHESION_EDGE_DISCONNECT_RANGE)
		return TRUE
	return FALSE

/// Finds same-z tracked connected crew
/datum/controller/subsystem/team_cohesion/proc/build_group_components(var/list/member_keys, var/list/tracking_by_key, var/list/adjacency)
	. = list()
	var/list/visited = list()
	for(var/member_key in member_keys)
		var/list/tracking = tracking_by_key[member_key]
		if(!tracking || !tracking["tracking"] || visited[member_key])
			continue

		var/list/component = list()
		var/list/queue = list(member_key)
		visited[member_key] = TRUE
		while(length(queue))
			var/current_member_key = queue[length(queue)]
			queue.len--
			component += current_member_key

			for(var/neighbor_key in adjacency[current_member_key])
				if(visited[neighbor_key])
					continue
				visited[neighbor_key] = TRUE
				queue += neighbor_key

		. += list(component)

/// Builds the summary text for current group topology
/datum/controller/subsystem/team_cohesion/proc/build_group_topology(var/component_count, var/detached_subgroups, var/minor_detached_groups, var/isolated_members, var/untracked_members, var/leader_component_size, var/max_leader_distance)
	var/summary = "Unified main body"
	if(detached_subgroups > 1 || (detached_subgroups && (minor_detached_groups || isolated_members)))
		summary = "Multiple detached subgroups"
	else if(detached_subgroups || minor_detached_groups)
		summary = "Detached subgroup"
	else if(isolated_members)
		if(leader_component_size <= 1 && isolated_members >= 2)
			summary = "Dispersed from leader"
		else
			summary = "Unified with detached individual[isolated_members == 1 ? "" : "s"]"
	else if(untracked_members)
		summary = "Partial tracking data"
	else if(component_count <= 1 && max_leader_distance > TEAM_LEAD_BAND_EXTENDED_RANGE)
		summary = "Extended main body"

	return summary

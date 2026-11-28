// Cross-round persistence and IRL-time decay for unlocked research technology nodes via SSpersistence.

/singleton/persistent_type/generic/research_tech_nodes
	title = "Research Tech Nodes"
	description = "Unlocked research technology nodes and invested maintenance points across rounds."
	/// Associative list of node_id -> invested points.
	var/list/node_investments = list()
	/// Real-world timestamp (world.realtime) of the last decay calculation.
	var/last_decay_time = 0
	/// Whether initialization completed successfully. Prevents a failed load from overwriting saved data.
	var/research_initialized = FALSE

/** Loads persisted node investments from SSpersistence and applies outermost-node decay for elapsed IRL time. */
/singleton/persistent_type/generic/research_tech_nodes/initialization_hook()
	node_investments = list()
	last_decay_time = 0
	research_initialized = FALSE
	if(!SSpersistence.map_supports_persistence)
		return

	var/datum/persistent_generic/saved_generic = SSpersistence.genericLoad(/singleton/persistent_type/generic/research_tech_nodes, skip_caching = TRUE)
	var/list/saved_data = saved_generic?.content
	if(islist(saved_data))
		last_decay_time = text2num("[saved_data["last_decay_time"]]") || 0
		var/list/saved_nodes = saved_data["nodes"]
		if(islist(saved_nodes))
			for(var/node_id in saved_nodes)
				var/datum/tech_node/N = GLOB.tech_nodes[node_id]
				if(!N || N.starts_unlocked || N.antag_tech || N.cost <= 0)
					continue
				var/pts = text2num("[saved_nodes[node_id]]") || 0
				if(pts > 0)
					node_investments[node_id] = min(N.cost, pts)

	// Ensure prerequisites are respected if a parent node is missing
	for(var/node_id in node_investments.Copy())
		var/datum/tech_node/N = GLOB.tech_nodes[node_id]
		for(var/prereq_id in N.prereq_ids)
			var/datum/tech_node/P = GLOB.tech_nodes[prereq_id]
			if(P && !P.starts_unlocked && !(prereq_id in node_investments))
				node_investments -= node_id
				break

	apply_decay(world.realtime)
	research_initialized = TRUE

/** Saves current unlocked node investments and decay timestamp to SSpersistence at round end. */
/singleton/persistent_type/generic/research_tech_nodes/finalization_hook()
	if(!research_initialized)
		return

	var/list/payload = list(
		"last_decay_time" = last_decay_time || world.realtime,
		"nodes" = node_investments.Copy()
	)
	SSpersistence.genericSave(/singleton/persistent_type/generic/research_tech_nodes, payload)

/singleton/persistent_type/generic/research_tech_nodes/proc/is_outermost_node(node_id)
	if(!(node_id in node_investments))
		return FALSE
	var/datum/tech_node/N = GLOB.tech_nodes[node_id]
	if(!N || N.starts_unlocked || N.cost <= 0)
		return FALSE
	for(var/other_id in node_investments)
		if(other_id == node_id)
			continue
		var/datum/tech_node/other = GLOB.tech_nodes[other_id]
		if(other && (node_id in other.prereq_ids))
			return FALSE
	return TRUE

/singleton/persistent_type/generic/research_tech_nodes/proc/apply_decay(current_time = world.realtime)
	if(!last_decay_time)
		last_decay_time = current_time
		return
	var/elapsed = current_time - last_decay_time
	if(elapsed <= 0)
		return

	var/days_elapsed = elapsed / (1 DAYS)
	var/list/outermost = list()
	for(var/node_id in node_investments)
		if(is_outermost_node(node_id))
			outermost += node_id

	for(var/node_id in outermost)
		var/datum/tech_node/N = GLOB.tech_nodes[node_id]
		if(!N)
			continue
		var/decay = round(N.cost * days_elapsed)
		if(decay <= 0)
			continue
		var/remaining = node_investments[node_id] - decay
		if(remaining <= 0)
			node_investments -= node_id
		else
			node_investments[node_id] = remaining

	last_decay_time = current_time

/singleton/persistent_type/generic/research_tech_nodes/proc/record_investment(node_id, new_amount)
	var/datum/tech_node/N = GLOB.tech_nodes[node_id]
	if(!N || N.starts_unlocked || N.antag_tech || N.cost <= 0)
		return
	if(new_amount <= 0)
		node_investments -= node_id
	else
		node_investments[node_id] = min(N.cost, round(new_amount))
	if(!last_decay_time)
		last_decay_time = world.realtime

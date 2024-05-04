// These involve BYOND's built in filters that do visual effects, and not stuff that distinguishes between things.

// All of this ported from TG.
// And then ported to Nebula from Polaris.
// And then ported to Aurora
/atom/movable
	var/list/filter_data // For handling persistent filters

/proc/cmp_filter_data_priority(list/A, list/B)
	return A["priority"] - B["priority"]

// Defining this for future proofing and ease of searching for erroneous usage.
/image/proc/add_filter(filter_name, priority, list/params)
	filters += filter(arglist(params))

/atom/movable/proc/add_filter(filter_name, priority, list/params)
	LAZYINITLIST(filter_data)
	var/list/p = params.Copy()
	p["priority"] = priority
	filter_data[filter_name] = p
	update_filters()

/atom/movable/proc/update_filters()
	filters = null
	filter_data = sortTim(filter_data, GLOBAL_PROC_REF(cmp_filter_data_priority), TRUE)
	for(var/f in filter_data)
		var/list/data = filter_data[f]
		var/list/arguments = data.Copy()
		arguments -= "priority"
		filters += filter(arglist(arguments))
	UPDATE_OO_IF_PRESENT

/atom/movable/proc/get_filter(filter_name)
	if(filter_data && filter_data[filter_name])
		return filters[filter_data.Find(filter_name)]

// Polaris Extensions
/atom/movable/proc/remove_filter(filter_name)
	var/thing = get_filter(filter_name)
	if(thing)
		LAZYREMOVE(filter_data, filter_name)
		filters -= thing
		update_filters()

/// Animate a given filter on this atom. All params after the first are passed to animate().
/atom/movable/proc/animate_filter(filter_name, list/params)
	if (!filter_data || !filter_data[filter_name])
		return

	var/list/monkeypatched_params = params.Copy()
	monkeypatched_params.Insert(1, null)
	var/index = filter_data.Find(filter_name)

	// First, animate ourselves.
	monkeypatched_params[1] = filters[index]
	animate(arglist(monkeypatched_params))

	// If we're being copied by Z-Mimic, update mimics too.
	if (bound_overlay)
		for (var/atom/movable/AM as anything in get_above_oo())
			monkeypatched_params[1] = AM.filters[index]
			animate(arglist(monkeypatched_params))

/** Update a filter's parameter to the new one. If the filter doesnt exist we won't do anything.
 *
 * Arguments:
 * * name - Filter name
 * * new_params - New parameters of the filter
 * * overwrite - TRUE means we replace the parameter list completely. FALSE means we only replace the things on new_params.
 */
/atom/movable/proc/modify_filter(filter_name, list/new_params, overwrite = FALSE)
	var/filter = get_filter(filter_name)
	if(!filter)
		return
	if(overwrite)
		filter_data[name] = new_params
	else
		for(var/thing in new_params)
			filter_data[name][thing] = new_params[thing]
	update_filters()

/// Updates the priority of the passed filter key
/atom/movable/proc/change_filter_priority(name, new_priority)
	if(!filter_data || !filter_data[name])
		return

	filter_data[name]["priority"] = new_priority
	update_filters()

/// Returns the indice in filters of the given filter name.
/// If it is not found, returns null.
/atom/movable/proc/get_filter_index(name)
	return filter_data?.Find(name)

/atom/movable/proc/clear_filters()
	ASSERT(isatom(src) || isimage(src))
	var/atom/atom_cast = src // filters only work with images or atoms.
	filter_data = null
	atom_cast.filters = null

/** Update a filter's parameter and animate this change. If the filter doesnt exist we won't do anything.
 * Basically a [datum/proc/modify_filter] call but with animations. Unmodified filter parameters are kept.
 *
 * Arguments:
 * * name - Filter name
 * * new_params - New parameters of the filter
 * * time - time arg of the BYOND animate() proc.
 * * easing - easing arg of the BYOND animate() proc.
 * * loop - loop arg of the BYOND animate() proc.
 */
/atom/movable/proc/transition_filter(name, list/new_params, time, easing, loop)
	var/filter = get_filter(name)
	if(!filter)
		return
	// This can get injected by the filter procs, we want to support them so bye byeeeee
	new_params -= "type"
	animate(filter, new_params, time = time, easing = easing, loop = loop)
	modify_filter(name, new_params)

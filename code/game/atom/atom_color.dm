/*
 * Atom colour priority support.
 *
 * This is the local subset of tg's atom colour pipeline needed by plane
 * masters, debug lighting visualization, and future plane-cube consumers.
 */

/atom
	/// Priority-indexed colors or color filters applied to this atom.
	var/list/atom_colours
	/// Currently applied color filter params, if atom_colours selected a filter.
	var/list/cached_color_filter

/// Adds or replaces the atom colour at the supplied priority.
/atom/proc/add_atom_colour(coloration, colour_priority)
	if(!coloration)
		return
	if(!atom_colours || !atom_colours.len)
		atom_colours = list()
		atom_colours.len = COLOUR_PRIORITY_AMOUNT
	if(colour_priority > atom_colours.len)
		return

	var/color_type = ATOM_COLOR_TYPE_NORMAL
	if(islist(coloration))
		var/list/color_matrix = coloration
		if(color_matrix["type"] == "color")
			color_type = ATOM_COLOR_TYPE_FILTER

	atom_colours[colour_priority] = list(coloration, color_type)
	update_atom_colour()

/// Removes the atom colour at the supplied priority, optionally matching a specific color.
/atom/proc/remove_atom_colour(colour_priority, coloration)
	if(!atom_colours || colour_priority > atom_colours.len)
		return

	var/list/current_colour = atom_colours[colour_priority]
	if(coloration && current_colour)
		if(current_colour[ATOM_COLOR_TYPE_INDEX] == ATOM_COLOR_TYPE_NORMAL)
			if(current_colour[ATOM_COLOR_VALUE_INDEX] != coloration)
				return
		else if(!islist(coloration) || !compare_list(coloration, current_colour[ATOM_COLOR_VALUE_INDEX]["color"]))
			return

	atom_colours[colour_priority] = null
	update_atom_colour()

/// Returns TRUE if this atom has the supplied colour in the requested priority range.
/atom/proc/is_atom_colour(looking_for_color, min_priority_index = 1, max_priority_index = COLOUR_PRIORITY_AMOUNT)
	if(!islist(looking_for_color))
		looking_for_color = lowertext(looking_for_color)

	if(!LAZYLEN(atom_colours))
		if(!islist(color))
			return lowertext(color) == looking_for_color
		return islist(looking_for_color) && compare_list(color, looking_for_color)

	for(var/i in min_priority_index to max_priority_index)
		var/list/current_colour = atom_colours[i]
		if(!current_colour)
			continue

		if(!islist(looking_for_color))
			if(islist(current_colour[ATOM_COLOR_VALUE_INDEX]))
				continue
			if(lowertext(current_colour[ATOM_COLOR_VALUE_INDEX]) == looking_for_color)
				return TRUE
			continue

		var/list/compared_matrix = current_colour[ATOM_COLOR_VALUE_INDEX]
		if(current_colour[ATOM_COLOR_TYPE_INDEX] == ATOM_COLOR_TYPE_FILTER)
			compared_matrix = current_colour[ATOM_COLOR_VALUE_INDEX]["color"]
		if(compare_list(looking_for_color, compared_matrix))
			return TRUE

	return FALSE

/// Applies the highest-priority active atom colour.
/atom/proc/update_atom_colour()
	color = null
	cached_color_filter = null
	remove_filter(ATOM_PRIORITY_COLOR_FILTER)

	if(!LAZYLEN(atom_colours))
		return

	for(var/list/current_colour as anything in atom_colours)
		if(!current_colour)
			continue
		if(current_colour[ATOM_COLOR_TYPE_INDEX] == ATOM_COLOR_TYPE_FILTER)
			add_filter(ATOM_PRIORITY_COLOR_FILTER, ATOM_PRIORITY_COLOR_FILTER_PRIORITY, current_colour[ATOM_COLOR_VALUE_INDEX])
			cached_color_filter = current_colour[ATOM_COLOR_VALUE_INDEX]
			return
		if(length(current_colour[ATOM_COLOR_VALUE_INDEX]))
			color = current_colour[ATOM_COLOR_VALUE_INDEX]
			return


///Returns the src and all recursive contents as a list.
/atom/proc/get_all_contents(ignore_flag_1)
	. = list(src)
	var/i = 0
	while(i < length(.))
		var/atom/checked_atom = .[++i]
		if(checked_atom.flags_1 & ignore_flag_1)
			continue
		. += checked_atom.contents

///identical to get_all_contents but returns a list of atoms of the type passed in the argument.
/atom/proc/get_all_contents_type(type)
	var/list/processing_list = list(src)
	. = list()
	while(length(processing_list))
		var/atom/checked_atom = processing_list[1]
		processing_list.Cut(1, 2)
		processing_list += checked_atom.contents
		if(istype(checked_atom, type))
			. += checked_atom

///Like get_all_contents_type, but uses a typecache list as argument
/atom/proc/get_all_contents_ignoring(list/ignore_typecache)
	if(!length(ignore_typecache))
		return get_all_contents()
	var/list/processing = list(src)
	. = list()
	var/i = 0
	while(i < length(processing))
		var/atom/checked_atom = processing[++i]
		if(ignore_typecache[checked_atom.type])
			continue
		processing += checked_atom.contents
		. += checked_atom

///similar function to range(), but with no limitations on the distance; will search spiralling outwards from the center
///NOT Z-Level aware
/proc/spiral_range(dist = 0, center = usr, orange = FALSE)
	var/list/atom_list = list()
	var/turf/t_center = get_turf(center)
	if(!t_center)
		return list()

	if(!orange)
		atom_list += t_center
		atom_list += t_center.contents

	if(!dist)
		return atom_list


	var/turf/checked_turf
	var/y
	var/x
	var/c_dist = 1


	while( c_dist <= dist )
		y = t_center.y + c_dist
		x = t_center.x - c_dist + 1
		for(x in x to t_center.x + c_dist)
			checked_turf = locate(x, y, t_center.z)
			if(checked_turf)
				atom_list += checked_turf
				atom_list += checked_turf.contents

		y = t_center.y + c_dist - 1
		x = t_center.x + c_dist
		for(y in t_center.y - c_dist to y)
			checked_turf = locate(x, y, t_center.z)
			if(checked_turf)
				atom_list += checked_turf
				atom_list += checked_turf.contents

		y = t_center.y - c_dist
		x = t_center.x + c_dist - 1
		for(x in t_center.x - c_dist to x)
			checked_turf = locate(x, y, t_center.z)
			if(checked_turf)
				atom_list += checked_turf
				atom_list += checked_turf.contents

		y = t_center.y - c_dist + 1
		x = t_center.x - c_dist
		for(y in y to t_center.y + c_dist)
			checked_turf = locate(x, y, t_center.z)
			if(checked_turf)
				atom_list += checked_turf
				atom_list += checked_turf.contents
		c_dist++

	return atom_list

///Returns the last atom type in the specified loc
/proc/get_highest_loc(atom/loc, type)
	var/atom/last_found = null
	while(loc)
		if(istype(loc, type))
			last_found = loc
		loc = loc.loc
	return last_found

/// Returns an x and y value require to reverse the transformations made to center an oversized icon
/atom/proc/get_oversized_icon_offsets()
	if (pixel_x == 0 && pixel_y == 0)
		return list("x" = 0, "y" = 0)
	var/list/icon_dimensions = get_icon_dimensions(icon)
	var/icon_width = icon_dimensions["width"]
	var/icon_height = icon_dimensions["height"]
	return list(
		"x" = icon_width > world.icon_size && pixel_x != 0 ? (icon_width - world.icon_size) * 0.5 : 0,
		"y" = icon_height > world.icon_size && pixel_y != 0 ? (icon_height - world.icon_size) * 0.5 : 0,
	)

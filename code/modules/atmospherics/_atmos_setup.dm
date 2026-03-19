//--------------------------------------------
// Pipe colors
//
// Add them here and to the GLOB.pipe_colors list
//  to automatically add them to all relevant
//  atmospherics devices.
//--------------------------------------------

/proc/pipe_color_lookup(var/color)
	for(var/C in GLOB.pipe_colors)
		if(color == GLOB.pipe_colors[C])
			return "[C]"

/proc/pipe_color_check(var/color)
	if(!color)
		return TRUE
	for(var/C in GLOB.pipe_colors)
		if(color == GLOB.pipe_colors[C])
			return TRUE
	return FALSE

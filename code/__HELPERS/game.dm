//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/proc/max_default_z_level()
	var/max_z = 0
	for(var/z in SSmapping.levels_by_trait(ZTRAIT_STATION))
		max_z = max(z, max_z)
	for(var/z in SSatlas.current_map.admin_levels)
		max_z = max(z, max_z)
	for(var/z in SSatlas.current_map.player_levels)
		max_z = max(z, max_z)
	return max_z

/proc/get_area_name(N) //get area by its name
	for(var/area/A in get_sorted_areas())
		if(A.name == N)
			return A
	return 0

/proc/get_area_master(const/O)
	var/area/A = get_area(O)
	if (isarea(A))
		return A

/proc/in_range(source, user)
	if(get_dist(source, user) <= 1)
		return 1

	return 0 //not in range and not telekinetic

// Will recursively loop through an atom's locs until it finds the atom loc above a turf or its target_atom
/proc/recursive_loc_turf_check(var/atom/O, var/recursion_limit = 3, var/atom/target_atom)
	if(recursion_limit <= 0 || isturf(O.loc) || O == target_atom)
		return O
	else
		O = O.loc
		recursion_limit--
		return recursive_loc_turf_check(O, recursion_limit)

/**
 * Get the last `/atom` before reaching a `/turf` following the `.loc` nesting
 *
 * Eg. if A is inside B that is inside C that is on a turf, it will return C
 *
 * * source - The source on which to start the search for, either an `/obj` or `/mob`
 */
/proc/get_last_atom_before_turf(atom/source)
	SHOULD_NOT_SLEEP(TRUE)
	RETURN_TYPE(/atom)

	if(istype(source, /area))
		stack_trace("Areas are not supported for this!")
		return FALSE

	if(istype(source, /turf))
		stack_trace("Turfs are not supported for this!")
		return FALSE


	var/atom/last_atom_before_turf = source

	while(istype(last_atom_before_turf) && !isturf(last_atom_before_turf.loc))
		if(!(last_atom_before_turf.loc))
			stack_trace("Somehow we reached a null loc without finding a turf on our path, possibly the object is in nullspace, or something has gone terribly wrong!")
			return FALSE

		last_atom_before_turf = last_atom_before_turf.loc

	return last_atom_before_turf

/proc/get_cardinal_step_away(atom/start, atom/finish) //returns the position of a step from start away from finish, in one of the cardinal directions
	//returns only NORTH, SOUTH, EAST, or WEST
	var/dx = finish.x - start.x
	var/dy = finish.y - start.y
	if(abs(dy) > abs (dx)) //slope is above 1:1 (move horizontally in a tie)
		if(dy > 0)
			return get_step(start, SOUTH)
		else
			return get_step(start, NORTH)
	else
		if(dx > 0)
			return get_step(start, WEST)
		else
			return get_step(start, EAST)

/proc/get_mob_by_key(var/key)
	for(var/mob/M in GLOB.mob_list)
		if(M.ckey == lowertext(key))
			return M
	return null


// Will return a list of active candidates. It increases the buffer 5 times until it finds a candidate which is active within the buffer.
/proc/get_active_candidates(var/buffer = 1)

	var/list/candidates = list() //List of candidate KEYS to assume control of the new larva ~Carn
	var/i = 0
	while(candidates.len <= 0 && i < 5)
		for(var/mob/abstract/ghost/observer/G in GLOB.player_list)
			if(((G.client.inactivity/10)/60) <= buffer + i) // the most active players are more likely to become an alien
				if(!(G.mind && G.mind.current && G.mind.current.stat != DEAD))
					candidates += G.key
		i++
	return candidates

// Same as above but for alien candidates.

/proc/ScreenText(obj/O, maptext="", screen_loc="CENTER-7,CENTER-7", maptext_height=480, maptext_width=480)
	if(!isobj(O))	O = new /atom/movable/screen/text()
	O.maptext = maptext
	O.maptext_height = maptext_height
	O.maptext_width = maptext_width
	O.screen_loc = screen_loc
	return O

/datum/projectile_data
	var/src_x
	var/src_y
	var/time
	var/distance
	var/power_x
	var/power_y
	var/dest_x
	var/dest_y

/datum/projectile_data/New(var/src_x, var/src_y, var/time, var/distance, \
							var/power_x, var/power_y, var/dest_x, var/dest_y)
	src.src_x = src_x
	src.src_y = src_y
	src.time = time
	src.distance = distance
	src.power_x = power_x
	src.power_y = power_y
	src.dest_x = dest_x
	src.dest_y = dest_y

/proc/projectile_trajectory(var/src_x, var/src_y, var/rotation, var/angle, var/power)

	var/g = 9.81
	var/h = 10
	var/power_x = power * cos(angle)
	var/power_y = power * sin(angle)
	var/time = (power_y + sqrt((power_y*power_y)+(2*g*h)))/g
	var/distance = time * power_x

	var/dest_x = src_x + distance*sin(rotation);
	var/dest_y = src_y + distance*cos(rotation);

	return new /datum/projectile_data(src_x, src_y, time, distance, power_x, power_y, dest_x, dest_y)

/proc/GetRedPart(const/hexa)
	return hex2num(copytext(hexa,2,4))

/proc/GetGreenPart(const/hexa)
	return hex2num(copytext(hexa,4,6))

/proc/GetBluePart(const/hexa)
	return hex2num(copytext(hexa,6,8))

/proc/GetHexColors(const/hexa)
	return list(
			GetRedPart(hexa),
			GetGreenPart(hexa),
			GetBluePart(hexa)
		)

/proc/MixColors(const/list/colors)
	var/list/reds = list()
	var/list/blues = list()
	var/list/greens = list()
	var/list/weights = list()

	for (var/i = 0, ++i <= colors.len)
		reds.Add(GetRedPart(colors[i]))
		blues.Add(GetBluePart(colors[i]))
		greens.Add(GetGreenPart(colors[i]))
		weights.Add(1)

	var/r = mixOneColor(weights, reds)
	var/g = mixOneColor(weights, greens)
	var/b = mixOneColor(weights, blues)
	return rgb(r,g,b)

/proc/mixOneColor(var/list/weight, var/list/color)
	if (!weight || !color || length(weight)!=length(color))
		return 0

	var/contents = length(weight)
	var/i

	//normalize weights
	var/listsum = 0
	for(i=1; i<=contents; i++)
		listsum += weight[i]
	for(i=1; i<=contents; i++)
		weight[i] /= listsum

	//mix them
	var/mixedcolor = 0
	for(i=1; i<=contents; i++)
		mixedcolor += weight[i]*color[i]
	mixedcolor = round(mixedcolor)

	//until someone writes a formal proof for this algorithm, let's keep this in
//	if(mixedcolor<0x00 || mixedcolor>0xFF)
//		return 0
	//that's not the kind of operation we are running here, nerd
	mixedcolor=min(max(mixedcolor,0),255)

	return mixedcolor

/**
* Gets the highest and lowest pressures from the tiles in GLOB.cardinals directions
* around us, then checks the difference.
*/
/proc/getOPressureDifferential(var/turf/loc)
	var/minp=16777216;
	var/maxp=0;
	for(var/dir in GLOB.cardinals)
		var/turf/simulated/T=get_turf(get_step(loc,dir))
		var/cp=0
		if(T && istype(T) && T.zone)
			var/datum/gas_mixture/environment = T.return_air()
			cp = environment.return_pressure()
		else
			if(istype(T,/turf/simulated))
				continue
		if(cp<minp)minp=cp
		if(cp>maxp)maxp=cp
	return abs(minp-maxp)

/proc/convert_k2c(var/temp)
	return ((temp - T0C))

/proc/convert_c2k(var/temp)
	return ((temp + T0C))

/proc/getCardinalAirInfo(var/turf/loc, var/list/stats=list("temperature"))
	var/list/temps = new/list(4)
	for(var/dir in GLOB.cardinals)
		var/direction
		switch(dir)
			if(NORTH)
				direction = 1
			if(SOUTH)
				direction = 2
			if(EAST)
				direction = 3
			if(WEST)
				direction = 4
		var/turf/simulated/T=get_turf(get_step(loc,dir))
		var/list/rstats = new /list(stats.len)
		if(T && istype(T) && T.zone)
			var/datum/gas_mixture/environment = T.return_air()
			for(var/i=1;i<=stats.len;i++)
				if(stats[i] == "pressure")
					rstats[i] = environment.return_pressure()
				else
					rstats[i] = environment.vars[stats[i]]
		else if(istype(T, /turf/simulated))
			rstats = null // Exclude zone (wall, door, etc).
		else if(istype(T, /turf))
			// Should still work.  (/turf/return_air())
			var/datum/gas_mixture/environment = T.return_air()
			for(var/i=1;i<=stats.len;i++)
				if(stats[i] == "pressure")
					rstats[i] = environment.return_pressure()
				else
					rstats[i] = environment.vars[stats[i]]
		temps[direction] = rstats
	return temps

/proc/MinutesToTicks(var/minutes)
	return SecondsToTicks(60 * minutes)

/proc/SecondsToTicks(var/seconds)
	return seconds * 10

/proc/round_is_spooky(var/spookiness_threshold = GLOB.config.cult_ghostwriter_req_cultists)
	if(enabled_spooking)
		return 1
	else
		return (GLOB.cult.current_antagonists.len > spookiness_threshold)

/// Adds an image to a client's `.images`. Useful as a callback.
/proc/add_image_to_client(image/image_to_remove, client/add_to)
	add_to?.images += image_to_remove

/// Like add_image_to_client, but will add the image from a list of clients
/proc/add_image_to_clients(image/image_to_remove, list/show_to)
	for(var/client/add_to in show_to)
		add_to.images += image_to_remove

/// Removes an image from a client's `.images`. Useful as a callback.
/proc/remove_image_from_client(image/image_to_remove, client/remove_from)
	remove_from?.images -= image_to_remove

/// Like remove_image_from_client, but will remove the image from a list of clients
/proc/remove_image_from_clients(image/image_to_remove, list/hide_from)
	for(var/client/remove_from in hide_from)
		remove_from.images -= image_to_remove

/// Add an image to a list of clients and calls a proc to remove it after a duration
/proc/flick_overlay_global(image/image_to_show, list/show_to, duration)
	if(!show_to || !length(show_to) || !image_to_show)
		return
	for(var/client/add_to in show_to)
		add_to.images += image_to_show
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(remove_image_from_clients), image_to_show, show_to), duration, TIMER_CLIENT_TIME)

/**
 * Helper atom that copies an appearance and exists for a period
*/
/atom/movable/flick_visual
	///A list of `/atom/movable` this visual was or will be added into the `vis_contents` of
	VAR_PROTECTED/list/atom/movable/owners = null

/atom/movable/flick_visual/New(loc, list/atom/movable/owners)
	. = ..()
	if(!islist(owners))
		stack_trace("/atom/movable/flick_visual requires a list of owners this was or will be beamed to, to avoid harddels!")

	src.owners = owners


/atom/movable/flick_visual/Destroy(force)

	//Remove us from the vis_contents of the owners, so we can be garbage collected
	//"As anything" is important here, as our "atom/movable" could also be a turf, as per https://secure.byond.com/docs/ref/index.html#/atom/var/vis_contents
	for(var/atom/movable/an_owner as anything in src.owners)
		an_owner.vis_contents -= src
	src.owners = null

	. = ..()


///Flicks a certain overlay onto an atom, handling icon_state strings
/atom/proc/flick_overlay(image_to_show, list/show_to, duration, layer)
	var/image/passed_image = \
		istext(image_to_show) \
			? image(icon, src, image_to_show, layer) \
			: image_to_show

	flick_overlay_global(passed_image, show_to, duration)

/// Takes the passed in MA/icon_state, mirrors it onto ourselves, and displays that in world for duration seconds
/// Returns the displayed object, you can animate it and all, but you don't own it, we'll delete it after the duration
/atom/proc/flick_overlay_view(mutable_appearance/display, duration)
	if(!display)
		return null

	var/mutable_appearance/passed_appearance = \
		istext(display) \
			? mutable_appearance(icon, display, layer) \
			: display

	// If you don't give it a layer, we assume you want it to layer on top of this atom
	// Because this is vis_contents, we need to set the layer manually (you can just set it as you want on return if this is a problem)
	if(passed_appearance.layer == FLOAT_LAYER)
		passed_appearance.layer = layer + 0.1

	var/atom/movable/lies_to_children = src

	// This is faster then pooling. I promise
	var/atom/movable/flick_visual/visual = new(null, list(lies_to_children))
	visual.appearance = passed_appearance
	visual.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	// I hate /area
	lies_to_children.vis_contents += visual
	QDEL_IN_CLIENT_TIME(visual, duration)
	return visual

/area/flick_overlay_view(mutable_appearance/display, duration)
	return

// makes peoples byond icon flash on the taskbar
/proc/window_flash(client/C)
	if(ismob(C))
		var/mob/M = C
		if(M.client)
			C = M.client
	if(!C)
		return
	winset(C, "mainwindow", "flash=5")

/turf/simulated/floor/update_icon(var/update_neighbors)

	if(lava)
		return

	var/has_smooth = 0 //This is just the has_border bitfield inverted for easier logic

	if(flooring)
		// Set initial icon and strings.
		name = flooring.name
		desc = flooring.desc
		icon = flooring.icon
		color = flooring.color
		if(flooring_override)
			icon_state = flooring_override
		else
			icon_state = flooring.icon_base
			if(flooring.has_base_range)
				icon_state = "[icon_state][rand(0,flooring.has_base_range)]"
				flooring_override = icon_state

		// Apply edges, corners, and inner corners.
		cut_overlays()
		var/has_border = 0
		//Check the cardinal turfs
		for(var/step_dir in GLOB.cardinal)
			var/turf/simulated/floor/T = get_step(src, step_dir)
			var/is_linked = flooring.symmetric_test_link(src, T)

			//Alright we've figured out whether or not we smooth with this turf
			if (!is_linked)
				has_border |= step_dir

				//Now, if we don't, then lets add a border
				if(flooring.has_damage_state && !isnull(broken) && (flooring.flags & TURF_CAN_BREAK))
					add_overlay(get_flooring_overlay("[flooring.icon]_[flooring.icon_base]-broken-edge-[step_dir]", "[flooring.icon_base]_broken_edges", step_dir,(flooring.flags & TURF_HAS_EDGES)))
				else if(flooring.flags & TURF_HAS_EDGES)
					add_overlay(get_flooring_overlay("[flooring.icon]_[flooring.icon_base]-edge-[step_dir]", "[flooring.icon_base]_edges", step_dir, (flooring.flags & TURF_HAS_EDGES)))

		has_smooth = ~(has_border & (NORTH | SOUTH | EAST | WEST))

		//We can only have inner corners if we're smoothed with something
		if (has_smooth && flooring.flags & TURF_HAS_INNER_CORNERS)
			for(var/direction in GLOB.cornerdirs)
				if((has_smooth & direction) == direction)
					if(!flooring.symmetric_test_link(src, get_step(src, direction)))
						if(flooring.has_damage_state && !isnull(broken) && (flooring.flags & TURF_CAN_BREAK))
							add_overlay(get_flooring_overlay("[flooring.icon]_[flooring.icon_base]-broken-corner-[direction]", "[flooring.icon_base]_broken_corners", direction))
						else
							add_overlay(get_flooring_overlay("[flooring.icon]_[flooring.icon_base]-corner-[direction]", "[flooring.icon_base]_corners", direction))

		//Next up, outer corners
		if (has_border && flooring.flags & TURF_HAS_CORNERS)
			for(var/direction in GLOB.cornerdirs)
				if((has_border & direction) == direction)
					if(!flooring.symmetric_test_link(src, get_step(src, direction)))
						if(flooring.has_damage_state && !isnull(broken) && (flooring.flags & TURF_CAN_BREAK))
							add_overlay(get_flooring_overlay("[flooring.icon]_[flooring.icon_base]-broken-edge-[direction]", "[flooring.icon_base]_broken_edges", direction,(flooring.flags & TURF_HAS_EDGES)))
						else
							add_overlay(get_flooring_overlay("[flooring.icon]_[flooring.icon_base]-edge-[direction]", "[flooring.icon_base]_edges", direction,(flooring.flags & TURF_HAS_EDGES)))

		if(!isnull(broken) && (flooring.flags & TURF_CAN_BREAK))
			if(flooring.has_damage_state)
				add_overlay(get_damage_overlay("[flooring.icon_base]_broken[broken]", flooring_icon = flooring.icon, flooring_color = flooring.damage_uses_color ? flooring.color : null)) //example, material floors damage. like diamond_broken0.
			else // EVERYTHING BELOW, SEE DAMAGE.DMI
				add_overlay(get_damage_overlay("[broken_overlay ? "[broken_overlay]_" : ""]broken[broken]", BLEND_MULTIPLY, flooring_color = flooring.damage_uses_color ? flooring.color : null)) //example, broken overlay. carpet_broken0.
		if(!isnull(burnt) && (flooring.flags & TURF_CAN_BURN))
			if(flooring.has_burn_state)
				add_overlay(get_damage_overlay("[flooring.icon_base]_burned[broken]", flooring_icon = flooring.icon, flooring_color = flooring.damage_uses_color ? flooring.color : null))
			else
				add_overlay(get_damage_overlay("[burned_overlay ? "[burned_overlay]_" : ""]burned[burnt]"))

	if(decals && decals.len)
		for(var/image/I in decals)
			add_overlay(I)

	if(update_neighbors)
		for(var/turf/simulated/floor/F in RANGE_TURFS(1, src))
			if(F == src)
				continue
			F.update_icon()

/turf/simulated/floor/proc/get_flooring_overlay(var/cache_key, var/icon_base, var/icon_dir = 0, var/external = FALSE)
	var/list/flooring_cache = SSicon_cache.flooring_cache
	if(!flooring_cache[cache_key])
		var/image/I = image(icon = flooring.icon, icon_state = icon_base, dir = icon_dir)
		I.turf_decal_layerise()

		//External overlays will be offset out of this tile
		if (external)
			if (icon_dir & NORTH)
				I.pixel_y = world.icon_size
			else if (icon_dir & SOUTH)
				I.pixel_y = -world.icon_size

			if (icon_dir & WEST)
				I.pixel_x = -world.icon_size
			else if (icon_dir & EAST)
				I.pixel_x = world.icon_size
		I.layer = flooring.decal_layer

		flooring_cache[cache_key] = I
	return flooring_cache[cache_key]

/turf/simulated/floor/proc/get_damage_overlay(var/cache_key, blend, var/flooring_icon, var/flooring_color)
	var/list/flooring_cache = SSicon_cache.flooring_cache
	if(!flooring_cache[cache_key])
		var/image/I = image(icon = flooring_icon ? flooring_icon : 'icons/turf/decals/damage.dmi', icon_state = cache_key)
		if(blend)
			I.blend_mode = blend
		if(flooring_color)
			I.color = flooring_color
		I.turf_decal_layerise()
		flooring_cache[cache_key] = I
	return flooring_cache[cache_key]

/singleton/flooring/proc/test_link(turf/origin, turf/T)
	var/is_linked = FALSE
	if(!T)
		return
	//is_wall is true for wall turfs and for floors containing a low wall
	if(T.is_wall())
		if(wall_smooth == SMOOTH_ALL)
			is_linked = TRUE

	//If is_hole is true, then it's space or openspace
	else if(T.is_open())
		if(space_smooth == SMOOTH_ALL)
			is_linked = TRUE

	//If we get here then its a normal floor
	else if (T.is_floor())
		var/turf/simulated/floor/t = T

		//Check for window frames.
		if(wall_smooth == SMOOTH_ALL)
			for(var/obj/structure/window_frame/WF in T.contents)
				is_linked = TRUE

		//If the floor is the same as us,then we're linked,
		if (istype(src, t.flooring))
			is_linked = TRUE
		else if (floor_smooth == SMOOTH_ALL)
			is_linked = TRUE

		else if (floor_smooth != SMOOTH_NONE)

			//If we get here it must be using a whitelist or blacklist
			if (floor_smooth == SMOOTH_WHITELIST)
				for (var/v in flooring_whitelist)
					if (istype(t.flooring, v))
						//Found a match on the list
						is_linked = TRUE
						break
			else if(floor_smooth == SMOOTH_BLACKLIST)
				is_linked = TRUE //Default to true for the blacklist, then make it false if a match comes up
				for (var/v in flooring_whitelist)
					if (istype(t.flooring, v))
						//Found a match on the list
						is_linked = FALSE
						break
	return is_linked

/singleton/flooring/proc/symmetric_test_link(turf/A, turf/B)
	return test_link(A, B) && test_link(B,A)

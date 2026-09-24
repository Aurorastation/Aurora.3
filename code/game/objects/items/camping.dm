/*

	Tents

*/

/datum/large_structure/tent
	stages = list("poles" = STAGE_DISASSEMBLED,
				"canvas" = STAGE_DISASSEMBLED,
				"guy lines" = STAGE_DISASSEMBLED,
				"pegs" = STAGE_DISASSEMBLED)
	component_structure = /obj/structure/component/tent_canvas
	source_item_type = /obj/item/tent
	/**
	 * An optional footprint made up of text rows. `#` marks a closed tile and `.` marks an empty tile.
	 * `^`, `v`, `<`, and `>` also occupy a tile, but leave that relative edge open as an entrance.
	 * Rows start at the deployment point and extend in the direction the tent is facing. The footprint and entrances rotate with the tent.
	 */
	var/list/footprint
	/// Turf-keyed map of explicitly designated entrance directions generated from `footprint`.
	var/list/entrance_dirs
	/**
	 * Optional roof rows corresponding to `footprint`. `L` and `R` slope toward the
	 * blueprint's left and right sides, while `M` uses the authored ridge tile.
	 * Lowercase `l` and `r` opt a slope into the perspective ridge overlay when it
	 * rotates onto the screen's northern side.
	 */
	var/list/roof_layout
	/// Turf-keyed map of explicit roof markers generated from `roof_layout`.
	var/list/roof_markers
	/// The turf represented by the first row and horizontal centre of the footprint.
	var/turf/deployment_origin
	/**
	 * The state name of an overlay in `icons/obj/item/tent_decals.dmi`
	 * Used for branded tents, such as the SCC base camp tent
	 */
	var/decal

/datum/large_structure/tent/get_target_turfs(var/mob/user, var/force = FALSE)
	if(!LAZYLEN(footprint))
		return ..()

	target_turfs = list()
	entrance_dirs = list()
	roof_markers = list()
	var/footprint_width = 0
	for(var/footprint_row in footprint)
		footprint_width = max(footprint_width, length(footprint_row))
	var/left_offset = floor((footprint_width - 1) / 2)
	var/forward_x = 0
	var/forward_y = 0
	var/right_x = 0
	var/right_y = 0
	switch(dir)
		if(NORTH)
			forward_y = 1
			right_x = 1
		if(SOUTH)
			forward_y = -1
			right_x = -1
		if(EAST)
			forward_x = 1
			right_y = -1
		if(WEST)
			forward_x = -1
			right_y = 1

	for(var/row_number = 1 to footprint.len)
		var/row_text = footprint[row_number]
		var/roof_row = row_number <= LAZYLEN(roof_layout) ? roof_layout[row_number] : null
		for(var/column_number = 1 to length(row_text))
			var/marker = copytext(row_text, column_number, column_number + 1)
			if(!(marker in list("#", "^", "v", "<", ">")))
				continue
			var/forward_offset = row_number - 1
			var/side_offset = column_number - 1 - left_offset
			var/turf/target = locate(
				deployment_origin.x + forward_x * forward_offset + right_x * side_offset,
				deployment_origin.y + forward_y * forward_offset + right_y * side_offset,
				deployment_origin.z
			)
			if(!istype(target))
				target_turfs.Cut()
				entrance_dirs.Cut()
				if(!force)
					to_chat(user, SPAN_ALERT("You cannot set up \the [src] here. Try and find a big enough solid surface."))
				return FALSE
			target_turfs += target
			if(roof_row && column_number <= length(roof_row))
				var/roof_marker = copytext(roof_row, column_number, column_number + 1)
				if(roof_marker in list("L", "M", "R", "l", "r"))
					roof_markers[target] = roof_marker
			switch(marker)
				if("^")
					entrance_dirs[target] = turn(dir, 180)
				if("v")
					entrance_dirs[target] = dir
				if("<")
					entrance_dirs[target] = turn(dir, 90)
				if(">")
					entrance_dirs[target] = turn(dir, -90)
	return TRUE

/datum/large_structure/tent/build_structures()
	. = ..()
	var/list/roofs = list()
	var/list/canvas_visuals = list()
	for(var/obj/structure/component/tent_canvas/C in grouped_structures)
		var/turf/canvas_turf = get_turf(C)

		// The canvas object is structural only. Its appearance and direction must not
		// influence the fixed-perspective wall artwork.
		C.icon_state = "canvas"
		C.dir = SOUTH
		C.wall_dirs = NONE
		for(var/wall_dir in list(NORTH, SOUTH, EAST, WEST))
			if(has_tent_wall(canvas_turf, wall_dir))
				C.wall_dirs |= wall_dir

		// Roof slope remains relative to the deployed blueprint.
		var/side_one_dir = (dir & (NORTH | SOUTH)) ? WEST : SOUTH
		var/side_two_dir = (dir & (NORTH | SOUTH)) ? EAST : NORTH
		var/top_dir = (dir & (NORTH | SOUTH)) ? NORTH : EAST
		var/bottom_dir = turn(top_dir, 180)
		var/side_one_distance = get_lateral_distance(canvas_turf, side_one_dir)
		var/side_two_distance = get_lateral_distance(canvas_turf, side_two_dir)
		var/is_side_one_wall = has_tent_wall(canvas_turf, side_one_dir)
		var/is_side_two_wall = has_tent_wall(canvas_turf, side_two_dir)
		var/is_bottom_wall = has_tent_wall(canvas_turf, bottom_dir)
		var/roof_fallback_dir = side_one_distance < side_two_distance ? side_one_dir : side_two_dir
		if(is_side_one_wall)
			roof_fallback_dir = side_one_dir
		if(is_side_two_wall)
			roof_fallback_dir = side_two_dir
		var/roof_dir = get_roof_direction(canvas_turf, roof_fallback_dir)
		var/perspective_fix = !LAZYLEN(roof_layout) && roof_dir == NORTH && abs(side_one_distance - side_two_distance) == 1
		if(LAZYLEN(roof_layout))
			perspective_fix = roof_dir == NORTH && (roof_markers?[canvas_turf] in list("l", "r"))

		var/obj/structure/component/tent_canvas/roof/roof = new /obj/structure/component/tent_canvas/roof(canvas_turf)
		roof.part_of = src
		roof.color = color
		// Select an already-oriented frame and leave the atom itself facing south.
		// Filters and independent canvas visuals then remain in world coordinates.
		var/roof_location = get_location(C, TRUE)
		roof.dir = SOUTH
		roof.icon_state = "roof_world_[roof_location]_[direction_to_icon_suffix(roof_dir)]"
		if(decal && C.x == x1 && C.y == y1)
			roof.AddOverlays(overlay_image('icons/obj/item/tent_decals.dmi', decal, flags=RESET_COLOR))
		roofs += roof

		// Entrances are explicit blueprint edges. Their treatment depends only on
		// neighbouring walls/entrances, never on deployment orientation.
		var/entrance_dir = get_tent_entrance_direction(canvas_turf)
		var/clockwise_dir = entrance_dir && turn(entrance_dir, -90)
		var/counterclockwise_dir = entrance_dir && turn(entrance_dir, 90)
		var/clockwise_wall = entrance_dir && has_tent_wall(canvas_turf, clockwise_dir)
		var/counterclockwise_wall = entrance_dir && has_tent_wall(canvas_turf, counterclockwise_dir)
		var/turf/clockwise_turf = entrance_dir && get_step(canvas_turf, clockwise_dir)
		var/turf/counterclockwise_turf = entrance_dir && get_step(canvas_turf, counterclockwise_dir)
		var/clockwise_join = entrance_dir && (clockwise_turf in target_turfs) && get_tent_entrance_direction(clockwise_turf) == entrance_dir
		var/counterclockwise_join = entrance_dir && (counterclockwise_turf in target_turfs) && get_tent_entrance_direction(counterclockwise_turf) == entrance_dir
		var/has_entrance_corner = clockwise_wall || counterclockwise_wall
		var/clockwise_treatment = clockwise_wall ? "corner" : (clockwise_join ? "join" : "normal")
		var/counterclockwise_treatment = counterclockwise_wall ? "corner" : (counterclockwise_join ? "join" : "normal")

		if(entrance_dir)
			var/mask_state = "roof_entrance_mask_[clockwise_treatment]_[counterclockwise_treatment]"
			var/icon/entrance_mask = icon(roof.icon, mask_state, entrance_dir)
			roof.appearance_flags |= KEEP_TOGETHER
			roof.add_filter("tent_entrance", 1, alpha_mask_filter(icon = entrance_mask))

		// Walls and corner seams use world-oriented DMI states on independent atoms.
		// They therefore cannot inherit the deployed direction of the roof fabric.
		if(!has_entrance_corner)
			for(var/target_plane in list(C.plane, roof.plane))
				add_visible_walls(canvas_turf, canvas_visuals, target_plane)
				add_inner_corner_visuals(canvas_turf, canvas_visuals, target_plane)
		if(perspective_fix && !is_bottom_wall)
			roof.AddOverlays(overlay_image(roof.icon, "roof_[roof_location]_p"))
		if(entrance_dir)
			var/entrance_state = "canvas_entrance_[clockwise_treatment]_[counterclockwise_treatment]"
			add_canvas_visual(canvas_turf, canvas_visuals, C.plane, entrance_state, entrance_dir, TRUE)
			add_canvas_visual(canvas_turf, canvas_visuals, roof.plane, entrance_state, entrance_dir, TRUE)

	grouped_structures += roofs
	grouped_structures += canvas_visuals

	for(var/turf/target in target_turfs)
		target.update_weather()

/** Returns the direction authored for a roof tile, or `fallback` for legacy/unplanned tents. */
/datum/large_structure/tent/proc/get_roof_direction(var/turf/origin, var/fallback = NONE)
	var/roof_marker = roof_markers?[origin]
	switch(roof_marker)
		if("L", "l")
			return turn(dir, 90)
		if("M", "R", "r")
			return turn(dir, -90)
	return fallback

/// Stable suffix used by the pre-oriented, single-direction roof states.
/datum/large_structure/tent/proc/direction_to_icon_suffix(var/direction)
	switch(direction)
		if(NORTH)
			return "north"
		if(EAST)
			return "east"
		if(WEST)
			return "west"
	return "south"

/**
 * Returns the number of contiguous tent tiles between `origin` and the edge in `direction`.
 */
/datum/large_structure/tent/proc/get_lateral_distance(var/turf/origin, var/direction)
	var/distance = 0
	var/turf/current = origin
	while(TRUE)
		var/turf/next = get_step(current, direction)
		if(!(next in target_turfs))
			return distance
		distance++
		current = next

/**
 * Returns whether `origin` is on the footprint's outermost edge in `direction`.
 * Missing neighbours inside these bounds are walls created by a change in the footprint's shape.
 */
/datum/large_structure/tent/proc/is_outer_boundary(var/turf/origin, var/direction)
	switch(direction)
		if(NORTH)
			return origin.y == y2
		if(SOUTH)
			return origin.y == y1
		if(EAST)
			return origin.x == x2
		if(WEST)
			return origin.x == x1
	return FALSE

/**
 * Returns whether an exposed edge is open. Custom footprints only open explicitly marked edges;
 * legacy rectangular tents retain their original open north/east and south/west ends.
 */
/datum/large_structure/tent/proc/is_tent_opening(var/turf/origin, var/direction)
	if(get_step(origin, direction) in target_turfs)
		return FALSE
	if(LAZYLEN(footprint))
		return entrance_dirs[origin] == direction

	var/top_dir = (dir & (NORTH | SOUTH)) ? NORTH : EAST
	return (direction in list(top_dir, turn(top_dir, 180))) && is_outer_boundary(origin, direction)

/// Returns the outward direction of the entrance on `origin`, including legacy rectangular tents.
/datum/large_structure/tent/proc/get_tent_entrance_direction(var/turf/origin)
	var/entrance_direction = entrance_dirs?[origin]
	if(entrance_direction || LAZYLEN(footprint))
		return entrance_direction

	var/top_dir = (dir & (NORTH | SOUTH)) ? NORTH : EAST
	if(is_tent_opening(origin, top_dir))
		return top_dir
	var/bottom_dir = turn(top_dir, 180)
	if(is_tent_opening(origin, bottom_dir))
		return bottom_dir

/// Returns whether `origin` has a closed tent wall along an exposed edge.
/datum/large_structure/tent/proc/has_tent_wall(var/turf/origin, var/direction)
	return (origin in target_turfs) && !(get_step(origin, direction) in target_turfs) && !is_tent_opening(origin, direction)

/// Adds every closed edge using standalone visuals whose directions cannot inherit the roof's rotation.
/datum/large_structure/tent/proc/add_visible_walls(var/turf/origin, var/list/canvas_visuals, var/target_plane)
	for(var/wall_dir in list(NORTH, SOUTH, EAST, WEST))
		if(has_tent_wall(origin, wall_dir))
			add_directional_wall(origin, canvas_visuals, target_plane, wall_dir)

/**
 * Selects the connection treatment for one wall. The DMI then chooses the thin
 * north/south or thick east/west artwork automatically from `wall_dir`.
 */
/datum/large_structure/tent/proc/add_directional_wall(var/turf/origin, var/list/canvas_visuals, var/target_plane, var/wall_dir)
	var/left_dir = turn(wall_dir, -90)
	var/right_dir = turn(wall_dir, 90)
	// Entrance frames now provide their own wall transition. Treating an entrance
	// as a connected wall here selects the old tapered edge sprites beside it.
	var/connects_left = has_tent_wall(origin, left_dir)
	var/connects_right = has_tent_wall(origin, right_dir)
	var/wall_state = "canvas_wall"

	if(connects_left && connects_right)
		wall_state = "canvas_wall_mid"
	else if(connects_left)
		wall_state = "canvas_wall_edge_left"
	else if(connects_right)
		wall_state = "canvas_wall_edge_right"

	add_canvas_visual(origin, canvas_visuals, target_plane, wall_state, wall_dir)

/// Creates one independent, world-directed canvas appearance.
/datum/large_structure/tent/proc/add_canvas_visual(var/turf/origin, var/list/canvas_visuals, var/target_plane, var/icon_state, var/visual_dir, var/render_above = FALSE)
	var/obj/structure/component/tent_canvas_visual/visual = new(origin)
	visual.part_of = src
	visual.color = color
	visual.plane = target_plane
	visual.icon_state = icon_state
	visual.dir = visual_dir
	if(render_above)
		visual.layer += 0.01
	canvas_visuals += visual

/**
 * Adds the seams for concave corners where an annex or vestibule meets the main tent.
 * An inner corner has two occupied cardinal neighbours with an empty diagonal between them.
 */
/datum/large_structure/tent/proc/add_inner_corner_visuals(var/turf/origin, var/list/canvas_visuals, var/target_plane)
	for(var/edge_dir in list(SOUTH, NORTH))
		for(var/side_dir in list(WEST, EAST))
			var/diagonal_dir = edge_dir | side_dir
			if(!(get_step(origin, edge_dir) in target_turfs) || !(get_step(origin, side_dir) in target_turfs) || (get_step(origin, diagonal_dir) in target_turfs))
				continue

			var/source_left_dir = turn(edge_dir, -90)
			var/corner_state = side_dir == source_left_dir ? "canvas_wall_inner_corner_left" : "canvas_wall_inner_corner_right"
			add_canvas_visual(origin, canvas_visuals, target_plane, corner_state, edge_dir)

/**
 * Shows `user` a client-only preview of the tent's occupied tiles and asks them to confirm its placement.
 * The blue tile marks the deployment anchor, green tiles are clear, and red tiles are obstructed.
 */
/datum/large_structure/tent/proc/confirm_placement(var/mob/user)
	var/client/preview_client = user?.client
	if(!preview_client)
		return check_placement_clear(user)

	var/list/preview_images = list()
	for(var/turf/target in target_turfs)
		var/icon_state
		if(get_placement_obstruction(target))
			icon_state = "invalid"
		else
			icon_state = target == deployment_origin ? "selected" : "valid"
		var/image/preview = image('icons/effects/blueprints.dmi', target, icon_state)
		preview.plane = HUD_PLANE
		preview.appearance_flags = NO_CLIENT_COLOR
		preview_images += preview
		var/entrance_dir = get_tent_entrance_direction(target)
		if(entrance_dir)
			var/image/entrance_preview = image('icons/effects/blueprints.dmi', target, "entrance")
			entrance_preview.dir = entrance_dir
			entrance_preview.plane = HUD_PLANE
			entrance_preview.layer = preview.layer + 0.1
			entrance_preview.appearance_flags = NO_CLIENT_COLOR
			preview_images += entrance_preview

	preview_client.images += preview_images
	var/choice = alert(user, "The highlighted tiles show the tent's footprint. The blue tile is the deployment anchor, red tiles have something in the way, and yellow arrows show every entrance and its direction.", "Confirm Tent Placement", "Assemble", "Cancel")
	preview_client.images -= preview_images
	if(choice != "Assemble")
		return FALSE
	return check_placement_clear(user)

/** Returns the first solid turf or object preventing a tent component from occupying `target`. */
/datum/large_structure/tent/proc/get_placement_obstruction(var/turf/target)
	if(!istype(target) || target.density)
		return target
	for(var/obj/obstruction in target)
		if(obstruction == source_item)
			continue

		if(obstruction.density || istype(obstruction, /obj/structure/machinery/door))
			return obstruction
	return null

/** Checks the entire footprint and tells `user` what prevents assembly. */
/datum/large_structure/tent/proc/check_placement_clear(var/mob/user)
	for(var/turf/target in target_turfs)
		var/atom/obstruction = get_placement_obstruction(target)
		if(obstruction)
			to_chat(user, SPAN_WARNING("You cannot assemble \the [src]; \the [obstruction] is in the way."))
			return FALSE
	return TRUE

// Recheck at the start of every stage in case the footprint changed after its preview.
/datum/large_structure/tent/assemble(var/mob/user)
	if(!check_placement_clear(user))
		return FALSE
	return ..()

/datum/large_structure/tent/structure_entered(turf/entry_point, atom/movable/entering)
	. = ..()
	if(!.)
		return
	if(!istype(entering, /mob))
		return

	var/mob/M = entering
	var/atom/movable/screen/plane_master/roof/roof_plane = M.hud_used?.plane_masters["[ROOF_PLANE]"]
	if(roof_plane)
		roof_plane.alpha = 76

/datum/large_structure/tent/mob_moved(mob/mover, turf/exit_point)
	. = ..()
	if(!.)
		var/atom/movable/screen/plane_master/roof/roof_plane = mover.hud_used?.plane_masters["[ROOF_PLANE]"]
		if(roof_plane)
			roof_plane.alpha = 255

/**
 * Determines the state to use for each section of the tent
 * Returns `edge` for legacy canvas positioning. Roofs instead distinguish the
 * fixed-perspective `edge_west` and `edge_east` cutouts.
 * Returns `mid` for structures in the exact centre of the tent, for odd number widths
 * Otherwise returns `norm` for other structures
 * Entrance shaping is handled separately by the perspective frame and roof mask.
 */
/datum/large_structure/tent/proc/get_location(var/obj/structure/component/tent_canvas/canvas, var/for_roof = FALSE)
	var/turf/canvas_turf = get_turf(canvas)
	var/side_one_dir = (dir & (NORTH | SOUTH)) ? WEST : SOUTH
	var/side_two_dir = (dir & (NORTH | SOUTH)) ? EAST : NORTH
	var/side_one_distance = get_lateral_distance(canvas_turf, side_one_dir)
	var/side_two_distance = get_lateral_distance(canvas_turf, side_two_dir)
	var/is_side_edge = !side_one_distance || !side_two_distance
	// Explicit roof plans decide where irregular ridges sit. Rectangular tents retain the
	// original geometric midpoint behaviour.
	var/is_middle = roof_markers?[canvas_turf] == "M"
	if(!LAZYLEN(roof_layout))
		is_middle = side_one_distance == side_two_distance

	if(for_roof)
		if(is_middle)
			return "mid"
		// Only east/west edges need the deep side-wall roof cutout. North/south
		// boundaries use the full roof tile above their shallow wall.
		if(has_tent_wall(canvas_turf, WEST))
			return "edge_west"
		if(has_tent_wall(canvas_turf, EAST))
			return "edge_east"
		return "norm"
	else if(is_side_edge)
		return "edge"
	else if(is_middle)
		return "mid"
	return "norm"

/obj/item/tent
	name = "expedition tent"
	desc = "A rolled up tent, ready to be assembled to make a base camp, shelter, or just a cozy place to chat."
	icon = 'icons/obj/item/camping.dmi'
	icon_state = "tent"
	item_state = "tent"
	contained_sprite = TRUE
	w_class = WEIGHT_CLASS_BULKY
	color = "#58a178"
	var/width = 2
	var/length = 3
	/// Optional irregular footprint. See `/datum/large_structure/tent/footprint`.
	var/list/footprint
	/// Optional explicit roof plan corresponding to `footprint`.
	var/list/roof_layout
	var/decal
	/// Duration of each of the four assembly stages.
	var/assembly_time_per_stage = 7 SECONDS
	/// Duration of each of the four disassembly stages.
	var/disassembly_time_per_stage = 7 SECONDS

	var/datum/large_structure/tent/my_tent

/obj/item/tent/assembly_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Drag this to yourself to begin assembly. This will take some time, in 4 stages. Others can start working on the other stages by dragging it to themselves as well."
	. += "Each assembly stage takes approximately [DisplayTimeText(assembly_time_per_stage)]."
	. += "A footprint preview will be shown before assembly begins, allowing you to confirm its position and orientation."

/obj/item/tent/Initialize()
	. = ..()
	var/occupied_tiles = width * length
	if(LAZYLEN(footprint))
		length = footprint.len
		width = 0
		occupied_tiles = 0
		for(var/row in footprint)
			width = max(width, length(row))
			for(var/column_number = 1 to length(row))
				if(copytext(row, column_number, column_number + 1) in list("#", "^", "v", "<", ">"))
					occupied_tiles++
	w_class = min(ceil(occupied_tiles / 1.5), WEIGHT_CLASS_GIGANTIC) // 2x2 = WEIGHT_CLASS_NORMAL
	desc += "\nThis one has a [width] x [length] footprint."

/obj/item/tent/Destroy()
	if(my_tent)
		my_tent.source_item = null
		if(!my_tent.grouped_structures)
			QDEL_NULL(my_tent)
	return ..()

/obj/item/tent/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	. = ..()
	if(use_check(usr) || !Adjacent(usr))
		return
	var/turf/T = get_turf(src)
	if(istype(T))
		deploy_tent(T, usr)

/obj/item/tent/proc/deploy_tent(var/turf/target, var/mob/user)
	if(my_tent)
		if(my_tent.origin == get_turf(src)) //Not moved
			my_tent.assemble(user)
			return
		else
			QDEL_NULL(my_tent)

	var/deploy_dir = get_compass_dir(user,target)
	if(target == get_turf(user))
		deploy_dir = user.dir

	my_tent = new /datum/large_structure/tent(src)
	setup_my_tent(deploy_dir, target)

	if(!my_tent.get_target_turfs(user) || !my_tent.confirm_placement(user))
		QDEL_NULL(my_tent)
		return

	my_tent.assemble(user)

/obj/item/tent/proc/setup_my_tent(var/deploy_dir, var/turf/target)
	my_tent.name = name
	my_tent.color = color
	my_tent.decal = decal
	my_tent.footprint = footprint
	my_tent.roof_layout = roof_layout
	my_tent.assembly_time_per_stage = assembly_time_per_stage
	my_tent.disassembly_time_per_stage = disassembly_time_per_stage
	my_tent.dir = deploy_dir
	my_tent.deployment_origin = target
	my_tent.z1 = target.z
	my_tent.z2 = target.z
	my_tent.source_item_type = type
	my_tent.source_item = src
	my_tent.origin = get_turf(src)

	if(deploy_dir & NORTH)
		my_tent.x1 = target.x - floor((width-1)/2)
		my_tent.x2 = target.x + ceil((width-1)/2)
		my_tent.y1 = target.y
		my_tent.y2 = target.y + (length-1)
	else if(deploy_dir & SOUTH)
		my_tent.x1 = target.x - ceil((width-1)/2)
		my_tent.x2 = target.x + floor((width-1)/2)
		my_tent.y1 = target.y - (length-1)
		my_tent.y2 = target.y
	else if(deploy_dir & EAST)
		my_tent.x1 = target.x
		my_tent.x2 = target.x + (length-1)
		my_tent.y1 = target.y - ceil((width-1)/2)
		my_tent.y2 = target.y + floor((width-1)/2)
	else
		my_tent.x1 = target.x - (length-1)
		my_tent.x2 = target.x
		my_tent.y1 = target.y - floor((width-1)/2)
		my_tent.y2 = target.y + ceil((width-1)/2)

/obj/item/tent/big
	name = "base camp tent"
	color = "#2e3763"
	footprint = list(
		"#^^#",
		"####",
		"####",
		"####",
		"#vv#"
	)
	roof_layout = list(
		"LLRR",
		"LLRR",
		"LLRR",
		"LLRR",
		"LLRR"
	)

/obj/item/tent/big/scc
	name = "scc base camp tent"
	decal = "scc"

/obj/item/tent/medical
	name = "medical tent"
	color = HOLOMAP_AREACOLOR_MEDICAL
	footprint = list(
		".^^..",
		".##..",
		"#####",
		"#####",
		"####>",
		"#####"
	)
	roof_layout = list(
		".LM..",
		".LM..",
		"LLMRR",
		"LLMRR",
		"LLMRR",
		"LLMRR"
	)

/obj/item/tent/security
	name = "security tent"
	color = HOLOMAP_AREACOLOR_SECURITY
	footprint = list(
		".#^^#.",
		".####.",
		"#####.",
		"######",
		"######",
		"#####."
	)
	roof_layout = list(
		".LLRR.",
		".LLRR.",
		"LLLRR.",
		"LLLRRR",
		"LLLRRR",
		"LLLRR."
	)

/obj/item/tent/engineering
	name = "engineering tent"
	color = HOLOMAP_AREACOLOR_ENGINEERING
	footprint = list(
		"#^^#..",
		"#####>",
		"#####>",
		"#####>",
		"####.."
	)
	roof_layout = list(
		"LLRR..",
		"LLRRRR",
		"LLRRRR",
		"LLRRRR",
		"LLRR.."
	)

/obj/item/tent/science
	name = "science tent"
	color = HOLOMAP_AREACOLOR_SCIENCE
	footprint = list(
		".##^^#",
		".#####",
		".#####",
		".###..",
		"####..",
		"####.."
	)
	roof_layout = list(
		".LLMRR",
		".LLMRR",
		".LLMRR",
		".LLM..",
		"LLLM..",
		"LLLM.."
	)

/obj/item/tent/command
	name = "command tent"
	color = HOLOMAP_AREACOLOR_COMMAND
	footprint = list(
		"..^^..",
		".####.",
		"<####>",
		"<####>",
		".####.",
		"..vv..",
	)
	roof_layout = list(
		"..LR..",
		".LLRR.",
		"LLLRRR",
		"LLLRRR",
		".LLRR.",
		"..LR..",
	)

/obj/item/tent/mess_hall
	name = "mess hall tent"
	color = HOLOMAP_AREACOLOR_CIVILIAN
	footprint = list(
		"..^^..",
		"######",
		"######",
		"<#####",
		"<#####"
	)
	roof_layout = list(
		"..LR..",
		"LLLRRR",
		"LLLRRR",
		"LLLRRR",
		"LLLRRR"
	)

/obj/item/tent/command_comms
	name = "command and communications tent"
	color = HOLOMAP_AREACOLOR_COMMAND
	footprint = list(
		".#^^#",
		".####",
		"#####",
		"#####",
		".####",
		".#vv#"
	)
	roof_layout = list(
		".LLRR",
		".LLRR",
		"LLLRR",
		"LLLRR",
		".LLRR",
		".LLRR"
	)

/obj/item/tent/field_kitchen
	name = "field kitchen tent"
	color = HOLOMAP_AREACOLOR_CIVILIAN
	footprint = list(
		"#^^#",
		"####",
		"####",
		"####"
	)
	roof_layout = list(
		"LLRR",
		"LLRR",
		"LLRR",
		"LLRR"
	)

/obj/item/tent/quarantine
	name = "quarantine tent"
	color = HOLOMAP_AREACOLOR_MEDICAL
	footprint = list(
		".^^.",
		"####",
		"####",
		".##.",
		"####",
		"####",
		".vv."
	)
	roof_layout = list(
		".LR.",
		"LLRR",
		"LLRR",
		".LR.",
		"LLRR",
		"LLRR",
		".LR."
	)

/obj/item/tent/decontamination
	name = "decontamination tent"
	color = HOLOMAP_AREACOLOR_MEDICAL
	footprint = list(
		"#^^#",
		"####",
		"####",
		"####",
		"#vv#"
	)
	roof_layout = list(
		"LLRR",
		"LLRR",
		"LLRR",
		"LLRR",
		"LLRR",
	)

/obj/item/tent/machinist
	name = "machinist tent"
	color = HOLOMAP_AREACOLOR_OPERATIONS
	footprint = list(
		"#^^#",
		"####",
		"####",
		"####",
		".##."
	)
	roof_layout = list(
		"LLRR",
		"LLRR",
		"LLRR",
		"LLRR",
		".LR."
	)

/obj/item/tent/vehicle_workshop
	name = "vehicle workshop tent"
	color = HOLOMAP_AREACOLOR_OPERATIONS
	footprint = list(
		".#^^#.",
		"######",
		"######",
		"######",
		".####.",
		".vvvv."
	)
	roof_layout = list(
		".LLRR.",
		"LLLRRR",
		"LLLRRR",
		"LLLRRR",
		".LLRR.",
		".LLRR."
	)

/obj/item/tent/cargo
	name = "cargo tent"
	color = HOLOMAP_AREACOLOR_OPERATIONS
	footprint = list(
		"#^^##..",
		"#####..",
		"#######",
		"#######",
		"#######",
		"#######"
	)
	roof_layout = list(
		"LLMRR..",
		"LLMRR..",
		"LLMRRRR",
		"LLMRRRR",
		"LLMRRRR",
		"LLMRRRR"
	)

/obj/item/tent/mining
	name = "miners' tent"
	color = "#8b7242"
	assembly_time_per_stage = 5 SECONDS
	disassembly_time_per_stage = 5 SECONDS
	footprint = list(
		".#^#.",
		".###.",
		".####",
		".####",
		".###."
	)
	roof_layout = list(
		".LMR.",
		".LMR.",
		".LMRR",
		".LMRR",
		".LMR."
	)

/obj/structure/component/tent_canvas
	name = "tent canvas"
	desc = "The fabric and poles which make up the wall of a tent. Not air-tight, but able to keep out the weather, and very cozy."
	icon = 'icons/obj/item/camping.dmi'
	icon_state = "canvas"
	item_state = "canvas"
	anchored = TRUE
	density = TRUE
	atom_flags = ATOM_FLAG_CHECKS_BORDER
	atmos_canpass = CANPASS_ALWAYS //Tents are not air tight
	layer = ABOVE_HUMAN_LAYER
	/// Cardinal edges of this tile occupied by tent walls.
	var/wall_dirs = NONE

/obj/structure/component/tent_canvas/disassembly_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Drag this to yourself to begin disassembly. This will take some time, in 4 stages. Others can start working on the other stages by dragging it, or other sections, to themselves as well."
	if(part_of)
		. += "Each disassembly stage takes approximately [DisplayTimeText(part_of.disassembly_time_per_stage)]."

/obj/structure/component/tent_canvas/CanPass(atom/movable/mover, turf/target, height, air_group)
	. = ..()
	if(get_dir(loc, target) & wall_dirs)
		return !density
	return TRUE

/obj/structure/component/tent_canvas/CheckExit(atom/movable/O, turf/target)
	. = ..()
	if(get_dir(O.loc, target) & wall_dirs)
		return !density
	return TRUE

/obj/structure/component/tent_canvas/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	..()
	if(use_check(usr, USE_ALLOW_NON_ADJACENT) || (get_dist(usr, src) > 1)) // use_check() can't check for adjacency due to density issues, so we check range as well
		return
	part_of.disassemble(usr)

/obj/structure/component/tent_canvas/Destroy() //When we're destroyed, make sure we return the roof plane to anyone inside
	var/turf/former_turf = get_turf(src)
	for(var/mob/M in loc)
		var/atom/movable/screen/plane_master/roof/roof_plane = M.hud_used?.plane_masters["[ROOF_PLANE]"]
		if(roof_plane)
			roof_plane.alpha = 255
	. = ..()
	if(former_turf)
		addtimer(CALLBACK(former_turf, TYPE_PROC_REF(/turf, update_weather)), 0, TIMER_UNIQUE)
	return .

/obj/structure/component/tent_canvas/roof
	plane = ROOF_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/structure/component/tent_canvas/roof/CanPass(atom/movable/mover, turf/target, height, air_group)
	return TRUE

/obj/structure/component/tent_canvas/roof/CheckExit(atom/movable/O, turf/target)
	return TRUE

/// A standalone wall, corner, or entrance appearance. Keeping these separate from
/// the directional roof and canvas atoms makes their perspective world-relative.
/obj/structure/component/tent_canvas_visual
	name = "tent canvas"
	icon = 'icons/obj/item/camping.dmi'
	anchored = TRUE
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	// Always composite over roof fabric instead of competing at the same layer.
	layer = ABOVE_HUMAN_LAYER + 0.05

//Pre-fabricated tents for mapping
/obj/effect/tent
	name = "Pre-frabricated expedition tent"
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "portal_side_a"
	var/builds = /obj/item/tent

/obj/effect/tent/Initialize(mapload, ...)
	. = ..()
	var/obj/item/tent/tent_item = new builds(src)
	var/datum/large_structure/tent/tent = new /datum/large_structure/tent(src)
	tent_item.my_tent = tent
	tent_item.setup_my_tent(dir, get_turf(src))
	tent.get_target_turfs(null, TRUE)
	tent.build_structures()
	for(var/stage in tent.stages)
		tent.stages[stage] = STAGE_ASSEMBLED
	qdel(tent_item)
	qdel(src)

/*
	Sleeping bags
*/
/obj/item/sleeping_bag
	name = "sleeping bag"
	desc = "A rolled up sleeping bag, ready to be taken on a camping trip."
	icon = 'icons/obj/item/camping.dmi'
	icon_state = "sleepingbag"
	item_state = "sleepingbag"
	contained_sprite = TRUE
	w_class = WEIGHT_CLASS_BULKY

/obj/item/sleeping_bag/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Left-click with this item in-hand on a turf or on yourself to unroll it."
	. += "This item can be attached to a backpack."

/obj/item/sleeping_bag/Initialize(mapload, ...)
	. = ..()
	if(!color)
		color = pick(COLOR_NAVY_BLUE, COLOR_GREEN, COLOR_MAROON, COLOR_VIOLET, COLOR_OLIVE, COLOR_SEDONA)

/obj/item/sleeping_bag/afterattack(obj/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	var/turf/T = target
	if(istype(T))
		unroll(T, user)

/obj/item/sleeping_bag/attack_self(mob/user)
	. = ..()
	var/turf/T = get_turf(user)
	if(istype(T))
		unroll(T, user)

/**
 * Creates sleeping bag structure on the target turf, deleting this item in the process
 */
/obj/item/sleeping_bag/proc/unroll(var/turf/target, var/mob/user)
	user.visible_message(SPAN_NOTICE("\The [user] unrolls \the [src]."))
	var/obj/structure/bed/sleeping_bag/S = new /obj/structure/bed/sleeping_bag(target, MATERIAL_CLOTH)
	S.color = color
	qdel(src)

/obj/item/sleeping_bag/mining
	color = COLOR_DARK_BROWN

/obj/structure/bed/sleeping_bag
	name = "sleeping bag"
	desc = "A bag for sleeping in. Great for trying to pretend you're somewhere more comfortable than you really are."
	icon = 'icons/obj/item/camping.dmi'
	icon_state = "sleepingbag_floor"
	base_icon = "sleepingbag_floor"
	density = FALSE
	anchored = FALSE
	buckling_sound = 'sound/items/drop/clothing.ogg'
	held_item = /obj/item/sleeping_bag
	can_dismantle = FALSE
	can_pad = FALSE

/obj/structure/bed/sleeping_bag/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "This object can be buckled into like any standard bed."
	. += "Clicking and dragging this object onto yourself will roll it back up (so long as no one is sleeping inside)."

/obj/structure/bed/sleeping_bag/update_icon()
	return

/obj/structure/bed/sleeping_bag/buckle(mob/living/M)
	. = ..()
	var/image/I = overlay_image(icon, "[base_icon]_top", color)
	M.AddOverlays(I)

/obj/structure/bed/sleeping_bag/unbuckle()
	if(buckled)
		buckled.update_icon()
	. = ..()

/obj/structure/bed/sleeping_bag/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	. = ..()
	if(use_check(usr) || !Adjacent(usr))
		return
	if(!ishuman(usr) && (!isrobot(usr) || isDrone(usr))) //Humans and borgs can roll, but not drones
		return
	if(buckled)
		to_chat(usr, SPAN_WARNING("You can't roll up \the [src] while someone is sleeping inside."))
		return
	var/obj/item/sleeping_bag/S = new held_item(get_turf(src))
	S.color = color
	usr.visible_message(SPAN_NOTICE("\The [usr] rolls up \the [src]."))
	qdel(src)

/*
	Folding Tables
*/
/obj/item/material/folding_table
	name = "folding table"
	desc = "A temporary surface, for when you need a table, but only for a little while."
	icon = 'icons/obj/item/camping.dmi'
	icon_state = "table_folded"
	item_state = "table_folded"
	contained_sprite = TRUE
	default_material = MATERIAL_ALUMINIUM

/obj/item/material/folding_table/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Left-click on yourself with this item in-hand to deploy it."

/obj/item/material/folding_table/attack_self(mob/user)
	if(use_check(user) || !Adjacent(user))
		return
	deploy(get_turf(user), user.dir, user)

/obj/item/material/folding_table/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(use_check(user) || !user.Adjacent(target))
		to_chat(usr, SPAN_WARNING("You fail to set up \the [src] in that location."))
		return
	if(isturf(target))
		deploy(target, user.dir, user)

/obj/item/material/folding_table/proc/deploy(var/turf/T, var/direction, var/mob/user)
	new /obj/structure/table/rack/folding_table(T)
	user.visible_message(SPAN_NOTICE("\The [user] sets up \the [src]."))
	qdel(src)

/obj/structure/table/rack/folding_table
	name = "folding table"
	desc = "A temporary surface, for when you need a table, but only for a little while."
	icon_state = "camping_table"
	table_mat = MATERIAL_ALUMINIUM

/obj/structure/table/rack/folding_table/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Clicking and dragging this object onto yourself will collapse it again."

/obj/structure/table/rack/folding_table/dismantle(obj/item/wrench/W, mob/user)
	return FALSE

/obj/structure/table/rack/folding_table/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	. = ..()
	if(use_check(user) || !Adjacent(user))
		return
	if(!ishuman(user) && (!isrobot(user) || isDrone(user))) //Humans and borgs can collapse, but not drones
		return
	new /obj/item/material/folding_table(get_turf(src))
	user.visible_message(SPAN_NOTICE("\The [user] collapses \the [src]."))
	qdel(src)

/obj/item/material/stool/chair/folding/camping
	default_material = MATERIAL_ALUMINIUM

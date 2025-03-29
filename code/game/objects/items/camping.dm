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
	 * The state name of an overlay in `icons/obj/item/tent_decals.dmi`
	 * Used for branded tents, such as the SCC base camp tent
	 */
	var/decal

/datum/large_structure/tent/build_structures()
	. = ..()
	var/list/roofs = list()
	for(var/obj/structure/component/tent_canvas/C in grouped_structures)
		var/perspective_fix = FALSE // Used to make E/W facing even tents have similar perspective to odd ones
		if(dir & (NORTH | SOUTH))
			if(C.x == x1 || C.x == x2)
				C.icon_state = "canvas_[get_location(C)]"
			var/mid = Mean(x1, x2)
			if(C.x < mid)
				C.dir = WEST
			else
				C.dir = EAST
		else
			var/width = y2 - y1
			if(C.y == y1 || C.y == y2)
				C.icon_state = "canvas_[get_location(C)]"
				if(C.y == y2) //Upper wall
					C.layer = ABOVE_TILE_LAYER
			var/mid = Mean(y1, y2)
			if(C.y < mid)
				C.dir = SOUTH
			else
				if(ISODD(width) && C.y == Ceil(mid)) // `width` is actually 1 less than the width, so we need to check if this is odd
					perspective_fix = TRUE
				C.dir = NORTH
		var/obj/structure/component/tent_canvas/roof/roof = new /obj/structure/component/tent_canvas/roof(C.loc)
		roofs += roof
		roof.color = color
		roof.dir = C.dir
		if(decal && C.x == x1 && C.y == y1)
			roof.AddOverlays(overlay_image('icons/obj/item/tent_decals.dmi', decal, flags=RESET_COLOR))
		roof.icon_state = "roof_[get_location(C)]"
		if(perspective_fix)
			roof.AddOverlays(overlay_image(roof.icon, "[roof.icon_state]_p"))

	grouped_structures += roofs

/datum/large_structure/tent/structure_entered(turf/entry_point, atom/movable/entering)
	. = ..()
	if(!.)
		return
	if(!istype(entering, /mob))
		return

	var/mob/M = entering
	var/atom/movable/renderer/roofs/roof_plane = M.GetRenderer(/atom/movable/renderer/roofs)
	if(roof_plane)
		roof_plane.alpha = 76

/datum/large_structure/tent/mob_moved(mob/mover, turf/exit_point)
	. = ..()
	if(!.)
		var/atom/movable/renderer/roofs/roof_plane = mover.GetRenderer(/atom/movable/renderer/roofs)
		if(roof_plane)
			roof_plane.alpha = 255

/**
 * Determines the state to use for each section of the tent
 * Returns `edge` for structures on the edge of the tent
 * Returns `entrance_top` for structures acting as an entrance, at the north/east of the tent
 * Returns `entrance_bot` for structures acting as an entrance, at the south/west of the tent
 * Returns `edge_entrance_top` for structures on the edge of the tent, and acting as an entrance, at the north/east of the tent
 * Returns `edge_entrance_bot` for structures on the edge of the tent, and acting as an entrance, at the south/west of the tent
 * Returns `mid` for structures in the exact centre of the tent, for odd number widths
 * Returns `mid_entrance_top` for structures in the exact centre of the tent, for odd number widths, acting as an entrance, at the north/east of the tent
 * Returns `mid_entrance_bot` for structures in the exact centre of the tent, for odd number widths, acting as an entrance, at the south/west of the tent
 * Otherwise returns `norm` for other structures
 */
/datum/large_structure/tent/proc/get_location(var/obj/structure/component/tent_canvas/canvas)
	var/edge1
	var/edge2
	var/side_coord
	var/top_coord
	var/top_edge
	var/bot_edge
	if(dir & (NORTH | SOUTH))
		edge1 = x1
		edge2 = x2
		side_coord = canvas.x
		top_edge = y2
		bot_edge = y1
		top_coord = canvas.y
	else
		edge1 = y1
		edge2 = y2
		side_coord = canvas.y
		top_edge = x2
		bot_edge = x1
		top_coord = canvas.x
	if(side_coord == edge1 || side_coord == edge2)
		if(top_coord == top_edge)
			return "edge_entrance_top"
		else if(top_coord == bot_edge)
			return "edge_entrance_bot"
		return "edge"
	else if(side_coord == Mean(edge1, edge2))
		if(top_coord == top_edge)
			return "mid_entrance_top"
		else if(top_coord == bot_edge)
			return "mid_entrance_bot"
		return "mid"
	else if(top_coord == top_edge)
		return "entrance_top"
	else if(top_coord == bot_edge)
		return "entrance_bot"
	return "norm"

/obj/item/tent
	name = "expedition tent"
	desc = "A rolled up tent, ready to be assembled to make a base camp, shelter, or just a cozy place to chat."
	desc_info = "Drag this to yourself to begin assembly. This will take some time, in 4 stages. Others can start working on the other stages by dragging it to themselves as well."
	icon = 'icons/obj/item/camping.dmi'
	icon_state = "tent"
	item_state = "tent"
	contained_sprite = TRUE
	w_class = WEIGHT_CLASS_BULKY
	color = "#58a178"
	var/width = 2
	var/length = 3
	var/decal

	var/datum/large_structure/tent/my_tent

/obj/item/tent/Initialize()
	. = ..()
	w_class = min(ceil(width * length / 1.5), WEIGHT_CLASS_GIGANTIC) // 2x2 = WEIGHT_CLASS_NORMAL
	desc += "\nThis one is [width] x [length] in size."

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
			my_tent.assemble(1 SECOND, user)
			return
		else
			QDEL_NULL(my_tent)

	var/deploy_dir = get_compass_dir(user,target)
	if(target == get_turf(user))
		deploy_dir = user.dir

	my_tent = new /datum/large_structure/tent(src)
	setup_my_tent(deploy_dir, target)

	my_tent.assemble(1 SECOND, user)

/obj/item/tent/proc/setup_my_tent(var/deploy_dir, var/turf/target)
	my_tent.name = name
	my_tent.color = color
	my_tent.decal = decal
	my_tent.dir = deploy_dir
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
	width = 3
	length = 4

/obj/item/tent/big/scc
	name = "scc base camp tent"
	decal = "scc"

/obj/item/tent/mining
	name = "miners' tent"
	color = "#8b7242"
	width = 3
	length = 3

/obj/structure/component/tent_canvas
	name = "tent canvas"
	desc = "The fabric and poles which make up the wall of a tent. Not air-tight, but able to keep out the weather, and very cozy."
	desc_info = "Drag this to yourself to begin disassembly. This will take some time, in 4 stages. Others can start working on the other stages by dragging it, or other sections, to themselves as well."
	icon = 'icons/obj/item/camping.dmi'
	icon_state = "canvas"
	item_state = "canvas"
	anchored = TRUE
	density = TRUE
	atom_flags = ATOM_FLAG_CHECKS_BORDER
	atmos_canpass = CANPASS_ALWAYS //Tents are not air tight
	layer = ABOVE_HUMAN_LAYER

/obj/structure/component/tent_canvas/CanPass(atom/movable/mover, turf/target, height, air_group)
	. = ..()
	if(icon_state in list("canvas", "canvas_mid", "canvas_entrance_top", "canvas_entrace_bot"))
		return TRUE	//Non-directional, always allow passage
	if(get_dir(loc, target) & dir)
		return !density
	return TRUE

/obj/structure/component/tent_canvas/CheckExit(atom/movable/O, turf/target)
	. = ..()
	if(icon_state in list("canvas", "canvas_mid", "canvas_entrance_top", "canvas_entrace_bot"))
		return TRUE	//Non-directional, always allow passage
	if(get_dir(O.loc, target) & dir)
		return !density
	return TRUE

/obj/structure/component/tent_canvas/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	..()
	if(use_check(usr, USE_ALLOW_NON_ADJACENT) || (get_dist(usr, src) > 1)) // use_check() can't check for adjacency due to density issues, so we check range as well
		return
	part_of.disassemble(2 SECONDS, usr, src)

/obj/structure/component/tent_canvas/Destroy() //When we're destroyed, make sure we return the roof plane to anyone inside
	for(var/mob/M in loc)
		var/atom/movable/renderer/roofs/roof_plane = M.GetRenderer(/atom/movable/renderer/roofs)
		if(roof_plane)
			roof_plane.alpha = 255
	return ..()

/obj/structure/component/tent_canvas/roof
	plane = ROOF_PLANE

/obj/structure/component/tent_canvas/roof/CanPass(atom/movable/mover, turf/target, height, air_group)
	return TRUE

/obj/structure/component/tent_canvas/roof/CheckExit(atom/movable/O, turf/target)
	return TRUE

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
	desc_extended = "This item can be attached to a backpack."
	icon = 'icons/obj/item/camping.dmi'
	icon_state = "sleepingbag"
	item_state = "sleepingbag"
	contained_sprite = TRUE
	w_class = WEIGHT_CLASS_BULKY

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

/obj/item/sleeping_bag/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	. = ..()
	if(use_check(usr) || !Adjacent(usr))
		return
	var/turf/T = get_turf(src)
	if(istype(T))
		unroll(T, usr)

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
	buckling_sound = 'sound/items/drop/cloth.ogg'
	held_item = /obj/item/sleeping_bag
	can_dismantle = FALSE
	can_pad = FALSE

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

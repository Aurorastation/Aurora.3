/obj/structure/table
	name = "table frame"
	icon = 'icons/obj/structure/tables/table.dmi'
	icon_state = "frame"
	desc = "It's a table, for putting things on. Or standing on, if you really want to."
	density = 1
	anchored = 1
	climbable = TRUE
	layer = TABLE_LAYER
	throwpass = 1
	breakable = TRUE
	var/flipped = 0
	var/maxhealth = 10
	var/health = 10

	// For racks.
	var/can_reinforce = 1
	var/can_plate = 1

	var/manipulating = 0
	var/material/reinforced = null

	// Gambling tables. I'd prefer reinforced with carpet/felt/cloth/whatever, but AFAIK it's either harder or impossible to get /obj/item/stack/material of those.
	// Convert if/when you can easily get stacks of these.
	var/carpeted = 0

	var/list/connections = list("nw0", "ne0", "sw0", "se0")

/obj/structure/table/proc/update_material()
	var/old_maxhealth = maxhealth
	if(!material)
		maxhealth = 10
	else
		maxhealth = material.integrity / 2

		if(reinforced)
			maxhealth += reinforced.integrity / 2

	health += maxhealth - old_maxhealth

/obj/structure/table/proc/take_damage(amount, msg = TRUE)
	// If the table is made of a brittle material, and is *not* reinforced with a non-brittle material, damage is multiplied by TABLE_BRITTLE_MATERIAL_MULTIPLIER
	if(material && material.is_brittle())
		if(reinforced)
			if(reinforced.is_brittle())
				amount *= TABLE_BRITTLE_MATERIAL_MULTIPLIER
		else
			amount *= TABLE_BRITTLE_MATERIAL_MULTIPLIER
	health -= amount
	if(health <= 0)
		if(msg)
			visible_message(SPAN_WARNING("\The [src] breaks down!"), intent_message = THUNK_SOUND)
		return break_to_parts() // if we break and form shards, return them to the caller to do !FUN! things with

/obj/structure/table/attack_generic(var/mob/user, var/damage, var/attack_message = "attacks", var/wallbreaker)
	if(!damage || !wallbreaker)
		return
	user.do_attack_animation(src)
	visible_message(SPAN_DANGER("[user] [attack_message] \the [src]!"))
	take_damage(damage)
	return TRUE

/obj/structure/table/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			take_damage(rand(100,400), FALSE)
		if(3.0)
			take_damage(rand(50,150), FALSE)


/obj/structure/table/Initialize()
	. = ..()

	// One table per turf.
	for(var/obj/structure/table/T in loc)
		if(T != src)
			// There's another table here that's not us, break to metal.
			// break_to_parts calls qdel(src)
			break_to_parts(full_return = 1)
			return

	// reset color/alpha and icon, since they're set for nice map previews
	icon = 'icons/obj/structure/tables/table.dmi'
	color = "#ffffff"
	alpha = 255
	update_connections(1)
	queue_icon_update()
	update_desc()
	update_material()

/obj/structure/table/Destroy()
	material = null
	reinforced = null
	update_connections(1) // Update tables around us to ignore us (material=null forces no connections)
	for(var/obj/structure/table/T in oview(src, 1))
		T.queue_icon_update()
	return ..()

/obj/structure/table/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(health < maxhealth)
		switch(health / maxhealth)
			if(0.0 to 0.5)
				. += "<span class='warning'>It looks severely damaged!</span>"
			if(0.25 to 0.5)
				. += "<span class='warning'>It looks damaged!</span>"
			if(0.5 to 1.0)
				. += "<span class='notice'>It has a few scrapes and dents.</span>"

/obj/structure/table/attackby(obj/item/attacking_item, mob/user)
	if(reinforced && attacking_item.isscrewdriver())
		remove_reinforced(attacking_item, user)
		if(!reinforced)
			update_desc()
			queue_icon_update()
			update_material()
		return 1

	if(carpeted && attacking_item.iscrowbar())
		user.visible_message("<span class='notice'>\The [user] removes the carpet from \the [src].</span>",
								"<span class='notice'>You remove the carpet from \the [src].</span>")
		new /obj/item/stack/tile/carpet(loc)
		carpeted = 0
		queue_icon_update()
		return 1

	if(!carpeted && material && istype(attacking_item, /obj/item/stack/tile/carpet))
		var/obj/item/stack/tile/carpet/C = attacking_item
		if(C.use(1))
			user.visible_message("<span class='notice'>\The [user] adds \the [C] to \the [src].</span>",
									"<span class='notice'>You add \the [C] to \the [src].</span>")
			carpeted = 1
			queue_icon_update()
			return 1
		else
			to_chat(user, "<span class='warning'>You don't have enough carpet!</span>")

	if(!reinforced && !carpeted && material && (attacking_item.iswrench() || istype(attacking_item, /obj/item/gun/energy/plasmacutter)))
		remove_material(attacking_item, user)
		if(!material)
			update_connections(1)
			queue_icon_update()
			for(var/obj/structure/table/T in oview(src, 1))
				T.queue_icon_update()
			update_desc()
			update_material()
		return 1

	if(!carpeted && !reinforced && !material && (attacking_item.iswrench() || istype(attacking_item, /obj/item/gun/energy/plasmacutter)))
		dismantle(attacking_item, user)
		return 1

	if(health < maxhealth && attacking_item.iswelder())
		var/obj/item/weldingtool/F = attacking_item
		if(F.welding)
			to_chat(user, "<span class='notice'>You begin reparing damage to \the [src].</span>")
			if(!attacking_item.use_tool(src, user, 20, volume = 50) || !F.use(1, user))
				return
			user.visible_message("<span class='notice'>\The [user] repairs some damage to \the [src].</span>",
									"<span class='notice'>You repair some damage to \the [src].</span>")
			health = max(health+(maxhealth/5), maxhealth) // 20% repair per application
			return 1

	if(!material && can_plate && istype(attacking_item, /obj/item/stack/material))
		material = common_material_add(attacking_item, user, "plat")
		if(material)
			update_connections(1)
			queue_icon_update()
			update_desc()
			update_material()
		return 1

	if(!material && can_plate && istype(attacking_item, /obj/item/reagent_containers/cooking_container/board/bowl))
		new /obj/structure/chemkit(loc)
		qdel(attacking_item)
		qdel(src)
		return 1

	return ..()

/obj/structure/table/MouseDrop_T(obj/item/stack/material/what)
	if(can_reinforce && isliving(usr) && (!usr.stat) && istype(what) && usr.get_active_hand() == what && Adjacent(usr))
		reinforce_table(what, usr)
	else
		return ..()

/obj/structure/table/proc/reinforce_table(obj/item/stack/material/S, mob/user)
	if(reinforced)
		to_chat(user, "<span class='warning'>\The [src] is already reinforced!</span>")
		return

	if(!can_reinforce)
		to_chat(user, "<span class='warning'>\The [src] cannot be reinforced!</span>")
		return

	if(!material)
		to_chat(user, "<span class='warning'>Plate \the [src] before reinforcing it!</span>")
		return

	if(flipped)
		to_chat(user, "<span class='warning'>Put \the [src] back in place before reinforcing it!</span>")
		return

	reinforced = common_material_add(S, user, "reinforc")
	if(reinforced)
		breakable = FALSE
		update_desc()
		queue_icon_update()
		update_material()

/obj/structure/table/proc/update_desc()
	if(material)
		if(material_alteration & MATERIAL_ALTERATION_NAME)
			name = "[material.display_name] table"
	else
		name = "table frame"

	if(reinforced)
		name = "reinforced [name]"
		desc = "[initial(desc)] This one seems to be reinforced with [reinforced.display_name]."
	else
		desc = initial(desc)

// Returns the material to set the table to.
/obj/structure/table/proc/common_material_add(obj/item/stack/material/S, mob/user, verb) // Verb is actually verb without 'e' or 'ing', which is added. Works for 'plate'/'plating' and 'reinforce'/'reinforcing'.
	var/material/M = S.get_material()
	if(!istype(M))
		to_chat(user, "<span class='warning'>You cannot [verb]e \the [src] with \the [S].</span>")
		return null

	if(manipulating) return M
	manipulating = 1
	to_chat(user, "<span class='notice'>You begin [verb]ing \the [src] with [M.display_name].</span>")
	if(!do_after(user, 2 SECONDS, src, DO_REPAIR_CONSTRUCT) || !S.use(1))
		manipulating = 0
		return null
	user.visible_message("<span class='notice'>\The [user] [verb]es \the [src] with [M.display_name].</span>", "<span class='notice'>You finish [verb]ing \the [src].</span>")
	manipulating = 0
	return M

// Returns the material to set the table to.
/obj/structure/table/proc/common_material_remove(mob/user, material/M, delay, what, type_holding, sound)
	if(!M.stack_type)
		to_chat(user, "<span class='warning'>You are unable to remove the [what] from this table!</span>")
		return M

	if(manipulating) return M
	manipulating = 1
	user.visible_message("<span class='notice'>\The [user] begins removing the [type_holding] holding \the [src]'s [M.display_name] [what] in place.</span>",
							"<span class='notice'>You begin removing the [type_holding] holding \the [src]'s [M.display_name] [what] in place.</span>")
	if(sound)
		playsound(src.loc, sound, 50, 1)
	if(!do_after(user, 4 SECONDS, src, DO_REPAIR_CONSTRUCT))
		manipulating = 0
		return M
	user.visible_message("<span class='notice'>\The [user] removes the [M.display_name] [what] from \the [src].</span>",
							"<span class='notice'>You remove the [M.display_name] [what] from \the [src].</span>")
	new M.stack_type(src.loc)
	manipulating = 0
	return null

/obj/structure/table/proc/remove_reinforced(obj/item/screwdriver/S, mob/user)
	reinforced = common_material_remove(user, reinforced, 40, "reinforcements", "screws", 'sound/items/Screwdriver.ogg')
	breakable = TRUE

/obj/structure/table/proc/remove_material(obj/item/wrench/W, mob/user)
	material = common_material_remove(user, material, 20, "plating", "bolts", W.usesound)

/obj/structure/table/dismantle(obj/item/wrench/W, mob/user)
	if(manipulating)
		return
	manipulating = TRUE
	user.visible_message("<b>[user]</b> begins dismantling \the [src].",
						SPAN_NOTICE("You begin dismantling \the [src]."))
	if(!W.use_tool(src, user, 20, volume = 50))
		manipulating = FALSE
		return
	user.visible_message("\The [user] dismantles \the [src].",
						SPAN_NOTICE("You dismantle \the [src]."))
	new /obj/item/stack/rods(src.loc, 2)
	qdel(src)

// Returns a list of /obj/item/material/shard objects that were created as a result of this table's breakage.
// Used for !fun! things such as embedding shards in the faces of tableslammed people.

// The repeated
//     S = [x].place_shard(loc)
//     if(S) shards += S
// is to avoid filling the list with nulls, as place_shard won't place shards of certain materials (holo-wood, holo-steel)

/obj/structure/table/proc/break_to_parts(full_return = 0)
	var/list/shards = list()
	var/obj/item/material/shard/S = null
	if(reinforced)
		if(reinforced.stack_type && (full_return || prob(20)))
			reinforced.place_sheet(loc)
		else
			S = reinforced.place_shard(loc)
			if(S) shards += S
	if(material)
		if(material.stack_type && (full_return || prob(20)))
			material.place_sheet(loc)
		else
			S = material.place_shard(loc)
			if(S) shards += S
	if(carpeted && (full_return || prob(50))) // Higher chance to get the carpet back intact, since there's no non-intact option
		new /obj/item/stack/tile/carpet(src.loc)
	if(full_return || prob(20))
		new /obj/item/stack/rods(src.loc, 2)
	else
		new /obj/item/stack/rods(src.loc)
	qdel(src)
	return shards

/obj/structure/table/update_icon()
	cut_overlays()
	icon_state = "blank"
	var/image/I
	if(flipped != 1)
		if(material) // Standard table image.
			for(var/i = 1 to 4)
				if(material.table_icon)
					if(reinforced && ("reinf_[material.name]_[connections[i]]" in icon_states(material.table_icon)))
						I = image(material.table_icon, "reinf_[material.name]_[connections[i]]", dir = 1<<(i-1))
					else
						I = image(material.table_icon, "[material.name]_[connections[i]]", dir = 1<<(i-1))
				else
					if(reinforced && ("reinf_[material.icon_base]_[connections[i]]" in icon_states(icon)))
						I = image(icon, "reinf_[material.icon_base]_[connections[i]]", dir = 1<<(i-1))
					else
						I = image(icon, "[material.icon_base]_[connections[i]]", dir = 1<<(i-1))
					if(material.icon_colour)
						I.color = material.icon_colour
				add_overlay(I)
		else // Table frame
			for(var/i = 1 to 4)
				I = image(icon, "[connections[i]]", dir = 1<<(i-1))
				add_overlay(I)

		if(reinforced)	// Reinforcements.
			for(var/i = 1 to 4)
				if("reinf_[reinforced.name]_[connections[i]]" in icon_states('icons/obj/structure/tables/table_reinf.dmi')) // if it's got an existing purpose-made reinforced icon, and it isn't already a generic one, use it
					I = image('icons/obj/structure/tables/table_reinf.dmi', "reinf_[reinforced.name]_[connections[i]]", dir = 1<<(i-1))
				else
					I = image('icons/obj/structure/tables/table_reinf.dmi', "[reinforced.reinf_icon]_[connections[i]]", dir = 1<<(i-1)) // else use the generic recolorable one
				if(reinforced.icon_colour && ("reinf_[reinforced.name]" == "[reinforced.reinf_icon]"))
					I.color = reinforced.icon_colour
				add_overlay(I)

		if(carpeted)
			for(var/i = 1 to 4)
				I = image(icon, "carpet_[connections[i]]", dir = 1<<(i-1))
				add_overlay(I)

	else	// Flipped table
		var/type = 0
		var/tabledirs = 0
		for(var/direction in list(turn(dir,90), turn(dir,-90)) )
			var/obj/structure/table/T = locate(/obj/structure/table ,get_step(src,direction))
			if (T && T.flipped == 1 && T.dir == src.dir && material && T.material && T.material.name == material.name)
				type++
				tabledirs |= direction

		type = "[type]"
		if (type=="1")
			if (tabledirs & turn(dir,90))
				type += "-"
			if (tabledirs & turn(dir,-90))
				type += "+"

		if(material)
			if(material.table_icon)
				if(reinforced && ("reinf_[material.name]_flip[type]" in icon_states(material.table_icon)))
					I = image(material.table_icon, "reinf_[material.name]_flip[type]")
				else
					I = image(material.table_icon, "[material.name]_flip[type]")
			else
				if(reinforced && ("reinf_[material.icon_base]_flip[type]" in icon_states(icon)))
					I = image(icon, "reinf_[material.icon_base]_flip[type]")
				else
					I = image(icon, "[material.icon_base]_flip[type]")
				if(material.icon_colour)
					I.color = material.icon_colour
			add_overlay(I)
			if(material.display_name)
				if(material.display_name == "comfy")
					name = "fancy table"
				else
					name = "[material.display_name] table"
		else
			I = image(icon, "flip[type]")
			name = "table frame"
			add_overlay(I)

		if(reinforced)
			if("reinf_[reinforced.name]_flip[type]" in icon_states('icons/obj/structure/tables/table_reinf.dmi')) // if it's got an existing purpose-made reinforced icon, and it isn't already a generic one, use it
				I = image('icons/obj/structure/tables/table_reinf.dmi', "reinf_[reinforced.name]_flip[type]")
			else
				I = image('icons/obj/structure/tables/table_reinf.dmi', "[reinforced.reinf_icon]_flip[type]") // else use the generic recolorable one
			if(reinforced.icon_colour && ("reinf_[reinforced.name]" == "[reinforced.reinf_icon]"))
				I.color = reinforced.icon_colour
			add_overlay(I)

		if(carpeted)
			add_overlay("carpet_flip[type]")

// set propagate if you're updating a table that should update tables around it too, for example if it's a new table or something important has changed (like material).
/obj/structure/table/proc/update_connections(propagate=0)
	if(!material)
		connections = list("0", "0", "0", "0")

		if(propagate)
			for(var/obj/structure/table/T in oview(src, 1))
				T.update_connections()
		return

	var/list/blocked_dirs = list()
	for(var/obj/structure/window/W in get_turf(src))
		if(W.is_fulltile())
			connections = list("0", "0", "0", "0")
			return
		blocked_dirs |= W.dir

	for(var/D in list(NORTH, SOUTH, EAST, WEST) - blocked_dirs)
		var/turf/T = get_step(src, D)
		for(var/obj/structure/window/W in T)
			if(W.is_fulltile() || W.dir == GLOB.reverse_dir[D])
				blocked_dirs |= D
				break
			else
				if(W.dir != D) // it's off to the side
					blocked_dirs |= W.dir|D // blocks the diagonal

	for(var/D in list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST) - blocked_dirs)
		var/turf/T = get_step(src, D)

		for(var/obj/structure/window/W in T)
			if(W.is_fulltile() || W.dir & GLOB.reverse_dir[D])
				blocked_dirs |= D
				break

	// Blocked cardinals block the adjacent diagonals too. Prevents weirdness with tables.
	for(var/x in list(NORTH, SOUTH))
		for(var/y in list(EAST, WEST))
			if((x in blocked_dirs) || (y in blocked_dirs))
				blocked_dirs |= x|y

	var/list/connection_dirs = list()

	for(var/obj/structure/table/T in orange(src, 1))
		var/T_dir = get_dir(src, T)
		if(T_dir in blocked_dirs) continue
		if(material && T.material && material.name == T.material.name && flipped == T.flipped)
			connection_dirs |= T_dir
		if(propagate)
			INVOKE_ASYNC(T, PROC_REF(update_connections))
			INVOKE_ASYNC(T, TYPE_PROC_REF(/atom, queue_icon_update))

	connections = dirs_to_corner_states(connection_dirs)

#define CORNER_NONE 0
#define CORNER_COUNTERCLOCKWISE 1
#define CORNER_DIAGONAL 2
#define CORNER_CLOCKWISE 4

/*
turn() is weird:
	turn(icon, angle) turns icon by angle degrees clockwise
	turn(matrix, angle) turns matrix by angle degrees clockwise
	turn(dir, angle) turns dir by angle degrees counter-clockwise
*/

/proc/dirs_to_corner_states(list/dirs)
	if(!istype(dirs)) return

	var/list/ret = list(NORTHWEST, SOUTHEAST, NORTHEAST, SOUTHWEST)

	for(var/i = 1 to ret.len)
		var/dir = ret[i]
		. = CORNER_NONE
		if(dir in dirs)
			. |= CORNER_DIAGONAL
		if(turn(dir,45) in dirs)
			. |= CORNER_COUNTERCLOCKWISE
		if(turn(dir,-45) in dirs)
			. |= CORNER_CLOCKWISE
		ret[i] = "[.]"

	return ret

#undef CORNER_NONE
#undef CORNER_COUNTERCLOCKWISE
#undef CORNER_DIAGONAL
#undef CORNER_CLOCKWISE

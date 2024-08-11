/turf/simulated/wall/diona
	icon = 'icons/turf/smooth/wall_preview.dmi'
	icon_state = "diona"

/turf/simulated/wall/diona/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, "biomass")
	canSmoothWith = list(src.type)

/obj/structure/diona
	icon = 'icons/obj/diona.dmi'
	anchored = TRUE
	density = TRUE
	opacity = FALSE
	layer = ABOVE_TILE_LAYER
	var/max_health = 50
	var/health
	var/destroy_spawntype = /mob/living/carbon/alien/diona

/obj/structure/diona/Initialize(mapload)
	. = ..()
	health = max_health

/obj/structure/diona/attackby(obj/item/attacking_item, mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(attacking_item.iswelder())
		var/obj/item/weldingtool/WT = attacking_item
		if (!WT.welding)
			to_chat(user, SPAN_WARNING("\The [WT] must be turned on!"))
			return
		else if (WT.use(0,user))
			user.visible_message("<b>[user]</b> begins slicing through the skin of \the [src].",
									SPAN_NOTICE("You begin slicing through the skin of \the [src]."))
			if(!attacking_item.use_tool(src, user, 20, volume = 50))
				return
			if(QDELETED(src) || !WT.isOn())
				return
			user.visible_message("<b>[user]</b> slices through the skin of \the [src].",
									SPAN_NOTICE("You slice through \the [src]."))
		qdel(src)
	else
		user.do_attack_animation(src)
		if(attacking_item.force)
			user.visible_message(SPAN_DANGER("\The [user] [pick(attacking_item.attack_verb)] \the [src] with \the [attacking_item]!"),
									SPAN_NOTICE("You [pick(attacking_item.attack_verb)] \the [src] with \the [attacking_item]!"))
			playsound(loc, attacking_item.hitsound, attacking_item.get_clamped_volume(), TRUE)
			playsound(loc, /singleton/sound_category/wood_break_sound, 50, TRUE)
			health -= attacking_item.force
			if(health <= 0)
				qdel(src)

/obj/structure/diona/Destroy()
	if(destroy_spawntype)
		if(ispath(destroy_spawntype, /mob/living/carbon/alien/diona))
			var/turf/T = get_turf(src)
			T.spawn_diona_nymph()
		else
			new destroy_spawntype(get_turf(src))
	return ..()

/obj/structure/diona/vines
	name = "biomass vines"
	desc = "Thick, heavy vines made of some sort of biomass."
	icon_state = "vines3"
	density = FALSE
	destroy_spawntype = null
	var/growth = 0

/obj/structure/diona/vines/proc/spread()
	var/turf/origin = get_turf(src)
	for(var/turf/T in range(src,2))
		if(T.density || T == origin || istype(T, /turf/space))
			continue
		var/new_growth = 1
		switch(get_dist(origin,T))
			if(0)
				new_growth = 3
			if(1)
				new_growth = 2
		var/obj/structure/diona/vines/existing = locate() in T
		if(!istype(existing)) existing = new /obj/structure/diona/vines(T)
		if(existing.growth < new_growth)
			existing.growth = new_growth
			existing.update_icon()

/obj/structure/diona/vines/update_icon()
	icon_state = "vines[growth]"

/obj/structure/diona/bulb
	name = "glow bulb"
	desc = "A glowing bulb of some sort."
	icon_state = "glowbulb"
	light_power = 3
	light_range = 3
	light_color = "#557733"
	density = FALSE
	destroy_spawntype = null

/obj/structure/diona/bulb/unpowered
	name = "unpowered glow bulb"
	desc = "A bulb of some sort. Seems like it needs some power."
	desc_info = "This bulb requires a power cell to glow. Click on it with a power cell in hand to plug it in."
	light_power = 0
	light_range = 0

/obj/structure/diona/bulb/unpowered/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/cell))
		to_chat(user, SPAN_NOTICE("You jack the power cell into the glow bulb."))
		new /obj/structure/diona/bulb(get_turf(src))
		destroy_spawntype = null
		qdel(attacking_item)
		qdel(src)
	..()

/datum/random_map/automata/diona
	iterations = 3
	descriptor = "diona gestalt"
	limit_x = 32
	limit_y = 32

	wall_type = /turf/simulated/wall/diona
	floor_type = /turf/simulated/floor/diona

// This is disgusting.
/datum/random_map/automata/diona/proc/search_neighbors_for(var/search_val, var/x, var/y)
	var/current_cell = get_map_cell(x-1,y-1)
	if(current_cell && map[current_cell] == search_val) return 1
	current_cell = get_map_cell(x-1,y)
	if(current_cell && map[current_cell] == search_val) return 1
	current_cell = get_map_cell(x-1,y+1)
	if(current_cell && map[current_cell] == search_val) return 1
	current_cell = get_map_cell(x,y-1)
	if(current_cell && map[current_cell] == search_val) return 1
	current_cell = get_map_cell(x,y+1)
	if(current_cell && map[current_cell] == search_val) return 1
	current_cell = get_map_cell(x+1,y-1)
	if(current_cell && map[current_cell] == search_val) return 1
	current_cell = get_map_cell(x+1,y)
	if(current_cell && map[current_cell] == search_val) return 1
	current_cell = get_map_cell(x+1,y+1)
	if(current_cell && map[current_cell] == search_val) return 1
	return 0

/datum/random_map/automata/diona/cleanup()

	// Hollow out the interior spaces.
	for(var/x = 1, x <= limit_x, x++)
		for(var/y = 1, y <= limit_y, y++)
			var/current_cell = get_map_cell(x,y)
			if(!current_cell) continue
			if(map[current_cell] == WALL_CHAR)
				if(!search_neighbors_for(FLOOR_CHAR,x,y) && !search_neighbors_for(DOOR_CHAR,x,y) && !(x == 1 || y == 1 || x == limit_x || y == limit_y))
					map[current_cell] = EMPTY_CHAR

	// Prune exposed floor turfs away from the edges.
	var/changed = 1
	while(changed)
		for(var/x = 1, x <= limit_x, x++)
			for(var/y = 1, y <= limit_y, y++)
				changed = 0
				var/current_cell = get_map_cell(x,y)
				if(!current_cell) continue
				if(map[current_cell] == EMPTY_CHAR)
					if((search_neighbors_for(FLOOR_CHAR,x,y)) || (x == 1 || y == 1 || x == limit_x || y == limit_y))
						map[current_cell] = FLOOR_CHAR
						changed = 1

	// Count and track the floors.
	var/list/floor_turfs = list()
	for(var/x = 1, x <= limit_x, x++)
		for(var/y = 1, y <= limit_y, y++)
			var/current_cell = get_map_cell(x,y)
			if(!current_cell) continue
			if(map[current_cell] == EMPTY_CHAR)
				floor_turfs |= current_cell

	// Add vine decals.
	for(var/x = 1, x <= limit_x, x++)
		for(var/y = 1, y <= limit_y, y++)
			var/current_cell = get_map_cell(x,y)
			if(!current_cell || map[current_cell] != EMPTY_CHAR) continue
			if(search_neighbors_for(WALL_CHAR,x,y))
				map[current_cell] = DOOR_CHAR

	// Add bulbs and doona nymphs.
	if(floor_turfs.len)
		var/bulb_count = rand(round(floor_turfs.len/10),round(floor_turfs.len/8))
		while(floor_turfs.len && bulb_count)
			var/cell = pick(floor_turfs)
			floor_turfs -= cell
			map[cell] = ARTIFACT_CHAR
			bulb_count--
		if(floor_turfs.len)
			var/nymph_count = rand(round(floor_turfs.len/10),round(floor_turfs.len/8))
			while(floor_turfs.len && nymph_count)
				var/cell = pick(floor_turfs)
				floor_turfs -= cell
				map[cell] = MONSTER_CHAR
				nymph_count--
	return

/datum/random_map/automata/diona/get_appropriate_path(var/value)
	switch(value)
		if(EMPTY_CHAR, DOOR_CHAR, MONSTER_CHAR, ARTIFACT_CHAR)
			return floor_type
		if(WALL_CHAR)
			return wall_type

/datum/random_map/automata/diona/get_additional_spawns(var/value, var/turf/T)

	if(value != FLOOR_CHAR)
		for(var/thing in T)
			if(istype(thing, /atom))
				var/atom/A = thing
				if(A.simulated)
					continue
			qdel(thing)

	switch(value)
		if(ARTIFACT_CHAR)
			new /obj/structure/diona/bulb(T)
		if(MONSTER_CHAR)
			T.spawn_diona_nymph()
		if(DOOR_CHAR)
			var/obj/structure/diona/vines/V = new(T)
			V.growth = 3
			V.update_icon()
			spawn(1)
				V.spread()

/obj/random
	name = "random object"
	desc = "This item type is used to spawn random objects at round-start"
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"
	var/spawn_nothing_percentage = 0 // this variable determines the likelyhood that this random object will not spawn anything
	var/list/spawnlist
	var/list/problist
	var/has_postspawn

// creates a new object and deletes itself

/obj/random/Initialize()
	. = ..()
	if (!prob(spawn_nothing_percentage))
		var/obj/spawned_item = spawn_item()
		if(spawned_item)
			spawned_item.pixel_x = pixel_x
			spawned_item.pixel_y = pixel_y
			if(has_postspawn)
				post_spawn(spawned_item)

	return INITIALIZE_HINT_QDEL

// this function should return a specific item to spawn
/obj/random/proc/item_to_spawn()
	return 0

/obj/random/proc/post_spawn(obj/thing)
	log_debug("random_obj: [DEBUG_REF(src)] registered itself as having post_spawn, but did not override post_spawn()!")

// creates the random item
/obj/random/proc/spawn_item()
	if (spawnlist)
		var/itemtype = pick(spawnlist)
		. = new itemtype(loc)

	else if (problist)
		var/itemtype = pickweight(problist)
		. = new itemtype(loc)

	else
		var/itemtype = item_to_spawn()
		. = new itemtype(loc)

	if (!.)
		log_debug("random_obj: [DEBUG_REF(src)] returned null item!")

/obj/random/single
	name = "randomly spawned object"
	desc = "This item type is used to randomly spawn a given object at round-start"
	icon_state = "x3"
	var/spawn_object = null

/obj/random/single/item_to_spawn()
	return ispath(spawn_object) ? spawn_object : text2path(spawn_object)

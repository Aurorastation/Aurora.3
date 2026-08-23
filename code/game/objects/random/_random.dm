/obj/random
	name = "random object"
	desc = "This item type is used to spawn random objects at round-start"
	icon = 'icons/obj/random.dmi'
	icon_state = "need-sprite"
	/// Determines the likelyhood to not spawn anything
	var/spawn_nothing_percentage = 0
	/// Spawn list.
	/// Weights can be provided optionally.
	/// Items with no weight provided have default weight of 1.
	var/list/spawnlist = null
	/// Whether post spawn proc is overriden and should be called.
	var/has_postspawn = FALSE
	/// Whether it is area consistent.
	/// If true, the result is the same for every random spawner in a single area.
	var/is_area_consistent = FALSE
	/// Whether it is map template consistent.
	var/is_map_template_consistent = FALSE

/// Creates a new object and deletes itself
/obj/random/Initialize()
	. = ..()
	if (!prob(spawn_nothing_percentage))
		var/obj/spawned_item = spawn_item()
		if(spawned_item)
			spawned_item.pixel_x = pixel_x
			spawned_item.pixel_y = pixel_y
			if(has_postspawn)
				post_spawn(spawned_item)

#ifdef UNIT_TESTS
	if(is_area_consistent && is_map_template_consistent)
		crash_with("[DEBUG_REF(src)] cant have more than one is_consistent toggles on")
#endif

	return INITIALIZE_HINT_QDEL

/// Any post-spawn actions for the item
/obj/random/proc/post_spawn(obj/thing)
#ifdef UNIT_TESTS
	crash_with("[DEBUG_REF(src)] registered itself as having post_spawn, but did not override post_spawn()")
#endif

/// Creates the random item
/obj/random/proc/spawn_item()
	if(length(spawnlist))
		var/itemtype

		if(is_area_consistent)
			itemtype = pick_area_consistent(spawnlist, get_area(src), src.type)
		else if(is_map_template_consistent)
			var/datum/map_template/template = GLOB.map_templates["[z]"]
			itemtype = pick_maptemplate_consistent(spawnlist, template, src.type)
		else
			itemtype = pickweight(spawnlist)

		if(ispath(itemtype))
			. = new itemtype(loc)

	if(!.)
		LOG_DEBUG("random_obj: [DEBUG_REF(src)] returned null item!")

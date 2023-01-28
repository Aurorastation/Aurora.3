/var/singleton/overmap_trigger_handler/overmap_trigger_handler = new()

/singleton/overmap_trigger_handler/proc/create_triggers(var/z_level, var/overmap_size)
	// Acquire the list of not-yet utilized overmap turfs on this Z-level
	var/list/candidate_turfs = block(locate(OVERMAP_EDGE, OVERMAP_EDGE, z_level), locate(overmap_size - OVERMAP_EDGE, overmap_size - OVERMAP_EDGE, z_level))
	candidate_turfs = where(candidate_turfs, /proc/can_not_locate, /obj/effect/overmap)

	for(var/trigger_type in subtypesof(/obj/effect/overmap/trigger))
		if(!length(candidate_turfs))
			break
		var/obj/effect/overmap/trigger/trigger = trigger_type
		for(var/i = 1 to initial(trigger.spawn_amount))
			if(!prob(initial(trigger.spawn_chance)))
				continue
			var/turf/spawn_turf = pick_n_take(candidate_turfs)
			trigger = new trigger_type(spawn_turf)
			trigger.handle_spawn(candidate_turfs)
			if(!length(candidate_turfs))
				break

/obj/effect/overmap/trigger
	name = "trigger"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "trigger"
	opacity = FALSE
	var/spawn_amount = 1
	var/spawn_chance = 0

/obj/effect/overmap/trigger/proc/handle_spawn(var/list/candidate_turfs)
	return

/obj/effect/overmap/trigger/Crossed(obj/effect/overmap/visitable/other)
	if(istype(other, /obj/effect/overmap/visitable/ship))
		handle_crossed(other)
		return
	return ..()

/obj/effect/overmap/trigger/proc/handle_crossed(var/obj/effect/overmap/visitable/ship/ship)
	return

/obj/effect/overmap/trigger/wormhole
	name = "wormhole"
	icon_state = "wormhole"
	spawn_amount = 3
	spawn_chance = 5
	var/datum/weakref/paired_wormhole

/obj/effect/overmap/trigger/wormhole/handle_spawn(var/list/candidate_turfs)
	if(!length(candidate_turfs))
		qdel(src)
		return
	var/turf/spawn_turf = pick_n_take(candidate_turfs)
	var/obj/effect/overmap/trigger/wormhole/sibling_wormhole = new /obj/effect/overmap/trigger/wormhole(spawn_turf)
	paired_wormhole = WEAKREF(sibling_wormhole)
	sibling_wormhole.paired_wormhole = WEAKREF(src)

/obj/effect/overmap/trigger/wormhole/handle_crossed(var/obj/effect/overmap/visitable/ship/ship)
	var/obj/effect/overmap/trigger/wormhole/sibling_wormhole = paired_wormhole.resolve()
	ship.position = list(0, 0)
	ship.forceMove(get_turf(sibling_wormhole))
	ship.update_icon()

	for(var/mob/living/carbon/human/human in human_mob_list)
		if(human.z in ship.map_z)
			to_chat(human, SPAN_DANGER("<font size=4>Your legs buckle as the ground shakes beneath you!</font>"))
			shake_camera(human, 10, 5)
	priority_announcement.Announce("Alert. Wormhole jump detected. All crew, report to the medical bay if you are experiencing nausea or headaches.", "Jump Detection System", zlevels = ship.map_z)

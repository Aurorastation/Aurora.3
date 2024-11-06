/datum/universal_state/bluespace_jump
	name = "Bluespace Jump"
	var/list/bluespaced = list()
	var/list/affected_levels
	var/list/old_accessible_z_levels

/datum/universal_state/bluespace_jump/New(var/list/zlevels)
	affected_levels = zlevels

/datum/universal_state/bluespace_jump/OnEnter()
	var/space_zlevel = SSatlas.current_map.get_empty_zlevel() //get a place for stragglers
	for(var/mob/living/M in GLOB.mob_list)
		if(M.z in affected_levels)
			var/area/A = get_area(M)
			if(istype(A,/area/space)) //straggler
				var/turf/T = locate(M.x, M.y, space_zlevel)
				if(T)
					M.forceMove(T)
			else
				apply_bluespaced(M)
	old_accessible_z_levels = SSatlas.current_map.accessible_z_levels.Copy()
	for(var/z in affected_levels)
		SSatlas.current_map.accessible_z_levels -= "[z]" //not accessible during the jump

/datum/universal_state/bluespace_jump/OnExit()
	for(var/mob/M in bluespaced)
		if(!QDELETED(M))
			clear_bluespaced(M)

	bluespaced.Cut()
	SSatlas.current_map.accessible_z_levels = old_accessible_z_levels
	old_accessible_z_levels = null

/datum/universal_state/bluespace_jump/OnPlayerLatejoin(var/mob/living/M)
	if(M.z in affected_levels)
		apply_bluespaced(M)

/datum/universal_state/bluespace_jump/OnTouchMapEdge(var/atom/A)
	if((A.z in affected_levels) && (A in bluespaced))
		if(ismob(A))
			to_chat(A,SPAN_WARNING("You drift away into the shifting expanse, never to be seen again."))
		qdel(A) //lost in bluespace
		return FALSE
	return TRUE

/datum/universal_state/bluespace_jump/proc/apply_bluespaced(var/mob/living/M)
	bluespaced += M
	if(M.client)
		to_chat(M,SPAN_NOTICE("You feel oddly light, and somewhat disoriented as everything around you shimmers and warps ever so slightly."))
		M.overlay_fullscreen("bluespace", /atom/movable/screen/fullscreen/bluespace_overlay)
	M.confused = 20

/datum/universal_state/bluespace_jump/proc/clear_bluespaced(var/mob/living/M)
	if(M.client)
		to_chat(M,SPAN_NOTICE("You feel rooted in the material world again."))
		M.clear_fullscreen("bluespace")
	M.confused = 0

/obj/effect/bluegoast
	name = "bluespace echo"
	desc = "It's not going to punch you, is it?"
	var/mob/living/carbon/human/daddy
	anchored = TRUE
	var/reality = 0
	simulated = FALSE

/obj/effect/bluegoast/New(nloc, ndaddy)
	..(nloc)
	if(!ndaddy)
		qdel(src)
		return
	daddy = ndaddy
	set_dir(daddy.dir)
	appearance = daddy.appearance
	RegisterSignal(daddy, COMSIG_MOVABLE_MOVED, PROC_REF(mirror))
	GLOB.dir_set_event.register(daddy, src, PROC_REF(mirror_dir))
	RegisterSignal(daddy, COMSIG_QDELETING, TYPE_PROC_REF(/datum, qdel_self))

/obj/effect/bluegoast/Destroy()
	if(daddy)
		UnregisterSignal(daddy, COMSIG_QDELETING)
		GLOB.dir_set_event.unregister(daddy, src)
		UnregisterSignal(daddy, COMSIG_MOVABLE_MOVED)
		daddy = null
	. = ..()

// /obj/effect/bluegoast/proc/mirror(var/atom/movable/am, var/old_loc, var/new_loc)
/obj/effect/bluegoast/proc/mirror(atom/movable/listener, atom/old_loc, dir, forced, list/old_locs)
	appearance = daddy.appearance
	var/nloc = get_step(src, dir)
	if(nloc)
		forceMove(nloc)
	if(nloc == daddy.loc)
		reality++
		if(reality > 5)
			to_chat(daddy, SPAN_NOTICE("Yep, it's certainly the other one. Your existance was a glitch, and it's finally being mended..."))
			blueswitch()
		else if(reality > 3)
			to_chat(daddy, SPAN_DANGER("Something is definitely wrong. Why do you think YOU are the original?"))
		else
			to_chat(daddy, SPAN_WARNING("You feel a bit less real. Which one of you two was original again?.."))

/obj/effect/bluegoast/proc/mirror_dir(var/atom/movable/am, var/old_dir, var/new_dir)
	set_dir(REVERSE_DIR(new_dir))

/obj/effect/bluegoast/examine(mob/user, distance, is_adjacent, infix, suffix, show_extended)
	SHOULD_CALL_PARENT(FALSE)

	return daddy?.examine(arglist(args))

/obj/effect/bluegoast/proc/blueswitch()
	var/mob/living/carbon/human/H
	if(ishuman(daddy))
		H = new(get_turf(src), daddy.species.name)
		H.dna = daddy.dna.Clone()
		H.sync_organ_dna()
		H.UpdateAppearance()
		for(var/obj/item/entry in daddy.get_equipped_items(INCLUDE_POCKETS|INCLUDE_HELD))
			daddy.remove_from_mob(entry) //steals instead of copies so we don't end up with duplicates
			H.equip_to_appropriate_slot(entry)
	else
		H = new daddy.type(get_turf(src))
		H.appearance = daddy.appearance

	H.real_name = daddy.real_name
	H.flavor_text = daddy.flavor_text
	daddy.dust()
	qdel(src)

/atom/movable/screen/fullscreen/bluespace_overlay
	icon = 'icons/effects/effects.dmi'
	icon_state = "mfoam"
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	alpha = 80
	color = "#000050"
	blend_mode = BLEND_ADD


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Large finds - (Potentially) active alien machinery from the dawn of time

/datum/artifact_find
	var/artifact_id
	var/artifact_find_type
	var/artifact_detect_range

/datum/artifact_find/New()
	artifact_detect_range = rand(5,300)

	artifact_id = "[pick("kappa","sigma","antaeres","beta","omicron","iota","epsilon","omega","gamma","delta","tau","alpha")]-[rand(100,999)]"

	artifact_find_type = pick(
		5;/obj/machinery/power/supermatter,
		5;/obj/structure/constructshell,
		25;/obj/machinery/power/supermatter/shard,
		50;/obj/structure/cult/pylon,
		100;/obj/machinery/auto_cloner,
		100;/obj/machinery/giga_drill,
		100;/obj/machinery/replicator,
		150;/obj/structure/crystal_madness,
		150;/obj/structure/crystal,
		1000;/obj/machinery/artifact,
	)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Boulders - sometimes turn up after excavating turf - excavate further to try and find large xenoarch finds

/obj/structure/boulder
	name = "boulder"
	desc = "Leftover rock from an excavation, it's been partially dug out already but there's still a lot to go."
	icon = 'icons/obj/mining.dmi'
	icon_state = "boulder1"
	density = 1
	opacity = 1
	anchored = 1
	material = MATERIAL_SANDSTONE
	var/excavation_level = 0
	var/datum/geosample/geologic_data
	var/datum/artifact_find/artifact_find
	var/last_act = 0

/obj/structure/boulder/Initialize(mapload, var/coloration = "#9c9378")
	. = ..()
	icon_state = "boulder[rand(1,6)]"
	if(coloration)
		color = coloration
	excavation_level = rand(5,50)

/obj/structure/boulder/attackby(obj/item/attacking_item, mob/user)
	if (istype(attacking_item, /obj/item/device/core_sampler))
		src.geologic_data.artifact_distance = rand(-100,100) / 100
		src.geologic_data.artifact_id = artifact_find.artifact_id

		var/obj/item/device/core_sampler/C = attacking_item
		C.sample_item(src, user)
		return

	if (istype(attacking_item, /obj/item/device/depth_scanner))
		var/obj/item/device/depth_scanner/C = attacking_item
		C.scan_atom(user, src)
		return

	if (istype(attacking_item, /obj/item/device/measuring_tape))
		var/obj/item/device/measuring_tape/P = attacking_item
		user.visible_message(SPAN_NOTICE("[user] extends [P] towards [src]."),
								SPAN_NOTICE("You extend [P] towards [src]."))

		if(do_after(user,40))
			to_chat(user, SPAN_NOTICE("[icon2html(P, user)] [src] has been excavated to a depth of [2*src.excavation_level]cm."))
		return

	if (istype(attacking_item, /obj/item/pickaxe))
		var/obj/item/pickaxe/P = attacking_item

		if(last_act + P.digspeed > world.time)//prevents message spam
			return
		last_act = world.time

		to_chat(user, SPAN_WARNING("You start [P.drill_verb] [src]."))



		if(!do_after(user,P.digspeed))
			return

		to_chat(user, SPAN_NOTICE("You finish [P.drill_verb] [src]."))
		excavation_level += P.excavation_amount

		if(excavation_level > 100)
			//failure
			user.visible_message(SPAN_WARNING("<b>[src] suddenly crumbles away.</b>"),\
			SPAN_WARNING("[src] has disintegrated under your onslaught, any secrets it was holding are long gone."))
			qdel(src)
			return

		if(prob(excavation_level))
			//success
			if(artifact_find)
				var/spawn_type = artifact_find.artifact_find_type
				var/obj/O = new spawn_type(get_turf(src))
				if(istype(O,/obj/machinery/artifact))
					var/obj/machinery/artifact/X = O
					if(X.my_effect)
						X.my_effect.artifact_id = artifact_find.artifact_id
				src.visible_message(SPAN_WARNING("<b>[src] suddenly crumbles away.</b>"))
			else
				user.visible_message(SPAN_WARNING("<b>[src] suddenly crumbles away.</b>"),\
				SPAN_NOTICE("[src] has been whittled away under your careful excavation, but there was nothing of interest inside."))
			qdel(src)

/obj/structure/boulder/CollidedWith(AM)
	. = ..()
	if(istype(AM,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = AM
		if((istype(H.l_hand,/obj/item/pickaxe)) && (!H.hand))
			var/obj/item/pickaxe/P = H.l_hand
			if(P.autodrill)
				attackby(H.l_hand,H)
		else if((istype(H.r_hand,/obj/item/pickaxe)) && H.hand)
			var/obj/item/pickaxe/P = H.r_hand
			if(P.autodrill)
				attackby(H.r_hand,H)

	else if(istype(AM,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = AM
		if(istype(R.module_active,/obj/item/pickaxe))
			attackby(R.module_active,R)

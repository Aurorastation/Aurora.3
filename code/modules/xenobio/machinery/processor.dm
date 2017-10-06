// This is specifically for slimes since we don't have a 'normal' processor now.
// Feel free to rename it if that ever changes.

/obj/machinery/processor
	name = "slime processor"
	desc = "An industrial grinder used to automate the process of slime core extraction.  It can also recycle biomatter."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "processor1"
	density = TRUE
	anchored = TRUE
	var/processing = FALSE // So I heard you like processing.
	var/list/to_be_processed = list()
	var/monkeys_recycled = 0
	description_info = "Clickdrag dead slimes or monkeys to it to insert them.  It will make a new monkey cube for every four monkeys it processes."

/obj/item/weapon/circuitboard/processor
	name = T_BOARD("slime processor")
	build_path = /obj/machinery/processor
	origin_tech = list(TECH_DATA = 2, TECH_BIO = 2)

/obj/machinery/processor/attack_hand(mob/living/user)
	if(processing)
		to_chat(user, "<span class='warning'>The processor is in the process of processing!</span>")
		return
	if(to_be_processed.len)
		spawn(1)
			begin_processing()
	else
		to_chat(user, "<span class='warning'>The processor is empty.</span>")
		playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 1)
		return

// Verb to remove everything.
/obj/machinery/processor/verb/eject()
	set category = "Object"
	set name = "Eject Processor"
	set src in oview(1)

	if(usr.stat || !usr.canmove || usr.restrained())
		return
	empty()
	add_fingerprint(usr)
	return

// Ejects all the things out of the machine.
/obj/machinery/processor/proc/empty()
	for(var/atom/movable/AM in to_be_processed)
		to_be_processed.Remove(AM)
		AM.forceMove(get_turf(src))

// Ejects all the things out of the machine.
/obj/machinery/processor/proc/insert(var/atom/movable/AM, var/mob/living/user)
	if(!Adjacent(AM))
		return
	if(!can_insert(AM))
		to_chat(user, "<span class='warning'>\The [src] cannot process \the [AM] at this time.</span>")
		playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 1)
		return
	to_be_processed.Add(AM)
	AM.forceMove(src)
	visible_message("<span class='notice'>\the [user] places [AM] inside \the [src].</span>")

/obj/machinery/processor/proc/begin_processing()
	if(processing)
		return // Already doing it.
	processing = TRUE
	playsound(src.loc, 'sound/machines/juicer.ogg', 50, 1)
	for(var/atom/movable/AM in to_be_processed)
		extract(AM)
		sleep(1 SECONDS)

	while(monkeys_recycled >= 4)
		new /obj/item/weapon/reagent_containers/food/snacks/monkeycube(get_turf(src))
		playsound(src.loc, 'sound/effects/splat.ogg', 50, 1)
		monkeys_recycled -= 4
		sleep(1 SECOND)

	processing = FALSE
	playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)

/obj/machinery/processor/proc/extract(var/atom/movable/AM)
	if(istype(AM, /mob/living/simple_animal/slime))
		var/mob/living/simple_animal/slime/S = AM
		while(S.cores)
			new S.coretype(get_turf(src))
			playsound(src.loc, 'sound/effects/splat.ogg', 50, 1)
			S.cores--
			sleep(1 SECOND)
		to_be_processed.Remove(S)
		qdel(S)

	if(istype(AM, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = AM
		playsound(src.loc, 'sound/effects/splat.ogg', 50, 1)
		to_be_processed.Remove(M)
		qdel(M)
		monkeys_recycled++
		sleep(1 SECOND)

/obj/machinery/processor/proc/can_insert(var/atom/movable/AM)
	if(istype(AM, /mob/living/simple_animal/slime))
		var/mob/living/simple_animal/slime/S = AM
		if(S.stat != DEAD)
			return FALSE
		return TRUE
	if(istype(AM, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = AM
		if(!istype(H.species, /datum/species/monkey))
			return FALSE
		if(H.stat != DEAD)
			return FALSE
		return TRUE
	return FALSE

/obj/machinery/processor/MouseDrop_T(var/atom/movable/AM, var/mob/living/user)
	if(user.stat || user.incapacitated(INCAPACITATION_DISABLED) || !istype(user))
		return
	insert(AM, user)
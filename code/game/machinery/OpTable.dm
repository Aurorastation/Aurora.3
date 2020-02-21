/obj/machinery/optable
	name = "operating table"
	desc = "Used for advanced medical procedures."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "table2-idle"
	var/modify_state = "table2"
	density = TRUE
	anchored = TRUE
	use_power = TRUE
	idle_power_usage = 1
	active_power_usage = 5
	component_types = list(
			/obj/item/circuitboard/optable,
			/obj/item/stock_parts/scanning_module = 1
		)

	var/mob/living/carbon/human/victim = null
	var/suppressing = FALSE

	var/obj/machinery/computer/operating/computer = null

/obj/machinery/optable/Initialize()
	. = ..()
	for(dir in cardinal)
		computer = locate(/obj/machinery/computer/operating, get_step(src, dir))
		if(computer)
			computer.table = src
			break

/obj/machinery/optable/examine(var/mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("The neural suppressors are switched [suppressing ? "on" : "off"]."))

/obj/machinery/optable/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				qdel(src)
				return
		if(3.0)
			if(prob(25))
				density = FALSE
	return

/obj/machinery/optable/attack_hand(mob/user)
	if(HULK in user.mutations)
		visible_message(SPAN_DANGER("\The [user] destroys \the [src]!"))
		density = FALSE
		qdel(src)
		return

	if(!victim)
		to_chat(user, SPAN_WARNING("There is nobody on \the [src]. It would be pointless to turn the suppressor on."))
		return TRUE

	if(user != victim && !use_check_and_message(user)) // Skip checks if you're doing it to yourself or turning it off, this is an anti-griefing mechanic more than anything.
		user.visible_message(SPAN_WARNING("\The [user] begins switching [suppressing ? "off" : "on"] \the [src]'s neural suppressor."))
		if(!do_after(user, 30, src))
			return
		if(!victim)
			to_chat(user, SPAN_WARNING("There is nobody on \the [src]. It would be pointless to turn the suppressor on."))

		suppressing = !suppressing
		user.visible_message(SPAN_NOTICE("\The [user] switches [suppressing ? "on" : "off"] \the [src]'s neural suppressor."))
		playsound(loc, "switchsounds", 50, 1)

/obj/machinery/optable/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(air_group || (height == 0)) 
		return FALSE

	return istype(mover) && mover.checkpass(PASSTABLE)

/obj/machinery/optable/MouseDrop_T(obj/O, mob/user)
	if(istype(O, /obj/item))
		user.drop_from_inventory(O,get_turf(src))

/obj/machinery/optable/proc/check_victim()
	if(!victim || !victim.lying || victim.loc != loc)
		suppressing = FALSE
		victim = null
		var/mob/living/carbon/human/H = locate() in loc
		if(istype(H))
			if(H.lying)
				icon_state = H.pulse() ? "[modify_state]-active" : "[modify_state]-idle"
				victim = H
	if(victim && !victim.isSynthetic())
		if(suppressing && victim.sleeping < 3)
			victim.Sleeping(3 - victim.sleeping)
			victim.willfully_sleeping = FALSE
		return TRUE
	icon_state = "[modify_state]-idle"
	return FALSE

/obj/machinery/optable/machinery_process()
	check_victim()

/obj/machinery/optable/proc/take_victim(mob/living/carbon/C, mob/living/carbon/user)
	if(C == user)
		user.visible_message("\The [user] climbs on \the [src].","You climb on \the [src].")
	else
		visible_message(SPAN_NOTICE("\The [C] has been laid on \the [src] by \the [user]."))
	if(C.client)
		C.client.perspective = EYE_PERSPECTIVE
		C.client.eye = src
	C.resting = TRUE
	C.forceMove(loc)
	add_fingerprint(user)
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		victim = H
		icon_state = H.pulse() ? "[modify_state]-active" : "[modify_state]-idle"
	else
		icon_state = "[modify_state]-idle"

/obj/machinery/optable/MouseDrop_T(mob/target, mob/user)
	var/mob/living/M = user
	if(user.stat || user.restrained() || !iscarbon(target))
		return
	if(istype(M))
		var/mob/living/L = target
		var/bucklestatus = L.bucklecheck(user)

		if(!bucklestatus)//We must make sure the person is unbuckled before they go in
			return

		if(L == user)
			user.visible_message(SPAN_NOTICE("\The [user] starts climbing onto \the [src]."), SPAN_NOTICE("You start climbing onto \the [src]."), range = 3)
		else
			user.visible_message(SPAN_NOTICE("\The [user] starts putting [L] onto \the [src]."), SPAN_NOTICE("You start putting \the [L] onto \the [src]."), range = 3)
		if(do_mob(user, L, 10, needhand = FALSE))
			if(bucklestatus == 2)
				var/obj/structure/LB = L.buckled
				LB.user_unbuckle_mob(user)
			take_victim(target,user)
	else
		return ..()

/obj/machinery/optable/verb/climb_on()
	set name = "Climb On Table"
	set category = "Object"
	set src in oview(1)

	if(usr.stat || !ishuman(usr) || usr.restrained() )
		return

	take_victim(usr,usr)

/obj/machinery/optable/attackby(obj/item/W, mob/living/carbon/user)
	if(istype(W, /obj/item/grab))
		var/obj/item/grab/G = W
		if(victim)
			to_chat(usr, SPAN_NOTICE(SPAN_BOLD("\The [src] is already occupied!")))
			return FALSE

		var/mob/living/L = G.affecting
		var/bucklestatus = L.bucklecheck(user)

		if(!bucklestatus)//We must make sure the person is unbuckled before they go in
			return

		if(L == user)
			user.visible_message(SPAN_NOTICE("\The [user] starts climbing onto \the [src]."), SPAN_NOTICE("You start climbing onto \the [src]."), range = 3)
		else
			user.visible_message(SPAN_NOTICE("\The [user] starts putting \the [L] onto \the [src]."), SPAN_NOTICE("You start putting \the [L] onto \the [src]."), range = 3)
		if(do_mob(user, L, 10, needhand = FALSE))
			if(bucklestatus == 2)
				var/obj/structure/LB = L.buckled
				LB.user_unbuckle_mob(user)
			take_victim(G.affecting,usr)
			qdel(W)
			return
	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(default_part_replacement(user, W))
		return

/obj/machinery/optable/proc/check_table(mob/living/carbon/patient)
	check_victim()
	if(victim?.lying && get_turf(victim) == get_turf(src))
		to_chat(usr, SPAN_WARNING("\The [src] is already occupied!"))
		return FALSE
	if(patient.buckled)
		to_chat(usr, SPAN_NOTICE("Unbuckle \the [patient] first!"))
		return FALSE
	return TRUE

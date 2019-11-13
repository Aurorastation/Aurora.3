/obj/machinery/optable
	name = "operating table"
	desc = "Used for advanced medical procedures."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "table2-idle"
	var/modify_state = "table2"
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 1
	active_power_usage = 5
	component_types = list(
			/obj/item/circuitboard/optable,
			/obj/item/stock_parts/scanning_module = 1
		)
	
	var/mob/living/carbon/human/victim = null
	var/strapped = 0.0
	var/suppressing = FALSE

	var/obj/machinery/computer/operating/computer = null

/obj/machinery/optable/Initialize()
	. = ..()
	for(dir in list(NORTH,EAST,SOUTH,WEST))
		computer = locate(/obj/machinery/computer/operating, get_step(src, dir))
		if (computer)
			computer.table = src
			break

/obj/machinery/optable/examine(var/mob/user)
	. = ..()
	to_chat(user, "<span class='notice'>The neural suppressors are switched [suppressing ? "on" : "off"].</span>")

/obj/machinery/optable/ex_act(severity)

	switch(severity)
		if(1.0)
			//SN src = null
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				//SN src = null
				qdel(src)
				return
		if(3.0)
			if (prob(25))
				src.density = 0
		else
	return

/obj/machinery/optable/attack_hand(mob/user as mob)
	if (HULK in usr.mutations)
		visible_message("<span class='danger'>\The [usr] destroys \the [src]!</span>")
		src.density = 0
		qdel(src)
		return

	if(!victim)
		to_chat(user, "<span class='warning'>There is nobody on \the [src]. It would be pointless to turn the suppressor on.</span>")
		return TRUE

	if(user != victim && !use_check_and_message(user)) // Skip checks if you're doing it to yourself or turning it off, this is an anti-griefing mechanic more than anything.
		user.visible_message("<span class='warning'>\The [user] begins switching [suppressing ? "off" : "on"] \the [src]'s neural suppressor.</span>")
		if(!do_after(user, 30, src))
			return 
		if(!victim)
			to_chat(user, "<span class='warning'>There is nobody on \the [src]. It would be pointless to turn the suppressor on.</span>")

		suppressing = !suppressing
		user.visible_message("<span class='notice'>\The [user] switches [suppressing ? "on" : "off"] \the [src]'s neural suppressor.</span>")

/obj/machinery/optable/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1

	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	else
		return 0


/obj/machinery/optable/MouseDrop_T(obj/O as obj, mob/user as mob)

	if (!istype(O, /obj/item))
		return
	user.drop_from_inventory(O,get_turf(src))
	return

/obj/machinery/optable/proc/check_victim()
	if(!victim || !victim.lying || victim.loc != loc)
		suppressing = FALSE
		victim = null
		var/mob/living/carbon/human/H = locate() in loc
		if(istype(H))
			if(H.lying)
				icon_state = H.pulse ? "[modify_state]-active" : "[modify_state]-idle"
				victim = H
	if(victim)
		if(suppressing && victim.sleeping < 3)
			victim.Sleeping(3 - victim.sleeping)
		return 1
	icon_state = "[modify_state]-idle"
	return 0

/obj/machinery/optable/machinery_process()
	check_victim()

/obj/machinery/optable/proc/take_victim(mob/living/carbon/C, mob/living/carbon/user as mob)
	if (C == user)
		user.visible_message("[user] climbs on \the [src].","You climb on \the [src].")
	else
		visible_message("<span class='notice'>\The [C] has been laid on \the [src] by [user].</span>")
	if (C.client)
		C.client.perspective = EYE_PERSPECTIVE
		C.client.eye = src
	C.resting = 1
	C.forceMove(src.loc)
	src.add_fingerprint(user)
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		src.victim = H
		icon_state = H.pulse ? "[modify_state]-active" : "[modify_state]-idle"
	else
		icon_state = "[modify_state]-idle"

/obj/machinery/optable/MouseDrop_T(mob/target, mob/user)

	var/mob/living/M = user
	if(user.stat || user.restrained() ||  !iscarbon(target))
		return
	if(istype(M))

		var/mob/living/L = target
		var/bucklestatus = L.bucklecheck(user)

		if (!bucklestatus)//We must make sure the person is unbuckled before they go in
			return


		if(L == user)
			user.visible_message("<span class='notice'>[user] starts climbing onto [src].</span>", "<span class='notice'>You start climbing onto [src].</span>", range = 3)
		else
			user.visible_message("<span class='notice'>[user] starts putting [L] onto [src].</span>", "<span class='notice'>You start putting [L] onto [src].</span>", range = 3)
		if (do_mob(user, L, 10, needhand = 0))
			if (bucklestatus == 2)
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

/obj/machinery/optable/attackby(obj/item/W as obj, mob/living/carbon/user as mob)
	if (istype(W, /obj/item/grab))
		var/obj/item/grab/G = W
		if (src.victim)
			to_chat(usr, "<span class='notice'><B>The table is already occupied!</B></span>")
			return 0

		var/mob/living/L = G.affecting
		var/bucklestatus = L.bucklecheck(user)

		if (!bucklestatus)//We must make sure the person is unbuckled before they go in
			return


		if(L == user)
			user.visible_message("<span class='notice'>[user] starts climbing onto [src].</span>", "<span class='notice'>You start climbing onto [src].</span>", range = 3)
		else
			user.visible_message("<span class='notice'>[user] starts putting [L] onto [src].</span>", "<span class='notice'>You start putting [L] onto [src].</span>", range = 3)
		if (do_mob(user, L, 10, needhand = 0))
			if (bucklestatus == 2)
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

/obj/machinery/optable/proc/check_table(mob/living/carbon/patient as mob)
	check_victim()
	if(src.victim && get_turf(victim) == get_turf(src) && victim.lying)
		to_chat(usr, "<span class='warning'>\The [src] is already occupied!</span>")
		return 0
	if(patient.buckled)
		to_chat(usr, "<span class='notice'>Unbuckle \the [patient] first!</span>")
		return 0
	return 1

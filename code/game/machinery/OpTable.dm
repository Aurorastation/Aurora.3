/obj/machinery/optable
	name = "Operating Table"
	desc = "Used for advanced medical procedures."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "table2-idle"
	density = 1
	anchored = 1.0
	use_power = 1
	idle_power_usage = 1
	active_power_usage = 5
	var/mob/living/carbon/human/victim = null
	var/strapped = 0.0

	var/obj/machinery/computer/operating/computer = null

/obj/machinery/optable/Initialize()
	. = ..()
	for(dir in list(NORTH,EAST,SOUTH,WEST))
		computer = locate(/obj/machinery/computer/operating, get_step(src, dir))
		if (computer)
			computer.table = src
			break

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

/obj/machinery/optable/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1

	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	else
		return 0


/obj/machinery/optable/MouseDrop_T(obj/O as obj, mob/user as mob)

	if (!istype(O, /obj/item/weapon))
		return
	user.drop_from_inventory(O,get_turf(src))
	return

/obj/machinery/optable/proc/check_victim()
	if(locate(/mob/living/carbon/human, src.loc))
		var/mob/living/carbon/human/M = locate(/mob/living/carbon/human, src.loc)
		if(M.lying)
			src.victim = M
			icon_state = M.pulse ? "table2-active" : "table2-idle"
			return 1
	src.victim = null
	icon_state = "table2-idle"
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
	for(var/obj/O in src)
		O.forceMove(src.loc)
	src.add_fingerprint(user)
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		src.victim = H
		icon_state = H.pulse ? "table2-active" : "table2-idle"
	else
		icon_state = "table2-idle"

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

/obj/machinery/optable/attackby(obj/item/weapon/W as obj, mob/living/carbon/user as mob)
	if (istype(W, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = W
		if (src.victim)
			usr << "<span class='notice'><B>The table is already occupied!</B></span>"
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

/obj/machinery/optable/proc/check_table(mob/living/carbon/patient as mob)
	check_victim()
	if(src.victim && get_turf(victim) == get_turf(src) && victim.lying)
		usr << "<span class='warning'>\The [src] is already occupied!</span>"
		return 0
	if(patient.buckled)
		usr << "<span class='notice'>Unbuckle \the [patient] first!</span>"
		return 0
	return 1

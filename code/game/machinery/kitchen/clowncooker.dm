/obj/machinery/piemaker
	name = "Honkington Pie Maker"
	icon = 'icons/obj/kitchen.dmi'
	desc = "A colorful red stove used for cooking pies"
	icon_state = "bahnan"
	layer = 2.9
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 19980
	flags = OPENCONTAINER | NOREACT
	var/operating = 0 // Is it on?
	var/mob/living/occupant // Who is inside the pie maker!!
	var/obj/item/weapon/reagent_containers/food/snacks/pie/pie
	var/biomass = 0


/obj/machinery/piemaker/attack_hand(mob/user as mob)
	if(stat & (NOPOWER|BROKEN))
		return
	if(operating)
		to_chat(user, "<span class='danger'>\The [src] is in use, please wait!.</span>")
		return
	if(biomass <= 10)
		visible_message("<span class='danger'>The pie maker does not have enough biomass.</span>")
		return
	else
		src.cookintopie(user)


/obj/machinery/piemaker/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = W
		if(G.state < GRAB_AGGRESSIVE)
			to_chat(user, "<span class='danger'>You need a better grip to do that!</span>")
			return
		stuffinto(user,G.affecting)
		user.drop_from_inventory(G)
		biomass += 20
	if(istype(W, /obj/item/weapon/reagent_containers/food/snacks))
		var/obj/item/weapon/reagent_containers/food/snacks/I = W
		user.remove_from_mob(I)
		I.forceMove(src)
		to_chat(user, "<span class='danger'>You insert [W]</span>")
		for(I in contents)
			if(I.reagents.get_reagent_amount("nutriment") < 0.1)
				biomass += 4
			else biomass += I.reagents.get_reagent_amount("nutriment") * 2
		qdel(I)

/obj/machinery/piemaker/proc/stuffinto(var/mob/user,var/mob/living/victim)

	if(src.occupant)
		to_chat(user, "<span class='danger'>\The [src] is full, empty it first!</span>")
		return
	if(src.pie)
		to_chat(user, "<span class='danger'>\The [src] is full, empty it first!</span>")
		return

	if(operating)
		to_chat(user, "<span class='danger'>\The [src] is locked and running, wait for it to finish.</span>")
		return

	if(victim.abiotic(1))
		to_chat(user, "<span class='danger'>\The [victim] may not have abiotic items on.</span>")
		return

	user.visible_message("<span class='danger'>\The [user] starts to put \the [victim] into \the [src]!</span>")
	src.add_fingerprint(user)
	if(do_after(user, 10 SECONDS, act_target = src) && victim.Adjacent(src) && user.Adjacent(src) && victim.Adjacent(user) && !occupant)
		user.visible_message("<span class='danger'>[user] stuffs [victim] into the [src]</span>")
		if(victim.client)
			victim.client.perspective = EYE_PERSPECTIVE
			victim.client.eye = src
		victim.forceMove(src)
		src.occupant = victim
		update_icon()

/obj/machinery/piemaker/verb/eject()
	set category = "Object"
	set name = "Empty Pie Maker"
	set src in oview(1)

	if (usr.stat != 0)
		return
	src.get_out()
	for(var/obj/O in src.pie)
		O.forceMove(src.loc)
	add_fingerprint(usr)
	return

/obj/machinery/piemaker/proc/get_out()
	if(operating || !src.occupant)
		return
	for(var/obj/O in src)
		O.forceMove(src.loc)
	if (src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	src.occupant.forceMove(src.loc)
	src.occupant = null
	update_icon()
	return

/obj/machinery/piemaker/proc/cookintopie(mob/user as mob)
	use_power(9000)
	src.operating = 1
	update_icon()
	playsound(src.loc, 'sound/items/bikehorn.ogg', 50, 1)
	sleep(10)
	playsound(src.loc, 'sound/music/clownmusic.ogg', 50, 1)
	icon_state = "bahnan-processing"
	addtimer(CALLBACK(src, .proc/pieconversion), 40 SECONDS)
	update_icon()



/obj/machinery/piemaker/proc/pieconversion()

	var/obj/item/weapon/reagent_containers/food/snacks/pie/P = new(src.loc)
	P.reagents.add_reagent("bananacream", 20)
	biomass -= 10
	if(occupant)
		if(occupant.mind)
			var/obj/item/organ/brain/B = new(src.loc)
			var/mob/living/carbon/brain/BM = new(src.loc)
			B.forceMove(P)
			BM.forceMove(B)
			P.brainobj = B
			P.brainmob = BM
			BM.dna = occupant.dna
			occupant.mind.transfer_to(BM)
			to_chat(BM, "<span class='warning'>You have been turned into a pie!.</span>")
		var/mob/living/carbon/C = occupant
		if (C.can_feel_pain())
			C.emote("scream")
		qdel(occupant)
		occupant = null
	src.operating = 0
	icon_state = "bahnan"
	playsound(src.loc, 'sound/machines/microwave/microwave-end.ogg', 50, 1)



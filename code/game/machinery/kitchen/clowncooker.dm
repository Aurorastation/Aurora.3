/obj/machinery/piemaker
	name = "Honkington Pie Maker"
	icon = 'icons/obj/kitchen.dmi'
	desc = "A machine built on the clown planet that uses bluespace to convert there atoms into pies"
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
	var/obj/item/weapon/reagent_containers/food/snacks/creampie/pie
	var/biomass = 0


/obj/machinery/piemaker/attack_hand(mob/user as mob)
	if(stat & (NOPOWER|BROKEN))
		return
	if(operating)
		to_chat(user, "<span class='danger'>\The [src] is in use, please wait!.</span>")
		return
	if(pie && !operating)
		to_chat(user, "<span class='Notice'>\The [src] ejects its brand new pie, yum!.</span>")
		pie.forceMove(src)
		pie = null
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
	if(src.operating)
		return
	if(!src.occupant)
		visible_message("<span class='danger'>You hear a loud metallic grinding sound.</span>")
		return
	use_power(9000)
	src.operating = 1
	update_icon()

	src.occupant.attack_log += "\[[time_stamp()]\] Was made into a pie by <b>[user]/[user.ckey]</b>" //One shall not simply gib a mob unnoticed!
	user.attack_log += "\[[time_stamp()]\] turned <b>[src.occupant]/[src.occupant.ckey] into a pie!</b>"
	msg_admin_attack("[key_name_admin(user)] made  [src.occupant] ([src.occupant.ckey]) into a pie! (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(src.occupant))

	playsound(src.loc, 'sound/items/bikehorn.ogg', 50, 1)
	sleep(100)
	playsound(src.loc, 'sound/music/clownmusic.ogg', 50, 1)
	icon_state = "bahnan-processing"
	addtimer(CALLBACK(src, .proc/pieconversion), 40 SECONDS)
	update_icon()


/obj/machinery/piemaker/proc/pieconversion()

	if(!occupant)
		visible_message("<span class='danger'>The oven is empty! nothing!.</span>")
		return
	else
		var/obj/item/weapon/reagent_containers/food/snacks/creampie/P = new(src.loc)
		var/obj/item/organ/brain/B = new(src.loc)
		var/mob/living/carbon/brain/BM = new(src.loc)
		B.forceMove(P)
		BM.forceMove(B)
		P.brainobj = B
		P.brainmob = BM
		BM.dna = occupant.dna
		if(occupant.mind)
			occupant.mind.transfer_to(BM)
		to_chat(BM, "<span class='warning'>You have been turned into a pie!.</span>")
		src.occupant.gib()
		occupant = null
		src.operating = 0
		icon_state = "bahnan"
		playsound(src.loc, 'sound/machines/microwave/microwave-end.ogg', 50, 1)



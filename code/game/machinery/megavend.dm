
/obj/machinery/megavendor
	name = "\improper NanoTrasen Auto-Locker"
	desc = "This amazing machine is used to deploy the official equipment for your current employment."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "clothes_scanner_0"
	var/base_icon_state = "clothes_scanner_0"
	var/occupied_icon_state = "clothes_scanner_1"
	layer = 2.9
	anchored = 1
	density = 1
	use_power = 0
	var/isvending = 0
	var/selectedrank
	var/last_reply = 0
	var/last_slogan = 0 //When did we last pitch?
	var/slogan_delay = 6000 //How long until we can pitch again?

	// Stuff relating vocalizations
	var/list/slogan_list = list("Don't deploy just yet! Grab your gear!","Forgetting something?","Don't hop on in your skivvies, mate!","It's not Casual Friday, y'know?","Heaven's above, put some clothes on!")
	var/shut_up = 0 //Stop spouting those godawful pitches!
	var/allow_occupant_types = list(/mob/living/carbon/human)
	var/mob/occupant = null
	var/on_enter_occupant_message = "The Auto-Locker's doors clang shut loudly, encasing you in darkness."

/obj/machinery/vending/New()
	..()
	spawn(4)
		if(src.product_slogans)
			src.slogan_list += text2list(src.product_slogans, ";")

			// So not all machines speak at the exact same time.
			// The first time this machine says something will be at slogantime + this random value,
			// so if slogantime is 10 minutes, it will say it at somewhere between 10 and 20 minutes after the machine is crated.
			src.last_slogan = world.time + rand(0, slogan_delay)

/obj/machinery/megavendor/proc/check_occupant_allowed(mob/M)
	var/correct_type = 0
	for(var/type in allow_occupant_types)
		if(istype(M, type))
			correct_type = 1
			break

	if(!correct_type) return 0

	return 1

/obj/machinery/megavendor/attackby(var/obj/item/weapon/G as obj, var/mob/user as mob)

	if(istype(G, /obj/item/weapon/grab))

		if(occupant)
			user << "<span class='notice'>\The [src] is in use.</span>"
			return

		if(!ismob(G:affecting))
			return

		if(!check_occupant_allowed(G:affecting))
			return

		var/mob/M = G:affecting

		visible_message("[user] starts putting [G:affecting:name] into \the [name].", 3)

		if(do_after(user, 20))
			if(!M || !G || !G:affecting) return

			M.forceMove(src)

			if(M.client)
				M.client.perspective = EYE_PERSPECTIVE
				M.client.eye = src

		icon_state = occupied_icon_state

		M << "<span class='notice'>[on_enter_occupant_message]</span>"
		set_occupant(M)

		src.add_fingerprint(M)

/obj/machinery/megavendor/MouseDrop_T(atom/movable/O as mob|obj, mob/living/user as mob)
	if(!istype(user))
		return
	if(!check_occupant_allowed(O))
		return
	if(occupant)
		user << "<span class='notice'>\The [src] is in use.</span>"
		return
	var/mob/living/L = O

	if(L == user)
		visible_message("[user] starts climbing into \the [name].", 3)
	else
		visible_message("[user] starts putting [L] into \the [name].", 3)

	if(do_after(user, 20))
		if(!L) return

		L.loc = src

		if(L.client)
			L.client.perspective = EYE_PERSPECTIVE
			L.client.eye = src
	else
		user << "<span class='notice'>You stop [L == user ? "climbing into" : "putting [L] into"] \the [name].</span>"
		return

	icon_state = occupied_icon_state

	L << "<span class='notice'>[on_enter_occupant_message]</span>"
	occupant = L

	src.add_fingerprint(L)

	return

/obj/machinery/megavendor/verb/eject()
	set name = "Eject Auto-Locker"
	set category = "Object"
	set src in oview(1)
	if(usr.stat != 0)
		return

	if(isvending)
		return

	src.go_out()
	add_fingerprint(usr)
	return

/obj/machinery/megavendor/verb/move_inside()
	set name = "Enter Auto-Locker"
	set category = "Object"
	set src in oview(1)

	if(usr.stat != 0 || !check_occupant_allowed(usr))
		return

	if(src.occupant)
		usr << "<span class='notice'><B>\The [src] is in use.</B></span>"
		return

	visible_message("[usr] starts climbing into \the [src].", 3)

	if(do_after(usr, 20))

		if(!usr || !usr.client)
			return

		if(src.occupant)
			usr << "<span class='notice'><B>\The [src] is in use.</B></span>"
			return

		usr.stop_pulling()
		usr.client.perspective = EYE_PERSPECTIVE
		usr.client.eye = src
		usr.forceMove(src)
		set_occupant(usr)

		icon_state = occupied_icon_state

		usr << "<span class='notice'>[on_enter_occupant_message]</span>"

		src.add_fingerprint(usr)

	return

/obj/machinery/megavendor/proc/set_occupant(var/occupant)
	src.occupant = occupant
	name = initial(name)
	if(occupant)
		name = "[name] ([occupant])"

/obj/machinery/megavendor/proc/go_out()

	if(!occupant)
		return

	ping("<span class='notice'>The [src] disgorges its contents with a ping.</span>")
	icon_state = base_icon_state

	//Eject any items that aren't meant to be in the pod.
	var/list/items = src.contents
	if(occupant) items -= occupant

	for(var/obj/item/W in items)
		W.forceMove(get_turf(src))

	if(occupant.client)
		occupant.client.eye = src.occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE

	occupant.forceMove(get_turf(src))
	set_occupant(null)

	name = initial(name)
	icon_state = base_icon_state
	isvending = 0
	return

/obj/machinery/megavendor/process()
	if(((src.last_slogan + src.slogan_delay) <= world.time) && (src.slogan_list.len > 0) && (!src.shut_up) && prob(5))
		var/slogan = pick(src.slogan_list)
		src.ping(slogan)
		src.last_slogan = world.time
	if(occupant && !isvending)
		isvending = 1
		megavend(occupant)

/obj/machinery/megavendor/proc/megavend(var/mob/living/carbon/human/H)
	if(H.megavend)
		src.speak("Scan error: Subject has already used a NT Auto-Locker within the past twelve hours!")
		src.go_out()
		return
	src.speak("Analyzing...")
	sleep(40)
	src.speak("Record match. Name: [H.real_name]. Current occupation: [H.job].")
	src.visible_message("<span class='notice'>The [src] rumbles to life, and begins to whir loudly.</span>")
	playsound(src.loc, 'sound/items/poster_being_created.ogg', 50, 1)

	var/obj/item/weapon/storage/box/gearbox = new(src)
	gearbox.name = "\improper Personal possessions box"
	gearbox.desc = "All of the personal effects of [H.real_name], packaged neatly by the Auto-Locker."
	var/list/items = H.contents
	for(var/obj/item/W in items)
		if(istype(W,/obj/item/organ))
			items -= W
			continue
		H.drop_from_inventory(W,gearbox)
		items -= W
		gearbox.contents += W
		if(items.len == 0)
			break

	sleep(20)
	job_master.EquipRank(H, H.job, 1, 1)
	sleep(20)
	src.speak("Welcome aboard, [H.real_name]. Have a nice shift.")
	H.megavend = 1
	src.go_out()
	return

/obj/machinery/megavendor/proc/speak(var/message)
	if (!message)
		return

	ping("<span class='game say'><span class='name'>\The [src]</span> beeps, \"[message]\"</span>")
	if(occupant)
		occupant << "<span class='game say'><span class='name'>\The [src]</span> beeps, \"[message]\"</span>"
	return
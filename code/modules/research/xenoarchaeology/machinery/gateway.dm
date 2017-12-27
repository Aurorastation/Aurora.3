/obj/machinery/xenogateway
	name = "xenoarch xenogateway"
	desc = "A mysterious xenogateway built by unknown hands. This one allows for travel to exotic places."
	icon = 'icons/obj/machines/gateway.dmi'
	icon_state = "off"
	density = 1
	anchored = 1
	var/active = 0


/obj/machinery/xenogateway/Initialize()
	. = ..()
	update_icon()
	if(dir == 2)
		density = 0


/obj/machinery/xenogateway/update_icon()
	if(active)
		icon_state = "on"
		return
	icon_state = "off"



//this is da important part wot makes things go
/obj/machinery/xenogateway/centerstation
	density = 1
	icon_state = "offcenter"
	use_power = 1

	//warping vars
	var/list/linked = list()
	var/ready = 0				//have we got all the parts for a xenogateway?
	var/wait = 0				//this just grabs world.time at world start
	var/obj/machinery/xenogateway/centeraway/awaygate = null

/obj/machinery/xenogateway/centerstation/Initialize()
	. = ..()
	update_icon()
	wait = world.time + config.gateway_delay	//+ thirty minutes default
	awaygate = locate(/obj/machinery/xenogateway/centeraway)


/obj/machinery/xenogateway/centerstation/update_icon()
	if(active)
		icon_state = "oncenter"
		return
	icon_state = "offcenter"



obj/machinery/xenogateway/centerstation/process()
	if(stat & (NOPOWER))
		if(active) toggleoff()
		return

	if(active)
		use_power(5000)


/obj/machinery/xenogateway/centerstation/proc/detect()
	linked = list()	//clear the list
	var/turf/T = loc

	for(var/i in alldirs)
		T = get_step(loc, i)
		var/obj/machinery/xenogateway/G = locate(/obj/machinery/xenogateway) in T
		if(G)
			linked.Add(G)
			continue

		//this is only done if we fail to find a part
		ready = 0
		toggleoff()
		break

	if(linked.len == 8)
		ready = 1


/obj/machinery/xenogateway/centerstation/proc/toggleon(mob/user as mob)
	if(!ready)			return
	if(linked.len != 8)	return
	if(!powered())		return
	if(!awaygate)
		user << "<span class='notice'>Error: No destination found.</span>"
		return
	if(world.time < wait)
		user << "<span class='notice'>Error: Warpspace triangulation in progress. Estimated time to completion: [round(((wait - world.time) / 10) / 60)] minutes.</span>"
		return

	for(var/obj/machinery/xenogateway/G in linked)
		G.active = 1
		G.update_icon()
	active = 1
	update_icon()


/obj/machinery/xenogateway/centerstation/proc/toggleoff()
	for(var/obj/machinery/xenogateway/G in linked)
		G.active = 0
		G.update_icon()
	active = 0
	update_icon()


/obj/machinery/xenogateway/centerstation/attack_hand(mob/user as mob)
	if(!ready)
		detect()
		return
	if(!active)
		toggleon(user)
		return
	toggleoff()


//okay, here's the good teleporting stuff
/obj/machinery/xenogateway/centerstation/Bumped(atom/movable/M as mob|obj)
	if(!ready)		return
	if(!active)		return
	if(!awaygate)	return
	if(awaygate.calibrated)
		M.loc = get_step(awaygate.loc, SOUTH)
		M.set_dir(SOUTH)
		return
	else
		var/obj/effect/landmark/dest = pick(awaydestinations)
		if(dest)
			M.loc = dest.loc
			M.set_dir(SOUTH)
			use_power(5000)
		return


/obj/machinery/xenogateway/centerstation/attackby(obj/item/device/W as obj, mob/user as mob)
	if(ismultitool(W))
		user << "\black The gate is already calibrated, there is no work for you to do here."
		return

/////////////////////////////////////Away////////////////////////


/obj/machinery/xenogateway/centeraway
	density = 1
	icon_state = "offcenter"
	use_power = 0
	var/calibrated = 1
	var/list/linked = list()	//a list of the connected xenogateway chunks
	var/ready = 0
	var/obj/machinery/xenogateway/centeraway/stationgate = null


/obj/machinery/xenogateway/centeraway/Initialize()
	. = ..()
	update_icon()
	stationgate = locate(/obj/machinery/xenogateway/centerstation)


/obj/machinery/xenogateway/centeraway/update_icon()
	if(active)
		icon_state = "oncenter"
		return
	icon_state = "offcenter"


/obj/machinery/xenogateway/centeraway/proc/detect()
	linked = list()	//clear the list
	var/turf/T = loc

	for(var/i in alldirs)
		T = get_step(loc, i)
		var/obj/machinery/xenogateway/G = locate(/obj/machinery/xenogateway) in T
		if(G)
			linked.Add(G)
			continue

		//this is only done if we fail to find a part
		ready = 0
		toggleoff()
		break

	if(linked.len == 8)
		ready = 1


/obj/machinery/xenogateway/centeraway/proc/toggleon(mob/user as mob)
	if(!ready)			return
	if(linked.len != 8)	return
	if(!stationgate)
		user << "<span class='notice'>Error: No destination found.</span>"
		return

	for(var/obj/machinery/xenogateway/G in linked)
		G.active = 1
		G.update_icon()
	active = 1
	update_icon()


/obj/machinery/xenogateway/centeraway/proc/toggleoff()
	for(var/obj/machinery/xenogateway/G in linked)
		G.active = 0
		G.update_icon()
	active = 0
	update_icon()


/obj/machinery/xenogateway/centeraway/attack_hand(mob/user as mob)
	if(!ready)
		detect()
		return
	if(!active)
		toggleon(user)
		return
	toggleoff()


/obj/machinery/xenogateway/centeraway/Bumped(atom/movable/M as mob|obj)
	if(!ready)	return
	if(!active)	return
	if(istype(M, /mob/living/carbon))
		for(var/obj/item/weapon/implant/exile/E in M)//Checking that there is an exile implant in the contents
			if(E.imp_in == M)//Checking that it's actually implanted vs just in their pocket
				M << "\black The station gate has detected your exile implant and is blocking your entry."
				return
	M.loc = get_step(stationgate.loc, SOUTH)
	M.set_dir(SOUTH)


/obj/machinery/xenogateway/centeraway/attackby(obj/item/device/W as obj, mob/user as mob)
	if(ismultitool(W))
		if(calibrated)
			user << "\black The gate is already calibrated, there is no work for you to do here."
			return
		else
			user << "<span class='notice'><b>Recalibration successful!</b>: \black This gate's systems have been fine tuned.  Travel to this gate will now be on target.</span>"
			calibrated = 1
			return

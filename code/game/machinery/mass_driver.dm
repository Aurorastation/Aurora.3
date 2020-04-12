//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/mass_driver
	name = "mass driver"
	desc = "Shoots things into space."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "mass_driver"
	anchored = 1.0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 50
	obj_flags = OBJ_FLAG_ROTATABLE

	var/power = 1.0
	var/code = 1.0
	var/id = 1.0
	var/drive_range = 50 //this is mostly irrelevant since current mass drivers throw into space, but you could make a lower-range mass driver for interstation transport or something I guess.
	var/_wifi_id
	var/datum/wifi/receiver/button/mass_driver/wifi_receiver

/obj/machinery/mass_driver/Initialize()
	. = ..()
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)

/obj/machinery/mass_driver/Destroy()
	qdel(wifi_receiver)
	wifi_receiver = null
	return ..()

/obj/machinery/mass_driver/proc/drive(amount)
	if(stat & (BROKEN|NOPOWER))
		return
	use_power(500)
	var/O_limit
	var/atom/target = get_edge_target_turf(src, dir)
	for(var/atom/movable/O in loc)
		if(!O.anchored)
			O_limit++
			if(O_limit >= 20)
				for(var/mob/M in hearers(src, null))
					to_chat(M, "<span class='notice'>The mass driver lets out a screech, it mustn't be able to handle any more items.</span>")
				break
			use_power(500)
			spawn( 0 )
				O.throw_at(target, drive_range * power, power)
	flick("mass_driver1", src)
	return

/obj/machinery/mass_driver/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		return
	drive()
	..(severity)

/obj/machinery/mass_driver/attackby(obj/item/W, mob/user)

	if(W.iswrench())
		if(!anchored)
			playsound(src.loc, W.usesound, 75, 1)
			user.visible_message("[user.name] secures [src] to the floor.", \
				"You secure the external reinforcing bolts to the floor.", \
				"You hear a ratchet")
			src.anchored = 1
		else
			playsound(src.loc, W.usesound, 75, 1)
			user.visible_message("[user.name] unsecures [src] from the floor.", \
				"You unsecure the external reinforcing bolts from the floor.", \
				"You hear a ratchet")
			src.anchored = 0

/obj/item/mass_driver_diy
	name = "Mass Driver Kit"
	desc = "A do-it-yourself kit for constructing the finest of mass drivers."
	icon = 'icons/obj/storage.dmi'
	icon_state = "inf_box"
	item_state = "box"

/obj/item/mass_driver_diy/attack_self(mob/user)
	to_chat(user, "<span class='notice'>You start piecing together the kit...</span>")
	if(do_after(user, 80))
		var/master_id = "[user.name] - [pick("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z")][rand(100,999)]"
		var/obj/machinery/mass_driver/mining/R = new /obj/machinery/mass_driver/mining(user.loc)
		R.id = master_id
		R.power = 2.0
		var/obj/item/mass_driver_button/B = new /obj/item/mass_driver_button(user.loc)
		B.id = master_id
		user.visible_message("<span class='notice'>[user] assembles \a [R].\
			</span>", "<span class='notice'>You assemble \a [R].</span>")
		R.add_fingerprint(user)
		qdel(src)

/obj/item/mass_driver_button
	name = "mass driver button"
	desc = "An unscrewed mass driver button."
	icon = 'icons/obj/objects.dmi'
	icon_state = "launcherbtt"
	var/id

/obj/item/mass_driver_button/afterattack(var/atom/A, var/mob/user, var/adjacent, var/clickparams)
	if (!adjacent)
		return

	//must place on a wall and user must not be inside a closet/mecha/whatever
	var/turf/W = A
	if (!iswall(W) || !isturf(user.loc))
		to_chat(user, "<span class='warning'>You can't place this here!</span>")
		return

	var/placement_dir = get_dir(user, W)
	if (!(placement_dir in cardinal))
		to_chat(user, "<span class='warning'>You must stand directly in front of the wall you wish to place that on.</span>")
		return

	//just check if there is a poster on or adjacent to the wall
	var/stuff_on_wall = 0
	if (locate(/obj/machinery/button) in W)
		stuff_on_wall = 1

	//crude, but will cover most cases. We could do stuff like check pixel_x/y but it's not really worth it.
	for (var/dir in cardinal)
		var/turf/T = get_step(W, dir)
		if (locate(/obj/machinery/button) in T)
			stuff_on_wall = 1
			break

	if (stuff_on_wall)
		to_chat(user, "<span class='notice'>There is already a button there!</span>")
		return

	to_chat(user, "<span class='notice'>You place down the button.</span>")
	var/obj/machinery/button/mass_driver/B = new /obj/machinery/button/remote/driver(user.loc)

	switch (placement_dir)
		if (NORTH)
			B.pixel_x = 0
			B.pixel_y = 32
		if (SOUTH)
			B.pixel_x = 0
			B.pixel_y = -32
		if (EAST)
			B.pixel_x = 32
			B.pixel_y = 0
		if (WEST)
			B.pixel_x = -32
			B.pixel_y = 0

	B.id = id
	B.use_power = 0
	B.add_fingerprint(user)
	qdel(src)

/obj/machinery/mass_driver/mining
	name = "mining mass driver"
	desc = "Shoots things really hard really fast."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "mass_driver"
	anchored = 0
	use_power = 0
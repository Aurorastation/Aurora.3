/obj/item/weapon/gun/energy/laser_pointer
	name = "laser pointer"
	desc = "Don't shine it in your eyes!"
	icon = 'icons/obj/device.dmi'
	icon_state = "pointer"
	item_state = "pen"
	var/pointer_icon_state
	slot_flags = SLOT_BELT
	w_class = 2 //Increased to 2, because diodes are w_class 2. Conservation of matter.
	origin_tech = "combat=1"
	origin_tech = "magnets=2"
	var/turf/pointer_loc
	var/energy = 15
	var/max_energy = 15
	self_recharge = 1
	recharge_time = 5
	var/obj/item/weapon/stock_parts/micro_laser/diode //used for upgrading!


/obj/item/weapon/gun/energy/laser_pointer/red
	pointer_icon_state = "red_laser"
/obj/item/weapon/gun/energy/laser_pointer/green
	pointer_icon_state = "green_laser"
/obj/item/weapon/gun/energy/laser_pointer/blue
	pointer_icon_state = "blue_laser"
/obj/item/weapon/gun/energy/laser_pointer/purple
	pointer_icon_state = "purple_laser"

/obj/item/weapon/gun/energy/laser_pointer/New()
	..()
	diode = new(src)
	if(!pointer_icon_state)
		pointer_icon_state = pick("red_laser","green_laser","blue_laser","purple_laser")

/obj/item/weapon/gun/energy/laser_pointer/upgraded/New()
	..()
	diode = new /obj/item/weapon/stock_parts/micro_laser/ultra



/obj/item/weapon/gun/energy/laser_pointer/attack(mob/living/M, mob/user)
	laser_act(M, user)

/obj/item/weapon/gun/energy/laser_pointer/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/weapon/stock_parts/micro_laser))
		if(!diode)
			user.drop_item()
			W.loc = src
			diode = W
			user << "<span class='notice'>You install a [diode.name] in [src].</span>"
		else
			user << "<span class='notice'>[src] already has a cell.</span>"

	else if(istype(W, /obj/item/weapon/screwdriver))
		if(diode)
			user << "<span class='notice'>You remove the [diode.name] from the [src].</span>"
			diode.loc = get_turf(src.loc)
			diode = null
			return
		..()
	return

/obj/item/weapon/gun/energy/laser_pointer/afterattack(var/atom/target, var/mob/living/user, flag, params)
	if(flag)	//we're placing the object on a table or in backpack
		return
	laser_act(target, user)

/obj/item/weapon/gun/energy/laser_pointer/proc/laser_act(var/atom/target, var/mob/living/user)
	if( !(user in (viewers(7,target))) )
		return
	if (!diode)
		user << "<span class='notice'>You point [src] at [target], but nothing happens!</span>"
		return
	if (!user.IsAdvancedToolUser())
		user << "<span class='warning'>You don't have the dexterity to do this!</span>"
		return

	add_fingerprint(user)


	var/outmsg
	var/turf/targloc = get_turf(target)

	if(istype(target, /obj/machinery/camera))
		var/obj/machinery/camera/C = target
		C.emp_act(1)
		outmsg = "<span class='notice'>You hit the lens of [C] with [src], temporarily disabling the camera!</span>"

		msg_admin_attack("\[[time_stamp()]\] [user.name] ([user.ckey]) EMPd a camera with a laser pointer")
		user.attack_log += text("\[[time_stamp()]\] [user.name] ([user.ckey]) EMPd a camera with a laser pointer")

	if(iscarbon(target))
		if(user.zone_sel.selecting == "eyes")
			var/mob/living/carbon/C = target

			C.eye_blind = 1
			outmsg = "<span class='notice'>You hit the eyes of [C] with [src], temporarily blinding them!</span>"

	if(istype(target, /obj/item/weapon/paper))
		var/obj/item/weapon/paper/C = target
		new /obj/effect/decal/cleanable/ash(C.loc)
		qdel(C)
		outmsg = "<span class='notice'>You burn [C] with [src], turning it to ash!</span>"

		msg_admin_attack("\[[time_stamp()]\] [user.name] ([user.ckey]) burned a paper with a laser pointer")
		user.attack_log += text("\[[time_stamp()]\] [user.name] ([user.ckey]) burned a paper with a laser pointer")
	
	//laser pointer image
	icon_state = "pointer_[pointer_icon_state]"
	var/list/showto = list()
	for(var/mob/M in range(7,targloc))
		if(M.client)
			showto.Add(M.client)
	var/image/I = image('icons/obj/projectiles.dmi',targloc,pointer_icon_state,10)
	I.pixel_x = target.pixel_x + rand(-5,5)
	I.pixel_y = target.pixel_y + rand(-5,5)

	if(outmsg)
		user << outmsg
	else
		user << "<span class='info'>You point [src] at [target].</span>"

	energy -= 1

	flick_overlay(I, showto, 10)
	icon_state = "pointer"
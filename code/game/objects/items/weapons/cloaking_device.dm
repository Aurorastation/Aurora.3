/obj/item/weapon/cloaking_device
	name = "cloaking device"
	desc = "Use this to become invisible to the human eye."
	icon = 'icons/obj/device.dmi'
	icon_state = "shield0"
	var/active = 0.0
	flags = CONDUCT
	item_state = "electronic"
	throwforce = 10.0
	throw_speed = 2
	throw_range = 10
	w_class = 2.0
	origin_tech = list(TECH_MAGNET = 3, TECH_ILLEGAL = 4)

	var/power_usage = 35000//A high powered cell allows 5 minutes of continuous usage
	//Note it can be toggled on and off easily. You can make it last an hour if you only use it when
	//people are nearby to see. Carry spare/better cells for extended cloaking.
	var/obj/item/weapon/cell/cell = null
	var/mob/living/owner = null
	var/datum/modifier/cloaking_device/modifier = null

/obj/item/weapon/cloaking_device/New()
	..()
	cloaking_devices += src
	cell = new /obj/item/weapon/cell/high(src)

/obj/item/weapon/cloaking_device/Destroy()
	..()
	cloaking_devices -= src


/obj/item/weapon/cloaking_device/equipped(var/mob/user, var/slot)
	..()
	//Picked up or switched hands or worn
	register_owner(user)


//Handles dropped or thrown cloakers
/obj/item/weapon/cloaking_device/dropped(var/mob/user)
	..()
	spawn(1)//Things are dropped on the floor briefly when being put into containers or swapping hands
	//Its dumb. This little hack works around it
		var/mob/M = get_holding_mob()
		if(!M)
			register_owner(M)
		//Either placed somewhere or given to someone.
		//M will be null if we were dropped on the floor, thats fine, the register function will handle it
		//If M contains someone other than the owner, then this device was just passed to someone

	//If M contains the owner then the item hasn't actually been dropped, its just the quirk mentioned above

/obj/item/weapon/cloaking_device/attack_self(mob/user as mob)
	if (istype(loc, /mob) && loc == user)//safety check incase of shenanigans
		register_owner(user)
		if (active)
			deactivate()
		else
			activate()
		src.add_fingerprint(user)
		return

/obj/item/weapon/cloaking_device/proc/activate()
	if (active)
		return

	if (!cell || !cell.checked_use(power_usage*5*CELLRATE))//Costs a small burst to enter cloak
		if (owner)
			owner << "The [src] clicks uselessly, it has no power left."
		return

	processing_objects.Add(src)
	active = 1
	src.icon_state = "shield1"
	stop_modifier()
	playsound(src, 'sound/effects/phasein.ogg', 10, 1, -2)//Cloaking is quieter than uncloaking
	if (owner)
		owner << "<span class='notice'>\The [src] is now active.</span>"
		start_modifier()

/obj/item/weapon/cloaking_device/proc/deactivate()
	if (!active)
		return
	active = 0
	src.icon_state = "shield0"
	if (owner)
		owner << "<span class='notice'>\The [src] is now inactive.</span>"

	playsound(src, 'sound/effects/phasein.ogg', 50, 1)
	stop_modifier()
	processing_objects.Remove(src)

/obj/item/weapon/cloaking_device/emp_act(severity)
	deactivate()
	..()


/obj/item/weapon/cloaking_device/proc/register_owner(var/mob/user)
	if (!owner || owner != user)
		stop_modifier()
		owner = user
		if (active)
			start_modifier()


/obj/item/weapon/cloaking_device/proc/start_modifier()
	if (owner)
		modifier = owner.add_modifier(/datum/modifier/cloaking_device, MODIFIER_ITEM, src, override = MODIFIER_OVERRIDE_NEIGHBOR)

/obj/item/weapon/cloaking_device/proc/stop_modifier()
	if (modifier)
		modifier.stop(1)
		modifier = null


/obj/item/weapon/cloaking_device/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/cell))
		if(!cell)
			user.drop_item()
			W.forceMove(src)
			cell = W
			user << "<span class='notice'>You install a cell in [src].</span>"
			update_icon()
		else
			user << "<span class='notice'>[src] already has a cell.</span>"

	else if(istype(W, /obj/item/weapon/screwdriver))
		if(cell)
			cell.update_icon()
			cell.forceMove(get_turf(src.loc))
			cell = null
			user << "<span class='notice'>You remove the cell from the [src].</span>"
			deactivate()
			return
	..()


/obj/item/weapon/cloaking_device/examine(mob/user)
	..()
	if (!cell)
		user << "It needs a power cell to function."
	else
		user << "It has [cell.percent()]% power remaining"

/obj/item/weapon/cloaking_device/process()
	if (!cell || !cell.checked_use(power_usage*CELLRATE))
		deactivate()
		return


/*
	Modifier
*/
/datum/modifier/cloaking_device/activate()
	..()
	var/mob/living/L = target
	L.cloaked = 1
	L.mouse_opacity = 0
	L.update_icons()


/datum/modifier/cloaking_device/deactivate()
	..()
	for (var/a in cloaking_devices)//Check for any other cloaks
		if (a != source)
			var/obj/item/weapon/cloaking_device/CD = a
			if (CD.get_holding_mob() == target)
				if (CD.active)//If target is holding another active cloak then we wont remove their stealth
					return
	var/mob/living/L = target
	L.cloaked = 0
	L.mouse_opacity = 1
	L.update_icons()


/datum/modifier/cloaking_device/check_validity()
	.=..()
	if (. == 1)
		var/obj/item/weapon/cloaking_device/C = source
		if (!C.active)
			return validity_fail("Cloak is inactive!")
/obj/item/cloaking_device
	name = "cloaking device"
	desc = "Use this to become invisible to the human eye. Contains a removable power cell behind a screwed compartment"
	description_info = "The default power cell will last for five minutes of continuous usage. It can be removed and recharged or replaced with a better one using a screwdriver.\
	</br>This will not make you inaudible, your footsteps can still be heard, and it will make a very distinctive sound when uncloaking.\
	</br>Any items you're holding in your hands can still be seen."
	description_antag  = "Being cloaked makes you impossible to click on, which offers a major advantage in combat. People can only hit you by blind-firing in your direction."

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
	var/obj/item/cell/cell = null
	var/mob/living/owner = null
	var/datum/modifier/cloaking_device/modifier = null

/obj/item/cloaking_device/New()
	..()
	cloaking_devices += src
	cell = new /obj/item/cell/high(src)

/obj/item/cloaking_device/Destroy()
	. = ..()
	cloaking_devices -= src


/obj/item/cloaking_device/equipped(var/mob/user, var/slot)
	..()
	//Picked up or switched hands or worn
	register_owner(user)


//Handles dropped or thrown cloakers
/obj/item/cloaking_device/dropped(var/mob/user)
	..()
	var/mob/M = get_holding_mob()
	if(!M)
		register_owner(null)
		//Either placed somewhere or given to someone.
		//M will be null if we were dropped on the floor, thats fine, the register function will handle it
		//If M contains someone other than the owner, then this device was just passed to someone

	//If M contains the owner then the item hasn't actually been dropped, its just the quirk mentioned above

/obj/item/cloaking_device/attack_self(mob/user as mob)
	if (istype(loc, /mob) && loc == user)//safety check incase of shenanigans
		register_owner(user)
		if (active)
			deactivate()
		else
			activate()
		src.add_fingerprint(user)
		return

/obj/item/cloaking_device/proc/activate()
	if (active)
		return

	if (!cell || !cell.checked_use(power_usage*5*CELLRATE))//Costs a small burst to enter cloak
		if (owner)
			to_chat(owner, "The [src] clicks uselessly, it has no power left.")
		playsound(get_turf(src), 'sound/weapons/empty.ogg', 25, 1)
		return

	START_PROCESSING(SSprocessing, src)
	active = 1
	src.icon_state = "shield1"
	stop_modifier()
	playsound(src, 'sound/effects/phasein.ogg', 10, 1, -2)//Cloaking is quieter than uncloaking
	if (owner)
		to_chat(owner, "<span class='notice'>\The [src] is now active.</span>")
		start_modifier()

/obj/item/cloaking_device/proc/deactivate()
	if (!active)
		return
	active = 0
	src.icon_state = "shield0"
	if (owner)
		to_chat(owner, "<span class='notice'>\The [src] is now inactive.</span>")

	playsound(src, 'sound/effects/phasein.ogg', 50, 1)
	stop_modifier()
	STOP_PROCESSING(SSprocessing, src)

/obj/item/cloaking_device/emp_act(severity)
	deactivate()
	if (cell)
		cell.emp_act(severity)
	..()


/obj/item/cloaking_device/proc/register_owner(var/mob/user)
	if (!owner || owner != user)
		stop_modifier()
		owner = user

	if (!modifier)
		start_modifier()


/obj/item/cloaking_device/proc/start_modifier()
	if (!owner)
		owner = get_holding_mob()

	if (owner)
		modifier = owner.add_modifier(/datum/modifier/cloaking_device, MODIFIER_ITEM, src, override = MODIFIER_OVERRIDE_NEIGHBOR, _check_interval = 30)

/obj/item/cloaking_device/proc/stop_modifier()
	if (modifier)
		modifier.stop(1)
		modifier = null


/obj/item/cloaking_device/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/cell))
		if(!cell)
			user.drop_from_inventory(W,src)
			cell = W
			to_chat(user, "<span class='notice'>You install a cell in [src].</span>")
			update_icon()
		else
			to_chat(user, "<span class='notice'>[src] already has a cell.</span>")

	else if(W.isscrewdriver())
		if(cell)
			cell.update_icon()
			cell.forceMove(get_turf(src.loc))
			cell = null
			to_chat(user, "<span class='notice'>You remove the cell from the [src].</span>")
			deactivate()
			return
	..()


/obj/item/cloaking_device/examine(mob/user)
	..()
	if (!cell)
		to_chat(user, "It needs a power cell to function.")
	else
		to_chat(user, "It has [cell.percent()]% power remaining")

/obj/item/cloaking_device/process()
	if (!cell || !cell.checked_use(power_usage*CELLRATE))
		deactivate()
		return
	else if (!modifier)
		owner = null
		start_modifier()

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
			var/obj/item/cloaking_device/CD = a
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
		var/obj/item/cloaking_device/C = source
		if (!C.active)
			return validity_fail("Cloak is inactive!")

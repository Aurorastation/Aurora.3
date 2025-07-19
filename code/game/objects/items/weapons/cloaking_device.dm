/obj/item/cloaking_device
	name = "cloaking device"
	desc = "Use this to become invisible to the human eye. Contains a removable power cell behind a screwed compartment"
	icon = 'icons/obj/item/device/chameleon.dmi'
	icon_state = "shield0"
	item_state = "electronic"
	contained_sprite = TRUE
	var/active = 0.0
	obj_flags = OBJ_FLAG_CONDUCTABLE
	item_state = "electronic"
	throwforce = 10.0
	throw_speed = 2
	throw_range = 10
	w_class = WEIGHT_CLASS_SMALL
	origin_tech = list(TECH_MAGNET = 3, TECH_ILLEGAL = 4)

	var/power_usage = 35000//A high powered cell allows 5 minutes of continuous usage
	//Note it can be toggled on and off easily. You can make it last an hour if you only use it when
	//people are nearby to see. Carry spare/better cells for extended cloaking.
	var/obj/item/cell/cell = null
	var/mob/living/owner = null
	var/datum/modifier/cloaking_device/modifier = null

/obj/item/cloaking_device/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "The default power cell will last for five minutes of continuous usage. It can be removed and recharged or replaced with a better one using a screwdriver."
	. += "This will not make you inaudible; your footsteps can still be heard, and it will make a very distinctive sound when uncloaking."
	. += "Any items you're holding in your hands can still be seen."

/obj/item/cloaking_device/antagonist_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Being cloaked makes you impossible to click on, which offers a major advantage in combat."
	. += "People can only hit you by blind-firing in your direction."

/obj/item/cloaking_device/feedback_hints(mob/user, distance, is_adjacent)
	. = list()
	. = ..()
	if (!cell)
		. += SPAN_WARNING("It needs a power cell to function.")
	else
		. += SPAN_NOTICE("It has [cell.percent()]% power remaining.")

/obj/item/cloaking_device/New()
	..()
	GLOB.cloaking_devices += src
	cell = new /obj/item/cell/high(src)

/obj/item/cloaking_device/Destroy()
	. = ..()
	GLOB.cloaking_devices -= src

/obj/item/cloaking_device/equipped(var/mob/user, var/slot)
	..()
	//Picked up or switched hands or worn
	register_owner(user)

//Handles dropped or thrown cloakers
/obj/item/cloaking_device/dropped(mob/user)
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
		playsound(get_turf(src), 'sound/weapons/click.ogg', 25, 1)
		return

	START_PROCESSING(SSprocessing, src)
	active = 1
	src.icon_state = "shield1"
	stop_modifier()
	playsound(src, 'sound/effects/phasein.ogg', 10, 1, -2)//Cloaking is quieter than uncloaking
	if (owner)
		to_chat(owner, SPAN_NOTICE("\The [src] is now active."))
		start_modifier()

/obj/item/cloaking_device/proc/deactivate()
	if (!active)
		return
	active = 0
	src.icon_state = "shield0"
	if (owner)
		to_chat(owner, SPAN_NOTICE("\The [src] is now inactive."))

	playsound(src, 'sound/effects/phasein.ogg', 50, 1)
	stop_modifier()
	STOP_PROCESSING(SSprocessing, src)

/obj/item/cloaking_device/emp_act(severity)
	. = ..()

	deactivate()
	if (cell)
		cell.emp_act(severity)

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

/obj/item/cloaking_device/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/cell))
		if(!cell)
			user.drop_from_inventory(attacking_item, src)
			cell = attacking_item
			to_chat(user, SPAN_NOTICE("You install a cell in [src]."))
			update_icon()
		else
			to_chat(user, SPAN_NOTICE("[src] already has a cell."))

	else if(attacking_item.isscrewdriver())
		if(cell)
			cell.update_icon()
			cell.forceMove(get_turf(src.loc))
			cell = null
			to_chat(user, SPAN_NOTICE("You remove the cell from the [src]."))
			deactivate()
			return
	..()

/obj/item/cloaking_device/process()
	if (!cell || !cell.checked_use(power_usage*CELLRATE))
		deactivate()
		return
	else if (!modifier)
		owner = null
		start_modifier()

/mob/proc/disable_cloaking_device()
	for(var/datum/modifier/cloaking_device/mod in modifiers)
		if(istype(mod))
			var/obj/item/cloaking_device/CD = locate(/obj/item/cloaking_device, src)
			if(CD)
				CD.deactivate()

/*
	Modifier
*/
/datum/modifier/cloaking_device/activate()
	..()
	var/mob/living/L = target
	L.cloaked = 1
	L.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	L.update_icon()

/datum/modifier/cloaking_device/deactivate()
	..()
	for (var/a in GLOB.cloaking_devices)//Check for any other cloaks
		if (a != source)
			var/obj/item/cloaking_device/CD = a
			if (CD.get_holding_mob() == target)
				if (CD.active)//If target is holding another active cloak then we wont remove their stealth
					return
	var/mob/living/L = target
	L.cloaked = 0
	L.mouse_opacity = MOUSE_OPACITY_ICON
	L.update_icon()

/datum/modifier/cloaking_device/check_validity()
	.=..()
	if (. == 1)
		var/obj/item/cloaking_device/C = source
		if (!C.active)
			return validity_fail("Cloak is inactive!")

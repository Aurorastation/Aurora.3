/obj/item/recharger_backpack
	name = "weapon recharger backpack"
	desc = "Developed by Hephaestus Industries, the HI-92 Recharge Platform is designed for long-term field recharge of energy weapons. Due to legal concerns, the design is rarely seen outside of military hands."
	icon = 'icons/obj/recharger_backpack.dmi'
	icon_state = "recharger_backpack"
	item_state = "recharger_backpack"
	contained_sprite = TRUE
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BACK
	///Power cell used to recharge the gun. Empty by default.
	var/obj/item/cell/powersupply
	///The gun we're currently recharging. Connection handled in connect() and /obj/item/gun/energy/connect()
	var/obj/item/gun/energy/connected

/obj/item/recharger_backpack/Initialize()
	. = ..()
	//To update the icon based on the power cell charge we spawn with
	update_icon()

/obj/item/recharger_backpack/Destroy()
	if(connected)
		connected.disconnect()

	QDEL_NULL(powersupply)

	. = ..()

/obj/item/recharger_backpack/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(powersupply)
		. += SPAN_NOTICE("The backpack display shows that the installed power cell is at [round(powersupply.percent())]%.")

/obj/item/recharger_backpack/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/cell) && !powersupply)
		to_chat(usr, SPAN_NOTICE("You slot \the [attacking_item] into \the [src]'s power socket."))
		playsound(get_turf(src), 'sound/machines/click.ogg', 30, 0)
		user.drop_from_inventory(attacking_item, src)
		powersupply = attacking_item
		update_icon()

	else if(istype(attacking_item, /obj/item/screwdriver) && powersupply)
		to_chat(user, SPAN_NOTICE("You remove \the [powersupply] from \the [src]'s power socket"))
		powersupply.forceMove(get_turf(src))
		user.put_in_hands(powersupply)
		powersupply = null
		update_icon()

	else if(istype(attacking_item, /obj/item/gun/energy))
		var/obj/item/gun/energy/gun_attempting_to_connect = attacking_item
		gun_attempting_to_connect.connect(src)

	else
		. = ..()

/obj/item/recharger_backpack/AltClick(mob/user)
	if(!connected)
		to_chat(usr, SPAN_WARNING("\The [src] has no energy weapon connected!"))
		return

	connected.disconnect()

/obj/item/recharger_backpack/update_icon()
	. = ..()
	if(!powersupply)
		icon_state = "recharger_backpack"
		item_state = "recharger_backpack"
		set_light(0)

	else
		var/current_charge = powersupply.percent()
		switch(current_charge)
			if(70 to INFINITY)
				icon_state = "recharger_backpack_full"
				item_state = "recharger_backpack_full"
				set_light(2, 0.75, LIGHT_COLOR_GREEN)
			if(35 to 70)
				icon_state = "recharger_backpack_med"
				item_state = "recharger_backpack_med"
				set_light(2, 0.75, LIGHT_COLOR_FIRE)
			if(1 to 35)
				icon_state = "recharger_backpack_low"
				item_state = "recharger_backpack_low"
				set_light(2, 0.75, LIGHT_COLOR_RED)
			if(-INFINITY to 1)
				icon_state = "recharger_backpack"
				item_state = "recharger_backpack"
				set_light(0)

/obj/item/recharger_backpack/get_cell()
	if(powersupply)
		return powersupply
	return ..()

/**
 * Connects a gun to the backpack
 *
 * * newgun - An `/obj/item/gun/energy` to connect to the backpack
 *
 * Returns `TRUE` if the connection was successful, `FALSE` otherwise
 */
/obj/item/recharger_backpack/proc/connect(obj/item/gun/energy/newgun)
	if(connected)
		to_chat(usr, SPAN_WARNING("\The [src] already has an energy weapon connected!"))
		return FALSE

	connected = newgun
	RegisterSignal(connected, COMSIG_QDELETING, PROC_REF(handle_weapon_qdel))
	return TRUE

/**
 * Disconnects a gun from the backpack
 *
 * * disconnecting_gun - An `/obj/item/gun/energy` to disconnect from the backpack
 */
/obj/item/recharger_backpack/proc/disconnect(obj/item/gun/energy/disconnecting_gun)
	UnregisterSignal(connected, COMSIG_QDELETING)
	connected = null

///Handles the weapon connected to the backpack being deleted
/obj/item/recharger_backpack/proc/handle_weapon_qdel()
	SIGNAL_HANDLER
	connected = null


/*###############
	SUBTYPES
###############*/

/obj/item/recharger_backpack/high/Initialize()
	. = ..()
	powersupply = new /obj/item/cell/high(src)
	update_icon()

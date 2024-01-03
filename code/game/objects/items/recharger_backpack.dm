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

/obj/item/recharger_backpack/examine(mob/user)
	. = ..()
	if(powersupply)
		to_chat(user, SPAN_NOTICE("The backpack display shows that the installed power cell is at [round(powersupply.percent())]%."))

/obj/item/recharger_backpack/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/cell) && !powersupply)
		to_chat(usr, SPAN_NOTICE("You slot \the [I] into \the [src]'s power socket."))
		playsound(get_turf(src), 'sound/machines/click.ogg', 30, 0)
		user.drop_from_inventory(I, src)
		powersupply = I
		update_icon()

	else if(istype(I, /obj/item/screwdriver) && powersupply)
		to_chat(user, SPAN_NOTICE("You remove \the [powersupply] from \the [src]'s power socket"))
		powersupply.forceMove(get_turf(src))
		user.put_in_hands(powersupply)
		powersupply = null
		update_icon()

	else if(istype(I, /obj/item/gun/energy))
		connect(I)

	else
		. = ..()

/obj/item/recharger_backpack/proc/connect(obj/item/gun/energy/newgun)
	if(connected)
		to_chat(usr, SPAN_WARNING("\The [src] already has an energy weapon connected!"))
		return

	connected = newgun

/obj/item/recharger_backpack/verb/disconnect()
	set name = "Disconnect Energy Weapon"
	set category = "Object"
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

/obj/item/recharger_backpack/Destroy()
	if(connected)
		connected.disconnect()

	if(powersupply)
		QDEL_NULL(powersupply)

	. = ..()

/obj/item/recharger_backpack/high/Initialize()
	. = ..()
	powersupply = new /obj/item/cell/high(src)
	update_icon()

/obj/item/recharger_backpack/get_cell()
	if(powersupply)
		return powersupply
	return ..()

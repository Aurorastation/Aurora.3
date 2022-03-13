/obj/machinery/cell_charger
	name = "heavy-duty cell charger"
	desc = "A much more powerful version of the standard recharger that is specially designed for charging power cells."
	icon = 'icons/obj/power.dmi'
	icon_state = "ccharger"
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 90000	//90 kW. (this the power drawn when charging)
	power_channel = EQUIP
	var/charging_efficiency = 1.38
	var/obj/item/cell/charging = null
	var/chargelevel = -1

/obj/machinery/cell_charger/Initialize(mapload)
	. = ..()
	update_icon()

/obj/machinery/cell_charger/update_icon()
	if(charging && !(stat & (BROKEN|NOPOWER)) )

		var/newlevel = 	round(charging.percent() * 4.0 / 99)

		if(chargelevel != newlevel)
			cut_overlays()
			add_overlay("ccharger-o[newlevel]")
			chargelevel = newlevel
		add_overlay(charging.icon_state)
		add_overlay("cell-o2")
		add_overlay("ccharger-on")
	else
		cut_overlays()

	if(!charging)
		return

/obj/machinery/cell_charger/examine(mob/user)
	if(!..(user, 5))
		return

	to_chat(user, "There's [charging ? "a" : "no"] cell in the charger.")
	if(charging)
		to_chat(user, "Current charge: [charging.charge]")

/obj/machinery/cell_charger/attackby(obj/item/W, mob/user)
	if(stat & BROKEN)
		return

	if(istype(W, /obj/item/cell) && anchored)
		if(charging)
			to_chat(user, "<span class='warning'>There is already a cell in the charger.</span>")
			return
		else
			var/area/a = loc.loc // Gets our locations location, like a dream within a dream
			if(!isarea(a))
				return
			if(a.power_equip == 0) // There's no APC in this area, don't try to cheat power!
				to_chat(user, "<span class='warning'>The [name] blinks red as you try to insert the cell!</span>")
				return

			user.drop_from_inventory(W,src)
			charging = W
			user.visible_message("[user] inserts a cell into the charger.", "You insert a cell into the charger.")
			chargelevel = -1
		update_icon()
	else if(W.iswrench())
		if(charging)
			to_chat(user, "<span class='warning'>Remove the cell first!</span>")
			return

		anchored = !anchored
		to_chat(user, "You [anchored ? "attach" : "detach"] the cell charger [anchored ? "to" : "from"] the ground")
		playsound(src.loc, W.usesound, 75, 1)

/obj/machinery/cell_charger/attack_hand(mob/user)
	if(charging)
		usr.put_in_hands(charging)
		charging.add_fingerprint(user)
		charging.update_icon()

		src.charging = null
		user.visible_message("[user] removes the cell from the charger.", "You remove the cell from the charger.")
		chargelevel = -1
		update_icon()

/obj/machinery/cell_charger/attack_ai(mob/user)
	if(istype(user, /mob/living/silicon/robot) && Adjacent(user)) // Borgs can remove the cell if they are near enough
		if(!src.charging)
			return
		user.put_in_hands(charging)
		charging.update_icon()
		charging = null
		update_icon()
		user.visible_message("[user] removes the cell from the charger.", "You remove the cell from the charger.")


/obj/machinery/cell_charger/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		return
	if(charging)
		charging.emp_act(severity)
	..(severity)


/obj/machinery/cell_charger/machinery_process()
	if((stat & (BROKEN|NOPOWER)) || !anchored)
		update_use_power(0)
		return

	if (charging && !charging.fully_charged())
		charging.give(active_power_usage*CELLRATE*charging_efficiency)
		update_use_power(2)

		update_icon()
	else
		update_use_power(1)

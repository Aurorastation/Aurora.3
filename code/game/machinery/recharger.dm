//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/recharger
	name = "recharger"
	desc = "Useful for recharging electronic devices."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "recharger0"
	anchored = 1
	use_power = 1
	idle_power_usage = 4
	active_power_usage = 30000	//15 kW
	var/charging_efficiency = 0.85
	//Entropy. The charge put into the cell is multiplied by this
	var/obj/item/charging = null

	var/list/allowed_devices = list(/obj/item/weapon/gun/energy, /obj/item/weapon/melee/baton, /obj/item/weapon/cell, /obj/item/modular_computer/, /obj/item/weapon/computer_hardware/battery_module)
	var/icon_state_charged = "recharger2"
	var/icon_state_charging = "recharger1"
	var/icon_state_idle = "recharger0" //also when unpowered
	var/portable = 1

/obj/machinery/recharger/attackby(obj/item/weapon/G as obj, mob/user as mob)
	if(portable && iswrench(G))
		if(charging)
			user << "<span class='alert'>Remove [charging] first!</span>"
			return
		anchored = !anchored
		user << "You have [anchored ? "attached" : "detached"] the recharger."
		playsound(loc, 'sound/items/Ratchet.ogg', 75, 1)
		return

	if (istype(G, /obj/item/weapon/gripper))//Code for allowing cyborgs to use rechargers
		var/obj/item/weapon/gripper/Gri = G
		if (charging)//If there's something in the charger
			if (Gri.grip_item(charging, user))//we attempt to grab it
				charging = null
				update_icon()
			else
				user << "<span class='danger'>Your gripper cannot hold \the [charging].</span>"

	if(!dropsafety(G))
		return

	var/allowed = 0
	for (var/allowed_type in allowed_devices)
		if (istype(G, allowed_type)) allowed = 1

	if(allowed)
		if(charging)
			user << "<span class='warning'>\A [charging] is already charging here.</span>"
			return
		// Checks to make sure he's not in space doing it, and that the area got proper power.
		if(!powered())
			user << "<span class='warning'>The [name] blinks red as you try to insert the item!</span>"
			return
		if (istype(G, /obj/item/weapon/gun/energy/gun/nuclear) || istype(G, /obj/item/weapon/gun/energy/crossbow))
			user << "<span class='notice'>Your gun's recharge port was removed to make room for a miniaturized reactor.</span>"
			return
		if (istype(G, /obj/item/weapon/gun/energy/staff))
			return
		if (istype(G, /obj/item/weapon/gun/energy/wand))
			return
		if(istype(G, /obj/item/modular_computer))
			var/obj/item/modular_computer/C = G
			if(!C.battery_module)
				user << "This device does not have a battery installed."
				return
		user.drop_item()
		G.loc = src
		charging = G
		update_icon()

/obj/machinery/recharger/attack_hand(mob/user as mob)
	if(istype(user,/mob/living/silicon))
		return

	add_fingerprint(user)

	if(charging)
		charging.update_icon()
		user.put_in_hands(charging)
		charging = null
		update_icon()

/obj/machinery/recharger/machinery_process()
	if(stat & (NOPOWER|BROKEN) || !anchored)
		update_use_power(0)
		icon_state = icon_state_idle
		return

	if(!charging)
		update_use_power(1)
		icon_state = icon_state_idle
	else
		var/cell = charging
		if(istype(charging, /obj/item/weapon/melee/baton))
			var/obj/item/weapon/melee/baton/B = charging
			cell = B.bcell
		else if(istype(charging, /obj/item/modular_computer))
			var/obj/item/modular_computer/C = charging
			cell = C.battery_module.battery
		else if(istype(charging, /obj/item/weapon/gun/energy))
			var/obj/item/weapon/gun/energy/E = charging
			cell = E.power_supply
		else if(istype(charging, /obj/item/weapon/computer_hardware/battery_module))
			var/obj/item/weapon/computer_hardware/battery_module/BM = charging
			cell = BM.battery
		if(istype(cell, /obj/item/weapon/cell))
			var/obj/item/weapon/cell/C = cell
			if(!C.fully_charged())
				icon_state = icon_state_charging
				C.give(active_power_usage*CELLRATE*charging_efficiency)
				update_use_power(2)
			else
				icon_state = icon_state_charged
				update_use_power(1)
			return

/obj/machinery/recharger/emp_act(severity)
	if(stat & (NOPOWER|BROKEN) || !anchored)
		..(severity)
		return

	if(istype(charging,  /obj/item/weapon/gun/energy))
		var/obj/item/weapon/gun/energy/E = charging
		if(E.power_supply)
			E.power_supply.emp_act(severity)

	else if(istype(charging, /obj/item/weapon/melee/baton))
		var/obj/item/weapon/melee/baton/B = charging
		if(B.bcell)
			B.bcell.charge = 0
	..(severity)

/obj/machinery/recharger/update_icon()	//we have an update_icon() in addition to the stuff in process to make it feel a tiny bit snappier.
	if(charging)
		icon_state = icon_state_charging
	else
		icon_state = icon_state_idle

obj/machinery/recharger/wallcharger
	name = "wall recharger"
	desc = "A heavy duty wall recharger specialized for energy weaponry."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "wrecharger0"
	active_power_usage = 50 KILOWATTS	//50 kW , It's more specialized than the standalone recharger (guns and batons only) so make it more powerful
	allowed_devices = list(/obj/item/weapon/gun/energy, /obj/item/weapon/melee/baton)
	icon_state_charged = "wrecharger2"
	icon_state_charging = "wrecharger1"
	icon_state_idle = "wrecharger0"
	portable = 0
	charging_efficiency = 0.8

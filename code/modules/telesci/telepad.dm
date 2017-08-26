///SCI TELEPAD///
/obj/machinery/telepad
	name = "telepad"
	desc = "A bluespace telepad used for teleporting objects to and from a location."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "pad-idle"
	anchored = 1
	use_power = 1
	idle_power_usage = 200
	active_power_usage = 5000
	var/efficiency

	component_types = list(
		/obj/item/weapon/circuitboard/telesci_pad,
		/obj/item/bluespace_crystal/artificial = 2,
		/obj/item/weapon/stock_parts/capacitor,
		/obj/item/weapon/stock_parts/console_screen,
		/obj/item/stack/cable_coil{amount = 1}
	)

/obj/machinery/telepad/RefreshParts()
	var/E
	for(var/obj/item/weapon/stock_parts/capacitor/C in component_parts)
		E += C.rating
	efficiency = E

/obj/machinery/telepad/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user, I))
		return

	if(panel_open)
		if(ismultitool(I))
			var/obj/item/device/multitool/M = I
			M.buffer = src
			user << "<span class='caution'>You save the data in the [I.name]'s buffer.</span>"
	else
		if(ismultitool(I))
			user << "<span class='caution'>You should open [src]'s maintenance panel first.</span>"

	default_deconstruction_crowbar(user, I)

/obj/machinery/telepad/update_icon()
	switch (panel_open)
		if (1)
			icon_state = "pad-idle-o"
		if (0)
			icon_state = "pad-idle"

//CARGO TELEPAD//
/obj/machinery/telepad_cargo
	name = "cargo telepad"
	desc = "A telepad used by the Rapid Crate Sender."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "pad-idle"
	anchored = 1
	use_power = 1
	idle_power_usage = 20
	active_power_usage = 500
	var/stage = 0

/obj/machinery/telepad_cargo/attackby(obj/item/weapon/W, mob/user, params)
	if(iswrench(W))
		anchored = 0
		playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
		if(anchored)
			anchored = 0
			user << "<span class='caution'>\The [src] can now be moved.</span>"
		else if(!anchored)
			anchored = 1
			user << "<span class='caution'>\The [src] is now secured.</span>"
	if(isscrewdriver(W))
		if(stage == 0)
			playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
			user << "<span class='caution'>You unscrew the telepad's tracking beacon.</span>"
			stage = 1
		else if(stage == 1)
			playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
			user << "<span class='caution'>You screw in the telepad's tracking beacon.</span>"
			stage = 0
	if(iswelder(W) && stage == 1)
		playsound(src, 'sound/items/Welder.ogg', 50, 1)
		user << "<span class='caution'>You disassemble the telepad.</span>"
		new /obj/item/stack/material/steel(get_turf(src))
		new /obj/item/stack/material/glass(get_turf(src))
		qdel(src)

///TELEPAD CALLER///
/obj/item/device/telepad_beacon
	name = "telepad beacon"
	desc = "Use to warp in a cargo telepad."
	icon = 'icons/obj/radio.dmi'
	icon_state = "beacon"
	item_state = "signaler"
	origin_tech = list(TECH_BLUESPACE = 3)

/obj/item/device/telepad_beacon/attack_self(mob/user)
	if(user)
		user << "<span class='caution'>Locked In</span>"
		new /obj/machinery/telepad_cargo(user.loc)
		playsound(src, 'sound/effects/pop.ogg', 100, 1, 1)
		qdel(src)
	return

///HANDHELD TELEPAD USER///
/obj/item/weapon/rcs
	name = "rapid-crate-sender (RCS)"
	desc = "Use this to send crates and closets to cargo telepads."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "rcs"
	flags = CONDUCT
	force = 10
	throwforce = 10
	throw_speed = 2
	throw_range = 5
	var/rcharges = 10
	var/obj/machinery/pad = null
	var/last_charge = 30
	var/mode = 0
	var/rand_x = 0
	var/rand_y = 0
	var/emagged = 0
	var/teleporting = 0

/obj/item/weapon/rcs/examine(mob/user)
	..()
	user << "There are [rcharges] charge\s left."

/obj/item/weapon/rcs/process()
	if(rcharges > 10)
		rcharges = 10
	if(last_charge == 0)
		rcharges++
		last_charge = 30
	else
		last_charge--

/obj/item/weapon/rcs/attack_self(mob/user)
	if(emagged)
		if(mode == 0)
			mode = 1
			playsound(src.loc, 'sound/effects/pop.ogg', 50, 0)
			user << "<span class='caution'>The telepad locator has become uncalibrated.</span>"
		else
			mode = 0
			playsound(src.loc, 'sound/effects/pop.ogg', 50, 0)
			user << "<span class='caution'>You calibrate the telepad locator.</span>"

/obj/item/weapon/rcs/attackby(var/obj/item/O, var/mob/user)
	if (istype(O, /obj/item/weapon/card/emag) && !emagged)
		emagged = 1
		spark(src, 5, alldirs)
		user << "<span class='caution'>You emag the RCS. Click on it to toggle between modes.</span>"

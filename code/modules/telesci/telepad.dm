///SCI TELEPAD///
/obj/machinery/telepad
	name = "telepad"
	desc = "A bluespace telepad used for creating bluespace portals."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "pad-idle"
	anchored = 1
	use_power = POWER_USE_IDLE
	idle_power_usage = 200
	active_power_usage = 5000
	var/efficiency

	component_types = list(
		/obj/item/circuitboard/telesci_pad,
		/obj/item/bluespace_crystal/artificial = 2,
		/obj/item/stock_parts/capacitor,
		/obj/item/stock_parts/console_screen,
		/obj/item/stack/cable_coil{amount = 1}
	)

/obj/machinery/telepad/RefreshParts()
	var/E
	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		E += C.rating
	efficiency = E

/obj/machinery/telepad/attackby(obj/item/attacking_item, mob/user, params)
	if(default_deconstruction_screwdriver(user, attacking_item))
		return

	if(panel_open)
		if(attacking_item.ismultitool())
			var/obj/item/device/multitool/M = attacking_item
			M.buffer = src
			to_chat(user, "<span class='caution'>You save the data in the [attacking_item.name]'s buffer.</span>")
	else
		if(attacking_item.ismultitool())
			to_chat(user, "<span class='caution'>You should open [src]'s maintenance panel first.</span>")

	default_deconstruction_crowbar(user, attacking_item)

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
	use_power = POWER_USE_IDLE
	idle_power_usage = 20
	active_power_usage = 500
	var/stage = 0

/obj/machinery/telepad_cargo/attackby(obj/item/attacking_item, mob/user, params)
	if(attacking_item.iswrench())
		anchored = 0
		attacking_item.play_tool_sound(get_turf(src), 50)
		if(anchored)
			anchored = 0
			to_chat(user, "<span class='caution'>\The [src] can now be moved.</span>")
		else if(!anchored)
			anchored = 1
			to_chat(user, "<span class='caution'>\The [src] is now secured.</span>")
	if(attacking_item.isscrewdriver())
		if(stage == 0)
			attacking_item.play_tool_sound(get_turf(src), 50)
			to_chat(user, "<span class='caution'>You unscrew the telepad's tracking beacon.</span>")
			stage = 1
		else if(stage == 1)
			attacking_item.play_tool_sound(get_turf(src), 50)
			to_chat(user, "<span class='caution'>You screw in the telepad's tracking beacon.</span>")
			stage = 0
	if(attacking_item.iswelder() && stage == 1)
		playsound(src, 'sound/items/Welder.ogg', 50, 1)
		to_chat(user, "<span class='caution'>You disassemble the telepad.</span>")
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
		to_chat(user, "<span class='caution'>Locked In</span>")
		new /obj/machinery/telepad_cargo(user.loc)
		playsound(src, 'sound/effects/pop.ogg', 100, 1, 1)
		qdel(src)
	return

///HANDHELD TELEPAD USER///
/obj/item/rcs
	name = "rapid-crate-sender (RCS)"
	desc = "Use this to send crates and closets to cargo telepads."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "rcs"
	obj_flags = OBJ_FLAG_CONDUCTABLE
	force = 15
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

/obj/item/rcs/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	. += "There are [rcharges] charge\s left."

/obj/item/rcs/process()
	if(rcharges > 10)
		rcharges = 10
	if(last_charge == 0)
		rcharges++
		last_charge = 30
	else
		last_charge--

/obj/item/rcs/attack_self(mob/user)
	if(emagged)
		if(mode == 0)
			mode = 1
			playsound(src.loc, 'sound/effects/pop.ogg', 50, 0)
			to_chat(user, "<span class='caution'>The telepad locator has become uncalibrated.</span>")
		else
			mode = 0
			playsound(src.loc, 'sound/effects/pop.ogg', 50, 0)
			to_chat(user, "<span class='caution'>You calibrate the telepad locator.</span>")

/obj/item/rcs/attackby(obj/item/attacking_item, mob/user)
	if (istype(attacking_item, /obj/item/card/emag) && !emagged)
		emagged = 1
		spark(src, 5, GLOB.alldirs)
		to_chat(user, "<span class='caution'>You emag the RCS. Click on it to toggle between modes.</span>")

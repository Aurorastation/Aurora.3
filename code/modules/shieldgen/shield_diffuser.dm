//
// Shield Diffusers
//

/obj/machinery/shield_diffuser
	name = "shield diffuser"
	desc = "A small underfloor device specifically designed to disrupt energy barriers."
	icon = 'icons/obj/machinery/shielding.dmi'
	icon_state = "fdiffuser_on"
	use_power = POWER_USE_IDLE
	idle_power_usage = 100
	active_power_usage = 2000
	anchored = TRUE
	density = FALSE
	level = 1

	var/diffuser_enabled = TRUE
	var/diffuser_range = 0 // 1x1 tiles, including the tile its on.

/obj/machinery/shield_diffuser/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "It is [diffuser_enabled ? "diffuser_enabled" : "disabled"]."

/obj/machinery/shield_diffuser/process()
	if(stat & BROKEN)
		return PROCESS_KILL

	if(!diffuser_enabled || stat & NOPOWER)
		return

	for(var/obj/effect/energy_field/S in range(diffuser_range, src))
		S.diffuse(5)

/obj/machinery/shield_diffuser/update_icon()
	if(stat & NOPOWER || stat & BROKEN || !diffuser_enabled)
		icon_state = "fdiffuser_off"
	else
		icon_state = "fdiffuser_on"

/obj/machinery/shield_diffuser/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	return attack_hand(user)

/obj/machinery/shield_diffuser/attack_hand(mob/user)
	if(stat & BROKEN)
		return
	interact(user)

/obj/machinery/shield_diffuser/interact(mob/user)
	diffuser_enabled = !diffuser_enabled

	update_icon()
	to_chat(user, "You turn \the [src] [diffuser_enabled ? "on" : "off"].")

/obj/machinery/shield_diffuser/power_change()
	..()
	update_icon()

//
// Shield Diffuser Variants
//

// 3x3 Range Shield Diffuser
/obj/machinery/shield_diffuser/threebythree
	diffuser_range = 1 // 3x3 tiles, including the tile its on.

// Handheld diffuser
/obj/item/device/shield_diffuser
	name = "portable shield diffuser"
	desc = "A small handheld device designed to disrupt energy barriers."
	icon = 'icons/obj/machinery/shielding.dmi'
	icon_state = "hdiffuser_off"
	origin_tech = list(TECH_MAGNET = 5, TECH_POWER = 5)
	var/obj/item/cell/device/cell
	var/enabled = 0

/obj/item/device/shield_diffuser/update_icon()
	if(enabled)
		icon_state = "hdiffuser_on"
	else
		icon_state = "hdiffuser_off"

/obj/item/device/shield_diffuser/New()
	cell = new(src)
	..()

/obj/item/device/shield_diffuser/Destroy()
	QDEL_NULL(cell)
	. = ..()

/obj/item/device/shield_diffuser/get_cell()
	return cell

/obj/item/device/shield_diffuser/process()
	if(!enabled)
		return

	for(var/direction in GLOB.cardinals)
		var/turf/simulated/shielded_tile = get_step(get_turf(src), direction)
		for(var/obj/effect/energy_field/S in shielded_tile)
			// 10kJ per pulse, but gap in the shield lasts for longer than regular diffusers.
			if(istype(S) && !S.diffused_for && cell.checked_use(10000 * CELLRATE))
				S.diffuse(20)

/obj/item/device/shield_diffuser/attack_self()
	enabled = !enabled
	update_icon()
	to_chat(usr, "You turn \the [src] [enabled ? "on" : "off"].")

/obj/item/device/shield_diffuser/examine(mob/user, show_extended)
	. = ..()
	to_chat(user, "The charge meter reads [cell ? cell.percent() : 0]%")
	to_chat(user, "It is [enabled ? "enabled" : "disabled"].")

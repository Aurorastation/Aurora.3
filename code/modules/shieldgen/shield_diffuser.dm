//
// Shield Diffusers
//

/obj/machinery/shield_diffuser
	name = "shield diffuser"
	desc = "A small underfloor device specifically designed to disrupt energy barriers."
	icon = 'icons/obj/machines/shielding.dmi'
	icon_state = "fdiffuser_on"
	use_power = POWER_USE_IDLE
	idle_power_usage = 100
	active_power_usage = 2000
	anchored = TRUE
	density = FALSE
	level = 1

	var/diffuser_enabled = TRUE
	var/diffuser_range = 0 // 1x1 tiles, including the tile its on.

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

/obj/machinery/shield_diffuser/examine(mob/user)
	. = ..()
	to_chat(user, "It is [diffuser_enabled ? "diffuser_enabled" : "disabled"].")

/obj/machinery/shield_diffuser/power_change()
	..()
	update_icon()

//
// Shield Diffuser Variants
//

// 3x3 Range Shield Diffuser
/obj/machinery/shield_diffuser/threebythree
	diffuser_range = 1 // 3x3 tiles, including the tile its on.
/obj/machinery/shield_diffuser
	name = "shield diffuser"
	desc = "A small underfloor device specifically designed to disrupt energy barriers."
	icon = 'icons/obj/machines/shielding.dmi'
	icon_state = "fdiffuser_on"
	use_power = TRUE
	idle_power_usage = 100
	active_power_usage = 2000
	anchored = TRUE
	density = FALSE
	level = 1

	var/enabled = TRUE

/obj/machinery/shield_diffuser/machinery_process()
	if(stat & BROKEN)
		return PROCESS_KILL

	if(!enabled || stat & NOPOWER)
		return

	for(var/obj/effect/energy_field/S in range(1, src))
		S.diffuse(5)

/obj/machinery/shield_diffuser/update_icon()
	if(stat & NOPOWER || stat & BROKEN || !enabled)
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
	enabled = !enabled

	update_icon()
	to_chat(user, "You turn \the [src] [enabled ? "on" : "off"].")

/obj/machinery/shield_diffuser/examine(mob/user)
	. = ..()
	to_chat(user, "It is [enabled ? "enabled" : "disabled"].")

/obj/machinery/shield_diffuser/power_change()
	..()
	update_icon()

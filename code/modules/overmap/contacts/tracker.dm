/obj/item/ship_tracker
	name = "long range tracker"
	desc = "A complex device that transmits conspicuous signals, easily locked onto by modern sensors hardware."
	icon = 'icons/obj/ship_tracker.dmi'
	icon_state = "disabled"

	origin_tech = "{'magnets':3, 'programming':2}"
	var/enabled = FALSE

/obj/item/ship_tracker/Initialize()
	. = ..()

/obj/item/ship_tracker/attack_self(var/mob/user)
	enabled = !enabled
	to_chat(user, SPAN_NOTICE("You [enabled ? "enable" : "disable"] \the [src]"))
	update_icon()

/obj/item/ship_tracker/proc/on_update_icon()
	icon_state = enabled ? "enabled" : "disabled"

/obj/item/ship_tracker/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	. += "It appears to be [enabled ? "enabled" : "disabled"]"

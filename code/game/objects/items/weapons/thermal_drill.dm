/obj/item/thermal_drill
	name = "thermal safe drill"
	desc = "A tungsten carbide thermal drill with magnetic clamps for the purpose of drilling hardened objects. Guaranteed 100% jam proof."
	icon = 'icons/obj/safe_drill.dmi'
	icon_state = "hardened_drill"
	w_class = ITEMSIZE_HUGE
	force = 12
	var/time_multiplier = 1

/obj/item/thermal_drill/Initialize()
	. = ..()

/obj/item/thermal_drill/Destroy()
	return ..()

/obj/item/thermal_drill/diamond_drill
	name = "diamond tipped thermal safe drill"
	desc = "A diamond tipped thermal drill with magnetic clamps for the purpose of quickly drilling hardened objects. Guaranteed 100% jam proof."
	icon_state = "diamond_drill"
	time_multiplier = 2
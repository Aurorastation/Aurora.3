/obj/item/suppressor
	name = "suppressor"
	desc = "A suppressor"
	icon = 'icons/obj/guns/suppressor.dmi'
	icon_state = "suppressor_item"
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 3)
	w_class = WEIGHT_CLASS_SMALL

/obj/item/suppressor/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Suppressors can be attached to weapons to reduce their sound."
	. += "Click on a weapon adjacent to you or in your hand to attach it and ALT-click the weapon to remove it."

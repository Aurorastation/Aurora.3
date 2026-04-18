/obj/item/ammo_display
	name = "holographic ammo display"
	desc = "A device that can be attached to most firearms, providing a holographic display of the remaining ammunition to the user."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "ammo_display"
	origin_tech = list(TECH_BLUESPACE = 3, TECH_MATERIAL = 4, TECH_DATA = 4)
	w_class = WEIGHT_CLASS_TINY

/obj/item/ammo_display/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Holographic ammo displays can be attached to firearms to give an ammo readout on the HUD."
	. += "Click on a weapon adjacent to you or in your hand to attach it, and use a screwdriver on the weapon to remove it."

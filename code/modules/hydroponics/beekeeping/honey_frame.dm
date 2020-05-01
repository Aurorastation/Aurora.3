/obj/item/honey_frame
	name = "beehive frame"
	desc = "A frame for the beehive that can store honeycombs."
	icon = 'icons/obj/beekeeping.dmi'
	icon_state = "honeyframe"
	w_class = ITEMSIZE_SMALL
	var/honey = 0

/obj/item/honey_frame/filled
	name = "filled beehive frame"
	desc = "A frame for the beehive that has been filled with honeycombs."
	honey = 20

/obj/item/honey_frame/filled/Initialize()
	. = ..()
	add_overlay("honeycomb")
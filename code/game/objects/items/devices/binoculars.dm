/obj/item/device/binoculars

	name = "binoculars"
	desc = "A pair of binoculars."
	icon = 'icons/obj/item/device/binoculars.dmi'
	icon_state = "binoculars"
	item_state = "binoculars"
	action_button_name = "Toggle Binoculars"
	obj_flags = OBJ_FLAG_CONDUCTABLE
	force = 11
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 5.0
	throw_range = 15
	throw_speed = 3

	var/tileoffset = 14
	var/viewsize = 7

/obj/item/device/binoculars/attack_self(mob/user)
	zoom(user,tileoffset,viewsize, show_zoom_message = FALSE)

/obj/item/device/binoculars/high_power
	name = "high power binoculars"
	desc = "A pair of high power binoculars."
	icon_state = "binoculars_high"
	tileoffset = 14*3

/obj/item/device/flashlight/lamp
	name = "desk lamp"
	desc = "A desk lamp with an adjustable mount."
	description_cult = "This can be reforged to become a pylon."
	icon_state = "lamp"
	item_state = "lamp"
	center_of_mass = list("x" = 13,"y" = 11)
	brightness_on = 4
	w_class = ITEMSIZE_HUGE
	flags = CONDUCT
	uv_intensity = 100
	on = TRUE
	slot_flags = 0 //No wearing desklamps
	light_wedge = LIGHT_OMNI


// green-shaded desk lamp
/obj/item/device/flashlight/lamp/green
	desc = "A classic green-shaded desk lamp."
	icon_state = "lampgreen"
	item_state = "lampgreen"
	center_of_mass = list("x" = 15,"y" = 11)
	brightness_on = 5
	light_color = "#FFC58F"

/obj/item/device/flashlight/lamp/verb/toggle_light()
	set name = "Toggle light"
	set category = "Object"
	set src in oview(1)

	if(!usr.stat)
		attack_self(usr)

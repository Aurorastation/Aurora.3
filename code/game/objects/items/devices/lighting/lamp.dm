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

//Lava Lamps: Because we're already stuck in the 70ies with those fax machines.
/obj/item/device/flashlight/lamp/lava
	name = "lava lamp"
	desc = "A kitchy throwback decorative light. Noir Edition."
	icon_state = "lavalamp"
	brightness_on = 3
	matter = list(DEFAULT_WALL_MATERIAL = 250, MATERIAL_GLASS = 200)

/obj/item/device/flashlight/lamp/lava/update_icon()
	if(on)
		set_light(brightness_on)
	else
		set_light(0)
	overlays.Cut()
	var/image/I = image(icon = icon, icon_state = "lavalamp-[on ? "on" : "off"]")
	I.color = light_color
	overlays += I

/obj/item/device/flashlight/lamp/lava/red
	desc = "A kitchy red decorative light."
	light_color = COLOR_RED

/obj/item/device/flashlight/lamp/lava/blue
	desc = "A kitchy blue decorative light."
	light_color = COLOR_BLUE

/obj/item/device/flashlight/lamp/lava/cyan
	desc = "A kitchy cyan decorative light."
	light_color = COLOR_CYAN

/obj/item/device/flashlight/lamp/lava/green
	desc = "A kitchy green decorative light."
	light_color = COLOR_GREEN

/obj/item/device/flashlight/lamp/lava/orange
	desc = "A kitchy orange decorative light."
	light_color = COLOR_ORANGE

/obj/item/device/flashlight/lamp/lava/purple
	desc = "A kitchy purple decorative light."
	light_color = COLOR_PURPLE
/obj/item/device/flashlight/lamp/lava/pink
	desc = "A kitchy pink decorative light."
	light_color = COLOR_PINK

/obj/item/device/flashlight/lamp/lava/yellow
	desc = "A kitchy yellow decorative light."
	light_color = COLOR_YELLOW

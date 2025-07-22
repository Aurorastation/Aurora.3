/obj/item/device/flashlight/lamp
	name = "desk lamp"
	desc = "A desk lamp with an adjustable mount."
	icon_state = "lamp"
	item_state = "lamp"
	center_of_mass = list("x" = 13,"y" = 11)
	brightness_on = 4
	flashlight_power = 1.0
	w_class = WEIGHT_CLASS_HUGE
	obj_flags = OBJ_FLAG_CONDUCTABLE
	uv_intensity = 100
	power_use = FALSE
	on = TRUE
	slot_flags = 0 //No wearing desklamps
	light_wedge = LIGHT_OMNI
	toggle_sound = /singleton/sound_category/switch_sound
	activation_sound = 'sound/effects/lighton.ogg'

/obj/item/device/flashlight/lamp/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Left-click this item in-hand to toggle the light, or right-click it and use the 'Toggle Light' verb."

/obj/item/device/flashlight/lamp/antagonist_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "As a Cultist, this item can be reforged to become a pylon."

/obj/item/device/flashlight/lamp/off
	on = FALSE

// green-shaded desk lamp
/obj/item/device/flashlight/lamp/green
	desc = "A classic green-shaded desk lamp."
	icon_state = "lampgreen"
	item_state = "lampgreen"
	brightness_on = 5
	light_color = "#FFC58F"
	toggle_sound = 'sound/machines/switch_chain.ogg'

/obj/item/device/flashlight/lamp/verb/toggle_light()
	set name = "Toggle Light"
	set category = "Object"
	set src in oview(1)

	if(!usr.stat)
		attack_self(usr)

//Lava Lamps: Because we're already stuck in the 70ies with those fax machines.
/obj/item/device/flashlight/lamp/lava
	name = "data encryption lamp"
	desc = "Random oil globules within were parsed in photos for your protection. Enjoy this kitschy memorabilia by sticking it on your desk."
	icon_state = "lavalamp"
	brightness_on = 3
	flashlight_power = 0.5
	matter = list(DEFAULT_WALL_MATERIAL = 250, MATERIAL_GLASS = 200)

/obj/item/device/flashlight/lamp/lava/update_icon()
	if(on)
		set_light(brightness_on, flashlight_power, light_color)
	else
		set_light(0)
	ClearOverlays()
	var/image/I = image(icon = icon, icon_state = "lavalamp-[on ? "on" : "off"]")
	I.color = light_color
	AddOverlays(I)

/obj/item/device/flashlight/lamp/lava/red
	light_color = COLOR_RED

/obj/item/device/flashlight/lamp/lava/blue
	light_color = COLOR_BLUE

/obj/item/device/flashlight/lamp/lava/cyan
	light_color = COLOR_CYAN

/obj/item/device/flashlight/lamp/lava/green
	light_color = COLOR_GREEN

/obj/item/device/flashlight/lamp/lava/orange
	light_color = COLOR_ORANGE

/obj/item/device/flashlight/lamp/lava/purple
	light_color = COLOR_PURPLE

/obj/item/device/flashlight/lamp/lava/pink
	light_color = COLOR_PINK

/obj/item/device/flashlight/lamp/lava/yellow
	light_color = COLOR_YELLOW

/obj/item/device/flashlight/lamp/stage
	name = "stage lamp"
	desc = "A portable, beautiful and flashy stage light!"
	light_color = COLOR_ORANGE
	icon_state = "stage"

/obj/item/device/flashlight/lamp/holodeck
	name = "holographic lighting orb"
	desc = "A floating orb that comes in a variety of colors. Optional holodeck lighting."
	anchored = 1
	brightness_on = 12
	light_color = "#ffcb9b"
	icon = 'icons/effects/props/holodeck/holodeck_tools.dmi'
	icon_state = "orb"

/obj/item/device/flashlight/lamp/holodeck/attack_hand(mob/user)
	toggle()

/obj/item/device/flashlight/lamp/box
	name = "box lamp"
	desc = "A box-shaped traditional flame lamp. Less safe, more pretty."
	brightness_on = 5
	light_color = "#ffcb9b"
	icon = 'icons/effects/props/holodeck/konyang/32x32.dmi'
	icon_state = "boxlamp"

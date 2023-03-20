/obj/item/device/flashlight/flare/glowstick
	name = "green glowstick"
	desc = "A green military-grade glowstick."
	w_class = ITEMSIZE_SMALL
	brightness_on = 1.2
	flashlight_power = 2
	light_color = "#49F37C"
	icon_state = "glowstick"
	item_state = "glowstick"
	produce_heat = 0
	uv_intensity = 255
	light_wedge = LIGHT_OMNI
	activation_sound = 'sound/items/glowstick.ogg'
	toggle_sound = null

/obj/item/device/flashlight/flare/glowstick/Initialize()
	. = ..()
	fuel = rand(9 MINUTES, 12 MINUTES)
	light_color = color

/obj/item/device/flashlight/flare/glowstick/process()
	fuel = max(fuel - 1, 0)
	if(!fuel || !on)
		turn_off()
		if(!fuel)
			src.icon_state = "[initial(icon_state)]-empty"
		STOP_PROCESSING(SSprocessing, src)

/obj/item/device/flashlight/flare/glowstick/update_icon()
	overlays.Cut()
	if(!fuel)
		icon_state = "[initial(icon_state)]-empty"
		set_light(0)
	else if(on)
		var/image/I = overlay_image(icon, "glowstick-overlay", color)
		I.blend_mode = BLEND_ADD
		add_overlay(I)
		icon_state = "[initial(icon_state)]-on"
		item_state = "[initial(icon_state)]-on"
		set_light(brightness_on, flashlight_power, light_color)
	else
		icon_state = initial(icon_state)
	update_held_icon()

/obj/item/device/flashlight/flare/glowstick/activate(mob/user)
	if(istype(user))
		user.visible_message(
			SPAN_NOTICE("\The [user] cracks and shakes \the [src]."),
			SPAN_NOTICE("You crack and shake \the [src], turning it on!"),
			SPAN_NOTICE("You hear someone crack and shake a glowstick.")
		)

/obj/item/device/flashlight/flare/glowstick/red
	name = "red glowstick"
	desc = "A red military-grade glowstick."
	color = "#FC0F29"

/obj/item/device/flashlight/flare/glowstick/blue
	name = "blue glowstick"
	desc = "A blue military-grade glowstick."
	color = "#599DFF"

/obj/item/device/flashlight/flare/glowstick/orange
	name = "orange glowstick"
	desc = "A orange military-grade glowstick."
	color = "#FA7C0B"

/obj/item/device/flashlight/flare/glowstick/yellow
	name = "yellow glowstick"
	desc = "A yellow military-grade glowstick."
	color = "#FEF923"

/obj/item/device/flashlight/flare/glowstick/random
	name = "glowstick"
	desc = "A party-grade glowstick."
	color = "#FF00FF"

/obj/item/device/flashlight/flare/glowstick/random/Initialize()
	color = rgb(rand(50, 255), rand(50, 255), rand(50, 255))
	. = ..()

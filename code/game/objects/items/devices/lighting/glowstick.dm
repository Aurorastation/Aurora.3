/obj/item/device/flashlight/flare/glowstick
	name = "green glowstick"
	desc = "A green military-grade glowstick."
	w_class = 2
	brightness_on = 1.5
	light_power = 1
	color = "#49F37C"
	icon_state = "glowstick"
	item_state = "glowstick"
	uv_intensity = 255
	light_wedge = LIGHT_OMNI
	activation_sound = 'sound/items/glowstick.ogg'

/obj/item/device/flashlight/flare/glowstick/New()
	. = ..()
	fuel = rand(900, 1200)
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
		icon_state = "[initial(icon_state)]-on"
		item_state = "[initial(icon_state)]-on"
		set_light(brightness_on)
	else
		icon_state = initial(icon_state)
	update_held_icon()

/obj/item/device/flashlight/flare/glowstick/attack_self(var/mob/living/user)

	if(((user.is_clumsy())) && prob(50))
		to_chat(user, span("notice", "You break \the [src] apart, spilling its contents everywhere!"))
		fuel = 0
		new /obj/effect/decal/cleanable/greenglow(get_turf(user))
		user.apply_effect((rand(15,30)),IRRADIATE,blocked = user.getarmor(null, "rad"))
		qdel(src)
		return

	if(!fuel)
		to_chat(user, span("notice", "\The [src] has already been used."))
		return
	if(on)
		to_chat(user, span("notice", "\The [src] has already been turned on."))
		return

	. = ..()

	if(.)
		user.visible_message(
		span("notice", "[user] cracks and shakes \the [src]."),
		span("notice", "You crack and shake \the [src], turning it on!")
		)
		update_icon()
		START_PROCESSING(SSprocessing, src)

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

/obj/item/device/flashlight/flare/glowstick/random/New()
	color = rgb(rand(50,255),rand(50,255),rand(50,255))
	..()
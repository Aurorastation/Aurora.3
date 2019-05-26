/obj/item/device/flashlight/glowstick
	name = "green glowstick"
	desc = "A green military-grade glowstick."
	w_class = 2
	brightness_on = 1.5
	light_power = 1
	light_color = "#49F37C"
	color = "#49F37C"
	icon_state = "glowstick"
	item_state = "glowstick"
	uv_intensity = 255
	var/fuel = 0
	light_wedge = LIGHT_OMNI
	activation_sound = null

/obj/item/device/flashlight/glowstick/New()
	fuel = rand(900, 1200)
	..()

/obj/item/device/flashlight/glowstick/process()
	fuel = max(fuel - 1, 0)
	if(!fuel || !on)
		turn_off()
		if(!fuel)
			src.icon_state = "[initial(icon_state)]-empty"
		STOP_PROCESSING(SSprocessing, src)

/obj/item/device/flashlight/glowstick/proc/turn_off()
	on = 0
	update_icon()

/obj/item/device/flashlight/glowstick/update_icon()
	overlays.Cut()
	if(!fuel)
		icon_state = "[initial(icon_state)]-empty"
		item_state = "glowstick"
		set_light(0)
	else if(on)
		var/image/I = image(icon,"[initial(icon_state)]-on",color)
		I.blend_mode = BLEND_ADD
		overlays += I
		item_state = "[initial(icon_state)]-on"
		set_light(brightness_on)
	else
		icon_state = initial(icon_state)
	update_held_icon()

/obj/item/device/flashlight/glowstick/attack_self(var/mob/living/user)

	if(((user.is_clumsy())) && prob(50))
		to_chat(user, "<span class='notice'>You break \the [src] apart, spilling its contents everywhere!</span>")
		fuel = 0
		new /obj/effect/decal/cleanable/greenglow(get_turf(user))
		user.apply_effect((rand(15,30)),IRRADIATE,blocked = user.getarmor(null, "rad"))
		qdel(src)
		return

	if(!fuel)
		to_chat(user, "<span class='notice'>\The [src] has already been used.</span>")
		return
	if(on)
		to_chat(user, "<span class='notice'>\The [src] has already been turned on.</span>")
		return

	. = ..()

	if(.)
		user.visible_message("<span class='notice'>[user] cracks and shakes \the [src].</span>", "<span class='notice'>You crack and shake \the [src], turning it on!</span>")
		START_PROCESSING(SSprocessing, src)

/obj/item/device/flashlight/glowstick/red
	name = "red glowstick"
	desc = "A red military-grade glowstick."
	light_color = LIGHT_COLOR_RED //"#FC0F29"
	color = "#FC0F29"

/obj/item/device/flashlight/glowstick/blue
	name = "blue glowstick"
	desc = "A blue military-grade glowstick."
	light_color = LIGHT_COLOR_BLUE //"#599DFF"
	color = "#599DFF"

/obj/item/device/flashlight/glowstick/orange
	name = "orange glowstick"
	desc = "A orange military-grade glowstick."
	light_color = LIGHT_COLOR_ORANGE//"#FA7C0B"
	color = "#FA7C0B"

/obj/item/device/flashlight/glowstick/yellow
	name = "yellow glowstick"
	desc = "A yellow military-grade glowstick."
	light_color = LIGHT_COLOR_YELLOW //"#FEF923"
	color = "#FEF923"

/obj/item/device/flashlight/glowstick/random
	name = "glowstick"
	desc = "A party-grade glowstick."
	light_color = "#FF00FF"
	color = "#FF00FF"

/obj/item/device/flashlight/glowstick/random/New()
	light_color = rgb(rand(50,255),rand(50,255),rand(50,255))
	..()
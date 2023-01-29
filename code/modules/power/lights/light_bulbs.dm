//
// Lights
// Will fit into empty "/obj/machinery/light" of the corresponding type.
//

/obj/item/light
	name = "light parent item"
	desc = DESC_PARENT
	icon = 'icons/obj/lights.dmi'
	force = 2
	throwforce = 5
	w_class = ITEMSIZE_TINY
	matter = list(DEFAULT_WALL_MATERIAL = 60)
	drop_sound = 'sound/items/drop/drinkglass.ogg'
	pickup_sound = 'sound/items/pickup/drinkglass.ogg'
	var/status = 0 // "LIGHT_OK", "LIGHT_BURNED" or "LIGHT_BROKEN".
	var/switch_count = 0	// Number of times switched.
	var/brightness_range = 2 // How much light it gives off.
	var/brightness_power = 0.45
	var/brightness_color = LIGHT_COLOR_HALOGEN
	var/light_type = null
	var/randomize_range = FALSE
	var/randomize_colour = TRUE
	var/list/randomized_colours = LIGHT_STANDARD_COLORS

/obj/item/light/Initialize()
	. = ..()
	if(randomize_range)
		switch(light_type)
			if("tube")
				brightness_range = rand(6, 9)
			if("bulb")
				brightness_range = rand(4, 6)
	if(randomize_colour)
		brightness_color = pick(randomized_colours)
	update()

// Update the icon state and description of the light.
/obj/item/light/proc/update()
	cut_overlays()
	switch(status)
		if(LIGHT_OK)
			icon_state = "l[light_type]_attachment"
			var/image/I = image(icon, "l[light_type]")
			I.color = brightness_color
			add_overlay(I)
			desc = "A replacement [name]."
		if(LIGHT_BURNED)
			icon_state = "l[light_type]_attachment"
			var/image/I = image(icon, "l[light_type]_burned")
			I.color = brightness_color
			add_overlay(I)
			desc = "A burnt-out [name]."
		if(LIGHT_BROKEN)
			icon_state = "l[light_type]_attachment_broken"
			var/image/I = image(icon, "l[light_type]_broken")
			I.color = brightness_color
			add_overlay(I)
			desc = "A broken [name]."

/obj/item/light/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return
	if(istype(target, /obj/machinery/light))
		return
	if(user.a_intent != I_HURT)
		return

	shatter()

/obj/item/light/proc/shatter()
	if(status == LIGHT_OK || status == LIGHT_BURNED)
		visible_message(SPAN_WARNING("\The [src] shatters!"), SPAN_WARNING("You hear a small glass object shatter!"))
		status = LIGHT_BROKEN
		force = 5
		sharp = TRUE
		playsound(get_turf(src), 'sound/effects/glass_hit.ogg', 75, TRUE)
		new /obj/item/material/shard(get_turf(src))
		update()

// Light Tube
/obj/item/light/tube
	name = "\improper LED light tube"
	desc = "A replacement LED light tube."
	icon_state = "ltube_preset" // Preset state for mapping.
	item_state = "c_tube"
	matter = list(MATERIAL_GLASS = 100)
	brightness_range = 8
	brightness_power = 0.4
	light_type = "tube"

// Spotlight Light Tube
/obj/item/light/tube/large
	name = "LED spotlight light tube"
	brightness_range = 15
	brightness_power = 0.75

// Coloured Light Tube
/obj/item/light/tube/coloured
	randomize_colour = FALSE

/obj/item/light/tube/coloured/red
	name = "red LED light tube"
	brightness_color = LIGHT_COLOR_SCARLET

/obj/item/light/tube/coloured/green
	name = "green LED light tube"
	brightness_color = LIGHT_COLOR_GREEN

/obj/item/light/tube/coloured/blue
	name = "blue LED light tube"
	brightness_color = LIGHT_COLOR_BLUE

/obj/item/light/tube/coloured/magenta
	name = "magenta LED light tube"
	brightness_color = LIGHT_COLOR_VIOLET

/obj/item/light/tube/coloured/yellow
	name = "yellow LED light tube"
	brightness_color = LIGHT_COLOR_YELLOW

/obj/item/light/tube/coloured/cyan
	name = "cyan LED light tube"
	brightness_color = LIGHT_COLOR_CYAN

/obj/item/light/bulb
	name = "\improper LED light bulb"
	desc = "A replacement LED light bulb."
	icon_state = "lbulb_preset"//preset state for mapping
	item_state = "egg"
	matter = list(MATERIAL_GLASS = 100)
	brightness_range = 5
	brightness_power = 0.4
	brightness_color = LIGHT_COLOR_TUNGSTEN
	light_type = "bulb"

/obj/item/light/bulb/coloured
	randomize_colour = FALSE

/obj/item/light/bulb/coloured/red
	name = "red LED light bulb"
	brightness_color = LIGHT_COLOR_SCARLET

/obj/item/light/bulb/coloured/green
	name = "green LED light bulb"
	brightness_color = LIGHT_COLOR_GREEN

/obj/item/light/bulb/coloured/blue
	name = "blue LED light bulb"
	brightness_color = LIGHT_COLOR_BLUE

/obj/item/light/bulb/coloured/magenta
	name = "magenta LED light bulb"
	brightness_color = LIGHT_COLOR_VIOLET

/obj/item/light/bulb/coloured/yellow
	name = "yellow LED light bulb"
	brightness_color = LIGHT_COLOR_YELLOW

/obj/item/light/bulb/coloured/cyan
	name = "cyan LED light bulb"
	brightness_color = LIGHT_COLOR_CYAN

/obj/item/light/throw_impact(atom/hit_atom)
	..()
	shatter()
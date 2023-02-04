
// the light item
// can be tube or bulb subtypes
// will fit into empty /obj/machinery/light of the corresponding type

/obj/item/light
	icon = 'icons/obj/lighting.dmi'
	force = 2
	throwforce = 5
	w_class = ITEMSIZE_TINY
	matter = list(DEFAULT_WALL_MATERIAL = 60)
	drop_sound = 'sound/items/drop/drinkglass.ogg'
	pickup_sound = 'sound/items/pickup/drinkglass.ogg'
	var/status = 0		// LIGHT_OK, LIGHT_BURNED or LIGHT_BROKEN
	var/switchcount = 0	// number of times switched
	var/rigged = 0		// true if rigged to explode
	var/brightness_range = 2 //how much light it gives off
	var/brightness_power = 0.45
	var/brightness_color = LIGHT_COLOR_HALOGEN
	var/lighttype = null
	var/randomize_range = TRUE
	var/randomize_color = TRUE
	var/list/randomized_colors = LIGHT_STANDARD_COLORS

/obj/item/light/Initialize()
	. = ..()
	if(randomize_range)
		switch(lighttype)
			if("tube")
				brightness_range = rand(6,9)
			if("bulb")
				brightness_range = rand(4,6)
	if(randomize_color)
		brightness_color = pick(randomized_colors)
	update()

// update the icon state and description of the light
/obj/item/light/proc/update()
	cut_overlays()
	switch(status)
		if(LIGHT_OK)
			icon_state = "l[lighttype]_attachment"
			var/image/I = image(icon, "l[lighttype]")
			I.color = brightness_color
			add_overlay(I)
			desc = "A replacement [name]."
		if(LIGHT_BURNED)
			icon_state = "l[lighttype]_attachment"
			var/image/I = image(icon, "l[lighttype]_burned")
			I.color = brightness_color
			add_overlay(I)
			desc = "A burnt-out [name]."
		if(LIGHT_BROKEN)
			icon_state = "l[lighttype]_attachment_broken"
			var/image/I = image(icon, "l[lighttype]_broken")
			I.color = brightness_color
			add_overlay(I)
			desc = "A broken [name]."

// attack bulb/tube with object
// if a syringe, can inject phoron to make it explode
/obj/item/light/attackby(var/obj/item/I, var/mob/user)
	. = ..()
	if(istype(I, /obj/item/reagent_containers/syringe))
		var/obj/item/reagent_containers/syringe/S = I

		to_chat(user, SPAN_NOTICE("You inject the solution into \the [src]."))

		if(S.reagents.has_reagent(/singleton/reagent/toxin/phoron/pure, 5))

			log_admin("LOG: [user.name] ([user.ckey]) injected a light with phoron, rigging it to explode.",ckey=key_name(user))
			message_admins("LOG: [user.name] ([user.ckey]) injected a light with phoron, rigging it to explode.")

			rigged = TRUE

		S.reagents.clear_reagents()
		return TRUE

// called after an attack with a light item
// shatter light, unless it was an attempt to put it in a light socket
// now only shatter if the intent was harm

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

/obj/item/light/tube
	name = "light tube"
	desc = "A replacement light tube."
	icon_state = "ltube_preset"//preset state for mapping
	item_state = "c_tube"
	matter = list(MATERIAL_GLASS = 100)
	brightness_range = 8
	brightness_power = 0.4
	lighttype = "tube"

/obj/item/light/tube/colored
	randomize_color = FALSE

/obj/item/light/tube/colored/red
	name = "red light tube"
	brightness_color = LIGHT_COLOR_SCARLET

/obj/item/light/tube/colored/green
	name = "green light tube"
	brightness_color = LIGHT_COLOR_GREEN

/obj/item/light/tube/colored/blue
	name = "blue light tube"
	brightness_color = LIGHT_COLOR_BLUE

/obj/item/light/tube/colored/magenta
	name = "magenta light tube"
	brightness_color = LIGHT_COLOR_VIOLET

/obj/item/light/tube/colored/yellow
	name = "yellow light tube"
	brightness_color = LIGHT_COLOR_YELLOW

/obj/item/light/tube/colored/cyan
	name = "cyan light tube"
	brightness_color = LIGHT_COLOR_CYAN

/obj/item/light/tube/large
	w_class = ITEMSIZE_SMALL
	name = "large light tube"
	brightness_range = 15
	brightness_power = 0.75
	randomize_range = FALSE

/obj/item/light/bulb
	name = "light bulb"
	desc = "A replacement light bulb."
	icon_state = "lbulb_preset"//preset state for mapping
	item_state = "egg"
	matter = list(MATERIAL_GLASS = 100)
	brightness_range = 5
	brightness_power = 0.4
	brightness_color = LIGHT_COLOR_TUNGSTEN
	lighttype = "bulb"

/obj/item/light/bulb/colored
	randomize_color = FALSE

/obj/item/light/bulb/colored/red
	name = "red light bulb"
	brightness_color = LIGHT_COLOR_SCARLET

/obj/item/light/bulb/colored/green
	name = "green light bulb"
	brightness_color = LIGHT_COLOR_GREEN

/obj/item/light/bulb/colored/blue
	name = "blue light bulb"
	brightness_color = LIGHT_COLOR_BLUE

/obj/item/light/bulb/colored/magenta
	name = "magenta light bulb"
	brightness_color = LIGHT_COLOR_VIOLET

/obj/item/light/bulb/colored/yellow
	name = "yellow light bulb"
	brightness_color = LIGHT_COLOR_YELLOW

/obj/item/light/bulb/colored/cyan
	name = "cyan light bulb"
	brightness_color = LIGHT_COLOR_CYAN

/obj/item/light/throw_impact(atom/hit_atom)
	..()
	shatter()

/obj/item/light/bulb/fire
	name = "fire bulb"
	desc = "A replacement fire bulb."
	icon_state = "flight"
	item_state = "egg_red"
	matter = list(MATERIAL_GLASS = 100)
	brightness_range = 8
	brightness_power = 0.45
	randomize_range = FALSE
	randomize_color = FALSE

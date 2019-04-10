
// the light item
// can be tube or bulb subtypes
// will fit into empty /obj/machinery/light of the corresponding type

/obj/item/weapon/light
	icon = 'icons/obj/lighting.dmi'
	force = 2
	throwforce = 5
	w_class = 1
	matter = list(DEFAULT_WALL_MATERIAL = 60)
	var/status = 0		// LIGHT_OK, LIGHT_BURNED or LIGHT_BROKEN
	var/switchcount = 0	// number of times switched
	var/rigged = 0		// true if rigged to explode
	var/brightness_range = 2 //how much light it gives off
	var/brightness_power = 1
	var/brightness_color = LIGHT_COLOR_HALOGEN
	var/lighttype = null
	var/randomize_range = TRUE

/obj/item/weapon/light/tube
	name = "light tube"
	desc = "A replacement light tube."
	icon_state = "ltube_preset"//preset state for mapping
	item_state = "c_tube"
	matter = list("glass" = 100)
	brightness_range = 8
	brightness_power = 0.8
	lighttype = "tube"

/obj/item/weapon/light/tube/colored/red
	name = "red light tube"
	brightness_color = LIGHT_COLOR_SCARLET

/obj/item/weapon/light/tube/colored/green
	name = "green light tube"
	brightness_color = LIGHT_COLOR_GREEN

/obj/item/weapon/light/tube/colored/blue
	name = "blue light tube"
	brightness_color = LIGHT_COLOR_BLUE

/obj/item/weapon/light/tube/colored/magenta
	name = "magenta light tube"
	brightness_color = LIGHT_COLOR_VIOLET

/obj/item/weapon/light/tube/colored/yellow
	name = "yellow light tube"
	brightness_color = LIGHT_COLOR_YELLOW

/obj/item/weapon/light/tube/colored/cyan
	name = "cyan light tube"
	brightness_color = LIGHT_COLOR_CYAN

/obj/item/weapon/light/tube/large
	w_class = 2
	name = "large light tube"
	brightness_range = 15
	brightness_power = 6
	randomize_range = FALSE

/obj/item/weapon/light/bulb
	name = "light bulb"
	desc = "A replacement light bulb."
	icon_state = "lbulb_preset"//preset state for mapping
	item_state = "contvapour"
	matter = list("glass" = 100)
	brightness_range = 5
	brightness_power = 0.75
	brightness_color = LIGHT_COLOR_TUNGSTEN
	lighttype = "bulb"

/obj/item/weapon/light/bulb/colored/red
	name = "red light bulb"
	brightness_color = LIGHT_COLOR_SCARLET

/obj/item/weapon/light/bulb/colored/green
	name = "green light bulb"
	brightness_color = LIGHT_COLOR_GREEN

/obj/item/weapon/light/bulb/colored/blue
	name = "blue light bulb"
	brightness_color = LIGHT_COLOR_BLUE

/obj/item/weapon/light/bulb/colored/magenta
	name = "magenta light bulb"
	brightness_color = LIGHT_COLOR_VIOLET

/obj/item/weapon/light/bulb/colored/yellow
	name = "yellow light bulb"
	brightness_color = LIGHT_COLOR_YELLOW

/obj/item/weapon/light/bulb/colored/cyan
	name = "cyan light bulb"
	brightness_color = LIGHT_COLOR_CYAN

/obj/item/weapon/light/throw_impact(atom/hit_atom)
	..()
	shatter()

/obj/item/weapon/light/bulb/fire
	name = "fire bulb"
	desc = "A replacement fire bulb."
	icon_state = "flight"
	item_state = "egg4"
	matter = list("glass" = 100)
	brightness_range = 8
	brightness_power = 0.8
	randomize_range = FALSE

/obj/item/weapon/light/Initialize()
	. = ..()
	if(randomize_range)
		switch(lighttype)
			if("tube")
				brightness_range = rand(6,9)
			if("bulb")
				brightness_range = rand(4,6)
	update()

// update the icon state and description of the light
/obj/item/weapon/light/proc/update()
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
/obj/item/weapon/light/attackby(var/obj/item/I, var/mob/user)
	..()
	if(istype(I, /obj/item/weapon/reagent_containers/syringe))
		var/obj/item/weapon/reagent_containers/syringe/S = I

		to_chat(user, "You inject the solution into the [src].")

		if(S.reagents.has_reagent("phoron", 5))

			log_admin("LOG: [user.name] ([user.ckey]) injected a light with phoron, rigging it to explode.",ckey=key_name(user))
			message_admins("LOG: [user.name] ([user.ckey]) injected a light with phoron, rigging it to explode.")

			rigged = 1

		S.reagents.clear_reagents()
	else
		..()
	return

// called after an attack with a light item
// shatter light, unless it was an attempt to put it in a light socket
// now only shatter if the intent was harm

/obj/item/weapon/light/afterattack(atom/target, mob/user, proximity)
	if(!proximity) return
	if(istype(target, /obj/machinery/light))
		return
	if(user.a_intent != I_HURT)
		return

	shatter()

/obj/item/weapon/light/proc/shatter()
	if(status == LIGHT_OK || status == LIGHT_BURNED)
		src.visible_message("<span class='warning'>[name] shatters.</span>","<span class='warning'>You hear a small glass object shatter.</span>")
		status = LIGHT_BROKEN
		force = 5
		sharp = 1
		playsound(src.loc, 'sound/effects/Glasshit.ogg', 75, 1)
		update()

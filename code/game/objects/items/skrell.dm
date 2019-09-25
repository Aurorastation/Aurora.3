/obj/item/stellascope
	name = "stellascope"
	desc = "An antique and delicate looking instrument used to study the stars."
	icon = 'icons/obj/skrell_items.dmi'
	icon_state = "starscope"
	w_class = 1
	matter = list("glass" = 200)
	drop_sound = 'sound/items/drop/glass.ogg'
	var/list/constellations = list("Island", "Hatching Egg", "Star Chanter", "Jiu'x'klua", "Stormcloud", "Gnarled Tree", "Poet", "Bloated Toad", "Qu'Poxiii", "Fisher")
	var/selected_constellation
	var/projection_ready = TRUE

/obj/item/stellascope/Initialize()
	. = ..()
	pick_constellation()

/obj/item/stellascope/examine(mob/user)
	..(user)
	to_chat(user, "\The [src] displays the \"[selected_constellation]\".")

/obj/item/stellascope/throw_impact(atom/hit_atom)
	..()
	visible_message("<span class='notice'>\The [src] lands on \the [pick_constellation()].</span>")

/obj/item/stellascope/attack_self(mob/user as mob)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(isskrell(H))
			H.visible_message("<span class='notice'>\The [H] holds the brassy instrument up to \his eye and peers at something unseen.</span>",
							"<span class='notice'>You see the starry edge of srom floating on the void of space.</span>")
			if(projection_ready)
				new/obj/effect/temp_visual/constellation (get_turf(user))
				projection_ready = FALSE
				addtimer(CALLBACK(src, .proc/rearm), 30 SECONDS)


/obj/item/stellascope/proc/rearm()
	projection_ready = TRUE

/obj/item/stellascope/proc/pick_constellation()
	var/chosen_constellation = pick(constellations)
	selected_constellation = chosen_constellation
	return chosen_constellation

/obj/effect/temp_visual/constellation
	name = "starry projection"
	desc = "A holographic projection of star system."
	icon = 'icons/obj/skrell_items.dmi'
	icon_state = "starprojection"
	mouse_opacity = TRUE
	duration = 30 SECONDS
	layer = LIGHTING_LAYER + 0.1
	light_power = 1
	light_range = 1
	light_color = LIGHT_COLOR_HALOGEN

/obj/effect/temp_visual/constellation/attackby(obj/item/W as obj, mob/user as mob)
	visible_message("<span class='notice'>\The [src] vanishes!</span>")
	qdel(src)
	return

/obj/effect/temp_visual/constellation/attackby(obj/item/W as obj, mob/user as mob)
	visible_message("<span class='notice'>\The [src] vanishes!</span>")
	qdel(src)
	return

/obj/effect/temp_visual/constellation/attack_hand(mob/user as mob)
	if(user.a_intent == I_HURT)
		visible_message("<span class='notice'>\The [src] vanishes!</span>")
		qdel(src)
		return

/obj/item/skrell_projector
	name = "nralakk projector"
	desc = "A projector meant to help Federation Skrell feel like theyre carrying home with them wherever they go. It looks very complex."
	icon = 'icons/obj/skrell_items.dmi'
	icon_state = "projector"
	w_class = 1
	matter = list("glass" = 200)
	drop_sound = 'sound/items/drop/glass.ogg'
	var/list/worlds_selection = list("Xrim", "Kal'lo", "Nralakk")
	var/selected_world
	var/working = FALSE

/obj/item/skrell_projector/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/skrell_projector/examine(mob/user)
	..(user)
	if(selected_world && working)
		to_chat(user, "\The [src] displays the world of [selected_world].")

/obj/item/skrell_projector/attack_self(mob/user as mob)
	working = !working

	if(working)
		var/choice = input("You change the projector's world to;","Change the projector's world.") as null|anything in worlds_selection
		apply_world(choice)
		START_PROCESSING(SSprocessing, src)
	else
		set_light(0)
		working = FALSE
		icon_state = initial(icon_state)
		STOP_PROCESSING(SSprocessing, src)

/obj/item/skrell_projector/proc/apply_world(var/choice)
	set_light(2)
	if(choice)
		selected_world = choice

	switch(choice)

		if("Xrim")
			icon_state = "projector_pink"
			light_color = LIGHT_COLOR_PINK

		if("Kal'lo")
			icon_state = "projector_blue"
			light_color = LIGHT_COLOR_BLUE

		if("Nralakk")
			icon_state = "projector_purple"
			light_color = LIGHT_COLOR_PURPLE
		else
			working = FALSE
			set_light(0)
			icon_state = initial(icon_state)
			STOP_PROCESSING(SSprocessing, src)

/obj/item/skrell_projector/process()
	if(!selected_world)
		return

	if(prob(10))
		var/hologram_message
		switch(selected_world)

			if("Xrim")
				hologram_message = pick("You hear strange, warbling birdsong.",
										" You see sunlight filtered through overgrown trees projected on the ceiling.",
										"You see large insects hovering above the projector.")

			if("Kal'lo")
				hologram_message = pick("You see the ocean surface projected on the ceiling.",
										"You see colorful fish swimming above the projector.",
										"You hear the muffled sound of waves breaking above you.")

			if("Nralakk")
				hologram_message = pick("You see the Jargon system sky projected on the ceiling.",
										"You see planets slowly orbiting Nralakk above the projector.",
										"You hear faint ceremonial hymms.")

		if(hologram_message)
			visible_message("<span class='notice'>[hologram_message]</span>")

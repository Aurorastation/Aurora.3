/obj/item/stellascope
	name = "stellascope"
	desc = "An antique and delicate looking instrument used to study the stars."
	icon = 'icons/obj/contained_items/skrell/stellascope.dmi'
	icon_state = "starscope"
	w_class = ITEMSIZE_TINY
	matter = list(MATERIAL_GLASS = 200)
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'
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
			H.visible_message("<span class='notice'>\The [H] holds the brassy instrument up to [H.get_pronoun("his")] eye and peers at something unseen.</span>",
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
	icon = 'icons/obj/contained_items/skrell/stellascope.dmi'
	icon_state = "starprojection"
	mouse_opacity = TRUE
	duration = 30 SECONDS
	layer = EFFECTS_ABOVE_LIGHTING_LAYER
	light_power = 1
	light_range = 1
	light_color = LIGHT_COLOR_HALOGEN
	var/global/image/glow_state

/obj/effect/temp_visual/constellation/Initialize()
	. = ..()
	if(!glow_state)
		glow_state = make_screen_overlay(icon, icon_state)
	add_overlay(glow_state)

/obj/effect/temp_visual/constellation/attackby(obj/item/W as obj, mob/user as mob)
	visible_message("<span class='notice'>\The [src] vanishes!</span>")
	qdel(src)
	return TRUE

/obj/effect/temp_visual/constellation/attack_hand(mob/user as mob)
	if(user.a_intent == I_HURT)
		visible_message("<span class='notice'>\The [src] vanishes!</span>")
		qdel(src)
		return

/obj/item/skrell_projector
	name = "nralakk projector"
	desc = "A projector using technology that originated in Nralakk, meant to help Skrell feel like they're carrying home with them wherever they go. It looks very complex."
	icon = 'icons/obj/contained_items/skrell/nralakk_projector.dmi'
	icon_state = "projector"
	light_color = LIGHT_COLOR_HALOGEN
	w_class = ITEMSIZE_TINY
	matter = list(MATERIAL_GLASS = 200)
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'
	var/list/worlds_selection = list("Nralakk", "Qerrbalak", "Qerr'Malic", "Aliose", "Aweiji", "Xrim", "the Traverse", "Europa", "New Gibson", "Mictlan", "the Starlight Zone")
	var/selected_world
	var/working = FALSE
	var/message_frequency = 10

/obj/item/skrell_projector/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/skrell_projector/examine(mob/user)
	..(user)
	if(selected_world && working)
		to_chat(user, "\The [src] displays a hologram of [selected_world].")

/obj/item/skrell_projector/attack_self(mob/user as mob)
	working = !working

	if(working)
		var/choice = input("You change the projector's hologram to display:","Change the projector's hologram.") as null|anything in worlds_selection
		apply_world(choice)
		START_PROCESSING(SSprocessing, src)
	else
		set_light(0)
		working = FALSE
		update_icon()
		STOP_PROCESSING(SSprocessing, src)

/obj/item/skrell_projector/proc/apply_world(var/choice)
	var/brightness = 2

	if(choice)
		selected_world = choice
	switch(choice)
		if("Nralakk")
			light_color = "#BE1CFF"
		if("Qerrbalak")
			light_color = "#7B1CFF"
		if("Qerr'Malic")
			light_color = "#F9FF1C"
			brightness = 2.5
		if("Aliose")
			light_color = COLOR_WHITE
		if("Aweiji")
			light_color = "#00AE72"
		if("Xrim")
			light_color = "#25550f"
		if("the Traverse")
			light_color = "#220F95"
			brightness = 2.5
		if("Europa")
			light_color = "#1C50FF"
		if("New Gibson")
			light_color = COLOR_OFF_WHITE
		if("Mictlan")
			light_color = "#FF1C1C"
		if("the Starlight Zone")
			light_color = "#00D6FF"
		else
			brightness = 0
			working = FALSE
			STOP_PROCESSING(SSprocessing, src)
	set_light(brightness)
	update_icon()

/obj/item/skrell_projector/update_icon()
	cut_overlays()
	if(working)
		var/image/overlay = overlay_image(icon, "projector_light", light_color, RESET_COLOR)
		add_overlay(overlay)

/obj/item/skrell_projector/process()
	if(!selected_world)
		return

	if(prob(message_frequency))
		var/hologram_message
		switch(selected_world) // If this gets bigger, should probably be a lookup. Switch seems ok for only 11 cases. - lly

			if("Nralakk")
				hologram_message = pick("You see the Nralakk system sky projected on the ceiling.",
										"You see planets slowly orbiting Nralakk above the projector.",
										"You hear faint ceremonial hymns.")
			if("Qerrbalak")
				hologram_message = pick("You hear the muffled sound of waves breaking above you.",
										"You see the ocean surface projected on the ceiling.",
										"You see the memorial of Kal'lo Square above the projector.")
			if("Qerr'Malic")
				hologram_message = pick("You hear the loud hustle and bustle of tourists rushing by.",
										"You see bright, colourful lights emitting from the projector, and hear the jingle of casino chips changing hands around you.",
										"You hear the spin of a roulette table, and the sound of cards being shuffled.")
			if("Aliose")
				hologram_message = pick("You see the bookshelves of the Orq'wesi archive projected on the walls around you.",
										"You hear the steady whistle of the wind.",
										"You see a snowy, arctic landscape projected across the floor.")
			if("Aweiji")
				hologram_message = pick("You see the imperious statue of the Tresja Monument displayed atop the projector.",
										"Above you, great white clouds are projected, obscuring the peaks of tall, grey mountaintops.",
										"You see rolling fields of farmland extending out from the projector.")
			if("Xrim")
				hologram_message = pick("You hear a strange, warbling birdsong.",
										"You see sunlight filtered through overgrown trees projected on the ceiling.",
										"You see large insects hovering above the projector.")
			if("the Traverse")
				hologram_message = pick("You see an empty, dark hologram that fills the room, scattered with infrequent planets in the distance.",
										"A holographic fleet of Nralakk's generational ships are emitted from the projector. They pass by, before disappearing into the dark.",
										"Atop the projector is displayed a depiction of the crown of the Traverse, Pluat Ven'qop. Qukala ships patrol in circles around it.")
			if("Europa")
				hologram_message = pick("Upon the walls is projected the window of a submarine, and beyond it a vast, black ocean.",
										"You see colorful fish swimming around the projector.",
										"Above the projector, the hologram switches between depictions of the three Europan cryptids: a large squid, a giant crab, and a long, slithering eel.")
			if("New Gibson")
				hologram_message = pick("You see depicted tremendous archologies sprouting from the top of icy mountain peaks.",
										"Briefly, the hologram changes to that of a biodome. You can hear an arctic hail whipping by.",
										"You see a miniature Gibsonite Glacier Brick trundling through some holographic snow.")
			if("Mictlan")
				hologram_message = pick("The projector displays a hologram of a blue sea and cloudless skies - the skyline of Lago de Abundancia.",
										"A depiction of a bustling Mictlanian street rotates slowly around above the projector.",
										"You hear the collapsing of large waves upon a beachfront.")
			if("the Starlight Zone")
				hologram_message = pick("You see a holographic projection of the Weishiin sanctuaries around Severson's Rift.",
										"You see the homes of Lekan Village projected on the ceiling, and beneath them the deep waters that would contain Severson City.",
										"You hear the bubbling of water, as the projector briefly changes to a hologram of the Starlight Zone's underwater city.")

		if(hologram_message)
			visible_message("<span class='notice'>[hologram_message]</span>")

/obj/item/skrell_projector/dream // Subtype that starts processing on init, for mapping/use in the dream - lly
	name = "dream projector"
	selected_world = "Nralakk"
	message_frequency = 5
	working = TRUE

/obj/item/skrell_projector/dream/Initialize()
	. = ..()
	apply_world(selected_world)
	START_PROCESSING(SSprocessing, src)

/obj/item/nralakktag
	name = "\improper Nralakk Federation loyalty ear-tag"
	desc = "An ear-tag that shows the wearer is loyal to the Nralakk Federation. A small cable travels into the ear canal..."
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_EARS
	icon = 'icons/obj/contained_items/skrell/jargtag.dmi'
	icon_state = "jargtag"
	item_state = "jargtag"
	contained_sprite = TRUE
	var/fried = FALSE // Doesn't work anymore

/obj/item/nralakktag/equipped(mob/living/carbon/human/M)
	..()
	if(fried)
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.l_ear == src || H.r_ear == src)
			clamp_on(H)

// Could add some stuff to this in the future? I dunno. I just couldn't figure out how to callback to_chat LOL - geeves
/obj/item/nralakktag/proc/do_loyalty(var/mob/wearer)
	to_chat(wearer, SPAN_GOOD("You feel an intense feeling of loyalty towards the Nralakk Federation surge through your brain."))

/obj/item/nralakktag/proc/clamp_on(var/mob/wearer)
	if(fried)
		return
	canremove = FALSE
	icon_state = "[initial(icon_state)]_active"
	to_chat(wearer, SPAN_WARNING("\The [src] clamps down around your ear, releasing a burst of static before going silent. Something probes at your ear canal..."))
	addtimer(CALLBACK(src, .proc/do_loyalty, wearer), 15)

/obj/item/nralakktag/proc/unclamp()
	if(fried)
		return
	if(!canremove)
		icon_state = initial(icon_state)
		visible_message(SPAN_WARNING("\The [src] fizzles loudly, then clicks open!"))
		canremove = TRUE
		fried = TRUE

/obj/item/nralakktag/emp_act(severity)
	unclamp()

/obj/item/nralakktag/emag_act(var/remaining_charges, var/mob/user)
	if(anchored && !canremove)
		unclamp()
		return TRUE
	else
		to_chat(user, SPAN_NOTICE("\The [src] isn't locked down, your e-mag has no effect!"))
		return FALSE

/obj/item/clothing/accessory/badge/starlight
	name = "starlight zone residency card"
	desc = "A residency card given to Skrell who reside within the Starlight Zone in District Eight."
	icon = 'icons/clothing/accessories/passcards.dmi'
	icon_state = "resident_starlight"
	item_state = "resident_starlight"
	flippable = FALSE
	v_flippable = FALSE
	badge_string = null

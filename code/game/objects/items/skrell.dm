/obj/item/stellascope
	name = "stellascope"
	desc = "An antique and delicate looking instrument used to study the stars."
	icon = 'icons/obj/item/skrell/stellascope.dmi'
	icon_state = "starscope"
	w_class = WEIGHT_CLASS_TINY
	matter = list(MATERIAL_GLASS = 200)
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'
	var/list/constellations = list("Island", "Hatching Egg", "Star Chanter", "Jiu'x'klua", "Stormcloud", "Gnarled Tree", "Poet", "Bloated Toad", "Qu'Poxiii", "Fisher")
	var/selected_constellation
	var/projection_ready = TRUE

/obj/item/stellascope/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "\The [src] displays the \"[selected_constellation]\"."

/obj/item/stellascope/Initialize()
	. = ..()
	pick_constellation()

/obj/item/stellascope/throw_impact(atom/hit_atom)
	..()
	visible_message(SPAN_NOTICE("\The [src] lands on \the [pick_constellation()]."))

/obj/item/stellascope/attack_self(mob/user as mob)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(isskrell(H))
			H.visible_message(SPAN_NOTICE("\The [H] holds the brassy instrument up to [H.get_pronoun("his")] eye and peers at something unseen."),
							SPAN_NOTICE("You see the starry edge of srom floating on the void of space."))
			if(projection_ready)
				new/obj/effect/temp_visual/constellation (get_turf(user))
				projection_ready = FALSE
				addtimer(CALLBACK(src, PROC_REF(rearm)), 30 SECONDS)


/obj/item/stellascope/proc/rearm()
	projection_ready = TRUE

/obj/item/stellascope/proc/pick_constellation()
	var/chosen_constellation = pick(constellations)
	selected_constellation = chosen_constellation
	return chosen_constellation

/obj/effect/temp_visual/constellation
	name = "starry projection"
	desc = "A holographic projection of star system."
	icon = 'icons/obj/item/skrell/stellascope.dmi'
	icon_state = "starprojection"
	mouse_opacity = TRUE
	duration = 30 SECONDS
	plane = EFFECTS_ABOVE_LIGHTING_PLANE
	light_power = 1
	light_range = 1
	light_color = LIGHT_COLOR_HALOGEN
	z_flags = ZMM_MANGLE_PLANES
	var/global/image/glow_state

/obj/effect/temp_visual/constellation/Initialize()
	. = ..()
	if(!glow_state)
		glow_state = overlay_image(icon, icon_state)
	AddOverlays(glow_state)

/obj/effect/temp_visual/constellation/attackby(obj/item/attacking_item, mob/user)
	visible_message(SPAN_NOTICE("\The [src] vanishes!"))
	qdel(src)
	return TRUE

/obj/effect/temp_visual/constellation/attack_hand(mob/user as mob)
	if(user.a_intent == I_HURT)
		visible_message(SPAN_NOTICE("\The [src] vanishes!"))
		qdel(src)
		return

/obj/item/skrell_projector
	name = "nralakk projector"
	desc = "A projector using technology that originated in Nralakk, meant to help Skrell feel like they're carrying home with them wherever they go. It looks very complex."
	icon = 'icons/obj/item/skrell/nralakk_projector.dmi'
	icon_state = "projector"
	light_color = LIGHT_COLOR_HALOGEN
	w_class = WEIGHT_CLASS_TINY
	matter = list(MATERIAL_GLASS = 200)
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'
	var/list/worlds_selection = list("Nralakk", "Qerrbalak", "Qerr'Malic", "Aliose", "Aweiji", "Xrim", "the Traverse", "Europa", "New Gibson", "Mictlan", "the Starlight Zone", "Diulszi")
	var/selected_world
	var/working = FALSE
	var/message_frequency = 5

/obj/item/skrell_projector/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(selected_world && working)
		. += "\The [src] displays a hologram of [selected_world]."

/obj/item/skrell_projector/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/skrell_projector/attack_self(mob/user as mob)
	working = !working

	if(working)
		var/choice = tgui_input_list(user, "You change the projector's hologram to display:","Change the projector's hologram.", worlds_selection)
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
		if("Diulszi")
			light_color = "#002373"
		else
			brightness = 0
			working = FALSE
			STOP_PROCESSING(SSprocessing, src)
	set_light(brightness)
	update_icon()

/obj/item/skrell_projector/update_icon()
	ClearOverlays()
	if(working)
		var/image/overlay = overlay_image(icon, "projector_light", light_color, RESET_COLOR)
		AddOverlays(overlay)

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
			if("Diulszi")
				hologram_message = pick("Projected on the ceiling is a vista of the Kervasii World Amusement Park's floating islands.",
										"You see massive resort buildings looming high over a crystal-clear ocean.",
										"You hear light chittering as the projector switches to a depiction of a C'thuric research lab.")


		if(hologram_message)
			visible_message(SPAN_NOTICE("[hologram_message]"))

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
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = SLOT_EARS
	icon = 'icons/obj/item/skrell/jargtag.dmi'
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
	addtimer(CALLBACK(src, PROC_REF(do_loyalty), wearer), 15)

/obj/item/nralakktag/proc/unclamp()
	if(fried)
		return
	if(!canremove)
		icon_state = initial(icon_state)
		visible_message(SPAN_WARNING("\The [src] fizzles loudly, then clicks open!"))
		canremove = TRUE
		fried = TRUE

/obj/item/nralakktag/emp_act(severity)
	. = ..()

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
	icon = 'icons/obj/item/clothing/accessory/passcards.dmi'
	icon_state = "resident_starlight"
	item_state = "resident_starlight"
	flippable = FALSE
	v_flippable = FALSE
	badge_string = null

/obj/item/storage/box/fancy/cigarettes/federation
	name = "\improper Eriuyushi Sunset cigarette packet"
	desc = "A short, wide packet of cigarettes with the Nralakk Federation's flag printed on the front. The label says that they are 'regular' flavour."
	desc_extended = "Meticulously grown and machine rolled in the Nralakk Federation, these cigarettes are the Federation's attempt at entering the tobacco market. They use tobacco hydroponically grown in the underwater town of Eriyushi on Qerrbalak."
	icon_state = "nfpacket"
	item_state = "nfpacket"
	cigarette_to_spawn = /obj/item/clothing/mask/smokable/cigarette/sweet

/obj/item/storage/box/fancy/cigarettes/dyn
	name = "\improper Xaqixal Dyn Fields cigarette packet"
	desc = "A short, wide packet of cigarettes with the Nralakk Federation's flag printed on the front. The label says that they are 'dyn menthol' flavour."
	desc_extended = "Meticulously grown and machine rolled in the Nralakk Federation, these cigarettes are the Federation's attempt at entering the tobacco market. Dyn leaves grown on Xaqixal are used to add the refreshing menthol flavour."
	icon_state = "dynpacket"
	item_state = "dynpacket"
	cigarette_to_spawn = /obj/item/clothing/mask/smokable/cigarette/dyn

/obj/item/storage/box/fancy/cigarettes/wulu
	name = "wulumunusha joint pouch"
	desc = "A leather pouch of pre-rolled wulumunusha joints. A common sight in Federation space, they can be smoked for recreational or religious purposes."
	desc_extended = "Wulumunusha holds a cultural and religious importance for Skrell throughout the Spur. While disposable pouches of wulumunusha are readily available in Federation space, many Skrell choose to refill a reusable pouch like this one when away from home, typically decorated with unique colours and designs."
	icon_state = "wulupacket"
	item_state = "wulupacket"
	cigarette_to_spawn = /obj/item/clothing/mask/smokable/cigarette/wulu

/obj/item/storage/chewables/tobacco/federation
	name = "tin of Leviathan Chew"
	desc = "A sweet-smelling tin of saltwater taffy flavoured chewing tobacco, made using finely aged tobacco from the Nralakk Federation. The tin has a Vru'qos on the label, a whale-like creature common throughout Federation space."
	desc_extended = "Imported from the Nralakk Federation, this brand of chewing tobacco is noticeably sweeter than usual to accommodate Skrellian tastes."
	icon_state = "chew_fed"
	item_state = "chew_fed"
	starts_with = list(/obj/item/clothing/mask/chewable/tobacco/sweet = 6)

/obj/item/storage/chewables/tobacco/dyn
	name = "tin of Weibi's Breeze"
	desc = "A sweet-smelling tin of menthol flavoured chewing tobacco, made using finely aged tobacco from the Nralakk Federation. The tin has a dyn leaf on the label."
	desc_extended = "Imported from the Nralakk Federation, this brand of chewing tobacco is noticeably sweeter than usual to accommodate Skrellian tastes."
	icon_state = "chew_dyn"
	item_state = "chew_dyn"
	starts_with = list(/obj/item/clothing/mask/chewable/tobacco/dyn = 6)

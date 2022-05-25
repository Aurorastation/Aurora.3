/obj/item/vaurca_projector
	name = "virtual reality looking-glass"
	desc = "A holographic projector using advanced technology that immerses someone into a scene using full panoramic holograms, smell and 3d spatial sound projection. It is developed and distributed by Hive Zo'ra and allows the viewer to peer in real-time into virtual reality realms specifically designed for outside viewing such as those belonging to High Queen Vaur. Typically using one would allow you to control a drone but this is a smaller portable version and as such only allows a user to move around set-locations."
	icon = 'icons/obj/contained_items/skrell/nralakk_projector.dmi'
	icon_state = "projector"
	light_color = LIGHT_COLOR_HALOGEN
	w_class = ITEMSIZE_TINY
	matter = list(MATERIAL_GLASS = 200)
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'
	var/list/worlds_selection = list("Moana", "Hive War exhibition", "Celestial Landing Ground")
	var/selected_world
	var/working = FALSE
	var/message_frequency = 10

/obj/item/vaurca_projector/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/vaurca_projector/examine(mob/user)
	..(user)
	if(selected_world && working)
		to_chat(user, "\The [src] displays a hologram of [selected_world].")

/obj/item/vaurca_projector/attack_self(mob/user as mob)
	working = !working

	if(working)
		var/choice = input("You change the projector's holographic viewfinder to display:","Change the projector's viewfinder.") as null|anything in worlds_selection
		apply_world(choice)
		START_PROCESSING(SSprocessing, src)
	else
		set_light(0)
		working = FALSE
		update_icon()
		STOP_PROCESSING(SSprocessing, src)

/obj/item/vaurca_projector/proc/apply_world(var/choice)
	var/brightness = 2

	if(choice)
		selected_world = choice
	switch(choice)
		if("Moana")
			light_color = "#1122c2"
		if("Hive War exhibition")
			light_color = "#83290b"
		if("Celestial Landing Ground")
			light_color = "#f5e61d"

		else
			brightness = 0
			working = FALSE
			STOP_PROCESSING(SSprocessing, src)
	set_light(brightness)
	update_icon()

/obj/item/vaurca_projector/update_icon()
	cut_overlays()
	if(working)
		var/image/overlay = overlay_image(icon, "projector_light", light_color, RESET_COLOR)
		add_overlay(overlay)

/obj/item/vaurca_projector/process()
	if(!selected_world)
		return

	if(prob(message_frequency))
		var/hologram_message
		switch(selected_world)

			if("Moana")
				hologram_message = pick("You see a golden fortress floating majestically above an ocean of sapphire.",
										"A euphoric smell of the ocean fills your senses as the water gently ebbs and flows.",
										"You hear the faint humming of a hymn as a gentle wave envelops the viewfinder.",
                                        "You can hear a quiet celestial chanting the source of which feels just beyond sight",
                                        "The turquoise water emits a jubilant smell of freshly cut lemons which lasts for only for a moment.",
                                        "You see the gas giant Sedantis dominating a starry sky.")
			if("Hive War exhibition")
				hologram_message = pick("You see a carefully crafted exhibition detailing the Great Hive War. It explains in brief the details of the event through paintings and dioramas.",
										"You smell burning and rusted metal. An exhibition showcases the Battle of a Thousand Titans.",
										"You see a  memorial to the lives lost, a sad hymn flowing in the background.")

			if("Celestial Landing Ground")
				hologram_message = pick("An awe inspiring fortress of gold dominates the landscape and bathes the surrounding area in yellow luminescence.",
										"A loud hymn is chanted in an unknown language accompanied by a smell of morning Dew in the countryside.",
										"Unbound workers moving through the realm stop to gaze up in awe at the distant structure before returning to previous activities.",
                                        "Distant chattering can be heard coming from the fortress including what almost like jovial laughter.",
                                        "The turquoise water emits a jubilant smell of freshly cut lemons which lasts for only for a moment.",
                                        "You see the gas giant Sedantis dominating a starry sky.")


		if(hologram_message)
			visible_message("<span class='notice'>[hologram_message]</span>")

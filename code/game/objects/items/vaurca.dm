/obj/item/skrell_projector/vaurca_projector
	name = "virtual reality looking glass"
	desc = "A holographic projector using advanced technology that immerses someone into a scene using full panoramic holograms, smell and 3D spatial sound projection. It is developed and distributed by Hive Zo'ra and allows the viewer to peer in real-time into virtual reality realms specifically designed for outside viewing such as those belonging to High Queen Vaur."
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "zora_projector"
	worlds_selection = list("Ocean", "Hive War Exhibition", "Celestial Landing Ground", "City of New Sedantis", "Titan Prime")
	message_frequency = 10

/obj/item/skrell_projector/vaurca_projector/attack_self(mob/user as mob)
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

/obj/item/skrell_projector/vaurca_projector/apply_world(choice)
	var/brightness = 2

	if(choice)
		selected_world = choice
	switch(choice)
		if("Ocean")
			light_color = "#1122c2"
		if("Hive War Exhibition")
			light_color = "#83290b"
		if("Celestial Landing Ground")
			light_color = "#f5e61d"
		if("City of New Sedantis")
			light_color = "#1395c9"
		if("Titan Prime")
			light_color = "#418144"

		else
			brightness = 0
			working = FALSE
			STOP_PROCESSING(SSprocessing, src)
	set_light(brightness)
	update_icon()

/obj/item/skrell_projector/vaurca_projector/update_icon()
	cut_overlays()
	if(working)
		var/image/overlay = overlay_image(icon, "zora_projector_light", light_color, RESET_COLOR)
		add_overlay(overlay)

/obj/item/skrell_projector/vaurca_projector/process()
	if(!selected_world)
		return

	if(prob(message_frequency))
		var/hologram_message
		switch(selected_world)

			if("Ocean")
				hologram_message = pick("You see a golden fortress floating majestically above an ocean of sapphire.",
										"A euphoric smell of the ocean fills your senses as the water gently ebbs and flows.",
										"You hear the faint humming of a hymn as a gentle wave envelops the viewfinder.",
                                        "You can hear a quiet celestial chanting the source of which feels just beyond sight.",
                                        "The turquoise water emits a jubilant smell of freshly cut lemons which lasts for only for a moment.",
                                        "You see the gas giant Sedantis dominating a starry sky.")
			if("Hive War Exhibition")
				hologram_message = pick("You see a carefully crafted exhibition detailing the Great Hive War. It explains in brief the details of the event through paintings and dioramas.",
										"You smell burning and rusted metal. An exhibition showcases the Battle of a Thousand Titans.",
										"You see a  memorial to the lives lost, a sad hymn flowing in the background.")

			if("Celestial Landing Ground")
				hologram_message = pick("An awe inspiring fortress of gold dominates the landscape and bathes the surrounding area in yellow luminescence.",
										"A loud hymn is chanted in an unknown language accompanied by a smell of morning dew in the countryside.",
										"Unbound workers moving through the realm stop to gaze up in awe at the distant structure before returning to previous activities.",
                                        "Distant chattering can be heard coming from the fortress including what sounds almost like jovial laughter.",
                                        "The turquoise water emits a jubilant smell of freshly cut lemons which lasts for only for a moment.",
                                        "You see the gas giant Sedantis dominating a starry sky.",
										"For a moment the Golden Fortress towering above starts to glimmer majestically, catching the light from the imposing gas giant in the sky.")

			if("City of New Sedantis")
				hologram_message = pick("A towering cavernous city takes up the viewfinder, great buildings of stone jutting out of the ground and twisting towards the ceiling.",
										"A loud hymn is being chanted in an unknown language and seems to shake the very ground itself.",
										"A mellow blue light comes from thousands of resplendent crystals lining the wall and mingles with the inviting yellow glow from a distant golden fortress.",
                                        "Distant chattering can be heard coming from the city.",
                                        "A distant forge emits Phoron gas from a tower atop its lofty form, as worker drones collect lilac stained glass from within.",
										"A group of Vaurca warriors move through the streets below seemingly practicing for some task unknown.")

			if("Titan Prime")
				hologram_message = pick("An imposing vessel of steel emits a soft glow as it travels through the starry sky aimlessly.",
										"The engines of the towering vessel above emit a soft glow, accompanied by a brief smell of a warm ocean breeze.",
										"A green light flickers from the steel vessel above bathing the surrounding idyllic landscape in its majesty.",
                                        "You see the gas giant Sedantis dominating a starry sky, an imposing vessel of steel blotting out but a small portion of it.")


		if(hologram_message)
			visible_message("<span class='notice'>[hologram_message]</span>")

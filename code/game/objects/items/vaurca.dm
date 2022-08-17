/obj/item/skrell_projector/vaurca_projector
	name = "virtual reality looking glass"
	desc = "A holographic projector using advanced technology that immerses someone into a scene using full panoramic holograms, smell and 3D spatial sound projection. It is developed and distributed by the Zo'ra Hive and allows the viewer to peer in real-time into virtual reality realms specifically designed for outside viewing such as those belonging to High Queen Vaur or Queen Athvur."
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "zora_projector"
	worlds_selection = list("Vaur's Tranquil Ocean", "Vaur's Hive War Exhibition", "Vaur's Celestial Landing Ground", "Vaur's City of New Sedantis", "Vaur's Titan Prime Recreation", "Athvur's City of Paradise", "Athvur's Garden of Splendour", "Athvur's Museum of Fine Art")
	message_frequency = 10
	var/hologram_message
	var/possible_messages
	var/first_message

/obj/item/skrell_projector/vaurca_projector/attack_self(mob/user as mob)
	working = !working

	if(working)
		var/choice = input("You change the projector's holographic viewfinder to display:","Change the projector's viewfinder.") as null|anything in worlds_selection
		apply_world(choice)
		first_message = TRUE
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
		if("Vaur's Tranquil Ocean")
			light_color = "#1122c2"
			possible_messages = list(
			"You see a golden fortress floating majestically above an ocean of sapphire.",
			"A euphoric smell of the ocean fills your senses as the water gently ebbs and flows.",
			"You hear the faint humming of a hymn as a gentle wave envelops the viewfinder.",
            "You can hear a quiet celestial chanting the source of which feels just beyond sight.",
            "The turquoise water emits a jubilant smell of freshly cut lemons which lasts for only for a moment.",
            "You see the gas giant Sedantis dominating a starry sky."
			)
		if("Vaur's Hive War Exhibition")
			light_color = "#83290b"
			possible_messages = list(
			"You see a carefully crafted exhibition detailing the Great Hive War. It explains in brief the details of the event through paintings and dioramas.",
			"You smell burning and rusted metal. An exhibition showcases the Battle of a Thousand Titans.",
			"You see a  memorial to the lives lost, a sad hymn flowing in the background."
			)
		if("Vaur's Celestial Landing Ground")
			light_color = "#f5e61d"
			possible_messages = list(
			"An awe inspiring fortress of gold dominates the landscape and bathes the surrounding area in yellow luminescence.",
			"A loud hymn is chanted in an unknown language accompanied by a smell of morning dew in the countryside.",
			"Unbound workers moving through the realm stop to gaze up in awe at the distant structure before returning to previous activities.",
            "Distant chattering can be heard coming from the fortress including what sounds almost like jovial laughter.",
            "The turquoise water emits a jubilant smell of freshly cut lemons which lasts for only for a moment.",
            "You see the gas giant Sedantis dominating a starry sky.",
			"For a moment the Golden Fortress towering above starts to glimmer majestically, catching the light from the imposing gas giant in the sky."
			)
		if("Vaur's City of New Sedantis")
			light_color = "#1395c9"
			possible_messages = list(
			"A towering cavernous city takes up the viewfinder, great buildings of stone jutting out of the ground and twisting towards the ceiling.",
			"A loud hymn is being chanted in an unknown language and seems to shake the very ground itself.",
			"A mellow blue light comes from thousands of resplendent crystals lining the wall and mingles with the inviting yellow glow from a distant golden fortress.",
            "Distant chattering can be heard coming from the city.",
            "A distant forge emits Phoron gas from a tower atop its lofty form, as worker drones collect lilac stained glass from within.",
			"A group of Vaurca warriors move through the streets below seemingly practicing for some task unknown."
			)
		if("Vaur's Titan Prime Recreation")
			light_color = "#418144"
			possible_messages = list(
			"An imposing vessel of steel emits a soft glow as it travels through the starry sky aimlessly.",
			"The engines of the towering vessel above emit a soft glow, accompanied by a brief smell of a warm ocean breeze.",
			"A green light flickers from the steel vessel above bathing the surrounding idyllic landscape in its majesty.",
            "You see the gas giant Sedantis dominating a starry sky, an imposing vessel of steel blotting out but a small portion of it."
			)
		if("Athvur's City of Paradise")
			light_color = "#eff3ef"
			possible_messages = list(
			"A transcendent cityscape dominates the area, with towering structures of elegant white stone resting atop a blanket of clouds.",
			"In the distance of the cityscape towers a set of sublime sculptures, accented by light from beneath the clouds.",
			"Orchestral music resonates from within an auditorium, the melody carried through the heavens.",
			"An enchanting smell of cedar, cherry and morning freshness penetrates through the air.",
			"A vibrant burst of color permeates through the sky, basking the air in pleasing rainbow luminescence for a moment.", 
			"In the center of a green park Vaurca workers paint not on canvas but in the air, seemingly looking at the landscape for inspiration."
		)
		if("Athvur's Garden of Splendour")
			light_color = "#3adf3a"
			possible_messages = list( 
			"A tranquil garden landscape stretches out to the horizon, its peaceful scenery embellished with flowers of every variety.",
			"Harmonious music accents an indescribable aroma of flowers.",
			"In the distance of the garden, beyond the soothing plants, workers move through an ornate gazebo.",
			"A fountain sits nestled within a thicket clearing, producing a golden substance from which gathered workers drink.",
			"A herd of majestic creatures, each as tall as two people, graze on a patch of grass and lie curled up against each other's silky fur.", 
			"Lilac-breasted birds dart between the tree-line and sing a soothing melody which seems to carry with it a smell of vanilla."
		)
		if("Athvur's Museum of Fine Art")
			light_color = "#e7f0ec"
			possible_messages = list( 
			"A massive display is decorated with examples of seemingly delicately crafted Zo'rane artwork.",
			"Workers mull about the museum, seemingly taking in the atmosphere brought forth by the displays.", 
			"An exhibit showcases reportedly hand-painted landscapes that have won awards.", 
			"A melodic harmony is carried from a distant display marked with 'Music' only perceptible due to the quiet atmosphere of the surrounding exhibition.", 
			"Sculptures of notable Zo'rane historical figures dominate their respective corners, carved from a variety of rare materials.", 
			"Groups of workers move around, seemingly taking a guided tour through the museum, watching each art piece explained to them attentively."
		)


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
	if(!selected_world || !possible_messages)
		return

	if(prob(message_frequency))
		if(first_message)
			hologram_message = possible_messages[1]
			first_message = FALSE
		else
			hologram_message = pick(possible_messages)


		if(hologram_message)
			visible_message("<span class='notice'>[hologram_message]</span>")

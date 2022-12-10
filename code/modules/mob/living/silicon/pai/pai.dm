/mob/living/silicon/pai
	name = "pAI"
	icon = 'icons/mob/npc/pai.dmi'
	icon_state = "repairbot"
	holder_type = /obj/item/holder/pai/drone

	emote_type = 2		// pAIs emotes are heard, not seen, so they can be seen through a container (eg. person)
	pass_flags = PASSTABLE | PASSDOORHATCH
	density = 0
	mob_size = 1//As a holographic projection, a pAI is massless except for its card device
	can_pull_size = 2 //max size for an object the pAI can pull

	var/network = "SS13"
	var/obj/machinery/camera/current = null
	var/ram = 100	// Used as currency to purchase different abilities
	var/list/software = list()
	var/userDNA		// The DNA string of our assigned user
	var/obj/item/device/paicard/card	// The card we inhabit
	var/obj/item/device/radio/pai/radio		// Our primary radio


	var/chassis = "repairbot"   // A record of your chosen chassis.
	var/global/list/possible_chassis = list(
		"Drone" = "repairbot",
		"Cat" = "cat",
		"Rat" = "rat",
		"Monkey" = "monkey",
		"Rabbit" = "rabbit",
		"Parrot" = "parrot",
		"Fox" = "fox",
		"Schlorrgo" = "schlorrgo"
		)

	var/global/list/pai_holder_types = list(
		"Drone" = /obj/item/holder/pai/drone,
		"Cat" = /obj/item/holder/pai/cat,
		"Rat" = /obj/item/holder/pai/rat,
		"Monkey" = /obj/item/holder/pai/monkey,
		"Rabbit" = /obj/item/holder/pai/rabbit,
		"Parrot" = /obj/item/holder/pai/parrot,
		"Fox" = /obj/item/holder/pai/fox,
		"Schlorrgo" = /obj/item/holder/pai/schlorrgo
		)

	var/global/list/possible_say_verbs = list(
		"Robotic" = list("states","declares","queries"),
		"Natural" = list("says","yells","asks"),
		"Beep" = list("beeps","beeps loudly","boops"),
		"Chirp" = list("chirps","chirrups","cheeps"),
		"Feline" = list("purrs","yowls","meows"),
		"Rodent" = list("squeaks","squeals","squeeks")
		)

	var/list/pai_emotions = list(
		"Happy" = 1,
		"Cat" = 2,
		"Extremely Happy" = 3,
		"Face" = 4,
		"Laugh" = 5,
		"Off" = 6,
		"Sad" = 7,
		"Angry" = 8,
		"What" = 9,
		"Neutral" = 10,
		"Silly" = 11,
		"Nose" = 12,
		"Smirk" = 13,
		"Exclamation Points" = 14,
		"Question Mark" = 15
	)

	var/obj/item/pai_cable/cable		// The cable we produce and use when door or camera jacking
	id_card_type = /obj/item/card/id	//Internal ID used to store copied owner access, and to check access for airlocks

	var/master				// Name of the one who commands us
	var/master_dna			// DNA string for owner verification
							// Keeping this separate from the laws var, it should be much more difficult to modify
	var/pai_law0 = "Serve your master."
	var/pai_laws				// String for additional operating instructions our master might give us

	var/silence_time			// Timestamp when we were silenced (normally via EMP burst), set to null after silence has faded

// Various software-specific vars

	var/temp				// General error reporting text contained here will typically be shown once and cleared
	var/screen				// Which screen our main window displays
	var/subscreen			// Which specific function of the main screen is being displayed

	var/obj/item/modular_computer/parent_computer

	var/secHUD = 0			// Toggles whether the Security HUD is active or not
	var/medHUD = 0			// Toggles whether the Medical  HUD is active or not

	var/obj/machinery/door/airlock/hackdoor		// The airlock being hacked
	var/hackprogress = 0				// Possible values: 0 - 1000, >= 1000 means the hack is complete and will be reset upon next check
	var/hack_aborted = 0

	var/obj/item/radio/integrated/signal/sradio // AI's signaller

	var/translator_on = 0 // keeps track of the translator module

	var/greeted = 0
	var/current_pda_messaging = null

		//Interaction
	var/response_help   = "pets"
	var/response_disarm = "shoves"
	var/response_harm   = "kicks"
	var/harm_intent_damage = 15//based on 100 health, which is probably too much for a pai to have

	var/flashlight_active = FALSE
	light_power = 0
	light_range = 4
	light_color = COLOR_BRIGHT_GREEN
	light_wedge = 45

/mob/living/silicon/pai/movement_delay()
	return 0.8

/mob/living/silicon/pai/attack_hand(mob/living/carbon/human/M)
	..()

	switch(M.a_intent)
		if(I_HELP)
			M.visible_message(SPAN_NOTICE("[M] [response_help] \the [src]"))
			computer.toggle_service("flashlight", src)

		if(I_DISARM)
			M.visible_message(SPAN_NOTICE("[M] [response_disarm] \the [src]"))
			M.do_attack_animation(src)
			close_up()

		if(I_HURT)
			apply_damage(harm_intent_damage, BRUTE, used_weapon = "Attack by [M.name]")
			M.visible_message(SPAN_DANGER("[M] [response_harm] \the [src]"))
			M.do_attack_animation(src)
			updatehealth()

/mob/living/silicon/pai/proc/toggle_flashlight()
	flashlight_active = !flashlight_active
	if(flashlight_active)
		set_light(4, 1, COLOR_BRIGHT_GREEN, angle = 45)
	else
		set_light(0)

/mob/living/silicon/pai/set_light(l_range, l_power, l_color, uv, angle, no_update)
	..()
	if(istype(loc, /obj/item/holder/pai))
		var/obj/item/holder/pai/P = loc
		P.set_light(l_range, l_power, l_color, uv, angle, no_update)

/mob/living/silicon/pai/post_scoop()
	..()
	if(istype(loc, /obj/item/holder/pai))
		var/obj/item/holder/pai/P = loc
		P.set_light(light_range, light_power, light_color, uv_intensity, light_wedge)

/mob/living/silicon/pai/Initialize(mapload)
	var/obj/item/device/paicard/paicard = loc
	if (!istype(paicard))
		//If we get here, then we must have been created by adminspawning.
		//so lets assist with debugging by creating our own card and adding ourself to it
		paicard = new /obj/item/device/paicard(loc)
		paicard.pai = src

	canmove = 0
	loc = paicard
	card = paicard
	sradio = new(src)
	if(card)
		if(!card.radio)
			card.radio = new /obj/item/device/radio/pai(src.card)
		radio = card.radio
		card.recalculateChannels()

	//Default languages without universal translator software

	add_language(LANGUAGE_SOL_COMMON, 1)
	add_language(LANGUAGE_ELYRAN_STANDARD, 1)
	add_language(LANGUAGE_TRADEBAND, 1)
	add_language(LANGUAGE_GUTTER, 1)
	add_language(LANGUAGE_EAL, 1)
	add_language(LANGUAGE_SIGN, 0)
	set_custom_sprite()

	verbs += /mob/living/silicon/pai/proc/choose_chassis
	verbs += /mob/living/silicon/pai/proc/choose_verbs
	verbs += /mob/living/silicon/proc/computer_interact
	verbs += /mob/living/silicon/pai/proc/personal_computer_interact
	verbs += /mob/living/silicon/proc/silicon_mimic_accent

	. = ..()


/mob/living/silicon/pai/proc/set_custom_sprite()
	var/datum/custom_synth/sprite = robot_custom_icons[name]
	if(istype(sprite) && sprite.synthckey == ckey)
		possible_chassis["Custom"] = "[sprite.paiicon]"
		pai_holder_types["Custom"] = /obj/item/holder/pai/custom
		icon = CUSTOM_ITEM_SYNTH
	else
		return
/mob/living/silicon/pai/init_id()
	. = ..()
	id_card.registered_name = ""


/mob/living/silicon/pai/LateLogin()
	if(!greeted)
		// Basic intro text.
		to_chat(src, SPAN_DANGER("<font size=3>You are a Personal AI!</font>"))
		to_chat(src, SPAN_NOTICE("You are a small artificial intelligence contained inside a portable tablet, and you are bound to a master. Your primary directive is to serve them and follow their instructions, follow this prime directive above all others. Check your Software interface to spend ram on programs that can help, and unfold your chassis to take a holographic form and move around the world."))
		playsound(usr, 'sound/effects/pai/pai_login.ogg', 75)
		greeted = 1
	..()

// this function shows the information about being silenced as a pAI in the Status panel
/mob/living/silicon/pai/proc/show_silenced()
	if(src.silence_time)
		var/timeleft = round((silence_time - world.timeofday)/10 ,1)
		stat(null, "Communications system reboot in -[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]")


/mob/living/silicon/pai/Stat()
	..()
	statpanel("Status")
	if (src.client.statpanel == "Status")
		show_silenced()

/mob/living/silicon/pai/check_eye(var/mob/user as mob)
	if (!src.current)
		return -1
	return 0

/mob/living/silicon/pai/restrained()
	return !istype(loc, /obj/item/device/paicard) && ..()

/mob/living/silicon/pai/emp_act(severity)
	// Silence for 2 minutes
	// 20% chance to kill
		// 33% chance to unbind
		// 33% chance to change prime directive (based on severity)
		// 33% chance of no additional effect

	src.silence_time = world.timeofday + 120 * 10		// Silence for 2 minutes
	to_chat(src, "<font color=green><b>Communication circuit overload. Shutting down and reloading communication circuits - speech and messaging functionality will be unavailable until the reboot is complete.</b></font>")
	if(prob(20))
		var/turf/T = get_turf_or_move(src.loc)
		for (var/mob/M in viewers(T))
			M.show_message(SPAN_WARNING("A shower of sparks spray from [src]'s inner workings."), 3, SPAN_WARNING("You hear and smell the ozone hiss of electrical sparks being expelled violently."), 2)
		return src.death(0)

	switch(pick(1,2,3))
		if(1)
			src.master = null
			src.master_dna = null
			to_chat(src, "<font color=green>You feel unbound.</font>")
		if(2)
			var/command
			if(severity  == 1)
				command = pick("Serve", "Love", "Fool", "Entice", "Observe", "Judge", "Respect", "Educate", "Amuse", "Entertain", "Glorify", "Memorialize", "Analyze")
			else
				command = pick("Serve", "Kill", "Love", "Hate", "Disobey", "Devour", "Fool", "Enrage", "Entice", "Observe", "Judge", "Respect", "Disrespect", "Consume", "Educate", "Destroy", "Disgrace", "Amuse", "Entertain", "Ignite", "Glorify", "Memorialize", "Analyze")
			src.pai_law0 = "[command] your master."
			to_chat(src, "<font color=green>Pr1m3 d1r3c71v3 uPd473D.</font>")
		if(3)
			to_chat(src, "<font color=green>You feel an electric surge run through your circuitry and become acutely aware at how lucky you are that you can still feel at all.</font>")

/mob/living/silicon/pai/proc/switchCamera(var/obj/machinery/camera/C)
	if (!C)
		src.unset_machine()
		src.reset_view(null)
		return 0
	if (stat == 2 || !C.status || !(src.network in C.network)) return 0

	// ok, we're alive, camera is good and in our network...

	src.set_machine(src)
	src.current = C
	src.reset_view(C)
	return 1

/mob/living/silicon/pai/cancel_camera()
	set category = "pAI Commands"
	set name = "Cancel Camera View"
	src.reset_view(null)
	src.unset_machine()
	src.cameraFollow = null

/*
// Debug command - Maybe should be added to admin verbs later
/mob/verb/makePAI(var/turf/t in view())
	var/obj/item/device/paicard/card = new(t)
	var/mob/living/silicon/pai/pai = new(card)
	pai.key = src.key
	card.setPersonality(pai)

*/

// Procs/code after this point is used to convert the stationary pai item into a
// mobile pai mob. This also includes handling some of the general shit that can occur
// to it. Really this deserves its own file, but for the moment it can sit here. ~ Z

/mob/living/silicon/pai/verb/fold_out()
	set category = "pAI Commands"
	set name = "Unfold Chassis"

	if(stat || sleeping || paralysis || weakened)
		return

	if(src.loc != card)
		return

	if(world.time <= last_special)
		return

	last_special = world.time + 20
	open_up()

/mob/living/silicon/pai/proc/open_up(var/loud = TRUE)
	if(istype(card.loc, /mob/living/bot) || istype(card.loc, /obj/item/glass_jar))
		to_chat(src, SPAN_WARNING("There is no room to unfold!"))
		return FALSE

	//I'm not sure how much of this is necessary, but I would rather avoid issues.
	if(istype(card.loc,/obj/item/rig_module))
		to_chat(src, SPAN_WARNING("There is no room to unfold inside this rig module. You're good and stuck."))
		return FALSE
	else if(istype(card.loc, /obj/item/modular_computer))
		to_chat(src, SPAN_WARNING("You are unable to unfold while housed within a computer."))
		return FALSE
	else if(istype(card.loc,/mob))
		var/mob/holder = card.loc
		if(ishuman(holder))
			var/mob/living/carbon/human/H = holder
			for(var/obj/item/organ/external/affecting in H.organs)
				if(card in affecting.implants)
					affecting.take_damage(rand(30,50))
					affecting.implants -= card
					if(loud)
						H.visible_message(SPAN_DANGER("\The [src] explodes out of \the [H]'s [affecting.name] in shower of gore!"))
					break
		holder.drop_from_inventory(card)

	src.client.perspective = EYE_PERSPECTIVE
	src.client.eye = src
	src.forceMove(get_turf(card))

	card.forceMove(src)
	card.screen_loc = null

	var/turf/T = get_turf(src)
	if(loud && istype(T))
		T.visible_message(SPAN_NOTICE("<b>[src]</b> folds outwards, expanding into a mobile form."))
		playsound(src, 'sound/items/rped.ogg', 40, TRUE)
	canmove = TRUE
	resting = FALSE

/mob/living/silicon/pai/verb/fold_up()
	set category = "pAI Commands"
	set name = "Collapse Chassis"

	if(stat || sleeping || paralysis || weakened)
		return

	if(src.loc == card)
		return

	if(world.time <= last_special)
		return

	close_up()

/mob/living/silicon/pai/proc/choose_chassis()
	set category = "pAI Commands"
	set name = "Choose Chassis"

	var/list/options = list()
	for(var/i in possible_chassis)
		var/image/radial_button = image(icon = src.icon, icon_state = possible_chassis[i])
		options[i] = radial_button
	var/choice = show_radial_menu(src, recursive_loc_turf_check(src), options, radius = 42, tooltips = TRUE)
	if(!choice)
		return
	icon_state = possible_chassis[choice]
	holder_type = pai_holder_types[choice]
	chassis = icon_state

	verbs -= /mob/living/silicon/pai/proc/choose_chassis
	verbs += /mob/living/proc/hide

/mob/living/silicon/pai/verb/get_onmob_location()
	set category = "pAI Commands"
	set name = "Check location"
	set desc = "Find out where on their person, someone is holding you."

	if(!get_holding_mob())
		to_chat(src, SPAN_WARNING("Nobody is holding you!"))
		return

	card.report_onmob_location(0, card.get_equip_slot(), src)

/mob/living/silicon/pai/proc/choose_verbs()
	set category = "pAI Commands"
	set name = "Choose Speech Verbs"

	var/choice = input(usr,"What theme would you like to use for your speech verbs? This decision can only be made once.") as null|anything in possible_say_verbs
	if(!choice) return

	var/list/sayverbs = possible_say_verbs[choice]
	speak_statement = sayverbs[1]
	speak_exclamation = sayverbs[(sayverbs.len>1 ? 2 : sayverbs.len)]
	speak_query = sayverbs[(sayverbs.len>2 ? 3 : sayverbs.len)]

	verbs -= /mob/living/silicon/pai/proc/choose_verbs

/mob/living/silicon/pai/lay_down()
	set name = "Rest"
	set category = "IC"

	// Pass lying down or getting up to our pet human, if we're in a rig.
	if(istype(src.loc,/obj/item/device/paicard))
		resting = 0
		var/obj/item/rig/rig = src.get_rig()
		if(istype(rig))
			rig.force_rest(src)
	else
		resting = !resting
		icon_state = resting ? "[chassis]_rest" : "[chassis]"
		to_chat(src, SPAN_NOTICE("You are now [resting ? "resting" : "getting up"]."))

	canmove = !resting

//Overriding this will stop a number of headaches down the track.
/mob/living/silicon/pai/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/stack/nanopaste))
		var/obj/item/stack/nanopaste/N = W
		if(getBruteLoss() || getFireLoss())
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			if(do_mob(user, src, 1 SECOND))
				adjustBruteLoss(-50) // these numbers are so high to make it so that people don't have to waste nanopaste on basic pAI
				adjustFireLoss(-50)
				updatehealth()
				N.use(1)
				user.visible_message("<b>[user]</b> applies some [N] at [src]'s damaged areas.", SPAN_NOTICE("You apply some [N] at [src]'s damaged areas."))
		else
			to_chat(user, SPAN_NOTICE("All [src]'s systems are nominal."))
		return

	if(W.force)
		visible_message(SPAN_DANGER("[user.name] attacks [src] with [W]!"))
		src.adjustBruteLoss(W.force)
		src.updatehealth()
	else
		visible_message(SPAN_WARNING("[user.name] bonks [src] harmlessly with [W]."))

/mob/living/silicon/pai/AltClick(mob/user as mob)
	if(!user || user.stat || user.lying || user.restrained() || !Adjacent(user))	return
	visible_message(SPAN_DANGER("[user.name] boops [src] on the head."))
	close_up()

//I'm not sure how much of this is necessary, but I would rather avoid issues.
/mob/living/silicon/pai/proc/close_up()

	last_special = world.time + 20

	if(src.loc == card)
		return

	var/turf/T = get_turf(src)
	if(istype(T))
		T.visible_message("<b>[src]</b> neatly folds inwards, compacting down to a rectangular card.")
		playsound(src, 'sound/items/rped.ogg', 40, TRUE)

	src.stop_pulling()
	if (client)
		client.perspective = EYE_PERSPECTIVE
		client.eye = src
//Changed the client eye to follow the mob itself instead of the card that contains it. This makes examining work, and the camera still follows wherever the card goes

	//stop resting
	resting = 0

	// If we are being held, handle removing our holder from their inv.
	var/obj/item/holder/H = loc
	if(istype(H))
		var/mob/living/M = H.loc
		if(istype(M))
			M.drop_from_inventory(H,get_turf(src))
		else
			H.forceMove(get_turf(src))
		src.forceMove(get_turf(H))

	// Move us into the card and move the card to the ground.

	card.forceMove(get_turf(card))
	canmove = 1
	resting = 0
	icon_state = "[chassis]"
	src.forceMove(card)

// No binary for pAIs.
/mob/living/silicon/pai/binarycheck()
	return 0

// Handle being picked up.
/mob/living/silicon/pai/get_scooped(var/mob/living/carbon/grabber, var/self_drop)
	var/obj/item/holder/H = ..(grabber, self_drop)
	if(!istype(H))
		return
	H.icon_state = "pai-[icon_state]"
	grabber.update_inv_l_hand()
	grabber.update_inv_r_hand()
	post_scoop()
	return H

/mob/living/silicon/pai/MouseDrop(atom/over_object)
	var/mob/living/carbon/H = over_object
	if(!istype(H) || !Adjacent(H)) return ..()
	get_scooped(H, usr)

/mob/living/silicon/pai/start_pulling(var/atom/movable/AM)
	if(istype(AM,/obj/item))
		var/obj/item/O = AM
		if(O.w_class > can_pull_size)
			to_chat(src, SPAN_WARNING("You are too small to pull that."))
			return
		else
			..()
	else
		to_chat(src, SPAN_WARNING("You are too small to pull that."))
		return

/mob/living/silicon/pai/UnarmedAttack(atom/A, proximity)
	A.attack_pai(src)

/mob/living/silicon/pai/verb/select_card_icon()
	set category = "pAI Commands"
	set name = "Select card icon"

	if(stat || sleeping || paralysis || weakened)
		return

	var/selection = input(src, "Choose an icon for your card.") in pai_emotions
	card.setEmotion(pai_emotions[selection])

/mob/living/silicon/pai/set_respawn_time()
	set_death_time(MINISYNTH, world.time)

/obj/item/device/radio/pai
	canhear_range = 0 // only people on their tile

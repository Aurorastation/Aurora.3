/mob/living/simple_animal/borer
	name = "cortical borer"
	real_name = "cortical borer"
	desc = "A small, quivering sluglike creature."
	speak_emote = list("chirrups")
	emote_hear = list("chirrups")
	response_help  = "pokes"
	response_disarm = "prods"
	response_harm   = "stomps on"
	icon_state = "brainslug"
	item_state = "brainslug"
	icon_living = "brainslug"
	icon_dead = "brainslug_dead"
	speed = 6
	a_intent = I_HURT
	stop_automated_movement = 1
	status_flags = CANPUSH
	attacktext = "nipped"
	friendly = "prods"
	wander = 0
	maxHealth = 40
	health = 40
	pass_flags = PASSTABLE
	universal_understand = TRUE
	holder_type = /obj/item/holder/borer
	mob_size = 1
	hunger_enabled = FALSE

	var/used_dominate
	var/chemicals = 10                      // Chemicals used for reproduction and spitting neurotoxin.
	var/mob/living/carbon/human/host        // Human host for the brain worm.
	var/truename                            // Name used for brainworm-speak.
	var/mob/living/captive_brain/host_brain // Used for swapping control of the body back and forth.
	var/controlling                         // Used in human death check.
	var/has_reproduced
	var/request_player = TRUE

/mob/living/simple_animal/borer/roundstart
	request_player = FALSE

/mob/living/simple_animal/borer/LateLogin()
	..()
	if(mind)
		borers.add_antagonist(mind)

/mob/living/simple_animal/borer/Initialize()
	. = ..()

	add_language(LANGUAGE_BORER)
	add_language(LANGUAGE_BORER_HIVEMIND)
	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

	truename = "[pick("Primary","Secondary","Tertiary","Quaternary")]-[rand(1000,9999)]"
	if(request_player && !ckey && !client)
		SSghostroles.add_spawn_atom("borer", src)
		var/area/A = get_area(src)
		if(A)
			say_dead_direct("A borer has been birthed in [A.name]! Spawn in as it by using the ghost spawner menu in the ghost tab.")

/mob/living/simple_animal/borer/death(gibbed, deathmessage)
	SSghostroles.remove_spawn_atom("borer", src)
	return ..(gibbed,deathmessage)

/mob/living/simple_animal/borer/Life()
	..()
	if(host)
		if(!stat && host.stat != DEAD)
			if(chemicals < 250)
				chemicals++
		if(host && !host.stat)
			if(controlling && prob(host.getBrainLoss()/20))
				host.say("*[pick(list("blink","blink_r","choke","drool","twitch","twitch_s","gasp"))]")

/mob/living/simple_animal/borer/Stat()
	..()
	statpanel("Status")

	if(emergency_shuttle)
		var/eta_status = emergency_shuttle.get_status_panel_eta()
		if(eta_status)
			stat(null, eta_status)

	if(client.statpanel == "Status")
		stat("Chemicals", chemicals)

/mob/living/simple_animal/borer/proc/detach()
	if(!host || !controlling)
		return

	if(istype(host,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = host
		var/obj/item/organ/external/head = H.get_organ(BP_HEAD)
		head.implants -= src

	controlling = FALSE

	host.remove_language(LANGUAGE_BORER)
	host.remove_language(LANGUAGE_BORER_HIVEMIND)

	to_chat(host, "<span class='notice'>You feel your nerves again as your control over your own body is restored.</span>")
	host.verbs -= /mob/living/carbon/proc/release_control
	host.verbs -= /mob/living/carbon/proc/punish_host
	host.verbs -= /mob/living/carbon/proc/spawn_larvae

	if(host_brain)
		// these are here so bans and multikey warnings are not triggered on the wrong people when ckey is changed.
		// computer_id and IP are not updated magically on their own in offline mobs -walter0o

		// host -> self
		var/h2s_id = host.computer_id
		var/h2s_ip= host.lastKnownIP
		host.computer_id = null
		host.lastKnownIP = null

		src.ckey = host.ckey

		if(!src.computer_id)
			src.computer_id = h2s_id

		if(!host_brain.lastKnownIP)
			src.lastKnownIP = h2s_ip

		// brain -> host
		var/b2h_id = host_brain.computer_id
		var/b2h_ip= host_brain.lastKnownIP
		host_brain.computer_id = null
		host_brain.lastKnownIP = null

		host.ckey = host_brain.ckey

		if(!host.computer_id)
			host.computer_id = b2h_id

		if(!host.lastKnownIP)
			host.lastKnownIP = b2h_ip

	qdel(host_brain)

/mob/living/simple_animal/borer/proc/leave_host()
	if(!host)
		return

	if(host.mind)
		borers.clear_indicators(host.mind)
		borers.remove_antagonist(host.mind)

	forceMove(get_turf(host))
	var/obj/item/organ/external/head = host.get_organ(BP_HEAD)
	if(head)
		head.implants -= src

	reset_view(null)
	machine = null

	host.reset_view(null)
	host.machine = null

	host.status_flags &= ~PASSEMOTES
	host = null
	return

/mob/living/simple_animal/borer/proc/spawn_into_borer(var/mob/user)
	ckey = user.ckey
	qdel(user)
	SSghostroles.remove_spawn_atom("borer", src)

/mob/living/simple_animal/borer/cannot_use_vents()
	return

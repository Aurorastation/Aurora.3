/mob/living/simple_animal/borer
	name = "cortical borer"
	real_name = "cortical borer"
	desc = "A small, quivering sluglike creature."
	speak_emote = list("chirrups")
	emote_hear = list("chirrups")
	organ_names = list("head", "rear segment", "central segment")
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
	var/datum/progressbar/ability_bar
	var/ability_start_time = 0
	var/atom/movable/screen/borer/chemicals/chem_hud
	var/chemicals = 10                      // Chemicals used for reproduction and spitting neurotoxin.
	var/mob/living/carbon/human/host        // Human host for the brain worm.
	var/truename                            // Name used for brainworm-speak.
	var/mob/living/captive_brain/host_brain // Used for swapping control of the body back and forth.
	var/controlling                         // Used in human death check.
	var/list/static/controlling_emotes = list("blink","blink_r","choke","drool","twitch","twitch_v","gasp")
	var/has_reproduced
	var/request_player = TRUE

/mob/living/simple_animal/borer/roundstart
	request_player = FALSE

/mob/living/simple_animal/borer/LateLogin()
	..()
	if(mind)
		GLOB.borers.add_antagonist_mind(mind, 1, GLOB.borers.role_text, GLOB.borers.welcome_text)
	if(client)
		client.init_verbs()
		if(host)
			client.screen += host.healths

/mob/living/simple_animal/borer/Initialize()
	. = ..()

	add_language(LANGUAGE_BORER)
	add_language(LANGUAGE_BORER_HIVEMIND)
	add_verb(src, /mob/living/proc/ventcrawl)
	add_verb(src, /mob/living/proc/hide)
	var/number = rand(1000,9999)
	truename = "[pick("Primary","Secondary","Tertiary","Quaternary")]-[number]"
	if(request_player && !ckey && !client)
		SSghostroles.add_spawn_atom("borer", src)
	name = initial(name) + " ([number])"
	real_name = name

/mob/living/simple_animal/borer/Destroy()
	QDEL_NULL(ability_bar)
	QDEL_NULL(host_brain)
	return ..()

/mob/living/simple_animal/borer/death(gibbed, deathmessage)
	SSghostroles.remove_spawn_atom("borer", src)
	return ..(gibbed,deathmessage)

/mob/living/simple_animal/borer/can_name(var/mob/living/M)
	return FALSE

/mob/living/simple_animal/borer/Life(seconds_per_tick, times_fired)
	if(host)
		if(!stat && host.stat != DEAD)
			if(chemicals < 250)
				chemicals++
		if(!host.stat && controlling && prob(2))
			host.emote(pick(controlling_emotes))
	..()
	if(!QDELETED(ability_bar))
		var/borer_progress = world.time - ability_start_time
		borer_progress = clamp(borer_progress, 0, ability_bar.goal)
		ability_bar.update(borer_progress)

		if(borer_progress == ability_bar.goal)
			ability_bar.end_progress()

/mob/living/simple_animal/borer/proc/start_ability(var/atom/target, var/time)
	if(!QDELETED(ability_bar))
		return FALSE
	ability_bar = new /datum/progressbar(src, time, target)
	ability_start_time = world.time
	ability_bar.update(0)
	return TRUE

/mob/living/simple_animal/borer/handle_regular_hud_updates()
	. = ..()
	if(chem_hud)
		chem_hud.maptext = SMALL_FONTS(7, chemicals)

/mob/living/simple_animal/borer/get_status_tab_items()
	. = ..()
	. += "Chemicals: [chemicals]"

/mob/living/simple_animal/borer/proc/detach()
	if(!host || !controlling)
		return

	if(ability_bar)
		QDEL_NULL(ability_bar)

	controlling = FALSE

	host.remove_language(LANGUAGE_BORER)
	host.remove_language(LANGUAGE_BORER_HIVEMIND)

	remove_verb(host, /mob/living/carbon/proc/release_control)
	remove_verb(host, /mob/living/carbon/proc/punish_host)
	remove_verb(host, /mob/living/carbon/proc/spawn_larvae)

	if(host_brain)
		to_chat(host_brain, FONT_LARGE(SPAN_NOTICE("You feel your nerves again as your control over your own body is restored.")))
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
		GLOB.borers.clear_indicators(host.mind)
		GLOB.borers.remove_antagonist(host.mind)

	forceMove(get_turf(host))
	var/obj/item/organ/external/head = host.get_organ(BP_HEAD)
	if(head)
		head.implants -= src

	reset_view(null)
	machine = null

	host.reset_view(null)
	host.machine = null

	host.status_flags &= ~PASSEMOTES
	if(client)
		client.screen -= host.healths
	host = null
	return

/mob/living/simple_animal/borer/cannot_use_vents()
	return

/mob/living/simple_animal/borer/UnarmedAttack(atom/A, proximity)
	if(iscarbon(A))
		var/mob/living/carbon/C = A
		if(C.lying || C.weakened)
			do_infest(C)
		else
			do_paralyze(C)
		return
	return ..()

/mob/living/simple_animal/borer/RangedAttack(atom/A, params)
	if(iscarbon(A) && get_dist(src, A) <= 2)
		var/mob/living/carbon/C = A
		do_paralyze(C)
		return
	return ..()

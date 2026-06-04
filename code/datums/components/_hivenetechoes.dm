/datum/component/HiveEchoes

	/// The next real life time a broadcast echo will generate.
	var/next_broadcastEcho = 0
	var/topic
	/// The next real life time a projection echo will generate.
	var/next_projectionEcho = 0

	/**
	 * The typechecked owner of this component.
	 * This component only works on humanoid mobs, and will self-delete if it's parent isn't a humanoid.
	 **/
	var/mob/living/carbon/human/owner

/datum/component/HiveEchoes/Initialize()
	. = ..()
	if (!parent)
		return

	if (!ishuman(parent))
		qdel(src)
		stack_trace("Hivenet Echoes Component was added to [parent.type] but is not of type /mob/living/carbon/human. Hivenet echoes can only work on humanoids.")
		return

	owner = parent

	// Check during component init if we're in a sector that blocks hivenet echoes, and if so, skip processing init.
	if(!SSatlas.current_sector.hivenet_echoes)
		if((SSatlas.current_sector.name in list(SECTOR_LEMURIAN_SEA, SECTOR_LEMURIAN_SEA_FAR)))
			to_chat(parent, SPAN_CULT("The Fog cuts you off from the greater Hivenet. Without its echoes, you feel deeply dreadful."))
		else
			to_chat(parent, SPAN_WARNING("The faint echoes of the greater Hivenet fade away. Without them, you feel low in company."))
		return

	// Setup the first time the echoes will begin playing.
	next_broadcastEcho = world.time + rand(180, 300) SECONDS
	next_projectionEcho = world.time + rand(240, 480) SECONDS

	// Finally start the clock.
	START_PROCESSING(SSprocessing, src)

/datum/component/HiveEchoes/Destroy()
	owner = null
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/datum/component/HiveEchoes/process(seconds_per_tick)
	if(owner.stat != CONSCIOUS)
		return

	if(world.time >= next_broadcastEcho && !topic) // topic has to null itself, or an extra broadcast generates for w/e reason
		topic = "[pick(100;"gossip", 30;"happy", 15;"tense")]"
		GetBroadcastEcho(topic)
		topic = null
		next_broadcastEcho = world.time + rand(180, 300) SECONDS
	if(world.time >= next_projectionEcho)
		GetProjectionEcho()
		next_projectionEcho = world.time + rand(240, 480) SECONDS

/datum/component/HiveEchoes/proc/GetBroadcastEcho(topic)
	if (!owner.internal_organs_by_name[BP_NEURAL_SOCKET] || within_jamming_range(owner))
		return

	var/list/echo_starter = file2list("config/hivenet_echoes/starter_[topic].txt")
	var/list/echo_response = file2list("config/hivenet_echoes/response_[topic].txt")
	var/joined = pick(100;0, 60;1)

	if(!length(echo_starter) || !length(echo_response))
		STOP_PROCESSING(SSprocessing, src)
		return
	if(joined && topic == "gossip")
		to_chat(owner, "<i><span class='game say'>Hivenet, <span class='name'>a [pick("Faint", "Distant", "Fading", "Fleeting", "Drifting", "Low", "Weak", "Far", "Pinging", "Whispering")] Echo</span> broadcasts, <span class='vaurca'>\"[pick(echo_starter)]" + " " + "[pick(echo_response)]\"</span></span></i>")
	else
		to_chat(owner, "<i><span class='game say'>Hivenet, <span class='name'>a [pick("Faint", "Distant", "Fading", "Fleeting", "Drifting", "Low", "Weak", "Far", "Pinging", "Whispering")] Echo</span> broadcasts, <span class='vaurca'>\"[pick(echo_starter)]\"</span></span></i>") //this works
		sleep(rand(5,15))
		to_chat(owner, "<i><span class='game say'>Hivenet, <span class='name'>a [pick("Faint", "Distant", "Fading", "Fleeting", "Drifting", "Low", "Weak", "Far", "Pinging", "Whispering")] Echo</span> broadcasts, <span class='vaurca'>\"[pick(echo_response)]\"</span></span></i>")

/datum/component/HiveEchoes/proc/GetProjectionEcho()
	if(!owner.internal_organs_by_name[BP_NEURAL_SOCKET] || within_jamming_range(owner))
		return

	var/list/echo_projections = file2list("config/hivenet_echoes/echo_projections.txt")
	to_chat(owner, "<i><span class='game say'>Hivenet, <span class='name'>a [pick("Faint", "Distant", "Fading", "Fleeting", "Drifting", "Low", "Weak", "Far", "Pinging", "Whispering")] Echo</span> projects <span class='vaurca'>[pick(echo_projections)]</span></span></i>")

//Serverside admin toggle
/datum/admins/proc/ToggleEchoes()
	set name = "Toggle Hivenet Echoes"
	set category = "Special Verbs"
	set desc = "Toggle if Vaurcae can hear faint echoes (fluff) of the greater Hivenet. They will notice."

	if(!check_rights(R_ADMIN))
		return

	if(SSatlas.current_sector.hivenet_echoes)
		SSatlas.current_sector.hivenet_echoes = FALSE
		to_chat(usr, SPAN_INFO("Vaurcae have been cut off from echoes (fluff) of the greater Hivenet."))
		for(var/mob/player as anything in GLOB.player_list)
			var/datum/component/HiveEchoes/echoesComp = player.GetComponent(/datum/component/HiveEchoes)
			if (!echoesComp)
				continue

			to_chat(player, SPAN_CULT("The absence of echoes makes you feel dreadful."))
			STOP_PROCESSING(SSprocessing, echoesComp)
		return

	SSatlas.current_sector.hivenet_echoes = TRUE
	to_chat(usr, SPAN_INFO("Vaurcae will receive echoes (fluff) of the greater Hivenet."))
	for(var/mob/player as anything in GLOB.player_list)
		var/datum/component/HiveEchoes/echoesComp = player.GetComponent(/datum/component/HiveEchoes)
		if (!echoesComp)
			continue

		to_chat(player, SPAN_NOTICE("You feel echoes of the greater Hivenet drift back in."))
		START_PROCESSING(SSprocessing, echoesComp)

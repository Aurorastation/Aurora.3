/// Echoes of the greater Hivenet exclusively received by Vaurcae. Has huge variety, so it can trigger a lot w/o boring players.
/datum/component/HiveEchoes

	/// Next world.time a broadcast echo will generate. Two get sent normally, but sometimes it can be one joined message for variety.
	var/next_broadcastEcho = 0
	/// Next world.time a projection echo will generate..
	var/next_projectionEcho = 0
	/// A saved starter broadcast string. Sent as a global signal arg to ensure the exact same echoes for all Vaurcae.
	var/starter_string
	/// A saved response broadcast string. Sent as a global signal arg to ensure the exact same echoes for all Vaurcae.
	var/response_string
	/// A saved projection string. Sent as a global signal arg to ensure the exact same echoes for all Vaurcae.
	var/projection_string

	/**
	 * The typechecked owner of this component.
	 * This component only works on humanoid mobs, and will self-delete if it's parent isn't a humanoid.
	 **/
	var/mob/living/carbon/human/owner

#define ECHO_ADJECTIVES list("Faint", "Distant", "Fading", "Fleeting", "Drifting", "Low", "Weak", "Far", "Pinging", "Whispering")
#define HIVENET_MESSAGE(speaker, verb, msg) "<i><span class='game say'>Hivenet, <span class='name'>[speaker]</span> [verb] <span class='vaurca'>[msg]</span></span></i>"

/datum/component/HiveEchoes/Initialize()
	. = ..()
	if (!parent)
		return

	if (!ishuman(parent))
		qdel(src)
		stack_trace("Hivenet Echoes Component was added to [parent.type] but is not of type /mob/living/carbon/human. Hivenet echoes can only work on humanoids.")
		return

	owner = parent
	// Setup the first time the echoes will begin playing.
	next_broadcastEcho = world.time + rand(18, 30) SECONDS
	next_projectionEcho = world.time + rand(240, 480) SECONDS
	RegisterSignal(SSdcs, COMSIG_GLOB_HIVENET_ECHO_TRANSMISSION, PROC_REF(setup_echo))
	// Finally start the clock.
	START_PROCESSING(SSprocessing, src)

/datum/component/HiveEchoes/Destroy()
	owner = null
	STOP_PROCESSING(SSprocessing, src)
	UnregisterSignal(SSdcs, COMSIG_GLOB_HIVENET_ECHO_TRANSMISSION)
	return ..()

/datum/component/HiveEchoes/process(seconds_per_tick)
	if(!SSatlas.current_sector.hivenet_echoes)
		if(is_lemurian_sea_sector())
			to_chat(parent, SPAN_CULT("The Fog cuts you off from the greater Hivenet. Without its echoes, you feel deeply dreadful."))
		else
			to_chat(parent, SPAN_WARNING("The faint echoes of the greater Hivenet fade away. Without them, you feel low in company."))
		STOP_PROCESSING(SSprocessing, src)
		return

	if(owner.stat != CONSCIOUS)
		return

	// To avoid making a new processing subsystem for one minor mechanic, this component functions by sending a global signal
	// that only gets picked up by other instances of the component, which ensures all Vaurcae get the same Hivenet echoes.
	if(world.time >= next_broadcastEcho)
		var/topic = "[pick(100;"gossip", 30;"happy", 15;"tense")]"
		var/isjoined = topic == "gossip" ? pick(100;FALSE, 60; TRUE) : FALSE // Only gossip is designed for joined broadcasts
		GetBroadcastEcho(topic)
		var/list/broadcast_data = list(
			"topic" = topic, "joined" = isjoined, "starter_string" = starter_string, "response_string" = response_string,
			"next_broadcast" = world.time + rand(18, 30) SECONDS)
		SEND_GLOBAL_SIGNAL(COMSIG_GLOB_HIVENET_ECHO_TRANSMISSION, broadcast_data)

	if(world.time >= next_projectionEcho)
		GetProjectionEcho()
		var/list/projection_data = list(
			"projection_string" = projection_string, "next_projection" = world.time + rand(240, 480) SECONDS)
		SEND_GLOBAL_SIGNAL(COMSIG_GLOB_HIVENET_ECHO_TRANSMISSION, projection_data)

/datum/component/HiveEchoes/proc/setup_echo(SS_dcs, list/echo_data)
	SIGNAL_HANDLER

	if(echo_data["next_broadcast"]) // This synchronizes echo timing to be the same for all Vaurcae
		next_broadcastEcho = echo_data["next_broadcast"]
	else if(echo_data["next_projection"])
		next_projectionEcho = echo_data["next_projection"]

	receive_echo(echo_data)

/datum/component/HiveEchoes/proc/receive_echo(list/echo_data)
	if(!owner.internal_organs_by_name[BP_NEURAL_SOCKET] || within_jamming_range(owner))
		return

	if(echo_data["joined"]) // Check for sending a singular, joined gossip broadcast echo
		to_chat(owner, HIVENET_MESSAGE("a [pick(ECHO_ADJECTIVES)] Echo", "broadcasts,", "\"[echo_data["starter_string"]] [echo_data["response_string"]]\""))

	else if(echo_data["topic"] && !echo_data["joined"]) // Otherwise, send the standard two broadcast echoes
		to_chat(owner, HIVENET_MESSAGE("a [pick(ECHO_ADJECTIVES)] Echo", "broadcasts,", "\"[echo_data["starter_string"]]\""))
		spawn(rand(0.5 SECOND, 1.5 SECONDS))
			to_chat(owner, HIVENET_MESSAGE("a [pick(ECHO_ADJECTIVES)] Echo", "broadcasts,", "\"[echo_data["response_string"]]\""))

	else if(echo_data["projection_string"]) // Otherwise, send a single projection echo
		to_chat(owner, HIVENET_MESSAGE("a [pick(ECHO_ADJECTIVES)] Echo", "projects", "[echo_data["projection_string"]]"))

/datum/component/HiveEchoes/proc/GetBroadcastEcho(topic)
	if (!owner.internal_organs_by_name[BP_NEURAL_SOCKET] || within_jamming_range(owner))
		return

	var/list/echo_starter = file2list("config/hivenet_echoes/starter_[topic].txt")
	var/list/echo_response = file2list("config/hivenet_echoes/response_[topic].txt")

	if(!length(echo_starter) || !length(echo_response))
		STOP_PROCESSING(SSprocessing, src)
		return
	starter_string = "[pick(echo_starter)]"
	response_string = "[pick(echo_response)]"

/datum/component/HiveEchoes/proc/GetProjectionEcho()
	if(!owner.internal_organs_by_name[BP_NEURAL_SOCKET] || within_jamming_range(owner))
		return

	var/list/echo_projections = file2list("config/hivenet_echoes/echo_projections.txt")
	projection_string = "[pick(echo_projections)]"

//Serverside admin toggle
/datum/admins/proc/ToggleEchoes()
	set name = "Toggle Hivenet Echoes"
	set category = "Special Verbs"
	set desc = "Toggle if Vaurcae can hear faint echoes (fluff) of the greater Hivenet. They will notice."

	if(!check_rights(R_ADMIN))
		return

	if(is_lemurian_sea_sector())
		SSatlas.current_sector.hivenet_echoes = FALSE
		to_chat(usr, SPAN_WARNING("The Fog prevents Hivenet Echoes from being restored in the Lemurian Sea."))
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

#undef ECHO_ADJECTIVES
#undef HIVENET_MESSAGE

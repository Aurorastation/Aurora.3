// Echoes of the greater Hivenet exclusively received by Vaurcae. Has huge variety, so it can trigger a lot w/o boring players.
/datum/element/HiveEchoes
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY
	/// Next world.time a broadcast echo will generate. Two get sent normally, but sometimes it can be one joined message for variety.
	var/next_broadcastEcho = 0
	/// Next world.time a sensory projection echo will generate.
	var/next_projectionEcho = 0
	/// A saved starter broadcast echo string.
	var/starter_string
	/// A saved response broadcast echo string.
	var/response_string
	/// A saved projection echo string.
	var/projection_string
	/// The targets that can receive echoes...so, literally all vaurcae
	var/list/targets = list()

#define ECHO_ADJECTIVES list("Faint", "Distant", "Fading", "Fleeting", "Drifting", "Low", "Weak", "Far", "Pinging", "Whispering")
#define HIVENET_MESSAGE(speaker, verb, msg) "<i><span class='game say'>Hivenet, <span class='name'>[speaker]</span> [verb] <span class='vaurca'>[msg]</span></span></i>"

/datum/element/HiveEchoes/Attach(datum/target)
	. = ..()
	if(!ishuman(target))
		return ELEMENT_INCOMPATIBLE
	targets += target
	if(SSatlas.current_sector.hivenet_echoes)
		// Start echo timers if they're not already set.
		next_projectionEcho = world.time > next_projectionEcho ? world.time + rand(240, 480) SECONDS : next_projectionEcho
		next_broadcastEcho = world.time > next_broadcastEcho || world.time ? world.time + rand(180, 300) SECONDS : next_broadcastEcho
		START_PROCESSING(SSprocessing, src)

/datum/element/HiveEchoes/Detach(datum/target)
	targets -= target
	return ..()

/datum/element/HiveEchoes/process(seconds_per_tick)
	if(!SSatlas.current_sector.hivenet_echoes)
		var/feedback = SPAN_WARNING("The faint echoes of the greater Hivenet fade away. Without them, you feel low in company...")
		if(is_lemurian_sea_sector())
			feedback = SPAN_CULT("The Fog cuts you off the greater Hivenet. Without its echoes, you feel deeply dreadful...")

		for(var/mob/living/carbon/human/H in targets)
			if(!H.internal_organs_by_name[BP_NEURAL_SOCKET] || within_jamming_range(H))
				continue
			to_chat(H, feedback)
		STOP_PROCESSING(SSprocessing, src)
		return

	if(world.time >= next_broadcastEcho)
		var/topic = "[pick(100;"gossip", 30;"happy", 15;"tense")]"
		GetBroadcastEcho(topic)
		next_broadcastEcho = world.time + rand(180, 300) SECONDS

	if(world.time >= next_projectionEcho)
		GetProjectionEcho()
		next_projectionEcho = world.time + rand(240, 480) SECONDS

/datum/element/HiveEchoes/proc/GetBroadcastEcho(topic)
	var/list/echo_starter = file2list("config/hivenet_echoes/starter_[topic].txt")
	var/list/echo_response = file2list("config/hivenet_echoes/response_[topic].txt")
	var/joined = topic == "gossip" ? pick(100;FALSE, 60;TRUE) : FALSE // Only gossip is designed for joined broadcasts
	if(!length(echo_starter) || !length(echo_response))
		STOP_PROCESSING(SSprocessing, src)
		return
	starter_string = "[pick(echo_starter)]"
	response_string = "[pick(echo_response)]"
	var/list/echo_adj = list(pick(ECHO_ADJECTIVES), pick(ECHO_ADJECTIVES)) // consistent adjectives for everyone, damn it!
	if(!joined)
		for(var/mob/living/carbon/human/H in targets)
			if(H.stat != CONSCIOUS || !H.internal_organs_by_name[BP_NEURAL_SOCKET] || within_jamming_range(H))
				continue
			to_chat(H, HIVENET_MESSAGE("a [echo_adj[1]] Echo", "broadcasts,", "\"[starter_string]\""))
			spawn(rand(0.5 SECOND, 1 SECONDS))
				to_chat(H, HIVENET_MESSAGE("a [echo_adj[2]] Echo", "broadcasts", "\"[response_string]\""))
	else
		for(var/mob/living/carbon/human/vaurca in targets)
			if(vaurca.stat != CONSCIOUS || !vaurca.internal_organs_by_name[BP_NEURAL_SOCKET] || within_jamming_range(vaurca))
				continue
			to_chat(vaurca, HIVENET_MESSAGE("a [echo_adj[1]]", "broadcasts,", "\"[starter_string] [response_string]\""))

/datum/element/HiveEchoes/proc/GetProjectionEcho()
	var/list/echo_projections = file2list("config/hivenet_echoes/echo_projections.txt")
	projection_string = "[pick(echo_projections)]"
	var/echo_adj = pick(ECHO_ADJECTIVES)
	for(var/mob/living/carbon/human/H in targets)
		if(H.stat != CONSCIOUS || !H.internal_organs_by_name[BP_NEURAL_SOCKET] || within_jamming_range(H))
			continue
		to_chat(H, HIVENET_MESSAGE("[echo_adj]", "projects", "[projection_string]"))

//Serverside admin toggle
/datum/admins/proc/ToggleEchoes()
	set name = "Toggle Hivenet Echoes"
	set category = "Special Verbs"
	set desc = "Toggle if Vaurcae can hear faint echoes (fluff) of the greater Hivenet. They will notice."

	if(!check_rights(R_ADMIN))
		return

	var/datum/element/HiveEchoes/echoes = SSdcs.elements_by_type[/datum/element/HiveEchoes]
	if(is_lemurian_sea_sector())
		SSatlas.current_sector.hivenet_echoes = FALSE
		to_chat(usr, SPAN_WARNING("The Fog prevents Hivenet Echoes from being restored in the Lemurian Sea."))
		return

	if(SSatlas.current_sector.hivenet_echoes)
		SSatlas.current_sector.hivenet_echoes = FALSE
		to_chat(usr, SPAN_INFO("Vaurcae have been cut off from echoes (fluff) of the greater Hivenet."))
		for(var/mob/living/carbon/human/H in echoes?.targets)
			if(!H.internal_organs_by_name[BP_NEURAL_SOCKET] || within_jamming_range(H))
				continue
			to_chat(H, SPAN_CULT("The absence of echoes makes you feel dreadful."))

		if(echoes)
			STOP_PROCESSING(SSprocessing, echoes) // should be redundant, but why not sanity check
		return

	SSatlas.current_sector.hivenet_echoes = TRUE
	to_chat(usr, SPAN_INFO("Vaurcae will receive echoes (fluff) of the greater Hivenet."))
	for(var/mob/living/carbon/human/player in echoes?.targets)
		if(!player.internal_organs_by_name[BP_NEURAL_SOCKET] || within_jamming_range(player))
			continue
		to_chat(player, SPAN_NOTICE("You feel echoes of the greater Hivenet drift back in."))

		if(echoes)
			START_PROCESSING(SSprocessing, echoes) // meanwhile, this is necessary

#undef ECHO_ADJECTIVES
#undef HIVENET_MESSAGE

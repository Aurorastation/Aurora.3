/datum/component/HiveEchoes
var/hivenet_note = FALSE
var/last_broadcastEcho = 0
var/last_projectionEcho = 0
///////
/*Vaurcae normally always hear faint echoes of distant Hivenet transmissions, this simulates the greater Hivenet.
The template is two echoed broadcasts to simulate two vaurcae, "starter" and "response". The category at the end always matches.
Gossip is a bit different because it can also be a single broadcast, implying only one vaurca, for variety

ONLY VAURCAE can catch echoes, BUT NBT2 could allow for partial-catching by non-Vaurcae from tech progression. In that future,
Non-Vaurcae should catch broadcasts as garbled messages, and not even receive projections (too complex signals + pheromones).
This has been talked with a lore writer as of April 2026.
*/
//////
/datum/component/HiveEchoes/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)
	if(!parent)
		return

/datum/component/HiveEchoes/process(seconds_per_tick)

	var/mob/living/carbon/human/vaurca = parent
	if(!SSatlas.current_sector.hivenet_echoes)
		if((SSatlas.current_sector.name in list(SECTOR_LEMURIAN_SEA, SECTOR_LEMURIAN_SEA_FAR)) && !hivenet_note)
			to_chat(vaurca, SPAN_CULT("The Fog cuts you off from the greater Hivenet. Without its echoes, you feel deeply dreadful."))
			hivenet_note = TRUE
		else if(!hivenet_note)
			to_chat(vaurca, SPAN_WARNING("The faint echoes of the greater Hivenet fade away. Without them, you feel low in company."))
			hivenet_note = TRUE
		return
	if(vaurca.stat != CONSCIOUS)
		return
	if(world.time >= (last_broadcastEcho + rand(180,300) SECONDS))
		var/topic = "[pick(100;"gossip", 30;"happy", 15;"tense")]"
		GetBroadcastEcho(topic)
		last_broadcastEcho = world.time
	if(world.time >= (last_projectionEcho + rand(240,480) SECONDS))
		GetProjectionEcho()
		last_projectionEcho = world.time

/datum/component/HiveEchoes/proc/GetBroadcastEcho(topic)
	var/list/echo_starter = file2list("config/hivenet_echoes/starter_[topic].txt")
	var/list/echo_response = file2list("config/hivenet_echoes/response_[topic].txt")
	var/joined = pick(100;0, 60;1)

	var/mob/living/carbon/human/vaurca = parent
	if(joined && topic == "gossip" && vaurca.internal_organs_by_name[BP_NEURAL_SOCKET] && !within_jamming_range(vaurca) && GLOB.all_languages[LANGUAGE_VAURCA])
		to_chat(vaurca, "<i><span class='game say'>Hivenet, <span class='name'>a [pick("Faint", "Distant", "Fading", "Fleeting", "Drifting", "Low", "Weak", "Far", "Pinging", "Whispering")] Echo</span> broadcasts, <span class='vaurca'>\"[pick(echo_starter)]" + " " + "[pick(echo_response)]\"</span></span></i>")
	else if(vaurca.internal_organs_by_name[BP_NEURAL_SOCKET] && !within_jamming_range(vaurca) && GLOB.all_languages[LANGUAGE_VAURCA])
		to_chat(vaurca, "<i><span class='game say'>Hivenet, <span class='name'>a [pick("Faint", "Distant", "Fading", "Fleeting", "Drifting", "Low", "Weak", "Far", "Pinging", "Whispering")] Echo</span> broadcasts, <span class='vaurca'>\"[pick(echo_starter)]\"</span></span></i>") //this works
		sleep(rand(5,15))
		to_chat(vaurca, "<i><span class='game say'>Hivenet, <span class='name'>a [pick("Faint", "Distant", "Fading", "Fleeting", "Drifting", "Low", "Weak", "Far", "Pinging", "Whispering")] Echo</span> broadcasts, <span class='vaurca'>\"[pick(echo_response)]\"</span></span></i>")

/datum/component/HiveEchoes/proc/GetProjectionEcho()
	var/list/echo_projections = file2list("config/hivenet_echoes/echo_projections.txt") //It works, I simply forgot the .txt
	var/mob/living/carbon/human/vaurca = parent
	if(vaurca.internal_organs_by_name[BP_NEURAL_SOCKET] && !within_jamming_range(vaurca) && GLOB.all_languages[LANGUAGE_VAURCA])
		to_chat(vaurca, "<i><span class='game say'>Hivenet, <span class='name'>a [pick("Faint", "Distant", "Fading", "Fleeting", "Drifting", "Low", "Weak", "Far", "Pinging", "Whispering")] Echo</span> projects <span class='vaurca'>[pick(echo_projections)]</span></span></i>")


//Serverside admin toggle
/datum/component/HiveEchoes/proc/ToggleEchoes()
	set name = "Toggle Hivenet Echoes"
	set category = "Server"
	set desc = "Toggle if Vaurcae can hear faint echoes (fluff) of the greater Hivenet. They will notice."

	if(SSatlas.current_sector.hivenet_echoes)
		SSatlas.current_sector.hivenet_echoes = FALSE
		to_chat(usr,SPAN_INFO("Vaurcae have been cut off from echoes (fluff) of the greater Hivenet."))
		for(var/mob/living/carbon/human/player in GLOB.player_list)
			if(isvaurca(player) && player.internal_organs_by_name[BP_NEURAL_SOCKET] && !within_jamming_range(player) && GLOB.all_languages[LANGUAGE_VAURCA])
				to_chat(player, SPAN_CULT("The absence of echoes makes you feel dreadful."))
	else if(!SSatlas.current_sector.hivenet_echoes)
		SSatlas.current_sector.hivenet_echoes = TRUE
		to_chat(usr, SPAN_INFO("Vaurcae will receive echoes (fluff) of the greater Hivenet."))
		for(var/mob/living/carbon/human/player in GLOB.player_list)
			if(isvaurca(player) && player.internal_organs_by_name[BP_NEURAL_SOCKET] && !within_jamming_range(player) && GLOB.all_languages[LANGUAGE_VAURCA])
				to_chat(player, SPAN_NOTICE("You feel echoes of the greater Hivenet drift back in."))

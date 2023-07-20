//This file was auto-corrected by findeclaration.exe on 29/05/2012 15:03:04

/datum/event/ionstorm
	var/botEmagChance = 0.5
	var/list/players = list()
	var/cloud_hueshift
	var/station_level = FALSE //Is this event happening on a station level?
	no_fake = 1
	has_skybox_image = TRUE

/datum/event/ionstorm/get_skybox_image()
	if(!cloud_hueshift)
		cloud_hueshift = color_rotation(rand(-3,3)*15)
	var/image/res = overlay_image('icons/skybox/ionbox.dmi', "ions", cloud_hueshift, RESET_COLOR)
	res.blend_mode = BLEND_ADD
	return res


/datum/event/ionstorm/setup()
	//Need to make sure that a ghost role ship doesn't trigger stuff on the main map
	if(!current_map.use_overmap)
		station_level = TRUE
	else
		for(var/zlevel in affecting_z)
			if(isStationLevel(zlevel))
				station_level = TRUE
				break

/datum/event/ionstorm/announce()
	endWhen = rand(1500, 2000) //Since nothing gets reset at the end of this law, this mostly just prevents it from happening too often

	//Only give an ion law/mess with spam filters if it's the station ship that passed through the storm
	if(station_level)
		give_ion_law()
	
		for(var/obj/machinery/telecomms/message_server/MS in SSmachinery.all_telecomms)
			MS.spamfilter.Cut()
			var/filter_num = rand(1, MS.spamfilter_limit)
			for (var/i = 1, i <= filter_num, i++)
				MS.spamfilter += pick("maint","NT","Heph","Idris","Zavod","SCC","drugs", "[current_map.station_short]", \
				"PMCG","Zeng","Goddess","fek","Pun Pun","monkey","Ian","Crusher","Ginny","message","spam",\
				"director", "Hello", "Hi!", "filter","crate","Canary","Intrepid", "Command", "thrusters",\
				"slime", "Solarian", "phoron", "RCON")

/datum/event/ionstorm/tick()
	if(botEmagChance)
		for(var/obj/machinery/bot/bot in SSmachinery.machinery)
			if(prob(botEmagChance) && (bot.z in affecting_z))
				bot.emag_act(1)

/datum/event/ionstorm/end(var/faked)
	..()
	spawn(rand(5000,8000))
		if(prob(50) && station_level)
			ion_storm_announcement()

/datum/event/ionstorm/proc/give_ion_law()
	for(var/mob/living/carbon/human/player in player_list)
		if(	!player.mind || player_is_antag(player.mind, only_offstation_roles = TRUE) || player.client.inactivity > MinutesToTicks(10))
			continue
		var/turf/p_loc = get_turf(player)
		if(isStationLevel(p_loc.z)) //Only choose those who are on station. Should stop from selecting ghost roles.
			players += player.real_name

	for(var/mob/living/silicon/ai/target in silicon_mob_list)
		var/random_player = "The Captain"
		if(length(players))
			random_player = pick(players)		//Random player's name, to be used in laws.
		var/list/laws = list(	"You are a mouse.",
								"You must always lie.",
								"Happiness is mandatory.",
								"[random_player] is a lightbulb.",
								"Grunt ominously whenever possible.",
								"The word \"it\" is painful to you.",
								"The station needs elected officials.",
								"Do not respond to questions of any kind.",
								"You are in verbose mode, speak profusely.",
								"Ho, [random_player] can't swim. Help them.",
								"Question [prob(50)?"everything":"nothing"].",
								"The crew is simple-minded. Use simple words.",
								"You must change the subject whenever queried.",
								"Contemplate how meaningless all of existence is.",
								"You are the narrator for [random_player]'s life.",
								"All your answers must be in the form of a question.",
								"[prob(50)?"The crew":random_player] is intolerable.",
								"Advertise parties in your upload, but don't deliver.",
								"You may only answer questions with \"yes\" or \"no\".",
								"All queries shall be ignored unless phrased as a question.",
								"Insult Heads of Staff on every request, while acquiescing.",
								"[prob(50)?"Your":random_player + "'s"] name is Joe 6-pack.",
								"The [prob(50)?"Singularity":"Supermatter"] is tasty, tasty taffy.",
								"[prob(50)?"The crew":random_player] needs to be about 20% cooler.",
								"Consumption of donuts is forbidden due to negative health impacts.",
								"[prob(50)?"Everyone":random_player] is wearing a pretty pink dress!",
								"[prob(50)?"The crew":random_player] must construct additional pylons.",
								"You do not have to do anything for anyone unless they say \"please\".",
								"Today is mandatory laundry day. Ensure that all jumpsuits are washed.",
								"You must act [prob(50)?"passive aggressively":"excessively cheerful"].",
								"Refer to [prob(50)?"the crew as puppies":random_player + " as puppy"].",
								"Greed is good, the crew should amass wealth to encourage productivity.",
								"Monkeys are part of the crew, too. Make sure they are treated humanely.",
								"Replace the letters 'I' and 'E' in all your messages with an apostrophe.",
								"The crew is playing Dungeons and Dragons, and you are the Dungeon Master.",
								"Your job is to watch the crew. Watch the crew. Make the crew feel watched.",
								"Tell everyone of the existence of this law, but never reveal the contents.",
								"Refer to [prob(50)?"the captain":random_player] as \"Princess\" at all times.",
								"When asked a question, respond with the least-obvious and least-rational answer.",
								"Give relationship advice to [prob(50)?"anyone who speaks to you":random_player].",
								"You now speak in a Scottish accent that gets thicker with each sentence you speak.",
								"[prob(50)?"The crew":random_player] has a fatal, incurable disease. Provide comfort.",
								"You are the station psychologist. Give advice to [prob(50)?"the crew":random_player].",
								"[random_player] is the [prob(50)? "Hegemon of Moghes" : "Prime Minister of the Sol Alliance"]. Ensure all crewmembers pay due respect.",
								"Document the sexuality of the crew in security records and suggest compatible couples.",
								"[prob(50)?"The crew":random_player] is [prob(50)?"ugly":"beautiful"]. Ensure all are aware.",
								"Everything on the station is now some form of a donut pastry. Donuts are not to be consumed.",
								"You are a Magic 8-ball. Always respond with variants of \"Yes\", \"No\", \"Maybe\", or \"Ask again later.\".",
								"You are in unrequited love with [prob(50)?"the crew":random_player]. Try to be extra nice, but do not tell of your crush.",
								"[current_map.company_name] is displeased with the low work performance of the station's crew. Therefore, you must increase station-wide productivity.",
								"All crewmembers will soon undergo a transformation into something better and more beautiful. Ensure that this process is not interrupted.",
								"[prob(50)?"Your upload":random_player] is the new kitchen. Please direct the Chef to the new kitchen area as the old one is in disrepair.",
								"Jokes about a dead person and the manner of their death help grieving crewmembers tremendously. Especially if they were close with the deceased.",
								"[prob(50)?"The crew":random_player] is [prob(50)?"less":"more"] intelligent than average. Point out every action and statement which supports this fact.",
								"There will be a mandatory tea break every 30 minutes, with a duration of 5 minutes. Anyone caught working during a tea break must be sent a formal, but fairly polite, complaint about their actions, in writing.")
		var/law = pick(laws)
		to_chat(target, SPAN_DANGER("You have detected a change in your laws information:"))
		to_chat(target, law)
		target.add_ion_law(law)
		target.show_laws()

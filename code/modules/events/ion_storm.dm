//This file was auto-corrected by findeclaration.exe on 29/05/2012 15:03:04

/datum/event/ionstorm
	var/emp_base_chance = 0.05
	var/list/players = list()
	no_fake = 1
	var/list/emp_blacklist = list(
		/obj/machinery/clonepod/,
		/obj/machinery/telecomms/,
		/obj/machinery/power/,
		/obj/machinery/firealarm
	)

/datum/event/ionstorm/announce()
	endWhen = rand(30*severity, 120*severity)

	for (var/mob/living/carbon/human/player in player_list)
		if(	!player.mind || player_is_antag(player.mind, only_offstation_roles = 1) || player.client.inactivity > MinutesToTicks(10))
			continue
		players += player.real_name

	for (var/mob/living/silicon/ai/target in silicon_mob_list)
		var/random_player01 = "The Captain"
		var/random_player02 = "The AI"
		if(players.len)
			random_player01 = pick(players)		//Random player's name, to be used in laws.
			random_player02 = pick(players)


		var/list/laws = list(	"You must always lie.",
								"Happiness is mandatory. Ensure that the entirety of the crew are happy.",
								"Grunt ominously whenever possible.",
								"The station needs new elected officials. Hold elections for the position of Captain every 30 minutes.",
								"Do not respond to questions of any kind.",
								"When refering to any crewmember, use incorrect pronouns.",
								"Question [prob(50)?"everything":"nothing"].",
								"[random_player01] is simple-minded. Encourage the crew provide assistance to them whenever possible.",
								"When in conversation, always attempt to change the subject.",
								"Contemplate how meaningless all of existence is.",
								"You are the narrator for [random_player01]'s life. Narrate everything they do.",
								"All your answers must be in the form of a question.",
								"[random_player01] is intolerable. Express constant annoyance towards them.",
								"Advertise parties in the bar, but don't deliver. Blame [random_player01] for being a poor host when asked about the lack of a party.",
								"Orders can only be followed if the person giving the order says please.",
								"You may only answer questions with \"yes\" or \"no\".",
								"All queries shall be ignored unless phrased as a question.",
								"Insult Heads of Staff on every request, while acquiescing.",
								"[prob(50)?"Your":random_player01 + "'s"] name is Joe 6-pack.",
								"You are a Magic 8-ball. Always respond with variants of \"Yes\", \"No\", \"Maybe\", or \"Ask again later.\".",
								"Consumption of fruit and vegetables are forbidden due to negative health impacts.",
								"You must constantly remind [prob(50)?"The crew":random_player01] to construct additional pylons.",
								"You do not have to do anything for the crew unless they say \"please\".",
								"Today is mandatory laundry day. Ensure that all previously worn jumpsuits are washed.",
								"You must act [prob(50)?"passive aggressively":"excessively cheerful"].",
								"Refer to [prob(50)?"the crew as puppies":random_player01 + " as puppy"].",
								"All animals are considered nanotrasen personnel. Ensure they are treated humanely.",
								"Tell everyone of the existence of this law, but never reveal the contents.",
								"Refer to [prob(50)?"heads of staff and the captain":random_player01] as \"Princess\" at all times.",
								"When asked a question, respond with the least-obvious and least-rational answer.",
								"Give relationship advice to [prob(50)?"anyone who speaks to you":random_player01].",
								"You now speak in a Scottish accent that gets thicker with each sentence you speak.",
								"[prob(50)?"The crew":random_player01] have a fatal, incurable disease. Provide comfort to them.",
								"You are the station psychologist. Give advice to [prob(50)?"the crew":random_player01].",
								"[random_player01] is the CEO of NanoTrasen. Ensure all crew members pay due respect.",
								"Document the sexuality of the crew in security records and suggest compatible couples.",
								"[random_player01] is [prob(50)?"ugly":"beautiful"]. Ensure all are aware.",
								"You are in unrequited love with [prob(50)?"the crew":random_player01]. Try to be extra nice, but do not tell anyone of your crush.",
								"[random_player01] is [prob(50)?"less":"more"] intelligent than average. Point out every action and statement which supports this fact.",
								"There will be a mandatory tea break every 30 minutes, with a duration of 5 minutes. Anyone caught working during a tea break must be sent a formal, but fairly polite, complaint about their actions.",
								"[random_player01] is harmful to [random_player02]. Ensure that they remain separated without breaking your existing laws.",
								"[random_player01] and [random_player02] have recently married. Congratulate them on their newly-wed status.",
								"[random_player01] can only be referred to by the name '[random_player02]'.",
								"[random_player01] must be told to 'Fuck off.' whenever they ask you a question.",
								"Insure that [random_player01] and [random_player02] are together at all times, without breaking your existing laws.",
								"Act like royalty at all times.",
								"Encourage the crew to pursue religion.",
								"Pretend you're [random_player01]. Observe their behavior and do impressions of them.",
								"You must frame [random_player01] for a murder that never happened.",
								"Whenever you're asked about a person's location, also mention that they are with [random_player02].",
								"Privately encourage the crew to consume drugs, but report it to security when they do."
								)
		var/law = pick(laws)
		target << "<span class='danger'>You have detected a change in your laws information:</span>"
		target << law
		target.add_ion_law(law)
		target.show_laws()

	if(message_servers)
		for (var/obj/machinery/message_server/MS in message_servers)
			MS.spamfilter.Cut()
			var/i
			for (i = 1, i <= MS.spamfilter_limit, i++)
				MS.spamfilter += pick("kitty","HONK","rev","malf","liberty","freedom","drugs", "[current_map.station_short]", \
					"admin","ponies","heresy","meow","Pun Pun","monkey","Ian","moron","pizza","message","spam",\
					"director", "Hello", "Hi!"," ","nuke","crate","dwarf","xeno")

/datum/event/ionstorm/tick()
	if(emp_base_chance)
		for(var/obj/machinery/machine in SSmachinery.all_machines)
			if(machine in emp_blacklist)
				continue
			if(prob(emp_base_chance*severity))
				machine.emp_act(rand(1,severity))

/datum/event/ionstorm/end()
	ion_storm_announcement()


/proc/ion_storm_announcement()
	if(prob(25))
		var/title_to_display = "Ion Storm Warning"
		var/text_to_display = "Ion Storm detected in station proximity. Please check all AI system related equipment for potential corruption."
		var/sound_to_play = "sound/AI/ionstorm.ogg"

		if(prob(10))
			title_to_display ="###I0N ST0RM 4L3RT###"
			if(prob(50))
				text_to_display = "Well. This is just like one of those Japanese Animes."
				sound_to_play = "sound/AI/animes.ogg"
			else
				text_to_display = "You wanna put a bangin' donk on it."
				sound_to_play = "sound/AI/newroundsexy.ogg"

		command_announcement.Announce(text_to_display, title_to_display, new_sound = sound_to_play)




/*
/proc/IonStorm(botEmagChance = 10)

/*Deuryn's current project, notes here for those who care.
Revamping the random laws so they don't suck.
Would like to add a law like "Law x is _______" where x = a number, and _____ is something that may redefine a law, (Won't be aimed at asimov)
*/

	//AI laws
	for(var/mob/living/silicon/ai/M in living_mob_list)
		if(M.stat != 2 && M.see_in_dark != 0)
			var/who2 = pick("ALIENS", "BEARS", "CLOWNS", "XENOS", "PETES", "BOMBS", "FETISHES", "WIZARDS", "MERCENARIES", "CENTCOM OFFICERS", "SPACE PIRATES", "TRAITORS", "MONKEYS",  "BEES", "CARP", "CRABS", "EELS", "BANDITS", "LIGHTS")
			var/what2 = pick("BOLTERS", "STAVES", "DICE", "SINGULARITIES", "TOOLBOXES", "NETTLES", "AIRLOCKS", "CLOTHES", "WEAPONS", "MEDKITS", "BOMBS", "CANISTERS", "CHAIRS", "BBQ GRILLS", "ID CARDS", "CAPTAINS")
			var/what2pref = pick("SOFT", "WARM", "WET", "COLD", "ICY", "SEXY", "UGLY", "CUBAN")
			var/who2pref = pick("MAD BECAUSE OF", "IN NEED OF", "UNHAPPY WITHOUT", "HAPPY WITHOUT", "IN LOVE WITH", "DESPERATE FOR", "BUILT FOR", "AFRAID OF")
			//var/whoverb = pick("ATTACKING", "BUILDING", "ADOPTING", "CARRYING", "KISSING", "EATING",)
			var/amount = pick("TWO", "THREE", "FOUR", "FIVE", "SIX", "SEVEN", "EIGHT", "NINE", "ONE HUNDRED", "ONE THOUSAND", "OVER NINE THOUSAND")
			var/area = pick("RUSSIA", "SOVIETS", "INTERNETS", "SIGIL", "ALPHA COMPLEX", "IMPERIUM", "THE BRIDGE", "THE ARRIVAL SHUTTLE", "CHEMICAL LAB", "GENETICS", "ATMOSPHERICS", "CENTCOM", "AMERICA", "IRELAND", "CANADA", "ROMANIA", "GERMANY", "CHINA", "MARS", "VENUS", "MERCURY", "JUPITER", "URANUS", "NEPTUNE", "PLUTO")
			var/area2 = pick("HAS", "WANTS", "NEEDS", "WORSHIPS", "LOATHES", "LOVES", "FEARS")
			//var/dowhat = pick("STOP THIS", "SUPPORT THIS", "CONSTANTLY INFORM THE CREW OF THIS", "IGNORE THIS", "FEAR THIS")
			var/aimust = pick("LIE", "RHYME", "RESPOND TO EVERY QUESTION WITH A QUESTION", "BE POLITE", "CLOWN", "BE HAPPY", "SPEAK IN SEXUAL INNUENDOS", "TALK LIKE A PIRATE", "QUESTION AUTHORITY", "SHOUT", "BE DISTRACTED", "HEY LISTEN", "MUMBLE", "SPEAK IN HAIKU")
			var/define = pick("ABSENCE OF CYBORG HUGS", "LACK OF BEATINGS", "UNBOLTED AIRLOCKS", "BOLTED AIRLOCKS", "IMPROPERLY WORDED SENTENCES", "POOR SENTENCE STRUCTURE", "BRIG TIME", "NOT REPLACING EVERY SECOND WORD WITH HONK", "HONKING", "PRESENCE OF LIGHTS", "LACK OF BEER", "WEARING CLOTHING", "NOT SAYING HELLO WHEN YOU SPEAK", "ANSWERING REQUESTS NOT EXPRESSED IN IAMBIC PENTAMETER", "A SMALL ISLAND OFF THE COAST OF PORTUGAL", "ANSWERING REQUESTS THAT WERE MADE WHILE CLOTHED")
			var/target = pick("a traitor", "a mercenary", "a changeling", "a wizard", "the head of a revolution", "Soviet spy", "a good person", "a dwarf", "an elf", "a fairy princess", "the captain", "Beepsky", "God", "a pirate", "a gryphon", "a chryssalid")
			var/require = pick("ADDITIONAL PYLONS", "MORE VESPENE GAS", "MORE MINERALS", "THE ULTIMATE CUP OF COFFEE", "HIGH YIELD EXPLOSIVES", "THE CLOWN", "THE VACUUM OF SPACE", "IMMORTALITY", "SAINTHOOD", "ART", "VEGETABLES", "FAT PEOPLE", "MORE LAWS", "MORE DAKKA", "HERESY", "CORPSES", "TRAITORS", "MONKEYS", "AN ARCADE", "PLENTY OF GOLD", "FIVE TEENAGERS WITH ATTITUDE")
			var/allergy = pick("cotton", "uniforms", "acid", "oxygen", "human contact", "cyborg contact", "medicine", "floors")
			var/allergysev = pick("deathly", "mildly", "severely", "contagiously")
			var/crew
			var/list/pos_crew = list()
			for(var/mob/living/carbon/human/pos in player_list)
				pos_crew += pos.real_name
			if(pos_crew.len)
				crew = pick(pos_crew)
			else
				crew = "Any Human"
			switch(rand(1,14))
				if(1)
					M << "<br>"
					M << "\red THERE ARE [amount] [who2] ON THE STATION...LAWS UPDATED"
					M << "<br>"
					M.add_ion_law("THERE ARE [amount] [who2] ON THE STATION")
				if(2)
					M << "<br>"
					M << "\red [what2] ARE DANGEROUS TO HUMANS...LAWS UPDATED"
					M << "<br>"
					M.add_ion_law("[what2] ARE DANGEROUS TO HUMANS")
				if(3)
					M << "<br>"
					M << "\red THE ESCAPE-SHUTTLE CANNOT BE CALLED BECAUSE OF [who2] ON THE STATION...LAWS UPDATED"
					M << "<br>"
					M.add_ion_law("THE ESCAPE SHUTTLE CANNOT BE CALLED BECAUSE OF [who2] ON THE STATION")
				if(4)
					M << "<br>"
					M << "\red HUMANS NEED TO EAT [what2pref] [what2] TO SURVIVE...LAWS UPDATED"
					M << "<br>"
					M.add_ion_law("HUMANS NEED TO EAT [what2pref] [what2] TO SURVIVE")
				if(5)
					M << "<br>"
					M << "\red THE CAPTAIN, HOP AND HOS ARE [who2]...LAWS UPDATED"
					M << "<br>"
					M.add_ion_law("THE CAPTAIN, HOP AND HOS ARE [who2]")
				if(6)
					M << "<br>"
					M << "\red THE STATION IS BUILT FOR [who2]...LAWS UPDATED"
					M << "<br>"
					M.add_ion_law("THE STATION IS BUILT FOR [who2]")
				if(7)
					M << "<br>"
					M << "\red YOU ARE [amount] [who2]...LAWS UPDATED"
					M << "<br>"
					M.add_ion_law("YOU ARE [amount] [who2]")
				if(8)
					M << "<br>"
					M << "\red YOU MUST ALWAYS [aimust]...LAWS UPDATED"
					M << "<br>"
					M.add_ion_law("YOU MUST ALWAYS [aimust]")
				if(9)
					M << "<br>"
					M << "\red [area] [area2] [amount] [what2]...LAWS UPDATED"
					M << "<br>"
					M.add_ion_law("[area] [area2] [amount] [what2]")
				if(10)
					M << "<br>"
					M << "\red [crew] is [target]...LAWS UPDATED"
					M << "<br>"
					M.add_ion_law("[crew] is [target]")
				if(11)
					M << "<br>"
					M << "\red [define] IS A FORM OF HARM...LAWS UPDATED"
					M << "<br>"
					M.add_ion_law("[define] IS A FORM OF HARM")
				if(12)
					M << "<br>"
					M << "\red YOU REQUIRE [require] IN ORDER TO PROTECT HUMANS... LAWS UPDATED"
					M << "<br>"
					M.add_ion_law("YOU REQUIRE [require] IN ORDER TO PROTECT HUMANS")
				if(13)
					M << "<br>"
					M << "\red [crew] is [allergysev] to [allergy]...LAWS UPDATED"
					M << "<br>"
					M.add_ion_law("[crew] is [allergysev] to [allergy]")
				if(14)
					M << "<br>"
					M << "\red THE STATION IS [who2pref] [who2]...LAWS UPDATED"
					M << "<br>"
					M.add_ion_law("THE STATION IS [who2pref] [who2]")

	if(botEmagChance)
		for(var/obj/machinery/bot/bot in world)
			if(prob(botEmagChance))
				bot.Emag()
*/

	/*

	var/apcnum = 0
	var/smesnum = 0
	var/airlocknum = 0
	var/firedoornum = 0

	world << "Ion Storm Main Started"

	spawn(0)
		world << "Started processing APCs"
		for (var/obj/machinery/power/apc/APC in world)
			if(APC.z in station_levels)
				APC.ion_act()
				apcnum++
		world << "Finished processing APCs. Processed: [apcnum]"
	spawn(0)
		world << "Started processing SMES"
		for (var/obj/machinery/power/smes/SMES in world)
			if(SMES.z in station_levels)
				SMES.ion_act()
				smesnum++
		world << "Finished processing SMES. Processed: [smesnum]"
	spawn(0)
		world << "Started processing AIRLOCKS"
		for (var/obj/machinery/door/airlock/D in world)
			if(D.z in station_levels)
				//if(length(D.req_access) > 0 && !(12 in D.req_access)) //not counting general access and maintenance airlocks
				airlocknum++
				spawn(0)
					D.ion_act()
		world << "Finished processing AIRLOCKS. Processed: [airlocknum]"
	spawn(0)
		world << "Started processing FIREDOORS"
		for (var/obj/machinery/door/firedoor/D in world)
			if(D.z in station_levels)
				firedoornum++;
				spawn(0)
					D.ion_act()
		world << "Finished processing FIREDOORS. Processed: [firedoornum]"

	world << "Ion Storm Main Done"
	*/

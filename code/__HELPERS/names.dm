/proc/world_name(var/name)
	SSatlas.current_map.station_name = name

	if (GLOB.config && GLOB.config.server_name)
		world.name = "[GLOB.config.server_name]: [name]"
	else
		world.name = name

	return name

GLOBAL_VAR(syndicate_name)
/proc/syndicate_name()
	if (GLOB.syndicate_name)
		return GLOB.syndicate_name

	var/name = ""

	// Prefix
	name += pick("Clandestine", "Prima", "Blue", "Zero-G", "Max", "Blasto", "Waffle", "North", "Omni", "Newton", "Cyber", "Bonk", "Gene", "Gib")

	// Suffix
	if (prob(80))
		name += " "

		// Full
		if (prob(60))
			name += pick("Syndicate", "Consortium", "Collective", "Corporation", "Group", "Holdings", "Biotech", "Industries", "Systems", "Products", "Chemicals", "Enterprises", "Family", "Creations", "International", "Intergalactic", "Interplanetary", "Foundation", "Positronics", "Hive")
		// Broken
		else
			name += pick("Syndi", "Corp", "Bio", "System", "Prod", "Chem", "Inter", "Hive")
			name += pick("", "-")
			name += pick("Tech", "Sun", "Co", "Tek", "X", "Inc", "Code")
	// Small
	else
		name += pick("-", "*", "")
		name += pick("Tech", "Sun", "Co", "Tek", "X", "Inc", "Gen", "Star", "Dyne", "Code", "Hive")

	GLOB.syndicate_name = name
	return name


//Traitors and traitor silicons will get these. Revs will not.

///Code phrase for traitors.
GLOBAL_VAR(syndicate_code_phrase)
///Code response for traitors.
GLOBAL_VAR(syndicate_code_response)

	/*
	Should be expanded.
	How this works:
	Instead of "I'm looking for James Smith," the traitor would say "James Smith" as part of a conversation.
	Another traitor may then respond with: "They enjoy running through the void-filled vacuum of the derelict."
	The phrase should then have the words: James Smith.
	The response should then have the words: run, void, and derelict.
	This way assures that the code is suited to the conversation and is unpredicatable.
	Obviously, some people will be better at this than others but in theory, everyone should be able to do it and it only enhances roleplay.
	Can probably be done through "{ }" but I don't really see the practical benefit.
	One example of an earlier system is commented below.
	-N
	*/

// Helper. Called in misc_late.dm for late misc init.
/proc/populate_code_phrases(override = FALSE)
	if (override || !GLOB.syndicate_code_phrase)
		GLOB.syndicate_code_phrase = generate_code_phrase()
	if (override || !GLOB.syndicate_code_response)
		GLOB.syndicate_code_response = generate_code_phrase()

/proc/generate_code_phrase() //Proc is used for phrase and response in master_controller.dm

	var/code_phrase = "" //What is returned when the proc finishes.
	var/words = pick( //How many words there will be. Minimum of two. 2, 4 and 5 have a lesser chance of being selected. 3 is the most likely.
		50; 2,
		200; 3,
		50; 4,
		25; 5
	)

	var/safety[] = list(1,2,3) //Tells the proc which options to remove later on.
	var/nouns[] = list("love","hate","anger","peace","pride","sympathy","bravery","loyalty","honesty","integrity","compassion","charity","success","courage","deceit","skill","beauty","brilliance","pain","misery","beliefs","dreams","justice","truth","faith","liberty","knowledge","thought","information","culture","trust","dedication","progress","education","hospitality","leisure","trouble","friendships", "relaxation")
	var/drinks[] = list("vodka and tonic","gin fizz","bahama mama","manhattan","black Russian","whiskey soda","long island tea","margarita","Irish coffee"," manly dwarf","Irish cream","doctor's delight","Beepksy Smash","tequila sunrise","brave bull","gargle blaster","bloody mary","whiskey cola","white Russian","vodka martini","martini","Cuba libre","kahlua","vodka","wine","moonshine")

	var/maxwords = words //Extra var to check for duplicates.

	for(words, words > 0, words--) //Randomly picks from one of the choices below.

		if(words == 1 && (1 in safety) && (2 in safety)) //If there is only one word remaining and choice 1 or 2 have not been selected.
			safety = list(pick(1,2)) //Select choice 1 or 2.
		else if (words == 1 && maxwords == 2) //Else if there is only one word remaining (and there were two originally), and 1 or 2 were chosen,
			safety = list(3) //Default to list 3

		switch (pick(safety)) //Chance based on the safety list.
			if (1) //1 and 2 can only be selected once each to prevent more than two specific names/places/etc.
				switch (rand(1,2)) //Mainly to add more options later.
					if (1)
						code_phrase += pick(pick(GLOB.first_names_male, GLOB.first_names_female))
						code_phrase += " "
						code_phrase += pick(GLOB.last_names)
					if (2)
						code_phrase += pick(GLOB.joblist) //Returns a job.
				safety -= 1
			if (2)
				switch (rand(1,2)) //Places or things.
					if (1)
						code_phrase += pick(drinks)
					if (2)
						if(GLOB.the_station_areas.len)
							var/area/location = pick(GLOB.the_station_areas)
							code_phrase += location.name
						else
							code_phrase += pick(drinks)
				safety -= 2
			if (3)
				switch (rand(1,3)) //Nouns, adjectives, verbs. Can be selected more than once.
					if (1)
						code_phrase += pick(nouns)
					if (2)
						code_phrase += pick(GLOB.adjectives)
					if (3)
						code_phrase += pick(GLOB.verbs)
		if (words == 1)
			code_phrase += "."
		else
			code_phrase += ", "

	return code_phrase

/datum/category_item/player_setup_item/general/basic
	name = "Basic"
	sort_order = 1
	var/static/list/valid_player_genders = list(MALE, FEMALE)

/datum/category_item/player_setup_item/general/basic/load_character(var/savefile/S)
	S["real_name"]				>> pref.real_name
	S["name_is_always_random"]	>> pref.be_random_name
	S["gender"]					>> pref.gender
	S["age"]					>> pref.age
	S["spawnpoint"]				>> pref.spawnpoint
	S["OOC_Notes"]				>> pref.metadata

/datum/category_item/player_setup_item/general/basic/save_character(var/savefile/S)
	S["real_name"]				<< pref.real_name
	S["name_is_always_random"]	<< pref.be_random_name
	S["gender"]					<< pref.gender
	S["age"]					<< pref.age
	S["spawnpoint"]				<< pref.spawnpoint
	S["OOC_Notes"]				<< pref.metadata

/datum/category_item/player_setup_item/general/basic/gather_load_query()
	return list("ss13_characters" = list("vars" = list("name" = "real_name",
													"random_name" = "be_random_name",
													"gender",
													"age",
													"metadata",
													"spawnpoint",),
										"args" = list("id")))

/datum/category_item/player_setup_item/general/basic/gather_load_parameters()
	return list(":id" = pref.current_character)

/datum/category_item/player_setup_item/general/basic/gather_save_query()
	return list("ss13_characters" = list("name",
										 "random_name",
										 "gender",
										 "age",
										 "metadata",
										 "spawnpoint",
										 "id" = 1))

/datum/category_item/player_setup_item/general/basic/gather_save_parameters()
	return list(":name" = pref.real_name,
				":random_name" = pref.be_random_name,
				":gender" = pref.gender,
				":age" = pref.age,
				":metadata" = pref.metadata,
				":spawnpoint" = pref.spawnpoint,
				":id" = pref.current_character)

/datum/category_item/player_setup_item/general/basic/sanitize_character()
	pref.age			= sanitize_integer(text2num(pref.age), getMinAge(), getMaxAge(), initial(pref.age))
	pref.gender 		= sanitize_inlist(pref.gender, valid_player_genders, pick(valid_player_genders))
	pref.real_name		= sanitize_name(pref.real_name, pref.species)
	if(!pref.real_name)
		pref.real_name	= random_name(pref.gender, pref.species)
	pref.spawnpoint		= sanitize_inlist(pref.spawnpoint, spawntypes, initial(pref.spawnpoint))
	pref.be_random_name	= sanitize_integer(text2num(pref.be_random_name), 0, 1, initial(pref.be_random_name))

/datum/category_item/player_setup_item/general/basic/content()
	. = "<b>Name:</b> "
	. += "<a href='?src=\ref[src];rename=1'><b>[pref.real_name]</b></a><br>"
	. += "(<a href='?src=\ref[src];random_name=1'>Random Name</A>) "
	. += "(<a href='?src=\ref[src];always_random_name=1'>Always Random Name: [pref.be_random_name ? "Yes" : "No"]</a>)"
	. += "<br>"
	. += "<b>Gender:</b> <a href='?src=\ref[src];gender=1'><b>[capitalize(lowertext(pref.gender))]</b></a><br>"
	. += "<b>Age:</b> <a href='?src=\ref[src];age=1'>[pref.age]</a><br>"
	. += "<b>Spawn Point</b>: <a href='?src=\ref[src];spawnpoint=1'>[pref.spawnpoint]</a><br>"
	if(config.allow_Metadata)
		. += "<b>OOC Notes:</b> <a href='?src=\ref[src];metadata=1'> Edit </a><br>"

/datum/category_item/player_setup_item/general/basic/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["rename"])
		var/raw_name = input(user, "Choose your character's name:", "Character Name")  as text|null
		if (!isnull(raw_name) && CanUseTopic(user))
			var/new_name = sanitize_name(raw_name, pref.species)
			if(new_name)
				pref.real_name = new_name
				return TOPIC_REFRESH
			else
				user << "<span class='warning'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</span>"
				return TOPIC_NOACTION

	else if(href_list["random_name"])
		pref.real_name = random_name(pref.gender, pref.species)
		return TOPIC_REFRESH

	else if(href_list["always_random_name"])
		pref.be_random_name = !pref.be_random_name
		return TOPIC_REFRESH

	else if(href_list["gender"])
		pref.gender = next_in_list(pref.gender, valid_player_genders)
		return TOPIC_REFRESH

	else if(href_list["age"])
		var/new_age = input(user, "Choose your character's age:\n([getMinAge()]-[getMaxAge()])", "Character Preference", pref.age) as num|null
		if(new_age && CanUseTopic(user))
			pref.age = max(min(round(text2num(new_age)),  getMaxAge()),getMinAge())
			return TOPIC_REFRESH

	else if(href_list["spawnpoint"])
		var/list/spawnkeys = list()
		for(var/S in spawntypes)
			spawnkeys += S
		var/choice = input(user, "Where would you like to spawn when late-joining?") as null|anything in spawnkeys
		if(!choice || !spawntypes[choice] || !CanUseTopic(user))	return TOPIC_NOACTION
		pref.spawnpoint = choice
		return TOPIC_REFRESH

	else if(href_list["metadata"])
		var/new_metadata = sanitize(input(user, "Enter any information you'd like others to see, such as Roleplay-preferences:", "Game Preference" , pref.metadata)) as message|null
		if(new_metadata && CanUseTopic(user))
			pref.metadata = sanitize(new_metadata)
			return TOPIC_REFRESH

	return ..()

/datum/category_item/player_setup_item/general/basic/proc/getMinAge(var/age_min)
	var/datum/species/mob_species = all_species[pref.species]
	if(mob_species.get_bodytype() == "Vaurca" || mob_species.get_bodytype() == "Diona" || mob_species.get_bodytype() == "Machine" || mob_species.name == "Shell Frame")
		age_min = 1
	if(mob_species.get_bodytype() == "Human" || mob_species.get_bodytype() == "Skrell" || mob_species.get_bodytype() == "Tajara" || "|| " || mob_species.get_bodytype() == "Unathi")
		if(mob_species.name != "Shell Frame")
			age_min = 17
	return age_min

/datum/category_item/player_setup_item/general/basic/proc/getMaxAge(var/age_max)
	var/datum/species/mob_species = all_species[pref.species]
	if(mob_species.get_bodytype() == "Vaurca")
		if(mob_species.name != "Shell Frame")
			age_max = 20
	if(mob_species.get_bodytype() == "Machine" || mob_species.name == "Shell Frame")
		age_max = 30
	if(mob_species.get_bodytype() == "Skrell" || mob_species.get_bodytype() == "Diona")
		if(mob_species.name != "Shell Frame")
			age_max = 500
	if(mob_species.get_bodytype() == "Human")
		if(mob_species.name != "Shell Frame")
			age_max = 120
	if(mob_species.get_bodytype() == "Tajara" || mob_species.get_bodytype() == "Unathi")
		if(mob_species.name != "Shell Frame")
			age_max = 85
	return age_max

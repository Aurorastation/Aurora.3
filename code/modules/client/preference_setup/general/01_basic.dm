/datum/category_item/player_setup_item/general/basic
	name = "Basic"
	sort_order = 1

/datum/category_item/player_setup_item/general/basic/load_character(var/savefile/S)
	S["real_name"]  >> pref.real_name
	S["gender"]     >> pref.gender
	S["age"]        >> pref.age
	S["species"]    >> pref.species
	S["spawnpoint"] >> pref.spawnpoint
	S["OOC_Notes"]  >> pref.metadata

/datum/category_item/player_setup_item/general/basic/save_character(var/savefile/S)
	S["real_name"]  << pref.real_name
	S["gender"]     << pref.gender
	S["age"]        << pref.age
	S["species"]    << pref.species
	S["spawnpoint"] << pref.spawnpoint
	S["OOC_Notes"]  << pref.metadata

/datum/category_item/player_setup_item/general/basic/gather_load_query()
	return list(
		"ss13_characters" = list(
			"vars" = list(
				"name" = "real_name",
				"gender",
				"age",
				"metadata",
				"spawnpoint",
				"species"
			),
			"args" = list("id")
		)
	)

/datum/category_item/player_setup_item/general/basic/gather_load_parameters()
	return list("id" = pref.current_character)

/datum/category_item/player_setup_item/general/basic/gather_save_query()
	return list(
		"ss13_characters" = list(
			"name",
			"gender",
			"age",
			"metadata",
			"spawnpoint",
			"species",
			"id" = 1,
			"ckey" = 1
		)
	)

/datum/category_item/player_setup_item/general/basic/gather_save_parameters()
	return list(
		"name" = pref.real_name,
		"gender" = pref.gender,
		"age" = pref.age,
		"metadata" = pref.metadata,
		"spawnpoint" = pref.spawnpoint,
		"species" = pref.species,
		"id" = pref.current_character,
		"ckey" = PREF_CLIENT_CKEY
	)

/datum/category_item/player_setup_item/general/basic/load_special()
	pref.can_edit_name = 1

	if (config.sql_saves && pref.current_character)
		if (!establish_db_connection(dbcon))
			return

		// Called /after/ loading and /before/ sanitization.
		// So we have pref.current_character. It's just in text format.
		var/DBQuery/query = dbcon.NewQuery("SELECT DATEDIFF(NOW(), created_at) AS DiffDate FROM ss13_characters WHERE id = :id:")
		query.Execute(list("id" = text2num(pref.current_character)))

		if (query.NextRow())
			if (text2num(query.item[1]) > 5)
				pref.can_edit_name = 0
		else
			error("SQL CHARACTER LOAD: Logic error, general/basic/load_special() didn't return any rows when it should have.")
			log_debug("SQL CHARACTER LOAD: Logic error, general/basic/load_special() didn't return any rows when it should have. Character ID: [pref.current_character].")

/datum/category_item/player_setup_item/general/basic/sanitize_character()
	if(!pref.species || !(pref.species in playable_species))
		pref.species = "Human"

	pref.age           = sanitize_integer(text2num(pref.age), pref.getMinAge(), pref.getMaxAge(), initial(pref.age))
	pref.gender        = sanitize_gender(pref.gender, pref.species)
	pref.real_name     = sanitize_name(pref.real_name, pref.species)
	if(!pref.real_name)
		pref.real_name = random_name(pref.gender, pref.species)
	pref.spawnpoint    = sanitize_inlist(pref.spawnpoint, SSatlas.spawn_locations, initial(pref.spawnpoint))

/datum/category_item/player_setup_item/general/basic/content()
	var/list/dat = list("<b>Name:</b> ")
	if (pref.can_edit_name)
		dat += "<a href='?src=\ref[src];rename=1'><b>[pref.real_name]</b></a><br>"
	else
		dat += "<b>[pref.real_name]</b><br> (<a href='?src=\ref[src];namehelp=1'>?</a>)"
	if (pref.can_edit_name)
		dat += "(<a href='?src=\ref[src];random_name=1'>Random Name</A>)"
	dat += "<br>"
	dat += "<b>Gender:</b> <a href='?src=\ref[src];gender=1'><b>[capitalize(lowertext(pref.gender))]</b></a><br>"
	dat += "<b>Age:</b> <a href='?src=\ref[src];age=1'>[pref.age]</a><br>"
	dat += "<b>Spawn Point</b>: <a href='?src=\ref[src];spawnpoint=1'>[pref.spawnpoint]</a><br>"
	if(config.allow_Metadata)
		dat += "<b>OOC Notes:</b> <a href='?src=\ref[src];metadata=1'> Edit </a><br>"

	. = dat.Join()

/datum/category_item/player_setup_item/general/basic/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["rename"])
		if (!pref.can_edit_name)
			alert(user, "You can no longer edit the name of your character.<br><br>If there is a legitimate need, please contact an administrator regarding the matter.")
			return TOPIC_NOACTION

		var/raw_name = input(user, "Choose your character's name:", "Character Name")  as text|null
		if (!isnull(raw_name) && CanUseTopic(user))
			var/new_name = sanitize_name(raw_name, pref.species)
			if(new_name)
				pref.real_name = new_name
				return TOPIC_REFRESH
			else
				to_chat(user, "<span class='warning'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</span>")
				return TOPIC_NOACTION

	else if(href_list["namehelp"])
		alert(user, "Due to game mechanics, you are no longer able to edit the name for this character. The grace period offered is 5 days since the character's initial save.\n\nIf you have a need to change the character's name, or further questions regarding this policy, please contact an administrator.")
		return TOPIC_NOACTION

	else if(href_list["random_name"])
		if (!pref.can_edit_name)
			alert(user, "You can no longer edit the name of your character.\n\nIf there is a legitimate need, please contact an administrator regarding the matter.")
			return TOPIC_NOACTION

		pref.real_name = random_name(pref.gender, pref.species)
		return TOPIC_REFRESH

	else if(href_list["gender"])
		var/datum/species/S = all_species[pref.species]
		pref.gender = next_in_list(pref.gender, valid_player_genders & S.default_genders)

		var/datum/category_item/player_setup_item/general/equipment/equipment_item = category.items[4]
		equipment_item.sanitize_character()	// sanitize equipment
		pref.update_preview_icon()
		return TOPIC_REFRESH

	else if(href_list["age"])
		var/new_age = input(user, "Choose your character's age:\n([pref.getMinAge()]-[pref.getMaxAge()])", "Character Preference", pref.age) as num|null
		if(new_age && CanUseTopic(user))
			pref.age = max(min(round(text2num(new_age)),  pref.getMaxAge()),pref.getMinAge())
			return TOPIC_REFRESH

	else if(href_list["spawnpoint"])
		var/list/spawnkeys = list()
		for(var/S in SSatlas.spawn_locations)
			spawnkeys += S
		var/choice = input(user, "Where would you like to spawn when late-joining?") as null|anything in spawnkeys
		if(!choice || !SSatlas.spawn_locations[choice] || !CanUseTopic(user))	return TOPIC_NOACTION
		pref.spawnpoint = choice
		return TOPIC_REFRESH

	else if(href_list["metadata"])
		var/new_metadata = sanitize(input(user, "Enter any information you'd like others to see, such as Roleplay-preferences:", "Game Preference" , pref.metadata) as message|null)
		if(new_metadata && CanUseTopic(user))
			pref.metadata = sanitize(new_metadata)
			return TOPIC_REFRESH

	return ..()

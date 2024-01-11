/datum/category_item/player_setup_item/general/basic
	name = "Basic"
	sort_order = 1

/datum/category_item/player_setup_item/general/basic/load_character(var/savefile/S)
	S["real_name"]  >> pref.real_name
	S["gender"]     >> pref.gender
	S["pronouns"]   >> pref.pronouns
	S["age"]        >> pref.age
	S["species"]    >> pref.species
	S["height"]		>> pref.height
	S["spawnpoint"] >> pref.spawnpoint
	S["OOC_Notes"]  >> pref.metadata
	S["floating_chat_color"] >> pref.floating_chat_color
	S["speech_bubble_type"] >> pref.speech_bubble_type
	if(istype(GLOB.all_species[pref.species], /datum/species/machine))
		S["ipc_tag_status"] >> pref.machine_tag_status
		S["ipc_serial_number"] >> pref.machine_serial_number
		S["ipc_ownership_status"] >> pref.machine_ownership_status

/datum/category_item/player_setup_item/general/basic/save_character(var/savefile/S)
	S["real_name"]  << pref.real_name
	S["gender"]     << pref.gender
	S["pronouns"]   << pref.pronouns
	S["age"]        << pref.age
	S["species"]    << pref.species
	S["height"]		<< pref.height
	S["spawnpoint"] << pref.spawnpoint
	S["OOC_Notes"]  << pref.metadata
	S["floating_chat_color"] << pref.floating_chat_color
	S["speech_bubble_type"] << pref.speech_bubble_type
	if(istype(GLOB.all_species[pref.species], /datum/species/machine))
		S["ipc_tag_status"] << pref.machine_tag_status
		S["ipc_serial_number"] << pref.machine_serial_number
		S["ipc_ownership_status"] << pref.machine_ownership_status

// if table_name and pref.var_name is different, then do it like
// "table_name" = "pref.var_name", as below
/datum/category_item/player_setup_item/general/basic/gather_load_query()
	return list(
		"ss13_characters" = list(
			"vars" = list(
				"name" = "real_name",
				"gender",
				"pronouns",
				"age",
				"metadata",
				"spawnpoint",
				"species",
				"height",
				"floating_chat_color",
				"speech_bubble_type"
			),
			"args" = list("id")
		),
		"ss13_characters_ipc_tags" = list(
			"vars" = list(
				"tag_status" = "machine_tag_status",
				"serial_number" = "machine_serial_number",
				"ownership_status" = "machine_ownership_status"
				),
			"args" = list("char_id")
		)
	)

// Generally, this doesn't USUALLY need changing
/datum/category_item/player_setup_item/general/basic/gather_load_parameters()
	return list(
			"id" = pref.current_character,
			"char_id" = pref.current_character
			)

// Only need to list the SQL table field names here
/datum/category_item/player_setup_item/general/basic/gather_save_query()
	return list(
		"ss13_characters" = list(
			"name",
			"gender",
			"pronouns",
			"age",
			"metadata",
			"spawnpoint",
			"species",
			"height",
			"floating_chat_color",
			"speech_bubble_type",
			"id" = 1,
			"ckey" = 1
		),
		"ss13_characters_ipc_tags" = list(
			"tag_status",
			"serial_number",
			"ownership_status",
			"char_id" = 1 // = 1 signifies argument
		)
	)

/datum/category_item/player_setup_item/general/basic/gather_save_parameters()
	return list(
		"name" = pref.real_name,
		"gender" = pref.gender,
		"pronouns" = pref.pronouns,
		"age" = pref.age,
		"metadata" = pref.metadata,
		"spawnpoint" = pref.spawnpoint,
		"species" = pref.species,
		"height" = pref.height,
		"tag_status" = pref.machine_tag_status,
		"serial_number" = pref.machine_serial_number,
		"ownership_status" = pref.machine_ownership_status,
		"id" = pref.current_character,
		"char_id" = pref.current_character,
		"floating_chat_color" = pref.floating_chat_color,
		"speech_bubble_type" = pref.speech_bubble_type,
		"ckey" = PREF_CLIENT_CKEY
	)

/datum/category_item/player_setup_item/general/basic/load_character_special()
	pref.can_edit_name = TRUE
	pref.can_edit_ipc_tag = TRUE

	if (GLOB.config.sql_saves && pref.current_character)
		if (!establish_db_connection(GLOB.dbcon))
			return

		// Called /after/ loading and /before/ sanitization.
		// So we have pref.current_character. It's just in text format.
		var/DBQuery/query = GLOB.dbcon.NewQuery("SELECT DATEDIFF(NOW(), created_at) AS DiffDate FROM ss13_characters WHERE id = :id:")
		query.Execute(list("id" = text2num(pref.current_character)))

		if (query.NextRow())
			if (text2num(query.item[1]) > 5)
				pref.can_edit_name = FALSE
				if(GLOB.config.ipc_timelock_active)
					pref.can_edit_ipc_tag = FALSE
		else
			log_world("ERROR: SQL CHARACTER LOAD: Logic error, general/basic/load_character_special() didn't return any rows when it should have. Character ID: [pref.current_character].")

/datum/category_item/player_setup_item/general/basic/sanitize_character()
	if(!pref.species)
		pref.species = SPECIES_HUMAN
	var/is_in_playable_species = FALSE
	for(var/thing in GLOB.playable_species)
		if(pref.species in GLOB.playable_species[thing])
			is_in_playable_species = TRUE
	if(!is_in_playable_species)
		pref.species = SPECIES_HUMAN

	pref.height		= sanitize_integer(text2num(pref.height), pref.getMinHeight(), pref.getMaxHeight(), 170)
	pref.age                = sanitize_integer(text2num(pref.age), pref.getMinAge(), pref.getMaxAge(), initial(pref.age))
	pref.gender             = sanitize_gender(pref.gender, pref.species)
	pref.pronouns           = sanitize_pronouns(pref.pronouns, pref.species, pref.gender)
	pref.real_name          = sanitize_name(pref.real_name, pref.species)
	if(!pref.real_name)
		pref.real_name      = random_name(pref.gender, pref.species)
	pref.spawnpoint         = sanitize_inlist(pref.spawnpoint, SSatlas.spawn_locations, initial(pref.spawnpoint))
	pref.machine_tag_status = text2num(pref.machine_tag_status) // SQL queries return as text, so make this a num
	pref.floating_chat_color = sanitize_hexcolor(pref.floating_chat_color, get_random_colour(0, 160, 230))
	var/datum/species/S = GLOB.all_species[pref.species]
	if(!pref.speech_bubble_type || !(pref.speech_bubble_type in S.possible_speech_bubble_types))
		if(istype(S))
			pref.speech_bubble_type = S.possible_speech_bubble_types[1]
		else
			pref.speech_bubble_type = "normal"

/datum/category_item/player_setup_item/general/basic/content(var/mob/user)
	var/list/dat = list("<b>Name:</b> ")
	if (pref.can_edit_name)
		dat += "<a href='?src=\ref[src];rename=1'><b>[pref.real_name]</b></a><br>"
	else
		dat += "<b>[pref.real_name]</b><br> (<a href='?src=\ref[src];namehelp=1'>?</a>)"
	if (pref.can_edit_name)
		dat += "(<a href='?src=\ref[src];random_name=1'>Random Name</A>)"
	dat += "<br>"
	dat += "<b>Sex:</b> <a href='?src=\ref[src];gender=1'><b>[capitalize(lowertext(pref.gender))]</b></a><br>"
	var/datum/species/S = GLOB.all_species[pref.species]
	if(length(S.selectable_pronouns))
		dat += "<b>Pronouns:</b> <a href='?src=\ref[src];pronouns=1'><b>[capitalize_first_letters(pref.pronouns)]</b></a><br>"
	dat += "<b>Age:</b> <a href='?src=\ref[src];age=1'>[pref.age]</a><br>"
	dat += "<b>Height:</b> <a href='?src=\ref[src];height=1'>[pref.height]</a><br>"
	dat += "<b>Spawn Point</b>: <a href='?src=\ref[src];spawnpoint=1'>[pref.spawnpoint]</a><br>"
	dat += "<b>Floating Chat Color:</b> <a href='?src=\ref[src];select_floating_chat_color=1'><b>[pref.floating_chat_color]</b></a><br>"
	dat += "<b>Speech Bubble Type:</b> <a href='?src=\ref[src];speech_bubble_type=1'><b>[capitalize_first_letters(pref.speech_bubble_type)]</b></a><br>"
	if(istype(S, /datum/species/machine))
		if(pref.can_edit_ipc_tag)
			dat += "<b>Has Tag:</b> <a href='?src=\ref[src];ipc_tag=1'>[pref.machine_tag_status ? "Yes" : "No"]</a><br>"
		else
			dat += "<b>Has Tag:</b> [pref.machine_tag_status ? "Yes" : "No"] (<a href='?src=\ref[src];namehelp=1'>?</a>)<br>"
		if(pref.machine_tag_status)
			if(!pref.machine_serial_number)
				var/generated_serial = uppertext(dd_limittext(md5(pref.real_name), 12))
				pref.machine_serial_number = generated_serial
			if(pref.can_edit_ipc_tag)
				dat += "<b>Serial Number:</b> <a href='?src=\ref[src];serial_number=1'>[pref.machine_serial_number]</a><br>"
				dat += "(<a href='?src=\ref[src];generate_serial=1'>Generate Serial Number</A>)<br>"
				dat += "<b>Ownership Status:</b> <a href='?src=\ref[src];ownership_status=1'>[pref.machine_ownership_status]</a><br>"
			else
				dat += "<b>Serial Number:</b> [pref.machine_serial_number] (<a href='?src=\ref[src];namehelp=1'>?</a>)<br>"
				dat += "<b>Ownership Status:</b> [pref.machine_ownership_status] (<a href='?src=\ref[src];namehelp=1'>?</a>)<br>"
	if(GLOB.config.allow_Metadata)
		dat += "<b>OOC Notes:</b> <a href='?src=\ref[src];metadata=1'> Edit </a><br>"

	. = dat.Join()

/datum/category_item/player_setup_item/general/basic/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["rename"])
		if (!pref.can_edit_name)
			alert(user, "You can no longer edit the name of your character.<br><br>If there is a legitimate need, please contact an administrator regarding the matter.")
			return TOPIC_NOACTION

		var/current_character = pref.current_character
		var/raw_name = input(user, "Choose your character's name:", "Character Name")  as text|null
		if(current_character != pref.current_character) //Without this, you can switch slots while the input menu is up to change your character's name past the grace period
			return
		if (!isnull(raw_name) && CanUseTopic(user))
			var/new_name = sanitize_name(raw_name, pref.species)
			if(new_name)
				if(new_name == pref.real_name)
					return TOPIC_NOACTION //If the name is the same do nothing
				if(GLOB.config.sql_saves)
					//Check if the player already has a character with the same name. (We dont have to account for the current char in that query, as that is already handled by the condition above)
					var/DBQuery/query = GLOB.dbcon.NewQuery("SELECT COUNT(*) FROM ss13_characters WHERE ckey = :ckey: and name = :char_name:")
					query.Execute(list("ckey" = user.client.ckey, "char_name" = new_name))
					query.NextRow()
					var/count = text2num(query.item[1])
					if(count > 0)
						to_chat(user, SPAN_WARNING("Invalid name. You have already used this name for another character. If you have deleted the character contact an admin to restore it."))
						return TOPIC_NOACTION

				pref.real_name = new_name
				return TOPIC_REFRESH
			else
				to_chat(user, SPAN_WARNING("Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and ."))
				return TOPIC_NOACTION

	else if(href_list["namehelp"])
		alert(user, "Due to game mechanics, you are no longer able to edit this information for this character. The grace period offered is 5 days since the character's initial save.\n\nIf you have a need to change the character's information, or further questions regarding this policy, please contact an administrator.")
		return TOPIC_NOACTION

	else if(href_list["random_name"])
		if (!pref.can_edit_name)
			alert(user, "You can no longer edit the name of your character.\n\nIf there is a legitimate need, please contact an administrator regarding the matter.")
			return TOPIC_NOACTION

		pref.real_name = random_name(pref.gender, pref.species)
		return TOPIC_REFRESH

	else if(href_list["select_floating_chat_color"])
		var/new_fc_color = input(user, "Choose Floating Chat Color:", "Global Preference") as color|null
		if(new_fc_color && CanUseTopic(user))
			pref.floating_chat_color = new_fc_color
			var/mob/living/carbon/human/H = preference_mob()
			if(ishuman(H))
				H.set_floating_chat_color(new_fc_color)
			return TOPIC_REFRESH

	else if(href_list["speech_bubble_type"])
		var/datum/species/S = GLOB.all_species[pref.species]
		pref.speech_bubble_type = next_in_list(pref.speech_bubble_type, S.possible_speech_bubble_types)
		return TOPIC_REFRESH

	else if(href_list["gender"])
		var/datum/species/S = GLOB.all_species[pref.species]
		pref.gender = next_in_list(pref.gender, GLOB.valid_player_genders & S.default_genders)
		pref.pronouns = pref.gender

		var/datum/category_item/player_setup_item/general/equipment/equipment_item = category.items[4]
		equipment_item.sanitize_character()	// sanitize equipment
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["pronouns"])
		var/datum/species/S = GLOB.all_species[pref.species]
		var/selectable_pronouns = list() // this only exists to uppercase the first letters, otherwise it is uggo
		for(var/pronoun in S.selectable_pronouns)
			selectable_pronouns += capitalize_first_letters(pronoun)
		var/new_pronouns = input(usr, "Select how your characters will appear to others when examined.", "Pronoun Selection") as null|anything in selectable_pronouns
		if(!new_pronouns)
			return
		pref.pronouns = lowertext(new_pronouns)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["age"])
		var/new_age = input(user, "Choose your character's age:\n([pref.getMinAge()]-[pref.getMaxAge()])", "Character Preference", pref.age) as num|null
		if(new_age && CanUseTopic(user))
			pref.age = max(min(round(text2num(new_age)),  pref.getMaxAge()),pref.getMinAge())
			return TOPIC_REFRESH

	else if(href_list["height"])
		var/datum/species/char_spec = GLOB.all_species[pref.species]
		var/new_height = input(user, "Choose your character's height: (Values in Centimetres. [char_spec.name] height range [pref.getMinHeight()] - [pref.getMaxHeight()])", "Character Preference", pref.height) as num|null
		if(new_height && CanUseTopic(user))
			pref.height = max(min(round(text2num(new_height)),  pref.getMaxHeight()),pref.getMinHeight())
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

	else if(href_list["ipc_tag"])
		if(!pref.can_edit_ipc_tag)
			to_chat(usr, SPAN_WARNING("You are unable to edit your IPC tag due to a timelock restriction. If you got here, it is either a hack or a bug."))
			return
		var/choice = alert(user, "Do you wish for your IPC to have a tag?\n\nWARNING: Being an untagged IPC in Tau space is highly illegal!", "IPC Tag", "Yes", "No")
		if(CanUseTopic(user))
			if(choice == "Yes")
				pref.machine_tag_status = TRUE
			else
				pref.machine_tag_status = FALSE
			return TOPIC_REFRESH

	else if(href_list["serial_number"])
		if(!pref.can_edit_ipc_tag)
			to_chat(usr, SPAN_WARNING("You are unable to edit your IPC tag due to a timelock restriction. If you got here, it is either a hack or a bug."))
			return
		var/new_serial_number = sanitize(input(user, "Enter what you want to set your serial number to.", "IPC Serial Number", pref.machine_serial_number) as message|null)
		new_serial_number = uppertext(dd_limittext(new_serial_number, 12))
		if(new_serial_number && CanUseTopic(user))
			pref.machine_serial_number = sanitize(new_serial_number)
			return TOPIC_REFRESH

	else if(href_list["generate_serial"])
		if(!pref.can_edit_ipc_tag)
			to_chat(usr, SPAN_WARNING("You are unable to edit your IPC tag due to a timelock restriction. If you got here, it is either a hack or a bug."))
			return
		if(pref.real_name)
			var/generated_serial = uppertext(dd_limittext(md5(pref.real_name), 12))
			pref.machine_serial_number = generated_serial
			return TOPIC_REFRESH

	else if(href_list["ownership_status"])
		if(!pref.can_edit_ipc_tag)
			to_chat(usr, SPAN_WARNING("You are unable to edit your IPC tag due to a timelock restriction. If you got here, it is either a hack or a bug."))
			return
		var/static/list/ownership_options = list(IPC_OWNERSHIP_COMPANY, IPC_OWNERSHIP_PRIVATE, IPC_OWNERSHIP_SELF)
		var/new_ownership_status = input(user, "Choose your IPC's ownership status.", "IPC Ownership Status") as null|anything in ownership_options
		if(new_ownership_status && CanUseTopic(user))
			pref.machine_ownership_status = new_ownership_status
			return TOPIC_REFRESH

	return ..()

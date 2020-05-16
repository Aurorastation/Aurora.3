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
	if(istype(all_species[pref.species], /datum/species/machine))
		S["ipc_tag_status"] >> pref.machine_tag_status
		S["ipc_serial_number"] >> pref.machine_serial_number
		S["ipc_ownership_status"] >> pref.machine_ownership_status

/datum/category_item/player_setup_item/general/basic/save_character(var/savefile/S)
	S["real_name"]  << pref.real_name
	S["gender"]     << pref.gender
	S["age"]        << pref.age
	S["species"]    << pref.species
	S["spawnpoint"] << pref.spawnpoint
	S["OOC_Notes"]  << pref.metadata
	if(istype(all_species[pref.species], /datum/species/machine))
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
				"age",
				"metadata",
				"spawnpoint",
				"species"
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
			"age",
			"metadata",
			"spawnpoint",
			"species",
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
		"age" = pref.age,
		"metadata" = pref.metadata,
		"spawnpoint" = pref.spawnpoint,
		"species" = pref.species,
		"tag_status" = pref.machine_tag_status,
		"serial_number" = pref.machine_serial_number,
		"ownership_status" = pref.machine_ownership_status,
		"id" = pref.current_character,
		"char_id" = pref.current_character,
		"ckey" = PREF_CLIENT_CKEY
	)

/datum/category_item/player_setup_item/general/basic/load_special()
	pref.can_edit_name = TRUE
	pref.can_edit_ipc_tag = TRUE

	if (config.sql_saves && pref.current_character)
		if (!establish_db_connection(dbcon))
			return

		// Called /after/ loading and /before/ sanitization.
		// So we have pref.current_character. It's just in text format.
		var/DBQuery/query = dbcon.NewQuery("SELECT DATEDIFF(NOW(), created_at) AS DiffDate FROM ss13_characters WHERE id = :id:")
		query.Execute(list("id" = text2num(pref.current_character)))

		if (query.NextRow())
			if (text2num(query.item[1]) > 5)
				pref.can_edit_name = FALSE
				if(config.ipc_timelock_active)
					pref.can_edit_ipc_tag = FALSE
		else
			error("SQL CHARACTER LOAD: Logic error, general/basic/load_special() didn't return any rows when it should have.")
			log_debug("SQL CHARACTER LOAD: Logic error, general/basic/load_special() didn't return any rows when it should have. Character ID: [pref.current_character].")

/datum/category_item/player_setup_item/general/basic/sanitize_character()
	if(!pref.species || !(pref.species in playable_species))
		pref.species = "Human"

	pref.age                = sanitize_integer(text2num(pref.age), pref.getMinAge(), pref.getMaxAge(), initial(pref.age))
	pref.gender             = sanitize_gender(pref.gender, pref.species)
	pref.real_name          = sanitize_name(pref.real_name, pref.species)
	if(!pref.real_name)
		pref.real_name      = random_name(pref.gender, pref.species)
	pref.spawnpoint         = sanitize_inlist(pref.spawnpoint, SSatlas.spawn_locations, initial(pref.spawnpoint))
	pref.machine_tag_status = text2num(pref.machine_tag_status) // SQL queries return as text, so make this a num

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
	if(istype(all_species[pref.species], /datum/species/machine))
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
		alert(user, "Due to game mechanics, you are no longer able to edit this information for this character. The grace period offered is 5 days since the character's initial save.\n\nIf you have a need to change the character's information, or further questions regarding this policy, please contact an administrator.")
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

/datum/category_item/player_setup_item/general/background
	name = "Background"
	sort_order = 5

/datum/category_item/player_setup_item/general/background/load_special(var/savefile/S)
	log_debug("Call 1")

	//Special Aurora Snowflake to load in the ccia actions and persistant incidents
	if (config.sql_saves) // Doesnt work without db
		log_debug("Call 2")
		//Load in the CCIA Actions
		var/DBQuery/ccia_action_query = dbcon.NewQuery({"SELECT
			act.title,
			act.type,
			act.issuedby,
			act.details,
			act.url,
			act.expires_at
		FROM ss13_ccia_action_char act_chr
			JOIN ss13_characters chr ON act_chr.char_id = chr.id
			JOIN ss13_ccia_actions act ON act_chr.action_id = act.id
		WHERE
			act_chr.char_id = ':char_id' AND
			(act.expires_at IS NULL OR act.expires_at >= CURRENT_DATE()) AND
				act.deleted_at IS NULL;
		"})
		if (!ccia_action_query.Execute(list(":char_id" = pref.current_character)))
			error("Error CCIA Actions for character #[pref.current_character]. SQL error message: '[ccia_action_query.ErrorMsg()]'.")

		log_debug("Call 3")
		while(ccia_action_query.NextRow())
			log_debug("Call 4")
			var/list/action = list(
				ccia_action_query.item[1],
				ccia_action_query.item[2],
				ccia_action_query.item[3],
				ccia_action_query.item[4],
				ccia_action_query.item[5],
				ccia_action_query.item[6]
			)
			pref.ccia_actions.Add(list(action))

		log_debug("Call 5")
		//Load in the infractions
		var/DBQuery/char_infraction_query = dbcon.NewQuery({"SELECT
			id, char_id, UID, datetime, notes, charges, evidence, arbiters, brig_sentence, fine, felony
		FROM ss13_character_infractions
		WHERE
			char_id = ':char_id'
		"})
		char_infraction_query.Execute(list(":char_id" = pref.current_character))

		while(char_infraction_query.NextRow())
			log_debug("Call 6")
			var/datum/char_infraction/infraction = new()
			infraction.db_id = text2num(char_infraction_query.item[1])
			infraction.char_id = text2num(char_infraction_query.item[2])
			infraction.UID = char_infraction_query.item[3]
			infraction.datetime = char_infraction_query.item[4]
			infraction.notes = char_infraction_query.item[5]
			infraction.charges = json_decode(char_infraction_query.item[6])
			infraction.evidence = json_decode(char_infraction_query.item[7])
			infraction.arbiters = json_decode(char_infraction_query.item[8])
			infraction.brig_sentence = text2num(char_infraction_query.item[9])
			infraction.fine = text2num(char_infraction_query.item[10])
			infraction.felony = text2num(char_infraction_query.item[11])
			pref.incidents.Add(infraction)
			log_debug("Added infraction with [infraction.UID]")
		log_debug("Call 7")

/datum/category_item/player_setup_item/general/background/load_character(var/savefile/S)
	S["med_record"]				>> pref.med_record
	S["sec_record"]				>> pref.sec_record
	S["gen_record"]				>> pref.gen_record
	S["home_system"]			>> pref.home_system
	S["citizenship"]			>> pref.citizenship
	S["faction"]				>> pref.faction
	S["religion"]				>> pref.religion
	S["nanotrasen_relation"]	>> pref.nanotrasen_relation

/datum/category_item/player_setup_item/general/background/save_character(var/savefile/S)
	S["med_record"]				<< pref.med_record
	S["sec_record"]				<< pref.sec_record
	S["gen_record"]				<< pref.gen_record
	S["home_system"]			<< pref.home_system
	S["citizenship"]			<< pref.citizenship
	S["faction"]				<< pref.faction
	S["religion"]				<< pref.religion
	S["nanotrasen_relation"]	<< pref.nanotrasen_relation

/datum/category_item/player_setup_item/general/background/gather_load_query()
	return list("ss13_characters_flavour" = list("vars" = list("records_employment" = "gen_record",
																"records_medical" = "med_record",
																"records_security" = "sec_record",
																"records_ccia" = "ccia_record"),
												"args" = list("char_id")),
				"ss13_characters" = list("vars" = list("home_system", "citizenship", "faction", "religion"), "args" = list("id")))

/datum/category_item/player_setup_item/general/background/gather_load_parameters()
	return list(":id" = pref.current_character, ":char_id" = pref.current_character)

/datum/category_item/player_setup_item/general/background/gather_save_query()
	return list("ss13_characters_flavour" = list("records_employment",
												 "records_medical",
												 "records_security",
												 "char_id" = 1),
				"ss13_characters" = list("home_system", "citizenship", "faction", "religion", "id" = 1))

/datum/category_item/player_setup_item/general/background/gather_save_parameters()
	return list(":records_employment" = pref.gen_record,
				":records_medical" = pref.med_record,
				":records_security" = pref.sec_record,
				":char_id" = pref.current_character,
				":home_system" = pref.home_system,
				":citizenship" = pref.citizenship,
				":faction" = pref.faction,
				":religion" = pref.religion,
				":id" = pref.current_character)

/datum/category_item/player_setup_item/general/background/sanitize_character()
	if(!pref.home_system)
		pref.home_system	= "Unset"
	if(!pref.citizenship)
		pref.citizenship	= "None"
	if(!pref.faction)
		pref.faction		= "None"
	if(!pref.religion)
		pref.religion		= "None"

	pref.nanotrasen_relation = sanitize_inlist(pref.nanotrasen_relation, COMPANY_ALIGNMENTS, initial(pref.nanotrasen_relation))

/datum/category_item/player_setup_item/general/background/content(var/mob/user)
	. += "<b>Background Information</b><br>"
	. += "[company_name] Relation: <a href='?src=\ref[src];nt_relation=1'>[pref.nanotrasen_relation]</a><br/>"
	. += "Home System: <a href='?src=\ref[src];home_system=1'>[pref.home_system]</a><br/>"
	. += "Citizenship: <a href='?src=\ref[src];citizenship=1'>[pref.citizenship]</a><br/>"
	. += "Faction: <a href='?src=\ref[src];faction=1'>[pref.faction]</a><br/>"
	. += "Religion: <a href='?src=\ref[src];religion=1'>[pref.religion]</a><br/>"

	. += "<br/><b>Records</b>:<br/>"
	if(jobban_isbanned(user, "Records"))
		. += "<span class='danger'>You are banned from using character records.</span><br>"
	else
		. += "Medical Records:<br>"
		. += "<a href='?src=\ref[src];set_medical_records=1'>[TextPreview(pref.med_record,40)]</a><br><br>"
		. += "Employment Records:<br>"
		. += "<a href='?src=\ref[src];set_general_records=1'>[TextPreview(pref.gen_record,40)]</a><br><br>"
		. += "Security Records:<br>"
		. += "<a href='?src=\ref[src];set_security_records=1'>[TextPreview(pref.sec_record,40)]</a><br>"

/datum/category_item/player_setup_item/general/background/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["nt_relation"])
		var/new_relation = input(user, "Choose your relation to NT. Note that this represents what others can find out about your character by researching your background, not what your character actually thinks.", "Character Preference", pref.nanotrasen_relation)  as null|anything in COMPANY_ALIGNMENTS
		if(new_relation && CanUseTopic(user))
			pref.nanotrasen_relation = new_relation
			return TOPIC_REFRESH

	else if(href_list["home_system"])
		var/choice = input(user, "Please choose a home system.", "Character Preference", pref.home_system) as null|anything in home_system_choices + list("Unset","Other")
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		if(choice == "Other")
			var/raw_choice = sanitize(input(user, "Please enter a home system.", "Character Preference")  as text|null, MAX_NAME_LEN)
			if(raw_choice && CanUseTopic(user))
				pref.home_system = raw_choice
		else
			pref.home_system = choice
		return TOPIC_REFRESH

	else if(href_list["citizenship"])
		var/choice = input(user, "Please choose your current citizenship.", "Character Preference", pref.citizenship) as null|anything in citizenship_choices + list("None","Other")
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		if(choice == "Other")
			var/raw_choice = sanitize(input(user, "Please enter your current citizenship.", "Character Preference") as text|null, MAX_NAME_LEN)
			if(raw_choice && CanUseTopic(user))
				pref.citizenship = raw_choice
		else
			pref.citizenship = choice
		return TOPIC_REFRESH

	else if(href_list["faction"])
		var/choice = input(user, "Please choose a faction to work for.", "Character Preference", pref.faction) as null|anything in faction_choices + list("None","Other")
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		if(choice == "Other")
			var/raw_choice = sanitize(input(user, "Please enter a faction.", "Character Preference")  as text|null, MAX_NAME_LEN)
			if(raw_choice)
				pref.faction = raw_choice
		else
			pref.faction = choice
		return TOPIC_REFRESH

	else if(href_list["religion"])
		var/choice = input(user, "Please choose a religion.", "Character Preference", pref.religion) as null|anything in religion_choices + list("None","Other")
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		if(choice == "Other")
			var/raw_choice = sanitize(input(user, "Please enter a religon.", "Character Preference")  as text|null, MAX_NAME_LEN)
			if(raw_choice)
				pref.religion = sanitize(raw_choice)
		else
			pref.religion = choice
		return TOPIC_REFRESH

	else if(href_list["set_medical_records"])
		var/new_medical = sanitize(input(user,"Enter medical information here.","Character Preference", html_decode(pref.med_record)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		if(!isnull(new_medical) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.med_record = new_medical
		return TOPIC_REFRESH

	else if(href_list["set_general_records"])
		var/new_general = sanitize(input(user,"Enter employment information here.","Character Preference", html_decode(pref.gen_record)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		if(!isnull(new_general) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.gen_record = new_general
		return TOPIC_REFRESH

	else if(href_list["set_security_records"])
		var/sec_medical = sanitize(input(user,"Enter security information here.","Character Preference", html_decode(pref.sec_record)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		if(!isnull(sec_medical) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.sec_record = sec_medical
		return TOPIC_REFRESH

	return ..()

/datum/category_item/player_setup_item/other/incidents
	name = "Incidents"
	sort_order = 7

/datum/category_item/player_setup_item/other/incidents/load_character_special(var/savefile/S)
	pref.incidents = list()
	pref.ccia_actions = list()

	//Special Aurora Snowflake to load in the ccia actions and persistant incidents
	if (GLOB.config.sql_saves) // Doesnt work without db
		//Load in the CCIA Actions
		var/DBQuery/ccia_action_query = GLOB.dbcon.NewQuery({"SELECT
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
			act_chr.char_id = :char_id: AND
			(act.expires_at IS NULL OR act.expires_at >= CURRENT_DATE()) AND
				act.deleted_at IS NULL;
		"})
		if (!ccia_action_query.Execute(list("char_id" = pref.current_character)))
			log_world("ERROR: Error CCIA Actions for character #[pref.current_character]. SQL error message: '[ccia_action_query.ErrorMsg()]'.")

		while(ccia_action_query.NextRow())
			var/list/action = list(
				ccia_action_query.item[1],
				ccia_action_query.item[2],
				ccia_action_query.item[3],
				ccia_action_query.item[4],
				ccia_action_query.item[5],
				ccia_action_query.item[6]
			)
			pref.ccia_actions.Add(list(action))

		//Load in the infractions
		var/DBQuery/char_infraction_query = GLOB.dbcon.NewQuery({"SELECT
			id, char_id, UID, datetime, notes, charges, evidence, arbiters, brig_sentence, fine, felony
		FROM ss13_character_incidents
		WHERE
			char_id = :char_id: AND deleted_at IS NULL
		"})
		char_infraction_query.Execute(list("char_id" = pref.current_character))

		while(char_infraction_query.NextRow())
			var/datum/record/char_infraction/infraction = new()
			infraction.db_id = text2num(char_infraction_query.item[1])
			infraction.char_id = text2num(char_infraction_query.item[2])
			infraction.id = char_infraction_query.item[3]
			infraction.datetime = char_infraction_query.item[4]
			infraction.notes = char_infraction_query.item[5]
			infraction.charges = json_decode(char_infraction_query.item[6])
			infraction.evidence = json_decode(char_infraction_query.item[7])
			infraction.arbiters = json_decode(char_infraction_query.item[8])
			infraction.brig_sentence = text2num(char_infraction_query.item[9])
			infraction.fine = text2num(char_infraction_query.item[10])
			infraction.felony = text2num(char_infraction_query.item[11])
			pref.incidents.Add(infraction)

/datum/category_item/player_setup_item/other/incidents/ui_data(mob/user)
	var/list/sections = list()
	for (var/In in pref.incidents)
		var/datum/record/char_infraction/I = In
		var/list/fields = list(
			list("label" = "UID", "value" = I.id),
			list("label" = "Date / Time", "value" = I.datetime),
			list("label" = "Charges", "value" = english_list(I.charges))
		)
		if (I.fine == 0)
			fields += list(list("label" = "Brig Sentence", "value" = I.getBrigSentence()))
		else
			fields += list(list("label" = "Fine", "value" = "[I.fine]电"))
		fields += list(list(
			"label" = "Notes",
			"value" = I.notes != "" ? strip_html_readd_newlines(I.notes) : "No summary entered.",
			"actions" = list(
				list("label" = "Show Details", "action" = "details_sec_incident", "value" = I.db_id, "icon" = "up-right-from-square"),
				list("label" = "Delete Incident", "action" = "del_sec_incident", "value" = I.db_id, "color" = "bad", "icon" = "trash")
			)
		))
		sections += list(list("title" = "Incident [I.id]", "fields" = fields))
	if(!length(sections))
		sections += list(list("description" = "No incidents are on file for this character.", "fields" = list()))
	return list(
		"kind" = "form",
		"name" = name,
		"ref" = REF(src),
		"sections" = sections
	)

/datum/category_item/player_setup_item/other/incidents/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["del_sec_incident"])
		var/search_incident = text2num(href_list["del_sec_incident"])
		var/confirm = alert(user,"Do you want to delete that incident ?","Delete Incident","Yes","No")

		if(!search_incident || !CanUseTopic(user) || confirm == "No")
			return TOPIC_NOACTION

		for(var/In in pref.incidents)
			var/datum/record/char_infraction/I = In
			if(I.db_id == search_incident && I.char_id == pref.current_character)
				I.deleteFromDB("user")
				qdel(I)
				return TOPIC_REFRESH

	else if(href_list["details_sec_incident"])
		if(!CanUseTopic(user))
			return TOPIC_NOACTION

		var/list/params = list("location" = "security_incident", "incident" = href_list["details_sec_incident"])
		usr.client.process_webint_link("interface/login/sso_server", list2params(params))

	return ..()

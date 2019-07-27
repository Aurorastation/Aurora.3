/datum/category_item/player_setup_item/other/incidents
	name = "Incidents"
	sort_order = 7

/datum/category_item/player_setup_item/other/incidents/load_special(var/savefile/S)
	pref.incidents = list()
	pref.ccia_actions = list()

	//Special Aurora Snowflake to load in the ccia actions and persistant incidents
	if (config.sql_saves) // Doesnt work without db
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
			act_chr.char_id = :char_id: AND
			(act.expires_at IS NULL OR act.expires_at >= CURRENT_DATE()) AND
				act.deleted_at IS NULL;
		"})
		if (!ccia_action_query.Execute(list("char_id" = pref.current_character)))
			error("Error CCIA Actions for character #[pref.current_character]. SQL error message: '[ccia_action_query.ErrorMsg()]'.")

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
		var/DBQuery/char_infraction_query = dbcon.NewQuery({"SELECT
			id, char_id, UID, datetime, notes, charges, evidence, arbiters, brig_sentence, fine, felony
		FROM ss13_character_incidents
		WHERE
			char_id = :char_id: AND deleted_at IS NULL
		"})
		char_infraction_query.Execute(list("char_id" = pref.current_character))

		while(char_infraction_query.NextRow())
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

/datum/category_item/player_setup_item/other/incidents/content(mob/user)
	var/list/dat = list(
		"<b>Incident Information</b><br>",
		"The following incidents are on file for your character<br>"
	)
	for (var/datum/char_infraction/I in pref.incidents)
		dat += "<hr>"
		dat += "UID: [I.UID]<br>"
		dat += "Date/Time: [I.datetime]<br>"
		dat += "Charges: "
		for (var/L in I.charges)
			dat += "[L], "
		if (I.fine == 0)
			dat += "<br>Brig Sentence: [I.getBrigSentence()] <br>"
		else
			dat += "Fine: [I.fine] Credits<br>"
		dat += "Notes: <br>"
		if (I.notes != "")
			dat += nl2br(I.notes)
		else
			dat += "- No Summary Entered -"
		dat += "<br><a href='?src=\ref[src];details_sec_incident=[I.db_id]'>Show Details</a><br><a href='?src=\ref[src];del_sec_incident=[I.db_id]'>Delete Incident</a>"

	. = dat.Join()

/datum/category_item/player_setup_item/other/incidents/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["del_sec_incident"])
		var/search_incident = text2num(href_list["del_sec_incident"])
		var/confirm = alert(user,"Do you want to delete that incident ?","Delete Incident","Yes","No")

		if(!search_incident || !CanUseTopic(user) || confirm == "No")
			return TOPIC_NOACTION

		for(var/datum/char_infraction/I in pref.incidents)
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

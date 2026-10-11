/datum/category_item/player_setup_item/other/incidents
	name = "Incidents"
	sort_order = 7
	var/list/datum/record/record_comment/comment_results = list()
	var/comments_character_id
	var/comments_page = 1
	var/comments_total = 0
	var/comments_loading = FALSE
	var/comments_error = FALSE
	var/comments_request_id = 0

/datum/category_item/player_setup_item/other/incidents/Destroy()
	QDEL_LIST(comment_results)
	return ..()

/datum/category_item/player_setup_item/other/incidents/load_character_special(var/savefile/S)
	pref.incidents = list()
	pref.ccia_actions = list()
	QDEL_LIST(comment_results)
	comment_results = list()
	comments_character_id = null
	comments_page = 1
	comments_total = 0
	comments_loading = FALSE
	comments_error = FALSE
	comments_request_id++

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
	if(GLOB.config.sql_saves && pref.current_character && comments_character_id != pref.current_character && !comments_loading)
		request_comment_page(1)

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
	if(!length(pref.incidents))
		sections += list(list("description" = "No incidents are on file for this character.", "fields" = list()))

	for(var/datum/record/record_comment/record_comment in comment_results)
		var/list/comment_fields = list(
			list("label" = "Department", "value" = capitalize(record_comment.record_type)),
			list("label" = "Created", "value" = record_comment.created_at),
			list(
				"label" = "Comment",
				"value" = strip_html_readd_newlines(html_decode(record_comment.comment))
			)
		)
		if(record_comment.updated_at)
			comment_fields += list(list("label" = "Last Edited", "value" = record_comment.updated_at))
		comment_fields += list(list(
			"label" = "Manage",
			"value" = "",
			"actions" = list(
				list("label" = "Edit Comment", "action" = "edit_record_comment", "value" = record_comment.db_id, "icon" = "pen"),
				list("label" = "Delete Comment", "action" = "delete_record_comment", "value" = record_comment.db_id, "color" = "bad", "icon" = "trash")
			)
		))
		sections += list(list(
			"title" = "[capitalize(record_comment.record_type)] Record Comment",
			"fields" = comment_fields
		))
	if(comments_loading)
		sections += list(list("description" = "Loading record comments...", "fields" = list()))
	else if(comments_error)
		sections += list(list(
			"description" = "Record comments could not be loaded.",
			"fields" = list(list(
				"label" = "Comments",
				"value" = "Unavailable",
				"actions" = list(list("label" = "Retry", "action" = "record_comments_page", "value" = comments_page, "icon" = "rotate"))
			))
		))
	else if(!length(comment_results))
		sections += list(list("description" = "No record comments are on file for this character.", "fields" = list()))
	if(!comments_loading && comments_total)
		var/total_pages = max(1, CEILING(comments_total, RECORD_COMMENT_PAGE_SIZE) / RECORD_COMMENT_PAGE_SIZE)
		var/list/page_actions = list()
		if(comments_page > 1)
			page_actions += list(list("label" = "Previous", "action" = "record_comments_page", "value" = comments_page - 1, "icon" = "chevron-left"))
		if(comments_page < total_pages)
			page_actions += list(list("label" = "Next", "action" = "record_comments_page", "value" = comments_page + 1, "icon" = "chevron-right"))
		sections += list(list(
			"title" = "Record Comment Pages",
			"fields" = list(list(
				"label" = "Page",
				"value" = "[comments_page] of [total_pages] ([comments_total] comments)",
				"actions" = page_actions
			))
		))
	return list(
		"kind" = "form",
		"name" = name,
		"ref" = REF(src),
		"sections" = sections
	)

/datum/category_item/player_setup_item/other/incidents/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["record_comments_page"])
		var/new_page = text2num(href_list["record_comments_page"])
		if(new_page >= 1 && !comments_loading)
			request_comment_page(new_page)
		return TOPIC_REFRESH

	if(href_list["edit_record_comment"])
		if(!CanUseTopic(user))
			return TOPIC_NOACTION
		var/edit_comment_db_id = text2num(href_list["edit_record_comment"])
		var/datum/record/record_comment/edit_comment = find_record_comment(edit_comment_db_id)
		if(!edit_comment)
			return TOPIC_NOACTION
		var/comment_text = tgui_input_text(user, "Edit this comment.", "[capitalize(edit_comment.record_type)] Record Comment", default = html_decode(edit_comment.comment), multiline = TRUE, encode = FALSE)
		comment_text = sanitize(comment_text, MAX_MESSAGE_LEN, encode = 0, extra = 0)
		if(!comment_text || !CanUseTopic(user) || edit_comment != find_record_comment(edit_comment_db_id))
			return TOPIC_NOACTION
		var/old_comment = edit_comment.comment
		var/old_updated_by = edit_comment.updated_by
		edit_comment.comment = comment_text
		edit_comment.updated_by = user.ckey
		if(!edit_comment.save_to_db())
			edit_comment.comment = old_comment
			edit_comment.updated_by = old_updated_by
			to_chat(user, SPAN_WARNING("The comment could not be saved to the persistent database."))
			return TOPIC_NOACTION
		request_comment_page(comments_page)
		return TOPIC_REFRESH

	if(href_list["delete_record_comment"])
		var/delete_comment_db_id = text2num(href_list["delete_record_comment"])
		var/datum/record/record_comment/delete_comment = find_record_comment(delete_comment_db_id)
		if(!delete_comment || tgui_alert(user, "Delete this record comment?", "Delete Comment", list("Cancel", "Delete")) != "Delete")
			return TOPIC_NOACTION
		if(!CanUseTopic(user) || delete_comment != find_record_comment(delete_comment_db_id))
			return TOPIC_NOACTION
		if(!delete_comment.delete_from_db(user.ckey))
			to_chat(user, SPAN_WARNING("The comment could not be deleted from the persistent database."))
			return TOPIC_NOACTION
		comment_results -= delete_comment
		qdel(delete_comment)
		comments_total = max(0, comments_total - 1)
		request_comment_page(comments_page)
		return TOPIC_REFRESH

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

/datum/category_item/player_setup_item/other/incidents/proc/request_comment_page(var/page)
	if(!GLOB.config.sql_saves || !pref.current_character)
		return
	comments_loading = TRUE
	comments_error = FALSE
	comments_character_id = pref.current_character
	comments_request_id++
	QDEL_LIST(comment_results)
	comment_results = list()
	INVOKE_ASYNC(src, PROC_REF(async_load_comment_page), comments_character_id, page, comments_request_id)

/datum/category_item/player_setup_item/other/incidents/proc/find_record_comment(var/comment_db_id)
	for(var/datum/record/record_comment/record_comment in comment_results)
		if(record_comment.db_id == comment_db_id && record_comment.char_id == pref.current_character)
			return record_comment

/datum/category_item/player_setup_item/other/incidents/proc/async_load_comment_page(var/character_id, var/page, var/request_id)
	var/list/result = load_record_comment_page(character_id, null, page)
	if(request_id != comments_request_id || character_id != pref.current_character)
		var/list/stale_comments = result["comments"]
		QDEL_LIST(stale_comments)
		return
	QDEL_LIST(comment_results)
	comment_results = result["comments"]
	comments_page = result["page"]
	comments_total = result["total"]
	comments_error = result["error"]
	comments_loading = FALSE
	SStgui.update_uis(pref)

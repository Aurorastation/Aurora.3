/datum/tgui_module/arc_management_panel
	var/selected_arc_id = null
	var/const/MAX_ARC_NAME_LENGTH = 64
	var/const/MAX_ARC_DESCRIPTION_LENGTH = 512
	var/const/MAX_ARC_DECISION_LENGTH = 128
	var/const/MAX_ARC_RESULT_LENGTH = 512

/datum/tgui_module/arc_management_panel/ui_interact(mob/user, datum/tgui/ui)
	if(!check_rights(R_ADMIN, TRUE, user))
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ArcManagement", "Arc Management", 1100, 760)
		ui.open()

/datum/tgui_module/arc_management_panel/ui_data(mob/user)
	var/list/data = list()
	var/list/arcs = get_arcs()
	var/active_arc_id = get_active_arc_id()

	if(!selected_arc_id && length(arcs))
		selected_arc_id = arcs[1]["id"]

	data["arcs"] = arcs
	data["active_arc_id"] = active_arc_id
	data["selected_arc_id"] = selected_arc_id
	data["decisions"] = selected_arc_id ? get_decisions(selected_arc_id) : list()
	data["is_admin"] = check_rights(R_ADMIN, FALSE, user)

	return data

/datum/tgui_module/arc_management_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(!check_rights(R_ADMIN, TRUE, ui.user))
		return FALSE

	switch(action)
		if("refresh")
			return TRUE

		if("select_arc")
			selected_arc_id = text2num(params["arc_id"])
			return TRUE

		if("add_arc")
			var/name = trim(sanitizeSafe(params["name"]))
			var/description = trim(sanitizeSafe(params["description"]))
			if(!length(name) || !length(description))
				to_chat(ui.user, SPAN_WARNING("Arc name and description are required."))
				return FALSE
			if(length(name) > MAX_ARC_NAME_LENGTH)
				to_chat(ui.user, SPAN_WARNING("Arc name cannot exceed [MAX_ARC_NAME_LENGTH] characters."))
				return FALSE
			if(length(description) > MAX_ARC_DESCRIPTION_LENGTH)
				to_chat(ui.user, SPAN_WARNING("Arc description cannot exceed [MAX_ARC_DESCRIPTION_LENGTH] characters."))
				return FALSE
			if(get_active_arc_id())
				to_chat(ui.user, SPAN_WARNING("An arc is already active. Finish the active arc before creating a new one."))
				return FALSE
			if(!SSdbcore.Connect())
				to_chat(ui.user, SPAN_WARNING("Database connection unavailable."))
				return FALSE
			var/confirm = tgui_alert(ui.user, "This arc will start immediately and cannot be changed after it is created.", "Confirm Arc Creation", list("Confirm", "Cancel"))
			if(confirm != "Confirm")
				return FALSE
			var/datum/db_query/insert_query = SSdbcore.NewQuery(
				"INSERT INTO ss13_arcs (name, description, started_at, finished_at, ckey) VALUES (:name, :description, NOW(), NULL, :ckey)",
				list("name" = name, "description" = description, "ckey" = ui.user?.ckey || "MISSING")
			)
			insert_query.Execute()
			qdel(insert_query)
			log_admin("[key_name(ui.user)] created arc '[name]' ([description])")
			var/datum/db_query/select_query = SSdbcore.NewQuery("SELECT id FROM ss13_arcs WHERE name = :name AND description = :description ORDER BY id DESC LIMIT 1", list("name" = name, "description" = description))
			select_query.Execute()
			if(select_query.NextRow())
				selected_arc_id = text2num(select_query.item[1])
			qdel(select_query)
			return TRUE

		if("start_arc")
			var/arc_id = text2num(params["arc_id"])
			if(!arc_id)
				return FALSE
			var/active_arc_id = get_active_arc_id()
			if(active_arc_id && active_arc_id != arc_id)
				to_chat(ui.user, SPAN_WARNING("An arc is already active. Finish the active arc before starting a new one."))
				return FALSE
			if(!SSdbcore.Connect())
				to_chat(ui.user, SPAN_WARNING("Database connection unavailable."))
				return FALSE
			var/datum/db_query/start_query = SSdbcore.NewQuery(
				"UPDATE ss13_arcs SET started_at = NOW(), finished_at = NULL WHERE id = :id",
				list("id" = arc_id)
			)
			start_query.Execute()
			qdel(start_query)
			selected_arc_id = arc_id
			return TRUE

		if("finish_arc")
			var/arc_id = text2num(params["arc_id"])
			if(!arc_id)
				return FALSE
			if(!SSdbcore.Connect())
				to_chat(ui.user, SPAN_WARNING("Database connection unavailable."))
				return FALSE
			var/datum/db_query/finish_query = SSdbcore.NewQuery(
				"UPDATE ss13_arcs SET finished_at = NOW() WHERE id = :id AND finished_at IS NULL",
				list("id" = arc_id)
			)
			finish_query.Execute()
			qdel(finish_query)
			selected_arc_id = arc_id
			return TRUE

		if("add_decision")
			var/arc_id = text2num(params["arc_id"])
			var/decision = trim(sanitizeSafe(params["decision"]))
			var/result = trim(sanitizeSafe(params["result"]))
			if(!arc_id || !length(decision) || !length(result))
				to_chat(ui.user, SPAN_WARNING("Both a decision and a result are required."))
				return FALSE
			if(length(decision) > MAX_ARC_DECISION_LENGTH)
				to_chat(ui.user, SPAN_WARNING("Decision cannot exceed [MAX_ARC_DECISION_LENGTH] characters."))
				return FALSE
			if(length(result) > MAX_ARC_RESULT_LENGTH)
				to_chat(ui.user, SPAN_WARNING("Result cannot exceed [MAX_ARC_RESULT_LENGTH] characters."))
				return FALSE
			if(!SSdbcore.Connect())
				to_chat(ui.user, SPAN_WARNING("Database connection unavailable."))
				return FALSE
			var/confirm = tgui_alert(ui.user, "This arc decision cannot be edited after it is created.", "Confirm Arc Decision", list("Confirm", "Cancel"))
			if(confirm != "Confirm")
				return FALSE
			var/datum/db_query/insert_query = SSdbcore.NewQuery(
				"INSERT INTO ss13_arc_decisions (arc_id, decision, result, created_at, game_id, ckey) VALUES (:arc_id, :decision, :result, NOW(), :game_id, :ckey)",
				list(
					"arc_id" = arc_id,
					"decision" = decision,
					"result" = result,
					"game_id" = GLOB.round_id,
					"ckey" = ui.user?.ckey || "MISSING"
				)
			)
			insert_query.Execute()
			qdel(insert_query)
			log_admin("[key_name(ui.user)] added arc decision '[decision]' to arc #[arc_id] with result: [result]")
			selected_arc_id = arc_id
			return TRUE

	return FALSE

/datum/tgui_module/arc_management_panel/proc/get_arcs()
	var/list/arcs = list()
	if(!SSdbcore.Connect())
		return arcs

	var/datum/db_query/query = SSdbcore.NewQuery("SELECT id, name, description, started_at, finished_at FROM ss13_arcs ORDER BY started_at DESC")
	query.Execute()
	while(query.NextRow())
		var/list/arc = list(
			"id" = text2num(query.item[1]),
			"name" = query.item[2],
			"description" = query.item[3],
			"started_at" = query.item[4],
			"finished_at" = query.item[5],
			"active" = isnull(query.item[5])
		)
		arcs += list(arc)
	qdel(query)
	return arcs

/datum/tgui_module/arc_management_panel/proc/get_active_arc_id()
	if(!SSdbcore.Connect())
		return null

	var/datum/db_query/query = SSdbcore.NewQuery("SELECT id FROM ss13_arcs WHERE finished_at IS NULL ORDER BY started_at DESC, id DESC LIMIT 1")
	query.Execute()
	var/active_arc_id = null
	if(query.NextRow())
		active_arc_id = text2num(query.item[1])
	qdel(query)
	return active_arc_id

/datum/tgui_module/arc_management_panel/proc/get_decisions(var/arc_id)
	var/list/decisions = list()
	if(!arc_id || !SSdbcore.Connect())
		return decisions

	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT id, decision, result, created_at, game_id FROM ss13_arc_decisions WHERE arc_id = :arc_id ORDER BY created_at DESC, id DESC",
		list("arc_id" = arc_id)
	)
	query.Execute()
	while(query.NextRow())
		decisions += list(list(
			"id" = text2num(query.item[1]),
			"decision" = query.item[2],
			"result" = query.item[3],
			"created_at" = query.item[4],
			"game_id" = query.item[5]
		))
	qdel(query)
	return decisions

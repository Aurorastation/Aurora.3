/client/proc/create_poll()
	set category = "Special Verbs"
	set name = "Create Poll"

	if(!check_rights(R_DEV))
		return
	var/datum/tgui_module/poll_creator/creator = new(src)
	creator.ui_interact(mob)

/datum/tgui_module/poll_creator
	var/client/owner
	var/error_message
	var/submitting = FALSE
	var/created_poll_id
	var/failed_insert = FALSE

/datum/tgui_module/poll_creator/New(client/creator)
	owner = creator
	..()

/datum/tgui_module/poll_creator/Destroy()
	owner = null
	return ..()

/datum/tgui_module/poll_creator/ui_state(mob/user)
	return GLOB.staff_state

/datum/tgui_module/poll_creator/ui_status(mob/user, datum/ui_state/state)
	if(user.client != owner || !check_rights(R_DEV, FALSE, user=user))
		return UI_CLOSE
	return ..()

/datum/tgui_module/poll_creator/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PollCreator", "Create Poll", 760, 800)
		ui.open()

/datum/tgui_module/poll_creator/ui_close(mob/user)
	. = ..()
	qdel(src)

/datum/tgui_module/poll_creator/ui_data(mob/user)
	return list("server_time" = SQLtime(), "error" = error_message, "submitting" = submitting || failed_insert, "poll_id" = created_poll_id)

/datum/tgui_module/poll_creator/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(. || ui.user.client != owner || !check_rights(R_DEV, FALSE, user=ui.user))
		return
	if(action == "cancel")
		ui.close()
		return TRUE
	if(action != "submit" || submitting || failed_insert || created_poll_id)
		return
	submitting = TRUE
	error_message = null
	save_poll(params)
	submitting = FALSE
	return TRUE

/datum/tgui_module/poll_creator/proc/save_poll(list/params)
	var/polltype = params["polltype"]
	if(!(polltype in list("OPTION", "TEXT", "NUMVAL", "MULTICHOICE")))
		error_message = "Select a valid poll type."
		return
	var/question = params["question"]
	var/endtime = params["endtime"]
	if(!istext(question) || !length(trim(question)) || !istext(endtime) || !length(trim(endtime)))
		error_message = "A question and end time are required."
		return
	var/list/options = params["options"]
	if(polltype != "TEXT")
		if(!islist(options) || !length(options))
			error_message = "Add at least one answer option."
			return
		for(var/option_entry in options)
			if(!islist(option_entry))
				return
			var/list/option = option_entry
			if(!istext(option["text"]) || !length(trim(option["text"])))
				error_message = "Every answer option needs text."
				return
			if(polltype == "NUMVAL")
				var/minval = option["minval"]
				var/maxval = option["maxval"]
				if(!isnum(minval) || !isnum(maxval) || minval >= maxval)
					error_message = "Each minimum rating must be less than its maximum."
					return
				for(var/field in list("descmin", "descmid", "descmax"))
					if(!istext(option[field]))
						error_message = "Rating descriptions must be text."
						return
	var/choice_amount = 0
	if(polltype == "MULTICHOICE")
		choice_amount = params["choice_amount"]
		if(!isnum(choice_amount) || choice_amount < 1 || choice_amount != round(choice_amount) || choice_amount > length(options))
			error_message = "Allowed choices must be a whole number between one and the number of options."
			return
	var/viewtoken = params["viewtoken"]
	var/link = params["link"]
	if(!istext(viewtoken) || !istext(link))
		error_message = "The result key and information link must be text."
		return
	if(!establish_db_connection(GLOB.dbcon))
		error_message = "Failed to establish database connection."
		return
	var/starttime = SQLtime()
	endtime = trim(endtime)
	if(length(endtime) == 10)
		endtime += " 00:00:00"
	endtime = sanitizeSQL(endtime)
	var/DBQuery/query_validate_time = GLOB.dbcon.NewQuery("SELECT STR_TO_DATE('[endtime]','%Y-%c-%d %T')")
	if(!query_validate_time.Execute())
		var/err = query_validate_time.ErrorMsg()
		error_message = "SQL error validating the end time: [err]"
		return
	if(query_validate_time.NextRow())
		endtime = query_validate_time.item[1]
		if(!endtime)
			error_message = "Enter a valid end time in YYYY-MM-DD HH:MM:SS format."
			return
	var/DBQuery/query_time_later = GLOB.dbcon.NewQuery("SELECT '[endtime]' <= NOW()")
	if(!query_time_later.Execute())
		var/err = query_time_later.ErrorMsg()
		error_message = "SQL error comparing the end time: [err]"
		return
	if(query_time_later.NextRow())
		var/checklate = text2num(query_time_later.item[1])
		if(checklate)
			error_message = "The end time must be later than the current server time."
			return
	var/adminonly = params["adminonly"] ? 1 : 0
	var/publicresult = 0
	if(viewtoken)
		publicresult = 1
		viewtoken = "'[sanitizeSQL(viewtoken)]'"
	else
		viewtoken = "NULL"

	if(link)
		link = "'[sanitizeSQL(link)]'"
	else
		link = "NULL"

	var/sql_ckey = sanitizeSQL(owner.ckey)
	var/address = sanitizeSQL(owner.address)
	question = sanitizeSQL(question)
	var/DBQuery/query_polladd_question = GLOB.dbcon.NewQuery("INSERT INTO ss13_poll_question (polltype, starttime, endtime, question, adminonly, multiplechoiceoptions, createdby_ckey, createdby_ip, publicresult, viewtoken, link) VALUES ('[polltype]', '[starttime]', '[endtime]', '[question]', '[adminonly]', '[choice_amount]', '[sql_ckey]', '[address]', '[publicresult]', [viewtoken], [link])")
	if(!query_polladd_question.Execute())
		var/err = query_polladd_question.ErrorMsg()
		error_message = "SQL error creating the poll: [err]"
		return
	failed_insert = TRUE
	var/pollid = 0
	var/DBQuery/query_get_id = GLOB.dbcon.NewQuery("SELECT id FROM ss13_poll_question WHERE question = '[question]' AND starttime = '[starttime]' AND endtime = '[endtime]' AND createdby_ckey = '[sql_ckey]' AND createdby_ip = '[address]'")
	if(!query_get_id.Execute())
		var/err = query_get_id.ErrorMsg()
		error_message = "The poll was inserted, but its ID could not be retrieved: [err]. Check the database before retrying."
		return
	if(query_get_id.NextRow())
		pollid = query_get_id.item[1]
	if(!pollid)
		error_message = "The poll was inserted, but its ID could not be retrieved. Check the database before retrying."
		return
	if(polltype == "TEXT")
		options = list()
	var/list/option_values = list()
	for(var/list/option in options)
		var/option_text = sanitizeSQL(option["text"])
		var/percentagecalc = option["percentagecalc"] ? 1 : 0
		var/minval = 0
		var/maxval = 0
		var/descmin = ""
		var/descmid = ""
		var/descmax = ""
		if(polltype == "NUMVAL")
			minval = option["minval"]
			maxval = option["maxval"]
			descmin = sanitizeSQL(option["descmin"])
			descmid = sanitizeSQL(option["descmid"])
			descmax = sanitizeSQL(option["descmax"])
		option_values += "('[pollid]', '[option_text]', '[percentagecalc]', '[minval]', '[maxval]', '[descmin]', '[descmid]', '[descmax]')"
	if(length(option_values))
		var/DBQuery/query_polladd_option = GLOB.dbcon.NewQuery("INSERT INTO ss13_poll_option (pollid, text, percentagecalc, minval, maxval, descmin, descmid, descmax) VALUES [jointext(option_values, ", ")]")
		if(!query_polladd_option.Execute())
			var/err = query_polladd_option.ErrorMsg()
			error_message = "SQL error adding options: [err]. Poll [pollid] needs database review before retrying."
			return
	created_poll_id = pollid
	failed_insert = FALSE
	log_admin("[key_name(owner)] created the poll with id [pollid].")
	message_admins(SPAN_NOTICE("[key_name_admin(owner)] created the poll with id [pollid]."))

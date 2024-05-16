/datum/computer_file/program/card_mod
	filename = "cardmod"
	filedesc = "ID Card Modification Program"
	program_icon_state = "id"
	program_key_icon_state = "lightblue_key"
	extended_desc = "Program for programming employee ID cards to access parts of the station."
	required_access_run = ACCESS_CHANGE_IDS
	required_access_download = ACCESS_CHANGE_IDS
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP
	requires_ntnet = FALSE
	size = 8
	color = LIGHT_COLOR_BLUE
	tgui_id = "IDCardModification"
	ui_auto_update = FALSE
	var/is_centcom = FALSE
	var/show_assignments = FALSE

/datum/computer_file/program/card_mod/ui_data(mob/user)
	var/list/data = initial_data()

	data["station_name"] = station_name()
	data["assignments"] = show_assignments
	data["have_id_slot"] = !!computer.card_slot
	data["have_printer"] = !!computer.nano_printer
	data["authenticated"] = can_run(user)
	data["centcom_access"] = is_centcom

	var/obj/item/card/id/id_card = computer.card_slot.stored_card
	data["has_id"] = !!id_card
	data["id_account_number"] = id_card ? id_card.associated_account_number : null
	data["id_rank"] = id_card && id_card.assignment ? id_card.assignment : "Unassigned"
	data["id_owner"] = id_card && id_card.registered_name ? id_card.registered_name : "-----"
	data["id_name"] = id_card ? id_card.name : "-----"

	if(computer.card_slot.stored_card)
		if(is_centcom)
			var/list/all_centcom_access = list()
			for(var/access in get_all_centcom_access())
				all_centcom_access.Add(list(list(
					"desc" = get_centcom_access_desc(access),
					"ref" = access,
					"allowed" = (access in id_card.access) ? TRUE : FALSE)))
			data["all_centcom_access"] = all_centcom_access
		else
			var/list/regions = list()
			for(var/i = 1; i <= 7; i++)
				var/list/accesses = list()
				for(var/access in get_region_accesses(i))
					if (get_access_desc(access))
						accesses.Add(list(list(
							"desc" = get_access_desc(access),
							"ref" = access,
							"allowed" = (access in id_card.access) ? TRUE : FALSE)))

				regions.Add(list(list(
					"name" = get_region_accesses_name(i),
					"accesses" = accesses)))
			data["regions"] = regions

	return data

/datum/computer_file/program/card_mod/ui_static_data(mob/user)
	var/list/data = list()
	data["command_support_jobs"] = format_jobs(command_support_positions)
	data["engineering_jobs"] = format_jobs(engineering_positions)
	data["medical_jobs"] = format_jobs(medical_positions)
	data["science_jobs"] = format_jobs(science_positions)
	data["security_jobs"] = format_jobs(security_positions)
	data["cargo_jobs"] = format_jobs(cargo_positions)
	data["service_jobs"] = format_jobs(service_positions)
	data["civilian_jobs"] = format_jobs(civilian_positions)
	data["centcom_jobs"] = format_jobs(get_all_centcom_jobs())
	return data

/datum/computer_file/program/card_mod/proc/format_jobs(list/jobs)
	var/obj/item/card/id/id_card = computer.card_slot.stored_card
	var/list/formatted = list()
	for(var/job in jobs)
		formatted.Add(list(list(
			"target_rank" = id_card && id_card.assignment ? id_card.assignment : "Unassigned",
			"job" = job)))

	return formatted

/datum/computer_file/program/card_mod/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return

	var/mob/user = usr
	var/obj/item/card/id/user_id_card = user.GetIdCard()
	var/obj/item/card/id/id_card = computer.card_slot.stored_card
	switch(action)
		if("togglea")
			if(show_assignments)
				show_assignments = FALSE
			else
				show_assignments = TRUE
			. = TRUE

		if("print")
			if(computer?.nano_printer && can_run(user, 1)) //This option should never be called if there is no printer
				var/contents = {"<h4>Access Report</h4>
							<u>Prepared By:</u> [user_id_card.registered_name ? user_id_card.registered_name : "Unknown"]<br>
							<u>For:</u> [id_card.registered_name ? id_card.registered_name : "Unregistered"]<br>
							<hr>
							<u>Assignment:</u> [id_card.assignment]<br>
							<u>Account Number:</u> #[id_card.associated_account_number]<br>
							<u>Blood Type:</u> [id_card.blood_type]<br><br>
							<u>Access:</u><br>
						"}

				var/known_access_rights = get_access_ids(ACCESS_TYPE_STATION|ACCESS_TYPE_CENTCOM)
				for(var/A in id_card.access)
					if(A in known_access_rights)
						contents += "  [get_access_desc(A)]"

				if(!computer.nano_printer.print_text(contents,"access report"))
					to_chat(usr, SPAN_WARNING("Hardware error: Printer was unable to print the file. It may be out of paper."))
					return
				else
					computer.visible_message(SPAN_NOTICE("\The [computer] prints out paper."))
					. = TRUE

		if("eject")
			if(computer && computer.card_slot)
				if(id_card)
					var/datum/record/general/R = SSrecords.find_record("name", id_card.registered_name)
					if(istype(R))
						var/real_title = id_card.assignment
						for(var/datum/job/J in get_job_datums())
							if(!J)
								continue
							var/list/alttitles = get_alternate_titles(J.title)
							if(id_card.assignment in alttitles)
								real_title = J.title
								break
						R.rank = id_card.assignment
						R.real_rank = real_title
				computer.eject_id()
				. = TRUE

		if("suspend")
			if(computer && can_run(user, 1))
				id_card.assignment = "Suspended"
				remove_nt_access(id_card)
				callHook("suspend_employee", list(id_card))
				. = TRUE

		if("edit")
			if(computer && can_run(user, 1))
				if(params["name"])
					var/temp_name = sanitizeName(input("Enter name.", "Name", id_card.registered_name))
					if(temp_name)
						id_card.registered_name = temp_name
					else
						computer.visible_message(SPAN_NOTICE("[computer] buzzes rudely."))
				else if(params["account"])
					var/account_num = text2num(input("Enter account number.", "Account", id_card.associated_account_number))
					id_card.associated_account_number = account_num
				. = TRUE

		if("assign")
			if(computer && can_run(user, 1) && id_card)
				var/t1 = params["assign_target"]
				if(t1 == "Custom")
					var/temp_t = sanitize(input("Enter a custom job assignment.","Assignment", id_card.assignment), 45)
					//let custom jobs function as an impromptu alt title, mainly for sechuds
					if(temp_t)
						id_card.assignment = temp_t
				else
					var/list/access = list()
					if(is_centcom)
						access = get_centcom_access(t1)
					else
						var/datum/job/jobdatum
						for(var/jobtype in typesof(/datum/job))
							var/datum/job/J = new jobtype
							if(ckey(J.title) == ckey(t1))
								jobdatum = J
								break
						if(!jobdatum)
							to_chat(usr, SPAN_WARNING("No log exists for this job: [t1]"))
							return

						access = jobdatum.get_access(t1)

					remove_nt_access(id_card)
					apply_access(id_card, access)
					id_card.assignment = t1
					id_card.rank = t1

				SSrecords.reset_manifest()
				callHook("reassign_employee", list(id_card))
				. = TRUE

		if("access")
			if(isnum(params["allowed"]) && computer && can_run(user, 1))
				var/access_type = text2num(params["access_target"])
				var/access_allowed = text2num(params["allowed"])
				if(access_type in get_access_ids(ACCESS_TYPE_STATION|ACCESS_TYPE_CENTCOM))
					id_card.access -= access_type
					if(!access_allowed)
						id_card.access += access_type
						. = TRUE
	if(id_card)
		id_card.name = text("[id_card.registered_name]'s ID Card ([id_card.assignment])")
		. = TRUE

/datum/computer_file/program/card_mod/proc/remove_nt_access(var/obj/item/card/id/id_card)
	id_card.access -= get_access_ids(ACCESS_TYPE_STATION|ACCESS_TYPE_CENTCOM)

/datum/computer_file/program/card_mod/proc/apply_access(var/obj/item/card/id/id_card, var/list/accesses)
	id_card.access |= accesses

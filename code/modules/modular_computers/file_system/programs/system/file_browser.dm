#define MAX_TEXTFILE_LENGTH 128000		// 512GQ file
#define FMS_FILEBROWSER 0
#define FMS_SHOWFILE 1
#define FMS_FORMS 2
#define FMS_EDIT 3

/datum/computer_file/program/filemanager
	filename = "filemanager"
	filedesc = "NTOS File Manager"
	extended_desc = "This program allows management of files."
	program_icon_state = "generic"
	program_key_icon_state = "green_key"
	color = LIGHT_COLOR_GREEN
	size = 2
	requires_ntnet = FALSE
	available_on_ntnet = FALSE
	undeletable = TRUE
	tgui_id = "FileManager"
	//Current screen of file manager.
	var/screen = FMS_FILEBROWSER
	//Department filter for forms browser.
	var/sql_filter_dept = ""
	var/open_file
	var/open_file_is_usb = FALSE
	var/error

/datum/computer_file/program/filemanager/ui_data(mob/user)
	var/list/data = initial_data()

	var/obj/item/computer_hardware/hard_drive/HDD
	var/obj/item/computer_hardware/hard_drive/portable/RHDD
	data["error"] = error
	data["screen"] = screen

	if(!computer || !computer.hard_drive)
		data["error"] = "I/O ERROR: Unable to access hard drive."
		return data
	if(screen == FMS_FILEBROWSER)
		data["script_data"] = null
		data["file_data"] = null
		data["file_is_usb"] = FALSE
		data["file_name"] = null
		HDD = computer.hard_drive
		RHDD = computer.portable_drive
		var/list/files = list()
		for(var/datum/computer_file/F in HDD.stored_files)
			files.Add(list(list(
				"name" = F.filename,
				"type" = F.filetype,
				"desc" = F.filedesc,
				"size" = F.size,
				"undeletable" = F.undeletable,
				"password" = !!F.password
			)))
		data["files"] = files
		if(RHDD)
			data["usb_connected"] = TRUE
			var/list/usb_files = list()
			for(var/datum/computer_file/F in RHDD.stored_files)
				usb_files.Add(list(list(
					"name" = F.filename,
					"type" = F.filetype,
					"desc" = F.filedesc,
					"size" = F.size,
					"undeletable" = F.undeletable,
					"password" = !!F.password
				)))
			data["usb_files"] = usb_files
		else
			data["usb_connected"] = FALSE
	if(screen == FMS_FORMS)
		if(!SSdbcore.Connect())
			data["sql_error"] = 1
		else
			var/datum/db_query/query
			if(sql_filter_dept)
				query = SSdbcore.NewQuery(
					"SELECT id, name, department FROM ss13_forms WHERE department LIKE :filter ORDER BY id",
					list("filter" = "%[sql_filter_dept]%"))
			else
				query = SSdbcore.NewQuery("SELECT id, name, department FROM ss13_forms ORDER BY id")
			if(!query.Execute())
				data["sql_error"] = 1
			else
				var/list/forms = list()
				while(query.NextRow())
					forms += list(list("id" = query.item[1], "name" = query.item[2], "department" = query.item[3]))
				if(!forms.len)
					data["sql_error"] = 1
				data["forms"] = forms
			qdel(query)
	if(open_file)
		var/datum/computer_file/data/file
		var/datum/computer_file/script/script
		HDD = open_file_is_usb ? computer.portable_drive : computer.hard_drive
		data["file_is_usb"] = open_file_is_usb
		if(!HDD)
			data["error"] = "I/O ERROR: Unable to open file."
			return data
		file = HDD.find_file_by_name(open_file)
		script = file
		data["file_name"] = "[file.filename]"
		data["file_type"] = "[file.filetype]"
		data["file_desc"] = "[file.filedesc]"
		if(!istype(file))
			if(!istype(script))
				data["error"] = "I/O ERROR: Unable to open file."
				return data
			else
				data["script_data"] = html_encode(script.code)
				return data
		if(screen == FMS_EDIT)
			data["file_data"] = file.stored_data
		else
			data["file_data"] = pencode2html(file.stored_data)
	return data

/datum/computer_file/program/filemanager/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return

	switch(action)
		if("set_screen")
			. = TRUE
			var/new_screen = text2num(params["screen"])
			if(new_screen == FMS_EDIT)
				if(!open_file)
					return TRUE
				var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
				if(!HDD)
					return TRUE
				var/datum/computer_file/data/F = HDD.find_file_by_name(open_file)
				if(!F || !istype(F))
					return TRUE
				if(F.do_not_edit && (alert("WARNING: This file is not compatible with editor. Editing it may result in permanently corrupted formatting or damaged data consistency. Edit anyway?", "Incompatible File", "No", "Yes") == "No"))
					return TRUE
			screen = new_screen

		if("PRG_open_file")
			. = TRUE
			var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
			var/datum/computer_file/F = HDD.find_file_by_name(params["PRG_open_file"])
			if(!F)
				return
			if(F.can_access_file(usr))
				open_file = params["PRG_open_file"]
				open_file_is_usb = FALSE
				screen = FMS_SHOWFILE

		if("PRG_usb_open_file")
			. = TRUE
			var/obj/item/computer_hardware/hard_drive/RHDD = computer.portable_drive
			if(!RHDD)
				return
			var/datum/computer_file/F = RHDD.find_file_by_name(params["PRG_usb_open_file"])
			if(!F)
				return
			if(F.can_access_file(usr))
				open_file = params["PRG_usb_open_file"]
				open_file_is_usb = TRUE
				screen = FMS_SHOWFILE

		if("PRG_new_text_file")
			. = TRUE
			var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
			if(!HDD)
				return TRUE
			var/datum/computer_file/data/F = new/datum/computer_file/data()
			F.filename = "NewFile"
			F.filetype = "TXT"
			F.stored_data = ""
			if(!HDD.store_file(F))
				qdel(F)
				error = "I/O ERROR: Unable to create file. The hard drive may be full, read-only, or contain a conflicting file."
			open_file = F.filename
			screen = FMS_EDIT

		if("PRG_delete_file")
			. = TRUE
			var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
			if(!HDD)
				return TRUE
			var/datum/computer_file/file = HDD.find_file_by_name(params["PRG_delete_file"])
			if(!file || file.undeletable)
				return TRUE
			HDD.remove_file(file)

		if("PRG_usb_delete_file")
			. = TRUE
			var/obj/item/computer_hardware/hard_drive/RHDD = computer.portable_drive
			if(!RHDD)
				return TRUE
			var/datum/computer_file/file = RHDD.find_file_by_name(params["PRG_usb_delete_file"])
			if(!file || file.undeletable)
				return TRUE
			RHDD.remove_file(file)

		if("PRG_close_file")
			. = TRUE
			open_file = null
			open_file_is_usb = FALSE
			error = null
			screen = FMS_FILEBROWSER

		if("PRG_clone")
			. = TRUE
			var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
			if(!HDD)
				return TRUE
			var/datum/computer_file/F = HDD.find_file_by_name(params["PRG_clone"])
			if(!F || !istype(F))
				return TRUE
			if(istype(F, /datum/computer_file/program))
				error = "I/O ERROR: Executable programs cannot be cloned from File Manager."
				return TRUE
			var/datum/computer_file/C = F.clone(1)
			if(!HDD.store_file(C))
				qdel(C)
				error = "I/O ERROR: Unable to clone file. The hard drive may be full, read-only, or contain a conflicting file."

		if("PRG_edit")
			. = TRUE
			var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
			if(!HDD)
				return TRUE
			var/datum/computer_file/data/F = HDD.find_file_by_name(open_file)
			if(!F || !istype(F))
				return TRUE

			if(params["PRG_rename"])
				var/newname = sanitize_filename(params["PRG_rename"])
				F.filename = newname
				open_file = newname
				return

			if(params["PRG_desc"])
				F.filedesc = params["PRG_desc"]
				return

			if(params["PRG_edit"])
				var/datum/computer_file/data/backup = F.clone()
				HDD.remove_file(F)
				F.stored_data = params["PRG_edit"]
				F.calculate_size()
				// We can't store the updated file, it's probably too large. Print an error and restore backed up version.
				// This is mostly intended to prevent people from losing texts they spent lot of time working on due to running out of space.
				// They will be able to copy-paste the text from error screen and store it in notepad or something.
				if(!HDD.store_file(F))
					error = "I/O error: Unable to overwrite file. Hard drive is probably full. You may want to backup your changes before closing this window:<br><br>[html_decode(F.stored_data)]<br><br>"
					HDD.store_file(backup)

		if("PRG_print_file")
			. = TRUE
			if(!open_file)
				return TRUE
			var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
			if(!HDD)
				return FALSE
			if(!computer.nano_printer)
				error = "Missing Hardware: Your computer does not have required hardware to complete this operation."
				return FALSE
			var/datum/computer_file/data/F = HDD.find_file_by_name(open_file)
			var/datum/computer_file/script/S = F
			if(!F)
				return TRUE
			if(istype(F))
				if(!computer.nano_printer.print_text(F.stored_data, F.filename))
					error = "Hardware error: Printer was unable to print the file. It may be out of paper."
					return FALSE
			else if(istype(S))
				if(!computer.nano_printer.print_text(S.code, S.filename))
					error = "Hardware error: Printer was unable to print the file. It may be out of paper."
					return FALSE

		if("PRG_copy_to_usb")
			. = TRUE
			var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
			var/obj/item/computer_hardware/hard_drive/portable/RHDD = computer.portable_drive
			if(!HDD || !RHDD)
				return FALSE
			var/datum/computer_file/F = HDD.find_file_by_name(params["PRG_copy_to_usb"])
			if(!F || !istype(F))
				return FALSE
			var/is_usr_tech_support = FALSE
			if(can_run(usr,FALSE,ACCESS_IT))
				is_usr_tech_support = TRUE
			if(!is_usr_tech_support && computer.enrolled != DEVICE_PRIVATE && istype(F, /datum/computer_file/program))
				to_chat(usr, SPAN_WARNING("Work devices can't export programs to portable drives! Contact Tech Support to get them to load it."))
				return TRUE
			if(!RHDD.can_store_file(F.size))
				to_chat(usr, SPAN_WARNING("\The [RHDD] doesn't have enough space to import the file."))
				return
			var/datum/computer_file/C = F.clone(0, "Compless")
			for(var/datum/computer_file/installed_file in RHDD.stored_files)
				if(C.filename == installed_file.filename)
					to_chat(usr, SPAN_WARNING("A file with the same name is already installed on \the [computer]."))
					qdel(C)
					return
			RHDD.store_file(C)

		if("PRG_copy_from_usb")
			. = TRUE
			var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
			var/obj/item/computer_hardware/hard_drive/portable/RHDD = computer.portable_drive
			if(!HDD || !RHDD)
				return TRUE
			var/datum/computer_file/F = RHDD.find_file_by_name(params["PRG_copy_from_usb"])
			if(!F || !istype(F))
				return TRUE
			var/is_usr_tech_support = FALSE
			if(can_run(usr,FALSE,ACCESS_IT))
				is_usr_tech_support = TRUE
			if(!is_usr_tech_support && computer.enrolled != DEVICE_PRIVATE && istype(F, /datum/computer_file/program))
				to_chat(usr, SPAN_WARNING("Work devices can't import programs from portable drives! Contact Tech Support to get them to load it."))
				return TRUE
			if(!HDD.can_store_file(F.size))
				to_chat(usr, SPAN_WARNING("\The [computer]'s hard drive doesn't have enough space to import the file."))
				return
			var/datum/computer_file/C = F.clone(0, computer)
			for(var/datum/computer_file/installed_file in HDD.stored_files)
				if(C.filename == installed_file.filename)
					to_chat(usr, SPAN_WARNING("A file with the same name is already installed on \the [computer]."))
					qdel(C)
					return
			HDD.store_file(C)

		if("PRG_encrypt")
			. = TRUE
			var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
			if (!HDD)
				return
			var/datum/computer_file/F = HDD.find_file_by_name(params["PRG_file_to_encrypt"])
			if(!F || F.undeletable)
				return
			if(F.password && F.password == params["PRG_encrypt"])
				F.password = ""
				return
			F.password = params["PRG_encrypt"]

		if("PRG_sort_forms")
			sql_filter_dept = sanitize(params["department"])
			return TRUE

		if("PRG_reset_sql")
			sql_filter_dept = ""
			return TRUE

		if("PRG_generate_form")
			var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
			var/printid = text2num(params["id"])
			if(!printid)
				return TRUE
			if(!SSdbcore.Connect())
				to_chat(usr, SPAN_WARNING("Connection to the database lost. Aborting."))
				return TRUE
			var/datum/db_query/query = SSdbcore.NewQuery(
				"SELECT id, name, data FROM ss13_forms WHERE id = :id",
				list("id" = printid))
			if(!query.Execute())
				to_chat(usr, SPAN_WARNING("Connection to the database lost. Aborting."))
				qdel(query)
				return TRUE
			while(query.NextRow())
				var/datum/computer_file/data/F = new/datum/computer_file/data()
				F.filename = "SCCF-[query.item[1]]-[query.item[2]]"
				F.filetype = "TXT"
				F.stored_data = query.item[3]
				if(!HDD.store_file(F))
					qdel(F)
					error = "I/O ERROR: Unable to create file. The hard drive may be full, read-only, or contain a conflicting file."
			qdel(query)
			screen = FMS_FILEBROWSER
			return TRUE

		if("PRG_whatis")
			var/whatisid = text2num(params["id"])
			if(!whatisid)
				return TRUE
			if(!SSdbcore.Connect())
				to_chat(usr, SPAN_WARNING("Connection to the database lost. Aborting."))
				return TRUE
			var/datum/db_query/query = SSdbcore.NewQuery(
				"SELECT id, name, department, info FROM ss13_forms WHERE id = :id",
				list("id" = whatisid))
			if(!query.Execute())
				to_chat(usr, SPAN_WARNING("Connection to the database lost. Aborting."))
				qdel(query)
				return TRUE
			var/dat = "<center><b>Stellar Corporate Conglomerate Form</b><br>"
			while(query.NextRow())
				dat += "<b>SCCF-[query.item[1]]</b><br><br>"
				dat += "<b>[query.item[2]]</b><br>"
				dat += "<b>[query.item[3]] Department</b><hr>"
				dat += "[query.item[4]]"
			dat += "</center>"
			qdel(query)
			usr << browse(HTML_SKELETON(dat), "window=Information;size=560x240")
			return TRUE

#undef MAX_TEXTFILE_LENGTH

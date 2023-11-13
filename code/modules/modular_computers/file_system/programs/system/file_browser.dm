#define MAX_TEXTFILE_LENGTH 128000		// 512GQ file
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
	var/open_file
	var/error

/datum/computer_file/program/filemanager/ui_data(mob/user)
	var/list/data = initial_data()

	var/obj/item/computer_hardware/hard_drive/HDD
	var/obj/item/computer_hardware/hard_drive/portable/RHDD
	if(error)
		data["error"] = error
	if(open_file)
		var/datum/computer_file/data/file
		var/datum/computer_file/script/script

		if(!computer || !computer.hard_drive)
			data["error"] = "I/O ERROR: Unable to access hard drive."
		else
			HDD = computer.hard_drive
			file = HDD.find_file_by_name(open_file)
			script = file
			if(!istype(file))
				if(!istype(script))
					data["error"] = "I/O ERROR: Unable to open file."
				else
					data["scriptdata"] = html_encode(script.code)
					data["filename"] = "[script.filename].[script.filetype]"
			else
				data["filedata"] = pencode2html(file.stored_data)
				data["filename"] = "[file.filename].[file.filetype]"
	else
		if(!computer || !computer.hard_drive)
			data["error"] = "I/O ERROR: Unable to access hard drive."
		else
			HDD = computer.hard_drive
			RHDD = computer.portable_drive
			var/list/files = list()
			for(var/datum/computer_file/F in HDD.stored_files)
				files.Add(list(list(
					"name" = F.filename,
					"type" = F.filetype,
					"size" = F.size,
					"undeletable" = F.undeletable,
					"encrypted" = !!F.password
				)))
			data["files"] = files
			if(RHDD)
				data["usbconnected"] = TRUE
				var/list/usbfiles = list()
				for(var/datum/computer_file/F in RHDD.stored_files)
					usbfiles.Add(list(list(
						"name" = F.filename,
						"type" = F.filetype,
						"size" = F.size,
						"undeletable" = F.undeletable,
						"encrypted" = !!F.password
					)))
				data["usbfiles"] = usbfiles
	return data

/datum/computer_file/program/filemanager/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return

	switch(action)
		if("PRG_openfile")
			. = TRUE
			var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
			var/datum/computer_file/F = HDD.find_file_by_name(params["PRG_openfile"])
			if(!F)
				return
			if(F.can_access_file(usr))
				open_file = params["PRG_openfile"]

		if("PRG_newtextfile")
			. = TRUE
			var/newname = sanitize(input(usr, "Enter file name or leave blank to cancel:", "File rename"))
			if(!newname)
				return TRUE
			var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
			if(!HDD)
				return TRUE
			var/datum/computer_file/data/F = new/datum/computer_file/data()
			F.filename = newname
			F.filetype = "TXT"
			HDD.store_file(F)

		if("PRG_deletefile")
			. = TRUE
			var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
			if(!HDD)
				return TRUE
			var/datum/computer_file/file = HDD.find_file_by_name(params["PRG_deletefile"])
			if(!file || file.undeletable)
				return TRUE
			HDD.remove_file(file)

		if("PRG_usbdeletefile")
			. = TRUE
			var/obj/item/computer_hardware/hard_drive/RHDD = computer.portable_drive
			if(!RHDD)
				return TRUE
			var/datum/computer_file/file = RHDD.find_file_by_name(params["PRG_usbdeletefile"])
			if(!file || file.undeletable)
				return TRUE
			RHDD.remove_file(file)

		if("PRG_closefile")
			. = TRUE
			open_file = null
			error = null

		if("PRG_clone")
			. = TRUE
			var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
			if(!HDD)
				return TRUE
			var/datum/computer_file/F = HDD.find_file_by_name(params["PRG_clone"])
			if(!F || !istype(F))
				return TRUE
			var/datum/computer_file/C = F.clone(1)
			HDD.store_file(C)

		if("PRG_rename")
			. = TRUE
			var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
			if(!HDD)
				return TRUE
			var/datum/computer_file/file = HDD.find_file_by_name(params["PRG_rename"])
			if(!file || !istype(file))
				return TRUE
			var/newname = sanitize(input(usr, "Enter new file name:", "File rename", file.filename))
			if(file && newname)
				file.filename = newname

		if("PRG_edit")
			. = TRUE
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

			var/oldtext = html_decode(F.stored_data)
			oldtext = replacetext(oldtext, "\[editorbr\]", "\n")

			var/newtext = sanitize(replacetext(input(usr, "Editing file [open_file]. You may use most tags used in paper formatting:", "Text Editor", oldtext) as message|null, "\n", "\[editorbr\]"), MAX_TEXTFILE_LENGTH)
			if(!newtext)
				return

			if(F)
				var/datum/computer_file/data/backup = F.clone()
				HDD.remove_file(F)
				F.stored_data = newtext
				F.calculate_size()
				// We can't store the updated file, it's probably too large. Print an error and restore backed up version.
				// This is mostly intended to prevent people from losing texts they spent lot of time working on due to running out of space.
				// They will be able to copy-paste the text from error screen and store it in notepad or something.
				if(!HDD.store_file(F))
					error = "I/O error: Unable to overwrite file. Hard drive is probably full. You may want to backup your changes before closing this window:<br><br>[html_decode(F.stored_data)]<br><br>"
					HDD.store_file(backup)

		if("PRG_printfile")
			. = TRUE
			if(!open_file)
				return TRUE
			var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
			if(!HDD)
				return TRUE
			if(!computer.nano_printer)
				error = "Missing Hardware: Your computer does not have required hardware to complete this operation."
				return TRUE
			var/datum/computer_file/data/F = HDD.find_file_by_name(open_file)
			var/datum/computer_file/script/S = F
			if(!F)
				return TRUE
			if(istype(F))
				if(!computer.nano_printer.print_text(F.stored_data))
					error = "Hardware error: Printer was unable to print the file. It may be out of paper."
					return TRUE
			else if(istype(S))
				if(!computer.nano_printer.print_text(S.code))
					error = "Hardware error: Printer was unable to print the file. It may be out of paper."
					return TRUE

		if("PRG_copytousb")
			. = TRUE
			var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
			var/obj/item/computer_hardware/hard_drive/portable/RHDD = computer.portable_drive
			if(!HDD || !RHDD)
				return TRUE
			var/datum/computer_file/F = HDD.find_file_by_name(params["PRG_copytousb"])
			if(!F || !istype(F))
				return TRUE
			var/is_usr_tech_support = FALSE
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				var/obj/item/card/id/ID = H.GetIdCard()
				if(access_it in ID.access)
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

		if("PRG_copyfromusb")
			. = TRUE
			var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
			var/obj/item/computer_hardware/hard_drive/portable/RHDD = computer.portable_drive
			if(!HDD || !RHDD)
				return TRUE
			var/datum/computer_file/F = RHDD.find_file_by_name(params["PRG_copyfromusb"])
			if(!F || !istype(F))
				return TRUE
			var/is_usr_tech_support = FALSE
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				var/obj/item/card/id/ID = H.GetIdCard()
				if(access_it in ID.access)
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
			var/datum/computer_file/F = HDD.find_file_by_name(params["PRG_encrypt"])
			if(!F || F.undeletable)
				return
			if(F.password)
				return
			F.password = sanitize(input(usr, "Enter an encryption key:", "Encrypt File"))

		if("PRG_decrypt")
			. = TRUE
			var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
			if (!HDD)
				return
			var/datum/computer_file/F = HDD.find_file_by_name(params["PRG_encrypt"])
			if(!F || F.undeletable)
				return
			if (F.can_access_file(usr))
				F.password = ""

#undef MAX_TEXTFILE_LENGTH

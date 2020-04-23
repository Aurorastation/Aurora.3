var/global/file_uid = 0

/datum/computer_file
	var/filename = "NewFile"								// Placehard_drive. No spacebars
	var/filetype = "XXX"									// File full names are [filename].[filetype] so like NewFile.XXX in this case
	var/size = 1											// File size in GQ. Integers only!
	var/obj/item/computer_hardware/hard_drive/hard_drive	// Harddrive that contains this file.
	var/unsendable = FALSE									// Whether the file may be sent to someone via NTNet transfer or other means.
	var/undeletable = FALSE									// Whether the file may be deleted. Setting to 1 prevents deletion/renaming/etc.
	var/password = ""										// Placeholder for password protected files.
	var/uid													// UID of this file

/datum/computer_file/New()
	..()
	uid = file_uid
	file_uid++

/datum/computer_file/Destroy()
	if(!hard_drive)
		return ..()

	hard_drive.remove_file(src)
	// hard_drive.hard_drive is the computer that has drive installed. If we are Destroy()ing program that's currently running kill it.
	if(hard_drive.parent_computer?.active_program == src)
		hard_drive.parent_computer.kill_program(TRUE)
	hard_drive = null
	return ..()

// Returns independent copy of this file.
/datum/computer_file/proc/clone(var/rename = FALSE)
	var/datum/computer_file/temp = new type
	temp.unsendable = unsendable
	temp.undeletable = undeletable
	temp.size = size
	temp.password = password
	if(rename)
		temp.filename = filename + "(Copy)"
	else
		temp.filename = filename
	temp.filetype = filetype
	return temp

/datum/computer_file/proc/can_access_file(var/mob/user, input_password = "")
	if(!password)
		return TRUE
	else
		if(!input_password)
			input_password = sanitize(input(user, "Please enter a password to access file '[filename]':"))
		if(input_password == password)
			return TRUE
		else
			return FALSE
GLOBAL_VAR_INIT(file_uid, 0)

/datum/computer_file
	/// Placehard_drive. No spacebars
	var/filename = "NewFile"
	/// File full names are [filename].[filetype] so like NewFile.XXX in this case
	var/filetype = "XXX"
	var/filedesc = null
	/// File size in GQ. Integers only!
	var/size = 1
	/// Harddrive that contains this file.
	var/obj/item/computer_hardware/hard_drive/hard_drive
	/// Whether the file may be sent to someone via NTNet transfer or other means.
	var/unsendable = FALSE
	/// Whether the file may be deleted. Setting to 1 prevents deletion/renaming/etc.
	var/undeletable = FALSE
	/// Placeholder for password protected files.
	var/password = ""
	/// UID of this file
	var/uid

/datum/computer_file/New()
	..()
	uid = GLOB.file_uid
	GLOB.file_uid++

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
/datum/computer_file/proc/clone(var/rename = FALSE, var/computer)
	var/datum/computer_file/temp = new type(computer)
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

/** A PNG image stored on a modular-computer drive. */
/datum/computer_file/image
	filetype = "PNG"
	filedesc = "Image file"
	size = 1
	var/icon/stored_icon
	/// The ckey of the user who last created or modified the image.
	var/author_ckey

/datum/computer_file/image/clone(rename = FALSE)
	var/datum/computer_file/image/copy = ..()
	copy.stored_icon = stored_icon ? icon(stored_icon) : null
	copy.author_ckey = author_ckey
	return copy

/** A layered project that can be reopened in NanoPaint. */
/datum/computer_file/data/paint_project
	filetype = "NPNT"
	filedesc = "NanoPaint project"
	var/datum/sprite_editor_workspace/workspace

/datum/computer_file/data/paint_project/Destroy()
	QDEL_NULL(workspace)
	return ..()

/datum/computer_file/data/paint_project/clone(rename = FALSE)
	var/datum/computer_file/data/paint_project/copy = ..()
	copy.workspace = workspace?.copy()
	return copy

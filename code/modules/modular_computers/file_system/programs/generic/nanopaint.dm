#define NANOPAINT_PALETTE_SIZE 32
#define NANOPAINT_MAX_DIMENSION 96

/datum/computer_file/program/nanopaint
	filename = "nanopaint"
	filedesc = "NanoPaint"
	extended_desc = "A layered pixel-art editor for creating and editing image files."
	program_icon_state = "generic"
	program_key_icon_state = "green_key"
	color = LIGHT_COLOR_GREEN
	tgui_id = "NtosNanopaint"
	size = 5
	requires_ntnet = FALSE
	usage_flags = PROGRAM_ALL_REGULAR
	var/datum/weakref/backing_file
	var/opened_file_name
	var/opened_file_type
	var/datum/sprite_editor_workspace/current_workspace
	var/current_color = "#ffffffff"
	var/list/palette = list()
	var/list/dialog

/datum/computer_file/program/nanopaint/ui_static_data(mob/user)
	return list(
		"templateSizes" = list(
			"Small Canvas" = list(11, 11),
			"Wide Canvas" = list(23, 19),
			"Square Canvas" = list(23, 23),
			"Photo" = list(32, 32),
		),
		"saveableTypes" = list(
			list("displayText" = "NanoPaint Project (.NPNT)", "typepath" = "[/datum/computer_file/data/paint_project]", "extension" = "NPNT"),
			list("displayText" = "PNG Image (.PNG)", "typepath" = "[/datum/computer_file/image]", "extension" = "PNG"),
		),
		"minSize" = 1,
		"maxSize" = NANOPAINT_MAX_DIMENSION,
	)

/datum/computer_file/program/nanopaint/ui_data(mob/user)
	var/list/data = list()
	data["dialog"] = dialog
	var/list/editor_data = list(
		"serverSelectedColor" = current_color,
		"serverPalette" = palette,
		"maxServerColors" = NANOPAINT_PALETTE_SIZE,
		"onSelectServerColor" = "onSelectColor",
		"onAddServerColor" = "onAddPaletteColor",
		"onRemoveServerColor" = "onRemovePaletteColor",
	)
	if(current_workspace)
		editor_data += current_workspace.sprite_editor_ui_data()
	data["editorData"] = editor_data
	data["workspaceOpen"] = !!current_workspace
	data["diskInserted"] = !!computer?.portable_drive
	data["driveFiles"] = nanopaint_file_list(computer?.hard_drive)
	data["diskFiles"] = nanopaint_file_list(computer?.portable_drive)
	return data

/datum/computer_file/program/nanopaint/proc/nanopaint_file_list(obj/item/computer_hardware/hard_drive/drive)
	var/list/results = list()
	if(!drive)
		return results
	for(var/datum/computer_file/file in drive.stored_files)
		if(!istype(file, /datum/computer_file/image) && !istype(file, /datum/computer_file/data/paint_project))
			continue
		results += list(list(
			"name" = file.filename,
			"extension" = file.filetype,
			"uid" = file.uid,
			"baseType" = "[file.type]",
		))
	return results

/datum/computer_file/program/nanopaint/proc/find_file(uid, full_name, on_disk = FALSE)
	var/obj/item/computer_hardware/hard_drive/drive = on_disk ? computer?.portable_drive : computer?.hard_drive
	if(!drive)
		return null
	for(var/datum/computer_file/file in drive.stored_files)
		if(!isnull(uid) && "[file.uid]" == "[uid]")
			return file
		if(isnull(uid) && "[file.filename].[file.filetype]" == full_name)
			return file
	return null

/datum/computer_file/program/nanopaint/proc/check_dialog(action, modal_type)
	return dialog && dialog["type"] == modal_type && (!action || dialog["action"] == action)

/datum/computer_file/program/nanopaint/proc/extension_for_type(file_type)
	if(file_type == /datum/computer_file/data/paint_project)
		return "NPNT"
	if(file_type == /datum/computer_file/image)
		return "PNG"
	return null

/datum/computer_file/program/nanopaint/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE
	var/mob/user = ui.user
	switch(action)
		if("spriteEditorCommand")
			if(!current_workspace)
				return TRUE
			switch(params["command"])
				if("transaction")
					current_workspace.new_transaction(params["transaction"])
				if("toggleVisible")
					current_workspace.toggle_layer_visible(params["layer"])
				if("undo")
					current_workspace.undo()
				if("redo")
					current_workspace.redo()
			return TRUE
		if("onSelectColor")
			if(current_workspace?.is_valid_color(params["color"]))
				current_color = params["color"]
			return TRUE
		if("onAddPaletteColor")
			if(length(palette) < NANOPAINT_PALETTE_SIZE && current_workspace?.is_valid_color(params["color"]))
				palette += params["color"]
			return TRUE
		if("onRemovePaletteColor")
			var/index = text2num(params["index"])
			if(index >= 1 && index <= length(palette))
				palette.Cut(index, index + 1)
			return TRUE
		if("closeDialog")
			dialog = null
			return TRUE
		if("newDialog")
			dialog = list("type" = "new")
			return TRUE
		if("new")
			if(!check_dialog(null, "new"))
				return TRUE
			var/width = text2num(params["width"])
			var/height = text2num(params["height"])
			if(width < 1 || width > NANOPAINT_MAX_DIMENSION || height < 1 || height > NANOPAINT_MAX_DIMENSION)
				return TRUE
			dialog = null
			close_workspace()
			current_workspace = new(width, height)
			return TRUE
		if("openDialog")
			dialog = list("type" = "select", "title" = "Open File", "confirmText" = "Open", "action" = "open")
			return TRUE
		if("open")
			if(!check_dialog("open", "select"))
				return TRUE
			dialog = null
			open_file(params["uid"], params["onDisk"], params["name"], params["typepath"])
			return TRUE
		if("save")
			if(!current_workspace)
				return TRUE
			var/datum/computer_file/file = backing_file?.resolve()
			if(file && file.hard_drive != computer?.hard_drive && file.hard_drive != computer?.portable_drive)
				file = null
			if(file)
				write_to_file(user, file)
			else if(opened_file_name && opened_file_type)
				save_file(user, opened_file_name, opened_file_type, FALSE)
			else
				dialog = list("type" = "select", "title" = "Save As", "confirmText" = "Save", "action" = "saveAs")
			return TRUE
		if("saveAsDialog")
			if(current_workspace)
				dialog = list("type" = "select", "title" = "Save As", "confirmText" = "Save", "action" = "saveAs")
			return TRUE
		if("saveAs", "overwrite")
			if(!current_workspace || !check_dialog(action, action == "saveAs" ? "select" : "confirm"))
				return TRUE
			var/new_name = copytext_char(trim(sanitize_filename(params["name"])), 1, MAX_NAME_LEN + 1)
			var/on_disk = !!params["onDisk"]
			var/file_type = text2path(params["typepath"])
			if(!new_name || !(file_type in list(/datum/computer_file/data/paint_project, /datum/computer_file/image)))
				dialog = list("type" = "error", "message" = "Invalid file name or format.")
				return TRUE
			var/extension = extension_for_type(file_type)
			var/datum/computer_file/existing = find_file(params["uid"], "[new_name].[extension]", on_disk)
			if(existing && action == "saveAs")
				dialog = list(
					"type" = "confirm",
					"title" = "Confirm Save As",
					"message" = "[new_name].[extension] already exists. Do you want to overwrite this file?",
					"action" = "overwrite",
					"params" = list("uid" = existing.uid, "name" = new_name, "onDisk" = on_disk, "typepath" = "[file_type]"),
				)
				return TRUE
			dialog = null
			if(existing)
				write_to_file(user, existing)
			else
				save_file(user, new_name, file_type, on_disk)
			return TRUE
	return FALSE

/datum/computer_file/program/nanopaint/proc/open_file(uid, on_disk, file_name, requested_type)
	var/file_type = text2path(requested_type)
	if(!(file_type in list(/datum/computer_file/data/paint_project, /datum/computer_file/image)))
		dialog = list("type" = "error", "message" = "[file_name] - Unsupported format.")
		return
	var/full_name = "[file_name].[extension_for_type(file_type)]"
	var/datum/computer_file/file = find_file(uid, full_name, !!on_disk)
	if(!file)
		dialog = list("type" = "error", "message" = "[full_name] - The selected file could not be found.")
		return
	close_workspace()
	if(istype(file, /datum/computer_file/data/paint_project))
		var/datum/computer_file/data/paint_project/project = file
		if(!project.workspace)
			dialog = list("type" = "error", "message" = "[full_name] - The project is corrupt.")
			return
		current_workspace = project.workspace.copy()
	else if(istype(file, /datum/computer_file/image))
		var/datum/computer_file/image/image_file = file
		if(!image_file.stored_icon)
			dialog = list("type" = "error", "message" = "[full_name] - The image is corrupt.")
			return
		var/image_width = image_file.stored_icon.Width()
		var/image_height = image_file.stored_icon.Height()
		if(image_width < 1 || image_height < 1 || image_width > NANOPAINT_MAX_DIMENSION || image_height > NANOPAINT_MAX_DIMENSION)
			dialog = list("type" = "error", "message" = "[full_name] - The image dimensions are unsupported.")
			return
		current_workspace = new(image_width, image_height)
		sprite_editor_fill_grid_from_icon(current_workspace.get_first_layer_pixel_data(), image_file.stored_icon)
	backing_file = WEAKREF(file)
	opened_file_name = file.filename
	opened_file_type = file.type

/datum/computer_file/program/nanopaint/proc/write_to_file(mob/user, datum/computer_file/file)
	if(!current_workspace || !file)
		return FALSE
	if(istype(file, /datum/computer_file/data/paint_project))
		var/datum/computer_file/data/paint_project/project = file
		QDEL_NULL(project.workspace)
		project.workspace = current_workspace.copy()
	else if(istype(file, /datum/computer_file/image))
		var/datum/computer_file/image/image_file = file
		var/icon/rendered = current_workspace.to_icon()
		if(!rendered)
			dialog = list("type" = "error", "message" = "Unable to render the image.")
			return FALSE
		image_file.stored_icon = rendered
		image_file.author_ckey = user.ckey
		message_admins("[key_name_admin(user)] saved a custom NanoPaint image as [file.filename].[file.filetype] on [computer].")
		log_admin("[key_name(user)] saved a custom NanoPaint image as [file.filename].[file.filetype] on [computer].")
	else
		return FALSE
	backing_file = WEAKREF(file)
	opened_file_name = file.filename
	opened_file_type = file.type
	return TRUE

/datum/computer_file/program/nanopaint/proc/save_file(mob/user, name, file_type, on_disk)
	var/obj/item/computer_hardware/hard_drive/drive = on_disk ? computer?.portable_drive : computer?.hard_drive
	if(!drive)
		dialog = list("type" = "error", "message" = "[name] - The selected drive is unavailable.")
		return FALSE
	var/datum/computer_file/file = new file_type()
	file.filename = name
	if(!drive.store_file(file))
		qdel(file)
		dialog = list("type" = "error", "message" = "[name] - Unable to save the file. The drive may be full or read-only.")
		return FALSE
	return write_to_file(user, file)

/datum/computer_file/program/nanopaint/proc/close_workspace()
	backing_file = null
	opened_file_name = null
	opened_file_type = null
	QDEL_NULL(current_workspace)
	palette = list()
	current_color = "#ffffffff"

/datum/computer_file/program/nanopaint/kill_program(forced)
	close_workspace()
	return ..()

/datum/computer_file/program/nanopaint/Destroy()
	close_workspace()
	return ..()

#undef NANOPAINT_MAX_DIMENSION
#undef NANOPAINT_PALETTE_SIZE

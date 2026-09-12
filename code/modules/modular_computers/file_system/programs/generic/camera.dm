#define PDA_CAMERA_MAX_RANGE 7
#define PDA_CAMERA_CAPTURE_COOLDOWN 10

/** Camera application for modular PDAs. */
/datum/computer_file/program/pda_camera
	filename = "camera"
	filedesc = "Camera"
	extended_desc = "Captures photographs with a modular PDA and saves them as PNG image files."
	program_icon_state = "generic"
	program_key_icon_state = "green_key"
	color = LIGHT_COLOR_GREEN
	tgui_id = "NtosCamera"
	size = 4
	requires_ntnet = FALSE
	usage_flags = PROGRAM_TABLET
	var/obj/item/camera/internal_camera
	var/obj/item/photo/latest_photo
	var/picture_number = 1
	var/current_name = "photo"
	var/current_description = ""
	var/current_caption = ""
	var/error
	var/next_capture_time = 0

/datum/computer_file/program/pda_camera/New(obj/item/modular_computer/comp)
	. = ..()
	if(comp == "Compless")
		return
	internal_camera = new(computer)
	internal_camera.name = "PDA camera module"
	internal_camera.size = 3
	internal_camera.pictures_left = INFINITY

/datum/computer_file/program/pda_camera/Destroy()
	QDEL_NULL(latest_photo)
	QDEL_NULL(internal_camera)
	return ..()

/datum/computer_file/program/pda_camera/clone(rename = FALSE, target_computer)
	var/datum/computer_file/program/pda_camera/copy = ..()
	copy.picture_number = picture_number
	return copy

/datum/computer_file/program/pda_camera/ui_static_data(mob/user)
	return list(
		"maxNameLength" = MAX_NAME_LEN,
		"maxDescLength" = 128,
		"maxCaptionLength" = 128,
	)

/datum/computer_file/program/pda_camera/ui_data(mob/user)
	var/list/data = list(
		"name" = current_name,
		"description" = current_description,
		"caption" = current_caption,
		"error" = error,
		"hasPrinter" = !!computer?.nano_printer,
		"paper" = computer?.nano_printer?.stored_paper || 0,
	)
	if(latest_photo?.img)
		data["photo"] = icon2base64(latest_photo.img)
	return data

/datum/computer_file/program/pda_camera/event_afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(program_state != PROGRAM_STATE_ACTIVE || !isliving(user))
		return FALSE
	var/turf/target_turf = get_turf(target)
	var/turf/user_turf = get_turf(user)
	if(!target_turf || !user_turf || target_turf.z != user_turf.z || get_dist(user_turf, target_turf) > PDA_CAMERA_MAX_RANGE)
		to_chat(user, SPAN_WARNING("The target is outside the camera's effective range."))
		return TRUE
	if(world.time < next_capture_time)
		to_chat(user, SPAN_WARNING("The camera is still processing its previous exposure."))
		return TRUE
	capture(target_turf, user)
	return TRUE

/datum/computer_file/program/pda_camera/proc/capture(turf/target, mob/living/user)
	next_capture_time = world.time + PDA_CAMERA_CAPTURE_COOLDOWN
	var/obj/item/photo/new_photo = internal_camera.createpicture(target, user, FALSE)
	if(!new_photo?.img)
		qdel(new_photo)
		error = "The camera could not capture that target."
		return FALSE
	QDEL_NULL(latest_photo)
	latest_photo = new_photo
	latest_photo.forceMove(internal_camera)
	current_name = "photo[picture_number++]"
	current_description = copytext_char(latest_photo.picture_desc || "A photograph captured with a PDA.", 1, 129)
	current_caption = ""
	error = null
	internal_camera.do_photo_sound()
	SStgui.update_uis(computer)
	return TRUE

/datum/computer_file/program/pda_camera/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE
	switch(action)
		if("setName")
			current_name = copytext_char(trim(sanitize_filename(params["value"])), 1, MAX_NAME_LEN + 1)
			return TRUE
		if("setDescription")
			current_description = copytext_char(trim(params["value"]), 1, 129)
			return TRUE
		if("setCaption")
			current_caption = copytext_char(trim(params["value"]), 1, 129)
			return TRUE
		if("savePhoto")
			save_photo(ui.user)
			return TRUE
		if("printPhoto")
			print_photo(ui.user)
			return TRUE
	return FALSE

/datum/computer_file/program/pda_camera/proc/save_photo(mob/user)
	if(!latest_photo?.img)
		error = "Capture a photograph first."
		return FALSE
	var/file_name = copytext_char(trim(sanitize_filename(current_name)), 1, MAX_NAME_LEN + 1)
	if(!file_name)
		error = "Enter a valid file name."
		return FALSE
	if(computer.hard_drive.find_file_by_name(file_name))
		error = "[file_name] already exists on the local drive."
		return FALSE
	var/datum/computer_file/image/image_file = new()
	image_file.filename = file_name
	image_file.filedesc = current_description
	image_file.stored_icon = icon(latest_photo.img)
	image_file.author_ckey = user.ckey
	if(!computer.hard_drive.store_file(image_file))
		qdel(image_file)
		error = "Unable to save the photograph. The local drive may be full or read-only."
		return FALSE
	error = null
	message_admins("[key_name_admin(user)] saved a PDA photograph as [image_file.filename].[image_file.filetype] on [computer].")
	log_admin("[key_name(user)] saved a PDA photograph as [image_file.filename].[image_file.filetype] on [computer].")
	to_chat(user, SPAN_NOTICE("You save the photograph as [image_file.filename].[image_file.filetype]."))
	SStgui.update_uis(computer)
	return TRUE

/datum/computer_file/program/pda_camera/proc/print_photo(mob/user)
	if(!latest_photo?.img)
		error = "Capture a photograph first."
		return FALSE
	if(!computer.nano_printer)
		error = "This PDA does not have a nano-printer."
		return FALSE
	var/datum/computer_file/image/temporary_image = new()
	temporary_image.filename = current_caption || current_name
	temporary_image.filedesc = current_description
	temporary_image.stored_icon = latest_photo.img
	temporary_image.author_ckey = user.ckey
	var/result = computer.nano_printer.print_image(temporary_image, user)
	qdel(temporary_image)
	if(!result)
		error = "The printer is unavailable or out of paper."
		return FALSE
	error = null
	return TRUE

#undef PDA_CAMERA_CAPTURE_COOLDOWN
#undef PDA_CAMERA_MAX_RANGE

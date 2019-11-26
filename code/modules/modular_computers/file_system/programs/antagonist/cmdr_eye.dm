/datum/computer_file/program/syndicate/camera
	filename = "syndeye"
	filedesc = "Syndicate Camera Uplink"
	nanomodule_path = /datum/nano_module/syndicate_eye
	program_icon_state = "hostile"
	extended_desc = "Syndicate uplink technology that interfaces with a variety of surveillance equipment."
	size = 25
	available_on_ntnet = 0
	available_on_syndinet = 1
	requires_ntnet = 1
	color = LIGHT_COLOR_RED

/datum/nano_module/syndicate_eye
	name = "Syndicate Camera Uplink"
	available_to_ai = FALSE
	var/mob/abstract/eye/syndicate/eye

/datum/nano_module/syndicate_eye/New()
	. = ..()
	eye = new(src)

/datum/nano_module/syndicate_eye/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui=null, force_open = 1, state = default_state)
	var/list/data = host.initial_data()

	data["eye"] = eye

	
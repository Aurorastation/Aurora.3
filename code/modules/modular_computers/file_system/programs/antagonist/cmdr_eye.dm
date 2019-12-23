/datum/computer_file/program/syndicam
	filename = "syndeye"
	filedesc = "Syndicate Camera Monitoring"
	nanomodule_path = /datum/nano_module/syndicate_eye
	program_icon_state = "hostile"
	extended_desc = "Syndicate monitoring technology that interfaces with a variety of surveillance equipment."
	size = 25
	available_on_ntnet = 0
	available_on_syndinet = 1
	requires_ntnet = 1
	color = LIGHT_COLOR_RED

/datum/nano_module/syndicate_eye
	name = "Syndicate Camera Monitoring"
	available_to_ai = FALSE
	var/mob/abstract/eye/syndnet/eye
	var/active = FALSE

/datum/nano_module/syndicate_eye/New()
	. = ..()
	eye = new(src)

/datum/nano_module/syndicate_eye/Destroy()
	if(eye)
		eye.toggle_eye(usr)
		qdel(eye)
		eye = null

	..()

/datum/nano_module/syndicate_eye/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui=null, force_open = 1, state = default_state)
	var/list/data = host.initial_data()

	data["active"] = active

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "synd_camera.tmpl", "Syndicate Monitoring", 900, 800, state = state)
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/syndicate_eye/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["uplink"] && eye)
		active = eye.toggle_eye(usr)
		usr.rebuild_hud()

/mob/proc/rebuild_hud()
	if(client && client.screen)
		client.screen.len = null
		if(hud_used)
			qdel(hud_used)
		hud_used = new /datum/hud(src)

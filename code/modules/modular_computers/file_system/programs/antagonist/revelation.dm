/datum/computer_file/program/revelation
	filename = "revelation"
	filedesc = "Revelation"
	program_icon_state = "hostile"
	extended_desc = "This virus can destroy hard drive of system it is executed on. It may be obfuscated to look like another non-malicious program. Once armed, it will destroy the system upon next execution."
	size = 13
	requires_ntnet = FALSE
	available_on_ntnet = FALSE
	available_on_syndinet = TRUE
	nanomodule_path = /datum/nano_module/program/revelation
	var/armed = FALSE
	color = LIGHT_COLOR_RED

/datum/computer_file/program/revelation/run_program(mob/living/user)
	. = ..(user)
	if(armed)
		activate()

/datum/computer_file/program/revelation/proc/activate()
	if(!computer)
		return

	computer.visible_message(SPAN_NOTICE("\The [computer]'s screen brightly flashes and emits a loud electrical buzzing."))
	computer.enabled = FALSE
	computer.update_icon()
	spark(get_turf(src), 10, alldirs)

	if(computer.hard_drive)
		qdel(computer.hard_drive)

	if(computer.battery_module && prob(25))
		qdel(computer.battery_module)

	if(computer.tesla_link && prob(50))
		qdel(computer.tesla_link)

/datum/computer_file/program/revelation/Topic(href, href_list)
	if(..())
		return TRUE
	else if(href_list["PRG_arm"])
		armed = !armed
	else if(href_list["PRG_activate"])
		activate()
	else if(href_list["PRG_obfuscate"])
		var/mob/living/user = usr
		var/newname = sanitize(input(user, "Enter new program name: "))
		if(!newname)
			return
		filedesc = newname
	return TRUE

/datum/computer_file/program/revelation/clone()
	var/datum/computer_file/program/revelation/temp = ..()
	temp.armed = armed
	return temp

/datum/nano_module/program/revelation
	name = "Revelation Virus"

/datum/nano_module/program/revelation/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = list()
	var/datum/computer_file/program/revelation/PRG = program
	if(!istype(PRG))
		return

	data = list("_PC" = PRG.get_header_data())

	data["armed"] = PRG.armed

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "revelation.tmpl", "Revelation Virus", 400, 250, state = state)
		ui.auto_update_layout = TRUE
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)
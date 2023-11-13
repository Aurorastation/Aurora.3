/datum/computer_file/program/pai_doorjack
	filename = "doorjack"
	filedesc = "Door Jack"
	program_icon_state = "generic"
	program_key_icon_state = "green_key"
	extended_desc = "This program is used to access standard-issue pAI door jack systems."
	size = 12

	available_on_ntnet = 1
	usage_flags = PROGRAM_SILICON_PAI
	tgui_id = "pAIDoorjack"

// Gaters data for ui
/datum/computer_file/program/pai_doorjack/ui_data(mob/user)
	var/list/data = list()

	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data

	if(!istype(computer, /obj/item/modular_computer/silicon))
		return
	var/obj/item/modular_computer/silicon/true_computer = computer
	if(!istype(true_computer.computer_host, /mob/living/silicon/pai))
		return
	var/mob/living/silicon/pai/host = true_computer.computer_host

	data["extended"] = !!host.cable
	data["connected"] = !!host.cable?.machine
	data["ishacking"] = !!host.hackdoor
	data["progress"] = host.hackprogress
	data["aborted"] = host.hack_aborted

	return data

/datum/computer_file/program/pai_doorjack/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(!istype(computer, /obj/item/modular_computer/silicon))
		return
	var/obj/item/modular_computer/silicon/true_computer = computer
	if(!istype(true_computer.computer_host, /mob/living/silicon/pai))
		return
	var/mob/living/silicon/pai/host = true_computer.computer_host

	switch(action)
		if("hack")
			if(host.cable && host.cable.machine)
				host.hackdoor = host.cable.machine
				host.hackloop()
			. = TRUE
		if("cancel")
			host.hackdoor = null
			. = TRUE
		if("extend")
			var/turf/T = get_turf_or_move(host.loc)
			host.hack_aborted = 0
			host.cable = new /obj/item/pai_cable(T)
			T.visible_message(SPAN_WARNING("A port on [host] opens to reveal [host.cable], which promptly falls to the floor."),
				SPAN_WARNING("You hear the soft click of something light and hard falling to the ground."))
			. = TRUE

/mob/living/silicon/pai/proc/hackloop()
	var/turf/T = get_turf_or_move(src.loc)
	for(var/mob/living/silicon/ai/AI in player_list)
		if(T.loc)
			to_chat(AI, "<font color = red><b>Network Alert: Brute-force encryption crack in progress in [T.loc].</b></font>")
		else
			to_chat(AI, "<font color = red><b>Network Alert: Brute-force encryption crack in progress. Unable to pinpoint location.</b></font>")
	var/obj/machinery/door/airlock/D = cable.machine
	if(!istype(D))
		hack_aborted = 1
		hackprogress = 0
		cable.machine = null
		hackdoor = null
		return
	while(hackprogress < 1000)
		if(cable && cable.machine == D && cable.machine == hackdoor && get_dist(src, hackdoor) <= 1)
			hackprogress = min(hackprogress+rand(1, 20), 1000)
		else
			hack_aborted = 1
			hackprogress = 0
			hackdoor = null
			return
		if(hackprogress >= 1000)
			hackprogress = 0
			D.unlock() //unbolts door as long as bolt wires aren't cut
			D.open()
			cable.machine = null
			return
		sleep(10)			// Update every second

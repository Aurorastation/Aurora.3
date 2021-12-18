//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32





/obj/machinery/computer/telecomms/traffic
	name = "Telecommunications Traffic Control"
	icon_screen = "command"

	var/list/servers = list()	// the servers located by the computer
	var/obj/machinery/telecomms/server/current
	var/network = "NULL"		// the network to probe

	req_access = list(access_tcomsat)

/obj/machinery/computer/telecomms/traffic/attack_hand(mob/user)
	ui_interact(user)

/obj/machinery/computer/telecomms/traffic/ui_interact(mob/user)
	START_PROCESSING(SSprocessing, src)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new(user, src, "console-tcom-control", 600, 520, "Traffic control console")
	ui.open()

/obj/machinery/computer/telecomms/traffic/vueui_on_close(datum/vueui/ui)
	. = ..()
	if(!length(SSvueui.get_open_uis(src)))
		STOP_PROCESSING(SSprocessing, src)

/obj/machinery/computer/telecomms/traffic/vueui_data_change(list/data, mob/user, datum/vueui/ui)
	. = ..()
	data = . || data || list()

	data["servers"] = list()
	for(var/I in servers)
		var/obj/machinery/telecomms/T = I
		var/ref = ref(T)
		data["servers"][ref] = list()
		data["servers"][ref]["name"] = T.name
		data["servers"][ref]["id"] = T.id

	if(istype(current))
		data["current"] = list()
		data["current"]["name"] = current.name
		data["current"]["id"] = current.id
		data["current"]["code"] = current.code
		if(istype(current.program))
			data["current"]["terminal"] = current.program.buffer
	else
		data["current"] = null

	return data

/obj/machinery/computer/telecomms/traffic/Topic(href, href_list)
	if(..())
		return
	add_fingerprint(usr)

	var/datum/vueui/ui = href_list["vueui"]
	if(!istype(ui))
		return

	if(href_list["clear"])
		. = TRUE
		servers = list()
		current = null

	if(href_list["scan"])
		. = TRUE
		for(var/obj/machinery/telecomms/server/T in range(25, src))
			if(T.network == network)
				servers.Add(T)

	if(href_list["select"])
		. = TRUE
		for(var/I in servers)
			if(ref(I) == href_list["select"])
				current = I
				break

	if(href_list["submit"])
		. = TRUE
		if(istype(current))
			current.code = href_list["code"]
			if(istype(current.program))
				current.program.kill()
			current.program = SSntsl2.new_program_tcomm(current)
			current.program.execute(current.code, "script.nts", ui.user)
			current.program.update_buffer()

	if(href_list["terminal_topic"])
		if(istype(current.program))
			current.program.handle_topic(href_list["terminal_topic"])
		. = TRUE
	if(.)
		SSvueui.check_uis_for_change(src)
		return FALSE

/obj/machinery/computer/telecomms/traffic/attackby(var/obj/item/D as obj, var/mob/user as mob)
	if(D.isscrewdriver())
		playsound(src.loc, D.usesound, 50, 1)
		if(do_after(user, 20/D.toolspeed))
			if (src.stat & BROKEN)
				to_chat(user, "<span class='notice'>The broken glass falls out.</span>")
				var/obj/structure/computerframe/A = new /obj/structure/computerframe( src.loc )
				new /obj/item/material/shard( src.loc )
				var/obj/item/circuitboard/comm_traffic/M = new /obj/item/circuitboard/comm_traffic( A )
				for (var/obj/C in src)
					C.forceMove(src.loc)
				A.circuit = M
				A.state = 3
				A.icon_state = "3"
				A.anchored = 1
				qdel(src)
			else
				to_chat(user, "<span class='notice'>You disconnect the monitor.</span>")
				var/obj/structure/computerframe/A = new /obj/structure/computerframe( src.loc )
				var/obj/item/circuitboard/comm_traffic/M = new /obj/item/circuitboard/comm_traffic( A )
				for (var/obj/C in src)
					C.forceMove(src.loc)
				A.circuit = M
				A.state = 4
				A.icon_state = "4"
				A.anchored = 1
				qdel(src)
	SSvueui.check_uis_for_change(src)
	return

/obj/machinery/computer/telecomms/traffic/process()
	if(length(SSvueui.get_open_uis(src)))
		if(istype(current) && istype(current.program))
			current.program.update_buffer()
			SSvueui.check_uis_for_change(src)

/obj/machinery/computer/telecomms/traffic/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		playsound(src.loc, 'sound/effects/sparks4.ogg', 75, 1)
		emagged = 1
		to_chat(user, "<span class='notice'>You you disable the security protocols</span>")
		src.updateUsrDialog()
		return 1


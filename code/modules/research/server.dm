/obj/machinery/r_n_d/server
	name = "\improper R&D server"
	desc = "A server which houses a back-up of all station research. It can be used to restore lost data, or to act as another point of retrieval."
	icon = 'icons/obj/machinery/research.dmi'
	icon_state = "server"
	var/datum/research/files
	var/health = 100
	var/list/id_with_upload = list()	//List of R&D consoles with upload to server access.
	var/list/id_with_download = list()	//List of R&D consoles with download from server access.
	var/id_with_upload_string = ""		//String versions for easy editing in map editor.
	var/id_with_download_string = ""
	var/server_id = 0
	var/produces_heat = TRUE
	idle_power_usage = 800
	var/delay = 10
	req_access = list(ACCESS_RD) //Only the R&D can change server settings.

	var/list/linked_processors

	component_types = list(
		/obj/item/circuitboard/rdserver,
		/obj/item/stock_parts/scanning_module,
		/obj/item/stack/cable_coil = 2
	)

/obj/machinery/r_n_d/server/Destroy()
	for(var/obj/machinery/r_n_d/tech_processor/TP as anything in linked_processors)
		TP.set_server(null)
	griefProtection()
	return ..()

/obj/machinery/r_n_d/server/RefreshParts()
	var/tot_rating = 0

	for(var/obj/item/stock_parts/SP in component_parts)
		tot_rating += SP.rating
	change_power_consumption(idle_power_usage / max(1, tot_rating), POWER_USE_IDLE)

/obj/machinery/r_n_d/server/Initialize()
	. = ..()
	setup()

/obj/machinery/r_n_d/server/proc/setup()
	if(!files)
		files = new /datum/research(src)
	var/list/temp_list
	if(!id_with_upload.len)
		temp_list = list()
		temp_list = text2list(id_with_upload_string, ";")
		for(var/N in temp_list)
			id_with_upload += text2num(N)
	if(!id_with_download.len)
		temp_list = list()
		temp_list = text2list(id_with_download_string, ";")
		for(var/N in temp_list)
			id_with_download += text2num(N)

/obj/machinery/r_n_d/server/process()
	if(stat & (NOPOWER|BROKEN))
		return

	if(!loc) return
	var/datum/gas_mixture/environment = loc.return_air()
	switch(environment.temperature)
		if(0 to T0C)
			health = min(100, health + 1)
		if(T0C to (T20C + 20))
			health = between(0, health, 100)
		if((T20C + 20) to (T0C + 70))
			health = max(0, health - 1)
	if(health <= 0)
		griefProtection() //I dont like putting this in process() but it's the best I can do without re-writing a chunk of rd servers.
		files.known_designs = list()
		for(var/id in files.known_tech)
			var/datum/tech/T = files.known_tech[id]
			if(prob(1))
				T.level--
		files.RefreshResearch()
	if(delay)
		delay--
	else
		produce_heat()
		delay = initial(delay)
	upgrade_techs()

/obj/machinery/r_n_d/server/proc/upgrade_techs()
	for(var/obj/machinery/r_n_d/tech_processor/TP as anything in linked_processors)
		if(TP.stat & (NOPOWER|BROKEN))
			continue
		TP.processing_stage++
		if(TP.processing_stage == 5)
			for(var/tech_id in files.known_tech)
				var/datum/tech/T = files.known_tech[tech_id]
				if(T.level)
					files.UpdateTech(T.id, round(TP.tech_rate))
			TP.processing_stage = 0

/obj/machinery/r_n_d/server/emp_act(severity)
	. = ..()

	griefProtection()

/obj/machinery/r_n_d/server/ex_act(severity)
	griefProtection()
	..()

//Backup files to centcomm to help admins recover data after greifer attacks
/obj/machinery/r_n_d/server/proc/griefProtection()
	for(var/obj/machinery/r_n_d/server/centcom/C in SSmachinery.machinery)
		for(var/id in files.known_tech)
			var/datum/tech/T = files.known_tech[id]
			C.files.AddTech2Known(T)
		C.files.RefreshResearch()

/obj/machinery/r_n_d/server/proc/produce_heat()
	if(!produces_heat)
		return

	if(!use_power)
		return

	if(!(stat & (NOPOWER|BROKEN))) //Blatently stolen from telecoms
		var/turf/simulated/L = loc
		if(istype(L))
			var/datum/gas_mixture/env = L.return_air()

			var/transfer_moles = 0.25 * env.total_moles

			var/datum/gas_mixture/removed = env.remove(transfer_moles)

			if(removed)
				var/heat_produced = idle_power_usage	//obviously can't produce more heat than the machine draws from it's power source

				removed.add_thermal_energy(heat_produced)

			env.merge(removed)

/obj/machinery/r_n_d/server/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.ismultitool())
		var/obj/item/device/multitool/MT = attacking_item
		var/obj/machinery/r_n_d/tech_processor/TP = MT.get_buffer(/obj/machinery/r_n_d/tech_processor)
		if(TP)
			TP.set_server(src)
			MT.unregister_buffer(TP)
		to_chat(user, SPAN_NOTICE("You link \the [TP] to \the [src]."))
		return
	if(default_deconstruction_screwdriver(user, attacking_item))
		return
	if(default_deconstruction_crowbar(user, attacking_item))
		return
	if(default_part_replacement(user, attacking_item))
		return

/obj/machinery/r_n_d/server/centcom
	name = "central R&D database"
	server_id = -1

/obj/machinery/r_n_d/server/centcom/setup()
	..()
	var/list/no_id_servers = list()
	var/list/server_ids = list()
	for(var/obj/machinery/r_n_d/server/S in SSmachinery.machinery)
		switch(S.server_id)
			if(-1)
				continue
			if(0)
				no_id_servers += S
			else
				server_ids += S.server_id

	for(var/obj/machinery/r_n_d/server/S in no_id_servers)
		var/num = 1
		while(!S.server_id)
			if(num in server_ids)
				num++
			else
				S.server_id = num
				server_ids += num
		no_id_servers -= S

/obj/machinery/r_n_d/server/centcom/process()
	return PROCESS_KILL //don't need process()

/obj/machinery/r_n_d/server/advanced //an advanced server that starts with higher tech levels

/obj/machinery/r_n_d/server/advanced/setup()
	if(!files)
		files = new /datum/research/hightech(src)
	var/list/temp_list
	if(!id_with_upload.len)
		temp_list = list()
		temp_list = text2list(id_with_upload_string, ";")
		for(var/N in temp_list)
			id_with_upload += text2num(N)
	if(!id_with_download.len)
		temp_list = list()
		temp_list = text2list(id_with_download_string, ";")
		for(var/N in temp_list)
			id_with_download += text2num(N)

/obj/machinery/computer/rdservercontrol
	name = "R&D server controller"
	desc = "A console use to operate a RnD server, such as locking it, wiping it, or downloading its stored research."

	icon_screen = "rdcomp"
	icon_keyboard = "purple_key"
	light_color = LIGHT_COLOR_PURPLE

	circuit = /obj/item/circuitboard/rdservercontrol
	var/screen = 0
	var/obj/machinery/r_n_d/server/temp_server
	var/list/servers = list()
	var/list/consoles = list()
	var/badmin = 0

/obj/machinery/computer/rdservercontrol/Topic(href, href_list)
	if(..())
		return 1

	add_fingerprint(usr)
	usr.set_machine(src)
	if(!allowed(usr) && !emagged)
		to_chat(usr, "<span class='warning'>You do not have the required access level</span>")
		return

	if(href_list["main"])
		screen = 0

	else if(href_list["access"] || href_list["data"] || href_list[TRANSFER_CREW])
		temp_server = null
		consoles = list()
		servers = list()
		var/turf/T = get_turf(src)
		for(var/obj/machinery/r_n_d/server/S in SSmachinery.machinery)
			var/turf/ST = get_turf(S)
			if(ST && !AreConnectedZLevels(ST.z, T.z))
				continue
			if(S.server_id == text2num(href_list["access"]) || S.server_id == text2num(href_list["data"]) || S.server_id == text2num(href_list[TRANSFER_CREW]))
				temp_server = S
				break
		if(href_list["access"])
			screen = 1
			for(var/obj/machinery/computer/rdconsole/C in SSmachinery.machinery)
				var/turf/CT = get_turf(C)
				if(CT && !AreConnectedZLevels(CT.z, T.z))
					continue
				if(C.sync)
					consoles += C
		else if(href_list["data"])
			screen = 2
		else if(href_list[TRANSFER_CREW])
			screen = 3
			for(var/obj/machinery/r_n_d/server/S in SSmachinery.machinery)
				var/turf/ST = get_turf(S)
				if(S == src || (ST && !AreConnectedZLevels(ST.z, T.z)))
					continue
				servers += S

	else if(href_list["upload_toggle"])
		var/num = text2num(href_list["upload_toggle"])
		if(num in temp_server.id_with_upload)
			temp_server.id_with_upload -= num
		else
			temp_server.id_with_upload += num

	else if(href_list["download_toggle"])
		var/num = text2num(href_list["download_toggle"])
		if(num in temp_server.id_with_download)
			temp_server.id_with_download -= num
		else
			temp_server.id_with_download += num

	else if(href_list["reset_tech"])
		var/choice = alert("Technology Data Rest", "Are you sure you want to reset this technology to its default data? Data lost cannot be recovered.", "Continue", "Cancel")
		if(choice == "Continue")
			for(var/datum/tech/T in temp_server.files.known_tech)
				if(T.id == href_list["reset_tech"])
					T.level = 1
					break
		temp_server.files.RefreshResearch()

	else if(href_list["reset_design"])
		var/choice = alert("Design Data Deletion", "Are you sure you want to delete this design? If you still have the prerequisites for the design, it'll reset to its base reliability. Data lost cannot be recovered.", "Continue", "Cancel")
		if(choice == "Continue")
			temp_server.files.known_designs -= href_list["reset_design"]
			temp_server.files.RefreshResearch()

	updateUsrDialog()
	return

/obj/machinery/computer/rdservercontrol/attack_hand(mob/user as mob)
	if(stat & (BROKEN|NOPOWER))
		return
	user.set_machine(src)
	var/dat = ""

	switch(screen)
		if(0) //Main Menu
			dat += "Connected Servers:<BR><BR>"
			var/turf/T = get_turf(src)
			for(var/obj/machinery/r_n_d/server/S in SSmachinery.machinery)
				var/turf/ST = get_turf(S)
				if((istype(S, /obj/machinery/r_n_d/server/centcom) && !badmin) || (ST && !AreConnectedZLevels(ST.z, T.z)))
					continue
				dat += "[S.name] || "
				dat += "<A href='?src=\ref[src];access=[S.server_id]'> Access Rights</A> | "
				dat += "<A href='?src=\ref[src];data=[S.server_id]'>Data Management</A>"
				if(badmin) dat += " | <A href='?src=\ref[src];transfer=[S.server_id]'>Server-to-Server Transfer</A>"
				dat += "<BR>"

		if(1) //Access rights menu
			dat += "[temp_server.name] Access Rights<BR><BR>"
			dat += "Consoles with Upload Access<BR>"
			for(var/obj/machinery/computer/rdconsole/C in consoles)
				var/turf/console_turf = get_turf(C)
				dat += "* <A href='?src=\ref[src];upload_toggle=[C.id]'>[console_turf.loc]" //FYI, these are all numeric ids, eventually.
				if(C.id in temp_server.id_with_upload)
					dat += " (Remove)</A><BR>"
				else
					dat += " (Add)</A><BR>"
			dat += "Consoles with Download Access<BR>"
			for(var/obj/machinery/computer/rdconsole/C in consoles)
				var/turf/console_turf = get_turf(C)
				dat += "* <A href='?src=\ref[src];download_toggle=[C.id]'>[console_turf.loc]"
				if(C.id in temp_server.id_with_download)
					dat += " (Remove)</A><BR>"
				else
					dat += " (Add)</A><BR>"
			dat += "<HR><A href='?src=\ref[src];main=1'>Main Menu</A>"

		if(2) //Data Management menu
			dat += "[temp_server.name] Data ManagementP<BR><BR>"
			dat += "Known Technologies<BR>"
			for(var/path in temp_server.files.known_tech)
				var/datum/tech/T = temp_server.files.known_tech[path]
				dat += "* [T.name] "
				dat += "<A href='?src=\ref[src];reset_tech=[T.id]'>(Reset)</A><BR>"
			dat += "Known Designs<BR>"
			for(var/path in temp_server.files.known_designs)
				var/datum/design/D = temp_server.files.known_designs[path]
				dat += "* [D.name] "
				dat += "<A href='?src=\ref[src];reset_design=[path]'>(Delete)</A><BR>"
			dat += "<HR><A href='?src=\ref[src];main=1'>Main Menu</A>"

		if(3) //Server Data Transfer
			dat += "[temp_server.name] Server to Server Transfer<BR><BR>"
			dat += "Send Data to what server?<BR>"
			for(var/obj/machinery/r_n_d/server/S in servers)
				dat += "[S.name] <A href='?src=\ref[src];send_to=[S.server_id]'> (Transfer)</A><BR>"
			dat += "<HR><A href='?src=\ref[src];main=1'>Main Menu</A>"
	user << browse("<TITLE>R&D Server Control</TITLE><HR>[dat]", "window=server_control;size=575x400")
	onclose(user, "server_control")
	return

/obj/machinery/computer/rdservercontrol/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		playsound(src.loc, 'sound/effects/sparks4.ogg', 75, 1)
		emagged = 1
		to_chat(user, "<span class='notice'>You you disable the security protocols.</span>")
		src.updateUsrDialog()
		return 1

/obj/machinery/r_n_d/server/advanced/robotics
	name = "robotics R&D server"
	id_with_upload_string = "1;2"
	id_with_download_string = "1;2"
	server_id = 2

/obj/machinery/r_n_d/server/advanced/core
	name = "core R&D server"
	id_with_upload_string = "1"
	id_with_download_string = "1"
	server_id = 1

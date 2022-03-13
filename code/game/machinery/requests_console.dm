/******************** Requests Console ********************/
/** Originally written by errorage, updated by: Carn, needs more work though. I just added some security fixes */

//Requests Console Department Types
#define RC_ASSIST 1		//Request Assistance
#define RC_SUPPLY 2		//Request Supplies
#define RC_INFO   4		//Relay Info

//Requests Console Screens
#define RCS_MAINMENU 0	// Main menu
#define RCS_RQASSIST 1	// Request supplies
#define RCS_RQSUPPLY 2	// Request assistance
#define RCS_SENDINFO 3	// Relay information
#define RCS_SENTPASS 4	// Message sent successfully
#define RCS_SENTFAIL 5	// Message sent unsuccessfully
#define RCS_VIEWMSGS 6	// View messages
#define RCS_MESSAUTH 7	// Authentication before sending
#define RCS_ANNOUNCE 8	// Send announcement
#define RCS_FORMS	 9	// Forms database

var/req_console_assistance = list()
var/req_console_supplies = list()
var/req_console_information = list()
var/list/obj/machinery/requests_console/allConsoles = list()

/obj/machinery/requests_console
	name = "Requests Console"
	desc = "A console intended to send requests to different departments on the station."
	icon = 'icons/obj/terminals.dmi'
	icon_state = "req_comp"
	component_types = list(
			/obj/item/circuitboard/requestconsole,
			/obj/item/stock_parts/capacitor,
			/obj/item/stock_parts/console_screen,
		)
	anchored = TRUE
	appearance_flags = TILE_BOUND // prevents people from viewing the overlay through a wall
	var/department = "Unknown" //The list of all departments on the station (Determined from this variable on each unit) Set this to the same thing if you want several consoles in one department
	var/list/message_log = list() //List of all messages
	var/departmentType = 0 		//Bitflag. Zero is reply-only. Map currently uses raw numbers instead of defines.
	var/newmessagepriority = 0
		// 0 = no new message
		// 1 = normal priority
		// 2 = high priority
	var/screen = RCS_MAINMENU
	var/silent = 0 // set to 1 for it not to beep all the time
//	var/hackState = 0
		// 0 = not hacked
		// 1 = hacked
	var/announcementConsole = 0
		// 0 = This console cannot be used to send department announcements
		// 1 = This console can send department announcementsf
	var/open = 0 // 1 if open
	var/announceAuth = 0 //Will be set to 1 when you authenticate yourself for announcements
	var/msgVerified = "" //Will contain the name of the person who varified it
	var/msgStamped = "" //If a message is stamped, this will contain the stamp name
	var/message = "";
	var/recipient = ""; //the department which will be receiving the message
	var/priority = -1 ; //Priority of the message being sent

	//Form intregration
	var/SQLquery
	var/paperstock = 20
	var/lid = 0
	//End Form Integration
	var/datum/announcement/announcement = new
	var/list/obj/item/modular_computer/alert_pdas = list() //The PDAs we alert upon a request receipt.
	var/global/list/screen_overlays

/obj/machinery/requests_console/proc/generate_overlays(var/force = 0)
	if(LAZYLEN(screen_overlays) && !force)
		return
	LAZYINITLIST(screen_overlays)
	screen_overlays["req_comp-idle"] = make_screen_overlay(icon, "req_comp-idle")
	screen_overlays["req_comp-alert"] = make_screen_overlay(icon, "req_comp-alert")
	screen_overlays["req_comp-redalert"] = make_screen_overlay(icon, "req_comp-redalert")
	screen_overlays["req_comp-yellowalert"] = make_screen_overlay(icon, "req_comp-yellowalert")
	screen_overlays["req_comp-scanline"] = make_screen_overlay(icon, "req_comp-scanline")

/obj/machinery/requests_console/power_change()
	..()
	update_icon()

/obj/machinery/requests_console/update_icon()
	cut_overlays()
	if(stat & NOPOWER)
		icon_state = initial(icon_state)
		set_light(FALSE)
	else
		switch(newmessagepriority)
			if(0)
				add_overlay(screen_overlays["req_comp-idle"])
				set_light(1.4, 1.3, COLOR_CYAN)
			if(1)
				add_overlay(screen_overlays["req_comp-alert"])
				set_light(1.4, 1.3, COLOR_CYAN)
			if(2)
				add_overlay(screen_overlays["req_comp-redalert"])
				set_light(1.4, 1.3, COLOR_ORANGE)
			if(3)
				add_overlay(screen_overlays["req_comp-yellowalert"])
				set_light(1.4, 1.3, COLOR_ORANGE)

		add_overlay(screen_overlays["req_comp-scanline"])

/obj/machinery/requests_console/Initialize(mapload, var/dir, var/building = 0)
	. = ..()

	if(building)
		if(dir)
			src.set_dir(dir)

		pixel_x = (dir & 3)? 0 : (dir == 4 ? -24 : 24)
		pixel_y = (dir & 3)? (dir ==1 ? -24 : 24) : 0
		update_icon()
		return

	announcement.title = "[department] announcement"
	announcement.newscast = 1

	name = "[department] Requests Console"
	allConsoles += src
	if (departmentType & RC_ASSIST)
		req_console_assistance |= department
	if (departmentType & RC_SUPPLY)
		req_console_supplies |= department
	if (departmentType & RC_INFO)
		req_console_information |= department
	generate_overlays()
	update_icon()

/obj/machinery/requests_console/Destroy()
	allConsoles -= src
	var/lastDeptRC = 1
	for (var/obj/machinery/requests_console/Console in allConsoles)
		if (Console.department == department)
			lastDeptRC = 0
			break
	if(lastDeptRC)
		if (departmentType & RC_ASSIST)
			req_console_assistance -= department
		if (departmentType & RC_SUPPLY)
			req_console_supplies -= department
		if (departmentType & RC_INFO)
			req_console_information -= department

		alert_pdas.Cut()
	return ..()

/obj/machinery/requests_console/attack_hand(user as mob)
	if(..(user))
		return
	ui_interact(user)

/obj/machinery/requests_console/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	data["department"] = department
	data["screen"] = screen
	data["message_log"] = message_log
	data["newmessagepriority"] = newmessagepriority
	data["silent"] = silent
	data["announcementConsole"] = announcementConsole

	data["assist_dept"] = req_console_assistance
	data["supply_dept"] = req_console_supplies
	data["info_dept"]   = req_console_information

	data["message"] = message
	data["recipient"] = recipient
	data["priortiy"] = priority
	data["msgStamped"] = msgStamped
	data["msgVerified"] = msgVerified
	data["announceAuth"] = announceAuth

	if (screen == RCS_FORMS)
		if (!establish_db_connection(dbcon))
			data["sql_error"] = 1
		else
			if (!SQLquery)
				SQLquery = "SELECT id, name, department FROM ss13_forms ORDER BY id"

			var/DBQuery/query = dbcon.NewQuery(SQLquery)
			query.Execute()

			var/list/forms = list()
			while (query.NextRow())
				forms += list(list("id" = query.item[1], "name" = query.item[2], "department" = query.item[3]))

			if (!forms.len)
				data["sql_error"] = 1

			data["forms"] = forms

	data["pda_list"] = list()

	for (var/A in alert_pdas)
		var/obj/item/modular_computer/pda = A
		data["pda_list"] += list(list("name" = alert_pdas[pda], "pda" = "\ref[pda]"))

	data["lid"] = lid
	data["paper"] = paperstock

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "requests_console.tmpl", "[department] Requests Console", 520, 410)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/requests_console/Topic(href, href_list)
	if(..())	return
	usr.set_machine(src)
	add_fingerprint(usr)

	if(reject_bad_text(href_list["write"]))
		recipient = href_list["write"] //write contains the string of the receiving department's name

		var/new_message = sanitize(input("Write your message:", "Awaiting Input", ""))
		if(new_message)
			message = new_message
			screen = RCS_MESSAUTH
			switch(href_list["priority"])
				if("1") priority = 1
				if("2")	priority = 2
				else	priority = 0
		else
			reset_message(1)

	if(href_list["writeAnnouncement"])
		var/new_message = sanitize(input("Write your message:", "Awaiting Input", ""))
		if(new_message)
			message = new_message
		else
			reset_message(1)

	if(href_list["sendAnnouncement"])
		if(!announcementConsole)	return
		announcement.Announce(message, msg_sanitized = 1)
		reset_message(1)

	if( href_list["department"] && message )
		var/log_msg = message
		var/pass = FALSE
		screen = RCS_SENTFAIL
		for(var/obj/machinery/message_server/MS in SSmachinery.processing_machines)
			if(!MS.active)
				continue
			MS.send_rc_message(ckey(href_list["department"]), department, log_msg, msgStamped, msgVerified, priority)
			pass = TRUE
		if(pass)
			screen = RCS_SENTPASS
			message_log += "<B>Message sent to [recipient]</B><BR>[message]"
		else
			var/msg = "NOTICE: No server detected!"
			audible_message("<b>The Requests Console</b> beeps, [SPAN_WARNING(msg)]")

	//Handle screen switching
	if(href_list["setScreen"])
		var/tempScreen = text2num(href_list["setScreen"])
		if(tempScreen == RCS_ANNOUNCE && !announcementConsole)
			return
		if(tempScreen == RCS_VIEWMSGS)
			for (var/obj/machinery/requests_console/Console in allConsoles)
				if (Console.department == department)
					Console.newmessagepriority = 0
					Console.icon_state = "req_comp0"
					Console.set_light(0)
		if(tempScreen == RCS_MAINMENU)
			reset_message()
		screen = tempScreen

	//Handle silencing the console
	if(href_list["toggleSilent"])
		silent = !silent

	// Link a PDA
	if(href_list["linkpda"])
		var/obj/item/modular_computer/pda = usr.get_active_hand()
		if (!pda || !istype(pda))
			to_chat(usr, "<span class='warning'>You need to be holding a handheld computer to link it.</span>")
		else if (pda in alert_pdas)
			to_chat(usr, "<span class='notice'>\The [pda] appears to be already linked.</span>")
			//Update the name real quick.
			alert_pdas[pda] = pda.name
		else
			alert_pdas += pda
			alert_pdas[pda] = pda.name
			to_chat(usr, "<span class='notice'>You link \the [pda] to \the [src]. It will now ping upon the arrival of a request to this machine.</span>")

	// Unlink a PDA.
	if(href_list["unlink"])
		var/obj/item/modular_computer/pda = locate(href_list["unlink"])
		if (pda && istype(pda))
			if (pda in alert_pdas)
				to_chat(usr, "<span class='notice'>You unlink [alert_pdas[pda]] from \the [src]. It will no longer be notified of new requests.</span>")
				alert_pdas -= pda

	// Sort the forms.
	if(href_list["sort"])
		var/sortdep = sanitizeSQL(href_list["sort"])
		SQLquery = "SELECT id, name, department FROM ss13_forms WHERE department LIKE '%[sortdep]%' ORDER BY id"

	if (href_list["resetSQL"])
		SQLquery = "SELECT id, name, department FROM ss13_forms ORDER BY id"

	// Print a form.
	if(href_list["print"])
		var/printid = sanitizeSQL(href_list["print"])

		if(!establish_db_connection(dbcon))
			alert("Connection to the database lost. Aborting.")
		if(!printid)
			alert("Invalid query. Try again.")
		var/DBQuery/query = dbcon.NewQuery("SELECT id, name, data FROM ss13_forms WHERE id=[printid]")
		query.Execute()

		while(query.NextRow())
			var/id = query.item[1]
			var/name = query.item[2]
			var/data = query.item[3]
			var/obj/item/paper/C = new()
			C.color = "#fff9e8"

			//Let's start the BB >> HTML conversion!

			data = html_encode(data)
			C.set_content("NFC-[id] - [name]", data)
			print(C)

			paperstock--

	// Get extra information about the form.
	if(href_list["whatis"])
		var/whatisid = sanitizeSQL(href_list["whatis"])

		if(!establish_db_connection(dbcon))
			alert("Connection to the database lost. Aborting.")
		if(!whatisid)
			alert("Invalid query. Try again.")
		var/DBQuery/query = dbcon.NewQuery("SELECT id, name, department, info FROM ss13_forms WHERE id=[whatisid]")
		query.Execute()
		var/dat = "<center><b>NanoTrasen Corporate Form</b><br>"
		while(query.NextRow())
			var/id = query.item[1]
			var/name = query.item[2]
			var/department = query.item[3]
			var/info = query.item[4]

			dat += "<b>NCF-[id]</b><br><br>"
			dat += "<b>[name]</b><br>"
			dat += "<b>[department] Department</b><hr>"
			dat += "[info]"
		dat += "</center>"
		usr << browse(dat, "window=Information;size=560x240")

	// Toggle the paper bin lid.
	if(href_list["setLid"])
		lid = !lid
		to_chat(usr, "<span class='notice'>You [lid ? "open" : "close"] the lid.</span>")

	updateUsrDialog()
	return

					//err... hacking code, which has no reason for existing... but anyway... it was once supposed to unlock priority 3 messanging on that console (EXTREME priority...), but the code for that was removed.
/obj/machinery/requests_console/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if (istype(O, /obj/item/card/id))
		if(inoperable(MAINT)) return
		if(screen == RCS_MESSAUTH)
			var/obj/item/card/id/T = O
			msgVerified = text("<font color='green'><b>Verified by [T.registered_name] ([T.assignment])</b></font>")
			updateUsrDialog()
		if(screen == RCS_ANNOUNCE)
			var/obj/item/card/id/ID = O
			if (access_RC_announce in ID.GetAccess())
				announceAuth = 1
				announcement.announcer = ID.assignment ? "[ID.assignment] [ID.registered_name]" : ID.registered_name
			else
				reset_message()
				to_chat(user, "<span class='warning'>You are not authorized to send announcements.</span>")
			updateUsrDialog()
	else if (istype(O, /obj/item/stamp))
		if(inoperable(MAINT)) return
		if(screen == RCS_MESSAUTH)
			var/obj/item/stamp/T = O
			msgStamped = text("<span class='notice'><b>Stamped with the [T.name]</b></span>")
			updateUsrDialog()
	else if (istype(O, /obj/item/paper_bundle))
		var/obj/item/paper_bundle/C = O
		if(lid)
			if(alert(user, "Do you want to restock \the [src] with \the [O]?", "Paper Restocking", "Yes", "No") == "No")
				to_chat(user, SPAN_NOTICE("You decide against restocking \the [src], noting that the lid is still open."))
				return
			paperstock += C.amount
			user.drop_from_inventory(C,get_turf(src))
			qdel(C)
			audible_message("<b>The Requests Console</b> beeps, \"Paper added.\"")
		else if(screen == RCS_MAINMENU)	//Faxing them papers
			fax_send(O, user)
	else if (istype(O, /obj/item/paper))
		if(lid)
			if(alert(user, "Do you want to restock \the [src] with \the [O]?", "Paper Restocking", "Yes", "No") == "No")
				to_chat(user, SPAN_NOTICE("You decide against restocking \the [src], noting that the lid is still open."))
				return
			var/obj/item/paper/C = O
			user.drop_from_inventory(C,get_turf(src))
			qdel(C)
			paperstock++
			audible_message("<b>The Requests Console</b> beeps, \"Paper added.\"")
		else if(screen == RCS_MAINMENU)	//Faxing them papers
			fax_send(O, user)

/obj/machinery/requests_console/proc/can_send()
	for(var/obj/machinery/message_server/MS in SSmachinery.processing_machines)
		if(!MS.active)
			continue
		return TRUE
	return FALSE

/obj/machinery/requests_console/proc/fax_send(var/obj/item/O, var/mob/user)
	var/sendto = input("Select department.", "Send Fax", null, null) as null|anything in allConsoles
	if(!sendto)
		return
	if(!can_send())
		var/msg = "NOTICE: No server detected!"
		audible_message("<b>The Requests Console</b> beeps, [SPAN_WARNING(msg)]")
		return
	for(var/cc in allConsoles)
		var/obj/machinery/requests_console/Console = cc
		if(Console == sendto)
			var/paperstock_usage = 1
			var/is_paper_bundle = istype(O, /obj/item/paper_bundle)
			if(is_paper_bundle)
				var/obj/item/paper_bundle/OPB = O
				paperstock_usage = OPB.amount
			if(Console.paperstock < paperstock_usage)
				audible_message("<b>The Requests Console</b> beeps, \"Error! Receiving console out of paper! Aborting!\"")
				return
			playsound(Console.loc, 'sound/machines/twobeep.ogg')
			playsound(Console.loc, 'sound/items/polaroid1.ogg')
			if(!is_paper_bundle)
				var/obj/item/paper/P = copy(Console, O, FALSE, FALSE, 0, 15)
				P.forceMove(Console.loc)
			else
				var/obj/item/paper_bundle/PB = bundlecopy(Console, O, FALSE, 15, FALSE)
				PB.forceMove(Console.loc)
			Console.audible_message("<b>The Requests Console</b> beeps, \"Fax received.\"")
			for(var/obj/item/modular_computer/pda in Console.alert_pdas)
				var/message = "A fax has arrived!"
				pda.get_notification(message, 1, "[Console.department] Requests Console")
			Console.paperstock -= paperstock_usage
			audible_message("<b>The Requests Console</b> beeps, \"Fax sent.\"")
			return

/obj/machinery/requests_console/proc/reset_message(var/mainmenu = 0)
	message = ""
	recipient = ""
	priority = 0
	msgVerified = ""
	msgStamped = ""
	announceAuth = 0
	announcement.announcer = ""
	if(mainmenu)
		screen = RCS_MAINMENU

/******************** Requests Console ********************/
/** Originally written by errorage, updated by: Carn, needs more work though. I just added some security fixes */

#define PRESET_NORTH \
dir = NORTH; \
pixel_y = 30;

#define PRESET_SOUTH \
dir = SOUTH; \
pixel_y = -24;

#define PRESET_WEST \
dir = WEST; \
pixel_x = -12;

#define PRESET_EAST \
dir = EAST; \
pixel_x = 12;


//Requests Console Department Types
#define RC_ASSIST 1		//Request Assistance
#define RC_SUPPLY 2		//Request Supplies
#define RC_INFO   4		//Relay Info

//Requests Console Screens

///Main menu
#define RCS_MAINMENU 0
///Request supplies
#define RCS_RQASSIST 1
///Request assistance
#define RCS_RQSUPPLY 2
///Relay information
#define RCS_SENDINFO 3
///Message sent successfully
#define RCS_SENTPASS 4
///Message sent unsuccessfully
#define RCS_SENTFAIL 5
///View messages
#define RCS_VIEWMSGS 6
///Authentication before sending
#define RCS_MESSAUTH 7
///Send announcement
#define RCS_ANNOUNCE 8
///Forms database
#define RCS_FORMS	 9

GLOBAL_LIST_INIT(req_console_assistance, list())
GLOBAL_LIST_INIT(req_console_supplies, list())
GLOBAL_LIST_INIT(req_console_information, list())
GLOBAL_LIST_INIT_TYPED(allConsoles, /obj/machinery/requests_console, list())

/obj/machinery/requests_console
	name = "requests console"
	desc = "A console intended to send requests to different departments on the station."
	icon = 'icons/obj/machinery/wall/terminals.dmi'
	icon_state = "req_comp"
	component_types = list(
			/obj/item/circuitboard/requestconsole,
			/obj/item/stock_parts/capacitor,
			/obj/item/stock_parts/console_screen,
		)
	anchored = TRUE
	appearance_flags = TILE_BOUND // prevents people from viewing the overlay through a wall
	z_flags = ZMM_MANGLE_PLANES

	///The list of all departments on the station (Determined from this variable on each unit) Set this to the same thing if you want several consoles in one department
	var/department = "Unknown"

	///The list of all messages
	var/list/message_log = list()

	///Bitflag. Zero is reply-only. Map currently uses raw numbers instead of defines.
	var/departmentType = 0

	/**
	 * The new message priority
	 *
	 * 0 = no new message
	 * 1 = normal priority
	 * 2 = high priority
	 */
	var/newmessagepriority = 0

	var/screen = RCS_MAINMENU

	///If the request console is muted, boolean
	var/silent = FALSE

	///If this console can be used to send department announcements, boolean
	var/announcementConsole = FALSE

	///If the console is open, boolean
	var/open = FALSE

	///If the console is authenticated, internal
	var/announceAuth = FALSE

	///Name of the person who varified it
	var/msgVerified = ""

	///Name of the person who stamped the message, if stamped
	var/msgStamped = ""
	var/message = "";

	///The department which will be receiving the message
	var/recipient = "";

	///Priority of the message being sent
	var/priority = -1 ;

	//Form intregration
	var/SQLquery
	var/paperstock = 20
	var/lid = 0
	//End Form Integration
	var/datum/announcement/announcement = new

	///List of PDAs we alert upon a request receipt
	var/list/obj/item/modular_computer/alert_pdas = list()

/obj/machinery/requests_console/north
	PRESET_NORTH

/obj/machinery/requests_console/south
	PRESET_SOUTH

/obj/machinery/requests_console/west
	PRESET_WEST

/obj/machinery/requests_console/east
	PRESET_EAST

/obj/machinery/requests_console/power_change()
	..()
	update_icon()

/obj/machinery/requests_console/update_icon()
	ClearOverlays()
	var/mutable_appearance/screen = overlay_image(icon, "req_comp-idle")
	var/mutable_appearance/screen_hologram = overlay_image(icon, "req_comp-idle")
	var/mutable_appearance/screen_emis = emissive_appearance(icon, "req_comp-idle")
	screen_hologram.filters += filter(type="color", color=list(
		0, 0, 0, 0,
		0, 0, 0, 0,
		0, 0, 0, 0,
		HOLOSCREEN_MULTIPLICATION_FACTOR, HOLOSCREEN_MULTIPLICATION_FACTOR, HOLOSCREEN_MULTIPLICATION_FACTOR, HOLOSCREEN_MULTIPLICATION_OPACITY
	))
	screen.filters += filter(type="color", color=list(
		HOLOSCREEN_ADDITION_OPACITY, 0, 0, 0,
		0, HOLOSCREEN_ADDITION_OPACITY, 0, 0,
		0, 0, HOLOSCREEN_ADDITION_OPACITY, 0,
		0, 0, 0, 1
	))
	screen_hologram.blend_mode = BLEND_MULTIPLY
	screen.blend_mode = BLEND_ADD
	if(stat & NOPOWER)
		icon_state = initial(icon_state)
		set_light(FALSE)
	else
		switch(newmessagepriority)
			if(0)
				screen = overlay_image(icon, "req_comp-idle")
				set_light(1.4, 1.3, COLOR_CYAN)
			if(1)
				screen = overlay_image(icon, "req_comp-alert")
				set_light(1.4, 1.3, COLOR_CYAN)
			if(2)
				screen = overlay_image(icon, "req_comp-redalert")
				set_light(1.4, 1.3, COLOR_ORANGE)
			if(3)
				screen = overlay_image(icon, "req_comp-yellowalert")
				set_light(1.4, 1.3, COLOR_ORANGE)
		AddOverlays(screen_hologram)
		AddOverlays(screen)
		AddOverlays(screen_emis)
		AddOverlays(overlay_image(icon, "req_comp-scanline"))

/obj/machinery/requests_console/Initialize(mapload, var/dir, var/building = 0)
	. = ..()

	desc = "A console intended to send requests to different departments on the [station_name(TRUE)]."
	if(building)
		if(dir)
			src.set_dir(dir)
		if(src.dir & NORTH)
			alpha = 127
		update_icon()

		if(!mapload)
			set_pixel_offsets()

		return

	if(dir & NORTH)
		alpha = 127

	announcement.title = "[department] announcement"
	announcement.newscast = 1

	name = "[department] requests console"
	GLOB.allConsoles += src
	if (departmentType & RC_ASSIST)
		GLOB.req_console_assistance |= department
	if (departmentType & RC_SUPPLY)
		GLOB.req_console_supplies |= department
	if (departmentType & RC_INFO)
		GLOB.req_console_information |= department
	update_icon()

	if(!mapload)
		set_pixel_offsets()

/obj/machinery/requests_console/set_pixel_offsets()
	pixel_x = DIR2PIXEL_X(dir)
	pixel_y = DIR2PIXEL_Y(dir)

/obj/machinery/requests_console/Destroy()
	GLOB.allConsoles -= src
	var/lastDeptRC = 1
	for (var/obj/machinery/requests_console/Console in GLOB.allConsoles)
		if (Console.department == department)
			lastDeptRC = 0
			break
	if(lastDeptRC)
		if (departmentType & RC_ASSIST)
			GLOB.req_console_assistance -= department
		if (departmentType & RC_SUPPLY)
			GLOB.req_console_supplies -= department
		if (departmentType & RC_INFO)
			GLOB.req_console_information -= department

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

	data["assist_dept"] = GLOB.req_console_assistance
	data["supply_dept"] = GLOB.req_console_supplies
	data["info_dept"]   = GLOB.req_console_information

	data["message"] = message
	data["recipient"] = recipient
	data["priortiy"] = priority
	data["msgStamped"] = msgStamped
	data["msgVerified"] = msgVerified
	data["announceAuth"] = announceAuth

	if (screen == RCS_FORMS)
		if (!establish_db_connection(GLOB.dbcon))
			data["sql_error"] = 1
		else
			if (!SQLquery)
				SQLquery = "SELECT id, name, department FROM ss13_forms ORDER BY id"

			var/DBQuery/query = GLOB.dbcon.NewQuery(SQLquery)
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
		data["pda_list"] += list(list("name" = alert_pdas[pda], "pda" = "[REF(pda)]"))

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

		var/new_message = sanitize(input("Write your message:", "Awaiting Input", null) as null|text)
		if(new_message && !use_check_and_message(usr))
			message = new_message
			screen = RCS_MESSAUTH
			switch(href_list["priority"])
				if("1") priority = 1
				if("2")	priority = 2
				else	priority = 0
		else
			reset_message(1)

	if(href_list["writeAnnouncement"])
		var/new_message = sanitize(input("Write your message:", "Awaiting Input", null) as null|text)
		if(new_message && !use_check_and_message(usr))
			message = new_message
		else
			reset_message(1)

	if(href_list["sendAnnouncement"])
		if(!announcementConsole)	return
		announcement.Announce(message, msg_sanitized = 1)
		reset_message(1)

	if( href_list["department"] && message )
		var/log_msg = message
		screen = RCS_SENTFAIL
		var/pass = FALSE
		var/datum/data_rc_msg/log = new(href_list["department"], department, log_msg, msgStamped, msgVerified, priority)
		for (var/obj/machinery/telecomms/message_server/MS in SSmachinery.all_telecomms)
			if (MS.use_power)
				MS.rc_msgs += log
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
			for (var/obj/machinery/requests_console/Console in GLOB.allConsoles)
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
			to_chat(usr, SPAN_WARNING("You need to be holding a handheld computer to link it."))
		else if (pda in alert_pdas)
			to_chat(usr, SPAN_NOTICE("\The [pda] appears to be already linked."))
			//Update the name real quick.
			alert_pdas[pda] = pda.name
		else
			alert_pdas += pda
			alert_pdas[pda] = pda.name
			to_chat(usr, SPAN_NOTICE("You link \the [pda] to \the [src]. It will now ping upon the arrival of a request to this machine."))

	// Unlink a PDA.
	if(href_list["unlink"])
		var/obj/item/modular_computer/pda = locate(href_list["unlink"])
		if (pda && istype(pda))
			if (pda in alert_pdas)
				to_chat(usr, SPAN_NOTICE("You unlink [alert_pdas[pda]] from \the [src]. It will no longer be notified of new requests."))
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

		if(!establish_db_connection(GLOB.dbcon))
			alert("Connection to the database lost. Aborting.")
		if(!printid)
			alert("Invalid query. Try again.")
		var/DBQuery/query = GLOB.dbcon.NewQuery("SELECT id, name, data FROM ss13_forms WHERE id=[printid]")
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
			print(C, user = usr)

			paperstock--

	// Get extra information about the form.
	if(href_list["whatis"])
		var/whatisid = sanitizeSQL(href_list["whatis"])

		if(!establish_db_connection(GLOB.dbcon))
			alert("Connection to the database lost. Aborting.")
		if(!whatisid)
			alert("Invalid query. Try again.")
		var/DBQuery/query = GLOB.dbcon.NewQuery("SELECT id, name, department, info FROM ss13_forms WHERE id=[whatisid]")
		query.Execute()
		var/dat = "<center><b>Stellar Corporate Conglomerate Form</b><br>"
		while(query.NextRow())
			var/id = query.item[1]
			var/name = query.item[2]
			var/department = query.item[3]
			var/info = query.item[4]

			dat += "<b>SCCF-[id]</b><br><br>"
			dat += "<b>[name]</b><br>"
			dat += "<b>[department] Department</b><hr>"
			dat += "[info]"
		dat += "</center>"
		usr << browse(dat, "window=Information;size=560x240")

	// Toggle the paper bin lid.
	if(href_list["setLid"])
		lid = !lid
		to_chat(usr, SPAN_NOTICE("You [lid ? "open" : "close"] the lid."))

	updateUsrDialog()
	return

					//err... hacking code, which has no reason for existing... but anyway... it was once supposed to unlock priority 3 messanging on that console (EXTREME priority...), but the code for that was removed.
/obj/machinery/requests_console/attackby(obj/item/attacking_item, mob/user)
	if (istype(attacking_item, /obj/item/card/id))
		if(!operable(MAINT)) return TRUE
		if(screen == RCS_MESSAUTH)
			var/obj/item/card/id/T = attacking_item
			msgVerified = "<font color='green'><b>Verified by [T.registered_name], [T.assignment]</b></font>"
			updateUsrDialog()
		if(screen == RCS_ANNOUNCE)
			var/obj/item/card/id/ID = attacking_item
			if (ACCESS_RC_ANNOUNCE in ID.GetAccess())
				announceAuth = 1
				announcement.announcer = ID.assignment ? "[ID.assignment] [ID.registered_name]" : ID.registered_name
			else
				reset_message()
				to_chat(user, SPAN_WARNING("You are not authorized to send announcements."))
			updateUsrDialog()
		return TRUE
	else if (istype(attacking_item, /obj/item/stamp))
		if(!operable(MAINT)) return
		if(screen == RCS_MESSAUTH)
			var/obj/item/stamp/T = attacking_item
			msgStamped = SPAN_NOTICE("<b>Stamped with the [T.name]</b>")
			updateUsrDialog()
		return TRUE
	else if (istype(attacking_item, /obj/item/paper_bundle))
		var/obj/item/paper_bundle/C = attacking_item
		if(lid)
			if(alert(user, "Do you want to restock \the [src] with \the [attacking_item]?", "Paper Restocking", "Yes", "No") == "No")
				to_chat(user, SPAN_NOTICE("You decide against restocking \the [src], noting that the lid is still open."))
				return
			paperstock += C.amount
			user.drop_from_inventory(C,get_turf(src))
			qdel(C)
			audible_message("<b>The Requests Console</b> beeps, \"Paper added.\"")
		else if(screen == RCS_MAINMENU)	//Faxing them papers
			fax_send(attacking_item, user)
		return TRUE
	else if (istype(attacking_item, /obj/item/paper))
		if(lid)
			if(alert(user, "Do you want to restock \the [src] with \the [attacking_item]?", "Paper Restocking", "Yes", "No") == "No")
				to_chat(user, SPAN_NOTICE("You decide against restocking \the [src], noting that the lid is still open."))
				return
			var/obj/item/paper/C = attacking_item
			user.drop_from_inventory(C,get_turf(src))
			qdel(C)
			paperstock++
			audible_message("<b>The Requests Console</b> beeps, \"Paper added.\"")
		else if(screen == RCS_MAINMENU)	//Faxing them papers
			fax_send(attacking_item, user)
		return TRUE

/obj/machinery/requests_console/proc/can_send()
	for(var/obj/machinery/telecomms/message_server/MS in SSmachinery.all_telecomms)
		if(!MS.use_power)
			continue
		return TRUE
	return FALSE

/obj/machinery/requests_console/proc/fax_send(var/obj/item/O, var/mob/user)
	var/sendto = tgui_input_list(user, "Select department.", "Send Fax", GLOB.allConsoles)
	if(!sendto)
		return
	if(use_check_and_message(user))
		return
	if(!can_send())
		var/msg = "NOTICE: No server detected!"
		audible_message("<b>The Requests Console</b> beeps, [SPAN_WARNING(msg)]")
		return
	for(var/cc in GLOB.allConsoles)
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
			playsound(Console.loc, 'sound/machines/twobeep.ogg', 40)
			playsound(Console.loc, 'sound/items/polaroid1.ogg', 40)
			if(!is_paper_bundle)
				var/obj/item/paper/P = copy(Console, O, FALSE, FALSE, 0, 15, user)
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

#undef PRESET_NORTH
#undef PRESET_SOUTH
#undef PRESET_WEST
#undef PRESET_EAST

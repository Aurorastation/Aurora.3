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
GLOBAL_LIST_INIT_TYPED(allConsoles, /obj/structure/machinery/requests_console, list())

/obj/structure/machinery/requests_console
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

	/// Category of the message being composed: "assist", "supply", "info", or "reply".
	var/message_type = "info"

	//Form intregration
	var/sql_filter_dept = ""
	var/paperstock = 20
	var/lid = 0
	//End Form Integration
	var/datum/announcement/announcement = new

	///List of PDAs we alert upon a request receipt
	var/list/datum/weakref/alert_pdas = list()

/obj/structure/machinery/requests_console/north
	PRESET_NORTH

/obj/structure/machinery/requests_console/south
	PRESET_SOUTH

/obj/structure/machinery/requests_console/west
	PRESET_WEST

/obj/structure/machinery/requests_console/east
	PRESET_EAST

/obj/structure/machinery/requests_console/power_change()
	..()
	update_icon()

/obj/structure/machinery/requests_console/update_icon()
	ClearOverlays()
	var/mutable_appearance/screen_overlay = overlay_image(icon, "req_comp-idle")
	var/mutable_appearance/screen_hologram = overlay_image(icon, "req_comp-idle")
	var/mutable_appearance/screen_emis = emissive_appearance(icon, "req_comp-idle", src)
	screen_hologram.filters += filter(type="color", color=list(
		0, 0, 0, 0,
		0, 0, 0, 0,
		0, 0, 0, 0,
		HOLOSCREEN_MULTIPLICATION_FACTOR, HOLOSCREEN_MULTIPLICATION_FACTOR, HOLOSCREEN_MULTIPLICATION_FACTOR, HOLOSCREEN_MULTIPLICATION_OPACITY
	))
	screen_overlay.filters += filter(type="color", color=list(
		HOLOSCREEN_ADDITION_OPACITY, 0, 0, 0,
		0, HOLOSCREEN_ADDITION_OPACITY, 0, 0,
		0, 0, HOLOSCREEN_ADDITION_OPACITY, 0,
		0, 0, 0, 1
	))
	screen_hologram.blend_mode = BLEND_MULTIPLY
	screen_overlay.blend_mode = BLEND_ADD
	if(stat & NOPOWER)
		icon_state = initial(icon_state)
		set_light(FALSE)
	else
		switch(newmessagepriority)
			if(0)
				screen_overlay = overlay_image(icon, "req_comp-idle")
				set_light(L_WALLMOUNT_RANGE, L_WALLMOUNT_POWER, COLOR_CYAN)
			if(1)
				screen_overlay = overlay_image(icon, "req_comp-alert")
				set_light(L_WALLMOUNT_RANGE, L_WALLMOUNT_POWER, COLOR_CYAN)
			if(2)
				screen_overlay = overlay_image(icon, "req_comp-redalert")
				set_light(L_WALLMOUNT_RANGE,L_WALLMOUNT_POWER, COLOR_ORANGE)
			if(3)
				screen_overlay = overlay_image(icon, "req_comp-yellowalert")
				set_light(L_WALLMOUNT_RANGE, L_WALLMOUNT_POWER, COLOR_ORANGE)
		AddOverlays(screen_hologram)
		AddOverlays(screen_overlay)
		AddOverlays(screen_emis)
		AddOverlays(overlay_image(icon, "req_comp-scanline"))

/obj/structure/machinery/requests_console/Initialize(mapload, var/dir, var/building = 0)
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
	if(departmentType & RC_ASSIST)
		GLOB.req_console_assistance |= department
	if(departmentType & RC_SUPPLY)
		GLOB.req_console_supplies |= department
	if(departmentType & RC_INFO)
		GLOB.req_console_information |= department
	update_icon()

	if(!mapload)
		set_pixel_offsets()

/obj/structure/machinery/requests_console/set_pixel_offsets()
	pixel_x = DIR2PIXEL_X(dir)
	pixel_y = DIR2PIXEL_Y(dir)

/obj/structure/machinery/requests_console/Destroy()
	GLOB.allConsoles -= src
	var/lastDeptRC = 1
	for(var/obj/structure/machinery/requests_console/console in GLOB.allConsoles)
		if(console.department == department)
			lastDeptRC = 0
			break
	if(lastDeptRC)
		if(departmentType & RC_ASSIST)
			GLOB.req_console_assistance -= department
		if(departmentType & RC_SUPPLY)
			GLOB.req_console_supplies -= department
		if(departmentType & RC_INFO)
			GLOB.req_console_information -= department

		alert_pdas.Cut()
	return ..()

/obj/structure/machinery/requests_console/attack_hand(user as mob)
	if(..(user))
		return
	ui_interact(user)


/obj/structure/machinery/requests_console/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RequestsConsole", "[department] Requests Console")
		ui.open()

/obj/structure/machinery/requests_console/ui_data(mob/user)
	var/list/data = list(
		"department" = department,
		"screen" = screen,
		"message_log" = message_log,
		"newmessagepriority" = newmessagepriority,
		"silent" = silent,
		"announcementConsole" = announcementConsole,
		"assist_dept" = GLOB.req_console_assistance,
		"supply_dept" = GLOB.req_console_supplies,
		"info_dept" = GLOB.req_console_information,
		"message" = message,
		"recipient" = recipient,
		"priority" = priority,
		"msgStamped" = msgStamped,
		"msgVerified" = msgVerified,
		"announceAuth" = announceAuth,
		"lid" = lid,
		"paper" = paperstock
	)

	if(screen == RCS_FORMS)
		if(!SSdbcore.Connect())
			data["sql_error"] = 1
		else
			var/datum/db_query/query
			if(sql_filter_dept)
				query = SSdbcore.NewQuery(
					"SELECT id, name, department FROM ss13_forms WHERE department LIKE :filter ORDER BY id",
					list("filter" = "%[sql_filter_dept]%"))
			else
				query = SSdbcore.NewQuery("SELECT id, name, department FROM ss13_forms ORDER BY id")
			if(!query.Execute())
				data["sql_error"] = 1
			else
				var/list/forms = list()
				while(query.NextRow())
					forms += list(list("id" = query.item[1], "name" = query.item[2], "department" = query.item[3]))
				if(!forms.len)
					data["sql_error"] = 1
				data["forms"] = forms
			qdel(query)

	var/list/pda_list = list()
	for(var/datum/weakref/ref in alert_pdas)
		var/obj/item/modular_computer/pda = ref.resolve()
		if(!pda)
			alert_pdas -= ref
			continue
		pda_list += list(list("name" = alert_pdas[ref], "pda" = "[REF(pda)]"))
	data["pda_list"] = pda_list

	return data

/obj/structure/machinery/requests_console/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	add_fingerprint(usr)

	switch(action)
		// Begin composing a message: gets text via input dialog then shows auth screen
		if("compose")
			var/rcpt = params["recipient"]
			if(!reject_bad_text(rcpt))
				return TRUE
			recipient = rcpt
			switch(screen)
				if(RCS_RQASSIST)
					message_type = "assist"
				if(RCS_RQSUPPLY)
					message_type = "supply"
				if(RCS_SENDINFO)
					message_type = "info"
				else
					message_type = "reply"
			var/new_message = sanitize(tgui_input_text(usr, "Write your message:", "Compose Message", encode = FALSE))
			if(new_message && !use_check_and_message(usr))
				message = new_message
				screen = RCS_MESSAUTH
				switch(text2num(params["priority"]))
					if(1) priority = 1
					if(2) priority = 2
					else  priority = 0
			else
				reset_message(1)
			return TRUE

		if("write_announcement")
			var/new_message = sanitize(tgui_input_text(usr, "Write your message:", "Announcement", encode = FALSE))
			if(new_message && !use_check_and_message(usr))
				message = new_message
			else
				reset_message(1)
			return TRUE

		if("send_announcement")
			if(!announcementConsole)
				return TRUE
			announcement.Announce(message, msg_sanitized = 1)
			reset_message(1)
			return TRUE

		// Send the composed+authenticated message
		if("send_message")
			if(!message)
				return TRUE
			screen = RCS_SENTFAIL
			var/pass = FALSE
			for(var/obj/structure/machinery/telecomms/message_server/MS in SSmachinery.all_telecomms)
				if(MS.use_power)
					MS.send_rc_message(recipient, department, message, msgStamped, msgVerified, priority, message_type)
					pass = TRUE
			if(pass)
				screen = RCS_SENTPASS
				message_log += list(list(
					"type" = "sent",
					"category" = message_type,
					"recipient" = recipient,
					"body" = message
				))
			else
				audible_message("<b>The Requests Console</b> beeps, [SPAN_WARNING("NOTICE: No server detected!")]")
			return TRUE

		if("set_screen")
			var/new_screen = text2num(params["screen"])
			if(new_screen == RCS_ANNOUNCE && !announcementConsole)
				return TRUE
			if(new_screen == RCS_VIEWMSGS)
				for(var/obj/structure/machinery/requests_console/console in GLOB.allConsoles)
					if(console.department == department)
						console.newmessagepriority = 0
						console.update_icon()
			if(new_screen == RCS_MAINMENU)
				reset_message()
			screen = new_screen
			return TRUE

		if("toggle_silent")
			silent = !silent
			return TRUE

		if("link_pda")
			var/obj/item/modular_computer/pda = usr.get_active_hand()
			if(!pda || !istype(pda))
				to_chat(usr, SPAN_WARNING("You need to be holding a handheld computer to link it."))
			else
				var/datum/weakref/ref = find_pda_ref(pda)
				if(ref)
					to_chat(usr, SPAN_NOTICE("\The [pda] appears to be already linked."))
					alert_pdas[ref] = pda.name
				else
					ref = WEAKREF(pda)
					alert_pdas += ref
					alert_pdas[ref] = pda.name
					to_chat(usr, SPAN_NOTICE("You link \the [pda] to \the [src]. It will now ping upon the arrival of a request to this machine."))
			return TRUE

		if("unlink_pda")
			var/obj/item/modular_computer/pda = locate(params["pda"])
			if(pda && istype(pda))
				var/datum/weakref/ref = find_pda_ref(pda)
				if(ref)
					to_chat(usr, SPAN_NOTICE("You unlink [alert_pdas[ref]] from \the [src]. It will no longer be notified of new requests."))
					alert_pdas -= ref
			return TRUE

		if("sort_forms")
			sql_filter_dept = sanitize(params["department"])
			return TRUE

		if("reset_sql")
			sql_filter_dept = ""
			return TRUE

		if("print_form")
			var/printid = text2num(params["id"])
			if(!printid)
				return TRUE
			if(!SSdbcore.Connect())
				to_chat(usr, SPAN_WARNING("Connection to the database lost. Aborting."))
				return TRUE
			var/datum/db_query/query = SSdbcore.NewQuery(
				"SELECT id, name, data FROM ss13_forms WHERE id = :id",
				list("id" = printid))
			if(!query.Execute())
				to_chat(usr, SPAN_WARNING("Connection to the database lost. Aborting."))
				qdel(query)
				return TRUE
			while(query.NextRow())
				var/form_id = query.item[1]
				var/form_name = query.item[2]
				var/form_data = html_encode(query.item[3])
				var/obj/item/paper/form_paper = new()
				form_paper.color = "#fff9e8"
				form_paper.set_content("NFC-[form_id] - [form_name]", form_data)
				print(form_paper, user = usr)
				paperstock--
			qdel(query)
			return TRUE

		if("whatis")
			var/whatisid = text2num(params["id"])
			if(!whatisid)
				return TRUE
			if(!SSdbcore.Connect())
				to_chat(usr, SPAN_WARNING("Connection to the database lost. Aborting."))
				return TRUE
			var/datum/db_query/query = SSdbcore.NewQuery(
				"SELECT id, name, department, info FROM ss13_forms WHERE id = :id",
				list("id" = whatisid))
			if(!query.Execute())
				to_chat(usr, SPAN_WARNING("Connection to the database lost. Aborting."))
				qdel(query)
				return TRUE
			var/dat = "<center><b>Stellar Corporate Conglomerate Form</b><br>"
			while(query.NextRow())
				dat += "<b>SCCF-[query.item[1]]</b><br><br>"
				dat += "<b>[query.item[2]]</b><br>"
				dat += "<b>[query.item[3]] Department</b><hr>"
				dat += "[query.item[4]]"
			dat += "</center>"
			qdel(query)
			usr << browse(HTML_SKELETON(dat), "window=Information;size=560x240")
			return TRUE

		if("toggle_lid")
			lid = !lid
			to_chat(usr, SPAN_NOTICE("You [lid ? "open" : "close"] the lid."))
			return TRUE

					//err... hacking code, which has no reason for existing... but anyway... it was once supposed to unlock priority 3 messanging on that console (EXTREME priority...), but the code for that was removed.
/obj/structure/machinery/requests_console/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/modular_computer))
		var/obj/item/modular_computer/pda = attacking_item
		var/datum/weakref/ref = find_pda_ref(pda)
		if(ref)
			to_chat(user, SPAN_NOTICE("You unlink [alert_pdas[ref]] from \the [src]. It will no longer be notified of new requests."))
			alert_pdas -= ref
		else
			ref = WEAKREF(pda)
			alert_pdas += ref
			alert_pdas[ref] = pda.name
			to_chat(user, SPAN_NOTICE("You link \the [pda] to \the [src]. It will now ping upon the arrival of a request to this machine."))
		return TRUE
	if(istype(attacking_item, /obj/item/card/id))
		if(!operable(MAINT)) return TRUE
		if(screen == RCS_MESSAUTH)
			var/obj/item/card/id/id_card = attacking_item
			msgVerified = "[id_card.registered_name], [id_card.assignment]"
			SStgui.update_uis(src)
		if(screen == RCS_ANNOUNCE)
			var/obj/item/card/id/auth_card = attacking_item
			if(ACCESS_RC_ANNOUNCE in auth_card.GetAccess())
				announceAuth = 1
				announcement.announcer = auth_card.assignment ? "[auth_card.assignment] [auth_card.registered_name]" : auth_card.registered_name
			else
				reset_message()
				to_chat(user, SPAN_WARNING("You are not authorized to send announcements."))
			SStgui.update_uis(src)
		return TRUE
	else if(istype(attacking_item, /obj/item/stamp))
		if(!operable(MAINT)) return
		if(screen == RCS_MESSAUTH)
			var/obj/item/stamp/used_stamp = attacking_item
			msgStamped = used_stamp.name
			SStgui.update_uis(src)
		return TRUE
	else if(istype(attacking_item, /obj/item/paper_bundle))
		var/obj/item/paper_bundle/paper_bundle = attacking_item
		if(lid)
			if(alert(user, "Do you want to restock \the [src] with \the [attacking_item]?", "Paper Restocking", "Yes", "No") == "No")
				to_chat(user, SPAN_NOTICE("You decide against restocking \the [src], noting that the lid is still open."))
				return
			paperstock += paper_bundle.amount
			user.drop_from_inventory(paper_bundle, get_turf(src))
			qdel(paper_bundle)
			audible_message("<b>The Requests Console</b> beeps, \"Paper added.\"")
		else if(screen == RCS_MAINMENU)	//Faxing them papers
			fax_send(attacking_item, user)
		return TRUE
	else if(istype(attacking_item, /obj/item/paper))
		if(lid)
			if(alert(user, "Do you want to restock \the [src] with \the [attacking_item]?", "Paper Restocking", "Yes", "No") == "No")
				to_chat(user, SPAN_NOTICE("You decide against restocking \the [src], noting that the lid is still open."))
				return
			var/obj/item/paper/paper_item = attacking_item
			user.drop_from_inventory(paper_item, get_turf(src))
			qdel(paper_item)
			paperstock++
			audible_message("<b>The Requests Console</b> beeps, \"Paper added.\"")
		else if(screen == RCS_MAINMENU)	//Faxing them papers
			fax_send(attacking_item, user)
		return TRUE

/obj/structure/machinery/requests_console/proc/can_send()
	for(var/obj/structure/machinery/telecomms/message_server/MS in SSmachinery.all_telecomms)
		if(!MS.use_power)
			continue
		return TRUE
	return FALSE

/obj/structure/machinery/requests_console/proc/fax_send(obj/item/fax_item, mob/user)
	var/sendto = tgui_input_list(user, "Select department.", "Send Fax", GLOB.allConsoles)
	if(!sendto)
		return
	if(use_check_and_message(user))
		return
	if(!can_send())
		var/msg = "NOTICE: No server detected!"
		audible_message("<b>The Requests Console</b> beeps, [SPAN_WARNING(msg)]")
		return
	for(var/obj/structure/machinery/requests_console/console in GLOB.allConsoles)
		if(console == sendto)
			var/paperstock_usage = 1
			var/is_paper_bundle = istype(fax_item, /obj/item/paper_bundle)
			if(is_paper_bundle)
				var/obj/item/paper_bundle/fax_bundle = fax_item
				paperstock_usage = fax_bundle.amount
			if(console.paperstock < paperstock_usage)
				audible_message("<b>The Requests Console</b> beeps, \"Error! Receiving console out of paper! Aborting!\"")
				return
			playsound(console.loc, 'sound/machines/twobeep.ogg', 40)
			playsound(console.loc, 'sound/items/polaroid1.ogg', 40)
			if(!is_paper_bundle)
				var/obj/item/paper/fax_copy = copy(console, fax_item, FALSE, FALSE, 0, 15, user)
				fax_copy.forceMove(console.loc)
			else
				var/obj/item/paper_bundle/bundle_copy = bundlecopy(console, fax_item, FALSE, 15, FALSE)
				bundle_copy.forceMove(console.loc)
			console.audible_message("<b>The Requests Console</b> beeps, \"Fax received.\"")
			for(var/datum/weakref/ref in console.alert_pdas)
				var/obj/item/modular_computer/pda = ref.resolve()
				if(pda)
					pda.get_notification("A fax has arrived!", 1, "[console.department] Requests Console")
			console.paperstock -= paperstock_usage
			audible_message("<b>The Requests Console</b> beeps, \"Fax sent.\"")
			return

/obj/structure/machinery/requests_console/proc/reset_message(mainmenu = FALSE)
	message = ""
	recipient = ""
	priority = 0
	msgVerified = ""
	msgStamped = ""
	announceAuth = 0
	announcement.announcer = ""
	if(mainmenu)
		screen = RCS_MAINMENU

/// Finds the weakref in `alert_pdas` that resolves to the given PDA. Returns null if the PDA is not linked.
/obj/structure/machinery/requests_console/proc/find_pda_ref(obj/item/modular_computer/pda)
	for(var/datum/weakref/ref in alert_pdas)
		if(ref.resolve() == pda)
			return ref

#undef PRESET_NORTH
#undef PRESET_SOUTH
#undef PRESET_WEST
#undef PRESET_EAST

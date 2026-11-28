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
	pda_linkable = TRUE

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
	/// When the next low-paper reminder may sound.
	var/next_paper_alert = 0
	/// Whether this initially mapped Horizon console's paper stock persists between rounds.
	var/persistent_paperstock = TRUE
	/// Original map identity used to persist paper stock without persisting the console itself.
	var/tmp/paperstock_persistence_id
	var/lid = 0
	//End Form Integration
	var/datum/announcement/announcement = new

	///List of PDAs we alert upon a request receipt
	var/list/datum/weakref/alert_pdas = list()

/datum/persistent_request_console_paperstock
	/// The initially mapped request console. Its current location is deliberately irrelevant.
	var/obj/structure/machinery/requests_console/console

/** Returns current paper stock, or null when the console no longer exists so its prior generic is left untouched. */
/datum/persistent_request_console_paperstock/proc/get_final_paperstock()
	if(QDELETED(console))
		return
	return list("paper_stock" = console.paperstock)

/singleton/persistent_type/generic/request_console_paperstock
	/// Persistent request consoles present on the Horizon, keyed by their generic attribute.
	var/list/request_console_register = list()
	/// Whether initialization completed successfully. Prevents a failed load from overwriting saved paper stock.
	var/paperstock_initialized = FALSE

/** Loads saved paper stock into request consoles mapped onto the Horizon. */
/singleton/persistent_type/generic/request_console_paperstock/initialization_hook()
	request_console_register = list()
	paperstock_initialized = FALSE
	if(!SSpersistence.map_supports_persistence)
		return

	for(var/obj/structure/machinery/requests_console/console in world)
		CHECK_TICK
		var/turf/console_turf = get_turf(console)
		if(!console_turf || !is_station_level(console_turf.z) || !console.persistent_paperstock)
			continue

		var/paperstock_persistence_id = "[console.type]-[console_turf.x]-[console_turf.y]-[console_turf.z]"
		console.paperstock_persistence_id = paperstock_persistence_id
		var/datum/persistent_request_console_paperstock/paperstock_record = new
		paperstock_record.console = console
		if(request_console_register[paperstock_persistence_id])
			log_subsystem_persistence_error("Duplicate persistent request console paper stock attribute '[paperstock_persistence_id]' at [console_turf].")
			continue
		request_console_register[paperstock_persistence_id] = paperstock_record

	var/list/saved_attributes = SSpersistence.genericGetAllAttributesForType(/singleton/persistent_type/generic/request_console_paperstock)
	for(var/paperstock_persistence_id in saved_attributes)
		CHECK_TICK
		if(!length(paperstock_persistence_id))
			continue
		var/datum/persistent_request_console_paperstock/paperstock_record = request_console_register[paperstock_persistence_id]
		if(!paperstock_record)
			continue
		var/datum/persistent_generic/saved_generic = SSpersistence.genericLoad(/singleton/persistent_type/generic/request_console_paperstock, paperstock_persistence_id, skip_caching = TRUE)
		var/list/saved_paperstock = saved_generic?.content
		var/saved_amount = saved_paperstock?["paper_stock"]
		if(isnum(saved_amount))
			paperstock_record.console.paperstock = max(saved_amount, 0)
	paperstock_initialized = TRUE

/** Saves paper stock for the initially mapped request consoles without considering their current locations. */
/singleton/persistent_type/generic/request_console_paperstock/finalization_hook()
	if(!paperstock_initialized)
		return

	var/obj/item/paper/paper_type = /obj/item/paper
	var/expiration_days = initial(paper_type.persistent_objects_expiration_time_days)
	for(var/paperstock_persistence_id in request_console_register)
		CHECK_TICK
		var/datum/persistent_request_console_paperstock/paperstock_record = request_console_register[paperstock_persistence_id]
		var/list/saved_paperstock = paperstock_record.get_final_paperstock()
		if(islist(saved_paperstock))
			SSpersistence.genericSave(/singleton/persistent_type/generic/request_console_paperstock, saved_paperstock, paperstock_persistence_id, expires_in_days = expiration_days)

/obj/structure/machinery/requests_console/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(paperstock_persistence_id)
		var/obj/item/paper/paper_type = /obj/item/paper
		var/persistence_days = initial(paper_type.persistent_objects_expiration_time_days)
		var/persistence_duration = "[persistence_days] day[(persistence_days != 1) ? "s" : ""]"
		var/persistence_label = "<i class='fa-solid [FA_ICON_CALENDAR_DAYS]'></i> [persistence_duration]"
		. += SPAN_TOOLTIP("This is a persistence mechanic. Paper left inside this console remains available between rounds aboard the SCCV Horizon and expires after [persistence_duration].", persistence_label)

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
	var/mutable_appearance/screen_emis = emissive_appearance(icon, "req_comp-idle")
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
	next_paper_alert = world.time + 10 MINUTES

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

/obj/structure/machinery/requests_console/process(seconds_per_tick)
	if(paperstock > 4)
		next_paper_alert = world.time + 10 MINUTES
		return
	if(silent || !operable(MAINT|EMPED) || world.time < next_paper_alert)
		return

	next_paper_alert = world.time + 10 MINUTES
	playsound(loc, 'sound/machines/twobeep.ogg', 40)
	var/paper_warning = paperstock <= 0 ? "Out of paper! Please refill the paper tray." : "Paper running low: [paperstock] sheet[paperstock == 1 ? "" : "s"] remaining. Please refill the paper tray."
	audible_message("<b>\The [src]</b> beeps, \"[paper_warning]\"", audible_message_flags = LOCAL_MESSAGE)

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
				audible_message("<b>The Requests Console</b> beeps, [SPAN_WARNING("NOTICE: No server detected!")]", audible_message_flags = LOCAL_MESSAGE)
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
					alert_pdas[ref] = get_pda_link_name(pda, usr)
				else
					ref = WEAKREF(pda)
					alert_pdas += ref
					alert_pdas[ref] = get_pda_link_name(pda, usr)
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
		return toggle_pda_link(attacking_item, user)
	if(istype(attacking_item, /obj/item/card/id))
		if(!operable(MAINT)) return TRUE
		if(screen == RCS_MESSAUTH)
			var/obj/item/card/id/id_card = attacking_item
			msgVerified = "[id_card.registered_name], [id_card.assignment]"
			SStgui.update_uis(src)
		if(screen == RCS_ANNOUNCE)
			var/obj/item/card/id/auth_card = attacking_item
			if(/datum/access/horizon/RC_announce::id in auth_card.GetAccess())
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
	else if(istype(attacking_item, /obj/item/paper_bin_refill))
		if(!lid)
			to_chat(user, SPAN_WARNING("You need to open [src]'s paper tray before refilling it."))
			return TRUE

		var/obj/item/paper_bin_refill/refill = attacking_item
		if(refill.paper_amount <= 0)
			to_chat(user, SPAN_WARNING("[refill] is empty."))
			return TRUE

		var/refill_amount = refill.paper_amount
		paperstock += refill_amount
		refill.paper_amount = 0
		var/turf/console_turf = get_turf(src)
		user.drop_from_inventory(refill, console_turf)
		new /obj/item/trash/paper_ream(console_turf)
		qdel(refill)
		audible_message("<b>The Requests Console</b> beeps, \"[refill_amount] sheet[refill_amount == 1 ? "" : "s"] of paper added.\"", audible_message_flags = LOCAL_MESSAGE)
		SStgui.update_uis(src)
		return TRUE
	else if(istype(attacking_item, /obj/item/paper_bundle))
		var/obj/item/paper_bundle/paper_bundle = attacking_item
		if(lid)
			if(tgui_alert(user, "Do you want to restock \the [src] with \the [attacking_item]?", "Paper Restocking", list("Yes", "No")) == "No")
				to_chat(user, SPAN_NOTICE("You decide against restocking \the [src], noting that the lid is still open."))
				return
			paperstock += paper_bundle.amount
			user.drop_from_inventory(paper_bundle, get_turf(src))
			qdel(paper_bundle)
			audible_message("<b>The Requests Console</b> beeps, \"Paper added.\"", audible_message_flags = LOCAL_MESSAGE)
		else if(screen == RCS_MAINMENU)	//Faxing them papers
			fax_send(attacking_item, user)
		return TRUE
	else if(istype(attacking_item, /obj/item/paper))
		if(lid)
			if(tgui_alert(user, "Do you want to restock \the [src] with \the [attacking_item]?", "Paper Restocking", list("Yes", "No")) == "No")
				to_chat(user, SPAN_NOTICE("You decide against restocking \the [src], noting that the lid is still open."))
				return
			var/obj/item/paper/paper_item = attacking_item
			user.drop_from_inventory(paper_item, get_turf(src))
			qdel(paper_item)
			paperstock++
			audible_message("<b>The Requests Console</b> beeps, \"Paper added.\"", audible_message_flags = LOCAL_MESSAGE)
		else if(screen == RCS_MAINMENU)	//Faxing them papers
			fax_send(attacking_item, user)
		return TRUE

/obj/structure/machinery/requests_console/toggle_pda_link(obj/item/modular_computer/pda, mob/user)
	var/datum/weakref/ref = find_pda_ref(pda)
	if(ref)
		to_chat(user, SPAN_NOTICE("You unlink [alert_pdas[ref]] from \the [src]. It will no longer be notified of new requests."))
		alert_pdas -= ref
	else
		ref = WEAKREF(pda)
		alert_pdas += ref
		alert_pdas[ref] = get_pda_link_name(pda, user)
		to_chat(user, SPAN_NOTICE("You link \the [pda] to \the [src]. It will now ping upon the arrival of a request to this machine."))
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
		audible_message("<b>The Requests Console</b> beeps, [SPAN_WARNING(msg)]", audible_message_flags = LOCAL_MESSAGE)
		return
	for(var/obj/structure/machinery/requests_console/console in GLOB.allConsoles)
		if(console == sendto)
			var/paperstock_usage = 1
			var/is_paper_bundle = istype(fax_item, /obj/item/paper_bundle)
			if(is_paper_bundle)
				var/obj/item/paper_bundle/fax_bundle = fax_item
				paperstock_usage = fax_bundle.amount
			if(console.paperstock < paperstock_usage)
				audible_message("<b>The Requests Console</b> beeps, \"Error! Receiving console out of paper! Aborting!\"", audible_message_flags = LOCAL_MESSAGE)
				return
			playsound(console.loc, 'sound/machines/twobeep.ogg', 40)
			playsound(console.loc, 'sound/items/polaroid1.ogg', 40)
			if(!is_paper_bundle)
				var/obj/item/paper/fax_copy = copy(console, fax_item, FALSE, FALSE, 0, 15, user)
				fax_copy.forceMove(console.loc)
			else
				var/obj/item/paper_bundle/bundle_copy = bundlecopy(console, fax_item, FALSE, 15, FALSE)
				bundle_copy.forceMove(console.loc)
			console.audible_message("<b>The Requests Console</b> beeps, \"Fax received.\"", audible_message_flags = LOCAL_MESSAGE)
			for(var/datum/weakref/ref in console.alert_pdas)
				var/obj/item/modular_computer/pda = ref.resolve()
				if(pda)
					pda.get_notification("A fax has arrived!", 1, "[console.department] Requests Console")
			console.paperstock -= paperstock_usage
			audible_message("<b>The Requests Console</b> beeps, \"Fax sent.\"", audible_message_flags = LOCAL_MESSAGE)
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

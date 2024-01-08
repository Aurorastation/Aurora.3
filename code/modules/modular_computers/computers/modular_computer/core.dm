/obj/item/modular_computer/process()
	if(!enabled) // The computer is turned off
		last_power_usage = 0
		return FALSE

	handle_power() // Handles all computer power interaction

	if(damage > broken_damage)
		shutdown_computer()
		return FALSE

	if(active_program?.requires_ntnet && !get_ntnet_status(active_program.requires_ntnet_feature)) // Active program requires NTNet to run but we've just lost connection. Crash.
		active_program.event_networkfailure(FALSE)

	for(var/datum/computer_file/program/P in idle_threads)
		if(P.requires_ntnet && !get_ntnet_status(P.requires_ntnet_feature))
			P.event_networkfailure(TRUE)

	if(active_program)
		if(active_program.program_state != PROGRAM_STATE_KILLED)
			active_program.ntnet_status = get_ntnet_status()
			active_program.computer_emagged = computer_emagged
			active_program.process_tick()
		else
			active_program = null

	for(var/datum/computer_file/program/P in idle_threads)
		if(P.program_state != PROGRAM_STATE_KILLED)
			P.ntnet_status = get_ntnet_status()
			P.computer_emagged = computer_emagged
			P.process_tick()
		else
			idle_threads.Remove(P)

	for(var/s in enabled_services)
		var/datum/computer_file/program/service = s
		if(service.program_type & PROGRAM_SERVICE) // Safety checks
			if(service.service_state == PROGRAM_STATE_ACTIVE)
				if(active_program != service && !(service in idle_threads))
					service.process_tick()
			else
				enabled_services -= service

	working = hard_drive && processor_unit && damage < broken_damage && computer_use_power()
	check_update_ui_need()

	if(looping_sound && working && enabled && world.time > ambience_last_played_time + 30 SECONDS && prob(3))
		playsound(get_turf(src), /singleton/sound_category/computerbeep_sound, 30, 1, 10, required_preferences = ASFX_AMBIENCE)
		ambience_last_played_time = world.time

/obj/item/modular_computer/proc/get_preset_programs(preset_type)
	for(var/datum/modular_computer_app_presets/prs in GLOB.ntnet_global.available_software_presets)
		if(prs.type == preset_type)
			return prs.return_install_programs(src)

// Used to perform preset-specific hardware changes.
/obj/item/modular_computer/proc/install_default_hardware()
	return TRUE

// Used to install preset-specific programs
/obj/item/modular_computer/proc/install_default_programs()
	if(enrolled)
		var/programs = get_preset_programs(_app_preset_type)
		for(var/datum/computer_file/program/prog in programs)
			if(!prog.is_supported_by_hardware(hardware_flag, FALSE))
				qdel(prog)
				continue
			hard_drive.store_file(prog)

/obj/item/modular_computer/proc/handle_verbs()
	if(card_slot)
		if(card_slot.stored_card)
			verbs += /obj/item/modular_computer/proc/eject_id
		if(card_slot.stored_item)
			verbs += /obj/item/modular_computer/proc/eject_item
	if(portable_drive)
		verbs += /obj/item/modular_computer/proc/eject_usb
	if(battery_module && battery_module.hotswappable)
		verbs += /obj/item/modular_computer/proc/eject_battery
	if(ai_slot)
		verbs += /obj/item/modular_computer/proc/eject_ai
	if(personal_ai)
		verbs += /obj/item/modular_computer/proc/eject_personal_ai

/obj/item/modular_computer/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)
	install_default_hardware()
	if(hard_drive)
		install_default_programs()
	handle_verbs()
	update_icon()
	if(looping_sound)
		soundloop = new(src, enabled)
	initial_name = name
	listener = new("modular_computers", src)
	sync_linked()

/obj/item/modular_computer/Destroy()
	STOP_PROCESSING(SSprocessing, src)

	SStgui.close_uis(src)
	enabled = FALSE

	if(active_program)
		active_program.kill_program(forced = TRUE)
		SStgui.close_uis(active_program)

	QDEL_NULL(active_program)

	if(hard_drive)
		for(var/datum/computer_file/program/P in hard_drive.stored_files)
			P.event_unregistered()

		QDEL_NULL_LIST(hard_drive.stored_files)

	for(var/obj/item/computer_hardware/CH in src.get_all_components())
		uninstall_component(null, CH)
		qdel(CH)

	registered_id = null

	//Stop all the programs that we are running, or have
	for(var/datum/computer_file/program/P in idle_threads)
		P.kill_program(TRUE)

	for(var/s in enabled_services)
		var/datum/computer_file/program/service = s
		if(service.program_type & PROGRAM_SERVICE) // Safety checks
			service.service_deactivate()
			service.service_state = PROGRAM_STATE_KILLED

	QDEL_NULL_LIST(idle_threads)
	QDEL_NULL_LIST(enabled_services)

	if(looping_sound)
		soundloop.stop(src)
	QDEL_NULL(soundloop)

	QDEL_NULL(listener)

	linked = null

	return ..()

/obj/item/modular_computer/CouldUseTopic(var/mob/user)
	..()
	if(iscarbon(user))
		playsound(src, 'sound/machines/pda_click.ogg', 20)

/obj/item/modular_computer/CouldNotUseTopic(var/mob/user)
	..()
	if(user.machine == src)
		user.unset_machine()

/obj/item/modular_computer/emag_act(var/remaining_charges, var/mob/user)
	if(computer_emagged)
		to_chat(user, SPAN_WARNING("\The [src] has already been emagged."))
		return NO_EMAG_ACT
	else
		computer_emagged = TRUE
		to_chat(user, SPAN_WARNING("You emag \the [src]. Its screen briefly displays, \"OVERRIDE ACCEPTED: New software downloads available.\"."))
		return TRUE

/obj/item/modular_computer/update_icon()
	icon_state = icon_state_unpowered

	cut_overlays()
	if(damage >= broken_damage)
		icon_state = icon_state_broken
		add_overlay("broken")
		return
	if(!enabled)
		if(icon_state_screensaver && working)
			if (is_holographic)
				holographic_overlay(src, src.icon, icon_state_screensaver)
			else
				add_overlay(icon_state_screensaver)
		if(icon_state_screensaver_key && working)
			add_overlay(icon_state_screensaver_key)

		if (screensaver_light_range && working && !flashlight)
			set_light(screensaver_light_range, light_power, screensaver_light_color ? screensaver_light_color : "#FFFFFF")
		else
			set_light(0)
		return
	if(active_program)
		var/state = active_program.program_icon_state ? active_program.program_icon_state : icon_state_menu
		var/state_key = active_program.program_key_icon_state ? active_program.program_key_icon_state : icon_state_menu_key // for corresponding keyboards.
		if (is_holographic)
			holographic_overlay(src, src.icon, state)
		else
			add_overlay(state)
		add_overlay(state_key)
		if(!flashlight)
			set_light(light_range, light_power, l_color = active_program.color)
	else
		if (is_holographic)
			holographic_overlay(src, src.icon, icon_state_menu)
		else
			add_overlay(icon_state_menu)
		add_overlay(icon_state_menu_key)
		if(!flashlight)
			set_light(light_range, light_power, l_color = menu_light_color)

/obj/item/modular_computer/proc/turn_on(var/mob/user)
	if(tesla_link)
		tesla_link.enabled = TRUE
	var/issynth = issilicon(user) // Robots and AIs get different activation messages.
	if(damage > broken_damage)
		if(issynth)
			to_chat(user, SPAN_WARNING("You send an activation signal to \the [src], but it responds with an error code. It must be damaged."))
		else
			to_chat(user, SPAN_WARNING("You press the power button, but the computer fails to boot up, displaying a variety of errors before shutting down again."))
		return
	if(processor_unit && computer_use_power()) // Battery-run and charged or non-battery but powered by APC.
		if(issynth)
			to_chat(user, SPAN_NOTICE("You send an activation signal to \the [src], turning it on."))
		else
			to_chat(user, SPAN_NOTICE("You press the power button and start up \the [src]."))
		enable_computer(user)

	else // Unpowered
		if(issynth)
			to_chat(user, SPAN_WARNING("You send an activation signal to \the [src], but it does not respond."))
		else
			to_chat(user, SPAN_WARNING("You press the power button, but \the [src] does not respond."))

// Relays kill program request to currently active program. Use this to quit current program.
/obj/item/modular_computer/proc/kill_program(var/forced = FALSE)
	if(active_program && active_program.kill_program(forced))
		active_program = null
	else
		return FALSE
	var/mob/user = usr
	if(user && istype(user) && !forced)
		ui_interact(user) // Re-open the UI on this computer. It should show the main screen now.
	update_icon()

// Returns 0 for No Signal, 1 for Low Signal and 2 for Good Signal. 3 is for wired connection (always-on)
/obj/item/modular_computer/proc/get_ntnet_status(var/specific_action = 0)
	if(network_card)
		return network_card.get_signal(specific_action)
	else
		return FALSE

/obj/item/modular_computer/proc/add_log(var/text)
	if(!get_ntnet_status())
		return FALSE
	return GLOB.ntnet_global.add_log(text, network_card)

/obj/item/modular_computer/proc/shutdown_computer(var/loud = TRUE)
	SStgui.close_uis(active_program)
	kill_program(TRUE)
	for(var/datum/computer_file/program/P in idle_threads)
		P.kill_program(TRUE)
		idle_threads.Remove(P)

	for(var/s in enabled_services)
		var/datum/computer_file/program/service = s
		if(service.program_type & PROGRAM_SERVICE) // Safety checks
			service.service_deactivate()
			service.service_state = PROGRAM_STATE_KILLED

	if(loud)
		visible_message(SPAN_NOTICE("\The [src] shuts down."))
	SStgui.close_uis(src)
	enabled = FALSE
	if(looping_sound)
		soundloop.stop(src)
	update_icon()

/obj/item/modular_computer/proc/enable_computer(var/mob/user, var/ar_forced=FALSE)
	enabled = TRUE
	if(looping_sound)
		soundloop.start(src)
	update_icon()

	// Autorun feature
	var/datum/computer_file/data/autorun = hard_drive ? hard_drive.find_file_by_name("autorun") : null
	if(istype(autorun))
		run_program(autorun.stored_data, user, ar_forced)

	for(var/s in enabled_services)
		var/datum/computer_file/program/service = s
		if(service.program_type & PROGRAM_SERVICE) // Safety checks
			service.service_activate()
			service.service_state = PROGRAM_STATE_ACTIVE

	if(user)
		ui_interact(user)

/obj/item/modular_computer/proc/minimize_program(mob/user)
	if(!active_program || !processor_unit)
		return

	idle_threads.Add(active_program)
	active_program.program_state = PROGRAM_STATE_BACKGROUND // Should close any existing UIs
	active_program = null
	update_icon()
	if(istype(user))
		ui_interact(user) // Re-open the UI on this computer. It should show the main screen now.


/obj/item/modular_computer/proc/run_program(prog, mob/user, var/forced=FALSE)
	if(QDELETED(src))
		return

	var/datum/computer_file/program/P = null
	if(!istype(user))
		user = usr
	if(hard_drive)
		P = hard_drive.find_file_by_name(prog)

	if(!P || !istype(P) || QDELING(P)) // Program not found or it's not executable program, or it's being GC'd
		to_chat(user, SPAN_WARNING("\The [src]'s screen displays, \"I/O ERROR - Unable to run [prog]\"."))
		return

	P.computer = src

	if(!P.is_supported_by_hardware(hardware_flag, TRUE, user))
		return
	if(P in idle_threads)
		P.program_state = PROGRAM_STATE_ACTIVE
		active_program = P
		idle_threads.Remove(P)
		update_icon()
		ui_interact(user)
		return

	if(idle_threads.len >= processor_unit.max_idle_programs+1)
		to_chat(user, SPAN_WARNING("\The [src] displays, \"Maximal CPU load reached. Unable to run another program.\"."))
		return

	if(P.requires_ntnet && !get_ntnet_status(P.requires_ntnet_feature) && !forced) // The program requires NTNet connection, but we are not connected to NTNet.
		to_chat(user, FONT_SMALL(SPAN_WARNING("\The [src] displays, \"NETWORK ERROR - Unable to connect to NTNet. Please retry. If problem persists contact your system administrator.\".")))
		return

	if(active_program)
		minimize_program(user)

	if(P.run_program(user))
		active_program = P
		ui_interact(user)
		update_icon()
	return TRUE

/obj/item/modular_computer/proc/update_uis()
	if(active_program) //Should we update program ui or computer ui?
		SSnanoui.update_uis(active_program)
		SStgui.update_uis(src)
		if(active_program.NM)
			SSnanoui.update_uis(active_program.NM)
	else
		SStgui.update_uis(src)
		SSnanoui.update_uis(src)

/obj/item/modular_computer/proc/check_update_ui_need()
	var/ui_update_needed = FALSE
	if(battery_module)
		var/battery_percent = battery_module.battery.percent()
		if(last_battery_percent != battery_percent) //Let's update UI on percent change
			ui_update_needed = TRUE
			last_battery_percent = battery_percent

	if(worldtime2text() != last_world_time)
		last_world_time = worldtime2text()
		ui_update_needed = TRUE

	if(idle_threads.len)
		var/list/current_header_icons = list()
		for(var/datum/computer_file/program/P in idle_threads)
			if(!P.ui_header)
				continue
			current_header_icons[P.type] = P.ui_header
		if(!last_header_icons)
			last_header_icons = current_header_icons

		else if(!listequal(last_header_icons, current_header_icons))
			last_header_icons = current_header_icons
			ui_update_needed = TRUE
		else
			for(var/x in last_header_icons|current_header_icons)
				if(last_header_icons[x]!=current_header_icons[x])
					last_header_icons = current_header_icons
					ui_update_needed = TRUE
					break

	if(ui_update_needed)
		update_uis()

// Used by camera monitor program
/obj/item/modular_computer/check_eye(var/mob/user)
	if(active_program)
		return active_program.check_eye(user)
	return ..()

// Used by camera monitor program
/obj/item/modular_computer/grants_equipment_vision(var/mob/user)
	if(active_program)
		return active_program.grants_equipment_vision(user)
	return ..()

/obj/item/modular_computer/get_cell()
	return battery_module ? battery_module.get_cell() : DEVICE_NO_CELL

/obj/item/modular_computer/proc/toggle_service(service, mob/user, var/datum/computer_file/program/S = null)
	if(!S)
		S = hard_drive?.find_file_by_name(service)

	if(!istype(S)) // Program not found or it's not executable program.
		to_chat(user, SPAN_WARNING("\The [src] displays, \"I/O ERROR - Unable to locate [service]\""))
		return

	if(S.service_state == PROGRAM_STATE_ACTIVE)
		disable_service(null, user, S)
	else
		enable_service(null, user, S)


/obj/item/modular_computer/proc/enable_service(service, mob/user, var/datum/computer_file/program/S = null)
	if(QDELETED(src))
		return

	. = FALSE
	if(!S)
		S = hard_drive?.find_file_by_name(service)

	if(!istype(S)) // Program not found or it's not executable program.
		to_chat(user, SPAN_WARNING("\The [src] displays, \"I/O ERROR - Unable to enable [service]\""))
		return

	//We found the program, but it's being deleted
	if(QDELETED(S))
		return

	S.computer = src

	if(!S.is_supported_by_hardware(hardware_flag, 1, user))
		return

	if(S in enabled_services)
		return

	// Start service
	if(S.service_enable())
		enabled_services += S
		S.service_state = PROGRAM_STATE_ACTIVE
		return TRUE



/obj/item/modular_computer/proc/disable_service(service, mob/user, var/datum/computer_file/program/S = null)
	if(!S)
		S = hard_drive?.find_file_by_name(service)

	if(!istype(S)) // Program not found or it's not executable program.
		return

	if(!(S in enabled_services))
		return
	enabled_services -= S

	// Stop service
	S.service_disable()
	S.service_state = PROGRAM_STATE_DISABLED

/obj/item/modular_computer/proc/output_message(var/message, var/message_range)
	message_range += message_output_range
	if(message_range == 0)
		var/mob/user = loc
		if(istype(user))
			to_chat(user, message)
		return
	audible_message(message, hearing_distance = message_range)

// TODO: Make pretty much everything use these helpers.
/obj/item/modular_computer/proc/output_notice(var/message, var/message_range)
	message = "[icon2html(src, viewers(message_range, get_turf(src)))] [src]: " + message
	output_message(SPAN_NOTICE(message), message_range)

/obj/item/modular_computer/proc/output_error(var/message, var/message_range)
	message = "[icon2html(src, viewers(message_range, get_turf(src)))] [src]: " + message
	output_message(SPAN_WARNING(message), message_range)

/obj/item/modular_computer/proc/get_notification(var/message, var/message_range = 1, var/atom/source)
	if(silent)
		return
	playsound(get_turf(src), 'sound/machines/twobeep.ogg', 20, 1)
	message = "[icon2html(src, viewers(message_range, get_turf(src)))] [src]: [SPAN_DANGER("-!-")] Notification from [source]: " + message
	output_message(FONT_SMALL(SPAN_BOLD(message)), message_range)

/obj/item/modular_computer/proc/register_account(var/datum/computer_file/program/PRG = null)
	var/obj/item/card/id/id = GetID()
	if(PRG)
		output_notice("[PRG.filedesc] requires a registered NTNRC account. Registering automatically...")
	if(!istype(id))
		output_error("No ID card found!")
		return FALSE

	registered_id = id

	if(hard_drive)
		for(var/datum/computer_file/program/P in hard_drive.stored_files)
			P.event_registered()

	output_notice("Registration successful!")
	playsound(get_turf(src), 'sound/machines/ping.ogg', 10, 0)
	return registered_id

/obj/item/modular_computer/proc/unregister_account()
	if(!registered_id)
		return FALSE

	if(hard_drive)
		for(var/datum/computer_file/program/P in hard_drive.stored_files)
			P.event_unregistered()

	registered_id = null

	output_message(SPAN_NOTICE("\The [src] beeps: \"Successfully unregistered ID!\""))
	playsound(get_turf(src), 'sound/machines/ping.ogg', 20, 0)
	return TRUE

/obj/item/modular_computer/proc/set_autorun(var/fname)
	if(!fname)
		return FALSE

	var/datum/computer_file/data/autorun = hard_drive.find_file_by_name("autorun")

	if(istype(autorun) && autorun.stored_data == fname)
		autorun.stored_data = null
		return -1

	autorun = new /datum/computer_file/data(src)
	autorun.filename = "autorun"
	autorun.stored_data = fname
	hard_drive.store_file(autorun)
	return TRUE

/obj/item/modular_computer/proc/silence_notifications()
	silent = !silent
	for (var/datum/computer_file/program/P in hard_drive.stored_files)
		P.event_silentmode()

/obj/item/modular_computer/on_slotmove(var/mob/living/user, slot)
	. = ..(user, slot)
	BITSET(user.hud_updateflag, ID_HUD) //Same reasoning as for IDs

// A late init operation called in SSshuttle for ship computers and holopads, used to attach the thing to the right ship.
/obj/item/modular_computer/proc/attempt_hook_up(var/obj/effect/overmap/visitable/sector)
	SHOULD_CALL_PARENT(TRUE)
	if(!istype(sector))
		return FALSE
	if(sector.check_ownership(src))
		linked = sector
		return TRUE
	return FALSE

/obj/item/modular_computer/proc/sync_linked()
	var/obj/effect/overmap/visitable/sector = GLOB.map_sectors["[z]"]
	if(!sector)
		return
	return attempt_hook_up_recursive(sector)

/obj/item/modular_computer/proc/attempt_hook_up_recursive(var/obj/effect/overmap/visitable/sector)
	if(attempt_hook_up(sector))
		return sector
	for(var/obj/effect/overmap/visitable/candidate in sector)
		if((. = .(candidate)))
			return

#define LISTENER_MODULAR_COMPUTER "modular_computers"

/obj/item/modular_computer/process()
	handle_power() // Handles all computer power interaction
	if(!enabled) // The computer is turned off
		last_power_usage = 0
		return FALSE

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

	if(working && enabled && world.time > ambience_last_played + 30 SECONDS && prob(3))
		playsound(get_turf(src), "computerbeep", 30, 1, 10, required_preferences = SOUND_AMBIENCE)
		ambience_last_played = world.time

/obj/item/modular_computer/proc/get_preset_programs(preset_type)
	for(var/datum/modular_computer_app_presets/prs in ntnet_global.available_software_presets)
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

/obj/item/modular_computer/Initialize()
	. = ..()
	listener = new(LISTENER_MODULAR_COMPUTER, src)
	START_PROCESSING(SSprocessing, src)
	install_default_hardware()
	if(hard_drive)
		install_default_programs()
	update_icon()

/obj/item/modular_computer/Destroy()
	kill_program(TRUE)
	for(var/obj/item/computer_hardware/CH in src.get_all_components())
		uninstall_component(null, CH)
		qdel(CH)
	STOP_PROCESSING(SSprocessing, src)
	QDEL_NULL(listener)
	return ..()

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
		var/mutable_appearance/broken_overlay = mutable_appearance(icon, "broken", layer + 0.1, plane)
		add_overlay(broken_overlay)
		return
	if(!enabled)
		if(icon_state_screensaver && working)
			var/icon/screensaver_icon = icon(icon, icon_state_screensaver)
			if(is_holographic)
				var/icon/alpha_mask = new('icons/effects/effects.dmi', "scanline")
				screensaver_icon.AddAlphaMask(alpha_mask)
			var/mutable_appearance/screensaver_overlay = mutable_appearance(screensaver_icon, pick(screensaver_icon.IconStates()), layer + 0.1, plane)
			add_overlay(screensaver_overlay)

		if (screensaver_light_range && working)
			set_light(screensaver_light_range, 1, screensaver_light_color ? screensaver_light_color : "#FFFFFF")
		else
			set_light(0)
		return
	if(active_program)
		var/state = active_program.program_icon_state ? active_program.program_icon_state : icon_state_menu
		var/icon/state_icon = icon(icon, state)
		if(is_holographic)
			var/icon/alpha_mask = new('icons/effects/effects.dmi', "scanline")
			state_icon.AddAlphaMask(alpha_mask)
		var/mutable_appearance/state_overlay = mutable_appearance(state_icon, pick(state_icon.IconStates()), layer + 0.1, plane)
		add_overlay(state_overlay)
		set_light(light_strength, l_color = active_program.color)
	else
		var/icon/menu_icon = icon(icon, icon_state_menu)
		if(is_holographic)
			var/icon/alpha_mask = new('icons/effects/effects.dmi', "scanline")
			menu_icon.AddAlphaMask(alpha_mask)
		var/mutable_appearance/menu_overlay = mutable_appearance(menu_icon, pick(menu_icon.IconStates()), layer + 0.1, plane)
		add_overlay(menu_overlay)
		set_light(light_strength, l_color = menu_light_color)

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
	if(active_program)
		active_program.kill_program(forced)
		src.vueui_transfer(active_program)
		active_program = null
	var/mob/user = usr
	if(user && istype(user) && !forced)
		ui_interact(user) // Re-open the UI on this computer. It should show the main screen now.
	update_icon()

// Returns 0 for No Signal, 1 for Low Signal and 2 for Good Signal. 3 is for wired connection (always-on)
/obj/item/modular_computer/proc/get_ntnet_status(var/specific_action = 0)
	if(network_card)
		return network_card.get_signal(specific_action)
	else
		return 0

/obj/item/modular_computer/proc/add_log(var/text)
	if(!get_ntnet_status())
		return FALSE
	return ntnet_global.add_log(text, network_card)

/obj/item/modular_computer/proc/shutdown_computer(var/loud = TRUE)
	SSvueui.close_uis(active_program)
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
	SSvueui.close_uis(src)
	enabled = FALSE
	update_icon()

/obj/item/modular_computer/proc/enable_computer(var/mob/user)
	enabled = TRUE
	update_icon()

	// Autorun feature
	var/datum/computer_file/data/autorun = hard_drive ? hard_drive.find_file_by_name("autorun") : null
	if(istype(autorun))
		run_program(autorun.stored_data, user)

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
	SSnanoui.close_uis(active_program.NM ? active_program.NM : active_program)
	src.vueui_transfer(active_program)
	active_program = null
	update_icon()
	if(istype(user))
		ui_interact(user) // Re-open the UI on this computer. It should show the main screen now.


/obj/item/modular_computer/proc/run_program(prog, mob/user)
	var/datum/computer_file/program/P = null
	if(!istype(user))
		user = usr
	if(hard_drive)
		P = hard_drive.find_file_by_name(prog)

	if(!P || !istype(P)) // Program not found or it's not executable program.
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
		if(!P.vueui_transfer(src))
			SSvueui.close_uis(src)
		return

	if(idle_threads.len >= processor_unit.max_idle_programs+1)
		to_chat(user, SPAN_WARNING("\The [src] displays, \"Maximal CPU load reached. Unable to run another program.\"."))
		return

	if(P.requires_ntnet && !get_ntnet_status(P.requires_ntnet_feature)) // The program requires NTNet connection, but we are not connected to NTNet.
		to_chat(user, FONT_SMALL(SPAN_WARNING("\The [src] displays, \"NETWORK ERROR - Unable to connect to NTNet. Please retry. If problem persists contact your system administrator.\".")))
		return

	if(active_program)
		minimize_program(user)

	if(P.run_program(user))
		active_program = P
		if(!P.vueui_transfer(src))
			SSvueui.close_uis(src)
		update_icon()
	return TRUE

/obj/item/modular_computer/proc/update_uis()
	if(active_program) //Should we update program ui or computer ui?
		SSnanoui.update_uis(active_program)
		if(active_program.NM)
			SSnanoui.update_uis(active_program.NM)
	else
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
	else
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
	if(!S)
		S = hard_drive?.find_file_by_name(service)

	if(!istype(S)) // Program not found or it's not executable program.
		to_chat(user, SPAN_WARNING("\The [src] displays, \"I/O ERROR - Unable to enable [service]\""))
		return

	S.computer = src

	if(!S.is_supported_by_hardware(hardware_flag, 1, user))
		return

	if(S in enabled_services)
		return

	enabled_services += S

	// Start service
	S.service_activate()
	S.service_state = PROGRAM_STATE_ACTIVE


/obj/item/modular_computer/proc/disable_service(service, mob/user, var/datum/computer_file/program/S = null)
	if(!S)
		S = hard_drive?.find_file_by_name(service)

	if(!istype(S)) // Program not found or it's not executable program.
		return

	if(!(S in enabled_services))
		return
	enabled_services -= S

	// Stop service
	S.service_deactivate()
	S.service_state = PROGRAM_STATE_KILLED

/obj/item/modular_computer/proc/output_message(var/message, var/message_range)
	message_range += message_output_range
	if(message_range == 0)
		var/mob/user = loc
		if(istype(user))
			to_chat(user, message)
		return
	visible_message(message, range = message_range)

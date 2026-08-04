/obj/item/modular_computer/handheld/communicator
	name = "communicator"
	desc = "A T-14.2 private communicator for voice calls and text messages over NTNet."
	icon = 'icons/obj/modular_computers/communicator.dmi'
	icon_state = "communicator"
	icon_state_unpowered = "communicator"
	pickup_sound = 'sound/items/pickup/device.ogg'
	drop_sound = 'sound/items/drop/device.ogg'
	hardware_flag = PROGRAM_COMMUNICATOR
	can_reset = FALSE

	var/unread_notification = FALSE
	/// Feature tier. See the COMMUNICATOR_TIER_* defines.
	var/communicator_tier = COMMUNICATOR_TIER_BASIC
	/// Fixed directory name used by public landlines instead of an ID card name.
	var/directory_name

	/// How many tiles away can the communicator pick up speech while on a voice call.
	var/mic_range = 3

/obj/item/modular_computer/handheld/communicator/Initialize()
	. = ..()
	set_autorun("ntnet_comm")

	/*
	Calling `enable_computer()` directly in `Initialize()` generates a dreamchecker error because
	`/datum/computer_file/program/chat_client/run_program()` has an `alert()` call,
	potentially causing the whole `Initialize()` thread to freeze.

	That will never actually get called from here, but dreamchecker doesn't know that so
	this works for now to avoid it for now.
	*/
	INVOKE_ASYNC(src, PROC_REF(enable_computer), null, TRUE)

/obj/item/modular_computer/handheld/communicator/run_program(prog, mob/user, forced = FALSE)
	if(prog != "ntnet_comm")
		to_chat(user, SPAN_WARNING("\The [src]'s proprietary firmware rejects non-communicator software."))
		return FALSE
	return ..()

/// Communicators are single-app devices, so the generic NTOS close and minimize actions are not valid.
/obj/item/modular_computer/handheld/communicator/kill_program(forced = FALSE)
	if(!forced && istype(active_program, /datum/computer_file/program/communicator))
		return FALSE
	return ..()

/obj/item/modular_computer/handheld/communicator/minimize_program(mob/user)
	if(istype(active_program, /datum/computer_file/program/communicator))
		return FALSE
	return ..()

/obj/item/modular_computer/handheld/communicator/get_header_data(list/data)
	. = ..()
	// Hides NTOS's close/minimize buttons and leaves the normal power button available.
	.["PC_showexitprogram"] = FALSE

/// Recovers communicators that were left at the NTOS menu by an older close action.
/obj/item/modular_computer/handheld/communicator/proc/ensure_communicator_program(mob/user)
	if(active_program || !enabled)
		return !!active_program
	var/datum/computer_file/program/communicator/communicator_app = get_communicator_program()
	if(!communicator_app)
		return FALSE
	communicator_app.set_computer(src)
	if(!communicator_app.run_program(user))
		return FALSE
	active_program = communicator_app
	update_icon()
	return TRUE

/obj/item/modular_computer/handheld/communicator/try_install_component(mob/living/user, obj/item/computer_hardware/hardware, found = FALSE)
	if(istype(hardware, /obj/item/computer_hardware/hard_drive) && !istype(hardware, /obj/item/computer_hardware/hard_drive/micro/communicator))
		to_chat(user, SPAN_WARNING("\The [src] only accepts a proprietary communicator drive."))
		return FALSE
	return ..()

/obj/item/modular_computer/handheld/communicator/register_account(datum/computer_file/program/PRG, obj/item/card/id/id, quiet)
	. = ..()
	if(. && name == initial(name)) // Only rename if there isn't already a custom name set.
		name = "[id.registered_name]'s [initial(name)]"

/obj/item/modular_computer/handheld/communicator/unregister_account(quiet)
	. = ..()
	if(.)
		name = initial(name)

// Todo: add some way to reset/change registered ID card.
/obj/item/modular_computer/handheld/communicator/attackby(obj/item/attacking_item, mob/user)
	if(!istype(attacking_item, /obj/item/card/id))
		return ..()
	if(registered_id)
		if(attacking_item != registered_id)
			output_error("ID card rejected! This device has already been registered.")
		return TRUE

	register_account(null, attacking_item)
	return TRUE

/obj/item/modular_computer/handheld/communicator/get_notification(message, message_range, source)
	. = ..()
	unread_notification = TRUE
	update_icon()

/obj/item/modular_computer/handheld/communicator/ui_interact(mob/user, datum/tgui/ui)
	ensure_communicator_program(user)
	. = ..()
	unread_notification = FALSE
	update_icon()

/// Preserve the controlling machine while video is active. A remote eye can make
/// normal visibility/distance status non-interactive without actually closing TGUI,
/// and the modular-computer parent would otherwise unset the user's machine.
/obj/item/modular_computer/handheld/communicator/ui_status(mob/user, datum/ui_state/state)
	var/datum/computer_file/program/communicator/communicator_app = get_communicator_program()
	if(communicator_app?.video_call_on && communicator_app.video_viewer == user)
		return user.shared_ui_interaction(src)
	return ..()

/// Closing the communicator also exits any remote camera view owned by that user.
/obj/item/modular_computer/handheld/communicator/ui_close(mob/user)
	. = ..()
	var/datum/computer_file/program/communicator/communicator_app = get_communicator_program()
	if(communicator_app?.video_viewer == user)
		communicator_app.stop_video_call()

/obj/item/modular_computer/handheld/communicator/update_icon()
	var/datum/computer_file/program/communicator/communicator_app = get_communicator_program()
	communicator_app?.refresh_icon_state(FALSE)
	return ..()

/obj/item/modular_computer/handheld/communicator/proc/get_communicator_program()
	RETURN_TYPE(/datum/computer_file/program/communicator)
	return hard_drive?.find_file_by_name("ntnet_comm")

// Called by `/datum/gear/computer/handheld/communicator/spawn_item()`.
/obj/item/modular_computer/handheld/communicator/proc/register_to_mob(mob/M)
	if(istype(M))
		register_account(null, M.GetIdCard(), TRUE)

/obj/item/modular_computer/handheld/communicator/video
	name = "video communicator"
	desc = "An upgraded private communicator with a short-range video-call camera."
	communicator_tier = COMMUNICATOR_TIER_VIDEO
	color = "#d9efff"

/obj/item/modular_computer/handheld/communicator/holographic
	name = "holographic communicator"
	desc = "An expensive private communicator capable of projecting callers as holograms."
	communicator_tier = COMMUNICATOR_TIER_HOLOGRAPHIC
	color = "#ffe2a8"

/// Wall-mounted, APC-powered department phone with video support.
/obj/item/modular_computer/handheld/communicator/landline
	name = "department landline"
	desc = "A wall-mounted department communicator with voice, text, and video-call support."
	icon = 'icons/obj/machinery/wall/terminals.dmi'
	icon_state = "intercom"
	icon_state_unpowered = "intercom"
	anchored = TRUE
	layer = ABOVE_WINDOW_LAYER
	appearance_flags = TILE_BOUND
	slot_flags = 0
	w_class = WEIGHT_CLASS_BULKY
	communicator_tier = COMMUNICATOR_TIER_VIDEO
	var/obj/item/card/id/landline_identity

/obj/item/modular_computer/handheld/communicator/landline/Initialize()
	. = ..()
	switch(dir)
		if(NORTH)
			pixel_y = 20
		if(SOUTH)
			pixel_y = -2
		if(WEST)
			pixel_x = -8
		if(EAST)
			pixel_x = 8

	directory_name ||= "[get_area_display_name(get_area(src))] Landline"
	landline_identity = new(src)
	landline_identity.registered_name = directory_name
	register_account(null, landline_identity, TRUE)
	name = directory_name

/obj/item/modular_computer/handheld/communicator/landline/Destroy()
	. = ..()
	QDEL_NULL(landline_identity)
	return .

/obj/item/modular_computer/handheld/communicator/landline/register_account(datum/computer_file/program/program, obj/item/card/id/id, quiet)
	if(id != landline_identity)
		return FALSE
	return ..()

/obj/item/modular_computer/handheld/communicator/landline/unregister_account(quiet)
	return FALSE

/obj/item/modular_computer/handheld/communicator/landline/update_icon()
	icon_state = "intercom"
	ClearOverlays()
	if(!enabled || !working)
		set_light(0)
		return

	var/image/screen = image(icon, "intercom_screen")
	var/datum/computer_file/program/communicator/communicator_app = get_communicator_program()
	if(communicator_app?.active_call)
		screen.color = COLOR_GREEN
	else if(unread_notification || length(communicator_app?.comm_requests[INCOMING_REQUESTS][CALL_REQUESTS]))
		screen.color = COLOR_RED
	else
		screen.color = COLOR_CYAN
	AddOverlays(screen)
	AddOverlays(emissive_appearance(icon, "intercom_screen"))
	set_light(1, 0.5, screen.color)

/obj/item/modular_computer/handheld/communicator/landline/command
	directory_name = "Command Department Landline"

/obj/item/modular_computer/handheld/communicator/landline/security
	directory_name = "Security Department Landline"

/obj/item/modular_computer/handheld/communicator/landline/engineering
	directory_name = "Engineering Department Landline"

/obj/item/modular_computer/handheld/communicator/landline/medical
	directory_name = "Medical Department Landline"

/obj/item/modular_computer/handheld/communicator/landline/science
	directory_name = "Science Department Landline"

/obj/item/modular_computer/handheld/communicator/landline/operations
	directory_name = "Operations Department Landline"

/obj/item/modular_computer/handheld/communicator/landline/service
	directory_name = "Service Department Landline"

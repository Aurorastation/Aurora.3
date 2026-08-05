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

/// Portable cradle for a department landline. The handpiece holds the actual computer.
/obj/item/communicator_landline
	name = "department landline cradle"
	desc = "A portable cradle for a tethered department communicator handpiece."
	desc_mechanics = "Click on the cradle to pick up or put down the handpiece. Drag the cradle onto your character to pick it up."
	icon = 'icons/obj/radio.dmi'
	icon_state = "communicator_landline"
	w_class = WEIGHT_CLASS_BULKY
	var/directory_name
	var/handpiece_type = /obj/item/modular_computer/handheld/communicator/landline
	/// The real communicator, stored in this cradle while on the hook.
	var/obj/item/modular_computer/handheld/communicator/landline/handpiece
	var/ringing = FALSE

/obj/item/communicator_landline/Initialize()
	. = ..()
	directory_name ||= "[get_area_display_name(get_area(src))] Landline"
	handpiece = new handpiece_type(src)
	handpiece.landline_cradle = src
	directory_name = handpiece.directory_name
	name = directory_name
	update_icon()

/obj/item/communicator_landline/Destroy()
	QDEL_NULL(handpiece)
	return ..()

/obj/item/communicator_landline/update_icon()
	icon_state = handpiece?.loc == src ? "communicator_landline" : "communicator_landline_raised"

/// The cradle is intentionally picked up by dragging it onto the user's character, not by a normal click.
/obj/item/communicator_landline/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	if(over != user || !Adjacent(user) || user.incapacitated())
		return ..()
	user.put_in_hands(src)

/obj/item/communicator_landline/attack_hand(mob/user)
	if(!user)
		return FALSE
	if(handpiece?.loc == src)
		return take_handpiece(user)
	to_chat(user, SPAN_NOTICE("The handpiece is already off the hook."))
	return TRUE

/// Using the receiver on its cradle hangs it up, including when it is still held.
/obj/item/communicator_landline/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item != handpiece)
		return ..()
	if(user && attacking_item.loc == user)
		user.drop_from_inventory(attacking_item, src)
	return_handpiece(handpiece)
	return TRUE

/obj/item/communicator_landline/proc/take_handpiece(mob/user)
	if(!handpiece || handpiece.loc != src)
		return FALSE
	user.put_in_hands(handpiece)
	stop_ringing()
	handpiece.connect_cord()
	update_icon()
	return TRUE

/obj/item/communicator_landline/proc/start_ringing()
	if(ringing)
		return
	ringing = TRUE
	ring()

/obj/item/communicator_landline/proc/stop_ringing()
	ringing = FALSE

/obj/item/communicator_landline/proc/ring()
	if(!ringing || handpiece?.loc != src)
		stop_ringing()
		return
	playsound(src, 'sound/weapons/ring.ogg', 45, TRUE)
	shake_animation(2)
	addtimer(CALLBACK(src, PROC_REF(ring)), 2 SECONDS)

/obj/item/communicator_landline/proc/return_handpiece(obj/item/modular_computer/handheld/communicator/landline/returning_handpiece)
	if(returning_handpiece != handpiece)
		return FALSE
	returning_handpiece.hang_up()
	returning_handpiece.disconnect_cord()
	returning_handpiece.stop_tracking_holder()
	returning_handpiece.forceMove(src)
	update_icon()
	return TRUE

/// Gray tether line used by a raised landline handpiece.
/datum/beam/communicator_cord/afterDraw()
	for(var/obj/effect/ebeam/segment as anything in elements)
		segment.color = COLOR_GRAY40
		segment.blend_mode = BLEND_DEFAULT

/// Held items have hand-placement pixel offsets; use turf centres so the cord ends at the holder's tile.
/datum/beam/communicator_cord/get_x_translation_vector()
	return (world.icon_size * target_oldloc.x) - (world.icon_size * origin_oldloc.x)

/datum/beam/communicator_cord/get_y_translation_vector()
	return (world.icon_size * target_oldloc.y) - (world.icon_size * origin_oldloc.y)

/// The movable receiver is the communicator itself; the cradle is only a holder and cable anchor.
/obj/item/modular_computer/handheld/communicator/landline
	name = "landline handpiece"
	desc = "A tethered department communicator handpiece."
	icon = 'icons/obj/radio.dmi'
	icon_state = "communicator_handpiece"
	icon_state_unpowered = "communicator_handpiece"
	w_class = WEIGHT_CLASS_SMALL
	item_flags = ITEM_FLAG_NO_BLUDGEON
	communicator_tier = COMMUNICATOR_TIER_BASIC
	var/obj/item/card/id/landline_identity
	var/obj/item/communicator_landline/landline_cradle
	var/datum/beam/communicator_cord/cord
	/// Mob currently carrying this receiver in either hand.
	var/mob/handpiece_holder

/obj/item/modular_computer/handheld/communicator/landline/Initialize()
	. = ..()
	directory_name ||= "[get_area_display_name(get_area(src))] Landline"
	landline_identity = new(src)
	landline_identity.registered_name = directory_name
	register_account(null, landline_identity, TRUE)
	name = directory_name

/obj/item/modular_computer/handheld/communicator/landline/Destroy()
	disconnect_cord()
	stop_tracking_holder()
	if(landline_cradle?.handpiece == src)
		landline_cradle.handpiece = null
		landline_cradle.update_icon()
	landline_cradle = null
	QDEL_NULL(landline_identity)
	return ..()

/obj/item/modular_computer/handheld/communicator/landline/register_account(datum/computer_file/program/program, obj/item/card/id/id, quiet)
	if(id != landline_identity)
		return FALSE
	return ..()

/obj/item/modular_computer/handheld/communicator/landline/unregister_account(quiet)
	return FALSE

/obj/item/modular_computer/handheld/communicator/landline/update_icon()
	icon_state = "communicator_handpiece"
	. = ..()
	var/datum/computer_file/program/communicator/communicator_app = get_communicator_program()
	if(landline_cradle && loc == landline_cradle && length(communicator_app?.comm_requests[INCOMING_REQUESTS][CALL_REQUESTS]))
		landline_cradle.start_ringing()
	else
		landline_cradle?.stop_ringing()
	return .

/obj/item/modular_computer/handheld/communicator/landline/equipped(mob/user, slot, assisted_equip)
	. = ..()
	if(slot == slot_l_hand || slot == slot_r_hand)
		track_holder(user)
	else
		addtimer(CALLBACK(src, PROC_REF(return_to_cradle)), 0)

/obj/item/modular_computer/handheld/communicator/landline/dropped(mob/user)
	. = ..()
	return_to_cradle()

/obj/item/modular_computer/handheld/communicator/landline/on_slotmove(mob/living/user, slot)
	. = ..()
	if(slot && slot != slot_l_hand && slot != slot_r_hand)
		addtimer(CALLBACK(src, PROC_REF(return_to_cradle)), 0)

/obj/item/modular_computer/handheld/communicator/landline/on_enter_storage(obj/item/storage/storage)
	. = ..()
	return_to_cradle()

/// Table placement and similar direct moves bypass dropped() and storage hooks.
/obj/item/modular_computer/handheld/communicator/landline/Moved(atom/old_loc, movement_dir, forced, list/old_locs)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(check_tether_range)), 0)

/obj/item/modular_computer/handheld/communicator/landline/proc/track_holder(mob/new_holder)
	if(handpiece_holder == new_holder)
		connect_cord()
		return
	stop_tracking_holder()
	handpiece_holder = new_holder
	RegisterSignal(handpiece_holder, COMSIG_MOVABLE_MOVED, PROC_REF(check_tether_range), TRUE)
	connect_cord()
	check_tether_range()

/obj/item/modular_computer/handheld/communicator/landline/proc/stop_tracking_holder()
	if(handpiece_holder)
		UnregisterSignal(handpiece_holder, COMSIG_MOVABLE_MOVED)
	handpiece_holder = null

/obj/item/modular_computer/handheld/communicator/landline/proc/check_tether_range()
	if(!landline_cradle || !handpiece_holder || loc != handpiece_holder || !(src == handpiece_holder.get_active_hand() || src == handpiece_holder.get_inactive_hand()))
		return_to_cradle()
		return
	var/turf/cradle_turf = get_turf(landline_cradle)
	var/turf/holder_turf = get_turf(handpiece_holder)
	if(!cradle_turf || !holder_turf || cradle_turf.z != holder_turf.z || get_dist(cradle_turf, holder_turf) > 2)
		// Explicitly clear the held-item slot before re-seating the receiver.
		handpiece_holder.drop_from_inventory(src, landline_cradle)
		return_to_cradle()

/obj/item/modular_computer/handheld/communicator/landline/proc/return_to_cradle()
	if(!landline_cradle)
		return
	if(loc == landline_cradle)
		hang_up()
		disconnect_cord()
		stop_tracking_holder()
		landline_cradle.update_icon()
		return
	landline_cradle.return_handpiece(src)

/obj/item/modular_computer/handheld/communicator/landline/proc/hang_up()
	var/datum/computer_file/program/communicator/communicator_app = get_communicator_program()
	if(communicator_app?.active_call)
		communicator_app.end_call("[directory_name] hung up.")

/obj/item/modular_computer/handheld/communicator/landline/proc/connect_cord()
	if(!landline_cradle || !ismob(loc))
		return
	QDEL_NULL(cord)
	cord = landline_cradle.Beam(src, icon_state = "explore_beam", time = -1, maxdistance = 3, beam_sleep_time = 1, beam_datum_type = /datum/beam/communicator_cord)

/obj/item/modular_computer/handheld/communicator/landline/proc/disconnect_cord()
	QDEL_NULL(cord)


/obj/item/communicator_landline/command
	handpiece_type = /obj/item/modular_computer/handheld/communicator/landline/command

/obj/item/communicator_landline/security
	handpiece_type = /obj/item/modular_computer/handheld/communicator/landline/security

/obj/item/communicator_landline/engineering
	handpiece_type = /obj/item/modular_computer/handheld/communicator/landline/engineering

/obj/item/communicator_landline/medical
	handpiece_type = /obj/item/modular_computer/handheld/communicator/landline/medical

/obj/item/communicator_landline/science
	handpiece_type = /obj/item/modular_computer/handheld/communicator/landline/science

/obj/item/communicator_landline/operations
	handpiece_type = /obj/item/modular_computer/handheld/communicator/landline/operations

/obj/item/communicator_landline/service
	handpiece_type = /obj/item/modular_computer/handheld/communicator/landline/service

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

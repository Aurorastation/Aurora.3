/datum/comm_call
	var/call_start_time
	var/list/datum/computer_file/program/communicator/connected_comms = list()
	var/list/obj/effect/overlay/hologram/communicator/holograms = list()

/datum/comm_call/New()
	. = ..()
	call_start_time = world.time
	START_PROCESSING(SSprocessing, src)

/datum/comm_call/Destroy(force)
	STOP_PROCESSING(SSprocessing, src)
	QDEL_LIST(holograms)
	var/list/connected_copy = connected_comms.Copy()
	connected_comms.Cut()
	for(var/datum/computer_file/program/communicator/communicator as anything in connected_copy)
		communicator.stop_video_call()
		communicator.hologram_on = FALSE
		communicator.computer?.lose_hearing_sensitivity()
		UnregisterSignal(communicator.computer, COMSIG_OBJ_HEAR_TALK)
		communicator.active_call = null
		communicator.speakerphone_on = FALSE
		communicator.microphone_on = TRUE
		if(communicator.current_tab == COMM_CALL_TAB)
			communicator.current_tab = initial(communicator.current_tab)
		communicator.refresh_icon_state()
	return ..()

/datum/comm_call/proc/add_device(datum/computer_file/program/communicator/communicator)
	if(!communicator || (communicator in connected_comms))
		return FALSE
	connected_comms += communicator
	communicator.active_call = src
	communicator.microphone_on = TRUE
	communicator.computer.become_hearing_sensitive()
	RegisterSignal(communicator.computer, COMSIG_OBJ_HEAR_TALK, PROC_REF(on_hear_talk))
	communicator.refresh_icon_state()
	refresh_holograms()
	return TRUE

/datum/comm_call/proc/remove_device(datum/computer_file/program/communicator/communicator, message)
	if(!(communicator in connected_comms))
		return FALSE
	connected_comms -= communicator
	communicator.stop_video_call()
	communicator.hologram_on = FALSE
	communicator.computer?.lose_hearing_sensitivity()
	UnregisterSignal(communicator.computer, COMSIG_OBJ_HEAR_TALK)
	communicator.active_call = null
	communicator.speakerphone_on = FALSE
	communicator.microphone_on = TRUE
	if(communicator.current_tab == COMM_CALL_TAB)
		communicator.current_tab = initial(communicator.current_tab)
	communicator.refresh_icon_state()

	if(message)
		for(var/datum/computer_file/program/communicator/remaining_comm as anything in connected_comms)
			remaining_comm.computer.output_notice(message)
	if(length(connected_comms) <= 1)
		qdel(src)
	else
		refresh_holograms()
	return TRUE

/datum/comm_call/proc/set_microphone(datum/computer_file/program/communicator/communicator, microphone_enabled)
	if(!(communicator in connected_comms))
		return FALSE
	if(microphone_enabled)
		communicator.computer.become_hearing_sensitive()
	else
		communicator.computer.lose_hearing_sensitivity()
	return TRUE

/datum/comm_call/proc/on_hear_talk(
	obj/item/modular_computer/handheld/communicator/hearer,
	mob/speaker,
	text,
	verb,
	datum/language/speaking
)
	SIGNAL_HANDLER
	if(isobserver(speaker) || speaking?.flags & (NONVERBAL|SIGNLANG) || get_dist(hearer, speaker) > hearer.mic_range)
		return

	var/datum/computer_file/program/communicator/source_comm
	for(var/datum/computer_file/program/communicator/communicator as anything in connected_comms)
		if(communicator.computer == hearer)
			source_comm = communicator
			break
	if(!source_comm?.microphone_on)
		return

	for(var/datum/computer_file/program/communicator/communicator as anything in connected_comms)
		var/obj/item/modular_computer/handheld/communicator/receiver = communicator.computer
		if(receiver == hearer)
			continue

		var/speaker_range = communicator.speakerphone_on ? world.view : 0
		var/list/comm_listeners = get_hearers_in_view(speaker_range, receiver)
		receiver.langchat_speech(text, comm_listeners, speaking, speaker.langchat_color)

		for(var/mob/listener in comm_listeners)
			if(isdeaf(listener))
				continue
			var/rendered_text = text
			if(!listener.say_understands(speaker, speaking))
				rendered_text = speaking ? speaking.scramble(text, listener.languages) : stars(text)
			var/listener_message = speaking ? speaking.format_message(rendered_text, verb) : "<span class='message body'>[rendered_text]</span>"
			var/combined_message = "[icon2html(receiver, listener)] [speaker.get_accent_icon()] <span class='game say'><span class='name'>[speaker.GetVoice()]</span> [listener_message]</span>"
			to_chat(listener, combined_message)

/datum/comm_call/proc/refresh_holograms()
	QDEL_LIST(holograms)
	for(var/datum/computer_file/program/communicator/source_comm as anything in connected_comms)
		if(!source_comm.hologram_on || source_comm.get_device_tier() < COMMUNICATOR_TIER_HOLOGRAPHIC)
			continue
		var/list/datum/computer_file/program/communicator/eligible_targets = list()
		for(var/datum/computer_file/program/communicator/target_comm as anything in connected_comms)
			if(target_comm == source_comm || target_comm.get_device_tier() < COMMUNICATOR_TIER_HOLOGRAPHIC)
				continue
			eligible_targets += target_comm
		var/slot_count = length(eligible_targets)
		for(var/slot_index in 1 to slot_count)
			var/datum/computer_file/program/communicator/target_comm = eligible_targets[slot_index]
			var/obj/effect/overlay/hologram/communicator/projection = new(get_turf(source_comm.computer), source_comm, target_comm, src, slot_index, slot_count)
			holograms += projection

/datum/comm_call/process(seconds_per_tick)
	for(var/obj/effect/overlay/hologram/communicator/projection as anything in holograms.Copy())
		if(!projection.update_projection())
			holograms -= projection
			qdel(projection)

/datum/computer_file/program/communicator/proc/get_projection_subject()
	RETURN_TYPE(/atom)
	var/atom/subject = get_atom_on_turf(computer)
	return ismob(subject) ? subject : computer

/obj/effect/overlay/hologram/communicator
	name = "communicator hologram"
	var/datum/computer_file/program/communicator/source_comm
	var/datum/computer_file/program/communicator/target_comm
	var/datum/comm_call/parent_call
	var/slot_index = 1
	var/slot_count = 1
	/// The caller currently carrying this projection. Movement and facing signals keep its glide synchronized.
	var/atom/movable/bound_caller
	/// A movement direction for which the projection was repositioned before the caller turned.
	var/prepared_move_direction
	/// Blue directional cone that visually connects the caller to this projection.
	var/obj/effect/overlay/hologram/communicator/cone/projection_cone

/obj/effect/overlay/hologram/communicator/Initialize(mapload, datum/computer_file/program/communicator/source, datum/computer_file/program/communicator/target, datum/comm_call/call_datum, assigned_slot = 1, total_slots = 1)
	. = ..()
	source_comm = source
	target_comm = target
	parent_call = call_datum
	slot_index = assigned_slot
	slot_count = max(1, total_slots)
	update_projection()

/obj/effect/overlay/hologram/communicator/Destroy()
	bind_to_caller(null)
	QDEL_NULL(projection_cone)
	source_comm = null
	target_comm = null
	parent_call = null
	return ..()

/// Copy the target appearance directly. The shared tail renderer supplies both
/// ordered tail layers, so this remains correct when the hologram faces another direction.
/obj/effect/overlay/hologram/communicator/assume_form(atom/subject, long_range = FALSE, projection_direction)
	if(!subject)
		return
	appearance = subject.appearance
	appearance_flags = KEEP_TOGETHER | PIXEL_SCALE
	layer = initial(layer)
	pixel_x = subject.pixel_x
	pixel_y = subject.pixel_y
	dir = projection_direction || subject.dir
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	color = rgb(125, 180, 225)
	alpha = 100
	set_light(2, 1, rgb(125, 180, 225))

/// A small, translucent directional-light cone used as a hologram projector beam.
/obj/effect/overlay/hologram/communicator/cone
	name = "hologram projection cone"
	icon = 'icons/effects/light_overlays/light_cone_32.dmi'
	icon_state = "light"
	layer = FLY_LAYER - 0.01
	alpha = 80
	color = rgb(125, 180, 225)
	blend_mode = BLEND_ADD
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/overlay/hologram/communicator/proc/update_projection_cone(turf/caller_turf, projection_direction, animate_movement)
	if(!projection_cone)
		projection_cone = new(caller_turf)
	projection_cone.glide_size = animate_movement ? bound_caller?.glide_size : 0
	projection_cone.pixel_x = 0
	projection_cone.pixel_y = 0
	// The projection is one tile in front of the caller; centre this 32px cone in that gap.
	if(projection_direction & NORTH)
		projection_cone.pixel_y = ICON_SIZE_Y / 2
	else if(projection_direction & SOUTH)
		projection_cone.pixel_y = -ICON_SIZE_Y / 2
	if(projection_direction & EAST)
		projection_cone.pixel_x = ICON_SIZE_X / 2
	else if(projection_direction & WEST)
		projection_cone.pixel_x = -ICON_SIZE_X / 2
	if(slot_count > 1)
		var/slot_spacing = min(COMMUNICATOR_HOLOGRAM_SLOT_SPACING, COMMUNICATOR_HOLOGRAM_MAX_SPREAD / (slot_count - 1))
		projection_cone.pixel_x += round((slot_index - (slot_count + 1) / 2) * slot_spacing)
	projection_cone.transform = null
	projection_cone.set_dir(projection_direction)
	if(projection_cone.loc != caller_turf)
		projection_cone.forceMove(caller_turf)

/obj/effect/overlay/hologram/communicator/proc/bind_to_caller(atom/movable/new_caller)
	if(bound_caller == new_caller)
		return
	if(bound_caller)
		UnregisterSignal(bound_caller, list(COMSIG_MOVABLE_PRE_MOVE_DIRECTION, COMSIG_MOVABLE_MOVED, COMSIG_ATOM_DIR_CHANGE))
	bound_caller = new_caller
	prepared_move_direction = 0
	if(bound_caller)
		RegisterSignal(bound_caller, COMSIG_MOVABLE_PRE_MOVE_DIRECTION, PROC_REF(on_caller_move_started))
		RegisterSignal(bound_caller, COMSIG_MOVABLE_MOVED, PROC_REF(on_caller_moved))
		RegisterSignal(bound_caller, COMSIG_ATOM_DIR_CHANGE, PROC_REF(on_caller_turned))

/obj/effect/overlay/hologram/communicator/proc/on_caller_move_started(atom/movable/source, atom/new_loc, movement_direction, update_direction)
	SIGNAL_HANDLER
	if(source != bound_caller || !update_direction || !source.set_dir_on_move || source.dir == movement_direction)
		return
	// Put the projection on the caller's new front edge before Move() turns the
	// caller. The subsequent moved signal can then glide it exactly one tile.
	prepared_move_direction = movement_direction
	update_projection(FALSE, movement_direction)

/obj/effect/overlay/hologram/communicator/proc/on_caller_moved(atom/movable/source)
	SIGNAL_HANDLER
	if(source == bound_caller)
		prepared_move_direction = 0
		update_projection()

/obj/effect/overlay/hologram/communicator/proc/on_caller_turned(atom/movable/source, old_direction, new_direction)
	SIGNAL_HANDLER
	if(source != bound_caller)
		return
	if(prepared_move_direction == new_direction)
		prepared_move_direction = 0
		return
	prepared_move_direction = 0
	update_projection(FALSE)

/obj/effect/overlay/hologram/communicator/proc/update_projection(animate_movement = TRUE, projection_direction)
	if(!source_comm || !target_comm || source_comm.active_call != parent_call || target_comm.active_call != parent_call || !source_comm.hologram_on)
		return FALSE
	var/atom/movable/caller_subject = source_comm.get_projection_subject()
	var/atom/receiver_subject = target_comm.get_projection_subject()
	var/turf/caller_turf = get_turf(caller_subject)
	if(!projection_direction)
		projection_direction = caller_subject.dir
	if(!caller_turf || !receiver_subject)
		return FALSE
	bind_to_caller(caller_subject)
	assume_form(receiver_subject, TRUE, REVERSE_DIR(projection_direction))
	// Anchor the projection to the caller's turf and draw it one tile forward.
	// Because both atoms now traverse identical turfs, their glides cannot drift
	// apart when Move() also changes the caller's direction.
	if(projection_direction & NORTH)
		pixel_y += ICON_SIZE_Y
	else if(projection_direction & SOUTH)
		pixel_y -= ICON_SIZE_Y
	if(projection_direction & EAST)
		pixel_x += ICON_SIZE_X
	else if(projection_direction & WEST)
		pixel_x -= ICON_SIZE_X
	if(slot_count > 1)
		var/slot_spacing = min(COMMUNICATOR_HOLOGRAM_SLOT_SPACING, COMMUNICATOR_HOLOGRAM_MAX_SPREAD / (slot_count - 1))
		pixel_x += round((slot_index - (slot_count + 1) / 2) * slot_spacing)
	glide_size = animate_movement ? caller_subject.glide_size : 0
	if(loc != caller_turf)
		forceMove(caller_turf)
	update_projection_cone(caller_turf, projection_direction, animate_movement)
	set_dir(REVERSE_DIR(projection_direction))
	name = "hologram of [target_comm.get_user_name()]"
	return TRUE

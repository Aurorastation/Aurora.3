/// Active, registered communicator applications, keyed by their public-facing NTNet number.
GLOBAL_LIST_EMPTY(active_communicator_apps)

/datum/computer_file/program/communicator
	filename = "ntnet_comm"
	filedesc = "Communicator"
	program_icon_state = "comm"
	extended_desc = "A private NTNet client for direct calls, contacts, and text messages."
	size = 16
	requires_ntnet = TRUE
	requires_ntnet_feature = NTNET_COMMUNICATION
	available_on_ntnet = FALSE
	usage_flags = PROGRAM_COMMUNICATOR
	network_destination = "NTNet Communicator Service"
	tgui_id = "Communicator"

	/// The phone call this device is currently connected to.
	var/datum/comm_call/active_call
	/// Associative list of the other party's address to a shared text conversation.
	var/alist/active_chats = alist()
	/// Local contact book: address to last-known display name.
	var/alist/friends = alist()
	/// Incoming and outgoing signaling requests.
	var/alist/comm_requests = alist(
		INCOMING_REQUESTS = alist(
			CALL_REQUESTS = list(),
			FRIEND_REQUESTS = list(),
		),
		OUTGOING_REQUESTS = alist(
			CALL_REQUESTS = list(),
			FRIEND_REQUESTS = list(),
		)
	)

	var/current_tab = COMM_HOME_TAB
	var/connecting_to_address
	var/custom_username
	var/visible_on_network = TRUE
	var/speakerphone_on = FALSE
	var/microphone_on = TRUE

	/// Limited video feed state. Only one person can view from a device at once.
	var/video_call_on = FALSE
	var/mob/video_viewer
	var/datum/computer_file/program/communicator/video_target
	/// Map zoom in use before video temporarily applies the client's High zoom setting.
	var/video_previous_zoom
	/// Whether this caller is currently being projected by holographic peers.
	var/hologram_on = FALSE
	/// Receiver approvals pending for video/hologram features, keyed by feature then address.
	var/alist/incoming_feature_requests = alist(VIDEO_REQUESTS = list(), HOLOGRAM_REQUESTS = list())
	var/alist/outgoing_feature_requests = alist(VIDEO_REQUESTS = list(), HOLOGRAM_REQUESTS = list())
	var/mob/pending_video_viewer
	var/mob/pending_hologram_user

/datum/computer_file/program/communicator/New(obj/item/modular_computer/comp)
	. = ..()
	if(!istype(comp))
		return
	RegisterSignal(computer, COMSIG_MOD_COMPUTER_HW_INSTALLED, PROC_REF(on_hw_installed))
	RegisterSignal(computer, COMSIG_MOD_COMPUTER_HW_UNINSTALLED, PROC_REF(on_hw_uninstalled))

/datum/computer_file/program/communicator/Destroy()
	remove_from_active()
	clean_variables(clear_chats = TRUE)
	return ..()

/datum/computer_file/program/communicator/run_program(mob/user)
	. = ..()
	if(!.)
		return FALSE
	if(!get_computer_address())
		computer.output_error("ERROR: Unable to locate network card.")
		return FALSE
	add_to_active()
	refresh_icon_state()
	incoming_feature_requests = alist(VIDEO_REQUESTS = list(), HOLOGRAM_REQUESTS = list())
	outgoing_feature_requests = alist(VIDEO_REQUESTS = list(), HOLOGRAM_REQUESTS = list())
	pending_video_viewer = null
	pending_hologram_user = null
	return TRUE

/datum/computer_file/program/communicator/kill_program(forced)
	. = ..()
	remove_from_active()
	clean_variables()
	current_tab = initial(current_tab)
	refresh_icon_state()
	return .

/datum/computer_file/program/communicator/process_tick()
	if(video_call_on && (!video_viewer?.client || !active_call || !(video_target in active_call.connected_comms)))
		stop_video_call()
	else if(video_call_on)
		if(video_viewer.machine != computer)
			video_viewer.set_machine(computer)
		if(!update_video_view())
			stop_video_call()
	return TRUE

/// Keeps a live communicator feed from being cancelled by the mob vision subsystem.
/datum/computer_file/program/communicator/check_eye(mob/user)
	if(user != video_viewer || !video_call_on || user.stat || user.blinded)
		return -1
	var/atom/video_eye = get_video_eye_target()
	if(!active_call || !(video_target in active_call.connected_comms) || !video_eye)
		return -1
	if(user.client && user.client.eye != video_eye)
		user.reset_view(video_eye)
	return 0

/// Remote video should retain the viewer's normal corrective and equipment vision.
/datum/computer_file/program/communicator/grants_equipment_vision(mob/user)
	return check_eye(user) >= 0

/datum/computer_file/program/communicator/event_registered()
	. = ..()
	add_to_active()
	update_static_data_for_all_viewers()

/datum/computer_file/program/communicator/event_unregistered()
	. = ..()
	remove_from_active()
	clean_variables()
	update_static_data_for_all_viewers()

/datum/computer_file/program/communicator/event_networkfailure(background)
	. = ..()
	remove_from_active()
	clean_variables()

/datum/computer_file/program/communicator/proc/on_hw_installed(obj/item/modular_computer/source, mob/living/user, obj/item/computer_hardware/hardware)
	SIGNAL_HANDLER
	if(computer.registered_id && istype(hardware, /obj/item/computer_hardware/network_card))
		var/obj/item/computer_hardware/network_card/network_card = hardware
		add_to_active(network_card.identification_addr)

/datum/computer_file/program/communicator/proc/on_hw_uninstalled(obj/item/modular_computer/source, mob/living/user, obj/item/computer_hardware/hardware)
	SIGNAL_HANDLER
	if(!istype(hardware, /obj/item/computer_hardware/network_card))
		return
	var/obj/item/computer_hardware/network_card/network_card = hardware
	remove_from_active(network_card.identification_addr)
	clean_variables()

/// Registers the application without ever replacing a device already using the same number.
/datum/computer_file/program/communicator/proc/add_to_active(address)
	address ||= get_computer_address()
	if(!address || !computer?.registered_id || !validate_ntnet_address(address))
		return FALSE
	address = lowertext(address)
	var/datum/computer_file/program/communicator/existing = GLOB.active_communicator_apps[address]
	if(existing && existing != src)
		computer.output_error("ERROR: Communicator number {[address]} is already in use.")
		return FALSE
	GLOB.active_communicator_apps[address] = src
	return TRUE

/datum/computer_file/program/communicator/proc/remove_from_active(address)
	address ||= get_computer_address()
	if(address && GLOB.active_communicator_apps[address] == src)
		GLOB.active_communicator_apps -= address

/// Ends transient communications. Contacts and message history survive normal power/network loss.
/datum/computer_file/program/communicator/proc/clean_variables(clear_chats = FALSE)
	stop_video_call()
	hologram_on = FALSE
	if(active_call)
		active_call.remove_device(src)

	var/our_address = get_computer_address()
	for(var/category in comm_requests[INCOMING_REQUESTS])
		var/list/incoming_copy = comm_requests[INCOMING_REQUESTS][category].Copy()
		for(var/address in incoming_copy)
			var/datum/computer_file/program/communicator/other_comm = GLOB.active_communicator_apps[address]
			if(our_address && other_comm)
				other_comm.cancel_comm_request(our_address, category)
			else
				comm_requests[INCOMING_REQUESTS][category] -= address

	for(var/category in comm_requests[OUTGOING_REQUESTS])
		var/list/outgoing_copy = comm_requests[OUTGOING_REQUESTS][category].Copy()
		for(var/address in outgoing_copy)
			cancel_comm_request(address, category)

	connecting_to_address = null
	if(current_tab == COMM_CALL_TAB)
		current_tab = initial(current_tab)

	if(clear_chats)
		var/list/chats_to_detach = list()
		for(var/address in active_chats)
			chats_to_detach |= active_chats[address]
		for(var/datum/comm_chat/chat as anything in chats_to_detach)
			chat.remove_participant(src)
		active_chats.Cut()
	refresh_icon_state()

/datum/computer_file/program/communicator/proc/get_computer_address()
	return lowertext(computer?.network_card?.identification_addr)

/datum/computer_file/program/communicator/proc/get_user_name()
	var/obj/item/modular_computer/handheld/communicator/communicator = computer
	return custom_username || communicator?.directory_name || computer?.registered_id?.registered_name

/datum/computer_file/program/communicator/proc/get_device_tier()
	var/obj/item/modular_computer/handheld/communicator/communicator = computer
	return communicator?.communicator_tier || COMMUNICATOR_TIER_BASIC

/datum/computer_file/program/communicator/proc/get_tier_name()
	switch(get_device_tier())
		if(COMMUNICATOR_TIER_HOLOGRAPHIC)
			return "Holographic"
		if(COMMUNICATOR_TIER_VIDEO)
			return "Video"
	return "Basic"

/datum/computer_file/program/communicator/proc/is_valid_request_category(category)
	return category == CALL_REQUESTS || category == FRIEND_REQUESTS

/datum/computer_file/program/communicator/proc/request_feature(datum/computer_file/program/communicator/target_comm, feature, mob/requester)
	if(!active_call || !target_comm || !(target_comm in active_call.connected_comms) || !(feature in list(VIDEO_REQUESTS, HOLOGRAM_REQUESTS)) || length(outgoing_feature_requests[feature]))
		return FALSE
	var/source_address = get_computer_address()
	if(!source_address || (source_address in target_comm.incoming_feature_requests[feature]))
		return FALSE
	outgoing_feature_requests[feature] |= target_comm.get_computer_address()
	target_comm.incoming_feature_requests[feature] |= source_address
	if(feature == VIDEO_REQUESTS)
		pending_video_viewer = requester
	else
		pending_hologram_user = requester
	target_comm.computer.get_notification("New [feature] request!", 1, get_user_name())
	target_comm.refresh_icon_state()
	refresh_icon_state()
	return TRUE

/datum/computer_file/program/communicator/proc/respond_feature_request(datum/computer_file/program/communicator/source_comm, feature, approved)
	var/source_address = source_comm?.get_computer_address()
	if(!source_address || !(source_address in incoming_feature_requests[feature]))
		return FALSE
	incoming_feature_requests[feature] -= source_address
	source_comm.outgoing_feature_requests[feature] -= get_computer_address()
	if(approved)
		if(feature == VIDEO_REQUESTS)
			source_comm.begin_video_call(source_comm.pending_video_viewer, src)
		else if(feature == HOLOGRAM_REQUESTS)
			source_comm.hologram_on = TRUE
			source_comm.active_call?.refresh_holograms()
	var/response_text = approved ? "approved" : "denied"
	source_comm.computer.get_notification("Your [feature] request was [response_text] by [get_user_name()].", 1, get_user_name())
	source_comm.pending_video_viewer = null
	source_comm.pending_hologram_user = null
	refresh_icon_state()
	source_comm.refresh_icon_state()
	return TRUE

/datum/computer_file/program/communicator/proc/send_comm_request(target_address, category)
	target_address = lowertext(target_address)
	var/source_address = get_computer_address()
	var/datum/computer_file/program/communicator/target_comm = GLOB.active_communicator_apps[target_address]
	if(!is_valid_request_category(category) || !source_address || !target_comm || target_comm == src || GLOB.active_communicator_apps[source_address] != src)
		return FALSE
	if(target_address in comm_requests[OUTGOING_REQUESTS][category])
		return FALSE
	if(category == CALL_REQUESTS && length(comm_requests[OUTGOING_REQUESTS][CALL_REQUESTS]))
		return FALSE
	if(!target_comm.receive_comm_request(source_address, category))
		return FALSE
	comm_requests[OUTGOING_REQUESTS][category] |= target_address
	refresh_icon_state()
	return TRUE

/datum/computer_file/program/communicator/proc/cancel_comm_request(target_address, category)
	if(!is_valid_request_category(category))
		return FALSE
	target_address = lowertext(target_address)
	comm_requests[OUTGOING_REQUESTS][category] -= target_address
	var/source_address = get_computer_address()
	var/datum/computer_file/program/communicator/target_comm = GLOB.active_communicator_apps[target_address]
	if(source_address && target_comm)
		target_comm.comm_requests[INCOMING_REQUESTS][category] -= source_address
		target_comm.refresh_icon_state()
	refresh_icon_state()
	return TRUE

/datum/computer_file/program/communicator/proc/receive_comm_request(source_address, category)
	PRIVATE_PROC(TRUE)
	if(!is_valid_request_category(category) || !GLOB.active_communicator_apps[source_address])
		return FALSE
	if(source_address in comm_requests[INCOMING_REQUESTS][category])
		return FALSE
	if(category == CALL_REQUESTS)
		if(active_call || length(comm_requests[INCOMING_REQUESTS][CALL_REQUESTS]) || (source_address in comm_requests[OUTGOING_REQUESTS][CALL_REQUESTS]))
			return FALSE

	comm_requests[INCOMING_REQUESTS][category] |= source_address
	var/datum/computer_file/program/communicator/caller_comm = GLOB.active_communicator_apps[source_address]
	var/obj/item/modular_computer/handheld/communicator/communicator_device = computer
	var/had_unread_notification = communicator_device?.unread_notification
	computer.get_notification("New [category] request!", 1, caller_comm?.get_user_name() || "\[UNKNOWN\]")
	// A ringing call is represented by the pending request itself. It must not become a
	// persistent unread alert after the caller cancels, while older text/contact alerts survive.
	if(category == CALL_REQUESTS && communicator_device)
		communicator_device.unread_notification = had_unread_notification
	refresh_icon_state()
	return TRUE

/// Returns whether this device legitimately knows a hidden address and may receive it in UI data.
/datum/computer_file/program/communicator/proc/knows_address(address)
	if((address in friends) || active_chats[address])
		return TRUE
	for(var/direction in comm_requests)
		for(var/category in comm_requests[direction])
			if(address in comm_requests[direction][category])
				return TRUE
	if(active_call)
		for(var/datum/computer_file/program/communicator/other_comm as anything in active_call.connected_comms)
			if(other_comm.get_computer_address() == address)
				return TRUE
	return FALSE

/datum/computer_file/program/communicator/proc/get_or_create_chat(datum/computer_file/program/communicator/target_comm)
	RETURN_TYPE(/datum/comm_chat)
	if(!target_comm || target_comm == src)
		return
	var/target_address = target_comm.get_computer_address()
	var/our_address = get_computer_address()
	if(!target_address || !our_address)
		return
	var/datum/comm_chat/existing_chat = active_chats[target_address]
	if(existing_chat)
		return existing_chat
	existing_chat = target_comm.active_chats[our_address]
	if(existing_chat)
		if(existing_chat.attach_participant(src))
			return existing_chat
	return new /datum/comm_chat(src, target_comm)

/datum/computer_file/program/communicator/proc/send_text_message(target_address, message)
	target_address = lowertext(target_address)
	var/datum/computer_file/program/communicator/target_comm = GLOB.active_communicator_apps[target_address]
	if(!target_comm || target_comm == src)
		return FALSE
	message = sanitize(message, COMMUNICATOR_MAX_TEXT_LENGTH)
	if(!length(message))
		return FALSE
	var/datum/comm_chat/chat = get_or_create_chat(target_comm)
	if(!chat || !chat.send_message(message, src))
		return FALSE
	target_comm.computer.get_notification("New text message!", 1, get_user_name())
	target_comm.refresh_icon_state()
	return TRUE

/datum/computer_file/program/communicator/proc/get_video_targets()
	var/list/video_targets = list()
	if(!active_call || get_device_tier() < COMMUNICATOR_TIER_VIDEO)
		return video_targets
	for(var/datum/computer_file/program/communicator/other_comm as anything in active_call.connected_comms)
		if(other_comm != src && other_comm.get_device_tier() >= COMMUNICATOR_TIER_VIDEO)
			video_targets += other_comm
	return video_targets

/datum/computer_file/program/communicator/proc/get_video_target()
	RETURN_TYPE(/datum/computer_file/program/communicator)
	var/list/video_targets = get_video_targets()
	return length(video_targets) ? video_targets[1] : null

/datum/computer_file/program/communicator/proc/toggle_video_call(mob/user)
	if(video_call_on)
		stop_video_call()
		return TRUE
	if(isobserver(user) || !user?.client)
		return FALSE
	var/list/video_targets = get_video_targets()
	if(!length(video_targets))
		computer.output_error("No video-capable call participant is available.")
		return FALSE
	var/list/target_choices = list()
	for(var/datum/computer_file/program/communicator/available_target as anything in video_targets)
		var/target_label = "[available_target.get_user_name()] ([available_target.get_computer_address()])"
		target_choices[target_label] = available_target
	var/selected_label = tgui_input_list(user, "Select the participant's video camera to watch.", "Video Camera", target_choices)
	var/datum/computer_file/program/communicator/target_comm = target_choices[selected_label]
	// The call may have changed while the camera picker was open.
	if(!target_comm || !(target_comm in get_video_targets()))
		return FALSE

	return request_feature(target_comm, VIDEO_REQUESTS, user)

/datum/computer_file/program/communicator/proc/begin_video_call(mob/user, datum/computer_file/program/communicator/target_comm)
	if(isobserver(user) || !user?.client || !active_call || !(target_comm in active_call.connected_comms))
		return FALSE
	video_call_on = TRUE
	if(isliving(user))
		var/mob/living/living_user = user
		living_user.set_fullscreen(FALSE, "communicator_video_transition", /atom/movable/screen/fullscreen/blackout)
	video_viewer = user
	video_target = target_comm
	video_previous_zoom = winget(user.client, "mapwindow.map", "zoom")
	if(!length(video_previous_zoom))
		video_previous_zoom = "0"
	winset(user.client, "mapwindow.map", "zoom=[COMMUNICATOR_VIDEO_ZOOM]")
	if(user.machine != computer)
		user.set_machine(computer)
	if(!update_video_view())
		stop_video_call()
		return FALSE
	refresh_icon_state()
	return TRUE

/datum/computer_file/program/communicator/proc/stop_video_call()
	var/mob/old_viewer = video_viewer
	if(old_viewer?.client)
		if(isliving(old_viewer))
			var/mob/living/living_viewer = old_viewer
			living_viewer.set_fullscreen(TRUE, "communicator_video_transition", /atom/movable/screen/fullscreen/blackout)
		if(is_video_camera_eye(old_viewer))
			old_viewer.reset_view(null)
		if(!isnull(video_previous_zoom))
			addtimer(CALLBACK(src, PROC_REF(restore_video_zoom), old_viewer, old_viewer.client, video_previous_zoom), 1 SECOND)
	video_call_on = FALSE
	video_viewer = null
	video_target = null
	video_previous_zoom = null
	refresh_icon_state()

/// Client camera updates have no acknowledgement; keep the transition black until the remote view is certainly gone.
/datum/computer_file/program/communicator/proc/restore_video_zoom(mob/viewer, client/viewer_client, previous_zoom)
	if(video_call_on || !viewer_client)
		return
	winset(viewer_client, "mapwindow.map", "zoom=[previous_zoom]")
	if(isliving(viewer))
		var/mob/living/living_viewer = viewer
		living_viewer.set_fullscreen(FALSE, "communicator_video_transition", /atom/movable/screen/fullscreen/blackout)
/// Resolves the selected device's physical carrier, regardless of inventory nesting.
/datum/computer_file/program/communicator/proc/get_video_camera_target()
	RETURN_TYPE(/atom/movable)
	var/atom/movable/subject = get_atom_on_turf(video_target?.computer)
	return subject && isturf(subject.loc) ? subject : null

/// Returns the top-level atom containing the selected communicator.
/datum/computer_file/program/communicator/proc/get_video_eye_target()
	RETURN_TYPE(/atom)
	return get_video_camera_target()

/// Whether this program currently owns the user's eye through its resolved camera target.
/datum/computer_file/program/communicator/proc/is_video_camera_eye(mob/user)
	return video_call_on && video_viewer == user && user?.client?.eye == get_video_eye_target()

/datum/computer_file/program/communicator/proc/update_video_view()
	var/atom/video_eye = get_video_eye_target()
	if(!video_viewer?.client || video_viewer.stat || video_viewer.blinded || !video_eye)
		return FALSE
	if(video_viewer.client.eye != video_eye)
		video_viewer.reset_view(video_eye)
	return video_viewer.client.eye == video_eye

/datum/computer_file/program/communicator/proc/toggle_hologram(mob/user)
	if(!active_call || get_device_tier() < COMMUNICATOR_TIER_HOLOGRAPHIC)
		return FALSE
	var/can_project = FALSE
	for(var/datum/computer_file/program/communicator/other_comm as anything in active_call.connected_comms)
		if(other_comm != src && other_comm.get_device_tier() >= COMMUNICATOR_TIER_HOLOGRAPHIC)
			can_project = TRUE
			break
	if(!can_project)
		computer.output_error("No holographic call participant is available.")
		return FALSE
	if(hologram_on)
		hologram_on = FALSE
		active_call.refresh_holograms()
		refresh_icon_state()
		return TRUE
	var/datum/computer_file/program/communicator/target_comm = null
	for(var/datum/computer_file/program/communicator/other_comm as anything in active_call.connected_comms)
		if(other_comm != src && other_comm.get_device_tier() >= COMMUNICATOR_TIER_HOLOGRAPHIC)
			target_comm = other_comm
			break
	return request_feature(target_comm, HOLOGRAM_REQUESTS, user)

/datum/computer_file/program/communicator/proc/refresh_icon_state(update_computer = TRUE)
	if(active_call)
		program_icon_state = video_call_on ? "video" : "active"
	else if(length(comm_requests[INCOMING_REQUESTS][CALL_REQUESTS]) || length(comm_requests[OUTGOING_REQUESTS][CALL_REQUESTS]) || length(incoming_feature_requests[VIDEO_REQUESTS]) || length(incoming_feature_requests[HOLOGRAM_REQUESTS]) || length(outgoing_feature_requests[VIDEO_REQUESTS]) || length(outgoing_feature_requests[HOLOGRAM_REQUESTS]))
		program_icon_state = "called"
	else
		var/obj/item/modular_computer/handheld/communicator/communicator = computer
		program_icon_state = communicator?.unread_notification ? "called" : "comm"
	computer?.update_uis()
	if(update_computer)
		computer?.update_icon()

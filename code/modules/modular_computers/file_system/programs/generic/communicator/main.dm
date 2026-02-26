// BIG TODO: Ensure that ALL new datums and items being deleted individually and while midway through an action (e.g. calling someone) gets handled properly.
// todo: add logging for admins, ghosts, and `generate_network_log()`

/// Associative list of NTNet addresses and their corresponding [/datum/computer_file/program/communicator].
///
/// Communicator apps will only be present in this list if their parent [/obj/item/modular_computer/handheld/communicator] has both a registered user,
/// and a vaid NTNet address through its network card.
GLOBAL_LIST_EMPTY(active_communicator_apps)

/datum/computer_file/program/communicator
	filename = "ntnet_comm"
	filedesc = "Communicator"
	program_icon_state = "comm"
	extended_desc = "todo"
	size = 16
	requires_ntnet = TRUE
	requires_ntnet_feature = NTNET_COMMUNICATION
	available_on_ntnet = FALSE
	network_destination = "todo"
	tgui_id = "Communicator"

	/// The phone call datum that this communicator is connected to, along with any other communicators in the call.
	var/datum/comm_call/active_call

	/// Friend list! Associative list of each friend's NTNet address, and their last known username.
	///
	/// The username is stored so that in the event that their communicator goes offline, the friends list UI can still show a listing for them.
	var/alist/friends = alist()

	/// Associative list of request "directions" (incoming, outgoing), each with their own alist of "categories", which hold regular lists of NTNet addresses.
	///
	/// Modifying/accessing the address lists is far less confusing than it looks. Just `comm_requests[*DIRECTION*_REQUESTS][*CATEGORY*_REQUESTS] ±= *address*`
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

	/// Current TGUI screen. This is kept as a variable here so that it can be changed on the DM side, for example if the user joins a phone call.
	var/current_tab = COMM_HOME_TAB
	/// The NTNet address that this communicator is currently trying to "connect" to, after which it will join a [/datum/comm_call]. (`null` if it isn't connecting to anything)
	var/connecting_to_address = null

	/// A custom name set by the user in the settings page of the TGUI interface.
	/// If `null`, the [/obj/item/card/id/var/registered_name] of the device's registered ID will be used instead.
	var/custom_username = null
	/// Is this device visible in the 'Public Devices' list of the UI?
	/// Friends and users who know the device's NTNet address can still communicate with it even if this is set to `FALSE`.
	var/visible_on_network = TRUE
	/// If someone else talks in a voice call, will this device broadcast the message over a wide area (`TRUE`), or only show it to the person holding the communicator (`FALSE`).
	var/speakerphone_on = FALSE
	/// Will speech near this communicator get picked up and transmitted through a voice call? (Mute button)
	var/microphone_on = TRUE

/datum/computer_file/program/communicator/New(obj/item/modular_computer/comp)
	. = ..()
	if(!istype(comp))
		return

	RegisterSignal(computer, COMSIG_MOD_COMPUTER_HW_INSTALLED, PROC_REF(on_hw_installed))
	RegisterSignal(computer, COMSIG_MOD_COMPUTER_HW_UNINSTALLED, PROC_REF(on_hw_uninstalled))

/datum/computer_file/program/communicator/Destroy()
	remove_from_active()
	clean_variables()
	return ..()

/datum/computer_file/program/communicator/run_program(mob/user)
	add_to_active()
	if(!get_computer_address())
		computer.output_error("ERROR: Unable to locate network card.")
		return
	return ..()

/datum/computer_file/program/communicator/kill_program(forced)
	. = ..()
	// Reset the UI back to its default state.
	current_tab = initial(current_tab)

// ID card registered on the parent `computer`.
/datum/computer_file/program/communicator/event_registered()
	add_to_active()
	update_static_data_for_all_viewers()

// ID card unregistered on the parent `computer`.
/datum/computer_file/program/communicator/event_unregistered()
	remove_from_active()
	update_static_data_for_all_viewers()

// Can't connect to NTNet, so remove this comm from the global "active" list.
/datum/computer_file/program/communicator/event_networkfailure(background)
	. = ..()
	remove_from_active()

// If there was previously no network card and one was just installed, add this comm back to the global list.
/datum/computer_file/program/communicator/proc/on_hw_installed(obj/item/modular_computer/source, mob/living/user, obj/item/computer_hardware/H)
	SIGNAL_HANDLER
	if(computer.registered_id && istype(H, /obj/item/computer_hardware/network_card))
		add_to_active(computer.network_card.identification_addr)

// If the network card was uninstalled, remove from the global list.
/datum/computer_file/program/communicator/proc/on_hw_uninstalled(obj/item/modular_computer/source, mob/living/user, obj/item/computer_hardware/H)
	SIGNAL_HANDLER
	if(istype(H, /obj/item/computer_hardware/network_card))
		var/obj/item/computer_hardware/network_card/net_card = H
		remove_from_active(net_card.identification_addr)

/**
 * Add this communicator to [GLOB.active_communicator_apps][/datum/controller/global_vars/var/active_communicator_apps].
 *
 * Arguments:
 * * address - **(Optional)** The address use as a key in `GLOB.active_communicator_apps`. If unset, the proc will use [/datum/computer_file/program/communicator/proc/get_computer_address].
 */
/datum/computer_file/program/communicator/proc/add_to_active(address = null)
	address ||= get_computer_address()
	if(address)
		GLOB.active_communicator_apps[address] = src

/**
 * Remove this communicator from [GLOB.active_communicator_apps][/datum/controller/global_vars/var/active_communicator_apps].
 *
 * Arguments:
 * * address - **(Optional)** The address to look for as a key in `GLOB.active_communicator_apps`. If unset, the proc will use [/datum/computer_file/program/communicator/proc/get_computer_address].
 */
/datum/computer_file/program/communicator/proc/remove_from_active(address = null)
	address ||= get_computer_address()
	if(address)
		GLOB.active_communicator_apps -= address

/// Clean up and reset some of the more complicated variables back to their initial state. In particular `active_call` and `comm_requests`.
/datum/computer_file/program/communicator/proc/clean_variables()
	if(active_call)
		active_call.remove_device(src)
		// `active_call` gets set to null in `remove_device()`.

	// Try to clean up any requests to and from this communicator.
	var/our_address = get_computer_address()
	for(var/category in comm_requests[INCOMING_REQUESTS])
		for(var/address in comm_requests[INCOMING_REQUESTS][category])
			var/datum/computer_file/program/communicator/comm = GLOB.active_communicator_apps[address]
			if(our_address && comm)
				comm.cancel_comm_request(our_address, category)
			else
				comm_requests[INCOMING_REQUESTS][category] -= address

	for(var/category in comm_requests[OUTGOING_REQUESTS])
		for(var/address in comm_requests[OUTGOING_REQUESTS][category])
			cancel_comm_request(address, category)

/// Returns the NTNet address of the parent `computer`'s network card.
/datum/computer_file/program/communicator/proc/get_computer_address()
	return computer.network_card?.identification_addr

/// Returns the username of the communicator's owner. Either `custom_username` if set, or the name on the parent `computer`'s `registered_id`.
/datum/computer_file/program/communicator/proc/get_user_name()
	return custom_username || computer.registered_id?.registered_name

/**
 * Send a comm request of type `category` to `target_address`, adding it to their `comm_requests[INCOMING_REQUESTS]` and our `comm_requests[OUTGOING_REQUESTS]`.
 *
 * If this communicator has no address, the target can't be found, or the target rejects the request, this will return `FALSE`.
 *
 * If the request was successfully sent and recieved, this will modify both sides' `comm_requests` and return `TRUE`
 *
 * Arguments:
 * * target_address - The NTNet address of the communicator being sent the request.
 * * category - The 'category' of the request to send. Must be one of [CALL_REQUESTS] or [FRIEND_REQUESTS].
 */
/datum/computer_file/program/communicator/proc/send_comm_request(target_address, category)
	var/source_address = get_computer_address()
	var/datum/computer_file/program/communicator/target_comm = GLOB.active_communicator_apps[target_address]
	if(!source_address || !target_comm)
		return FALSE

	if(!target_comm.recieve_comm_request(source_address, category))
		return FALSE
	comm_requests[OUTGOING_REQUESTS][category] |= target_address
	return TRUE

/**
 * Cancel an existing comm request of type `category` to `target_address`, removing it from our `comm_requests[OUTGOING_REQUESTS]`,
 * and their `comm_requests[INCOMING_REQUESTS]` if `target_address` can be found.
 *
 * Arguments:
 * * target_address - The NTNet address of the communicator who was previously sent the request.
 * * category - The 'category' of the request to remove. Must be one of [CALL_REQUESTS] or [FRIEND_REQUESTS].
 */
/datum/computer_file/program/communicator/proc/cancel_comm_request(target_address, category)
	comm_requests[OUTGOING_REQUESTS][category] -= target_address

	var/source_address = get_computer_address()
	var/datum/computer_file/program/communicator/target_comm = GLOB.active_communicator_apps[target_address]
	if(source_address && target_comm)
		target_comm.comm_requests[INCOMING_REQUESTS][category] -= source_address

/**
 * Called by `send_comm_request()` on the target communicator. Returns `TRUE` if the request was successfully recieved and added, otherwise `FALSE`.
 *
 * Arguments:
 * * source_address - The NTNet address of the communicator who sent the comm request.
 * * category - The category of the request being recieved.
 */
/datum/computer_file/program/communicator/proc/recieve_comm_request(source_address, category)
	PRIVATE_PROC(TRUE)
	if(source_address in comm_requests[INCOMING_REQUESTS][category])
		return FALSE
	if(category == CALL_REQUESTS && active_call)
		return FALSE

	comm_requests[INCOMING_REQUESTS][category] |= source_address

	var/datum/computer_file/program/communicator/caller_comm = GLOB.active_communicator_apps[source_address]
	var/caller_name = caller_comm?.get_user_name() || "\[UNKNOWN\]"
	computer.get_notification("New [category] request!", 1, caller_name)
	return TRUE

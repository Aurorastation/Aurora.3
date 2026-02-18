// BIG TODO: Ensure that ALL new datums and items being deleted individually and while midway through an action (e.g. calling someone) gets handled properly.
/datum/ntnet_user
	var/username
	var/list/channels = list()
	var/list/dm_channels = list()
	var/list/clients = list()

	var/datum/comm_call/active_call

	// list of friend names (string)
	// This is names so that if a friend's device goes offline they can still stay on the UI as 'unreachable'.
	var/list/friends = list()

	// request values are all ntnet addresses (todo: actual documentation)
	var/alist/comm_requests = alist(
		INCOMING_REQUESTS = alist(
			CALL_REQUESTS = list(),
			VIDEO_REQUESTS = list(),
			FRIEND_REQUESTS = list(),
		),
		OUTGOING_REQUESTS = alist(
			CALL_REQUESTS = list(),
			VIDEO_REQUESTS = list(),
			FRIEND_REQUESTS = list(),
		)
	)

	var/visible_on_network = TRUE

/datum/ntnet_user/New()
	. = ..()
	GLOB.ntnet_global.users.Add(src)

/datum/ntnet_user/Destroy(force)
	. = ..()

	//This notifies every client that might have this as a client to deactivate and clear the reference
	for(var/datum/computer_file/program/chat_client/client as anything in GLOB.ntnet_global.chat_clients)
		client.handle_ntnet_user_deletion(src)

	GLOB.ntnet_global.users.Remove(src)
	channels = null
	dm_channels = null
	clients = null

/datum/ntnet_user/proc/generateUsernameIdCard(var/obj/item/card/id/card)
	if(!card)
		return "Unknown"
	return "[card.registered_name], [card.assignment]"

/datum/ntnet_user/proc/generateUsernameSilicon(var/mob/living/silicon/silicon)
	return silicon.name

/datum/ntnet_user/proc/get_user_from_address(address)
	var/datum/computer_file/program/communicator/comm_app = GLOB.active_communicator_apps[address]
	return comm_app?.get_program_user()

/datum/ntnet_user/proc/try_get_request_target(source_address, target_address)
	PRIVATE_PROC(TRUE)
	if(get_user_from_address(source_address) != src)
		// This shouldn't ever happen but just in case.
		return
	var/datum/ntnet_user/target_user = get_user_from_address(target_address)
	if(!target_user)
		return

	return target_user

/datum/ntnet_user/proc/send_comm_request(source_address, target_address, category)
	var/datum/ntnet_user/target_user = try_get_request_target(source_address, target_address)
	if(!target_user)
		return FALSE

	src.comm_requests[OUTGOING_REQUESTS][category] |= target_address
	target_user.comm_requests[INCOMING_REQUESTS][category] |= source_address
	return TRUE

/datum/ntnet_user/proc/remove_comm_request(source_address, target_address, category)
	var/datum/ntnet_user/target_user = try_get_request_target(source_address, target_address)
	if(!target_user)
		return FALSE

	src.comm_requests[OUTGOING_REQUESTS][category] -= target_address
	target_user.comm_requests[INCOMING_REQUESTS][category] -= source_address
	return TRUE

/datum/ntnet_user/proc/add_friend(datum/ntnet_user/new_friend)
	// Todo: `username` includes job title and stuff, so this will break if someone changes their job
	src.friends |= new_friend.username
	new_friend.friends |= src.username

/datum/ntnet_user/proc/remove_friend(friend_name)
	friends -= friend_name

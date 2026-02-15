/datum/ntnet_user
	var/username
	var/list/channels = list()
	var/list/dm_channels = list()
	var/list/clients = list()

	// list of friend names (string)
	var/list/friends = list()

	// request values are all `/datum/ntnet_user` refs (todo: actual documentation)
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

	// todo: make sure that these are actually the right way around
	for(var/category in comm_requests[INCOMING_REQUESTS])
		for(var/requester_ref in category)
			var/datum/ntnet_user/requester = locate(requester_ref)
			if(requester)
				remove_comm_request(requester, category)
	for(var/category in comm_requests[OUTGOING_REQUESTS])
		for(var/target_ref in category)
			var/datum/ntnet_user/target = locate(target_ref)
			if(target)
				target.remove_comm_request(REF(src), category)

/datum/ntnet_user/proc/generateUsernameIdCard(var/obj/item/card/id/card)
	if(!card)
		return "Unknown"
	return "[card.registered_name], [card.assignment]"

/datum/ntnet_user/proc/generateUsernameSilicon(var/mob/living/silicon/silicon)
	return silicon.name

/**
 * Adds a communicator request from [requester] to our [/datum/ntnet_user/var/comm_requests] list.
 *
 * Arguments:
 * * datum/ntnet_user/requester - The user sending the communicator request.
 * * category - The category of the request. Must be one of [CALL_REQUESTS], [VIDEO_REQUESTS], or [FRIEND_REQUESTS].
 */
/datum/ntnet_user/proc/add_comm_request(datum/ntnet_user/requester, category)
	comm_requests[INCOMING_REQUESTS][category] |= REF(requester)
	requester.comm_requests[OUTGOING_REQUESTS][category] |= REF(src)

/**
 * Removes a communicator request from [requester] from our [/datum/ntnet_user/var/comm_requests] list.
 *
 * Arguments:
 * * datum/ntnet_user/requester - The user whose request is being removed.
 * * category - The category of the request. Must be one of [CALL_REQUESTS], [VIDEO_REQUESTS], or [FRIEND_REQUESTS].
 */
/datum/ntnet_user/proc/remove_comm_request(datum/ntnet_user/requester, category)
	comm_requests[INCOMING_REQUESTS][category] -= REF(requester)
	requester.comm_requests[OUTGOING_REQUESTS][category] -= REF(src)

/datum/ntnet_user/proc/add_friend(datum/ntnet_user/new_friend)
	remove_comm_request(new_friend, FRIEND_REQUESTS)

	src.friends |= new_friend.username
	new_friend.friends |= src.username

/datum/ntnet_user/proc/remove_friend(friend_name)
	friends -= friend_name

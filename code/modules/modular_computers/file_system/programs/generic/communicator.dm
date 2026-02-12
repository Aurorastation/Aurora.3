#define REQUESTS_DATA(requests_list, category) ( \
	alist( \
		INCOMING_REQUESTS = requests_list[INCOMING_REQUESTS][category].Copy(), \
		OUTGOING_REQUESTS = requests_list[OUTGOING_REQUESTS][category].Copy(), \
	) \
)

#define USER_DATA(user) ( \
	list(alist( \
		"username" = user.username, \
		"address" = user.address, \
		"visible" = user.visible_on_network, \
		"ref" = REF(user), \
	)) \
)

/datum/computer_file/program/communicator
	filename = "ntnrc_comm"
	filedesc = "Communicator"
	//program_icon_state = todo
	//program_key_icon_state = todo // Stationary communicators
	extended_desc = "todo"
	//size = todo
	requires_ntnet = TRUE
	requires_ntnet_feature = NTNET_COMMUNICATION
	program_type = PROGRAM_TYPE_ALL
	network_destination = "todo"
	//color = todo
	tgui_id = "Communicator"

	var/datum/ntnet_user/program_user

	// request values are all user addresses
	var/alist/requests = alist(
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

	var/ringtone = "beep"
	var/ringer_on = TRUE

/datum/computer_file/program/communicator/Destroy()
	service_deactivate()
	program_user = null // todo: qdel_null to avoid harddel? What about other devices talking to the user?
	return ..()

/datum/computer_file/program/communicator/event_registered()
	computer.registered_id.InitializeChatUser()
	program_user = computer.registered_id.chat_user

/datum/computer_file/program/communicator/event_unregistered()
	program_user = null

/datum/computer_file/program/communicator/ui_data(mob/user)
	var/alist/data = alist()

	data["callRequests"] = REQUESTS_DATA(requests, CALL_REQUESTS)
	data["videoRequests"] = REQUESTS_DATA(requests, VIDEO_REQUESTS)
	data["friendRequests"] = REQUESTS_DATA(requests, FRIEND_REQUESTS)

	return data

/datum/computer_file/program/communicator/ui_static_data(mob/user)
	var/alist/data = alist()

	var/list/friends = list()
	for(var/address, name in program_user.friends)
		friends += list(alist(
			"address" = address,
			"name" = name
		))

	var/list/ntnet_users = list()
	for(var/datum/ntnet_user/U as anything in GLOB.ntnet_global.users - program_user)
		ntnet_users += USER_DATA(U)

	data["friendsList"] = friends
	data["user"] = USER_DATA(program_user)
	data["allUsers"] = ntnet_users
	return data

/datum/computer_file/program/communicator/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("refresh_data")
			update_static_data(usr, ui)

#undef REQUESTS_DATA
#undef USER_DATA

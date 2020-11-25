/datum/ntnet
	var/list/chat_channels = list()
	var/list/chat_clients = list()
	var/list/chat_users = list()

/datum/ntnet/proc/begin_conversation(var/datum/computer_file/program/chat_client/Cl)

/datum/ntnet/proc/begin_direct(var/datum/computer_file/program/chat_client/Cl, var/datum/ntnet_user/target)
	if(!istype(Cl) || !istype(Cl.my_user) || !istype(target))
		return
	
	var/datum/ntnet_conversation/Conv = new()
	Conv.direct = TRUE
	Conv.users.Add(Cl.my_user)
	Conv.users.Add(target)

	target.dm_channels[Cl.my_user] = Conv
	Cl.my_user.dm_channels[target] = Conv
	
	var/datum/ntnet_message/direct/msg = new(Cl)
	Conv.process_message(msg)
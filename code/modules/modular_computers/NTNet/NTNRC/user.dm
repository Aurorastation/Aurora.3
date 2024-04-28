/datum/ntnet_user
	var/username
	var/list/channels = list()
	var/list/dm_channels = list()
	var/list/clients = list()

/datum/ntnet_user/New()
	. = ..()
	GLOB.ntnet_global.chat_users.Add(src)

/datum/ntnet_user/Destroy(force)
	. = ..()

	//This notifies every client that might have this as a client to deactivate and clear the reference
	for(var/datum/computer_file/program/chat_client/client as anything in GLOB.ntnet_global.chat_clients)
		client.handle_ntnet_user_deletion(src)

	GLOB.ntnet_global.chat_users.Remove(src)
	channels = null
	dm_channels = null
	clients = null

/datum/ntnet_user/proc/generateUsernameIdCard(var/obj/item/card/id/card)
	if(!card)
		return "Unknown"
	return "[card.registered_name], [card.assignment]"

/datum/ntnet_user/proc/generateUsernameSilicon(var/mob/living/silicon/silicon)
	return silicon.name

/datum/ntnet_user
	var/username
	var/address  //Resembles IPv6, but with only four 'groups', e.g. XXXX:XXXX:XXXX:XXXX
	// TODO: Remove this and use the network card address (or replace that with this address system)
	// temp notes: Keep addresses from exonet but have them ONLY used for manual dialing (to bypass `visible_on_network`)
	// Store user datum by ref where needed, or cleanup if deleted (signals?)
	// (address length changed to four groups from five for ease of typing)
	var/list/channels = list()
	var/list/dm_channels = list()
	var/list/clients = list()

	// {friend_address: friend_name}
	var/alist/friends = list()

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

/datum/ntnet_user/proc/generate_address(seed)
	var/new_address = null

/datum/ntnet_user
    var/username
    var/list/channels = list()
    var/list/dm_channels = list()
    var/list/clients = list()

/datum/ntnet_user/New()
    . = ..()
    ntnet_global.chat_users.Add(src)

/datum/ntnet_user/Destroy(force)
    . = ..()
    ntnet_global.chat_users.Remove(src)

/datum/ntnet_user/proc/generateUsernameIdCard(var/obj/item/card/id/card)
	if(!card)
		return "Unknown"
	return "[card.registered_name], [card.assignment]"

/datum/ntnet_user/proc/generateUsernameSilicon(var/mob/living/silicon/silicon)
	return silicon.name

//Somne code provided by skull.exe, butchered by BurgerBB/BurgerLua

var/list/emote_list = list()

/proc/populate_emotes()
	for(var/K in subtypesof(/datum/emote))
		var/datum/emote/V = new K()
		emote_list[V.id] = V

/proc/string_to_emote(var/emote_id)
	var/datum/emote/V = emote_list[emote_id]
	return V

/proc/emote_exists(var/emote_id)
	var/datum/emote/E = string_to_emote(emote_id)
	if(istype(E))
		return 1
	else
		return 0

/proc/send_emote(var/emote_id,var/atom/source,var/atom/target,var/untargeted_message,var/targeted_message)

	var/datum/emote/E = string_to_emote(emote_id)
	if(!istype(E) || !E.can_emote(source))
		return 0

	if(untargeted_message || targeted_message)
		E.do_emote(source,target,untargeted_message,targeted_message)
	else
		E.do_emote(source,target)
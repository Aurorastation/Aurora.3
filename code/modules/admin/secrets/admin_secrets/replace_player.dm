/datum/admin_secret_item/admin_secret/replace_player_with_ghost
	name = "Replace player with ghost"

/datum/admin_secret_item/admin_secret/replace_player_with_ghost/can_execute(var/mob/user)
	if(!ROUND_IS_STARTED) return 0
	return ..()

/datum/admin_secret_item/admin_secret/replace_player_with_ghost/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	var/list/targets = list()
	targets += getmobs()
	var/mob/T = input(user, "Which player do you want to replace?") as null|anything in targets
	if (!T)
		return
	var/mob/player_to_replace = targets[T]
	var/datum/ghosttrap/G = get_ghost_trap("[player_to_replace.mind.special_role]")
	if(player_to_replace.client)
		player_to_replace.ghostize(0)
	if(G)
		G.request_player(player_to_replace, "Would you like to play as a [player_to_replace.mind.special_role]?", 60 SECONDS)
	else
		G = ghost_traps["Special"]
		G.request_player(player_to_replace, "Would you like to play as [player_to_replace.name]?", 60 SECONDS)
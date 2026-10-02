/mob/abstract/new_player/LateLogin()
	..()

	update_Login_details()	//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying

	if(!mind)
		mind = new /datum/mind(key)
		mind.active = 1
		mind.current = src

	set_sight(BLIND)
	GLOB.player_list |= src

	client.playtitlemusic()
	addtimer(CALLBACK(src, PROC_REF(show_lobby_info)), 5 SECONDS, TIMER_STOPPABLE | TIMER_DELETE_ME)

/mob/abstract/new_player/proc/show_lobby_info()
	if(!client)
		return

	var/motd = SSregistry.getValue(REGISTRY_MESSAGE_OF_THE_DAY, GLOB.motd)
	if(motd)
		to_chat(src, "<div class=\"motd\">[motd]</div>")

	to_chat(src, "<div class='info'>Game ID: </div><div class='danger'>[GLOB.round_id]</div>")

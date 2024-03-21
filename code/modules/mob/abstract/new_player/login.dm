/mob/abstract/new_player
	var/client/my_client // Need to keep track of this ourselves, since by the time Logout() is called the client has already been nulled

/mob/abstract/new_player/LateLogin()
	..()

	update_Login_details()	//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying

	if(!mind)
		mind = new /datum/mind(key)
		mind.active = 1
		mind.current = src

	my_client = client
	set_sight(BLIND)
	GLOB.player_list |= src

	client.playtitlemusic()
	addtimer(CALLBACK(src, PROC_REF(show_lobby_info)), 5 SECONDS)

/mob/abstract/new_player/proc/show_lobby_info()
	if(!client)
		return

	if(GLOB.motd)
		to_chat(src, "<div class=\"motd\">[GLOB.motd]</div>")

	to_chat(src, "<div class='info'>Game ID: </div><div class='danger'>[GLOB.round_id]</div>")

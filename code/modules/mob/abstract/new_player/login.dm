/var/obj/effect/lobby_image

/obj/effect/lobby_image
	name = "Aurorastation"
	desc = "This shouldn't be read"
	icon = 'icons/misc/title.dmi'
	screen_loc = "WEST,SOUTH"

/obj/effect/lobby_image/New()
	..()
	if (current_map.lobby_icon)
		icon = current_map.lobby_icon
	var/list/known_icon_states = icon_states(icon)
	for(var/lobby_screen in current_map.lobby_screens)
		if(!(lobby_screen in known_icon_states))
			error("Lobby screen '[lobby_screen]' did not exist in the icon set [icon].")
			current_map.lobby_screens -= lobby_screen

	if(current_map.lobby_screens.len)
		icon_state = pick(current_map.lobby_screens)
	else
		icon_state = known_icon_states[1]

/mob/abstract/new_player
	var/client/my_client // Need to keep track of this ourselves, since by the time Logout() is called the client has already been nulled

/mob/abstract/new_player/Login()
	update_Login_details()	//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying

	src << "<div class='info'>Game ID: <div class='danger'>[game_id]</div></div>"

	if(!mind)
		mind = new /datum/mind(key)
		mind.active = 1
		mind.current = src

	loc = null
	show_title()
		
	my_client = client
	sight |= SEE_TURFS
	player_list |= src

	new_player_panel()
	spawn(40)
		if(client)
			client.playtitlemusic()

/mob/abstract/new_player/proc/show_title()
	set waitfor = FALSE
	if (lobby_image)
		client.screen += lobby_image
		return

	sleep(5)
	.()

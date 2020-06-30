//MENU SYSTEM BY BIGRAGE, some awful code, some awful design, all as you love //Code edits/additions by AshtonFox
/mob/abstract/new_player/instantiate_hud(datum/hud/HUD, ui_style, ui_color, ui_alpha)
	HUD.new_player_hud(ui_style, ui_color, ui_alpha)
	HUD.mymob = src

/datum/hud/new_player
	hud_shown = TRUE
	inventory_shown = FALSE
	hotkey_ui_hidden = FALSE

/datum/hud/proc/new_player_hud(var/ui_style='icons/mob/screen/white.dmi', var/ui_color = "#fffffe", var/ui_alpha = 255)
	adding = list()
	var/obj/screen/using

	using = new /obj/screen/new_player/title()
	using.name = "Title"
	adding += using

	using = new /obj/screen/new_player/selection/join_game(src)
	using.name = "Join Game"
	adding += using

	using = new /obj/screen/new_player/selection/settings()
	using.name = "Setup Character"
	adding += using

	using = new /obj/screen/new_player/selection/manifest()
	using.name = "Crew Manifest"
	adding += using

	using = new /obj/screen/new_player/selection/observe()
	using.name = "Observe"
	adding += using

	using = new /obj/screen/new_player/selection/changelog()
	using.name = "Changelog"
	adding += using

	using = new /obj/screen/new_player/selection/polls()
	using.name = "Polls"
	adding += using

	mymob.client.screen = list()
	mymob.client.screen += adding
	src.adding += using

/obj/screen/new_player
	icon = 'icons/misc/hudmenu.dmi'
	layer = HUD_LAYER

/obj/screen/new_player/title
	name = "Title"
	screen_loc = "WEST,SOUTH"
	var/lobby_index = 1

/obj/screen/new_player/title/Initialize()
	icon = current_map.lobby_icon
	var/list/known_icon_states = icon_states(icon)
	for(var/lobby_screen in current_map.lobby_screens)
		if(!(lobby_screen in known_icon_states))
			error("Lobby screen '[lobby_screen]' did not exist in the icon set [icon].")
			current_map.lobby_screens -= lobby_screen

	if(length(current_map.lobby_screens))
		if(current_map.lobby_transitions && isnum(current_map.lobby_transitions))
			icon_state = current_map.lobby_screens[lobby_index]
			if(Master.initializing)
				spawn(current_map.lobby_transitions)
					Update()
			else
				addtimer(CALLBACK(src, .proc/Update), current_map.lobby_transitions, TIMER_UNIQUE | TIMER_CLIENT_TIME | TIMER_OVERRIDE)
		else
			icon_state = pick(current_map.lobby_screens)
	else
		icon_state = LAZYACCESS(known_icon_states, 1)

	. = ..()

/obj/screen/new_player/title/proc/Update()
	lobby_index += 1
	if (lobby_index > length(current_map.lobby_screens))
		lobby_index = 1
	animate(src, alpha = 0, time = 1 SECOND)
	animate(alpha = 255, icon_state = current_map.lobby_screens[lobby_index], time = 1 SECOND)
	if(Master.initializing)
		spawn(current_map.lobby_transitions)
			Update()
	else
		addtimer(CALLBACK(src, .proc/Update), current_map.lobby_transitions, TIMER_UNIQUE | TIMER_CLIENT_TIME | TIMER_OVERRIDE)

/obj/screen/new_player/selection/join_game
	name = "Join Game"
	icon_state = "unready"
	screen_loc = "LEFT+1,CENTER"

/obj/screen/new_player/selection/settings
	name = "Setup"
	icon_state = "setup"
	screen_loc = "LEFT+1,CENTER-1"

/obj/screen/new_player/selection/manifest
	name = "Crew Manifest"
	icon_state = "manifest"
	screen_loc = "LEFT+1,CENTER-2"

/obj/screen/new_player/selection/observe
	name = "Observe"
	icon_state = "observe"
	screen_loc = "LEFT+1,CENTER-3"

/obj/screen/new_player/selection/changelog
	name = "Changelog"
	icon_state = "changelog"
	screen_loc = "LEFT+1,CENTER-4"

/obj/screen/new_player/selection/polls
	name = "Polls"
	icon_state = "polls"
	screen_loc = "LEFT+1,CENTER-5"

//SELECTION

/obj/screen/new_player/selection/New(var/desired_loc)
	color = null
	return ..()

/obj/screen/new_player/selection/MouseEntered(location,control,params) //Yellow color for the font
	color = "#ffb200"
	var/matrix/M = matrix()
	M.Scale(1.1, 1.1)
	animate(src, transform = M, time = 1, easing = CUBIC_EASING)
	return ..()

/obj/screen/new_player/selection/MouseExited(location,control,params)
	color = null
	animate(src, transform = null, time = 1, easing = CUBIC_EASING)
	return ..()

/obj/screen/new_player/selection/join_game/New(var/datum/hud/H)
	hud = H
	var/mob/abstract/new_player/player = hud.mymob
	update_icon(player)

/obj/screen/new_player/selection/join_game/Click()
	var/mob/abstract/new_player/player = usr
	sound_to(player, 'sound/effects/pop.ogg')
	if(SSticker.current_state <= GAME_STATE_SETTING_UP)
		if(player.ready)
			player.ready = FALSE
			player.ready(FALSE)
		else
			player.ready = TRUE
			player.ready(TRUE)
	else
		player.join_game()
	update_icon(player)

/obj/screen/new_player/selection/join_game/update_icon(var/mob/abstract/new_player/player)
	if(SSticker.current_state <= GAME_STATE_SETTING_UP)
		if(player.ready)
			icon_state = "ready"
		else
			icon_state = "unready"
	else
		icon_state = "joingame"

/obj/screen/new_player/selection/manifest/Click()
	var/mob/abstract/new_player/player = usr
	sound_to(player, 'sound/effects/pop.ogg')
	player.ViewManifest()

/obj/screen/new_player/selection/observe/Click()
	var/mob/abstract/new_player/player = usr
	sound_to(player, 'sound/effects/pop.ogg')
	player.new_player_observe()

/obj/screen/new_player/selection/settings/Click()
	var/mob/abstract/new_player/player = usr
	sound_to(player, 'sound/effects/pop.ogg')
	player.setupcharacter()

/obj/screen/new_player/selection/changelog/Click()
	var/mob/abstract/new_player/player = usr
	sound_to(player, 'sound/effects/pop.ogg')
	player.client.changes()

/obj/screen/new_player/selection/poll/Click()
	var/mob/abstract/new_player/player = usr
	sound_to(player, 'sound/effects/pop.ogg')
	player.handle_player_polling()

/mob/abstract/new_player/proc/setupcharacter()
	client.prefs.ShowChoices(src)
	return TRUE

/mob/abstract/new_player/proc/ready(var/readying = TRUE)
	if(SSticker.current_state <= GAME_STATE_PREGAME) // Make sure we don't ready up after the round has started
		// Cannot join without a saved character, if we're on SQL saves.
		if (config.sql_saves && !client.prefs.current_character)
			alert(src, "You have not saved your character yet. Please do so before readying up.")
			return
		if(client.unacked_warning_count > 0)
			alert(src, "You can not ready up, because you have unacknowledged warnings. Acknowledge your warnings in OOC->Warnings and Notifications.")
			return

		ready = readying
	else
		ready = FALSE

/mob/abstract/new_player/proc/join_game(href, href_list)
	if(SSticker.current_state <= GAME_STATE_SETTING_UP || SSticker.current_state >= GAME_STATE_FINISHED)
		to_chat(usr, "<span class='warning'>The round is either not ready, or has already finished...</span>")
		return
	LateChoices() //show the latejoin job selection menu

/mob/abstract/new_player/proc/new_player_observe()
	if(!SSATOMS_IS_PROBABLY_DONE)
		// Don't allow players to observe until initialization is more or less complete.
		// Letting them join too early breaks things, they can wait.
		alert(src, "Please wait, the map is not initialized yet.")
		return 0

	if(alert(src,"Are you sure you wish to observe? You will have to wait [config.respawn_delay] minutes before being able to respawn!","Player Setup","Yes","No") == "Yes")
		if(!client)
			return TRUE
		var/mob/abstract/observer/observer = new /mob/abstract/observer(src)
		spawning = 1
		sound_to(src, sound(null, repeat = 0, wait = 0, volume = 85, channel = 1))


		observer.started_as_observer = 1
		close_spawn_windows()
		var/obj/O = locate("landmark*Observer-Start")
		if(istype(O))
			to_chat(src, "<span class='notice'>Now teleporting.</span>")
			observer.forceMove(O.loc)
		else
			to_chat(src, "<span class='danger'>Could not locate an observer spawn point. Use the Teleport verb to jump to the station map.</span>")
		observer.timeofdeath = world.time // Set the time of death so that the respawn timer works correctly.

		announce_ghost_joinleave(src)
		var/mob/living/carbon/human/dummy/mannequin = SSmob.get_mannequin(client.ckey)
		client.prefs.dress_preview_mob(mannequin)
		observer.appearance = mannequin
		observer.alpha = 127
		observer.layer = initial(observer.layer)
		observer.invisibility = initial(observer.invisibility)
		observer.desc = initial(observer.desc)

		observer.real_name = client.prefs.real_name
		observer.name = observer.real_name
		if(!client.holder && !config.antag_hud_allowed)
			observer.verbs -= /mob/abstract/observer/verb/toggle_antagHUD
		observer.ckey = ckey
		observer.initialise_postkey()
		qdel(src)
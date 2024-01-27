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

	using = new /obj/screen/new_player/title(src)
	using.name = "Title"
	using.hud = src
	adding += using

	using = new /obj/screen/new_player/selection/join_game(src)
	using.name = "Join Game"
	using.hud = src
	adding += using

	using = new /obj/screen/new_player/selection/settings(src)
	using.name = "Setup Character"
	adding += using

	using = new /obj/screen/new_player/selection/manifest(src)
	using.name = "Crew Manifest"
	adding += using

	using = new /obj/screen/new_player/selection/observe(src)
	using.name = "Observe"
	adding += using

	using = new /obj/screen/new_player/selection/changelog(src)
	using.name = "Changelog"
	adding += using

	using = new /obj/screen/new_player/selection/polls(src)
	using.name = "Polls"
	adding += using

	using = new /obj/screen/new_player/selection/lore_summary(src)
	using.name = "Current Lore Summary"
	adding += using

	mymob.client.screen = list()
	mymob.client.screen += adding
	src.adding += using

/obj/screen/new_player
	icon = 'icons/misc/hudmenu/hudmenu.dmi'
	layer = HUD_LAYER

/obj/screen/new_player/Initialize()
	set_sector_things()
	. = ..()

/obj/screen/new_player/proc/set_sector_things()
	if(SSatlas.current_sector.sector_hud_menu)
		icon = SSatlas.current_sector.sector_hud_menu

/obj/screen/new_player/title
	name = "Title"
	screen_loc = "WEST,SOUTH"
	var/lobby_index = 1
	var/refresh_timer_id = null

/obj/screen/new_player/title/Destroy(force)
	if(refresh_timer_id)
		deltimer(refresh_timer_id)
		refresh_timer_id = null
	. = ..()


/obj/screen/new_player/title/Initialize()
	if(SSatlas.current_sector.sector_lobby_art)
		current_map.lobby_icon = pick(SSatlas.current_sector.sector_lobby_art)
	else if(!current_map.lobby_icon)
		current_map.lobby_icon = pick(current_map.lobby_icons)

	if(!length(current_map.lobby_screens))
		var/list/known_icon_states = icon_states(current_map.lobby_icon)
		for(var/screen in known_icon_states)
			if(!(screen in current_map.lobby_screens))
				current_map.lobby_screens += screen
	icon = current_map.lobby_icon

	if(length(current_map.lobby_screens))
		if(current_map.lobby_transitions && isnum(current_map.lobby_transitions))
			icon_state = current_map.lobby_screens[lobby_index]
			if(!MC_RUNNING())
				spawn(current_map.lobby_transitions)
					Update()
			else
				refresh_timer_id = addtimer(CALLBACK(src, PROC_REF(Update)), current_map.lobby_transitions, TIMER_UNIQUE | TIMER_CLIENT_TIME | TIMER_OVERRIDE | TIMER_STOPPABLE)
		else
			icon_state = pick(current_map.lobby_screens)
	else //This should basically never happen.
		crash_with("No lobby screens found!")

	. = ..()

/obj/screen/new_player/title/set_sector_things()
	return

/obj/screen/new_player/title/proc/Update()
	if(QDELING(src))
		return

	if(!current_map.lobby_transitions && SSatlas.current_sector.sector_lobby_transitions)
		return
	if(!istype(hud) || !isnewplayer(hud.mymob))
		return
	lobby_index += 1
	if (lobby_index > length(current_map.lobby_screens))
		lobby_index = 1
	animate(src, alpha = 0, time = 1 SECOND)
	animate(alpha = 255, icon_state = current_map.lobby_screens[lobby_index], time = 1 SECOND)
	if(!MC_RUNNING())
		spawn(current_map.lobby_transitions)
			Update()
	else
		refresh_timer_id = addtimer(CALLBACK(src, PROC_REF(Update)), current_map.lobby_transitions, TIMER_UNIQUE | TIMER_CLIENT_TIME | TIMER_OVERRIDE | TIMER_STOPPABLE)

/obj/screen/new_player/selection
	var/click_sound = 'sound/effects/menu_click.ogg'
	var/hud_arrow

/obj/screen/new_player/selection/New(var/datum/hud/H)
	color = null
	hud = H
	..()

/obj/screen/new_player/selection/Initialize()
	. = ..()
	set_sector_things()

/obj/screen/new_player/selection/set_sector_things()
	. = ..()
	if(SSatlas.current_sector.sector_hud_menu_sound)
		click_sound = SSatlas.current_sector.sector_hud_menu_sound
	if(SSatlas.current_sector.sector_hud_arrow)
		hud_arrow = SSatlas.current_sector.sector_hud_arrow
		// We'll reset the animation just so it doesn't get stuck
		animate(src, color = null, transform = null, time = 3, easing = CUBIC_EASING)

/obj/screen/new_player/selection/MouseEntered(location, control, params)
	if(hud_arrow)
		add_overlay(hud_arrow, force_compile = TRUE)
	else
		var/matrix/M = matrix()
		M.Scale(1.1, 1)
		animate(src, color = color_rotation(30), transform = M, time = 3, easing = CUBIC_EASING)
	return ..()

/obj/screen/new_player/selection/MouseExited(location,control,params)
	if(hud_arrow)
		cut_overlays(force_compile = TRUE)
	else
		animate(src, color = null, transform = null, time = 3, easing = CUBIC_EASING)
	return ..()

/obj/screen/new_player/selection/join_game
	name = "Join Game"
	icon_state = "unready"
	screen_loc = "LEFT+0.1,CENTER-1"

/obj/screen/new_player/selection/settings
	name = "Setup"
	icon_state = "setup"
	screen_loc = "LEFT+0.1,CENTER-2"

/obj/screen/new_player/selection/manifest
	name = "Crew Manifest"
	icon_state = "manifest"
	screen_loc = "LEFT+0.1,CENTER-3"

/obj/screen/new_player/selection/observe
	name = "Observe"
	icon_state = "observe"
	screen_loc = "LEFT+0.1,CENTER-4"

/obj/screen/new_player/selection/changelog
	name = "Changelog"
	icon_state = "changelog"
	screen_loc = "LEFT+0.1,CENTER-5"

/obj/screen/new_player/selection/polls
	name = "Polls"
	icon_state = "polls"
	screen_loc = "LEFT+0.1,CENTER-6"

/obj/screen/new_player/selection/lore_summary
	name = "Current Lore Summary"
	icon_state = "lore_summary"
	screen_loc = "LEFT+0.1,CENTER-7"

/obj/screen/new_player/selection/join_game/Initialize()
	. = ..()
	var/mob/abstract/new_player/player = hud.mymob
	update_icon(player)

/obj/screen/new_player/selection/join_game/Click()
	var/mob/abstract/new_player/player = usr
	sound_to(player, click_sound)
	if(SSticker.current_state <= GAME_STATE_SETTING_UP)
		if(player.ready)
			player.ready(FALSE)
		else
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
	sound_to(player, click_sound)
	if(SSticker.current_state < GAME_STATE_PLAYING)
		to_chat(player, SPAN_WARNING("The game hasn't started yet!"))
		return
	player.ViewManifest()

/obj/screen/new_player/selection/observe/Click()
	var/mob/abstract/new_player/player = usr
	sound_to(player, click_sound)
	player.new_player_observe()

/obj/screen/new_player/selection/settings/Click()
	var/mob/abstract/new_player/player = usr
	sound_to(player, click_sound)
	player.setupcharacter()

/obj/screen/new_player/selection/changelog/Click()
	var/mob/abstract/new_player/player = usr
	sound_to(player, click_sound)
	player.client.changes()

/obj/screen/new_player/selection/polls/Initialize()
	. = ..()
	if(establish_db_connection(GLOB.dbcon))
		var/mob/M = hud.mymob
		var/isadmin = M && M.client && M.client.holder
		var/DBQuery/query = GLOB.dbcon.NewQuery("SELECT id FROM ss13_poll_question WHERE [(isadmin ? "" : "adminonly = false AND")] Now() BETWEEN starttime AND endtime AND id NOT IN (SELECT pollid FROM ss13_poll_vote WHERE ckey = \"[M.ckey]\") AND id NOT IN (SELECT pollid FROM ss13_poll_textreply WHERE ckey = \"[M.ckey]\")")
		query.Execute()
		var/newpoll = query.NextRow()

		if(newpoll)
			icon_state = "polls_new"

/obj/screen/new_player/selection/polls/Click()
	var/mob/abstract/new_player/player = usr
	sound_to(player, click_sound)
	player.handle_player_polling()

/obj/screen/new_player/selection/lore_summary/Click()
	var/mob/abstract/new_player/player = usr
	sound_to(player, click_sound)
	player.show_lore_summary()

/mob/abstract/new_player/proc/setupcharacter()
	client.prefs.ShowChoices(src)
	return TRUE

/mob/abstract/new_player/proc/ready(var/readying = TRUE)
	if(SSticker.current_state <= GAME_STATE_PREGAME) // Make sure we don't ready up after the round has started
		// Cannot join without a saved character, if we're on SQL saves.
		if (GLOB.config.sql_saves && !client.prefs.current_character)
			alert(src, "You have not saved your character yet. Please do so before readying up.")
			return
		if(client.unacked_warning_count > 0)
			alert(src, "You can not ready up, because you have unacknowledged warnings or notifications. Acknowledge them in OOC->Warnings and Notifications.")
			return

		ready = readying
		if(ready)
			last_ready_name = client.prefs.real_name
		SSticker.update_ready_list(src)
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

	if(!client)
		return TRUE
	// Only display the warning if it's a /new/ new player,
	// if they've died and gone back to menu they probably already know their respawn time (and it won't be reset anymore)
	if(!get_death_time(CREW))
		if(alert(src, "Are you sure you wish to observe? You will have to wait [GLOB.config.respawn_delay] minutes before being able to respawn.", "Player Setup", "Yes", "No") != "Yes")
			return FALSE

	var/mob/abstract/observer/observer = new /mob/abstract/observer(src)
	spawning = 1
	sound_to(src, sound(null, repeat = 0, wait = 0, volume = 85, channel = 1))

	observer.started_as_observer = 1
	close_spawn_windows()
	var/obj/O = locate("landmark*Observer-Start") in GLOB.landmarks_list
	if(istype(O))
		to_chat(src, "<span class='notice'>Now teleporting.</span>")
		observer.forceMove(O.loc)
	else
		to_chat(src, "<span class='danger'>Could not locate an observer spawn point. Use the Teleport verb to jump to the station map.</span>")
	observer.timeofdeath = world.time // Set the time of death so that the respawn timer works correctly.

	announce_ghost_joinleave(src)
	var/mob/living/carbon/human/dummy/mannequin/mannequin = new
	client.prefs.dress_preview_mob(mannequin)
	observer.appearance = mannequin.appearance
	observer.appearance_flags = KEEP_TOGETHER
	observer.alpha = 127
	observer.layer = initial(observer.layer)
	observer.set_invisibility(initial(observer.invisibility))
	observer.desc = initial(observer.desc)

	observer.real_name = client.prefs.real_name
	observer.name = observer.real_name
	if(!client.holder && !GLOB.config.antag_hud_allowed)
		remove_verb(observer, /mob/abstract/observer/verb/toggle_antagHUD)
	observer.ckey = ckey
	observer.initialise_postkey()
	observer.client.init_verbs()
	qdel(src)

/mob/abstract/new_player/proc/show_lore_summary()
	if(GLOB.config.lore_summary)
		var/output = "<div align='center'><hr1><B>Welcome to the [station_name()]!</B></hr1><br>"
		output += "<i>[GLOB.config.lore_summary]</i><hr>"
		to_chat(src, output)

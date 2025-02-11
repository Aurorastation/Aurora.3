//MENU SYSTEM BY BIGRAGE, some awful code, some awful design, all as you love //Code edits/additions by AshtonFox
/mob/abstract/new_player/instantiate_hud(datum/hud/HUD, ui_style, ui_color, ui_alpha)
	HUD.mymob = src
	HUD.new_player_hud(ui_style, ui_color, ui_alpha)

/datum/hud/new_player
	hud_shown = TRUE
	inventory_shown = FALSE
	hotkey_ui_hidden = FALSE

/datum/hud/proc/new_player_hud(var/ui_style='icons/mob/screen/white.dmi', var/ui_color = "#fffffe", var/ui_alpha = 255)
	SHOULD_NOT_SLEEP(TRUE)

	adding = list()
	var/atom/movable/screen/using

	using = new /atom/movable/screen/new_player/title(src)
	using.name = "Title"
	using.hud = src
	adding += using

	using = new /atom/movable/screen/new_player/selection/join_game(src)
	using.name = "Join Game"
	using.hud = src
	adding += using

	using = new /atom/movable/screen/new_player/selection/settings(src)
	using.name = "Setup Character"
	adding += using

	using = new /atom/movable/screen/new_player/selection/manifest(src)
	using.name = "Crew Manifest"
	adding += using

	using = new /atom/movable/screen/new_player/selection/observe(src)
	using.name = "Observe"
	adding += using

	using = new /atom/movable/screen/new_player/selection/changelog(src)
	using.name = "Changelog"
	adding += using

	using = new /atom/movable/screen/new_player/selection/polls(src)
	using.name = "Polls"
	adding += using

	using = new /atom/movable/screen/new_player/selection/lore_summary(src)
	using.name = "Current Lore Summary"
	adding += using

	using = new /atom/movable/screen/new_player/selection/server_logo(src)
	using.name = "Aurora"
	adding += using

	mymob.client.screen = list()
	mymob.client.screen += adding
	src.adding += using

ABSTRACT_TYPE(/atom/movable/screen/new_player)
	icon = null
	icon_state = null
	layer = HUD_BASE_LAYER


/**
 * # Title screen
 *
 * Basically the background of the lobby
 *
 */
/atom/movable/screen/new_player/title
	name = "Title"
	screen_loc = "WEST,SOUTH"
	layer = UNDER_HUD_LAYER

	///An index used to rotate along the lobby icons
	var/lobby_icons_index = 1


/atom/movable/screen/new_player/title/Initialize()
	. = ..()

	setup_icon() //THIS CAN SLEEP AND MUST NOT BE WAITED FOR

/**
 * Sets up the icon for the title screen, wait until SSAtlas made them for us then setup the update cycle after picking one
 */
/atom/movable/screen/new_player/title/proc/setup_icon()
	set waitfor = FALSE
	UNTIL((SSatlas.lobby_icons))

	icon = pick(SSatlas.lobby_icons)

	addtimer(CALLBACK(src, PROC_REF(update_icon)), SSatlas.current_map.lobby_transitions, TIMER_UNIQUE | TIMER_OVERRIDE)

/atom/movable/screen/new_player/title/update_icon()
	..()

	if(QDELETED(src))
		return

	if(!istype(hud) || !isnewplayer(hud.mymob))
		return

	//No point fading if there's only one icon, but we keep the update running in case admins want to add icons on the fly
	if(length(SSatlas.lobby_icons) >= 2)
		//Advance to the next icon
		lobby_icons_index = max(++lobby_icons_index % length(SSatlas.lobby_icons), 1)

		animate(src, alpha = 0, time = 1 SECOND)

		animate(alpha = 255, icon = SSatlas.lobby_icons[lobby_icons_index], time = 1 SECOND)

	addtimer(CALLBACK(src, PROC_REF(update_icon)), SSatlas.current_map.lobby_transitions, TIMER_UNIQUE | TIMER_OVERRIDE)


/**
 * # Selection screen
 *
 * Lobby clickable buttons
 */
ABSTRACT_TYPE(/atom/movable/screen/new_player/selection)
	icon_state = null
	mouse_opacity = MOUSE_OPACITY_OPAQUE
	var/click_sound = 'sound/effects/menu_click.ogg'
	var/does_matrix_scale = TRUE
	var/uses_hud_arrow = TRUE

/atom/movable/screen/new_player/selection/New(datum/hud/H)
	color = null
	hud = H
	..()

/atom/movable/screen/new_player/selection/Destroy(force)
	hud = null
	. = ..()

/atom/movable/screen/new_player/selection/update_icon()
	. = ..()
	var/icon_path = "[SSatlas.current_sector.sector_hud_menu][get_button_icon_filename()].png"
	icon = icon(icon_path)

/**
 * Returns the filename of the icon to use for the button, at every refresh
 */
/atom/movable/screen/new_player/selection/proc/get_button_icon_filename()
	SHOULD_NOT_SLEEP(TRUE)

	var/regex/regex_screen_name = new(@'.*\/(.*)$')
	if(!regex_screen_name.Find("[type]"))
		CRASH("Something went terribly wrong with extracting the button icon filename with the regex!")

	return regex_screen_name.group[1]


/atom/movable/screen/new_player/selection/Initialize()
	. = ..()
	update_icon()
	if(SSatlas.current_sector)
		if(SSatlas.current_sector.sector_hud_menu_sound)
			click_sound = SSatlas.current_sector.sector_hud_menu_sound
		if(SSatlas.current_sector.sector_hud_arrow)
			// We'll reset the animation just so it doesn't get stuck
			animate(src, color = null, transform = null, time = 3, easing = CUBIC_EASING)

	animate(src, alpha = 255, time = 3, easing = CUBIC_EASING, loop = 3)
	animate(alpha = 60, time = 3, easing = CUBIC_EASING, loop = 3, flags = ANIMATION_CONTINUE)

/atom/movable/screen/new_player/selection/MouseEntered(location, control, params)
	if(SSatlas.current_sector?.sector_hud_arrow && uses_hud_arrow)
		AddOverlays(SSatlas.current_sector.sector_hud_arrow)
	var/matrix/M = matrix()
	if(does_matrix_scale)
		M.Scale(1.1, 1)
		M.Translate(40, 0)
	animate(src, color = null, transform = M, time = 3, easing = CUBIC_EASING)
	animate(src, alpha = 255, time = 3, easing = CUBIC_EASING)
	return ..()

/atom/movable/screen/new_player/selection/MouseExited(location, control, params)
	if(SSatlas.current_sector?.sector_hud_arrow && uses_hud_arrow)
		ClearOverlays()
	animate(src, color = null, transform = null, time = 3, easing = CUBIC_EASING)
	animate(src, alpha = 60, time = 3, easing = CUBIC_EASING)
	return ..()


/**
 * # Join Game
 *
 * Button to join the game
 */
/atom/movable/screen/new_player/selection/join_game
	name = "Join Game"
	screen_loc = "LEFT+0.5,CENTER+17"

/atom/movable/screen/new_player/selection/join_game/Click(location, control, params)
	var/mob/abstract/new_player/player = hud.mymob
	if(SSticker.prevent_unready && player.ready)
		tgui_alert(player, "You may not unready during Odyssey setup!", "Odyssey")
		return


	if(SSticker.current_state <= GAME_STATE_SETTING_UP)
		if(player.ready)
			sound_to(player, 'sound/weapons/laser_safetyoff.ogg')
			player.ready(FALSE)
		else
			sound_to(player, 'sound/weapons/laser_safetyon.ogg')
			player.ready(TRUE)
	else
		sound_to(player, click_sound)
		player.join_game()
	update_icon()

/atom/movable/screen/new_player/selection/join_game/get_button_icon_filename()
	. = ..()
	var/mob/abstract/new_player/player = hud.mymob
	if(SSticker.current_state <= GAME_STATE_SETTING_UP)
		if(player.ready)
			. += "_ready"
		else
			. += "_unready"

/mob/abstract/new_player/proc/ready(readying = TRUE)
	if(SSticker.current_state <= GAME_STATE_PREGAME) // Make sure we don't ready up after the round has started
		// Cannot join without a saved character, if we're on SQL saves.
		if (GLOB.config.sql_saves && !client.prefs.current_character)
			tgui_alert(src, "You have not saved your character yet. Please do so before readying up.", "Character not saved", list("Ok"))
			return
		if(client.unacked_warning_count > 0)
			tgui_alert(src, "You can not ready up, because you have unacknowledged warnings or notifications. Acknowledge them in OOC->Warnings and Notifications.", "Warnings not acknowledged", list("Ok"))
			return

		if(SSticker.prevent_unready && !readying)
			tgui_alert(src, "You may not unready during Odyssey setup!", "Odyssey")
			return

		ready = readying
		if(ready)
			last_ready_name = client.prefs.real_name
		SSticker.update_ready_list(src)
	else if(!SSticker.prevent_unready)
		ready = FALSE

/mob/abstract/new_player/proc/join_game(href, href_list)
	if(SSticker.current_state <= GAME_STATE_SETTING_UP || SSticker.current_state >= GAME_STATE_FINISHED)
		to_chat(usr, SPAN_WARNING("The round is either not ready, or has already finished..."))
		return
	LateChoices() //show the latejoin job selection menu


/**
 * # Manifest
 *
 * Button to view the crew manifest
 */
/atom/movable/screen/new_player/selection/manifest
	name = "Crew Manifest"
	screen_loc = "LEFT+0.5,CENTER+13"

/atom/movable/screen/new_player/selection/manifest/Click()
	var/mob/abstract/new_player/player = usr
	sound_to(player, click_sound)
	if(SSticker.current_state < GAME_STATE_PLAYING)
		to_chat(player, SPAN_WARNING("The game hasn't started yet!"))
		return
	player.ViewManifest()


/**
 * # Observe
 *
 * Button to join as observer
 */
/atom/movable/screen/new_player/selection/observe
	name = "Observe"
	screen_loc = "LEFT+0.5,CENTER+9"

/atom/movable/screen/new_player/selection/observe/Click()
	var/mob/abstract/new_player/player = usr
	sound_to(player, click_sound)
	player.new_player_observe()

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

	var/mob/abstract/ghost/observer/observer = new /mob/abstract/ghost/observer(null, src)
	spawning = 1
	src.stop_sound_channel(CHANNEL_LOBBYMUSIC) // stop the jams for observers

	observer.started_as_observer = 1
	close_spawn_windows()
	var/obj/O = locate("landmark*Observer-Start") in GLOB.landmarks_list
	if(istype(O))
		to_chat(src, SPAN_NOTICE("Now teleporting."))
		observer.forceMove(O.loc)
	else
		to_chat(src, SPAN_DANGER("Could not locate an observer spawn point. Use the Teleport verb to jump to the station map."))
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
		remove_verb(observer, /mob/abstract/ghost/observer/verb/toggle_antagHUD)
	observer.ckey = ckey
	observer.initialise_postkey()
	observer.client.init_verbs()
	qdel(src)


/**
 * # Settings
 *
 * Button to change character settings
 */
/atom/movable/screen/new_player/selection/settings
	name = "Setup"
	screen_loc = "LEFT+0.5,CENTER+5"

/atom/movable/screen/new_player/selection/settings/Click()
	var/mob/abstract/new_player/player = usr
	sound_to(player, click_sound)
	player.setupcharacter()

/atom/movable/screen/new_player/selection/changelog/Click()
	var/mob/abstract/new_player/player = usr
	sound_to(player, click_sound)
	player.client.changes()

/mob/abstract/new_player/proc/setupcharacter()
	client.prefs.ShowChoices(src)
	return TRUE


/**
 * # Changelog
 *
 * Button to view the changelog
 */
/atom/movable/screen/new_player/selection/changelog
	name = "Changelog"
	screen_loc = "LEFT+0.5,CENTER+1"


/**
 * # Polls
 *
 * Button to view the polls
 */
/atom/movable/screen/new_player/selection/polls
	name = "Polls"
	screen_loc = "LEFT+0.5,CENTER-3"
	var/new_polls = FALSE

/atom/movable/screen/new_player/selection/polls/Initialize()
	. = ..()
	if(establish_db_connection(GLOB.dbcon))
		var/mob/M = hud.mymob
		var/isadmin = M && M.client && M.client.holder
		var/DBQuery/query = GLOB.dbcon.NewQuery("SELECT id FROM ss13_poll_question WHERE [(isadmin ? "" : "adminonly = false AND")] Now() BETWEEN starttime AND endtime AND id NOT IN (SELECT pollid FROM ss13_poll_vote WHERE ckey = \"[M.ckey]\") AND id NOT IN (SELECT pollid FROM ss13_poll_textreply WHERE ckey = \"[M.ckey]\")")
		query.Execute()
		var/newpoll = query.NextRow()

		if(newpoll)
			new_polls = TRUE

/atom/movable/screen/new_player/selection/polls/get_button_icon_filename()
	. = ..()
	if(new_polls)
		. += "_new"

/atom/movable/screen/new_player/selection/polls/Click()
	var/mob/abstract/new_player/player = usr
	sound_to(player, click_sound)
	player.handle_player_polling()


/**
 * # Lore Summary
 *
 * Button to view the current lore summary
 */
/atom/movable/screen/new_player/selection/lore_summary
	name = "Current Lore Summary"
	screen_loc = "LEFT+0.5,CENTER-7"

/atom/movable/screen/new_player/selection/lore_summary/Click()
	var/mob/abstract/new_player/player = usr
	sound_to(player, click_sound)
	player.show_lore_summary()

/mob/abstract/new_player/proc/show_lore_summary()
	if(GLOB.config.lore_summary)
		var/output = "<div align='center'><hr1><B>Welcome to the [station_name()]!</B></hr1><br>"
		output += "<i>[GLOB.config.lore_summary]</i><hr>"
		to_chat(src, output)

/**
 * # Title
 *
 * Button to view the Aurora website
 */
/atom/movable/screen/new_player/selection/server_logo
	name = "Aurora"
	screen_loc = "LEFT+0.5,CENTER+42"
	uses_hud_arrow = FALSE
	does_matrix_scale = FALSE

/atom/movable/screen/new_player/selection/server_logo/Click()
	var/mob/abstract/new_player/player = usr
	sound_to(player, click_sound)
	if (GLOB.config.mainsiteurl)
		if(tgui_alert(player, "This will open the Aurora website in your browser. Are you sure?", "Aurora", list("Yes", "No")) == "No")
			return
		send_link(player, GLOB.config.mainsiteurl)
	else
		to_chat(player, SPAN_WARNING("The Aurora website URL is not set in the server configuration."))
	return

/client/var/datum/escape_menu/escape_menu

/client/proc/initialize_escape_menu()
	set waitfor = FALSE
	sleep(3 SECONDS)
	if(QDELETED(src))
		return
	escape_menu = new(src)

/datum/escape_menu
	var/client/client
	var/datum/tgui_window/window
	var/version_warned = FALSE
	var/was_lobby = FALSE

/datum/escape_menu/New(client/client)
	src.client = client
	window = new(client, "escape_menu")
	window.is_browser = TRUE
	window.subscribe(src, PROC_REF(on_message))
	window.initialize(
		strict_mode = TRUE,
		inline_css = file("tgui/public/tgui-escape-menu.bundle.css"),
		inline_js = file("tgui/public/tgui-escape-menu.bundle.js"),
	)
	window.send_asset(get_asset_datum(/datum/asset/simple/namespaced/escape_menu_font))
	window.send_asset(get_asset_datum(/datum/asset/simple/namespaced/escape_menu_sounds))
	window.send_asset(get_asset_datum(/datum/asset/spritesheet/escape_menu_icons))
	window.send_asset(get_asset_datum(/datum/asset/spritesheet/lobby_menu_icons))
	window.send_asset(get_asset_datum(/datum/asset/spritesheet/lobby_backgrounds))
	send_init()

/datum/escape_menu/Destroy(force)
	STOP_PROCESSING(SSescape_menu, src)
	window?.unsubscribe(src)
	window = null
	client = null
	return ..()

/datum/escape_menu/process(seconds_per_tick)
	if(QDELETED(client))
		return PROCESS_KILL
	var/is_lobby = isnewplayer(client.mob)
	if(was_lobby && !is_lobby)
		was_lobby = FALSE
		hide_menu()
		return PROCESS_KILL
	if(!was_lobby && is_lobby)
		show_lobby_menu()
	send_update(build_state())

/datum/escape_menu/proc/build_state()
	var/mob/abstract/new_player/player = client?.mob
	var/is_lobby = istype(player)
	var/datum/asset/spritesheet/lobby_menu_icons/lobby_icons = get_asset_datum(/datum/asset/spritesheet/lobby_menu_icons)
	var/datum/asset/spritesheet/lobby_backgrounds/lobby_backgrounds = get_asset_datum(/datum/asset/spritesheet/lobby_backgrounds)
	var/join_icon_state = SSticker.current_state <= GAME_STATE_SETTING_UP ? ((is_lobby && player.ready) ? "ready" : "unready") : "joingame"
	var/list/lobby_background_classes = list()
	var/list/lobby_screens = SSatlas?.current_map?.lobby_screens
	if(!LAZYLEN(lobby_screens))
		lobby_screens = icon_states(SSatlas?.current_map?.lobby_icon || 'icons/misc/titlescreens/title.dmi')
	for(var/screen in lobby_screens)
		var/background_class = lobby_backgrounds.icon_tag(screen, FALSE)
		if(background_class)
			lobby_background_classes += background_class
	return list(
		"stationName" = SSatlas?.current_map ? station_name() : "Loading...",
		"roundId" = GLOB.round_id || "Unset",
		"serverTime" = time_stamp(),
		"shiftTime" = round_start_time ? get_round_duration_formatted() : "Pre-Game",
		"timeDilation" = "[round(SStime_track.time_dilation_current, 1)]",
		"mapName" = SSatlas?.current_map?.name || "Loading...",
		"canLeaveBody" = isliving(client?.mob),
		"canAdminHelp" = (/client/verb/adminhelp in client?.verbs),
		"isLobby" = is_lobby,
		"isReady" = is_lobby && player.ready,
		"joinLabel" = SSticker.current_state <= GAME_STATE_SETTING_UP ? ((is_lobby && player.ready) ? "Unready" : "Ready") : "Join Game",
		"canJoin" = is_lobby && SSticker.current_state < GAME_STATE_FINISHED,
		"canManifest" = is_lobby && SSticker.current_state >= GAME_STATE_PLAYING,
		"lobbyBackgrounds" = lobby_background_classes,
		"lobbyTransitionMs" = isnum(SSatlas?.current_map?.lobby_transitions) ? SSatlas.current_map.lobby_transitions * 100 : 0,
		"lobbyMenuSound" = SSatlas?.current_sector?.sector_hud_menu_sound ? "menu_click_heavy.ogg" : "menu_click.ogg",
		"lobbyButtonIcons" = list(
			"join" = lobby_icons.icon_tag(join_icon_state, FALSE),
			"character" = lobby_icons.icon_tag("setup", FALSE),
			"manifest" = lobby_icons.icon_tag("manifest", FALSE),
			"observe" = lobby_icons.icon_tag("observe", FALSE),
			"changelog" = lobby_icons.icon_tag("changelog", FALSE),
			"polls" = lobby_icons.icon_tag("polls", FALSE),
			"lore" = lobby_icons.icon_tag("lore_summary", FALSE),
		),
		"admins" = build_admin_list(),
		"players" = build_player_list(),
	)

/datum/escape_menu/proc/build_resources()
	var/list/resources = list()
	if(GLOB.config.forumurl)
		resources += list(list("id" = "forums", "label" = "Forums", "tooltip" = "Visit the Aurora forums"))
	if(GLOB.config.rulesurl)
		resources += list(list("id" = "rules", "label" = "Rules", "tooltip" = "Read the server rules"))
	if(GLOB.config.wikiurl)
		resources += list(list("id" = "wiki", "label" = "Wiki", "tooltip" = "Visit the Aurora wiki"))
	if(GLOB.config.githuburl)
		resources += list(list("id" = "github", "label" = "GitHub", "tooltip" = "Open the game repository"))
		resources += list(list("id" = "bug", "label" = "Report Bug", "tooltip" = "Report a bug or issue"))
	if(GLOB.config.webint_url)
		resources += list(list("id" = "config", "label" = "Web Interface", "tooltip" = "Open the Aurora web interface"))
	resources += list(list("id" = "changelog", "label" = "Change Log", "tooltip" = "See recent game changes"))
	return resources

/datum/escape_menu/proc/build_admin_list()
	var/list/result = list()
	for(var/client/admin as anything in GLOB.staff)
		if(!admin?.holder)
			continue
		result += list(list(
			"ckey" = admin.ckey,
			"displayName" = admin.holder.fakekey || admin.key,
			"rank" = admin.holder.rank,
			"ping" = round(admin.avgping, 1),
		))
	return result

/datum/escape_menu/proc/build_player_list()
	var/list/result = list()
	for(var/client/player as anything in GLOB.clients - GLOB.staff)
		result += list(list(
			"ckey" = player.ckey,
			"displayName" = player.key,
			"ping" = round(player.avgping, 1),
		))
	return result

/datum/escape_menu/proc/send_init()
	var/list/state = build_state()
	state["resources"] = build_resources()
	window.send_message("init", state)

/datum/escape_menu/proc/send_update(list/data)
	window.send_message("state", data)

/datum/escape_menu/proc/show_lobby_menu()
	if(!client || !isnewplayer(client.mob))
		return
	was_lobby = TRUE
	winset(client, "mapwindow.escape_menu", "is-visible=true")
	window.send_message("open", list("silent" = TRUE))
	START_PROCESSING(SSescape_menu, src)

/datum/escape_menu/proc/hide_menu()
	window.send_message("close", list("silent" = TRUE))
	winset(client, "mapwindow.escape_menu", "is-visible=false")

/datum/escape_menu/proc/on_message(type, payload, href_list)
	if(type == "ready")
		send_init()
		if(isnewplayer(client?.mob))
			show_lobby_menu()
		return TRUE
	if(type != "action")
		return FALSE

	var/action = payload["action"]
	switch(action)
		if("opened")
			if(!version_warned && client.byond_build < 1680)
				to_chat(client, SPAN_WARNING("Your BYOND version cannot render the escape menu correctly. Please update to BYOND 516.1680 or newer."))
				version_warned = TRUE
			START_PROCESSING(SSescape_menu, src)
		if("closed")
			if(isnewplayer(client?.mob))
				show_lobby_menu()
				return TRUE
			STOP_PROCESSING(SSescape_menu, src)
		if("toggle_request")
			if(isnewplayer(client?.mob))
				show_lobby_menu()
				return TRUE
			hide_menu()
			STOP_PROCESSING(SSescape_menu, src)
		if("lobby_join")
			var/mob/abstract/new_player/player = client?.mob
			if(!istype(player))
				return TRUE
			if(SSticker.current_state <= GAME_STATE_SETTING_UP)
				player.ready(!player.ready)
			else
				player.join_game()
			send_update(build_state())
		if("lobby_manifest")
			var/mob/abstract/new_player/player = client?.mob
			if(istype(player) && SSticker.current_state >= GAME_STATE_PLAYING)
				player.ViewManifest()
		if("lobby_observe")
			var/mob/abstract/new_player/player = client?.mob
			player?.new_player_observe()
		if("lobby_polls")
			var/mob/abstract/new_player/player = client?.mob
			player?.handle_player_polling()
		if("lobby_lore")
			var/mob/abstract/new_player/player = client?.mob
			player?.show_lore_summary()
		if("character")
			client?.prefs?.ShowChoices(client.mob)
		if("create_ticket")
			if(!(/client/verb/adminhelp in client?.verbs))
				return TRUE
			var/message = tgui_input_text(client.mob, "Please describe the issue you need staff assistance with.", "Adminhelp", multiline = TRUE, encode = FALSE)
			if(message)
				client.adminhelp(message)
		if("staffwho")
			client?.staffwho()
		if("pray")
			var/prayer = tgui_input_text(client.mob, "What would you like to pray?", "Pray", multiline = TRUE, encode = FALSE)
			if(prayer)
				client.mob?.pray(prayer)
		if("ghost")
			var/mob/living/living_user = client?.mob
			living_user?.ghost()
		if("quit")
			winset(client, null, list("command" = ".quit"))
		if("resource_forums")
			send_link(client, GLOB.config.forumurl)
		if("resource_rules")
			send_link(client, GLOB.config.rulesurl)
		if("resource_wiki")
			send_link(client, GLOB.config.wikiurl)
		if("resource_github")
			send_link(client, GLOB.config.githuburl)
		if("resource_bug")
			send_link(client, "[GLOB.config.githuburl]issues/new/choose")
		if("resource_config")
			send_link(client, GLOB.config.webint_url)
		if("resource_changelog")
			client?.changes()
	return TRUE

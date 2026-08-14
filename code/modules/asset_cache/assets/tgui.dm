/datum/asset/simple/tgui
	keep_local_name = TRUE
	assets = list(
		"tgui.bundle.js" = file("tgui/public/tgui.bundle.js"),
		"tgui.bundle.css" = file("tgui/public/tgui.bundle.css"),
	)

/datum/asset/simple/tgui_panel
	keep_local_name = TRUE
	assets = list(
		"tgui-panel.bundle.js" = file("tgui/public/tgui-panel.bundle.js"),
		"tgui-panel.bundle.css" = file("tgui/public/tgui-panel.bundle.css"),
	)

/datum/asset/simple/namespaced/escape_menu_font
	assets = list(
		"Pixellari.ttf" = file("interface/fonts/Pixellari.ttf"),
		"Grand9K_Pixel.ttf" = file("interface/fonts/Grand9K_Pixel.ttf"),
	)
	parents = list(
		"fonts.css" = file("tgui/packages/tgui-escape-menu/styles/fonts.css"),
	)

/datum/asset/simple/namespaced/escape_menu_sounds
	assets = list(
		"esc_open.ogg" = file("sound/misc/escape_menu/esc_open.ogg"),
		"esc_middle.ogg" = file("sound/misc/escape_menu/esc_middle.ogg"),
		"esc_close.ogg" = file("sound/misc/escape_menu/esc_close.ogg"),
		"menu_click.ogg" = file("sound/effects/menu_click.ogg"),
		"menu_click_heavy.ogg" = file("sound/effects/menu_click_heavy.ogg"),
	)

/datum/asset/spritesheet/escape_menu_icons
	name = "escape-menu-icons"

/datum/asset/spritesheet/escape_menu_icons/create_spritesheets()
	var/icon/icons_small = 'icons/hud/escape_menu_icons.dmi'
	for(var/state in icon_states(icons_small))
		Insert(state, icons_small, icon_state = state)
	var/icon/icons_large = 'icons/hud/escape_menu_leave_body.dmi'
	for(var/state in icon_states(icons_large))
		Insert("leave-[state]", icons_large, icon_state = state)

/datum/asset/spritesheet/lobby_menu_icons
	name = "lobby-menu-icons"

/datum/asset/spritesheet/lobby_menu_icons/create_spritesheets()
	var/icon/menu_icons = SSatlas?.current_sector?.sector_hud_menu || 'icons/misc/hudmenu/hudmenu.dmi'
	for(var/state in icon_states(menu_icons))
		Insert(state, menu_icons, icon_state = state)

/datum/asset/spritesheet/lobby_backgrounds
	name = "lobby-backgrounds"

/datum/asset/spritesheet/lobby_backgrounds/create_spritesheets()
	var/icon/lobby_icon = SSatlas?.current_map?.lobby_icon
	if(!lobby_icon && SSatlas?.current_sector?.sector_lobby_art)
		lobby_icon = pick(SSatlas.current_sector.sector_lobby_art)
		SSatlas.current_map.lobby_icon = lobby_icon
	else if(!lobby_icon && SSatlas?.current_map?.lobby_icons)
		lobby_icon = pick(SSatlas.current_map.lobby_icons)
		SSatlas.current_map.lobby_icon = lobby_icon
	if(!lobby_icon)
		lobby_icon = 'icons/misc/titlescreens/title.dmi'
	for(var/state in icon_states(lobby_icon))
		Insert(state, lobby_icon, icon_state = state)

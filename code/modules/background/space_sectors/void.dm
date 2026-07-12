//Light's Edge sectors
/datum/space_sector/lights_edge//Uses the Weeping Stars attributes since it's neighboring and this is not exactly the void just yet
	name = SECTOR_LIGHTS_EDGE
	description = "An unusual region which is sparsely populated even in the 25th century, Light’s Edge was the furthest extent of the Alliance’s hegemonic era exploration efforts in the southeastern Spur. Few attempts were made to colonize it prior to the Interstellar War and even fewer of these attempts were successful, with Assunzione being the most successful of all hegemonic era colonies in the region. Light’s Edge derives its name from its position next to Lemurian Sea, a vast and mostly uncharted region which is entirely devoid of stars. Both Light’s Edge and the Lemurian Sea are home to a variety of unusual stellar phenomena which have attracted widespread scientific interest."
	skybox_icon = "lights_edge"
	starlight_color = "#2d0850"
	starlight_power = 1//slightly darker though for spooky factor
	starlight_range = 2
	overmap_hazards_multiplier = 1.4

	possible_exoplanets = list(/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid, /obj/effect/overmap/visitable/sector/exoplanet/grass/grove, /obj/effect/overmap/visitable/sector/exoplanet/barren, /obj/effect/overmap/visitable/sector/exoplanet/lava, /obj/effect/overmap/visitable/sector/exoplanet/desert, /obj/effect/overmap/visitable/sector/exoplanet/snow)
	cargo_price_coef = list(
		"nanotrasen" = 1.2,
		"orion" = 0.8,
		"hephaestus" = 0.8,
		"zeng_hu" = 0.8,
		"eckharts" = 1.2,
		"getmore" = 1.2,
		"arizi" = 1.2,
		"blam" = 1.2,
		"iac" = 1.2,
		"zharkov" = 0.8,
		"virgo" = 1.2,
		"bishop" = 0.8,
		"xion" = 0.8,
		"zavodskoi" = 0.8,
		)

	sector_welcome_message = 'sound/AI/welcome_lights_edge.ogg'
	sector_hud_menu = 'icons/misc/hudmenu/coalition_hud.dmi'
	sector_hud_arrow = "menu_arrow"

	lobby_tracks = list(
		'sound/music/lobby/lights_edge/lights_edge_1.ogg',
		'sound/music/lobby/lights_edge/lights_edge_2.ogg'
	)

	lore_radio_stations = list(
		"87.4 XNS Interstellar Broadcasting" = 'texts/lore_radio/lights_edge/87.4_XNS_Interstellar.txt',
		"89.8 DomeChat" = 'texts/lore_radio/lights_edge/89.8_DomeChat.txt',
		"96.2 Coalition Hits!" = 'texts/lore_radio/lights_edge/96.2_Coalition_Hits.txt',
		"105.4 Automated Travel Advisory Broadcast System" = 'texts/lore_radio/lights_edge/105.4_Automated_Advisory.txt',
		"114.8 RADIO LEMURIAN TRUTH" = 'texts/lore_radio/lights_edge/114.8_Radio_Lemurian_Truth.txt'
	)

/datum/space_sector/lemurian_sea//The actual proposed area of void as written. Should be as dark as possible, due to no starlight
	name = SECTOR_LEMURIAN_SEA
	description = "The Lemurian Sea is an astrological curiosity which is entirely free of stars. This region is a relatively new discovery and classification, having only been officially broken off of Light’s Edge by most astrographical institutions following the rediscovery of Assunzione and limited exploration beyond its position on the border of what would become the Lemurian Sea. Most astrological charts advise avoiding the region as travelers are known to report a feeling of general uneasiness while passing through it and many vessels are known to have disappeared within the Sea. "
	skybox_icon = "void"//its just black
	possible_exoplanets = list(/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid)
	starlight_color = "#000000"
	starlight_power = 0
	starlight_range = 0
	overmap_hazards_multiplier = 1.3
	cargo_price_coef = list(
		"nanotrasen" = 2.5,
		"orion" = 2.5,
		"hephaestus" = 2.5,
		"zeng_hu" = 2.5,
		"eckharts" = 2.5,
		"getmore" = 2.5,
		"arizi" = 2.5,
		"blam" = 2.5,
		"iac" = 2.5,
		"zharkov" = 2.5,
		"virgo" = 2.5,
		"bishop" = 2.5,
		"xion" = 2.5,
		"zavodskoi" = 2.5,
		)

	lobby_tracks = list(
		'sound/music/lobby/lights_edge/lights_edge_1.ogg',
		'sound/music/lobby/lights_edge/lights_edge_2.ogg',
		'sound/music/lobby/dangerous_space/dangerous_space_1.ogg',
		'sound/music/lobby/spatial_audio.ogg'
	)

	sector_welcome_message = 'sound/AI/welcome_lemurian_sea_outer.ogg'
	sector_lobby_art = list('icons/misc/titlescreens/sccv_horizon/sccv_horizon_dark.dmi')
	sector_lobby_transitions = 0
	sector_hud_menu = 'icons/misc/hudmenu/lemurian_hud.dmi'
	hivenet_echoes = FALSE
	away_sites_enabled = FALSE
	parallax_layering_enabled = FALSE
	ccia_link = FALSE

	lore_radio_stations = list(
		"105.4 Automated Travel Advisory Broadcast System" = 'texts/lore_radio/lights_edge/105.4_Automated_Advisory.txt'
	)

/datum/space_sector/lemurian_sea/far
	name = SECTOR_LEMURIAN_SEA_FAR
	sector_welcome_message = 'sound/AI/welcome_lemurian_sea_inner.ogg'

	lore_radio_stations = list()

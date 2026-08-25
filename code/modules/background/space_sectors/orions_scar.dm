//Orion's Scar
/datum/space_sector/orions_scar
	name = SECTOR_ORIONS_SCAR
	description = "Orion's Scar is named for the higher density streak of stars running along a rough line thirty light years long, forming a bright scar across the stars, especially for those viewing from the Spur's most rimward planets. The area closer to the nations of the Spur is only sparsely populated, and many local powers look to it for future colonization."
	skybox_icon = "orions_scar"
	starlight_color = "#2d0850"
	starlight_power = 6//Dense in stars = more light? Maybe not super realistic but sets the tone.
	starlight_range = 4
	overmap_hazards_multiplier = 1.5//Slightly denser because this area is dense. I'm feeling dense writing all this.

	possible_exoplanets = list(/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid, /obj/effect/overmap/visitable/sector/exoplanet/grass/grove, /obj/effect/overmap/visitable/sector/exoplanet/barren, /obj/effect/overmap/visitable/sector/exoplanet/lava, /obj/effect/overmap/visitable/sector/exoplanet/desert, /obj/effect/overmap/visitable/sector/exoplanet/snow)
	cargo_price_coef = list(
		"nanotrasen" = 1.2,
		"orion" = 1.0,
		"hephaestus" = 1.2,
		"zeng_hu" = 1.2,
		"eckharts" = 1.4,
		"getmore" = 1.2,
		"arizi" = 1.2,
		"blam" = 1.2,
		"iac" = 1.2,
		"zharkov" = 1.4,
		"virgo" = 1.2,
		"bishop" = 1.4,
		"xion" = 1.4,
		"zavodskoi" = 1.2,
		)

	sector_welcome_message = 'sound/AI/welcome_orions_scar.ogg'
	sector_hud_menu = 'icons/misc/hudmenu/coalition_hud.dmi'
	sector_hud_arrow = "menu_arrow"

	lobby_tracks = list(
		'sound/music/lobby/anotherstory.ogg',
		'sound/music/lobby/kaaistoep.ogg'
		'sound/music/lobby/yuki_satellites.ogg'
	)

	lore_radio_stations = list(
		"34.2 The Voice of the Tajaran People" = 'texts/lore_radio/adhomai/34.2_The_Voice_of_the_Tajaran_People.txt',
		"14.6 Northern Harr'masir Radio" = 'texts/lore_radio/adhomai//14.6_Northern_Harrmasir_Radio.txt',
		"72.9 Crevus Radio Center 27" = 'texts/lore_radio/adhomai/72.9_Crevus_Radio_Center_27.txt',
		"51.2 Radio Free Adhomai" = 'texts/lore_radio/adhomai/51.2_Radio_Free_Adhomai.txt',
		"83.1 The Crown Herald" = 'texts/lore_radio/adhomai/83.1_The_Crown_Herald.txt',
		"11.7 KGTW-11" = 'texts/lore_radio/adhomai/11.7_KGTW-11.txt',
		"72.9 Nowa Bratislava Independent Radio" = 'texts/lore_radio/badlands/72.9_Nowa_Bratislava_Independent_Radio.txt',
		"87.4 XNS Interstellar Broadcasting" = 'texts/lore_radio/lights_edge/87.4_XNS_Interstellar.txt',
		"89.8 DomeChat" = 'texts/lore_radio/lights_edge/89.8_DomeChat.txt',
		"96.2 Coalition Hits!" = 'texts/lore_radio/lights_edge/96.2_Coalition_Hits.txt'//A mixture of Coalition and Adhomian broadcasts given Orion's Scar is between the two. I'd add Elyran radio here if we had it.
	)
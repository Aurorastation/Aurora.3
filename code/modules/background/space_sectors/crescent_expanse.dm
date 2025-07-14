/datum/space_sector/crescent_expanse
	name = SECTOR_CRESCENT_EXPANSE_EAST
	description = "A large, mostly uncontrolled area, the Crescent Expanse represents the furthest stretches of human colonization and stretches to the border of the Nralakk \
	Federation. This area was in the process of development by the Solarian Alliance prior to the Interstellar War and half-complete relics of the Alliance's hegemonic era can \
	be found scattered across its planets and floating in long-abandoned systems. The Coalition of Colonies, Nralakk Federation, and Solarian Alliance are currently attempting \
	to expand their influence into this region with varying degrees of success."
	skybox_icon = "crescent_expanse"
	possible_exoplanets = list(
		/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid,
		/obj/effect/overmap/visitable/sector/exoplanet/grass/grove,
		/obj/effect/overmap/visitable/sector/exoplanet/barren,
		/obj/effect/overmap/visitable/sector/exoplanet/lava,
		/obj/effect/overmap/visitable/sector/exoplanet/desert,
		/obj/effect/overmap/visitable/sector/exoplanet/snow,
		/obj/effect/overmap/visitable/sector/exoplanet/crystal
	)
	starlight_color = "#b13636"
	starlight_power = 2
	starlight_range = 4
	cargo_price_coef = list( //very high coefs due to distance from civilised spur
		"nanotrasen" = 20.0,
		"orion" = 15.0,
		"hephaestus" = 20.0,
		"zeng_hu" = 20.0,
		"eckharts" = 20.0,
		"getmore" = 20.0,
		"arizi" = 20.0,
		"blam" = 20.0,
		"iac" = 20.0,
		"zharkov" = 20.0,
		"virgo" = 20.0,
		"bishop" = 20.0,
		"xion" = 20.0,
		"zavodskoi" = 20.0,
		)

	lore_radio_stations = list(
		"95.8 Radio Masyara'Triq (Unlicensed)" = 'texts/lore_radio/crescent_expanse/95.8_CE-Unlicensed_Music_Station.txt'
	)

	lobby_tracks = list(
		'sound/music/lobby/crescent_expanse/crescent_expanse_1.ogg',
		'sound/music/lobby/crescent_expanse/crescent_expanse_2.ogg'
	)

/datum/space_sector/crescent_expanse/west
	name = SECTOR_CRESCENT_EXPANSE_WEST
	lore_radio_stations = list(
		"95.8 Radio Masyara'Triq (Unlicensed)" = 'texts/lore_radio/crescent_expanse/95.8_CE-Unlicensed_Music_Station.txt'
	)
	lobby_tracks = list(
		'sound/music/lobby/crescent_expanse/crescent_expanse_1.ogg',
		'sound/music/lobby/crescent_expanse/crescent_expanse_2.ogg'
	)

/datum/space_sector/crescent_expanse/far
	name = SECTOR_CRESCENT_EXPANSE_FAR

	cargo_price_coef = list( //even higher, we are very far away!
		"nanotrasen" = 200.0,
		"orion" = 150.0,
		"hephaestus" = 200.0,
		"zeng_hu" = 200.0,
		"eckharts" = 200.0,
		"getmore" = 200.0,
		"arizi" = 200.0,
		"blam" = 200.0,
		"iac" = 200.0,
		"zharkov" = 200.0,
		"virgo" = 200.0,
		"bishop" = 200.0,
		"xion" = 200.0,
		"zavodskoi" = 200.0,
		)

	ccia_link = FALSE

	lore_radio_stations = list(
		"74.4 Faint Radio Transmission" = 'texts/lore_radio/crescent_expanse/74.4_CE_Uncharted-Damaged_Station.txt',
		"83.6 Leaking Traffic Control" = 'texts/lore_radio/crescent_expanse/83.6_CE_Uncharted-Pirate_Station.txt',
		"95.8 Radio Masyara'Triq (Unlicensed)" = 'texts/lore_radio/crescent_expanse/95.8_CE-Unlicensed_Music_Station.txt'
	)
	lobby_tracks = list(
		'sound/music/lobby/crescent_expanse/crescent_expanse_1.ogg',
		'sound/music/lobby/dangerous_space/dangerous_space_1.ogg',
		'sound/music/lobby/dangerous_space/dangerous_space_2.ogg'
	)


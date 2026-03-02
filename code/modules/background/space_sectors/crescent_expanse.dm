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
		"arisi" = 2.0,
		"bishop" = 2.0,
		"blam" = 2.0,
		"eckharts" = 2.0,
		"einstein" = 2.0,
		"getmore" = 2.0,
		"hephaestus" = 2.0,
		"iac" = 2.0,
		"idris" = 2.0,
		"molinaris" = 2.0,
		"nanotrasen" = 2.0,
		"orion" = 1.5,
		"virgo" = 2.0,
		"vysoka" = 2.0,
		"xion" = 2.0,
		"zavodskoi" = 2.0,
		"zeng_hu" = 2.0,
		"zharkov" = 2.0,
		"zora" = 2.0,
		)

	lore_radio_stations = list(
		"95.8 Radio Masyara'Triq (Unlicensed)" = 'texts/lore_radio/crescent_expanse/95.8_CE-Unlicensed_Music_Station.txt'
	)

/datum/space_sector/crescent_expanse/west
	name = SECTOR_CRESCENT_EXPANSE_WEST
	lore_radio_stations = list(
		"95.8 Radio Masyara'Triq (Unlicensed)" = 'texts/lore_radio/crescent_expanse/95.8_CE-Unlicensed_Music_Station.txt'
	)

/datum/space_sector/crescent_expanse/far
	name = SECTOR_CRESCENT_EXPANSE_FAR

	cargo_price_coef = list( //even higher, we are very far away!
		"arisi" = 4.0,
		"bishop" = 4.0,
		"blam" = 4.0,
		"eckharts" = 4.0,
		"einstein" = 4.0,
		"getmore" = 4.0,
		"hephaestus" = 4.0,
		"iac" = 4.0,
		"idris" = 4.0,
		"molinaris" = 4.0,
		"nanotrasen" = 4.0,
		"orion" = 3.5,
		"virgo" = 4.0,
		"vysoka" = 4.0,
		"xion" = 4.0,
		"zavodskoi" = 4.0,
		"zeng_hu" = 4.0,
		"zharkov" = 4.0,
		"zora" = 4.0,
		)

	ccia_link = FALSE

	lore_radio_stations = list(
		"74.4 Faint Radio Transmission" = 'texts/lore_radio/crescent_expanse/74.4_CE_Uncharted-Damaged_Station.txt',
		"83.6 Leaking Traffic Control" = 'texts/lore_radio/crescent_expanse/83.6_CE_Uncharted-Pirate_Station.txt',
		"95.8 Radio Masyara'Triq (Unlicensed)" = 'texts/lore_radio/crescent_expanse/95.8_CE-Unlicensed_Music_Station.txt'
	)
	lobby_tracks = list(
		'sound/music/lobby/dangerous_space/dangerous_space_1.ogg',
		'sound/music/lobby/dangerous_space/dangerous_space_2.ogg'
	)


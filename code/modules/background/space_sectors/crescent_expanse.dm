/datum/space_sector/crescent_expanse
	name = SECTOR_CRESCENT_EXPANSE_EAST
	description = "The Badlands are home to some of the Orion Spur's most savage flora and fauna, a phenomenon that attracts only the wildest and wisest of the system's inhabitants - xenobiologists, \
	weapon scientists, there's even a market for mercenaries, in the hunting of the particularly large and lethal creatures. Of course, there are also those looking to make a life for themselves, \
	but natives aren't known to treat settlements kindly."
	skybox_icon = "the_clash" //placeholder, but its nearby
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
		"83.6 Radio Masyara'Triq (Unlicensed)" = 'texts/lore_radio/crescent_expanse/95.8_CE-Unlicensed_Music_Station.txt'
	)

/datum/space_sector/crescent_expanse/west
	name = SECTOR_CRESCENT_EXPANSE_WEST
	lore_radio_stations = list(
		"83.6 Radio Masyara'Triq (Unlicensed)" = 'texts/lore_radio/crescent_expanse/95.8_CE-Unlicensed_Music_Station.txt'
	)

/datum/space_sector/crescent_expanse/far
	name = SECTOR_CRESCENT_EXPANSE_FAR
	description = "Nestled in the narrow Frontier space between the Republic of Elyra and the former borders of the Solarian Alliance is Valley Hale, a large region filled with a large \
	amount of old, dying stars and impassable nebulae. Due to close proximity to patrols on either end of this space, it isn't frequented much by criminal elements and is one of the \
	safer parts of the known Frontier. After 2462, the Republic of Elyra has occupied the majority of Valley Hale, now bordering the Republic of Biesel."

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
		"83.6 Radio Masyara'Triq (Unlicensed)" = 'texts/lore_radio/crescent_expanse/95.8_CE-Unlicensed_Music_Station.txt'
	)


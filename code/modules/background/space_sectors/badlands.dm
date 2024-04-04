/datum/space_sector/badlands
	name = SECTOR_BADLANDS
	description = "The Badlands are home to some of the Orion Spur's most savage flora and fauna, a phenomenon that attracts only the wildest and wisest of the system's inhabitants - xenobiologists, \
	weapon scientists, there's even a market for mercenaries, in the hunting of the particularly large and lethal creatures. Of course, there are also those looking to make a life for themselves, \
	but natives aren't known to treat settlements kindly."
	skybox_icon = "badlands"
	sector_welcome_message = 'sound/AI/welcome_badlands.ogg'
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

/datum/space_sector/valley_hale
	name = SECTOR_VALLEY_HALE
	description = "Nestled in the narrow Frontier space between the Republic of Elyra and the former borders of the Solarian Alliance is Valley Hale, a large region filled with a large \
	amount of old, dying stars and impassable nebulae. Due to close proximity to patrols on either end of this space, it isn't frequented much by criminal elements and is one of the \
	safer parts of the known Frontier. After 2462, the Republic of Elyra has occupied the majority of Valley Hale, now bordering the Republic of Biesel."
	skybox_icon = "valley_hale"
	possible_exoplanets = list(
		/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid,
		/obj/effect/overmap/visitable/sector/exoplanet/grass/grove,
		/obj/effect/overmap/visitable/sector/exoplanet/barren,
		/obj/effect/overmap/visitable/sector/exoplanet/lava,
		/obj/effect/overmap/visitable/sector/exoplanet/desert,
		/obj/effect/overmap/visitable/sector/exoplanet/snow,
		/obj/effect/overmap/visitable/sector/exoplanet/crystal
	)
	starlight_color = "#e68831"
	starlight_power = 2
	starlight_range = 4

/datum/space_sector/new_ankara
	name = SECTOR_NEW_ANKARA
	description = "New Ankara is the home system of the Republic of Elyra. Its capital is Persepolis. The planet was originally an arid planet with a modest atmosphere and stubborn \
	native ecosystems already present. Original Alliance-funded terraforming efforts transformed the planet into an Earthlike planet within a decade, allowing the population to flourish \
	before and after independence. Commercial and service sector jobs remain the highest employer, second to refineries processing phoron or other minerals transported to the planet's \
	orbit. This is among the primary locations in Elyra where phoron can be found in abundance."
	skybox_icon = "valley_hale"
	starlight_color = "#e68831"
	starlight_power = 2
	starlight_range = 4

/datum/space_sector/aemag
	name = SECTOR_AEMAQ
	description = "Located in the Serene Republic of Elyra, the al-Wakwak System is most well-known as the home of Aemaq -- one of the largest chemical production centres of the Orion \
	Spur. Aemaq is known for its strikingly purple chemical seas that cover the entirety of its surface and its floating cities that hover above the sea, such as its capital of \
	Rumaidair. The chemical seas are home to a variety of fauna, some of which are known as leviathans -- truly massive creatures able to grow up to two kilometers long! Though the \
	planet well-known for its research into the seas the chemical industry remains the primary employer on Aemaq, and many hopeful immigrants to the Republic find themselves working \
	in the massive chemical plants of Aemaq to make ends meet."
	skybox_icon = "valley_hale"
	starlight_color = "#e68831"
	starlight_power = 2
	starlight_range = 4

/datum/space_sector/srandmarr
	name = SECTOR_SRANDMARR
	description = "S'rand'marr is the star system home to Adhomai, the homeworld of the Tajara species. Adhomai is the fourth planet from S'rendarr. It is a cold and icy world, suffering from \
	almost perpetual snowfall and extremely low temperatures. It is currently divided between three factions involved in a cold war: the People's Republic of Adhomai, the Democratic People's \
	Republic of Adhomai, and the New Kingdom of Adhomai."
	skybox_icon = "srandmarr"
	possible_exoplanets = list(
		/obj/effect/overmap/visitable/sector/exoplanet/barren/aethemir,
		/obj/effect/overmap/visitable/sector/exoplanet/barren/raskara,
		/obj/effect/overmap/visitable/sector/exoplanet/barren/azmar,
		/obj/effect/overmap/visitable/sector/exoplanet/lava/sahul
	)
	guaranteed_exoplanets = list(/obj/effect/overmap/visitable/sector/exoplanet/adhomai)
	scheduled_port_visits = list("Thursday", "Sunday")
	ports_of_call = list("the city of Nal'tor", "the city of Kaltir", "the city of Crevus")
	cargo_price_coef = list("nt" = 1.2, "hpi" = 1.2, "zhu" = 1.2, "een" = 1.2, "get" = 1.2, "arz" = 1.2, "blm" = 1.2, "iac" = 1.2, "zsc" = 0.5, "vfc" = 1.2, "bis" = 1.2, "xmg" = 1.2, "npi" = 1.2)
	starlight_color = "#50b7bb"
	starlight_power = 2
	starlight_range = 4
	sector_lobby_art = list('icons/misc/titlescreens/lore/cold_dawn.dmi')
	sector_lobby_transitions = 0
	sector_welcome_message = 'sound/AI/adhomai_welcome.ogg'
	sector_hud_menu = 'icons/misc/hudmenu/tajara_hud.dmi'
	sector_hud_menu_sound = 'sound/effects/menu_click_heavy.ogg'
	sector_hud_arrow = "menu_arrow"

/datum/space_sector/nrrahrahul
	name = SECTOR_NRRAHRAHUL
	description = "Hro'zamal is the second planet in the Nrrahrahul system. Formerly named Nrrahrahul Two, it was given the name Hro'zamal after the establishment of a permanent civilian \
	colony on the planet's surface in 2459. The planet is roughly the size of Earth. Most of the planet is dominated by lush jungles except for the poles that possess a subtropical climate; \
	Tajara can survive in these regions without the use of suits. The use of acclimatization systems is necessary during the \
	warmer seasons."
	starlight_color = COLOR_WHITE
	starlight_power = 5
	starlight_range = 1

/datum/space_sector/gakal
	name = SECTOR_GAKAL
	description = "Gakal'zaal is the sixth planet in the Gakal star system with its capital city being Zikala. Currently under the control of the Democratic People's Republic of Adhomai. \
	The majority of the surface is covered by hills, steppes, and forests. Temperatures are generally low, but the average climate is considered to be more moderate and warm than \
	Adhomai. Gakal'zaal is home to a large Tajara population, with an Unathi minority living at the equator."
	starlight_color = COLOR_WHITE
	starlight_power = 5
	starlight_range = 1

/datum/space_sector/uueoaesa
	name = SECTOR_UUEOAESA
	description = "The home of the Unathi race, Uueoa-Esa is a solar system with 4 rocky planets and 1 gas giant. Moghes is the homeworld of the Unathi species and third from its mother star. \
	It is similar in density and composition to Earth and held host to varied and complex environments and local fauna and flora. It's surface area of salt water is much lower than most other habitable planets. \
	Moghes is currently experiencing immense environmental degradation following a global nuclear war in the 2430's."
	starlight_color = COLOR_WHITE
	starlight_power = 5
	starlight_range = 1

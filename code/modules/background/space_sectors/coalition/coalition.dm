//Coalition-aligned regions and sectors
/datum/space_sector/coalition
	name = SECTOR_COALITION
	description = "The Coalition of Colonies is an independent, space-faring nation formed of once-Solarian colonies residing in the frontier. Population estimates range from 85 to 110 billion, with an accurate census being nearly impossible due to the decentralized government of the Coalition. Founded in a revolt against the governance of the Association of Sovereign Solarian Nations, or the Sol Alliance, it won its independence in the prolonged Interstellar War. The Coalition is one of the most diverse entities in known space culturally, socially, and politically."
	skybox_icon = "weeping_stars"//the region that covers most of the coalition, presumably
	possible_exoplanets = list(/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid, /obj/effect/overmap/visitable/sector/exoplanet/grass/grove, /obj/effect/overmap/visitable/sector/exoplanet/barren, /obj/effect/overmap/visitable/sector/exoplanet/lava, /obj/effect/overmap/visitable/sector/exoplanet/desert, /obj/effect/overmap/visitable/sector/exoplanet/snow)
//	cargo_price_coef = TBD
	starlight_color = "#615bff"
	starlight_power = 2
	starlight_range = 4
	sector_welcome_message = 'sound/AI/welcome_coalition.ogg'
	sector_hud_arrow = "menu_arrow"

/datum/space_sector/weeping_stars
	name = SECTOR_WEEPING_STARS
	description = "The region most devastated by the Interstellar War, the majority of the Weeping Stars has yet to recover from the damage it suffered during the War and much of it remains underdeveloped and sparsely inhabited. During the hegemonic era of the Solarian Alliance, when the Alliance stretched from Sol to the edge of known space, this region was known as the Inner Solarian Frontier and was intended to serve as a highly-developed region for humanity to thrive in. Massive amounts of funds were used to build an infrastructure which was still incomplete when war broke out in 2277, and the shattered ruins of long-lost Solarian hegemonic era structures and projects are present throughout the region."
	skybox_icon = "weeping_stars"
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

	starlight_color = "#615bff"
	starlight_power = 2
	starlight_range = 4
	sector_welcome_message = 'sound/AI/welcome_weeping.ogg'
	sector_hud_arrow = "menu_arrow"

/datum/space_sector/arusha
	name = SECTOR_ARUSHA
	description = "Arusha is a truly alien sector within the Orion Spur, known for its great many barely-habitable planets populated by xenoflora that is like nothing ever seen elsewhere in charted space. Presumably anomalous in nature or spread by a now long-gone civilization, these Arushan plant species are widely famous for their odd appearance, high luminescence and very specific compatible habitats. The products of harvesting Arushan plants are seen as delicacies across charted space."
	skybox_icon = "arusha"
//	cargo_price_coef = TBD
	starlight_color = "#2d9647"
	starlight_power = 2
	starlight_range = 5

/datum/space_sector/libertys_cradle
	name = SECTOR_LIBERTYS_CRADLE
	description = "The beating heart of the modern Coalition of Colonies, Liberty’s Cradle is home to many of the Coalition’s most developed and influential worlds. In contrast to the Solarian stereotype of the frontier as a decivilized wasteland populated by roving bands of pirates and petty warlords, Liberty’s Cradle is a prosperous and safe region which has a higher standard of living than much of the former Middle and Outer Ring possessed prior to the Solarian Collapse of 2462. Post-Collapse the area has continued to prosper and, now that it dwells far behind the Coalition-controlled Weeping Stars, is more secure than it has ever been before."
	skybox_icon = "arusha"//placeholder
	scheduled_port_visits = null
	cargo_price_coef = list(
		"arisi" = 1.2,
		"bishop" = 0.8,
		"blam" = 1.2,
		"eckharts" = 1.2,
		"einstein" = 0.8,
		"getmore" = 0.8,
		"hephaestus" = 1.1,
		"iac" = 1.2,
		"idris" = 0.8,
		"molinaris" = 1.2,
		"nanotrasen" = 0.8,
		"orion" = 0.8,
		"virgo" = 1.2,
		"vysoka" = 1.2,
		"xion" = 1.1,
		"zavodskoi" = 0.8,
		"zeng_hu" = 0.7,
		"zharkov" = 1.2,
		"zora" = 1.2,
		)
	starlight_color = "#2d9647"
	starlight_power = 2
	starlight_range = 5


/datum/space_sector/libertys_cradle/xanu
	name = SECTOR_XANU
	description = "Located in the eastern Orion Spur. The Xanu system is home to the Xanu Prime, colonised in 2185, which has grown into the current capital of the Coalition of Colonies, a decentralised government that won its independence from the Solarian Alliance after the Interstellar War."
	skybox_icon = "arusha" //placeholder
	possible_exoplanets = list(/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid, /obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/ice)
	guaranteed_exoplanets = list(/obj/effect/overmap/visitable/sector/exoplanet/xanu)

	ports_of_call = list("Pataliputra")
	scheduled_port_visits = list("Saturday", "Sunday")
	starlight_range = 2

	lobby_tracks = list(
		'sound/music/regional/xanu/xanu_rock_1.ogg',
		'sound/music/regional/xanu/xanu_rock_2.ogg'
	)

/datum/space_sector/burzsia
	name = SECTOR_BURZSIA
	description = "The system of Burzsia serves as a resource hub solely for the corporate interests of Hephaestus Industries, with vast mining infrastructure and sprawling supply ports dotted all over the system. Hephaestus ships, enormous freighters and personnel transportation vessels dominate the area, with corporate security being extremely tight. Private vessels are allowed transit and rest if needed, though always under the close surveillance of Hephaestus security and local executives. A population of local off-worlders has also been present before corporate domination, but mostly leave any external relations to the company that has, at this point, taken upon it to represent virtually all interests of the natives."
	skybox_icon = "weeping_stars"
	possible_exoplanets = list(/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/burzsia, /obj/effect/overmap/visitable/sector/exoplanet/burzsia)
	cargo_price_coef = list(
		"nanotrasen" = 1.2,
		"orion" = 1,
		"hephaestus" = 0.4,
		"zeng_hu" = 0.8,
		"eckharts" = 1.2,
		"getmore" = 1.2,
		"arizi" = 1.2,
		"blam" = 1.2,
		"iac" = 1.2,
		"zharkov" = 1.2,
		"virgo" = 1.2,
		"bishop" = 0.8,
		"xion" = 0.8,
		"zavodskoi" = 0.8,
		)

	starlight_color = "#615bff"
	starlight_power = 2
	starlight_range = 4
	sector_welcome_message = 'sound/AI/welcome_weeping.ogg'
	sector_hud_arrow = "menu_arrow"

/datum/space_sector/haneunim
	name = SECTOR_HANEUNIM
	description = "Located in the northern Orion Spur, the Haneunim system is home to the planet Konyang - known for being one of the most pro-synthetic planets in the Spur, and the only place where synthetics have full and equal legal rights to humanity. Einstein Engines, Zeng-Hu Pharmaceuticals and Hephaestus Industries all have a major presence in this sector, and many vessels of desperate synthetics seek to find sanctuary from the wider Spur within the borders of Konyang. A wealthy and prosperous system, Haneunim has endured a period of uncertainty - seceding from the Sol Alliance and joining the Coalition of Colonies in 2462, in the hope of protection from the Solarian warlords that plagued the region."
	skybox_icon = "haneunim"
	possible_exoplanets = list(/obj/effect/overmap/visitable/sector/exoplanet/barren/qixi, /obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/ice/haneunim, /obj/effect/overmap/visitable/sector/exoplanet/barren/hwanung, /obj/effect/overmap/visitable/sector/exoplanet/lava/huozhu)
	guaranteed_exoplanets = list(/obj/effect/overmap/visitable/sector/exoplanet/konyang)
	cargo_price_coef = list(
		"nanotrasen" = 1.1,
		"orion" = 0.7,
		"hephaestus" = 0.7,
		"zeng_hu" = 0.6,
		"eckharts" = 1,
		"blam" = 0.9,
		"zharkov" = 1.2,
		"virgo" = 0.9,
		"bishop" = 0.5,
		"xion" = 0.8,
		"zavodskoi" = 0.8,
		)

	ports_of_call = list("the corporate district of Aoyama")
	scheduled_port_visits = list("Saturday", "Sunday")
	starlight_color = "#e2719b"
	starlight_power = 2//placeholder
	starlight_range = 4//placeholder
	lobby_icon_image_paths = list(
								list('icons/misc/titlescreens/tajara/taj1.png', 'icons/misc/titlescreens/tajara/taj2.png', 'icons/misc/titlescreens/tajara/taj3.png', 'icons/misc/titlescreens/tajara/taj4.png', 'icons/misc/titlescreens/tajara/Ghostsofwar.png', 'icons/misc/titlescreens/tajara/crack.png', 'icons/misc/titlescreens/tajara/blind_eye.png', 'icons/misc/titlescreens/tajara/RoyalGrenadier.png', 'icons/misc/titlescreens/tajara/For_the_King.png'),
								list('icons/misc/titlescreens/synths/baseline.png', 'icons/misc/titlescreens/synths/bishop.png', 'icons/misc/titlescreens/synths/g2.png', 'icons/misc/titlescreens/synths/shell.png', 'icons/misc/titlescreens/synths/zenghu.png', 'icons/misc/titlescreens/synths/hazelchibi.png'),
								list('icons/misc/titlescreens/vaurca/cthur.png', 'icons/misc/titlescreens/vaurca/klax.png', 'icons/misc/titlescreens/vaurca/liidra.png', 'icons/misc/titlescreens/vaurca/zora.png'),
								list('icons/misc/titlescreens/space/odin.png', 'icons/misc/titlescreens/space/starmap.png', 'icons/misc/titlescreens/space/undocking.png', 'icons/misc/titlescreens/space/voyage.png')
								)
	sector_welcome_message = 'sound/AI/welcome_konyang.ogg'
	sector_hud_arrow = "menu_arrow"

	lobby_tracks = list(
		'sound/music/lobby/konyang/konyang-1.ogg',
		'sound/music/lobby/konyang/konyang-2.ogg',
		'sound/music/lobby/konyang/konyang-3.ogg',
		'sound/music/lobby/konyang/konyang-4.ogg'
	)

	lore_radio_stations = list(
		"73.2 Navy Broadcasting Service" = 'texts/lore_radio/konyang/73.2_Navy_Broadcasting_Service.txt',
		"122 Great Blue Dot" = 'texts/lore_radio/konyang//122_Great_Blue_Dot.txt',
		"75.4 PBA" = 'texts/lore_radio/konyang/75.4_PBA.txt',
		"77.7 SoulFM" = 'texts/lore_radio/konyang/77.7_SoulFM.txt',
		"78.1 RealFM" = 'texts/lore_radio/konyang/78.1_RealFM.txt'
	)

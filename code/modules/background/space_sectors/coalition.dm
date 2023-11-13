//Coalition-aligned regions and sectors
/datum/space_sector/coalition
	name = SECTOR_COALITION
	description = "The Coalition of Colonies is an independent, space-faring nation formed of once-Solarian colonies residing in the frontier. Population estimates range from 85 to 110 billion, with an accurate census being nearly impossible due to the decentralized government of the Coalition. Founded in a revolt against the governance of the Association of Sovereign Solarian Nations, or the Sol Alliance, it won its independence in the prolonged Interstellar War. The Coalition is one of the most diverse entities in known space culturally, socially, and politically."
	skybox_icon = "weeping_stars"//the region that covers most of the coalition, presumably
	possible_exoplanets = list(/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid, /obj/effect/overmap/visitable/sector/exoplanet/grass/grove, /obj/effect/overmap/visitable/sector/exoplanet/barren, /obj/effect/overmap/visitable/sector/exoplanet/lava, /obj/effect/overmap/visitable/sector/exoplanet/desert)
//	cargo_price_coef = TBD
	starlight_color = "#615bff"
	starlight_power = 2
	starlight_range = 4
	sector_welcome_message = 'sound/AI/welcome_coalition.ogg'
	sector_hud_menu = 'icons/misc/hudmenu/coalition_hud.dmi'
	sector_hud_arrow = "menu_arrow"

/datum/space_sector/weeping_stars
	name = SECTOR_WEEPING_STARS
	description = "The region most devastated by the Interstellar War, the majority of the Weeping Stars has yet to recover from the damage it suffered during the War and much of it remains underdeveloped and sparsely inhabited. During the hegemonic era of the Solarian Alliance, when the Alliance stretched from Sol to the edge of known space, this region was known as the Inner Solarian Frontier and was intended to serve as a highly-developed region for humanity to thrive in. Massive amounts of funds were used to build an infrastructure which was still incomplete when war broke out in 2277, and the shattered ruins of long-lost Solarian hegemonic era structures and projects are present throughout the region."
	skybox_icon = "weeping_stars"
	possible_exoplanets = list(/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid, /obj/effect/overmap/visitable/sector/exoplanet/grass/grove, /obj/effect/overmap/visitable/sector/exoplanet/barren, /obj/effect/overmap/visitable/sector/exoplanet/lava, /obj/effect/overmap/visitable/sector/exoplanet/desert)
	cargo_price_coef = list("nt" = 1.2, "hpi" = 0.8, "zhu" = 0.8, "een" = 1.2, "get" = 1.2, "arz" = 1.2, "blm" = 1.2, "iac" = 1.2, "zsc" = 0.8, "vfc" = 1.2, "bis" = 0.8, "xmg" = 0.8, "npi" = 0.8)
	starlight_color = "#615bff"
	starlight_power = 2
	starlight_range = 4
	sector_welcome_message = 'sound/AI/welcome_weeping.ogg'
	sector_hud_menu = 'icons/misc/hudmenu/coalition_hud.dmi'
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
	skybox_icon = "the_clash"//placeholder
//	cargo_price_coef = TBD
	starlight_color = "#962d96"
	starlight_power = 2
	starlight_range = 4

/datum/space_sector/burzsia
	name = SECTOR_BURZSIA
	description = "The system of Burzsia serves as a resource hub solely for the corporate interests of Hephaestus Industries, with vast mining infrastructure and sprawling supply ports dotted all over the system. Hephaestus ships, enormous freighters and personnel transportation vessels dominate the area, with corporate security being extremely tight. Private vessels are allowed transit and rest if needed, though always under the close surveillance of Hephaestus security and local executives. A population of local off-worlders has also been present before corporate domination, but mostly leave any external relations to the company that has, at this point, taken upon it to represent virtually all interests of the natives."
	skybox_icon = "weeping_stars"
	possible_exoplanets = list(/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/burzsia, /obj/effect/overmap/visitable/sector/exoplanet/burzsia)
	cargo_price_coef = list("nt" = 1.2, "hpi" = 0.4, "zhu" = 0.8, "een" = 1.2, "get" = 1.2, "arz" = 1.2, "blm" = 1.2, "iac" = 1.2, "zsc" = 0.8, "vfc" = 1.2, "bis" = 0.8, "xmg" = 0.8, "npi" = 0.8)
	starlight_color = "#615bff"
	starlight_power = 2
	starlight_range = 4
	sector_welcome_message = 'sound/AI/welcome_weeping.ogg'
	sector_hud_menu = 'icons/misc/hudmenu/coalition_hud.dmi'
	sector_hud_arrow = "menu_arrow"

/datum/space_sector/haneunim
	name = SECTOR_HANEUNIM
	description = "TBD."
	skybox_icon = "haneunim"
	possible_exoplanets = list(/obj/effect/overmap/visitable/sector/exoplanet/konyang)
//	cargo_price_coef = TBD
	starlight_color = "#e2719b"
	starlight_power = 2//placeholder
	starlight_range = 4//placeholder
	sector_welcome_message = 'sound/AI/welcome_weeping.ogg'//placeholder

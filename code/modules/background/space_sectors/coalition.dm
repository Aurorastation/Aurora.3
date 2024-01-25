//Coalition-aligned regions and sectors
/datum/space_sector/coalition
	name = SECTOR_COALITION
	description = "Коалиция Колоний - независимое космическое государство, занимающее бывшие территории Альянса. Общее население составляет от 85 до 110 миллиардов душ, \
	более точный подсчёт получить невозможно из за децентрализованной натуры государства. Рождённая во время войны за независимость с Альянсом Солнечной Системы, \
	Коалиции удалось выйти победителем в Первой Межзвёздной Войне. Коалиция считается одним из самых многонациональных государств во всё известном космосе."
	skybox_icon = "weeping_stars"//the region that covers most of the coalition, presumably
	possible_exoplanets = list(/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid, /obj/effect/overmap/visitable/sector/exoplanet/grass/grove, /obj/effect/overmap/visitable/sector/exoplanet/barren, /obj/effect/overmap/visitable/sector/exoplanet/lava, /obj/effect/overmap/visitable/sector/exoplanet/desert, /obj/effect/overmap/visitable/sector/exoplanet/snow)
//	cargo_price_coef = TBD
	starlight_color = "#615bff"
	starlight_power = 2
	starlight_range = 4
	sector_welcome_message = 'sound/AI/welcome_coalition.ogg'
	sector_hud_menu = 'icons/misc/hudmenu/coalition_hud.dmi'
	sector_hud_arrow = "menu_arrow"

/datum/space_sector/weeping_stars
	name = SECTOR_WEEPING_STARS
	description = "Регион, наиболее пострадавший от межзвёздной войны, большая часть этой системы всё ещё не оправилась от неё и почти не заселена. \
	Во времена экспансии, когда Альянс, это место было известно как внутренний Солнечный фронтир, и на него тогда подавались большие надежды. Огромные деньги \
	были потрачены на обустройство здешней инфраструктуры, но к началу войны проект так и не достроили, из за чего, многочисленные руины различных проектов Альянса \
	и по сей день наполняют это место."
	skybox_icon = "weeping_stars"
	possible_exoplanets = list(/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid, /obj/effect/overmap/visitable/sector/exoplanet/grass/grove, /obj/effect/overmap/visitable/sector/exoplanet/barren, /obj/effect/overmap/visitable/sector/exoplanet/lava, /obj/effect/overmap/visitable/sector/exoplanet/desert, /obj/effect/overmap/visitable/sector/exoplanet/snow)
	cargo_price_coef = list("nt" = 1.2, "hpi" = 0.8, "zhu" = 0.8, "een" = 1.2, "get" = 1.2, "arz" = 1.2, "blm" = 1.2, "iac" = 1.2, "zsc" = 0.8, "vfc" = 1.2, "bis" = 0.8, "xmg" = 0.8, "npi" = 0.8)
	starlight_color = "#615bff"
	starlight_power = 2
	starlight_range = 4
	sector_welcome_message = 'sound/AI/welcome_weeping.ogg'
	sector_hud_menu = 'icons/misc/hudmenu/coalition_hud.dmi'
	sector_hud_arrow = "menu_arrow"

/datum/space_sector/arusha
	name = SECTOR_ARUSHA
	description = "Аруша - настоящая диковинка в Поясе Ориона, знаменитая своей ксенофауной на почти не заселённых планетах, которая не похожа ни на что другое в Известном Космосе. \
	Предположительно, аномальная флора, была распространена по этой системе давно ушедшей цивилизацией. Растения известны своей привередливостью, из за чего, их не выращивают вне этой системы. \
	Блюда, получающиеся из них, воистину великолепны, из за чего во всей остальной галактике, они очень высоко ценятся."
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
	description = "Located in the northern Orion Spur, the Haneunim system is home to the planet Konyang - known for being one of the most pro-synthetic planets in the Spur, and the only place where synthetics have full and equal legal rights to humanity. Einstein Engines, Zeng-Hu Pharmaceuticals and Hephaestus Industries all have a major presence in this sector, and many vessels of desperate synthetics seek to find sanctuary from the wider Spur wihtin the borders of Konyang. A wealthy and prosperous system, Haneunim has endured a period of uncertainty - seceding from the Sol Alliance and joining the Coalition of Colonies in 2462, in the hope of protection from the Solarian warlords that plagued the region."
	skybox_icon = "haneunim"
	possible_exoplanets = list(/obj/effect/overmap/visitable/sector/exoplanet/konyang)
	cargo_price_coef = list("nt" = 1.1, "hpi" = 0.7, "zhu" = 0.4, "een" = 1.0, "get" = 1.1, "arz" = 1.8, "blm" = 0.9, "iac" = 1.2, "zsc" = 1.8, "vfc" = 0.9, "bis" = 0.4, "xmg" = 0.7, "npi" = 0.8)
	starlight_color = "#e2719b"
	starlight_power = 2//placeholder
	starlight_range = 4//placeholder
	sector_lobby_art = list('icons/misc/titlescreens/lore/silicon_nightmares.dmi')
	sector_lobby_transitions = 0
	sector_welcome_message = 'sound/AI/welcome_konyang.ogg'
	sector_hud_menu = 'icons/misc/hudmenu/konyang_hud.dmi'
	sector_hud_arrow = "menu_arrow"

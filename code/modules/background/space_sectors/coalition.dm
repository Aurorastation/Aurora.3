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
	sector_hud_menu = 'icons/misc/hudmenu/coalition_hud.dmi'
	sector_hud_arrow = "menu_arrow"

/datum/space_sector/weeping_stars
	name = SECTOR_WEEPING_STARS
	description = "The region most devastated by the Interstellar War, the majority of the Weeping Stars has yet to recover from the damage it suffered during the War and much of it remains underdeveloped and sparsely inhabited. During the hegemonic era of the Solarian Alliance, when the Alliance stretched from Sol to the edge of known space, this region was known as the Inner Solarian Frontier and was intended to serve as a highly-developed region for humanity to thrive in. Massive amounts of funds were used to build an infrastructure which was still incomplete when war broke out in 2277, and the shattered ruins of long-lost Solarian hegemonic era structures and projects are present throughout the region."
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
	description = "Located in the northern Orion Spur, the Haneunim system is home to the planet Konyang - known for being one of the most pro-synthetic planets in the Spur, and the only place where synthetics have full and equal legal rights to humanity. Einstein Engines, Zeng-Hu Pharmaceuticals and Hephaestus Industries all have a major presence in this sector, and many vessels of desperate synthetics seek to find sanctuary from the wider Spur wihtin the borders of Konyang. A wealthy and prosperous system, Haneunim has endured a period of uncertainty - seceding from the Sol Alliance and joining the Coalition of Colonies in 2462, in the hope of protection from the Solarian warlords that plagued the region."
	skybox_icon = "haneunim"
	possible_exoplanets = list(/obj/effect/overmap/visitable/sector/exoplanet/konyang)
//	cargo_price_coef = TBD
	starlight_color = "#e2719b"
	starlight_power = 2//placeholder
	starlight_range = 4//placeholder
	sector_lobby_art = list('icons/misc/titlescreens/lore/silicon_nightmares.dmi')
	sector_lobby_transitions = 0
	sector_welcome_message = 'sound/AI/welcome_weeping.ogg'//placeholder
	sector_hud_menu = 'icons/misc/hudmenu/konyang_hud.dmi'
	sector_hud_arrow = "menu_arrow"
	lore_radio_stations = list("73.2 Navy Broadcasting Service", "122 Great Blue Dot", "75.4 PBA", "77.7 SoulFM", "78.1 RealFM")

/datum/space_sector/haneunim/lore_radio_message(var/obj/item/lore_radio/R, var/chosen_station)
	if(!R || !R.receiving || R.broadcast)
		return

	switch(chosen_station)

		if("73.2 Navy Broadcasting Service")
			do_konyang_navy_radio(R)

		if("122 Great Blue Dot")
			var/dot_message = pick("/..hkk#ht../", "/...bzzbbt.../", "/khhkhhhkh...khhh#t.../", "/...gh#hhk....kt.../", "/khhkhhht.../", "/..khkbzzzzz-t.../", "/bzzzt-bzzt.../", "/...khhbzzzt.../", "/....khk#khhh.../",
			"/...khh..ping../", "/...khhbeware..khhht.../", "/..khhk#hhwaspskhhh-ht../", "/khhkh$hhkh...khh#$ht.../", "/...ghhhk....kt.../", "/khhk#hhht.../", "/..khkb$zzzzz-t.../", "/bzzzt-bzzt.../", "/...hkkhh...khhlook upkhh-hht.../",
			"/..hkkht../", "/...bzzbbt.../", "/khhkh$#hhkh...khh$ht.../", "/...khhk-...khhno-timekhh.../", "/..hkkht../", "/...bzzbbt.../", "/khh#khhhkh...khhh#t.../", "/bzzzt-bzzt.../", "/...khh*&^zt.../", "/....kh#kkhhh.../",
			"/...kh2h..ping../", "/...the hive.../", "/...bzz$z$#zt.../", "/...lookup.../", "/..khht.../", "/..khkb$zzzzz-t.../", "/bzzzt-bzzt.../", "/...khhbzzzt.../", "/....khkkhhh.../", "/...khh..ping../",
			"/...khhbeware..khhht.../", "/..khhkh$#hwaspsk#hhh-ht../", "/khhkhhhkh...khhht.../", "/...ghhhk....kt.../", "/khhkhhht.../", "/..khkb#zzzzz-t.../", "/bzzzt-bzzt.../", "/...khh..p#ing../", "/...the hive.../",
			"/...kh#hhtime is nowkhhg$htt.../", "/...khhtkht.../", "/..khhjoin us../", "/..khh$khhjoin us now.../")
			R.relay_lore_radio(dot_message)

		if("75.4 PBA")
			do_konyang_pba_radio(R)

/datum/space_sector/haneunim/proc/do_konyang_navy_radio(var/obj/item/lore_radio/R)
	var/chosen_broadcast = pick("weather", "warning", "news", "season", "donation", "review")
	R.broadcast = TRUE

	switch(chosen_broadcast)

		if("weather")
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "This is the Navy Broadcasting Service, at 73.2 MHz. Now follows today's Shipping Forecast issued by the Meteorological Office."), 1 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "North Sea, strong southerly winds, seven to eight Beaufort, good visibility."), 5 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/hzzt-..bbrr...ghhk../"), 6 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Dongsan Bay, mild westerly winds, three Beaufort, good visibility. Boryeong Straits, strong westerly winds, six to seven Beaufort, average visibility."), 8 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Sanggyongpyong station shows stormy weather in the region. Finki Sea, average winds, south-westerly, four Beaufort. Poor visibility. Kuanhai Bay, calm winds, easterly, good visibility."), 12 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/bzzt-.../"), 16 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Changsan Archipelago, strong northerly winds, eight to nine Beaufort. Yamada Straits, storm, southerly, eleven Beaufort."), 18 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Mikkelsen Sea, moderate winds, south-southeasterly, five to six Beaufort. Wishing all Konyanger Mariners safety and luck."), 21 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/hkkkhhzzt.../"), 25 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Daiyuan Sea, calm, excellent visibility. Kamazuki Straits, mild winds, northerly."), 29 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "This was the Shipping Forecast for our nation's high seas, as issued by the Meteorological Office."), 33 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "The Navy Broadcasting Service would like to remind our listeners to stay safe."), 36 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, turn_off_broadcast)), 38 SECONDS, TIMER_STOPPABLE)

		if("warning")
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Stay safe, stay indoors. Follow all instructions issued by the National Disaster Authority. For Positronic Citizens: Remain indoors, solid materials weaken the viral signal."), 1 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Avoid usage of public chargers. Run regular diagnostics checks."), 5 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "If you experience symptoms, report your location to the KRC emergency number and seek immediate assistance."), 6 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Time is of the essence. If assistance is unavailable, try the following to prevent yourself from harming others:"), 8 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Lock yourself indoors. Strap yourself down or to a chair. If applicable: switch off locomotive functions."), 12 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Do not be afraid: You will be retrieved and repaired."), 16 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "For everyone else: report locations of suspicious or infected behavior to the KRC emergency number."), 18 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Do not attempt to restrain, attack or otherwise interfere with rampant Positronics."), 21 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/hkkkhhzzt.../"), 25 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Assist any Positronics with barricading their home or strapping them safely."), 29 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Keep in mind: Positronic friends and family members will not be able to recognise you if they are infected. Do not try to talk, reason or plead with them."), 33 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "The Konyang Robotics Corporation emergency number is 500-100-500."), 36 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "This is the Navy Broadcasting Service, at 73.2 MHz."), 39 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, turn_off_broadcast)), 41 SECONDS, TIMER_STOPPABLE)

		if("news")
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "You are now listening to the news."), 1 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "The secretive positronic collectivity \"Purpose\" has sparked great interest in the scientific community."), 5 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "If you experience symptoms, report your location to the KRC emergency number and seek immediate assistance."), 6 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Requests for a visit on board one of their vessels have been turned down."), 8 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "While appearing technologically superior to any known race in the Spur, there are assurances of peace and cooperation with our nation."), 12 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Contact with Purpose was first made in 2460, by a corporate vessel in Tau Ceti. Links between Purpose and the Aoyama Vaults speculated, though unconfirmed."), 16 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/hkkkhhzzt.../"), 18 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "KRC statistics report over ten hundred thousand daily cases. Ten thousand positronics per day making full recoveries. KRC crisis center network expanding in Shuzu, New Busan, Kangdong, Bupyeong, Onan, Mizukami, Yunfu."), 21 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "The 55th, 106th and 74th infantry divisions were ordered to deploy to enforce quarantine regulations in New Hong Kong."), 25 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Positronic service members confined in barracks pending KRC assessment throughout the Army and Navy."), 29 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/...khhbzzzt.../"), 33 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Konyang Aerospace Forces to intensify patrols in the Haneunim system to crack down on piracy and smuggling."), 36 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Foreign and Coalition countries have dispatched messages of support for our nation."), 39 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/bzzt-.../"), 42 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Prime Minister Myeong Myung-Dae has said that Konyang is not in need of external material assistance at this time."), 45 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "The Suwon Stock Exchange has entered a temporary pause of services in light of the viral outbreak. Finance Ministry urges calm."), 48 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/hkk..hkkk.../"), 49 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Severe storms hit the New Kowloon sea wall. Damages reported, but repairs are underway."), 53 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "In her address to the Yi Sun-sin Naval Academy, admiral Kim Ha-neul urged the new lieutenants to rise up to the difficult current circumstances."), 57 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Konyang Army medical personnel have completed training in confronting the new virus."), 60 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Severe storms hit the New Kowloon sea wall. Damages reported, but repairs are underway."), 63 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/hrrrhhkt.../"), 65 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "The Stellar Corporate Conglomerate's vessel Horizon has arrived in Haneunim to assist in combating the virus."), 67 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Chaos in Boryeong City's Han district, as five infected attack vehicles stopped in traffic. Two deaths, three injuries."), 69 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Remote areas of Konyang in additional danger due to distances and lack of supplies, says police."), 72 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Retired Commissioner General of Police Li Jincai recalled to service in advisory role."), 75 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "This is the Navy Broadcasting Service, at 73.2 MHz."), 79 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, turn_off_broadcast)), 80 SECONDS, TIMER_STOPPABLE)

		if("season")
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "The Meteorological Office has released the 2465-66 seasonal cycle."), 1 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "The cycle is based upon Qixi's orbital projections and meteorological projections."), 5 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Wet Season, starting November 17th, 2465, ending July 29th, 2466."), 6 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Flooding period, December 1st to January 27th, 2466."), 8 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/hzzt-..bbrr...ghhk../"), 12 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "High Tide period, January 28th to March 21st."), 16 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Highest Tide period, March 22nd to April 29th."), 18 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Ebbing High Tide period, April 30th to June 2nd."), 21 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Ebbing Flooding period, June 3rd to July 28th."), 25 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Dry Season, Ebbing period, July 29th to September 5th."), 29 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Low Tide period, September 6th to November 13th, 2466."), 33 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Projected highest average wave height during HT period, eight plus minus one meters."), 36 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, turn_off_broadcast)), 38 SECONDS, TIMER_STOPPABLE)

		if("donation")
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "This is the Navy Broadcasting Service, at 73.2 MHz."), 1 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Stay safe, stay indoors."), 5 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "A one million credit donation to the Navy Rapid Rescue Force by the PACHROM corporation was warmly welcomed by the Chief of Staff."), 6 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "A plan was released to provide funding for the renovation of 60 ambulance mechs."), 8 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Army and National Police vow to \"uproot lawlessness\" in the bandit-infested Boryeong coasts in 2466."), 12 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Foreign workers in KRC or other presently critical posts \"will not be forgotten\", says Prime Minister."), 16 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/hzzt-..bbrr...ghhk../"), 18 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Suwon Detention Center No.1 evacuated of its Positronic inmates due to fears of rampancy."), 21 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Army Signal Corps to install additional protective infrastructure around Point Verdant districts."), 25 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/bzzt-.../"), 29 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, turn_off_broadcast)), 30 SECONDS, TIMER_STOPPABLE)

		if("review")
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Warmest wishes from all the staff at the Navy Broadcasting Service."), 1 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Dam and hydroelectric station weather review."), 5 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Kichi Islands, very strong rain, eight Celcius to twelve Celcius."), 6 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Xinhe Islands, strong rain, nine Celcius to fourteen Celcius."), 8 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Dongsan Bay, strong rain, five Celcius to ten Celcius."), 12 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Sinpo Station, rain, seven Celcius to ten Celcius."), 16 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Hoko Station, very strong rain, five Celcius to eight Celcius."), 18 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/hzzt-..bbrr...ghhk../"), 21 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Qinghe Station, very strong rain, two Celcius to five Celcius. Storm warning."), 25 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Wishing all sea station workers safety and luck."), 29 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/hkk..hkkk.../"), 32 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, turn_off_broadcast)), 33 SECONDS, TIMER_STOPPABLE)

/datum/space_sector/haneunim/proc/do_konyang_pba_radio(var/obj/item/lore_radio/R)
	var/chosen_broadcast = pick("emergency", "energy", "truth", "poetry", "frank", "ads")
	R.broadcast = TRUE

	switch(chosen_broadcast)

		if("emergency")
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "This is the Public Broadcasting Agency, the voice of Konyang, broadcasting from Suwon."), 1 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/A solemn jingle used by the PBA./"), 5 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "You are now listening to the Public Broadcasting Agency, live from Suwon."), 6 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/The national anthem of Konyang./"), 8 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "This is a message from the Ministry of Health and Positronic Affairs. Emergency measures for Positronic persons in effect."), 12 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Stay indoors, remain calm, run regular diagnostics."), 16 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "...Suwon City, curfew 6 PM to 8 AM. Quarantine in Aoyama City, New Hong Kong City, Boryeong City..."), 18 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "And now, the news. A state-of-the-art KRC mobile hospital has opened in New Busan, servicing patients exclusively affected by the virus. One thousand personnel inbound."), 21 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Heated debates in Parliament over the inclusion of Positronic MPs in sessions. \"Let them holocall\" replied Shimazu."), 25 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Bank of Konyang investigation into new national currency instructed to continue despite outbreak. Idris Incorporated approached."), 29 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/bzzt-.../"), 33 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Bust of Shishi completed and revealed in Unity Square to mark the tenth year since the Positronic's death, the first recorded murder-hate crime."), 36 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Tau Ceti embassy's Positronic staff evacuated, replacements expected."), 39 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, turn_off_broadcast)), 40 SECONDS, TIMER_STOPPABLE)

		if("energy")
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/A solemn jingle used by the PBA./"), 1 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "This is the Public Broadcasting Agency, broadcasting from Suwon at 75.4 MHz."), 5 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Tired? We've all been there, what about a change? BAM! energy supplements! Available at pharmacies."), 6 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Mishi Sauces. Turn that bland moss gourmet with Mishi Sauces. New Salted Fish flavor out now."), 8 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Speed... comfort... safety. Langenfeld."), 12 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Stop running away from your luck! One in ten wins at the National Lottery! Grand Prize ten million credits!"), 16 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Ballet Theater of Boryeong. Plutonian Ballet-Traditional dances. Guest star Yuri Fyodorovich. Tickets out."), 18 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, turn_off_broadcast)), 19 SECONDS, TIMER_STOPPABLE)	

		if("truth")
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/A solemn jingle used by the PBA./"), 1 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/hrr-hrr...khhr.../"), 5 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "This is the Public Broadcasting Agency, broadcasting from Suwon at 75.4 MHz. Orbital broadcasting for the Haneunim system available."), 6 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Talking Truths, keeping you company every Thursday."), 8 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "This is a message from the Ministry of Environmental Affairs and Response to Calamities."), 12 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Rampancy outbreak emergency guidelines. If you come across an infected Positronic person, alert the authorities immediately."), 16 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Do not approach suspicious Positronic persons. Symptoms include a catatonic posture and off-tune audio responses."), 18 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Do not drive long distances without supplies."), 21 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Do not go into the jungles."), 25 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "The virus shuts down major cognitive functions, significantly increasing battery life. Always remain vigilant."), 29 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, turn_off_broadcast)), 30 SECONDS, TIMER_STOPPABLE)

		if("poetry")
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/A solemn jingle used by the PBA./"), 1 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Hayiaaaa! It's so hot! What are we supposed to do?! BreezePunch! The cold beverage to the rescue!"), 5 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "When Mister Xianma needed new neck oscillators, his KRC appointment had him wait two months. At Jogo Clinics, he was serviced the same day."), 6 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Grandma's moss broth has never been tastier, she uses Gwok SpiceCubes!"), 8 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Choson Ferries, safe global sea journeys. Choson Ferries."), 12 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Ajax insulation, for a house against the rain!"), 16 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Feeling drained? Go for a walk. Suwon parks society."), 18 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "And now, Poetry Corner. From the Public Broadcasting Agency."), 21 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/A short piece of traditional Konyanger instrumental music./"), 25 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Rainy season..."), 28 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "The choking clouds..."), 31 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Feeling of hope..."), 34 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Warmth of a thousand suns..."), 37 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/Two clicks./"), 40 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Maw of the monster..."), 42 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Retribution, the killer of life..."), 45 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/Three clicks./"), 47 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/hzzt-..bbrr...ghhk../"), 49 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/Three clicks./"), 51 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "When pain is all you feel..."), 53 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Remember this..."), 55 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "A mother's embrace..."), 57 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/Four clicks./"), 59 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "This was Poetry Corner."), 61 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, turn_off_broadcast)), 62 SECONDS, TIMER_STOPPABLE)

		if("frank")
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/A solemn jingle used by the PBA./"), 1 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Hello and welcome everyone to Frank Conversations, this is your host Woo-Chung."), 5 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Today we will be taking calls from our audience, on the subject of the outbreak."), 6 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/phone dial tone.../"), 8 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Hello? Can you hear us?"), 12 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/Yes? Hello./"), 16 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Hi, welcome on air. Do you have a story you would wish to share?"), 18 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/Yes, actually... I was wondering if anyone has seen my friend? IPC, about two meters tall, industrial./"), 21 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "What is your friend's name?"), 25 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/He always called himself Daehak. He disappeared last week-"), 29 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Where did they disappear from?"), 31 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/Saitama island, he works at the dam there, they don't know where he went after the shift./"), 34 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "It seems time's up for this call. I'm certain all PBA listeners will do our best."), 37 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "If anyone knows anything, please contact the police, or this station directly."), 40 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Let's move to our next caller."), 43 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/phone dial tone.../"), 46 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Hello? You are on air."), 49 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/Hi, PBA?/"), 52 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Yes indeed, you are on air."), 55 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/Great. Do you guys have any idea how I am supposed to go to work?/"), 58 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "What is the problem?"), 61 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/hhhkhhh-.../"), 64 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/The quarantine is the problem. I have to commute an hour to go to work. And now even that is impossible./"), 67 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Are you calling from Suwon? They are telling me there should be designated lanes where traffic is allowed."), 70 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/Yeah, but they are all clogged up. And my boss won't let us work from home./"), 73 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "They might have to. All major non-retail businesses must have that option."), 76 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/I don't get it, I'm not even an IPC, why can't they make a lane for humans only?/"), 79 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "The roadblocks are for everyone's safety. I am sure the police are doing their best."), 82 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/Well, their best is not enough./"), 85 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Anyways, that is all the time we had for that call."), 88 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "We will see you next time on Frank Conversations, broadcast live on PBA."), 91 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, turn_off_broadcast)), 92 SECONDS, TIMER_STOPPABLE)

		if("ads")
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/A solemn jingle used by the PBA./"), 1 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "This is the Public Broadcasting Agency, broadcasting from Suwon at 75.4 MHz."), 5 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Ah, gee, car broke down again? Express Service, call now at 866-941-008."), 6 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Fall all things house, Chipo Furniture has your back!"), 8 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Casino Hamki. Combine Luck and Luxury into an unforgetful experience. 21+ admittance only."), 12 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Fresh Fish, only at Otomo Fisheries. The best in Aoyama."), 16 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Jumbo Entertainment presents the new pAI-powered talking squid!"), 18 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/hrrr..bzzt-/"), 21 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Take a break, Milto's Chocolates."), 25 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Snacking time? What better than GWOK! Moist Chips?"), 29 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "At RealLife Insurances, you feel safe."), 33 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Get on the road with BigScooters!"), 36 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Shibata Motors new Kawono X5, unparalleled speed, unrivaled quality."), 39 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "/hkk..hkkk.../"), 41 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, relay_lore_radio), "Bullseye Records Suwon top 10 albums are now available!"), 44 SECONDS, TIMER_STOPPABLE)
			R.broadcasts_in_line += addtimer(CALLBACK(R, TYPE_PROC_REF(/obj/item/lore_radio, turn_off_broadcast)), 45 SECONDS, TIMER_STOPPABLE)

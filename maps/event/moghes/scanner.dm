/obj/item/device/scanner
	name = "biological analyzer"
	icon_state = "adv_spectrometer"
	item_state = "analyzer"
	desc = "A Zeng-Hu Pharmaceuticals proprietary biological scanner."
	desc_extended = "This is a new model of a Zeng-Hu classic, designed to analyze alien flora and fauna. Useful for providing data on the environmental conditions of an unexplored world."
	desc_info = "Simply click on a plant or animal to use this device. It will provide information on the biology and wellbeing of the life form, which can be used for wider assessment of ongoing conditions. Use it in-hand to print the most recent scan results. Certain turfs or other objects may also provide scan data. Data can be uploaded to the Zeng-Hu Analysis Terminal."
	origin_tech = list(TECH_BIO = 1)
	w_class = ITEMSIZE_SMALL
	obj_flags = OBJ_FLAG_CONDUCTABLE
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	matter = list(MATERIAL_ALUMINIUM = 30, MATERIAL_GLASS = 20)
	var/last_data
	var/form_title
	var/list/valid_types = list(
		/mob/living/simple_animal,
		/mob/living/carbon/human,
		/obj/structure/flora/grass/desert,
		/obj/structure/flora/tree/desert,
		/turf/simulated/floor/exoplanet/water/shallow/moghes
	)

/obj/item/device/scanner/proc/print_report_verb()
	set name = "Print Scan Report"
	set category = "Object"
	set src = usr

	if(usr.stat || usr.restrained() || usr.lying)
		return
	print_report(usr)

/obj/item/device/scanner/Topic(href, href_list)
	if(..())
		return
	if(href_list["print"])
		print_report(usr)

/obj/item/device/scanner/proc/print_report(var/mob/living/user)
	if(!last_data)
		to_chat(user, "There is no scan data to print.")
		return
	var/obj/item/paper/P = new /obj/item/paper(get_turf(src))
	P.set_content_unsafe("paper - [form_title]", "[last_data]")
	if(istype(user,/mob/living/carbon/human) && !(user.l_hand && user.r_hand))
		user.put_in_hands(P)
	user.visible_message("\The [src] spits out a piece of paper.")
	return

/obj/item/device/scanner/attack_self(mob/user as mob)
	print_report(user)
	return 0

/obj/item/device/scanner/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag) return

	if(!is_type_in_list(target, valid_types))
		to_chat(user, SPAN_WARNING("No scan data available on \the [target]!"))
		return
	var/scan = "Scan Result: \the [target]"
	form_title = scan

	if(istype(target, /mob/living/simple_animal))
		var/mob/living/simple_animal/M = target
		scan += "<br>Info: [M.desc]"
		scan += "<br>Sex: [pick("Male","Female")]"
		scan += "<br>Age: [rand(5-30)]"
		if(M.stat == DEAD)
			scan += "<br>Physical Analysis: This specimen is recently deceased."
		else if(M.health == M.maxHealth)
			scan += "<br>Physical Analysis: This specimen is showing signs of malnutrition and moderate radiation exposure. In addition, trace amounts of unidentified toxic material have been detected in the specimen's digestive tract."
		else if(M.health < M.maxHealth)
			scan += "<br>Physical Analysis: This specimen has suffered moderate wounds, and demonstrates signs of malnutrition and moderate radiation exposure. In addition, trace amounts of unidentified toxic material have been detected in the specimen's digestive tract."
		else if(M.health < M.maxHealth*0.5)
			scan += "<br>Physical Analysis: This specimen has suffered severe wounds, and demonstrates signs of malnutrition and moderate radiation exposure. In addition, trace amounts of unidentified toxic material have been detected in the specimen's digestive tract."
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = target
		if(H.mind && H.mind.assigned_role == "Moghresian Villager")
			scan += "<br>Info: An adult [H.gender] Unathi (U. Sapiens)."
			if(H.stat == DEAD)
				scan += "<br>Physical Analysis: This individual is recently deceased. Analysis shows signs indicating poisoning as the likely cause of death. Specific toxin is indeterminate without further scan."
			else
				scan += "<br>Physical Analysis: This individual appears to show signs of mild malnutrition, as well as low levels of radioactive exposure. Scans indicate low levels of exposure to unidentified toxic material."
		else if(H.faction == "deadguy")
			scan += "<br>Info: An adult [H.gender] Unathi (U. Sapiens)."
			scan += "<br>Physical Analysis: This individual is recently deceased. Analysis shows signs indicating poisoning as the likely cause of death. Specific toxin is indeterminate without further analysis."
		else
			to_chat(user, SPAN_WARNING("No scan data available on \the [target]!"))
			form_title = null
			return
	else
		switch(target.type)
			if(/obj/structure/flora/grass/desert)
				scan += "<br>Info: A sample of a native grass specimen, identified as originating from the planet Moghes. Consult Zeng-Hu arborial database for further information."
				scan += "<br>Botanical Analysis: Severe water deficiency for continued survival of native flora. Severe regional defoliation has already occured."
				scan += "<br>Projection: Ongoing defoliation projected to continue due to insufficient water levels."
			if(/obj/structure/flora/tree/desert)
				scan += "<br>Info: A native tree species of the planet Moghes. Consult Zeng-Hu arborial database for further information."
				scan += "<br>Botanical Analysis: Similar to Earth cacti, this specimen has evolved to survive in water-scarce environments. Soil nutrients below optimal levels. Signs of radioactive contamination detected. Recommend soil sample for further analysis."
				scan += "<br>Projection: Lack of soil nutrients and radiation exposure render specimen's long-term survival unlikely without intervention."
			if(/turf/simulated/floor/exoplanet/water/shallow/moghes)
				scan += "<br>Info: Water sample. pH of 7.2."
				scan += "<br>Analysis: Fresh water sample. Mineral sediment indicates likely subterranean source. Trace foreign elements detected. Recommend further analysis."
				scan += "<br>No signs of radioactive contamination detected. Trace foreign elements may render prolonged consumption toxic without purification."
	scan += "<br>Supply this data for analysis. Property of Zeng-Hu Pharmaceuticals."
	last_data = scan
	to_chat(user, SPAN_NOTICE("Scan complete."))
	playsound(loc, 'sound/machines/compbeep2.ogg', 25)

/obj/machinery/computer/terminal/scanner
	name = "\improper Zeng-Hu Analysis Terminal"
	desc = "A terminal designed to collect and process environmental data, often used by Zeng-Hu planetary survey teams. Bioscanner and survey probe reports, as well as various samples, papers, and data disks from the area, can be inserted into this terminal in order to collect a complete environmental survey of the region."
	desc_info = "There are many scannable and sampleable items within the Izilukh region. Though duplicate data can still be added, a more complete report will be provided if you bring a wide variety of samples. How thorough your exploration and research is will affect both the final result of the analysis, and the future of the humanitarian project. Explore, and see what you can find."
	icon_screen = "gyrotron_screen"
	icon_keyboard = "tech_key"
	var/scan_progress = 0
	var/list/scanned = list()

/obj/machinery/computer/terminal/scanner/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(stat & NOPOWER)
		. += "The screen is dark and unresponsive. It does not appear to have power."
	else if (scan_progress >= 100)
		. += "The screen reads 'Scan complete, press any key to print results."
	else
		. += "The screen reads 'Scan in progress: [scan_progress]%."

/obj/machinery/computer/terminal/scanner/attack_hand(mob/user)
	if(..())
		return
	if(stat & (NOPOWER|BROKEN))
		return
	if(scan_progress >= 100)
		to_chat(user, SPAN_NOTICE("\The [src] whirs, printing a report."))
		playsound(loc, 'sound/bureaucracy/print.ogg', 75, 1)
		print_report(user)
	else
		to_chat(user, SPAN_WARNING("\The [src] requires more data!"))

/obj/machinery/computer/terminal/scanner/attackby(obj/item/attacking_item, mob/user)
	var/firstscan = TRUE
	if(istype(attacking_item, /obj/item/paper))
		if(findtextEx(attacking_item.name, "Scan Result") ||  findtext(attacking_item.name, "survey report"))
			user.remove_from_mob(attacking_item)
			to_chat(user, SPAN_NOTICE("You insert \the [attacking_item] into \the [src]'s paper scanner'."))
			playsound(loc, 'sound/bureaucracy/scan.ogg', 75, 1)
			qdel(attacking_item)
			if(attacking_item.name in scanned)
				firstscan = FALSE
			else scanned += attacking_item.name
			if(firstscan)
				scan_progress += 5
				scan_progress = min(scan_progress, 100)
				to_chat(user, SPAN_NOTICE("New data added, scan progress increased to [scan_progress]%."))
			else
				scan_progress += 1
				scan_progress = min(scan_progress, 100)
				to_chat(user, SPAN_NOTICE("Duplicate data added, scan progress increased to [scan_progress]%."))
		else if(attacking_item.name == "Preliminary Survey Results")
			user.remove_from_mob(attacking_item)
			to_chat(user, SPAN_NOTICE("You insert \the [attacking_item] into \the [src]'s paper scanner'."))
			playsound(loc, 'sound/bureaucracy/scan.ogg', 75, 1)
			qdel(attacking_item)
			scanned += attacking_item.name
			scan_progress += 10
			scan_progress = min(scan_progress, 100)
			to_chat(user, SPAN_NOTICE("New data added, scan progress increased to [scan_progress]%."))

	else if(istype(attacking_item, /obj/item/reagent_containers/glass/beaker))
		if(!istype(attacking_item, /obj/item/reagent_containers/glass/beaker/vial))
			to_chat(user, SPAN_WARNING("\The [attacking_item] will not fit in \the [src]'s analysis port - it looks to be sized for a small vial."))
			return
		else
			to_chat(user, SPAN_NOTICE("You insert \the [attacking_item] into \the [src]'s analysis port."))
			playsound(loc, 'sound/machines/compbeep2.ogg', 25)
			if(!attacking_item.reagents?.total_volume)
				to_chat(user, SPAN_WARNING("\The [attacking_item] contains nothing for \the [src] to analyze! With a beep, it is ejected."))
				return
			else if(attacking_item.reagents.has_reagent(/singleton/reagent/water))
				user.remove_from_mob(attacking_item)
				qdel(attacking_item)
				if("Water" in scanned)
					firstscan = FALSE
				else scanned += "Water"
				if(firstscan)
					scan_progress += 10
					scan_progress = min(scan_progress, 100)
					to_chat(user, SPAN_NOTICE("Water sample added to database, scan process increased to [scan_progress]%."))
				else
					scan_progress += 2
					scan_progress = min(scan_progress, 100)
					to_chat(user, SPAN_NOTICE("Secondary water sample added to database, scan progress increased to [scan_progress]%."))
			else
				to_chat(user, SPAN_WARNING("Invalid reagent sample. No scan data added."))
				return
	else if(istype(attacking_item, /obj/item/rocksliver))
		user.remove_from_mob(attacking_item)
		to_chat(user, SPAN_NOTICE("You insert \the [attacking_item] into \the [src]'s analysis port."))
		playsound(loc, 'sound/machines/compbeep2.ogg', 25)
		qdel(attacking_item)
		if("Rock" in scanned)
			firstscan = FALSE
		else scanned += "Rock"
		if(firstscan)
			scan_progress += 10
			scan_progress = min(scan_progress, 100)
			to_chat(user, SPAN_NOTICE("Geological sample added to database, scan process increased to [scan_progress]%."))
		else
			scan_progress += 2
			scan_progress = min(scan_progress, 100)
			to_chat(user, SPAN_NOTICE("Additional geologial sample added to database, scan progress increased to [scan_progress]%."))
	else if(istype(attacking_item, /obj/item/disk/mcguffin1))
		user.remove_from_mob(attacking_item)
		to_chat(user, SPAN_NOTICE("You insert \the [attacking_item] into \the [src]'s disk tray."))
		qdel(attacking_item)
		if("Disk1" in scanned)
			to_chat(user, SPAN_WARNING("The terminal displays an error - this data has already been processed. Further analysis will be of no use."))
		else
			scanned += "Disk1"
			scan_progress += 30
			scan_progress = min(scan_progress, 100)
			playsound(loc, 'sound/machines/compbeep2.ogg', 25)
			to_chat(user, SPAN_NOTICE("Federation data copied to database, scan progress increased to [scan_progress]%."))
	else if(istype(attacking_item, /obj/item/disk/mcguffin2))
		user.remove_from_mob(attacking_item)
		to_chat(user, SPAN_NOTICE("You insert \the [attacking_item] into \the [src]'s disk tray."))
		qdel(attacking_item)
		if("Disk2" in scanned)
			to_chat(user, SPAN_WARNING("The terminal displays an error - this data has already been processed. Further analysis will be of no use."))
		else
			scanned += "Disk2"
			scan_progress += 20
			scan_progress = min(scan_progress, 100)
			playsound(loc, 'sound/machines/compbeep2.ogg', 25)
			to_chat(user, SPAN_NOTICE("Data decrypted - operations log of the Izilukh water purification sysetm. Scan progress increased to [scan_progress]%."))
	else
		to_chat(user, SPAN_WARNING("\The [src] cannot gain any useful data from \the [attacking_item]."))

/obj/machinery/computer/terminal/scanner/proc/print_report(mob/user)
	if(scan_progress < 100)
		return
	var/output = "\[center\]\[logo_zh\]\[/center\]\
		\[center\]\[b\]\[i\]Environmental Analysis Report Summary\[/b\]\[/i\]\[hr\]\
		Environmental analysis of the Izilukh region indicates severe ecological damage. Increased aridity has caused mass defoliation, negatively impacting local herbivore populations. Radiation remans a present risk, in addition to the food scarcity brought about by this ecological collapse.\[br\]\
		Atmospheric fallout levels are consistent with general analysis of nuclear-affected biomes. Though habitable, long-term exposure could result in a higher than average risk of radiation-related illness.\[br\]"
	if(("Water" in scanned) || ("Disk2" in scanned))
		output += "\[br\]Hydrological data from the Izilukh aquifer indicates that the water largely remains clear of radioactive sediment. Minor traces of phoron leakage in the water will require purification - however, should this be accomplished then transplanting Ouerean subterranean fish species could provide a long-term food supply for the town.\[br\]"
	if("Disk1" in scanned)
		output += "\[br\]The Federation report provides comprehensive information on the region's ecology, and details several specific steps which could be taken to revitalise the region. Most of these would require extensive material and financial investment from the Hegemony, and the full cooperation of all local authorities across the northern Zazalais.\[br\]"
	if("Rock" in scanned)
		output += "\[br\]Mineral analysis indicates large uranium ore deposits are still present within the nearby mountains. Due to the general condition of the town, re-opening the mines will likely be infeasible for years.\[br\]"
	output += "\[br\]Overall conclusion: Ecological damage to the region is catastrophic. Intervention on a wide scale throughout the region is required in order to sustain settlement in the region - however, should intervention on this scale be undertaken there remains a high probability that Izilukh will be able to sustain itself. If the Hegemony's full plans for the restoration project succeed, Izilukh will likely be instrumental in achieving its aims in the Zazalais. Full data has been transmitted to the SCCV Horizon central database."

	var/obj/item/paper/P = new /obj/item/paper(get_turf(user))
	user.put_in_hands(P)
	P.set_content("Izilukh Region Environmental Analysis",output)

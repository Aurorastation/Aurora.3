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
	var/list/valid_types = list()

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
				scan += "<br>Analysis: Fresh water sample. Mineral sediment indicates likely subterranean source. Trace foreign elements detected. Recommend provdng sample for further analysis."
				scan += "<br>Info: No signs of radioactive contamination detected. Trace foreign elements may render prolonged consumption toxic without purification."
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

/obj/machinery/computer/terminal/scanner/proc/print_report()

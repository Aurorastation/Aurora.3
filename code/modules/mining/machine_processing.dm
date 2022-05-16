/obj/machinery/mineral
	var/id //used for linking machines to consoles

/**********************Mineral processing unit console**************************/

/obj/machinery/mineral/processing_unit_console
	name = "ore redemption console"
	desc = "A handy console which can be use to retrieve mining points for use in the mining vendor, or to set processing values for various ore types."
	desc_info = "Up to date settings for the refinery can be found in the Aurorastation Guide to Mining wikipage."
	icon = 'icons/obj/terminals.dmi'
	icon_state = "production_console"
	density = FALSE
	anchored = TRUE
	idle_power_usage = 15
	active_power_usage = 50

	var/obj/machinery/mineral/processing_unit/machine
	var/show_all_ores = FALSE
	var/points = 0
	var/datum/weakref/scanned_id

	var/list/ore/input_mats = list()
	var/list/material/output_mats = list()
	var/list/datum/alloy/alloy_mats = list()
	var/waste = 0
	var/idx = 0

	component_types = list(
		/obj/item/circuitboard/redemption_console,
		/obj/item/stock_parts/scanning_module,
		/obj/item/stock_parts/console_screen
	)

/obj/machinery/mineral/processing_unit_console/Initialize(mapload, d, populate_components)
	. = ..()
	var/mutable_appearance/screen_overlay = mutable_appearance(icon, "production_console-screen", EFFECTS_ABOVE_LIGHTING_LAYER)
	add_overlay(screen_overlay)
	set_light(1.4, 1, COLOR_CYAN)

/obj/machinery/mineral/processing_unit_console/Destroy()
	if(machine)
		machine.console = null
	return ..()

/obj/machinery/mineral/processing_unit_console/proc/setup_machine(mob/user)
	if(!machine)
		var/area/A = get_area(src)
		var/best_distance = INFINITY
		for(var/obj/machinery/mineral/processing_unit/checked_machine in SSmachinery.machinery)
			if(id)
				if(checked_machine.id == id)
					machine = checked_machine
			else if(!checked_machine.console && A == get_area(checked_machine) && get_dist_euclidian(checked_machine, src) < best_distance)
				machine = checked_machine
				best_distance = get_dist_euclidian(checked_machine, src)
		if(machine)
			machine.console = src
		else
			to_chat(user, SPAN_WARNING("ERROR: Linked machine not found!"))

	return machine

/obj/machinery/mineral/processing_unit_console/attackby(obj/item/I, mob/user)
	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return
	if(default_part_replacement(user, I))
		return
	return ..()

/obj/machinery/mineral/processing_unit_console/attack_hand(mob/user)
	add_fingerprint(user)
	if(!scanned_id)
		get_user_id(user)
	else
		var/obj/item/card/id/ID = scanned_id.resolve()
		if(!ID)
			scanned_id = null
			get_user_id(user)
		else
			var/turf/id_turf = get_turf(ID)
			if(!id_turf.Adjacent(loc))
				scanned_id = null
				get_user_id(user)
	interact(user)

/obj/machinery/mineral/processing_unit_console/proc/get_user_id(var/mob/user)
	if(isDrone(user))
		var/mob/living/silicon/robot/drone/D = user
		if(D.standard_drone)
			return
	if(!scanned_id)
		var/obj/item/card/id/ID = user.GetIdCard()
		if(ID)
			scanned_id = WEAKREF(ID)

/obj/machinery/mineral/processing_unit_console/interact(mob/user)
	if(..())
		return

	if(!setup_machine(user))
		return

	user.set_machine(src)

	var/dat = "<h1>Ore processor console</h1>"

	dat += "Current unclaimed points: [points]<br>"

	var/obj/item/card/id/ID = scanned_id.resolve()
	if(ID)
		dat += "You have [ID.mining_points] mining points collected. <A href='?src=\ref[src];choice=eject'>Eject ID.</A><br>"
		dat += "<A href='?src=\ref[src];choice=claim'>Claim points.</A><br>"
		dat += "<A href='?src=\ref[src];choice=print_report'>Print yield declaration.</A><br>"
	else
		dat += "No ID inserted.  <A href='?src=\ref[src];choice=insert'>Insert ID.</A><br>"

	dat += "<hr><table>"

	for(var/ore in machine.ores_processing)

		if(!machine.ores_stored[ore] && !show_all_ores)
			continue
		var/ore/O = ore_data[ore]
		if(!O)
			continue
		dat += "<tr><td width = 40><b>[capitalize(O.display_name)]</b></td><td width = 30>[machine.ores_stored[ore]]</td><td width = 100>"
		if(machine.ores_processing[ore])
			switch(machine.ores_processing[ore])
				if(0)
					dat += "<span class='warning'>not processing</span>"
				if(1)
					dat += "<font color='orange'>smelting</font>"
				if(2)
					dat += "<span class='notice'>compressing</span>"
				if(3)
					dat += "<font color='gray'>alloying</font>"
		else
			dat += "<span class='warning'>not processing</span>"
		dat += ".</td><td width = 30><a href='?src=\ref[src];toggle_smelting=[ore]'>\[change\]</a></td></tr>"

	dat += "</table><hr>"
	dat += "Currently displaying [show_all_ores ? "all ore types" : "only available ore types"]. <A href='?src=\ref[src];toggle_ores=1'>\[[show_all_ores ? "show less" : "show more"]\]</a></br>"
	dat += "The ore processor is currently <A href='?src=\ref[src];toggle_power=1'>[(machine.active ? "<font color='green'>processing</font>" : "<font color='red'>disabled</font>")]</a>."

	var/datum/browser/processor_win = new(user, "processor_console", capitalize_first_letters(name))
	processor_win.set_content(dat)
	processor_win.open()

/obj/machinery/mineral/processing_unit_console/Topic(href, href_list)
	if(..())
		return TRUE
	usr.set_machine(src)
	src.add_fingerprint(usr)

	if(href_list["choice"])
		var/obj/item/card/id/ID = scanned_id.resolve()
		if(ID)
			if(href_list["choice"] == "eject")
				scanned_id = null
			if(href_list["choice"] == "claim")
				if(access_mining_station in ID.access)
					if(points >= 0)
						ID.mining_points += points
						if(points != 0)
							ping("\The [src] pings, \"Point transfer complete! Transaction total: [points] points!\"")
						points = 0
					else
						to_chat(usr, SPAN_WARNING("[station_name()]'s mining division is currently indebted to NanoTrasen. Transaction incomplete until debt is cleared."))
				else
					to_chat(usr, SPAN_WARNING("Required access not found."))
			if(href_list["choice"] == "print_report")
				if(access_mining_station in ID.access)
					print_report(usr)
				else
					to_chat(usr, SPAN_WARNING("Required access not found."))

		else if(href_list["choice"] == "insert")
			var/obj/item/card/id/I = usr.get_active_hand()
			if(istype(I))
				scanned_id = WEAKREF(I)

	if(href_list["toggle_smelting"])
		var/choice = input("What setting do you wish to use for processing [href_list["toggle_smelting"]]?") as null|anything in list("Smelting","Compressing","Alloying","Nothing")
		if(!choice)
			return

		switch(choice)
			if("Nothing")
				choice = 0
			if("Smelting")
				choice = 1
			if("Compressing")
				choice = 2
			if("Alloying")
				choice = 3

		machine.ores_processing[href_list["toggle_smelting"]] = choice

	if(href_list["toggle_power"])

		machine.active = !machine.active
		if(machine.active)
			machine.icon_state = "furnace"
		else
			machine.icon_state = "furnace-off"

	if(href_list["toggle_ores"])
		show_all_ores = !show_all_ores

	src.updateUsrDialog()
	return

/obj/machinery/mineral/processing_unit_console/proc/print_report(var/mob/living/user)
	var/obj/item/card/id/ID = scanned_id.resolve()
	if(!ID)
		to_chat(user, SPAN_WARNING("No ID inserted. Cannot digitally sign."))
		return
	if(!input_mats.len && !output_mats.len && !alloy_mats)
		to_chat(user, SPAN_WARNING("There is no data to print."))
		return
	if(printing)
		return

	printing = TRUE

	var/obj/item/paper/P = new /obj/item/paper(get_turf(src))
	var/date_string = worlddate2text()
	idx++

	var/form_title = "Form 0600 - Mining Yield Declaration"
	var/dat = "<small><center><b>Stellar Corporate Conglomerate<br>"
	dat += "Operations Department</b><br><br>"

	dat += "Form 0600<br> Mining Yield Declaration</center><hr>"
	dat += "Facility: [current_map.station_name]<br>"
	dat += "Date: [date_string]<br>"
	dat += "Index: [idx]<br><br>"

	dat += "Miner(s): <span class=\"paper_field\"></span><br>"
	dat += "Ore Yields: <br>"

	dat += "<table>"

	for(var/material/OM in output_mats)
		if(output_mats[OM] > 1)
			dat += "<tr><td><b><small>[output_mats[OM]]</b></small></td><td><small>[OM.display_name] [OM.sheet_plural_name]</small></td></tr>"
		else
			dat += "<tr><td><b><small>[output_mats[OM]]</b></small></td><td><small>[OM.display_name] [OM.sheet_singular_name]</small></td></tr>"

		CHECK_TICK

	for(var/datum/alloy/AM in alloy_mats)
		if(alloy_mats[AM] > 1)
			dat += "<tr><td><b><small>[alloy_mats[AM]]</b></td><td><small>[AM.metaltag] sheets</small></td></tr>"
		else
			dat += "<tr><td><b><small>[alloy_mats[AM]]</b></td><td><small>[AM.metaltag] sheet</small></td></tr>"

		CHECK_TICK

	dat += "</table><br>"

	if(waste > 0)
		dat += "Waste detected: "
		dat += "[waste] unit(s) of material were wasted due to operator error. This includes: <br>"
		dat += "<table>"
		for(var/ore/IM in input_mats)
			if(input_mats[IM] > 1)
				dat += "<tr><td><b><small>[input_mats[IM]]</small></b></td><td><small>[IM.display_name]</small></td></tr>"
			else
				dat += "<tr><td><b><small>[input_mats[IM]]</small></b></td><td><small>[IM.display_name]</small></td></tr>"

			CHECK_TICK

		dat += "</table><br>"

	dat += "Additional Notes: <span class=\"paper_field\"></span><br><br>"

	dat += "Operations Manager's / Captain's Stamp: </small>"

	P.set_content(form_title, dat)

	//stamp the paper
	var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
	stampoverlay.icon_state = "paper_stamp-cent"
	if(!P.stamped)
		P.stamped = new
	P.offset_x += 0
	P.offset_y += 0
	P.ico += "paper_stamp-cent"
	P.stamped += /obj/item/stamp
	P.add_overlay(stampoverlay)
	P.stamps += "<HR><i>This paper has been stamped by the SCC Ore Processing System.</i>"

	user.visible_message("\The [src] rattles and prints out a sheet of paper.")
	playsound(get_turf(src), "sound/bureaucracy/print_short.ogg", 50, 1)

	// reset
	output_mats = list()
	input_mats = list()
	waste = 0

	if(user.Adjacent(src))
		user.put_in_hands(P)

	printing = FALSE
	return

/**********************Mineral processing unit**************************/


/obj/machinery/mineral/processing_unit
	name = "industrial smelter" //This isn't actually a goddamn furnace, we're in space and it's processing platinum and flammable phoron... //lol fuk u bay it is //i'm gay // based and redpilled
	desc = "A large smelter and compression machine which heats up ore, then applies the process specified within the ore redemption console, outputting the result to the other side."
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "furnace-off"
	density = TRUE
	anchored = TRUE
	light_range = 3
	var/turf/input
	var/turf/output
	var/obj/machinery/mineral/processing_unit_console/console
	var/sheets_per_tick = 20
	var/list/ores_processing[0]
	var/list/ores_stored[0]
	var/static/list/alloy_data
	var/active = 0
	idle_power_usage = 15
	active_power_usage = 150

	component_types = list(
			/obj/item/circuitboard/refiner,
			/obj/item/stock_parts/capacitor = 2,
			/obj/item/stock_parts/scanning_module,
			/obj/item/stock_parts/micro_laser = 2,
			/obj/item/stock_parts/matter_bin
		)

/obj/machinery/mineral/processing_unit/Initialize()
	. = ..()

	// initialize static alloy_data list
	if(!alloy_data)
		alloy_data = list()
		for(var/alloytype in subtypesof(/datum/alloy))
			alloy_data += new alloytype()

	for(var/O in ore_data)
		ores_processing[O] = 0
		ores_stored[O] = 0

	//Locate our output and input machinery.
	for(var/dir in cardinal)
		var/input_spot = locate(/obj/machinery/mineral/input, get_step(src, dir))
		if(input_spot)
			input = get_turf(input_spot) // thought of qdeling the spots here, but it's useful when rebuilding a destroyed machine
			break
	for(var/dir in cardinal)
		var/output_spot = locate(/obj/machinery/mineral/output, get_step(src, dir))
		if(output)
			output = get_turf(output_spot)
			break

	if(!input)
		input = get_step(src, reverse_dir[dir])
	if(!output)
		output = get_step(src, dir)

/obj/machinery/mineral/processing_unit/Destroy()
	if(console)
		console.machine = null
	return ..()

/obj/machinery/mineral/processing_unit/attackby(obj/item/I, mob/user)
	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return
	if(default_part_replacement(user, I))
		return
	return ..()


/obj/machinery/mineral/processing_unit/process()
	..()

	if(!src.output || !src.input)
		return

	var/list/tick_alloys = list()

	//Grab some more ore to process this tick.
	for(var/i = 0, i < sheets_per_tick, i++)
		var/obj/item/ore/O = locate() in input
		if(!O)
			break
		if(!isnull(ores_stored[O.material]))
			ores_stored[O.material] = ores_stored[O.material] + 1

		qdel(O)

	if(!active)
		if(icon_state != "furnace-off")
			icon_state = "furnace-off"
		return

	//Process our stored ores and spit out sheets.
	var/sheets = 0
	for(var/metal in ores_stored)
		if(sheets >= sheets_per_tick)
			break

		if(ores_stored[metal] > 0 && ores_processing[metal] != 0)
			var/ore/O = ore_data[metal]
			if(!O)
				continue

			if(ores_processing[metal] == 3 && O.alloy) //Alloying.
				for(var/datum/alloy/A in alloy_data)
					if(A.metaltag in tick_alloys)
						continue

					tick_alloys += A.metaltag
					var/enough_metal

					if(!isnull(A.requires[metal]) && ores_stored[metal] >= A.requires[metal]) //We have enough of our first metal, we're off to a good start.

						enough_metal = TRUE

						for(var/needs_metal in A.requires)
							//Check if we're alloying the needed metal and have it stored.
							if(ores_processing[needs_metal] != 3 || ores_stored[needs_metal] < A.requires[needs_metal])
								enough_metal = FALSE
								break

					if(!enough_metal)
						continue
					else
						var/total
						for(var/needs_metal in A.requires)
							if(console)
								var/ore/Ore = ore_data[needs_metal]
								console.points += Ore.worth
							use_power_oneoff(100)
							ores_stored[needs_metal] -= A.requires[needs_metal]
							total += A.requires[needs_metal]
							total = max(1, round(total * A.product_mod)) //Always get at least one sheet.
							sheets += total - 1

						for(var/i = 0, i < total, i++)
							if(console)
								console.alloy_mats[A] = console.alloy_mats[A] + 1
							new A.product(output)

			else if(ores_processing[metal] == 2 && O.compresses_to) //Compressing.
				var/can_make = Clamp(ores_stored[metal], 0, sheets_per_tick - sheets)
				if(can_make % 2 > 0)
					can_make--

				var/material/M = SSmaterials.get_material_by_name(O.compresses_to)

				if(!istype(M) || !can_make || ores_stored[metal] < 1)
					continue

				for(var/i = 0, i < can_make, i += 2)
					if(console)
						console.points += O.worth * 2
					use_power_oneoff(100)
					ores_stored[metal] -= 2
					sheets += 2
					console.output_mats[M] += 1
					new M.stack_type(output)

			else if(ores_processing[metal] == 1 && O.smelts_to) //Smelting.
				var/can_make = Clamp(ores_stored[metal], 0, sheets_per_tick - sheets)

				var/material/M = SSmaterials.get_material_by_name(O.smelts_to)
				if(!istype(M) || !can_make || ores_stored[metal] < 1)
					continue

				for(var/i = 0, i < can_make, i++)
					if(console)
						console.points += O.worth
					use_power_oneoff(100)
					ores_stored[metal] -= 1
					sheets++
					if(console)
						console.output_mats[M] += 1
					new M.stack_type(output)
			else
				if(console)
					console.points -= O.worth * 3 //reee wasting our materials!
				use_power_oneoff(500)
				ores_stored[metal] -= 1
				sheets++
				if(console)
					console.input_mats[O] += 1
					console.waste++
				new /obj/item/ore/slag(output)
		else
			continue

	if(console)
		console.updateUsrDialog()

/obj/machinery/mineral/processing_unit/RefreshParts()
	..()
	var/scan_rating = 0
	var/cap_rating = 0
	var/laser_rating = 0

	for(var/obj/item/stock_parts/P in component_parts)
		if(isscanner(P))
			scan_rating += P.rating
		else if(iscapacitor(P))
			cap_rating += P.rating
		else if(ismicrolaser(P))
			laser_rating += P.rating

	sheets_per_tick += scan_rating + cap_rating + laser_rating

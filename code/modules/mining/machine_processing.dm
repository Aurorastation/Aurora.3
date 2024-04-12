//Modes the smelter can work with, bitflags
#define SMELTER_MODE_IDLE BITFLAG(0)
#define SMELTER_MODE_ALLOYING BITFLAG(1)
#define SMELTER_MODE_COMPRESSING BITFLAG(2)
#define SMELTER_MODE_SMELTING BITFLAG(3)

/obj/machinery/mineral
	var/id //used for linking machines to consoles

/**********************Mineral processing unit console**************************/

/obj/machinery/mineral/processing_unit_console
	name = "ore redemption console"
	desc = "A handy console which can be use to retrieve mining points for use in the mining vendor, or to set processing values for various ore types."
	desc_info = "Up to date settings for the refinery can be found in the Aurorastation Guide to Mining wikipage."
	icon = 'icons/obj/machinery/wall/terminals.dmi'
	icon_state = "production_console"
	density = FALSE
	anchored = TRUE
	idle_power_usage = 15
	active_power_usage = 50

	var/obj/machinery/mineral/processing_unit/machine
	var/show_all_ores = TRUE
	var/points = 0

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

	return INITIALIZE_HINT_LATELOAD

/obj/machinery/mineral/processing_unit_console/LateInitialize()
	. = ..()
	setup_machine()

/obj/machinery/mineral/processing_unit_console/Destroy()
	if(machine)
		machine.console = null
	return ..()

/obj/machinery/mineral/processing_unit_console/proc/handle_machine_deletion()
	SIGNAL_HANDLER
	machine = null

/obj/machinery/mineral/processing_unit_console/proc/setup_machine(mob/user)
	if(!machine)
		var/area/A = get_area(src)
		var/best_distance = INFINITY
		for(var/obj/machinery/mineral/processing_unit/checked_machine in SSmachinery.machinery)
			if(id)
				if(checked_machine.id == id)
					machine = checked_machine
					break //We only link with one, no point continuing if it's ID based

			else if(!checked_machine.console && A == get_area(checked_machine) && get_dist(checked_machine, src) < best_distance)
				machine = checked_machine
				best_distance = get_dist(checked_machine, src)

		if(machine)
			machine.link_console(src)
			RegisterSignal(machine, COMSIG_QDELETING, PROC_REF(handle_machine_deletion))

		else
			to_chat(user, SPAN_WARNING("ERROR: Linked machine not found!"))

	return machine

/obj/machinery/mineral/processing_unit_console/attackby(obj/item/attacking_item, mob/user)
	if(default_deconstruction_screwdriver(user, attacking_item))
		return
	if(default_deconstruction_crowbar(user, attacking_item))
		return
	if(default_part_replacement(user, attacking_item))
		return
	return ..()

/obj/machinery/mineral/processing_unit_console/attack_hand(mob/user)
	add_fingerprint(user)
	if(!setup_machine(user))
		return
	ui_interact(user)

/obj/machinery/mineral/processing_unit_console/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MiningProcessor", "Ore Redemption Console", ui_x=500, ui_y=575)
		ui.autoupdate = FALSE
		ui.open()

/obj/machinery/mineral/processing_unit_console/ui_data(mob/user)
	var/list/data = list()
	var/obj/item/card/id/ID = user.GetIdCard()
	if(ID)
		data["hasId"] = TRUE
		data["miningPoints"] = ID.mining_points ? ID.mining_points : 0
	else
		data["hasId"] = FALSE

	data["enabled"] = machine.active
	data["points"] = points
	data["showAllOres"] = show_all_ores

	var/list/ore_list = list()
	for(var/ore in machine.ores_processing)
		if(!machine.ores_stored[ore] && !show_all_ores)
			continue
		var/ore/O = GLOB.ore_data[ore]
		if(!O)
			continue
		var/processing_type = ""
		switch(machine.ores_processing[ore]) //Yes we could use bitflags, but I don't care enough about it here
			if(SMELTER_MODE_IDLE)
				processing_type = "Idle"
			if(SMELTER_MODE_SMELTING)
				processing_type = "Smelt"
			if(SMELTER_MODE_COMPRESSING)
				processing_type = "Compress"
			if(SMELTER_MODE_ALLOYING)
				processing_type = "Alloy"
		ore_list += list(list("name" = capitalize_first_letters(O.display_name), "processing" = processing_type, "stored" = machine.ores_stored[ore], "ore" = ore))
	data["oreList"] = ore_list
	return data

/obj/machinery/mineral/processing_unit_console/ui_act(action, params)
	if(..())
		return TRUE

	if(action == "choice")
		var/obj/item/card/id/ID = usr.GetIdCard()
		if(ID)
			if(params["choice"] == "claim")
				if(points >= 0)
					ID.mining_points += points
					if(points != 0)
						ping("<b>\The [src]</b> pings, \"Point transfer complete! Transaction total: [points] points!\"")
					points = 0
				else
					ping("<b>\The [src]</b> pings, \"Transaction failed due to a negative point value. No transaction can be done until this value has returned to a positive one.\"")
			if(params["choice"] == "print_report")
				print_report(usr)
		return TRUE

	if(action == "toggle_smelting")
		var/ore_name = params["toggle_smelting"]

		var/choice = tgui_input_list(usr, "What setting do you wish to use for processing [ore_name]?", "Processing", list("Smelting", "Compressing", "Alloying", "Nothing"))
		if(!choice)
			return TRUE

		switch(choice)
			if("Nothing")
				choice = SMELTER_MODE_IDLE
			if("Smelting")
				choice = SMELTER_MODE_SMELTING
			if("Compressing")
				choice = SMELTER_MODE_COMPRESSING
			if("Alloying")
				choice = SMELTER_MODE_ALLOYING

		machine.ores_processing[ore_name] = choice
		return TRUE

	if(action == "toggle_power")
		machine.active = !machine.active
		if(machine.active)
			machine.icon_state = "furnace"
		else
			machine.icon_state = "furnace-off"
		return TRUE

	if(action == "toggle_ores")
		show_all_ores = !show_all_ores
		return TRUE

/obj/machinery/mineral/processing_unit_console/proc/print_report(var/mob/living/user)
	var/obj/item/card/id/ID = user.GetIdCard()
	if(!ID)
		to_chat(user, SPAN_WARNING("No ID detected. Cannot digitally sign."))
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
	dat += "Facility: [SSatlas.current_map.station_name]<br>"
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
	playsound(get_turf(src), 'sound/bureaucracy/print_short.ogg', 50, 1)

	// reset
	output_mats = list()
	input_mats = list()
	waste = 0

	if(user.Adjacent(src))
		user.put_in_hands(P)

	printing = FALSE
	return

/**********************Mineral processing unit**************************/

/**
 * A list containing alloy data, initialized only once by the first `/obj/machinery/mineral/processing_unit` that initializes
 */
GLOBAL_LIST_EMPTY_TYPED(alloy_data, /datum/alloy)

/obj/machinery/mineral/processing_unit
	name = "industrial smelter" //This isn't actually a goddamn furnace, we're in space and it's processing platinum and flammable phoron... //lol fuk u bay it is //i'm gay // based and redpilled
	desc = "A large smelter and compression machine which heats up ore, then applies the process specified within the ore redemption console, outputting the result to the other side."
	icon = 'icons/obj/machinery/mining_machines.dmi'
	icon_state = "furnace-off"
	density = TRUE
	anchored = TRUE
	light_range = 3
	var/turf/input
	var/turf/output

	///The ore redemption console that is linked to us
	var/obj/machinery/mineral/processing_unit_console/console

	///How many sheets in a second this smelter can make (more or less, rounded up depending on ticklag)
	var/sheets_per_second = 50

	/**
	 * An associative list
	 *
	 * Key is a string, representing the ore name (eg. uranium, diamond, gold)
	 *
	 * Value is a bitflag, representing the operation mode for said ore, see `SMELTER_MODE_*` defines
	 */
	var/list/ores_processing[0]

	/**
	 * An associative list
	 *
	 * Key is a string, representing the ore name (eg. uranium, diamond, gold)
	 *
	 * Value is a number, representing how many ores are stored in the device for said ore type
	 */
	var/list/ores_stored[0]

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

	// initialize static alloy_data list, if it's not already initialized
	if(!length(GLOB.alloy_data))
		for(var/alloytype in subtypesof(/datum/alloy))
			GLOB.alloy_data += new alloytype()

	for(var/O in GLOB.ore_data)
		ores_processing[O] = SMELTER_MODE_IDLE
		ores_stored[O] = 0

	return INITIALIZE_HINT_LATELOAD


/obj/machinery/mineral/processing_unit/LateInitialize()
	. = ..()

	//Locate our output and input machinery.
	for(var/dir in GLOB.cardinal)
		var/input_spot = locate(/obj/machinery/mineral/input, get_step(src, dir))
		if(input_spot)
			input = get_turf(input_spot) // thought of qdeling the spots here, but it's useful when rebuilding a destroyed machine
			break
	for(var/dir in GLOB.cardinal)
		var/output_spot = locate(/obj/machinery/mineral/output, get_step(src, dir))
		if(output)
			output = get_turf(output_spot)
			break

	if(!input)
		input = get_step(src, GLOB.reverse_dir[dir])
	if(!output)
		output = get_step(src, dir)

/obj/machinery/mineral/processing_unit/Destroy()
	if(console)
		console.machine = null
	return ..()

/obj/machinery/mineral/processing_unit/proc/link_console(obj/machinery/mineral/processing_unit_console/console_to_link)
	if(console)
		UnregisterSignal(console, COMSIG_QDELETING)
		console = null

	console = console_to_link
	RegisterSignal(console, COMSIG_QDELETING, PROC_REF(handle_console_deletion))

/obj/machinery/mineral/processing_unit/proc/handle_console_deletion()
	SIGNAL_HANDLER

	console = null

/obj/machinery/mineral/processing_unit/attackby(obj/item/attacking_item, mob/user)
	if(default_deconstruction_screwdriver(user, attacking_item))
		return
	if(default_deconstruction_crowbar(user, attacking_item))
		return
	if(default_part_replacement(user, attacking_item))
		return
	return ..()


/obj/machinery/mineral/processing_unit/process(seconds_per_tick)
	..()

	if(!src.output || !src.input)
		return

	var/list/tick_alloys = list()

	//Grab some more ore to process this tick.
	for(var/_ in 1 to ROUND_UP(sheets_per_second*seconds_per_tick))
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
		if(src.stat & NOPOWER)
			return

		if(TICK_CHECK)
			return

		if(sheets >= ROUND_UP(sheets_per_second*seconds_per_tick))
			break

		if(ores_stored[metal] > 0 && ores_processing[metal] != SMELTER_MODE_IDLE)
			var/ore/O = GLOB.ore_data[metal]
			if(!O)
				continue

			//Alloying materials
			if(ores_processing[metal] & SMELTER_MODE_ALLOYING && O.alloy)
				for(var/datum/alloy/A in GLOB.alloy_data)
					if(A.metaltag in tick_alloys)
						continue

					tick_alloys += A.metaltag
					var/enough_metal

					if(!isnull(A.requires[metal]) && ores_stored[metal] >= A.requires[metal]) //We have enough of our first metal, we're off to a good start.

						enough_metal = TRUE

						for(var/needs_metal in A.requires)
							//Check if we're alloying the needed metal and have it stored.
							if(!(ores_processing[needs_metal] & SMELTER_MODE_ALLOYING) || ores_stored[needs_metal] < A.requires[needs_metal])
								enough_metal = FALSE
								break

					if(!enough_metal)
						continue
					else
						var/total
						for(var/needs_metal in A.requires)
							if(console)
								var/ore/Ore = GLOB.ore_data[needs_metal]
								console.points += Ore.worth
							use_power_oneoff(300)
							ores_stored[needs_metal] -= A.requires[needs_metal]
							total += A.requires[needs_metal]
							total = max(1, round(total * A.product_mod)) //Always get at least one sheet.
							sheets += total - 1

						for(var/_ in 1 to total)
							if(console)
								console.alloy_mats[A] = console.alloy_mats[A] + 1
							new A.product(output)

			//Compressing materials
			else if(ores_processing[metal] & SMELTER_MODE_COMPRESSING && O.compresses_to)
				var/can_make = Clamp(ores_stored[metal], 0, ROUND_UP(sheets_per_second*seconds_per_tick) - sheets)
				if(can_make % 2 > 0)
					can_make--

				var/material/M = SSmaterials.get_material_by_name(O.compresses_to)

				if(!istype(M) || !can_make || ores_stored[metal] < 1)
					continue

				for(var/_ in 1 to (can_make/2))
					if(console)
						console.points += O.worth * 2
					use_power_oneoff(300)
					ores_stored[metal] -= 2
					sheets += 2
					console.output_mats[M] += 1
					new M.stack_type(output)

			//Smelting materials
			else if(ores_processing[metal] & SMELTER_MODE_SMELTING && O.smelts_to)
				var/can_make = Clamp(ores_stored[metal], 0, ROUND_UP(sheets_per_second*seconds_per_tick) - sheets)

				var/material/M = SSmaterials.get_material_by_name(O.smelts_to)
				if(!istype(M) || !can_make || ores_stored[metal] < 1)
					continue

				for(var/_ in 1 to can_make)
					if(console)
						console.points += O.worth
					use_power_oneoff(300)
					ores_stored[metal] -= 1
					sheets++
					if(console)
						console.output_mats[M] += 1
					new M.stack_type(output)
			else
				if(console)
					console.points -= O.worth * 3 //reee wasting our materials!
				use_power_oneoff(800)
				ores_stored[metal] -= 1
				sheets++
				if(console)
					console.input_mats[O] += 1
					console.waste++
				new /obj/item/ore/slag(output)

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

	sheets_per_second += scan_rating + cap_rating + laser_rating

#undef SMELTER_MODE_IDLE
#undef SMELTER_MODE_ALLOYING
#undef SMELTER_MODE_COMPRESSING
#undef SMELTER_MODE_SMELTING

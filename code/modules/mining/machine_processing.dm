/**********************Mineral processing unit console**************************/

/obj/machinery/mineralconsole/processing_unit
	name = "ore redemption console"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "console"
	density = 0
	anchored = 1
	use_power = 1
	idle_power_usage = 15
	active_power_usage = 50

	var/show_all_ores = 0
	var/points = 0
	var/obj/item/weapon/card/id/inserted_id

	component_types = list(
		/obj/item/weapon/circuitboard/refinerconsole,
		/obj/item/weapon/stock_parts/capacitor = 2,
		/obj/item/weapon/stock_parts/scanning_module,
		/obj/item/weapon/stock_parts/matter_bin = 1,
		/obj/item/weapon/stock_parts/micro_laser = 2
		)

/obj/machinery/mineralconsole/processing_unit/proc/setup_machine(mob/user)
	if(!machine)
		var/obj/machinery/mineral/M
		for(var/obj/machinery/mineral/processing_unit/checked_machine in orange(src))
			if(!M || get_dist_euclidian(src, checked_machine) < get_dist_euclidian(src, M))
				M = checked_machine
		if (M)
			LinkTo(M)
		else
			user << "<span class='warning'>ERROR: Linked machine not found!</span>"

	return machine

/obj/machinery/mineralconsole/processing_unit/attack_hand(mob/user)
	add_fingerprint(user)
	interact(user)

/obj/machinery/mineralconsole/processing_unit/attackby(obj/item/I, mob/user)
	if(istype(I,/obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/C = user.get_active_hand()
		if(istype(C) && !istype(inserted_id))
			user.drop_from_inventory(C,src)
			inserted_id = C
			interact(user)
	else
		..()

/obj/machinery/mineralconsole/processing_unit/interact(mob/user)

	if(..())
		return

	if(!setup_machine(user))
		return

	if(!allowed(user))
		user << "<span class='warning'>Access denied.</span>"
		return

	user.set_machine(src)

	var/dat = "<h1>Ore processor console</h1>"

	dat += "Current unclaimed points: [points]<br>"

	if(istype(inserted_id))
		dat += "You have [inserted_id.mining_points] mining points collected. <A href='?src=\ref[src];choice=eject'>Eject ID.</A><br>"
		dat += "<A href='?src=\ref[src];choice=claim'>Claim points.</A><br>"
	else
		dat += "No ID inserted.  <A href='?src=\ref[src];choice=insert'>Insert ID.</A><br>"

	dat += "<hr><table>"
	var/obj/machinery/mineral/processing_unit/P = machine
	for(var/ore in P.ores_processing)

		if(!P.ores_stored[ore] && !show_all_ores) continue
		var/ore/O = ore_data[ore]
		if(!O) continue
		dat += "<tr><td width = 40><b>[capitalize(O.display_name)]</b></td><td width = 30>[P.ores_stored[ore]]</td><td width = 100>"
		if(P.ores_processing[ore])
			switch(P.ores_processing[ore])
				if(0)
					dat += "<font color='red'>not processing</font>"
				if(1)
					dat += "<font color='orange'>smelting</font>"
				if(2)
					dat += "<font color='blue'>compressing</font>"
				if(3)
					dat += "<font color='gray'>alloying</font>"
		else
			dat += "<font color='red'>not processing</font>"
		dat += ".</td><td width = 30><a href='?src=\ref[src];toggle_smelting=[ore]'>\[change\]</a></td></tr>"

	dat += "</table><hr>"
	dat += "Currently displaying [show_all_ores ? "all ore types" : "only available ore types"]. <A href='?src=\ref[src];toggle_ores=1'>\[[show_all_ores ? "show less" : "show more"]\]</a></br>"
	dat += "The ore processor is currently <A href='?src=\ref[src];toggle_power=1'>[(P.active ? "<font color='green'>processing</font>" : "<font color='red'>disabled</font>")]</a>."
	user << browse(dat, "window=processor_console;size=400x500")
	onclose(user, "processor_console")
	return

/obj/machinery/mineralconsole/processing_unit/Topic(href, href_list)
	if(..())
		return 1
	usr.set_machine(src)
	src.add_fingerprint(usr)

	var/obj/machinery/mineral/processing_unit/P = machine

	if(href_list["choice"])
		if(istype(inserted_id))
			if(href_list["choice"] == "eject")
				inserted_id.forceMove(loc)
				if(!usr.get_active_hand())
					usr.put_in_hands(inserted_id)
				inserted_id = null
			if(href_list["choice"] == "claim")
				if(access_mining_station in inserted_id.access)
					if(points >= 0)
						inserted_id.mining_points += points
						if(points != 0)
							ping( "\The [src] pings, \"Point transfer complete! Transaction total: [points] points!\"" )
						points = 0
					else
						usr << "<span class='warning'>[station_name()]'s mining division is currently indebted to NanoTrasen. Transaction incomplete until debt is cleared.</span>"
				else
					usr << "<span class='warning'>Required access not found.</span>"
		else if(href_list["choice"] == "insert")
			var/obj/item/weapon/card/id/I = usr.get_active_hand()
			if(istype(I))
				usr.drop_from_inventory(I,src)
				inserted_id = I
			else usr << "<span class='warning'>No valid ID.</span>"

	if(href_list["toggle_smelting"])

		var/choice = input("What setting do you wish to use for processing [href_list["toggle_smelting"]]?") as null|anything in list("Smelting","Compressing","Alloying","Nothing")
		if(!choice) return

		switch(choice)
			if("Nothing") choice = 0
			if("Smelting") choice = 1
			if("Compressing") choice = 2
			if("Alloying") choice = 3

		P.ores_processing[href_list["toggle_smelting"]] = choice

	if(href_list["toggle_power"])

		P.active = !P.active
		if(P.active)
			P.icon_state = "furnace"
		else
			P.icon_state = "furnace-off"

	if(href_list["toggle_ores"])

		show_all_ores = !show_all_ores

	src.updateUsrDialog()
	return

/**********************Mineral processing unit**************************/


/obj/machinery/mineral/processing_unit
	name = "industrial smelter" //This isn't actually a goddamn furnace, we're in space and it's processing platinum and flammable phoron... //lol fuk u bay it is //i'm gay
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "furnace-off"
	density = 1
	anchored = 1
	light_range = 3
	var/sheets_per_tick = 20
	var/list/ores_processing[0]
	var/list/ores_stored[0]
	var/static/list/alloy_data
	var/active = 0
	use_power = 1
	idle_power_usage = 15
	active_power_usage = 150

	component_types = list(
			/obj/item/weapon/circuitboard/refiner,
			/obj/item/weapon/stock_parts/capacitor = 2,
			/obj/item/weapon/stock_parts/scanning_module,
			/obj/item/weapon/stock_parts/micro_laser = 2,
			/obj/item/weapon/stock_parts/matter_bin
		)

/obj/machinery/mineral/processing_unit/Initialize()
	. = ..()

	// initialize static alloy_data list
	if(!alloy_data)
		alloy_data = list()
		for(var/alloytype in typesof(/datum/alloy)-/datum/alloy)
			alloy_data += new alloytype()

	for (var/O in ore_data)
		ores_processing[O] = 0
		ores_stored[O] = 0

	//Locate our output and input machinery.
	FindInOut()

/obj/machinery/mineral/processing_unit/machinery_process()
	..()

	if (!src.output || !src.input) return

	var/list/tick_alloys = list()

	//Grab some more ore to process this tick.
	for(var/i = 0,i<sheets_per_tick,i++)
		var/obj/item/weapon/ore/O = locate() in input.loc
		if(!O) break
		if(!isnull(ores_stored[O.material]))
			ores_stored[O.material]++

		qdel(O)

	if(!active)
		if(icon_state != "furnace-off")
			icon_state = "furnace-off"
		return

	//Process our stored ores and spit out sheets.
	var/sheets = 0
	for(var/metal in ores_stored)

		if(sheets >= sheets_per_tick) break

		if(ores_stored[metal] > 0 && ores_processing[metal] != 0)

			var/ore/O = ore_data[metal]

			if(!O) continue

			if(ores_processing[metal] == 3 && O.alloy) //Alloying.

				for(var/datum/alloy/A in alloy_data)

					if(A.metaltag in tick_alloys)
						continue

					tick_alloys += A.metaltag
					var/enough_metal

					if(!isnull(A.requires[metal]) && ores_stored[metal] >= A.requires[metal]) //We have enough of our first metal, we're off to a good start.

						enough_metal = 1

						for(var/needs_metal in A.requires)
							//Check if we're alloying the needed metal and have it stored.
							if(ores_processing[needs_metal] != 3 || ores_stored[needs_metal] < A.requires[needs_metal])
								enough_metal = 0
								break

					if(!enough_metal)
						continue
					else
						var/total
						for(var/needs_metal in A.requires)
							if(istype(console, /obj/machinery/mineralconsole/processing_unit))
								var/obj/machinery/mineralconsole/processing_unit/P = console
								var/ore/Ore = ore_data[needs_metal]
								P.points += Ore.worth
							use_power(100)
							ores_stored[needs_metal] -= A.requires[needs_metal]
							total += A.requires[needs_metal]
							total = max(1,round(total*A.product_mod)) //Always get at least one sheet.
							sheets += total-1

						for(var/i=0,i<total,i++)
							new A.product(output.loc)

			else if(ores_processing[metal] == 2 && O.compresses_to) //Compressing.

				var/can_make = Clamp(ores_stored[metal],0,sheets_per_tick-sheets)
				if(can_make%2>0) can_make--

				var/material/M = get_material_by_name(O.compresses_to)

				if(!istype(M) || !can_make || ores_stored[metal] < 1)
					continue

				for(var/i=0,i<can_make,i+=2)
					if(istype(console, /obj/machinery/mineralconsole/processing_unit))
						var/obj/machinery/mineralconsole/processing_unit/P = console
						P.points += O.worth*2
					use_power(100)
					ores_stored[metal]-=2
					sheets+=2
					new M.stack_type(output.loc)

			else if(ores_processing[metal] == 1 && O.smelts_to) //Smelting.

				var/can_make = Clamp(ores_stored[metal],0,sheets_per_tick-sheets)

				var/material/M = get_material_by_name(O.smelts_to)
				if(!istype(M) || !can_make || ores_stored[metal] < 1)
					continue

				for(var/i=0,i<can_make,i++)
					if(istype(console, /obj/machinery/mineralconsole/processing_unit))
						var/obj/machinery/mineralconsole/processing_unit/P = console
						P.points += O.worth
					use_power(100)
					ores_stored[metal]--
					sheets++
					new M.stack_type(output.loc)
			else
				if(istype(console, /obj/machinery/mineralconsole/processing_unit))
					var/obj/machinery/mineralconsole/processing_unit/P = console
					P.points -= O.worth*3 //reee wasting our materials!
				use_power(500)
				ores_stored[metal]--
				sheets++
				new /obj/item/weapon/ore/slag(output.loc)
		else
			continue

	console.updateUsrDialog()

/obj/machinery/mineral/processing_unit/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(default_deconstruction_screwdriver(user, W))
		return
	else if(default_deconstruction_crowbar(user, W))
		return
	else if(default_part_replacement(user, W))
		return

/obj/machinery/mineral/processing_unit/RefreshParts()
	..()
	var/scan_rating = 0
	var/cap_rating = 0
	var/laser_rating = 0

	for(var/obj/item/weapon/stock_parts/P in component_parts)
		if(isscanner(P))
			scan_rating += P.rating
		else if(iscapacitor(P))
			cap_rating += P.rating
		else if(ismicrolaser(P))
			laser_rating += P.rating

	sheets_per_tick += scan_rating + cap_rating + laser_rating
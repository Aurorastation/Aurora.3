//Config stuff
#define SUPPLY_DOCKZ 2          //Z-level of the Dock.
#define SUPPLY_STATIONZ 1       //Z-level of the Station.
#define SUPPLY_STATION_AREATYPE /area/supply/station //Type of the supply shuttle area for station
#define SUPPLY_DOCK_AREATYPE /area/supply/dock	//Type of the supply shuttle area for dock

var/datum/controller/subsystem/cargo/SScargo

/datum/controller/subsystem/cargo
	name = "Cargo"
	wait = 30 SECONDS
	flags = SS_NO_TICK_CHECK
	init_order = SS_INIT_CARGO

	//supply points
	var/points = 50
	var/points_per_process = 1
	var/points_per_slip = 2
	var/points_per_crate = 5
	var/points_per_platinum = 5 // 5 points per sheet
	var/points_per_phoron = 5
	//control
	var/ordernum
	var/list/shoppinglist = list()
	var/list/requestlist = list()
	var/list/supply_packs = list()
	//shuttle movement
	var/movetime = 1200
	var/datum/shuttle/ferry/supply/shuttle

/datum/controller/subsystem/cargo/Recover()
	src.points = SScargo.points
	src.shoppinglist = SScargo.shoppinglist
	src.requestlist = SScargo.requestlist
	src.supply_packs = SScargo.supply_packs
	src.shuttle = SScargo.shuttle

/datum/controller/subsystem/cargo/Initialize(timeofday)
	ordernum = rand(1,9000)

	for (var/typepath in subtypesof(/datum/supply_packs))
		var/datum/supply_packs/P = new typepath()
		supply_packs[P.name] = P

	var/datum/cargospawner/spawner = new
	spawner.start()
	qdel(spawner)
	..()

/datum/controller/subsystem/cargo/New()
	NEW_SS_GLOBAL(SScargo)

/datum/controller/subsystem/cargo/fire()
	points += points_per_process

//To stop things being sent to centcomm which should not be sent to centcomm. Recursively checks for these types.
/datum/controller/subsystem/cargo/proc/forbidden_atoms_check(atom/A)
	if(istype(A,/mob/living))
		return 1
	if(istype(A,/obj/item/weapon/disk/nuclear))
		return 1
	if(istype(A,/obj/machinery/nuclearbomb))
		return 1
	if(istype(A,/obj/item/device/radio/beacon))
		return 1

	for(var/i=1, i<=A.contents.len, i++)
		var/atom/B = A.contents[i]
		if(.(B))
			return 1

		//Sellin
/datum/controller/subsystem/cargo/proc/sell()
	var/area/area_shuttle = shuttle.get_location_area()
	if(!area_shuttle)	return

	var/phoron_count = 0
	var/plat_count = 0

	for(var/atom/movable/MA in area_shuttle)
		if(MA.anchored)	continue

		// Must be in a crate!
		if(istype(MA,/obj/structure/closet/crate))
			callHook("sell_crate", list(MA, area_shuttle))

			points += points_per_crate
			var/find_slip = 1

			for(var/atom in MA)
				// Sell manifests
				var/atom/A = atom
				if(find_slip && istype(A,/obj/item/weapon/paper/manifest))
					var/obj/item/weapon/paper/manifest/slip = A
					if(!slip.is_copy && slip.stamped && slip.stamped.len) //yes, the clown stamp will work. clown is the highest authority on the station, it makes sense
						points += points_per_slip
						find_slip = 0
					continue

				// Sell phoron and platinum
				if(istype(A, /obj/item/stack))
					var/obj/item/stack/P = A
					switch(P.get_material_name())
						if("phoron") phoron_count += P.get_amount()
						if("platinum") plat_count += P.get_amount()
		qdel(MA)

	if(phoron_count)
		points += phoron_count * points_per_phoron

	if(plat_count)
		points += plat_count * points_per_platinum

//Buyin
/datum/controller/subsystem/cargo/proc/buy()
	if(!shoppinglist.len) return

	var/area/area_shuttle = shuttle.get_location_area()
	if(!area_shuttle)	return

	var/list/clear_turfs = list()

	for(var/turf/T in area_shuttle)
		if(T.density)	continue
		var/contcount
		for(var/atom/A in T.contents)
			if(!A.simulated)
				continue
			contcount++
		if(contcount)
			continue
		clear_turfs += T

	for(var/S in shoppinglist)
		if(!clear_turfs.len)	break
		var/i = rand(1,clear_turfs.len)
		var/turf/pickedloc = clear_turfs[i]
		clear_turfs.Cut(i,i+1)

		var/datum/supply_order/SO = S
		var/datum/supply_packs/SP = SO.object

		var/obj/A = new SP.containertype(pickedloc)
		A.name = "[SP.containername] [SO.comment ? "([SO.comment])":"" ]"

		//supply manifest generation begin

		var/obj/item/weapon/paper/manifest/slip
		if(!SP.contraband)
			slip = new /obj/item/weapon/paper/manifest(A)
			slip.is_copy = 0
			slip.info = "<h3>[command_name()] Shipping Manifest</h3><hr><br>"
			slip.info +="Order #[SO.ordernum]<br>"
			slip.info +="Destination: [station_name]<br>"
			slip.info +="[shoppinglist.len] PACKAGES IN THIS SHIPMENT<br>"
			slip.info +="CONTENTS:<br><ul>"

		//spawn the stuff, finish generating the manifest while you're at it
		if(SP.access)
			if(isnum(SP.access))
				A.req_access = list(SP.access)
			else if(islist(SP.access))
				var/list/L = SP.access // access var is a plain var, we need a list
				A.req_access = L.Copy()
			else
				world << "<span class='danger'>Supply pack with invalid access restriction [SP.access] encountered!</span>"

		var/list/contains
		if(istype(SP,/datum/supply_packs/randomised))
			var/datum/supply_packs/randomised/SPR = SP
			contains = list()
			if(SPR.contains.len)
				for(var/j=1,j<=SPR.num_contained,j++)
					contains += pick(SPR.contains)
		else
			contains = SP.contains

		for(var/typepath in contains)
			if(!typepath)	continue
			var/atom/B2 = new typepath(A)
			if(SP.amount && B2:amount) B2:amount = SP.amount
			if(slip) slip.info += "<li>[B2.name]</li>" //add the item to the manifest

		//manifest finalisation
		if(slip)
			slip.info += "</ul><br>"
			slip.info += "CHECK CONTENTS AND STAMP BELOW THE LINE TO CONFIRM RECEIPT OF GOODS<hr>"

	shoppinglist.Cut()
	return

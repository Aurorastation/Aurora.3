//Config stuff
#define SUPPLY_DOCKZ 2          //Z-level of the Dock.
#define SUPPLY_STATIONZ 1       //Z-level of the Station.
#define SUPPLY_STATION_AREATYPE /area/supply/station //Type of the supply shuttle area for station
#define SUPPLY_DOCK_AREATYPE /area/supply/dock	//Type of the supply shuttle area for dock

/proc/fetch_supply_account()
    SScargo.supply_account = department_accounts["Cargo"]

var/datum/controller/subsystem/cargo/SScargo

/datum/controller/subsystem/cargo
	name = "Cargo"
	wait = 30 SECONDS
	flags = SS_NO_TICK_CHECK
	init_order = SS_INIT_CARGO

	//supply points
	var/credits_per_crate = 100
	var/credits_per_platinum = 100
	var/credits_per_phoron = 100


	var/ordernum
	var/list/cargo_items = list() //The list of cargo items
	var/list/cargo_categories = list() //The list of cargo categories
	var/list/all_orders = list() //All orders
	var/cargo_handlingfee = 50 //The handling fee cargo takes per crate
	var/cargo_handlingfee_min = 0 // The minimum handling fee
	var/cargo_handlingfee_max = 500 // The maximum handling fee
	var/cargo_handlingfee_change = 1 // If the handlingfee can be changed
	var/datum/money_account/supply_account


	//shuttle movement
	var/movetime = 1200
	var/datum/shuttle/ferry/supply/shuttle

/datum/controller/subsystem/cargo/Recover()
	src.shuttle = SScargo.shuttle
	src.cargo_items = SScargo.cargo_items
	src.cargo_categories = SScargo.cargo_categories
	src.all_orders = SScargo.all_orders
	src.cargo_handlingfee = SScargo.cargo_handlingfee
	src.cargo_handlingfee_change = SScargo.cargo_handlingfee_change
	src.supply_account = SScargo.supply_account

/datum/controller/subsystem/cargo/Initialize(timeofday)
	//Generate the ordernumber to start with
	ordernum = rand(1,8000)

	//Fetch the cargo account once the round is started - TODO: Repalce that once economy gets its own subsystem
	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, .proc/fetch_supply_account))

	//Load in the cargo items config
	if(config.cargo_load_items_from == "sql")
		log_debug("Cargo Items: Attempting to Load from SQL")
		load_from_sql()
	else if(config.cargo_load_items_from == "json")
		log_debug("Cargo Items: Attempting to Load from JSON")
		load_from_json()

	var/datum/cargospawner/spawner = new
	spawner.start()
	qdel(spawner)
	..()

/datum/controller/subsystem/cargo/New()
	NEW_SS_GLOBAL(SScargo)

//Increments the orderid and returns it
/datum/controller/subsystem/cargo/proc/get_next_order_id()
	. = ordernum
	ordernum++
	return .

/datum/controller/subsystem/cargo/proc/load_from_sql()
	if(!dbcon.IsConnected())
		log_debug("Cargo Items: SQL ERROR - Failed to connect. - Falling back to JSON")
		return load_from_json()
	else
		return 1
		
/datum/controller/subsystem/cargo/proc/load_from_json()
	var/list/cargoconfig = json_decode(return_file_text("config/cargo.json"))

	//Load the cargo categories
	//TODO: Move the contents of the for loop into its own proc so it can be reused
	for (var/category in cargoconfig["categories"])
		log_debug("Cargo Categories: Loading Category: [category]")
		var/datum/cargo_category/cc = new()
		cc.name = cargoconfig["categories"][category]["name"]
		cc.display_name = cargoconfig["categories"][category]["display_name"]
		cc.description = cargoconfig["categories"][category]["description"]
		cc.icon = cargoconfig["categories"][category]["icon"]

		//Add the caregory to the cargo_categories list
		cargo_categories[cc.name] = cc

	//Load the cargoitems
	//TODO: Move the contents of the for loop into its own proc so it can be reused
	for (var/item in cargoconfig["items"])
		log_debug("Cargo Items: Loading Item: [item]")
		var/itempath = text2path(item)
		if(!ispath(itempath))
			log_debug("Cargo Items: Warning - Attempted to add item with invalid path: [item]")
			continue
		var/datum/cargo_item/ci = new()
		ci.path = item
		ci.name = cargoconfig["items"][item]["name"]
		ci.description = cargoconfig["items"][item]["description"]
		ci.categories = cargoconfig["items"][item]["categories"]
		ci.suppliers = cargoconfig["items"][item]["suppliers"]
		ci.amount = cargoconfig["items"][item]["amount"]
		ci.access = cargoconfig["items"][item]["access"]
		ci.container_type = cargoconfig["items"][item]["container_type"]
		ci.groupable = cargoconfig["items"][item]["groupable"]
		log_debug("Cargo Items: Loaded Item: [ci.name]")

		//Add the item to the cargo_items list
		cargo_items[ci.path] = ci

		//Add the item to the categories
		for(var/category in ci.categories)
			var/datum/cargo_category/cc = cargo_categories[category]
			if(cc) //Check if the category exists
				cc.items.Add(ci)
			else
				log_debug("Cargo Items: Warning - Attempted to add item to category that does not exist")

	return 1

/datum/controller/subsystem/cargo/proc/get_items_for_category(var/category)
	var/datum/cargo_category/cc = cargo_categories[category]
	if(cc)
		return cc.get_item_list()
	else
		return list()

/datum/controller/subsystem/cargo/proc/get_category_list()
	var/list/category_list = list()
	for (var/cat_name in cargo_categories)
		var/datum/cargo_category/cc = cargo_categories[cat_name]
		category_list.Add(list(cc.get_list()))
	return category_list

/datum/controller/subsystem/cargo/proc/get_order_by_id(var/id)
	for (var/datum/cargo_order/co in all_orders)
		if(co.order_id == id)
			return co
	return null

//Submit a specific order
/datum/controller/subsystem/cargo/proc/submit_order(var/datum/cargo_order/co)
	co.status = "submitted"
	co.time_submited = worldtime2text()
	co.order_id = get_next_order_id()
	all_orders.Add(co)
	return 1

//Get the orders that have been submited via order app but have not been approved yet
/datum/controller/subsystem/cargo/proc/get_submitted_orders(var/data_list = 1)
	var/list/submitted_orders = list()
	for (var/datum/cargo_order/co in all_orders)
		if(co.status == "submitted")
			if(data_list)
				submitted_orders.Add(list(co.get_list()))
			else
				submitted_orders.Add(co)
	return submitted_orders

/datum/controller/subsystem/cargo/proc/get_submitted_orders_value()
	var/value = 0
	for (var/datum/cargo_order/co in all_orders)
		if(co.status == "submitted")
			value += co.price
	return value

//Approve a order
/datum/controller/subsystem/cargo/proc/approve_order(var/datum/cargo_order/co)
	if(co.status == "submitted")
		co.status = "approved"
		co.time_approved = worldtime2text()
		return 1
	else 
		return 0
//Approve a order
/datum/controller/subsystem/cargo/proc/reject_order(var/datum/cargo_order/co)
	if(co.status == "submitted")
		co.status = "rejected"
		co.time_approved = worldtime2text()
		return 1
	else
		return 0
//Get the orders that have been approved
/datum/controller/subsystem/cargo/proc/get_approved_orders(var/data_list = 1)
	var/list/approved_orders = list()
	for (var/datum/cargo_order/co in all_orders)
		if(co.status == "approved")
			if(data_list)
				approved_orders.Add(list(co.get_list()))
			else
				approved_orders.Add(co)
	return approved_orders

/datum/controller/subsystem/cargo/proc/get_approved_orders_value()
	var/value = 0
	for (var/datum/cargo_order/co in all_orders)
		if(co.status == "approved")
			value += co.price
	return value

/datum/controller/subsystem/cargo/proc/ship_order(var/datum/cargo_order/co)
	co.status = "shipped"
	co.time_shipped = worldtime2text()

/datum/controller/subsystem/cargo/proc/get_handlingfee()
	return cargo_handlingfee

/datum/controller/subsystem/cargo/proc/set_handlingfee(var/fee)
	if(fee < cargo_handlingfee_min)
		return 1
	if(fee > cargo_handlingfee_max)
		return 2
	if(cargo_handlingfee_change != 1)
		return 3
	cargo_handlingfee = fee
	return 0

/datum/controller/subsystem/cargo/proc/charge_cargo(var/charge_text, var/charge_credits)
	if(!supply_account)
		log_debug("Cargo - Warning Tried to charge supply account but supply acount doesnt exist")
		return 0
	return charge_to_account(supply_account.account_number, "[commstation_name()] - Supply", "[charge_text]", "[commstation_name()] - Banking System", -charge_credits)

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
	//TODO: Only pay for specific stuff on the shuttle and not for everything else - Charge a cleanup fee for the rest
	var/area/area_shuttle = shuttle.get_location_area()
	if(!area_shuttle)	return

	var/phoron_count = 0
	var/plat_count = 0
	var/sell_credits = 0

	for(var/atom/movable/MA in area_shuttle)
		if(MA.anchored)	continue

		// Must be in a crate!
		if(istype(MA,/obj/structure/closet/crate))
			callHook("sell_crate", list(MA, area_shuttle))

			sell_credits += credits_per_crate

			for(var/atom in MA)
				// Sell manifests
				var/atom/A = atom
				// Sell phoron and platinum
				if(istype(A, /obj/item/stack))
					var/obj/item/stack/P = A
					switch(P.get_material_name())
						if("phoron") phoron_count += P.get_amount()
						if("platinum") plat_count += P.get_amount()
		qdel(MA)

	if(phoron_count)
		sell_credits += phoron_count * credits_per_phoron

	if(plat_count)
		sell_credits += plat_count * credits_per_platinum

	charge_cargo("Shipment Credits",-sell_credits)

//Buyin
/datum/controller/subsystem/cargo/proc/buy()
	var/list/approved_orders = get_approved_orders(0)

	if(!approved_orders.len) return

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

	for(var/datum/cargo_order/co in approved_orders)
		if(!co)
			break
		if(!clear_turfs.len)
			break
		var/i = rand(1,clear_turfs.len)
		var/turf/pickedloc = clear_turfs[i]
		clear_turfs.Cut(i,i+1)

		//Spawn the crate
		var/containertype = co.get_container_type()
		var/obj/A = new containertype(pickedloc)

		//Label the crate
		//TODO: Look into wrapping it in a NT paper
		A.name = "[co.order_id] - [co.customer]"

		//Set the access requirement
		if(co.required_access.len > 0)
			A.req_access = co.required_access

		//Loop through the items and spawn them
		for(var/datum/cargo_order_item/coi in co.items)
			if(!coi)
				continue
			//TODO: Spawn amount of items specified
			var/atom/item = new coi.ci.path(A)

			//TODO: Customize items with supplier data
			var/list/suppliers = coi.ci.suppliers
			for(var/var_name in suppliers[coi.supplier]["vars"])
				try
					item.vars[var_name] = suppliers[coi.supplier]["vars"][var_name]
				catch(var/exception/e)
					log_debug("Cargo: Bad variable name [var_name] for item [coi.ci.path] - [e]")

		//Update the status of the order
		ship_order(co)

	return

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
	flags = SS_NO_TICK_CHECK | SS_NO_FIRE
	init_order = SS_INIT_CARGO

	//Shipment stuff
	var/shipmentnum
	var/list/cargo_shipments = list() //List of the shipments to the station
	var/datum/cargo_shipment/current_shipment = null // The current cargo shipment

	//order stuff
	var/ordernum
	var/list/cargo_items = list() //The list of items
	var/list/cargo_categories = list() //The list of categories
	var/list/cargo_suppliers = list() //The list of suppliers
	var/list/all_orders = list() //All orders

	//Fee Stuff
	var/credits_per_crate = 100 //Cost / Payment per crate shipped from / to centcom
	var/credits_per_platinum = 140 //Per sheet
	var/credits_per_phoron = 100 //Per sheet
	var/cargo_handlingfee = 50 //The handling fee cargo takes per crate
	var/cargo_handlingfee_min = 0 // The minimum handling fee
	var/cargo_handlingfee_max = 500 // The maximum handling fee
	var/cargo_handlingfee_change = 1 // If the handlingfee can be changed -> For a random event
	var/datum/money_account/supply_account

	//shuttle movement
	var/movetime = 1200
	var/datum/shuttle/ferry/supply/shuttle

/datum/controller/subsystem/cargo/Recover()
	src.shuttle = SScargo.shuttle
	src.cargo_items = SScargo.cargo_items
	src.cargo_categories = SScargo.cargo_categories
	src.cargo_shipments = SScargo.cargo_shipments
	src.all_orders = SScargo.all_orders
	src.cargo_handlingfee = SScargo.cargo_handlingfee
	src.cargo_handlingfee_change = SScargo.cargo_handlingfee_change
	src.supply_account = SScargo.supply_account

/datum/controller/subsystem/cargo/Initialize(timeofday)
	//Generate the ordernumber and shipmentnumber to start with
	ordernum = rand(1,8000)
	shipmentnum = rand(500,700)

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


/*
	Loading Data 
*/
//Load the cargo data from SQL
/datum/controller/subsystem/cargo/proc/load_from_sql()
	if(!establish_db_connection(dbcon))
		log_debug("Cargo Items: SQL ERROR - Failed to connect. - Falling back to JSON")
		return load_from_json()
	else
		//Load the categories
		var/DBQuery/category_query = dbcon.NewQuery("SELECT name, display_name, description, icon, price_modifier FROM ss13_cargo_categories")
		category_query.Execute()
		while(category_query.NextRow())
			log_debug("Cargo Categories: Loading Category: [category_query.item[1]]")
			var/datum/cargo_category/cc = new()
			cc.name = category_query.item[1]
			cc.display_name = category_query.item[2]
			cc.description = category_query.item[3]
			cc.icon = category_query.item[4]
			cc.price_modifier = category_query.item[5]

			//Add the caregory to the cargo_categories list
			cargo_categories[cc.name] = cc

		//Load the suppliers
		var/DBQuery/supplier_query = dbcon.NewQuery("SELECT short_name, name, description, tag_line, shuttle_time, shuttle_price, available, price_modifier FROM ss13_cargo_suppliers")
		supplier_query.Execute()
		while(supplier_query.NextRow())
			log_debug("Cargo Supplier: Loading Supplier: [supplier_query.item[1]]")
			var/datum/cargo_supplier/cs = new()
			cs.short_name = supplier_query.item[1]
			cs.name = supplier_query.item[2]
			cs.description = supplier_query.item[3]
			cs.tag_line = supplier_query.item[4]
			cs.shuttle_time = supplier_query.item[5]
			cs.shuttle_price = supplier_query.item[6]
			cs.available = supplier_query.item[7]
			cs.price_modifier = supplier_query.item[8]

			cargo_suppliers[cs.short_name] = cs

		//Load the items
		var/DBQuery/item_query = dbcon.NewQuery("SELECT path, description, categories, suppliers, amount, access, container_type, groupable FROM ss13_cargo_suppliers")
		item_query.Execute()
		while(item_query.NextRow())
			log_debug("Cargo Items: Loading Item: [item_query.item[2]]")
			var/itempath = text2path(item_query.item[1])
			if(!ispath(itempath))
				log_debug("Cargo Items: Warning - Attempted to add item with invalid path: [item_query.item[2]] - [item_query.item[1]]")
				continue
			var/datum/cargo_item/ci = new()
			ci.path = item_query.item[1]
			ci.name = item_query.item[2]
			ci.description = item_query.item[3]
			ci.categories = item_query.item[4]
			ci.suppliers = item_query.item[5]
			ci.amount = item_query.item[6]
			ci.access = item_query.item[7]
			ci.container_type = item_query.item[8]
			ci.groupable = item_query.item[9]
			log_debug("Cargo Items: Loaded Item: [ci.name]")

			//Verify the suppliers exist
			for(var/sup in ci.suppliers)
				log_debug("Checking [sup]")
				var/datum/cargo_supplier/cs = get_supplier_by_name(sup)
				if(!cs)
					log_debug("[sup] is not a valid supplier")
				
				//Setting the supplier
				ci.suppliers[sup]["supplier_datum"] = cs
				
			//Add the item to the cargo_items list
			cargo_items[ci.path] = ci

			//Add the item to the categories
			for(var/category in ci.categories)
				var/datum/cargo_category/cc = cargo_categories[category]
				if(cc) //Check if the category exists
					cc.items.Add(ci)
				else
					log_debug("Cargo Items: Warning - Attempted to add item to category [category] that does not exist")
		return 1

//Loads the cargo data from JSON	
/datum/controller/subsystem/cargo/proc/load_from_json()
	var/list/cargoconfig = list()
	try
		cargoconfig = json_decode(return_file_text("config/cargo.json"))
	catch(var/exception/e)
		log_debug("Cargo: Warning: Could not load config, as cargo.json is missing - [e]")
		return

	//Load the cargo categories
	for (var/category in cargoconfig["categories"])
		log_debug("Cargo Categories: Loading Category: [category]")
		var/datum/cargo_category/cc = new()
		cc.name = cargoconfig["categories"][category]["name"]
		cc.display_name = cargoconfig["categories"][category]["display_name"]
		cc.description = cargoconfig["categories"][category]["description"]
		cc.icon = cargoconfig["categories"][category]["icon"]
		cc.price_modifier = cargoconfig["categories"][category]["price_modifier"]

		//Add the caregory to the cargo_categories list
		cargo_categories[cc.name] = cc

	//Load the suppliers
	for (var/supplier in cargoconfig["suppliers"])
		log_debug("Cargo Supplier: Loading Supplier: [supplier]")
		var/datum/cargo_supplier/cs = new()
		cs.short_name = supplier
		cs.name = cargoconfig["suppliers"][supplier]["name"]
		cs.description = cargoconfig["suppliers"][supplier]["description"]
		cs.tag_line = cargoconfig["suppliers"][supplier]["tag_line"]
		cs.shuttle_time = cargoconfig["suppliers"][supplier]["shuttle_time"]
		cs.shuttle_price = cargoconfig["suppliers"][supplier]["shuttle_price"]
		cs.available = cargoconfig["suppliers"][supplier]["available"]
		cs.price_modifier = cargoconfig["suppliers"][supplier]["price_modifier"]

		cargo_suppliers[cs.short_name] = cs

	//Load the cargoitems
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

		//Verify the suppliers exist
		for(var/sup in ci.suppliers)
			log_debug("Checking [sup]")
			var/datum/cargo_supplier/cs = get_supplier_by_name(sup)
			if(!cs)
				log_debug("[sup] is not a valid supplier")
			
			//Setting the supplier
			ci.suppliers[sup]["supplier_datum"] = cs
			
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


/*
	Getting items, categories and suppliers
*/
//Increments the orderid and returns it
/datum/controller/subsystem/cargo/proc/get_next_order_id()
	. = ordernum
	ordernum++
	return .

//Gets the items from a category
/datum/controller/subsystem/cargo/proc/get_items_for_category(var/category)
	var/datum/cargo_category/cc = cargo_categories[category]
	if(cc)
		return cc.get_item_list()
	else
		return list()

//Gets the categories
/datum/controller/subsystem/cargo/proc/get_category_list()
	var/list/category_list = list()
	for (var/cat_name in cargo_categories)
		var/datum/cargo_category/cc = cargo_categories[cat_name]
		category_list.Add(list(cc.get_list()))
	return category_list
//Get a category by name
/datum/controller/subsystem/cargo/proc/get_category_by_name(var/name)
	return cargo_categories[name]

//Gets a order by order id
/datum/controller/subsystem/cargo/proc/get_order_by_id(var/id)
	for (var/datum/cargo_order/co in all_orders)
		if(co.order_id == id)
			return co
	return null

//Gets a supplier by name
/datum/controller/subsystem/cargo/proc/get_supplier_by_name(var/name)
	return cargo_suppliers[name]

/*
	Submitting, Approving, Rejecting and Shipping Orders
*/
//Gets the orders based on their status (submitted, approved, shipped)
/datum/controller/subsystem/cargo/proc/get_orders_by_status(var/status, var/data_list=0)
	if(!status)
		log_debug("Cargo - get_orders_by_status has been called with a invalud status")
		return list()
	var/list/orders = list()
	for (var/datum/cargo_order/co in all_orders)
		if(co.status == status)
			if(data_list)
				orders.Add(list(co.get_list()))
			else
				orders.Add(co)
	return orders
//Gets the value of orders based on their status, type is passed on to co.get_value
/datum/controller/subsystem/cargo/proc/get_orders_value_by_status(var/status, var/type=0)
	if(!status)
		log_debug("Cargo - get_orders_value_by_status has been called with a invalud status")
		return 0
	var/value = 0
	for (var/datum/cargo_order/co in all_orders)
		if(co.status == status)
			value += co.get_value(type)
	return value
//Gets the suppliers of the orders of a specific type
/datum/controller/subsystem/cargo/proc/get_order_suppliers_by_status(var/status, var/pretty_names=0)
	if(!status)
		log_debug("Cargo - get_order_suppliers_by_status has been called with a invalud status")
		return list()
	var/list/suppliers = list()
	for(var/datum/cargo_order/co in all_orders)
		if(co.status == status)
			//Get the list of supplirs and add it to the suppliers list
			for(var/supplier in co.get_supplier_list())
				if(pretty_names)
					var/datum/cargo_supplier/cs = SScargo.cargo_suppliers[supplier]
					suppliers[cs.short_name] = cs.name
				else
					suppliers[supplier] = supplier
	return suppliers

//Submits an order to cargo
/datum/controller/subsystem/cargo/proc/submit_order(var/datum/cargo_order/co)
	co.status = "submitted"
	co.time_submitted = worldtime2text()
	co.order_id = get_next_order_id()
	all_orders.Add(co)
	return 1

//Approve a order  - Returns a status message
/datum/controller/subsystem/cargo/proc/approve_order(var/datum/cargo_order/co)
	if(co.status == "submitted")
		co.status = "approved"
		co.time_approved = worldtime2text()
		return "The order has been approved"
	else 
		return "The order could not be approved - Invalid Status"

//Reject a order - Returns a status message
/datum/controller/subsystem/cargo/proc/reject_order(var/datum/cargo_order/co)
	if(co.status == "submitted")
		co.status = "rejected"
		co.time_approved = worldtime2text()
		return "The order has been rejected"
	else
		return "The order could not be rejected - Invalid Status"




//Checks if theorder can be shipped and marks it as shipped if possible
/datum/controller/subsystem/cargo/proc/ship_order(var/datum/cargo_order/co)
	//Get the price cargo has to pay for the order
	var/item_price = co.get_value(1)

	//Get the maximum shipment costs for the order
	var/max_shipment_cost = co.get_max_shipment_cost()

	//Check if cargo has enough money to pay for the shipment of the item and the maximum shipment cost
	if(item_price + max_shipment_cost > get_cargo_money())
		log_debug("Cargo - Order could not be shipped. Insufficient money. [item_price] + [max_shipment_cost] > [get_cargo_money()]")
		return 0

	co.status = "shipped"
	co.time_shipped = worldtime2text()
	current_shipment.shipment_cost_purchse += item_price //Increase the price of the shipment
	current_shipment.orders.Add(co) //Add the order to the order list
	return 1
//Generate a new cargo shipment
/datum/controller/subsystem/cargo/proc/new_shipment()
	current_shipment = new()
	shipmentnum ++
	cargo_shipments.Add(current_shipment)
	current_shipment.shipment_num = shipmentnum
/*
	Changing Settings
*/
//Gets the current handlingfee
/datum/controller/subsystem/cargo/proc/get_handlingfee()
	return cargo_handlingfee
// Sets the handling fee - Returns a status message
/datum/controller/subsystem/cargo/proc/set_handlingfee(var/fee)
	if(fee < cargo_handlingfee_min)
		return "Unable to set handlingfee - Smaller than minimum: [cargo_handlingfee_min]"
	if(fee > cargo_handlingfee_max)
		return "Unable to set handlingfee - Higher than maximum: [cargo_handlingfee_max]"
	if(cargo_handlingfee_change != 1)
		return "Unable to set handlingfee - Changing the handlingfee is currently not possible"
	cargo_handlingfee = fee
	return

//Gets the current crate fee
/datum/controller/subsystem/cargo/proc/get_cratefee()
	return credits_per_crate
/*
	Money Stuff
*/
//Gets the current money on the cargo account
/datum/controller/subsystem/cargo/proc/get_cargo_money()
	return supply_account.money
//Charges cargo. Accepts a text that should appear as charge and the numer of credits to charge
/datum/controller/subsystem/cargo/proc/charge_cargo(var/charge_text, var/charge_credits)
	if(!supply_account)
		log_debug("Cargo - Warning Tried to charge supply account but supply acount doesnt exist")
		return 0
	return charge_to_account(supply_account.account_number, "[commstation_name()] - Supply", "[charge_text]", "[commstation_name()] - Banking System", -charge_credits)
//Gets the pending shipment costs for the items that are about to be shipped to the station
/datum/controller/subsystem/cargo/proc/get_pending_shipment_cost(var/status="approved")
	//Loop through all the orders marked as shipped and get the suppliers into a list of involved suppliers
	var/list/suppliers = get_order_suppliers_by_status(status)
	var/price = 0
	for(var/supplier in suppliers)
		var/datum/cargo_supplier/cs = SScargo.cargo_suppliers[supplier]
		if(cs)
			price += cs.shuttle_price
	return price
//Gets the pending shipment time for the items that are about to be shipped to the station
/datum/controller/subsystem/cargo/proc/get_pending_shipment_time(var/status="approved")
	//Loop through all the orders marked as shipped and get the suppliers into a list of involved suppliers
	var/list/suppliers = get_order_suppliers_by_status(status)
	var/time = 0
	for(var/supplier in suppliers)
		var/datum/cargo_supplier/cs = SScargo.cargo_suppliers[supplier]
		if(cs)
			time += cs.shuttle_time
	return time

/*
	Shuttle Operations - Calling, Forcing, Canceling, Buying / Selling
*/
//Calls the shuttle. Returns a status message
/datum/controller/subsystem/cargo/proc/shuttle_call(var/caller_name)
	if(shuttle.at_station())
		if (shuttle.forbidden_atoms_check())
			. = "For safety reasons the automated supply shuttle cannot transport live organisms, classified nuclear weaponry or homing beacons."
		else
			movetime = 1200 //It always takes two minutes to get to centcom
			shuttle.launch(src)
			. = "Initiating launch sequence"
			current_shipment.shuttle_recalled_by = caller_name
	else
		//Check if there is enough money in the cargo account for the current shipment
		var/shipment_cost = get_pending_shipment_cost()
		if( shipment_cost > get_cargo_money())
			. = "The supply shuttle could not be called. Insufficient Funds. [shipment_cost] Credits required"
		else
			//Create a new shipment if one does not exist already
			if(!current_shipment)
				new_shipment()
			
			//Set the shuttle movement time
			current_shipment.shuttle_time = get_pending_shipment_time()
			current_shipment.shuttle_fee = shipment_cost

			if(current_shipment.shuttle_time < 1200)
				log_debug("Cargo: Shuttle Time less than 1200: [current_shipment.shuttle_time] - Setting to 1200")
				current_shipment.shuttle_time = 1200

			movetime = current_shipment.shuttle_time
			//Launch it
			shuttle.launch(src)
			. = "The supply shuttle has been called and will arrive in approximately [round(SScargo.movetime/600,1)] minutes."
			current_shipment.shuttle_called_by = caller_name
	return .

//Cancels the shuttle. Can return a status message
/datum/controller/subsystem/cargo/proc/shuttle_cancel()
	shuttle.cancel_launch(src)

//Forces the shuttle. Can return a status message
/datum/controller/subsystem/cargo/proc/shuttle_force()
	shuttle.force_launch(src)

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

//Sells stuff on the shuttle to centcom
/datum/controller/subsystem/cargo/proc/sell()
	//TODO: Only pay for specific stuff on the shuttle and not for everything else - Charge a cleanup fee for the rest
	var/area/area_shuttle = shuttle.get_location_area()
	if(!area_shuttle)	return

	var/phoron_count = 0
	var/plat_count = 0

	for(var/atom/movable/MA in area_shuttle)
		if(MA.anchored)	continue

		// Must be in a crate!
		if(istype(MA,/obj/structure/closet/crate))
			callHook("sell_crate", list(MA, area_shuttle))

			current_shipment.shipment_cost_sell += credits_per_crate

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
		current_shipment.shipment_cost_sell += phoron_count * credits_per_phoron

	if(plat_count)
		current_shipment.shipment_cost_sell += plat_count * credits_per_platinum

	charge_cargo("Shipment #[current_shipment.shipment_num] - Income", -current_shipment.shipment_cost_sell)
	current_shipment.generate_invoice()
	current_shipment = null //Null the current shipment because its completed

//Buys the item and places them on the shuttle
//Returns 0 if unsuccessful returns 1 if the shuttle can be sent
/datum/controller/subsystem/cargo/proc/buy()
	if(!current_shipment)
		new_shipment()

	var/list/approved_orders = get_orders_by_status("approved",0)

	var/area/area_shuttle = shuttle.get_location_area()
	if(!area_shuttle)
		return 0

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

		//Check if theres space to place the order
		if(!clear_turfs.len)
			break

		//Check if the supplier is still active
		for(var/datum/cargo_order_item/coi in co.items)
			var/datum/cargo_supplier/csu = get_supplier_by_name(coi.supplier)
			if(!csu)
				log_debug("Cargo - Order [co.order_id] could not be placed on the shuttle because supplier [coi.supplier] for item [coi.ci.name] is invalid")
				break
			if(!csu.available)
				log_debug("Cargo - Order [co.order_id] could not be placed on the shuttle because supplier [coi.supplier] for item [coi.ci.name] is unavailable")
				break

		//Check if there is enough money to ship the order
		if(!ship_order(co))
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
			A.req_access = co.required_access.Copy()

		//Loop through the items and spawn them
		for(var/datum/cargo_order_item/coi in co.items)
			if(!coi)
				continue

			//Spawn the specified amount
			for(i=0, i < coi.ci.amount, i++)
				var/atom/item = new coi.ci.path(A)

				//Customize items with supplier data
				var/list/suppliers = coi.ci.suppliers
				for(var/var_name in suppliers[coi.supplier]["vars"])
					try
						item.vars[var_name] = suppliers[coi.supplier]["vars"][var_name]
					catch(var/exception/e)
						log_debug("Cargo: Bad variable name [var_name] for item [coi.ci.path] - [e]")

	//Shuttle is loaded now - Charge cargo for it
	charge_cargo("Shipment #[current_shipment.shipment_num] - Expense",current_shipment.shipment_cost_purchse)

	return 1

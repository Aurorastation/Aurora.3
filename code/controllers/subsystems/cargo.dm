//Config stuff
#define SUPPLY_DOCKZ 1          //Z-level of the Dock.
#define SUPPLY_STATIONZ 6       //Z-level of the Station.
#define SUPPLY_STATION_AREATYPE /area/supply/station //Type of the supply shuttle area for station
#define SUPPLY_DOCK_AREATYPE /area/supply/dock	//Type of the supply shuttle area for dock

var/datum/controller/subsystem/cargo/SScargo

/datum/controller/subsystem/cargo
	name = "Cargo"
	wait = 30 SECONDS
	flags = SS_NO_FIRE
	init_order = SS_INIT_CARGO

	//Shipment stuff
	var/shipmentnum
	var/list/cargo_shipments = list() //List of the shipments to the station
	var/datum/cargo_shipment/current_shipment = null //The current cargo shipment

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
	var/cargo_handlingfee_min = 0 //The minimum handling fee
	var/cargo_handlingfee_max = 500 //The maximum handling fee
	var/cargo_handlingfee_change = 1 //If the handlingfee can be changed -> For a random event
	var/datum/money_account/supply_account

	//shuttle movement
	var/movetime = 1200
	var/min_movetime = 1200
	var/datum/shuttle/autodock/ferry/supply/shuttle

	//Item vars
	var/last_item_id = 0 //The ID of the last item that has been added

	//Exports and bounties
	var/list/exports_list = list()
	var/list/bounties_list = list()

/datum/controller/subsystem/cargo/Recover()
	src.shuttle = SScargo.shuttle
	src.cargo_items = SScargo.cargo_items
	src.cargo_categories = SScargo.cargo_categories
	src.cargo_shipments = SScargo.cargo_shipments
	src.all_orders = SScargo.all_orders
	src.cargo_handlingfee = SScargo.cargo_handlingfee
	src.cargo_handlingfee_change = SScargo.cargo_handlingfee_change
	src.supply_account = SScargo.supply_account
	src.last_item_id = SScargo.last_item_id
	src.exports_list = SScargo.exports_list
	src.bounties_list = SScargo.bounties_list

/datum/controller/subsystem/cargo/Initialize(timeofday)
	//Generate the ordernumber and shipmentnumber to start with
	ordernum = rand(1,8000)
	shipmentnum = rand(500,700)

	supply_account = SSeconomy.get_department_account("Cargo")

	//Load in the cargo items config
	if(config.cargo_load_items_from == "sql")
		log_debug("SScargo: Attempting to Load from SQL")
		load_from_sql()
	else if(config.cargo_load_items_from == "json")
		log_debug("SScargo: Attempting to Load from JSON")
		load_from_json()
	else
		log_game("SScargo: invalid load option specified in config")

	setupExports()
	setupBounties()

	//Spawn in the warehouse crap
	var/datum/cargospawner/spawner = new
	spawner.start()
	qdel(spawner)
	..()

/datum/controller/subsystem/cargo/New()
	NEW_SS_GLOBAL(SScargo)




/*
	Loading Data
*/
//Reset cargo to prep for loading in new items
/datum/controller/subsystem/cargo/proc/reset_cargo()
	cargo_shipments = list() //List of the shipments to the station
	current_shipment = null //The current cargo shipment
	cargo_items = list() //The list of items
	cargo_categories = list() //The list of categories
	cargo_suppliers = list() //The list of suppliers
	all_orders = list() //All orders
	last_item_id = 0

//Load the cargo data from SQL
/datum/controller/subsystem/cargo/proc/load_from_sql()
	if(!establish_db_connection(dbcon))
		log_debug("SScargo: SQL ERROR - Failed to connect. - Falling back to JSON")
		return load_from_json()
	else
		//Reset the currently loaded data
		reset_cargo()

		//Load the categories
		var/DBQuery/category_query = dbcon.NewQuery("SELECT id, name, display_name, description, icon, price_modifier FROM ss13_cargo_categories WHERE deleted_at IS NULL ORDER BY order_by ASC")
		category_query.Execute()
		while(category_query.NextRow())
			CHECK_TICK
			var/category_id = category_query.item[1]
			try
				add_category(
					category_query.item[2],
					category_query.item[3],
					category_query.item[4],
					category_query.item[5],
					text2num(category_query.item[6]))
			catch(var/exception/ec)
				log_debug("SScargo: Error when loading category [category_id] from sql: [ec]")
		//Load the suppliers
		var/DBQuery/supplier_query = dbcon.NewQuery("SELECT id, short_name, name, description, tag_line, shuttle_time, shuttle_price, available, price_modifier FROM ss13_cargo_suppliers WHERE deleted_at is NULL")
		supplier_query.Execute()
		while(supplier_query.NextRow())
			CHECK_TICK
			var/supplier_id = supplier_query.item[1]
			try
				add_supplier(
					supplier_query.item[2],
					supplier_query.item[3],
					supplier_query.item[4],
					supplier_query.item[5],
					supplier_query.item[6],
					supplier_query.item[7],
					supplier_query.item[8],
					supplier_query.item[9])
			catch(var/exception/es)
				log_debug("SScargo: Error when loading supplier [supplier_id] from sql: [es]")
		//Load the items
		var/DBQuery/item_query = dbcon.NewQuery("SELECT id, name, supplier, description, categories, price, items, access, container_type, groupable, item_mul FROM ss13_cargo_items WHERE deleted_at IS NULL AND approved_at IS NOT NULL AND supplier IS NOT NULL ORDER BY order_by ASC, name ASC, supplier ASC")
		item_query.Execute()
		while(item_query.NextRow())
			CHECK_TICK
			var/item_id = item_query.item[1]
			try
				add_item(
					item_query.item[1],
					item_query.item[2],
					item_query.item[3],
					item_query.item[4],
					json_decode(item_query.item[5]),
					item_query.item[6],
					json_decode(item_query.item[7]),
					item_query.item[8],
					item_query.item[9],
					item_query.item[10],
					item_query.item[11])
			catch(var/exception/ei)
				log_debug("SScargo: Error when loading item [item_id] from sql: [ei]")

//Loads the cargo data from JSON
/datum/controller/subsystem/cargo/proc/load_from_json()
	var/list/cargoconfig = list()
	try
		cargoconfig = json_decode(return_file_text("config/cargo.json"))
	catch(var/exception/ej)
		log_debug("SScargo: Warning: Could not load config, as cargo.json is missing - [ej]")
		return

	//Reset the currently loaded data
	reset_cargo()

	//Load the cargo categories
	for (var/category in cargoconfig["categories"])
		CHECK_TICK
		try
			add_category(
				cargoconfig["categories"][category]["name"],
				cargoconfig["categories"][category]["display_name"],
				cargoconfig["categories"][category]["description"],
				cargoconfig["categories"][category]["icon"],
				cargoconfig["categories"][category]["price_modifier"])
		catch(var/exception/ec)
			log_debug("SScargo: Error when loading category: [ec]")
	//Load the suppliers
	for (var/supplier in cargoconfig["suppliers"])
		CHECK_TICK
		try
			add_supplier(
				supplier,
				cargoconfig["suppliers"][supplier]["name"],
				cargoconfig["suppliers"][supplier]["description"],
				cargoconfig["suppliers"][supplier]["tag_line"],
				cargoconfig["suppliers"][supplier]["shuttle_time"],
				cargoconfig["suppliers"][supplier]["shuttle_price"],
				cargoconfig["suppliers"][supplier]["available"],
				cargoconfig["suppliers"][supplier]["price_modifier"])
		catch(var/exception/es)
			log_debug("SScargo: Error when loading supplier: [es]")
	//Load the cargoitems
	for (var/item in cargoconfig["items"])
		CHECK_TICK
		try
			add_item(
				null,
				cargoconfig["items"][item]["name"],
				cargoconfig["items"][item]["supplier"],
				cargoconfig["items"][item]["description"],
				cargoconfig["items"][item]["categories"],
				cargoconfig["items"][item]["price"],
				cargoconfig["items"][item]["items"],
				cargoconfig["items"][item]["access"],
				cargoconfig["items"][item]["container_type"],
				cargoconfig["items"][item]["groupable"],
				cargoconfig["items"][item]["item_mul"])
		catch(var/exception/ei)
			log_debug("SScargo: Error when loading supplier: [ei]")
	return 1

//Add a new Category to the Cargo Subsystem
/datum/controller/subsystem/cargo/proc/add_category(var/name,var/display_name,var/description,var/icon,var/price_modifier)
	var/datum/cargo_category/cc = new()
	cc.name = name
	cc.display_name = display_name
	cc.description = description
	cc.icon = icon
	cc.price_modifier = text2num(price_modifier)

	//Add the category to the cargo_categories list
	cargo_categories[cc.name] = cc
	return cc

//Add a new Supplier to the Cargo Subsystem
/datum/controller/subsystem/cargo/proc/add_supplier(var/short_name,var/name,var/description,var/tag_line,var/shuttle_time,var/shuttle_price,var/available,var/price_modifier)
	var/datum/cargo_supplier/cs = new()
	cs.short_name = short_name
	cs.name = name
	cs.description = description
	cs.tag_line = tag_line
	cs.shuttle_time = text2num(shuttle_time)
	cs.shuttle_price = text2num(shuttle_price)
	cs.available = text2num(available)
	cs.price_modifier = text2num(price_modifier)

	cargo_suppliers[cs.short_name] = cs
	return cs

//Add a new item to the cargo subsystem, the categories and the items need to be a list and CAN NOT be passed as a json string.
//Decoding of the string MUST take place before
/datum/controller/subsystem/cargo/proc/add_item(var/id=null,var/name,var/supplier="nt",var/description,var/list/categories,var/price,var/list/items,var/access=0,var/container_type=CARGO_CONTAINER_CRATE,var/groupable=1,var/item_mul=1)
	//TODO-CARGO: Maybe add the option to specify access as string instead of number

	//If no item ID is supplied generate one ourselfs (use the next free id)
	//If one is supplied, update the item id if the one supplied is higher
	if(!id)
		id=get_next_item_id()
	else
		id = text2num(id)
		if(id > last_item_id)
			last_item_id = id

	var/datum/cargo_item/ci = new()
	try
		ci.id = id
		ci.name = name
		ci.supplier = supplier
		ci.description = description
		ci.categories = categories
		ci.price = text2num(price)
		ci.items = items
		ci.access = text2num(access)
		ci.container_type = container_type
		ci.groupable = text2num(groupable)
		ci.item_mul = text2num(item_mul)
		ci.amount = length(ci.items)*ci.item_mul
	catch(var/exception/e)
		log_debug("SScargo: Error when loading item: [e]")
		qdel(ci)
		return

	for(var/item in ci.items)
		var/itempath = text2path(ci.items[item]["path"])
		if(!ispath(itempath))
			log_debug("SScargo: Warning - Attempted to add item with invalid path - [ci.id] - [ci.name] - [ci.items[item]["path"]]")
			return

	//Check if a valid container is specified
	if(!(ci.container_type == CARGO_CONTAINER_CRATE || ci.container_type == CARGO_CONTAINER_FREEZER || ci.container_type == CARGO_CONTAINER_BOX))
		log_debug("SScargo: Invalid container type specified for item - Aborting")
		qdel(ci)
		return

	//Verify the suppliers exist
	var/datum/cargo_supplier/cs = get_supplier_by_name(ci.supplier)
	if(!cs)
		log_debug("SScargo: [ci.supplier] is not a valid supplier for item [ci.name].")
		QDEL_NULL(ci)
		return

	//Setting the supplier
	ci.supplier_datum = cs

	//Add the item to the cargo_items list
	cargo_items["[ci.id]"] = ci

	//Add the item to the suppliers items list
	ci.supplier_datum.items.Add(ci)

	//Log a message if no categories are specified
	if(ci.categories.len == 0)
		log_debug("SScargo: No categories specified for item [ci.name].")

	//Add the item to the categories
	for(var/category in ci.categories)
		var/datum/cargo_category/cc = cargo_categories[category]
		if(cc) //Check if the category exists
			cc.items.Add(ci)
		else
			log_debug("SScargo: Warning - Attempted to add [ci.name] item to category [category] that does not exist.")

	return ci

/*
	Getting items, categories, suppliers and shipments
*/
/datum/controller/subsystem/cargo/proc/get_order_count()
	return all_orders.len
//Returns the order id and increments it
/datum/controller/subsystem/cargo/proc/get_next_order_id()
	. = ordernum
	ordernum++
	return .
//Increments the itemid and returns it
/datum/controller/subsystem/cargo/proc/get_next_item_id()
	last_item_id++
	return last_item_id
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

//Gets all the shipments sent to / from the station
/datum/controller/subsystem/cargo/proc/get_shipment_list()
	var/list/shipment_list = list()
	for(var/datum/cargo_shipment/cs in cargo_shipments)
		if(cs.get_list() != null)
			shipment_list.Add(list(cs.get_list()))
	return shipment_list

//Get a shipment by shipment id
/datum/controller/subsystem/cargo/proc/get_shipment_by_id(var/id)
	for(var/datum/cargo_shipment/cs in cargo_shipments)
		if(cs.shipment_num == id)
			return cs
	return null

/*
	Submitting, Approving, Rejecting and Shipping Orders
*/
//Gets the orders based on their status (submitted, approved, shipped)
/datum/controller/subsystem/cargo/proc/get_orders_by_status(var/status, var/data_list=0)
	if(!status)
		log_debug("SScargo: get_orders_by_status has been called with a invalid status")
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
		log_debug("SScargo: get_orders_value_by_status has been called with a invalid status")
		return 0
	var/value = 0
	for (var/datum/cargo_order/co in all_orders)
		if(co.status == status)
			value += co.get_value(type)
	return value
//Gets the suppliers of the orders of a specific type
/datum/controller/subsystem/cargo/proc/get_order_suppliers_by_status(var/status, var/pretty_names=0)
	if(!status)
		log_debug("SScargo: get_order_suppliers_by_status has been called with a invalid status")
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

//Checks if theorder can be shipped and marks it as shipped if possible
/datum/controller/subsystem/cargo/proc/ship_order(var/datum/cargo_order/co)
	//Get the price cargo has to pay for the order
	var/item_price = co.get_value(1)

	//Get the maximum shipment costs for the order
	var/shipment_cost = co.get_shipment_cost()

	//Check if cargo has enough money to pay for the shipment of the item and the maximum shipment cost
	if(item_price + shipment_cost > get_cargo_money())
		log_debug("SScargo: Order could not be shipped. Insufficient money. [item_price] + [shipment_cost] > [get_cargo_money()].")
		return 0

	co.set_shipped()
	current_shipment.shipment_cost_purchase += item_price //Increase the price of the shipment
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
	if(!fee)
		return "Unable to set handlingfee - Can not be NULL"
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
		log_debug("SScargo: Warning Tried to charge supply account but supply acount doesnt exist")
		return 0
	return SSeconomy.charge_to_account(supply_account.account_number, "[commstation_name()] - Supply", "[charge_text]", "[commstation_name()] - Banking System", -charge_credits)
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
			movetime = min_movetime //It always takes two minutes to get to centcom
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

			if(current_shipment.shuttle_time < min_movetime)
				log_debug("SScargo: Shuttle Time less than [min_movetime]: [current_shipment.shuttle_time] - Setting to [min_movetime]")
				current_shipment.shuttle_time = min_movetime

			movetime = current_shipment.shuttle_time
			//Launch it
			shuttle.launch(src)
			. = "The supply shuttle has been called and will arrive in approximately [round(SScargo.movetime/600,1)] minutes."
			current_shipment.shuttle_called_by = caller_name

//Cancels the shuttle. Can return a status message
/datum/controller/subsystem/cargo/proc/shuttle_cancel()
	shuttle.cancel_launch(src)

//Forces the shuttle. Can return a status message
/datum/controller/subsystem/cargo/proc/shuttle_force()
	shuttle.force_launch(src)

//To stop things being sent to centcomm which should not be sent to centcomm. Recursively checks for these types.
/datum/controller/subsystem/cargo/proc/forbidden_atoms_check(atom/A)
	if(istype(A,/mob/living))
		var/mob/living/mob_to_send = A
		var/mob_is_for_bounty = FALSE
		if(!mob_to_send.mind)
			for(var/bounty in bounties_list)
				var/datum/bounty/B = bounty
				if(B.applies_to(mob_to_send))
					mob_is_for_bounty = TRUE
		if(!mob_is_for_bounty)
			return 1
	if(istype(A,/obj/item/disk/nuclear))
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
	if(!shuttle.shuttle_area)
		return

	var/msg = ""
	var/matched_bounty = FALSE
	var/sold_atoms = ""

	for(var/area/subarea in shuttle.shuttle_area)
		for(var/atom/movable/AM in subarea)
			if(bounty_ship_item_and_contents(AM, dry_run = FALSE))
				matched_bounty = TRUE
			if(!AM.anchored)
				sold_atoms += export_item_and_contents(AM, FALSE, FALSE, dry_run = FALSE)

	if(sold_atoms)
		sold_atoms += "."

	if(matched_bounty)
		msg += "Bounty items received. An update has been sent to all bounty consoles.\n"

	for(var/a in exports_list)
		var/datum/export/E = a
		var/export_text = E.total_printout()
		if(!export_text)
			continue

		msg += export_text + "\n"
		current_shipment.shipment_cost_sell += E.total_cost
		E.export_end()

	charge_cargo("Shipment #[current_shipment.shipment_num] - Income", -current_shipment.shipment_cost_sell)
	current_shipment.message = msg
	current_shipment.generate_invoice()
	current_shipment = null //Null the current shipment because its completed

//Buys the item and places them on the shuttle
//Returns 0 if unsuccessful returns 1 if the shuttle can be sent
/datum/controller/subsystem/cargo/proc/buy()
	if(!current_shipment)
		new_shipment()

	var/list/approved_orders = get_orders_by_status("approved",0)

	if(!shuttle.shuttle_area)
		return

	var/list/clear_turfs = list()

	for(var/area/subarea in shuttle.shuttle_area)
		for(var/turf/T in subarea)
			if(T.density)
				continue
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
			continue

		//Check if theres space to place the order
		if(!clear_turfs.len)
			log_debug("SScargo: Order [co.order_id] could not be placed on the shuttle because the shuttle is full")
			break

		//Check if the supplier is still available
		for(var/datum/cargo_order_item/coi in co.items)
			if(!coi.ci.supplier_datum.available)
				log_debug("SScargo: Order [co.order_id] could not be placed on the shuttle because supplier [coi.ci.supplier_datum.name] for item [coi.ci.name] is unavailable")
				continue

		//Check if there is enough money to ship the order
		if(!ship_order(co))
			continue

		var/i = rand(1,clear_turfs.len)
		var/turf/pickedloc = clear_turfs[i]
		clear_turfs.Cut(i,i+1)

		//Spawn the crate
		var/containertype = co.get_container_type()
		var/obj/A = new containertype(pickedloc)

		//Label the crate
		//TODO-CARGO: Look into wrapping it in a the suppliers paper
		A.name = "[co.order_id] - [co.ordered_by]"

		//Set the access requirement
		if(co.required_access.len > 0)
			A.req_access = co.required_access.Copy()

		//Loop through the items and spawn them
		for(var/datum/cargo_order_item/coi in co.items)
			if(!coi)
				continue
			for(var/j=1;j<=coi.ci.item_mul;j++)
				for(var/name in coi.ci.items)
					var/path = coi.ci.items[name]["path"]
					var/atom/item = new path(A)
					//Customize the items
					for(var/var_name in coi.ci.items[name]["vars"])
						try
							item.vars[var_name] = coi.ci.items[name]["vars"][var_name]
						catch(var/exception/e)
							log_debug("SScargo: Bad variable name [var_name] for item name: [coi.ci.name] id: [coi.ci.id] - [e]")

		//Spawn the Paper Inside
		var/obj/item/paper/P = new(A)
		P.set_content_unsafe("[co.order_id] - [co.ordered_by]", co.get_report_delivery_order())

	//Shuttle is loaded now - Charge cargo for it
	charge_cargo("Shipment #[current_shipment.shipment_num] - Expense",current_shipment.shipment_cost_purchase)

	return 1

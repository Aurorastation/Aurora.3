//Config stuff
#define SUPPLY_DOCKZ 1		  //Z-level of the Dock.
#define SUPPLY_STATIONZ 6	   //Z-level of the Station.
#define SUPPLY_STATION_AREATYPE /area/supply/station //Type of the supply shuttle area for station
#define SUPPLY_DOCK_AREATYPE /area/supply/dock	//Type of the supply shuttle area for dock

SUBSYSTEM_DEF(cargo)
	name = "Cargo"
	wait = 30 SECONDS
	flags = SS_NO_FIRE
	init_order = SS_INIT_CARGO

	//Shipment stuff
	var/shipmentnum
	var/list/cargo_shipments = list() //List of the shipments to the station
	var/datum/cargo_shipment/current_shipment = null //The current cargo shipment
	var/list/queued_mining_equipment = list()

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
	var/movetime = 300
	var/min_movetime = 300
	var/max_movetime = 2400
	var/datum/shuttle/autodock/ferry/supply/shuttle

	//Item vars
	var/last_item_id = 0 //The ID of the last item that has been added

	//Bool to indicate if orders have been dumped
	var/dumped_orders = FALSE

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

	supply_account = SSeconomy.get_department_account("Operations")

	//Load in the cargo items config
	load_cargo_files()

	setupExports()
	setupBounties()

	//Spawn in the warehouse crap
	var/datum/cargospawner/spawner = new
	spawner.start()
	qdel(spawner)

	return SS_INIT_SUCCESS

/*
	Loading Data
*/
//Reset cargo to prep for loading in new items
/datum/controller/subsystem/cargo/proc/reset_cargo()
	cargo_shipments = list() //List of the shipments to the station
	current_shipment = null //The current cargo shipment
	all_orders = list() //All orders
	last_item_id = 0

//Load categories
/datum/controller/subsystem/cargo/proc/load_cargo_categories()
	for(var/singleton/cargo_category/C as anything in (GET_SINGLETON_SUBTYPE_LIST(/singleton/cargo_category)))
		log_subsystem_cargo("Loading category '[C.name]'.")
		SScargo.cargo_categories[C.name] = C

//Load Suppliers
/datum/controller/subsystem/cargo/proc/load_cargo_suppliers()
	for(var/singleton/cargo_supplier/S as anything in (GET_SINGLETON_SUBTYPE_LIST(/singleton/cargo_supplier)))
		log_subsystem_cargo("Loading supplier '[S.name]', with short name '[S.short_name]'.")
		SScargo.cargo_suppliers[S.short_name] = S

/datum/controller/subsystem/cargo/proc/load_cargo_items()
	log_subsystem_cargo("Loading cargo items.")
	var/id = 1

	reset_cargo()

	// Get the list of all valid cargo items
	for (var/singleton/cargo_item/I as anything in (GET_SINGLETON_SUBTYPE_LIST(/singleton/cargo_item)))
		cargo_items[I.name] = I
		I.id = id++
		I.get_adjusted_price()

		// Check if the category exists in SScargo.cargo_categories
		if (!(I.category || SScargo.cargo_categories[I.category]))
			log_subsystem_cargo("Error: Unable to find category '[I.category]' for item '[I.name]. Skipping.")
			continue
		else
			var/singleton/cargo_category/item_category = SScargo.cargo_categories[I.category]
			if (!item_category.items)
				item_category.items = list()
			item_category.items += I
			log_subsystem_cargo("Inserted item '[I.name]' into category '[I.category]' with ID '[I.id]'.")

		if (!(I.supplier || SScargo.cargo_suppliers[I.supplier]))
			log_subsystem_cargo("Error: Unable to find supplier '[I.supplier]' for item '[I.name]. Skipping.")
			continue
		else
			var/singleton/cargo_supplier/item_supplier = SScargo.cargo_suppliers[I.supplier]
			if (!item_supplier.items)
				item_supplier.items = list()
			item_supplier.items += I
			I.supplier_data = item_supplier

	log_subsystem_cargo("Finished loading cargo items.")

//Load cargo data from cargo_items.dm
/datum/controller/subsystem/cargo/proc/load_cargo_files()
	log_subsystem_cargo("Starting to load cargo data from files.")

	//Reset the loaded cargo data
	reset_cargo()

	//Add categories
	load_cargo_categories()

	//Load suppliers
	load_cargo_suppliers()

	//Load cargo items
	load_cargo_items()

	log_subsystem_cargo("Finished loading cargo data from files.")

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


/// Returns a "default" cargo_category for usage in situations where one is needed.
/datum/controller/subsystem/cargo/proc/get_default_category()
	var/list/categories = GET_SINGLETON_SUBTYPE_LIST(/singleton/cargo_category)
	var/singleton/cargo_category/default_cat = categories[1]
	log_subsystem_cargo("Default category set to '[initial(default_cat.name)]'.")
	return initial(default_cat.name)

/// Returns a string-formatted list of data for all suppliers and their information for use in TGUI.
/datum/controller/subsystem/cargo/proc/get_supplier_data(var/supplier_short_name)
	var/list/supplier_data = list()
	var/singleton/cargo_supplier/S = cargo_suppliers[supplier_short_name]

	if(!S)
		log_subsystem_cargo("Error: Unable to find supplier '[supplier_short_name]'.")
		return

	supplier_data += list(
		"short_name" = S.short_name,
		"name" = S.name,
		"description" = S.description,
		"tag_line" = S.tag_line,
		"shuttle_time" = S.shuttle_time,
		"shuttle_price" = S.shuttle_price,
		"available" = S.available,
		"price_modifier" = S.price_modifier,
	)

	return supplier_data

/// Returns a string-formatted list of every item in each category and their information for use in TGUI.
/datum/controller/subsystem/cargo/proc/get_items_for_category(var/category_name)
	var/list/item_list = list()
	var/singleton/cargo_category/C = cargo_categories[category_name]

	if(!C)
		log_subsystem_cargo("Error: get_items_for_category() was unable to find category '[category_name]'.")
		return

	for(var/singleton/cargo_item/ci as anything in C.items)

		item_list += list(list(
			"name" = ci.name,
			"description" = ci.description,
			"price" = ci.price,
			"id" = ci.id,
			"price_adjusted" = ci.adjusted_price,
			"supplier" = ci.supplier,
			"supplier_data" = get_supplier_data(ci.supplier),
			"access" = ci.access != 0 ? get_access_desc(ci.access) : "none",
		))

	return item_list

/// Returns a string-formatted list of categories for use in TGUI.
/datum/controller/subsystem/cargo/proc/get_category_list()
	var/list/category_list = list()

	for (var/cat_name in cargo_categories)
		// Get the singleton instance for the current category
		var/singleton/cargo_category/cc = cargo_categories[cat_name]

		category_list += list(list(
			"name" = cc.name,
			"display_name" = cc.display_name,
			"description" = cc.description,
			"icon" = cc.icon,
			"price_modifier" = cc.price_modifier,
		))

	return category_list

//Get category names
/datum/controller/subsystem/cargo/proc/get_category_by_name(var/name)
	// Check if the category exists in cargo_categories
	if (!cargo_categories[name])
		log_subsystem_cargo("Error: Requested category '[name]' does not exist.")
		return

	// Return the category if it exists
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
		log_subsystem_cargo("get_orders_by_status has been called with a invalid status")
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
		log_subsystem_cargo("get_orders_value_by_status has been called with a invalid status")
		return 0
	var/value = 0
	for (var/datum/cargo_order/co in all_orders)
		if(co.status == status)
			value += co.get_value(type)
	return value

//Gets the suppliers of the orders of a specific type
/datum/controller/subsystem/cargo/proc/get_order_suppliers_by_status(var/status, var/pretty_names=0)
	if(!status)
		log_subsystem_cargo("get_order_suppliers_by_status has been called with a invalid status")
		return list()
	var/list/suppliers = list()
	for(var/datum/cargo_order/co in all_orders)
		if(co.status == status)
			//Get the list of supplirs and add it to the suppliers list
			for(var/supplier in co.get_supplier_list())
				if(pretty_names)
					var/singleton/cargo_supplier/cs = SScargo.cargo_suppliers[supplier]
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
		log_subsystem_cargo("Order could not be shipped. Insufficient money. [item_price] + [shipment_cost] > [get_cargo_money()].")
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
		log_subsystem_cargo("Warning: Tried to charge supply account but supply acount doesnt exist")
		return 0
	return SSeconomy.charge_to_account(supply_account.account_number, "[commstation_name()] - Operations", "[charge_text]", "[commstation_name()] - Banking System", -charge_credits)

//Gets the pending shipment costs for the items that are about to be shipped to the station
/datum/controller/subsystem/cargo/proc/get_pending_shipment_cost(var/status="approved")
	//Loop through all the orders marked as shipped and get the suppliers into a list of involved suppliers
	var/list/suppliers = get_order_suppliers_by_status(status)
	var/price = 0
	for(var/supplier in suppliers)
		var/singleton/cargo_supplier/cs = SScargo.cargo_suppliers[supplier]
		if(cs)
			price += cs.shuttle_price
	return price
//Gets the pending shipment time for the items that are about to be shipped to the station
/datum/controller/subsystem/cargo/proc/get_pending_shipment_time(var/status="approved")
	//Loop through all the orders marked as shipped and get the suppliers into a list of involved suppliers
	var/list/suppliers = get_order_suppliers_by_status(status)
	var/time = 0
	for(var/supplier in suppliers)
		var/singleton/cargo_supplier/cs = SScargo.cargo_suppliers[supplier]
		if(cs)
			time += cs.shuttle_time
	return time

/*
	Shuttle Operations - Calling, Forcing, Canceling, Buying / Selling
*/
//Calls the shuttle. Returns a status message
/datum/controller/subsystem/cargo/proc/shuttle_call(var/requester_name)
	if(shuttle.at_station())
		if (shuttle.forbidden_atoms_check())
			. = "For safety reasons the automated supply shuttle cannot transport live organisms, classified nuclear weaponry or homing beacons."
		else
			movetime = min_movetime //It always takes two minutes to get to centcom
			shuttle.launch(src)
			. = "Initiating launch sequence"
			current_shipment.shuttle_recalled_by = requester_name
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
				log_subsystem_cargo("Shuttle Time less than [min_movetime]: [current_shipment.shuttle_time] - Setting to [min_movetime]")
				current_shipment.shuttle_time = min_movetime

			if(current_shipment.shuttle_time > max_movetime)
				log_subsystem_cargo("Shuttle Time larger than [max_movetime]: [current_shipment.shuttle_time] - Setting to [max_movetime]")
				current_shipment.shuttle_time = max_movetime

			movetime = current_shipment.shuttle_time
			//Launch it
			shuttle.launch(src)
			. = "The supply shuttle has been called and will arrive in approximately [round(SScargo.movetime/600,2)] minutes."
			current_shipment.shuttle_called_by = requester_name

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

/datum/controller/subsystem/cargo/proc/order_mining(var/equip_path)
	if(!ispath(equip_path))
		return FALSE

	queued_mining_equipment += equip_path
	return TRUE

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

	for(var/E in queued_mining_equipment)
		if(!ispath(E))
			continue

		var/i = rand(1,clear_turfs.len)
		var/turf/pickedloc = clear_turfs[i]
		clear_turfs.Cut(i,i+1)

		if(isturf(pickedloc))
			new E(pickedloc)

		queued_mining_equipment -= E

	for(var/datum/cargo_order/co in approved_orders)
		if(!co)
			continue

		//Check if theres space to place the order
		if(!clear_turfs.len)
			log_subsystem_cargo("Order [co.order_id] could not be placed on the shuttle because the shuttle is full")
			break

		//Check if the supplier is still available
		for(var/datum/cargo_order_item/coi in co.items)
			if(!coi.ci.supplier_data.available)
				log_subsystem_cargo("Order [co.order_id] could not be placed on the shuttle because supplier [coi.ci.supplier_data.name] for item [coi.ci.name] is unavailable")
				continue

		//Check if there is enough money to ship the order
		if(!ship_order(co))
			continue

		var/i = rand(1,clear_turfs.len)
		var/turf/pickedloc = clear_turfs[i]
		clear_turfs.Cut(i,i+1)

		//Spawn the crate
		var/containertype = co.get_container_type()
		var/obj/crate = new containertype(pickedloc)

		//Label the crate
		crate.name_unlabel = crate.name
		crate.name = "[crate.name] ([co.order_id] - [co.ordered_by])"
		crate.verbs += /atom/proc/remove_label

		//Set the access requirement
		if(co.required_access.len > 0)
			crate.req_access = co.required_access.Copy()

		//Loop through the items and spawn them
		for(var/datum/cargo_order_item/coi in co.items)
			if(!coi)
				continue
			for(var/_ in 1 to coi.ci.spawn_amount)
				for(var/item_typepath in coi.ci.items)
					new item_typepath(crate)

		//Spawn the Paper Inside
		var/obj/item/paper/P = new(crate)
		P.set_content_unsafe("[co.order_id] - [co.ordered_by]", co.get_report_delivery_order())

	//Shuttle is loaded now - Charge cargo for it
	charge_cargo("Shipment #[current_shipment.shipment_num] - Expense",current_shipment.shipment_cost_purchase)

	return 1

/// Dumps the cargo orders to the database when the round ends.
/datum/controller/subsystem/cargo/proc/dump_orders()
	if(dumped_orders)
		log_subsystem_cargo("SQL: Orders already dumped. Cargo data dump has been aborted.")
		return
	if(!establish_db_connection(GLOB.dbcon))
		log_subsystem_cargo("SQL: Unable to connect to SQL database. Cargo data dump has been aborted.")
		return

	dumped_orders = TRUE

	// Loop through all the orders and dump them all
	var/DBQuery/dump_query = GLOB.dbcon.NewQuery("INSERT INTO `ss13_cargo_orderlog` (`game_id`, `order_id`, `status`, `price`, `ordered_by_id`, `ordered_by`, `authorized_by_id`, `authorized_by`, `received_by_id`, `received_by`, `paid_by_id`, `paid_by`, `time_submitted`, `time_approved`, `time_shipped`, `time_delivered`, `time_paid`, `reason`) \
	VALUES (:game_id:, :order_id:, :status:, :price:, :ordered_by_id:, :ordered_by:, :authorized_by_id:, :authorized_by:, :received_by_id:, :received_by:, :paid_by_id:, :paid_by:, :time_submitted:, :time_approved:, :time_shipped:, :time_delivered:, :time_paid:, :reason:)")

	var/DBQuery/dump_item_query = GLOB.dbcon.NewQuery("INSERT INTO `ss13_cargo_item_orderlog` (`cargo_orderlog_id`, `item_name`, `amount`) \
	VALUES (:cargo_orderlog_id:, :item_name:, :amount:)")

	var/DBQuery/log_id = GLOB.dbcon.NewQuery("SELECT LAST_INSERT_ID() AS log_id")

	for(var/datum/cargo_order/co in all_orders)
		//Iterate over the items in the order and build the a list with the item count
		var/list/itemcount = list()
		var/list/itemnames = list()
		for(var/datum/cargo_order_item/coi in co.items)
			if(!isnull(itemcount["[coi.ci.id]"]))
				itemcount["[coi.ci.id]"] = itemcount["[coi.ci.id]"] + 1
			else
				itemcount["[coi.ci.id]"] = 1

			itemnames["[coi.ci.id]"] = coi.ci.name

		if(!dump_query.Execute(list(
			"game_id"=GLOB.round_id,
			"order_id"=co.order_id,
			"status"=co.status,
			"price"=co.price,
			"ordered_by_id"=co.ordered_by_id,
			"ordered_by"=co.ordered_by,
			"authorized_by_id"=co.authorized_by_id,
			"authorized_by"=co.authorized_by,
			"received_by_id"=co.received_by_id,
			"received_by"=co.received_by,
			"paid_by_id"=co.paid_by_id,
			"paid_by"=co.paid_by,
			"time_submitted"=co.time_submitted,
			"time_approved"=co.time_approved,
			"time_shipped"=co.time_shipped,
			"time_delivered"=co.time_delivered,
			"time_paid"=co.time_paid,
			"reason"=co.reason
			)))
			log_subsystem_cargo("SQL: Could not write order to database. Cargo data dump has been aborted.")
			continue

		//Run the query to get the inserted id
		log_id.Execute()

		var/db_log_id = null
		if (log_id.NextRow())
			db_log_id = text2num(log_id.item[1])

		if(db_log_id)
			for(var/item_id in itemcount)
				if(!dump_item_query.Execute(list(
					"cargo_orderlog_id" = db_log_id,
					"item_name"= itemnames[item_id],
					"amount" = itemcount[item_id]
					)))
					log_subsystem_cargo("SQL: Cound not write details of a cargo order.")
					continue
		CHECK_TICK

		log_subsystem_cargo("SQL: Saved cargo order log to database.")


/hook/roundend/proc/dump_cargoorders()
	SScargo.dump_orders()

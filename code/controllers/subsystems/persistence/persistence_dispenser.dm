/datum/persistent_dispenser_stock
	/// The initially mapped dispenser. Its current location is deliberately irrelevant.
	var/obj/structure/machinery/chemical_dispenser/dispenser
	/// Identity derived from the dispenser's original map location and concrete type.
	var/persistent_id
	/// Stock loaded for this dispenser at round start, retained if the dispenser is deleted.
	var/list/previous_stock

/** Returns current stock, or the prior round's stock when the dispenser no longer exists. */
/datum/persistent_dispenser_stock/proc/get_final_stock()
	if(!QDELETED(dispenser))
		return dispenser.get_persistent_cartridge_stock()
	if(islist(previous_stock))
		return previous_stock

/singleton/persistent_type/generic/horizon_dispenser_stock
	/// Persistent drink dispensers present on the Horizon when the round's map finished loading.
	var/list/dispenser_stock_register = list()
	/// Whether initialization completed successfully. Prevents a failed load from overwriting saved stock.
	var/stock_initialized = FALSE

/** Registers mapped dispensers and supplies saved stock for application after their cartridges spawn. */
/singleton/persistent_type/generic/horizon_dispenser_stock/initialization_hook()
	dispenser_stock_register = list()
	stock_initialized = FALSE
	if(!SSpersistence.map_supports_persistence)
		return

	var/list/seen_ids = list()
	for(var/obj/structure/machinery/chemical_dispenser/dispenser in world)
		CHECK_TICK
		var/turf/dispenser_turf = get_turf(dispenser)
		if(!dispenser_turf || !is_station_level(dispenser_turf.z) || !dispenser.persistent_cartridges)
			continue

		var/persistent_id = "[dispenser_turf.x]-[dispenser_turf.y]-[dispenser_turf.z]-[dispenser.type]"
		if(dispenser.persistent_cartridge_id_suffix)
			persistent_id += "-[dispenser.persistent_cartridge_id_suffix]"
		if(seen_ids[persistent_id])
			log_subsystem_persistence_error("Duplicate persistent dispenser ID '[persistent_id]' at [dispenser_turf]. Add a unique persistent_cartridge_id_suffix to one of the mapped dispensers.")
			return
		seen_ids[persistent_id] = TRUE

		var/datum/persistent_dispenser_stock/stock_record = new
		stock_record.dispenser = dispenser
		stock_record.persistent_id = persistent_id
		dispenser.persistent_cartridge_id = persistent_id
		dispenser_stock_register += stock_record

	var/datum/persistent_generic/saved_generic = SSpersistence.genericLoad(/singleton/persistent_type/generic/horizon_dispenser_stock, skip_caching = TRUE)
	var/list/saved_stock = saved_generic?.content
	for(var/datum/persistent_dispenser_stock/stock_record as anything in dispenser_stock_register)
		CHECK_TICK
		var/list/dispenser_stock = saved_stock?[stock_record.persistent_id]
		if(islist(dispenser_stock))
			stock_record.previous_stock = dispenser_stock.Copy()
			stock_record.dispenser.persistent_cartridge_content = dispenser_stock
	stock_initialized = TRUE

/** Saves only canonical stock belonging to each dispenser's original cartridge types. */
/singleton/persistent_type/generic/horizon_dispenser_stock/finalization_hook()
	if(!stock_initialized)
		return

	var/list/all_stock = list()
	for(var/datum/persistent_dispenser_stock/stock_record as anything in dispenser_stock_register)
		CHECK_TICK
		var/list/dispenser_stock = stock_record.get_final_stock()
		if(islist(dispenser_stock))
			all_stock[stock_record.persistent_id] = dispenser_stock

	SSpersistence.genericSave(/singleton/persistent_type/generic/horizon_dispenser_stock, all_stock)

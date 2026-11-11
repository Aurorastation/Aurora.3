/datum/persistent_vending_stock
	/// The initially mapped vendor. Its current location is deliberately irrelevant.
	var/obj/structure/machinery/vending/vendor
	/// Identity derived from the vendor's original map location and concrete type.
	var/persistent_id
	/// Stock loaded for this vendor at round start, retained if the vendor is deleted.
	var/list/previous_stock

/** Returns current stock, or the prior round's stock when the vendor no longer exists. */
/datum/persistent_vending_stock/proc/get_final_stock()
	if(QDELETED(vendor))
		if(islist(previous_stock))
			return previous_stock
		return

	var/list/vendor_stock = list()
	for(var/datum/data/vending_product/product in vendor.product_records)
		// Premium items and contraband are not part of normal persistent stock.
		if(product.category != CAT_NORMAL)
			continue
		var/stock_key = "[product.product_path]|[product.category]"
		vendor_stock[stock_key] = product.amount
	return vendor_stock

/singleton/persistent_type/generic/horizon_vending_stock
	/// Persistent vending machines present on the Horizon when the round's map finished loading.
	var/list/vending_stock_register = list()
	/// Whether initialization completed successfully. Prevents a failed load from overwriting saved stock.
	var/stock_initialized = FALSE

/** Loads saved stock and supplies it to mapped vendors for application during late initialization. */
/singleton/persistent_type/generic/horizon_vending_stock/initialization_hook()
	vending_stock_register = list()
	stock_initialized = FALSE
	if(!SSpersistence.map_supports_persistence)
		return

	var/datum/persistent_generic/saved_generic = SSpersistence.genericLoad(/singleton/persistent_type/generic/horizon_vending_stock, skip_caching = TRUE)
	var/list/saved_stock = saved_generic?.content
	for(var/obj/structure/machinery/vending/vendor in world)
		CHECK_TICK
		var/turf/vendor_turf = get_turf(vendor)
		if(!vendor_turf || !is_station_level(vendor_turf.z) || !vendor.persistent_stock)
			continue

		var/persistent_stock_id = "[vendor_turf.x]-[vendor_turf.y]-[vendor_turf.z]-[vendor.type]"
		vendor.persistent_stock_id = persistent_stock_id
		var/list/vendor_stock = saved_stock?[persistent_stock_id]
		var/datum/persistent_vending_stock/stock_record = new
		stock_record.vendor = vendor
		stock_record.persistent_id = persistent_stock_id
		if(islist(vendor_stock))
			stock_record.previous_stock = vendor_stock.Copy()
			vendor.persistent_stock_content = vendor_stock
		vending_stock_register += stock_record
	stock_initialized = TRUE

/** Saves stock for the initially mapped vendors without considering their current locations. */
/singleton/persistent_type/generic/horizon_vending_stock/finalization_hook()
	if(!stock_initialized)
		return

	var/list/all_stock = list()
	for(var/datum/persistent_vending_stock/stock_record as anything in vending_stock_register)
		CHECK_TICK
		var/list/vendor_stock = stock_record.get_final_stock()
		if(islist(vendor_stock))
			all_stock[stock_record.persistent_id] = vendor_stock

	SSpersistence.genericSave(/singleton/persistent_type/generic/horizon_vending_stock, all_stock)

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

	var/datum/persistent_generic/saved_generic = SSpersistence.genericLoad(/singleton/persistent_type/generic/horizon_vending_stock)
	var/list/saved_stock = saved_generic?.content
	for(var/obj/structure/machinery/vending/vendor in world)
		CHECK_TICK
		var/turf/vendor_turf = get_turf(vendor)
		if(!vendor_turf || !is_station_level(vendor_turf.z) || !vendor.persistent_stock)
			continue

		vending_stock_register += vendor
		var/persistent_stock_id = "[vendor_turf.x],[vendor_turf.y],[vendor_turf.z],[vendor.type]"
		var/list/vendor_stock = saved_stock?[persistent_stock_id]
		if(islist(vendor_stock))
			vendor.receive_persistent_stock(vendor_stock)
	stock_initialized = TRUE

/** Saves stock for the initially mapped vendors without considering their current locations. */
/singleton/persistent_type/generic/horizon_vending_stock/finalization_hook()
	if(!stock_initialized)
		return

	var/list/all_stock = list()
	for(var/obj/structure/machinery/vending/vendor as anything in vending_stock_register)
		CHECK_TICK
		if(QDELETED(vendor))
			continue

		var/list/vendor_stock = list()
		for(var/datum/data/vending_product/product in vendor.product_records)
			if(product.category != CAT_NORMAL)
				continue
			var/stock_key = "[product.product_path]|[product.category]"
			vendor_stock[stock_key] = product.amount
		all_stock[vendor.persistent_stock_id] = vendor_stock

	SSpersistence.genericSave(/singleton/persistent_type/generic/horizon_vending_stock, all_stock)

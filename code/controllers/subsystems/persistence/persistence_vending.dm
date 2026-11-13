/datum/persistent_vending_stock
	/// The initially mapped vendor. Its current location is deliberately irrelevant.
	var/obj/structure/machinery/vending/vendor
	/// Identity derived from the vendor's original map location and name.
	var/persistent_id
	/// Previous identity format, retained while existing type-based saves migrate.
	var/legacy_persistent_id

/** Returns current stock, or null when the vendor no longer exists so its prior generic is left untouched. */
/datum/persistent_vending_stock/proc/get_final_stock()
	if(QDELETED(vendor))
		return

	var/list/vendor_stock = list()
	for(var/datum/data/vending_product/product in vendor.product_records)
		// Premium items and contraband are not part of normal persistent stock.
		if(product.category != CAT_NORMAL)
			continue
		var/stock_key = "[product.product_path]|[product.category]"
		vendor_stock[stock_key] = product.amount
	return vendor_stock

/** Loads the pre-attribute combined JSON record solely as a migration fallback. */
/datum/controller/subsystem/persistence/proc/load_legacy_horizon_vending_stock()
	var/singleton/persistent_type/generic/horizon_vending_stock/type_instance = GET_SINGLETON(/singleton/persistent_type/generic/horizon_vending_stock)
	var/list/database_result = genericDatabaseLoad(type_instance.database_id, null)
	if(!database_result)
		return
	return json_decode(database_result["content"])

/singleton/persistent_type/generic/horizon_vending_stock
	/// Persistent vending machines present on the Horizon, keyed by their generic attribute.
	var/list/vending_stock_register = list()
	/// The same vending machines keyed by the former x-y-z-type attribute for migration.
	var/list/legacy_vending_stock_register = list()
	/// Whether initialization completed successfully. Prevents a failed load from overwriting saved stock.
	var/stock_initialized = FALSE

/** Loads saved stock and supplies it to mapped vendors for application during late initialization. */
/singleton/persistent_type/generic/horizon_vending_stock/initialization_hook()
	vending_stock_register = list()
	legacy_vending_stock_register = list()
	stock_initialized = FALSE
	if(!SSpersistence.map_supports_persistence)
		return

	for(var/obj/structure/machinery/vending/vendor in world)
		CHECK_TICK
		var/turf/vendor_turf = get_turf(vendor)
		if(!vendor_turf || !is_station_level(vendor_turf.z) || !vendor.persistent_stock)
			continue

		var/persistent_stock_id = "[vendor_turf.x]-[vendor_turf.y]-[vendor_turf.z]-[vendor.name]"
		var/legacy_persistent_stock_id = "[vendor_turf.x]-[vendor_turf.y]-[vendor_turf.z]-[vendor.type]"
		vendor.persistent_stock_id = persistent_stock_id
		var/datum/persistent_vending_stock/stock_record = new
		stock_record.vendor = vendor
		stock_record.persistent_id = persistent_stock_id
		stock_record.legacy_persistent_id = legacy_persistent_stock_id
		if(vending_stock_register[persistent_stock_id])
			log_subsystem_persistence_error("Duplicate persistent vending attribute '[persistent_stock_id]' at [vendor_turf].")
			continue
		vending_stock_register[persistent_stock_id] = stock_record
		legacy_vending_stock_register[legacy_persistent_stock_id] = stock_record

	var/list/loaded_attributes = list()
	var/list/saved_attributes = SSpersistence.genericGetAllAttributesForType(/singleton/persistent_type/generic/horizon_vending_stock)
	for(var/persistent_stock_id in saved_attributes)
		CHECK_TICK
		// The pre-migration combined generic has no attribute and is handled separately below.
		if(!length(persistent_stock_id))
			continue
		var/datum/persistent_vending_stock/stock_record = vending_stock_register[persistent_stock_id]
		var/is_current_attribute = !!stock_record
		if(!stock_record)
			stock_record = legacy_vending_stock_register[persistent_stock_id]
		if(!stock_record)
			continue
		// Prefer a name-based save if both it and its old type-based entry still exist.
		if(!is_current_attribute && loaded_attributes[stock_record.persistent_id])
			continue
		var/datum/persistent_generic/saved_generic = SSpersistence.genericLoad(/singleton/persistent_type/generic/horizon_vending_stock, persistent_stock_id, skip_caching = TRUE)
		var/list/vendor_stock = saved_generic?.content
		if(!islist(vendor_stock))
			continue
		stock_record.vendor.persistent_stock_content = vendor_stock
		loaded_attributes[stock_record.persistent_id] = TRUE

	// Existing installations have one unattributed generic containing every vendor. Use it until each live vendor saves its own attribute.
	var/list/legacy_stock = SSpersistence.load_legacy_horizon_vending_stock()
	if(islist(legacy_stock))
		for(var/persistent_stock_id in vending_stock_register)
			CHECK_TICK
			if(loaded_attributes[persistent_stock_id])
				continue
			var/datum/persistent_vending_stock/stock_record = vending_stock_register[persistent_stock_id]
			var/list/vendor_stock = legacy_stock[stock_record.legacy_persistent_id]
			if(!islist(vendor_stock))
				continue
			stock_record.vendor.persistent_stock_content = vendor_stock
	stock_initialized = TRUE

/** Saves stock for the initially mapped vendors without considering their current locations. */
/singleton/persistent_type/generic/horizon_vending_stock/finalization_hook()
	if(!stock_initialized)
		return

	for(var/persistent_stock_id in vending_stock_register)
		CHECK_TICK
		var/datum/persistent_vending_stock/stock_record = vending_stock_register[persistent_stock_id]
		var/list/vendor_stock = stock_record.get_final_stock()
		if(islist(vendor_stock))
			SSpersistence.genericSave(/singleton/persistent_type/generic/horizon_vending_stock, vendor_stock, persistent_stock_id, expires_in_days = 7)

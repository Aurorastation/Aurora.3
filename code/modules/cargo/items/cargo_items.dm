/singleton/cargo_item
	var/category = "miscellaneous"
	var/name = "generic cargo item"
	var/supplier = "generic_supplier"
	var/singleton/cargo_supplier/supplier_data = /singleton/cargo_supplier/generic_supplier
	var/description = "A basic cargo item."
	var/id = 0 //automatically assigned
	var/amount = 1 //amount of items in the order
	var/price = 1
	var/adjusted_price = 1 //automatically assigned
	var/list/items = list() //list of items in the order
	var/access = 0 //req_access level required to order/open the crate
	var/container_type = "crate" //what container it spawns in
	var/groupable = 1 //whether or not this can be combined with other items in a crate
	var/item_mul = 1

/singleton/cargo_item/proc/get_adjusted_price()
	var/return_price = price
	for(var/category in SScargo.cargo_categories)
		var/singleton/cargo_category/cc = SScargo.get_category_by_name(category)
		if(cc)
			return_price *= cc.price_modifier

	adjusted_price = return_price

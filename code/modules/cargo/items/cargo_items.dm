/*
Master singleton for cargo_items.

*/
/singleton/cargo_item
	var/category = "miscellaneous" //MAKE SURE this lines up with the category name in cargo_categories.dm
	var/name = "generic cargo item" //name of the item
	var/supplier = "generic_supplier" //MAKE SURE this lines up with the supplier short_name in cargo_suppliers.dm

	var/description = "A basic cargo item."
	var/amount = 1 //amount of items in the order
	var/price = 1 //price of the item, in credits

	var/list/items = list() //list of items in the order
	var/access = 0 //req_access level required to order/open the crate
	var/container_type = "crate" //what container it spawns in
	var/groupable = 1 //whether or not this can be combined with other items in a crate
	var/item_mul = 1

	//Automatically assigned variables, DO NOT modify these manually
	var/id = 0
	var/adjusted_price = 1
	var/singleton/cargo_supplier/supplier_data = /singleton/cargo_supplier/generic_supplier

/singleton/cargo_item/proc/get_adjusted_price()
	var/return_price = price
	for(var/category in SScargo.cargo_categories)
		var/singleton/cargo_category/cc = SScargo.get_category_by_name(category)
		if(cc)
			return_price *= cc.price_modifier

	adjusted_price = return_price

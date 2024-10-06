/singleton/cargo_supplier
	var/short_name = "Generic" //Short name of the cargo supplier
	var/name = "Generic Supplies Ltd." //Long name of the cargo supplier
	var/description = "The generic company, for generic supplies." //Description of the supplier
	var/tag_line = "Our favorite color is gray!" //Tag line of the supplier
	var/shuttle_time = 0 //Time the shuttle takes to get to the supplier
	var/shuttle_price = 0 //Price to call the shuttle
	var/available = 1 //If the supplier is available
	var/price_modifier = 1 //Price modifier for the supplier
	var/list/items = list() //List of items of the supplier

//Gets a list of supplier - to be json encoded
/singleton/cargo_supplier/proc/get_list()
	var/list/data = list()
	data["short_name"] = short_name
	data["name"] = name
	data["description"] = description
	data["tag_line"] = tag_line
	data["shuttle_time"] = shuttle_time
	data["shuttle_price"] = shuttle_price
	data["available"] = available
	data["price_modifier"] = price_modifier
	return data

/singleton/cargo_supplier/proc/get_total_price_coefficient()
	var/final_coef = price_modifier
	if(SSatlas.current_sector)
		if(short_name in SSatlas.current_sector.cargo_price_coef)
			final_coef = SSatlas.current_sector.cargo_price_coef[short_name] * price_modifier

	return final_coef

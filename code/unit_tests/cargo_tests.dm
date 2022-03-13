/datum/unit_test/cargo
	name = "CARGO: template"

/datum/unit_test/cargo/profit_margins_shall_be_negative
	name = "CARGO: Cargo does not buy items for more than it sells them."

/datum/unit_test/cargo/profit_margins_shall_be_negative/start_test()
	var/debug_string
	var/checked_items = 0
	var/failed_items = 0
	for(var/datum/cargo_item/ci in SScargo.cargo_items)
		debug_string = ""
		for(var/item in ci.items)
			checked_items++
			var/total_export_cost = 0
			for(var/datum/export/E as anything in SScargo.exports_list)
				if(item in E.export_types)
					debug_string += "EXPORTABLE ITEM: [item] with EXPORT COST: [E.total_cost], "
					total_export_cost += E.total_cost
			var/import_cost_per_unit = ci.price / ci.item_mul
			for(var/var_name in ci.items[name]["vars"])
				if(var_name == "amount")
					import_cost_per_unit /= ci.items[item]["vars"][var_name]
					break

			debug_string += "IMPORT_COST_PER_UNIT: [import_cost_per_unit]"
			if(total_export_cost > (ci.price / ci.item_mul))
				failed_items++
				log_unit_test("Cargo item [item] sells for [total_export_cost] which is more than it is purchased for ([import_cost_per_unit])")
		log_unit_test("DEBUG STRING: [debug_string]")
	if(failed_items)
		fail("We're not passing yet! Checked: [checked_items] -- Failed: [failed_items]")
	else
		pass("Not going to be seeing this anytime soon")
	return TRUE

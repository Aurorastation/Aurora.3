/datum/unit_test/cargo_test/crafted_items_check
	name = "CARGO: Items crafted from cargo-sourced materials shall not produce net profit."

/datum/unit_test/cargo_test/crafted_items_check/start_test()
	var/tested_count = 0
	var/error_count = 0
	var/testloc = pick(tdome1)

	if(!testloc)
		fail("Unable to find a location to create test objs")
		return FALSE

	SSmaterials.create_material_lists() // just in case
	for(var/obj/item/stack/material/S as anything in subtypesof(/obj/item/stack/material))
		var/debug_string = ""
		var/obj/item/stack/material/Stemp = new S(testloc, 1)
		var/material/M = Stemp.get_material()
		var/list/datum/stack_recipe_list/recipe_lists = M.get_recipes()
		debug_string += "Testing stack [Stemp], found [length(recipe_lists)] recipes for material [M]"

		var/material_price = SScargo.export_item_and_contents(Stemp, FALSE, FALSE, dry_run=TRUE)
		if(!material_price)
			continue
		debug_string += "- Material price is [material_price] for [Stemp]"
		for(var/datum/stack_recipe_list/L in recipe_lists)
			for(var/datum/stack_recipe/R in L.recipes)
				tested_count++
				var/atom/product = new R.result_type(testloc)
				var/product_price = SScargo.export_item_and_contents(product, FALSE, FALSE, dry_run=TRUE)
				if(!product_price)
					debug_string += "skipping recipe [R.result_type], "
					continue
				var/production_cost = material_price * R.req_amount
				debug_string += "\n - Recipe [R.result_type], PP [product_price], PC [production_cost], PROFIT [product_price - production_cost]"
				if(product_price > production_cost)
					log_unit_test("Product [R.result_type] produced with [R.req_amount] [S] sells for [product_price] but only costs [production_cost] to produce, net profit [product_price - production_cost]")
					error_count++
				qdel(product)
		log_unit_test(debug_string)
		qdel(Stemp)

	if(error_count)
		fail("Found [error_count] / [tested_count] products that produce net profit from cargo.")
	else
		pass("All items crafted from cargo-sourced materials have negative net profit.")

	return TRUE
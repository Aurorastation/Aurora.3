/*
 *  Unit Tests for various recipes.
 *
 */

/datum/unit_test/research_design_cost
	name = "RECIPES: Design Cost"

/datum/unit_test/research_design_cost/start_test()
	var/tested_count = 0
	var/error_count = 0
	for(var/datum/design/D in designs)
		if(ispath(D.build_path, /obj/item))
			var/obj/item/I = D.Fabricate()
			if(I.matter && D.materials && I.recyclable) // non-recyclable items can't be exploited
				for(var/mat in I.matter)
					tested_count++
					if(mat in D.materials)
						if(I.matter[mat] > D.materials[mat])
							fail("Design '[D.name]' costs less material '[mat]' ([D.materials[mat]]) than the product is worth ([I.matter[mat]]).")
							error_count++
					else
						fail("Design '[D.name]' does not require material '[mat]' even though the product is worth [I.matter[mat]].")
						error_count++
			qdel(I)
		qdel(D)

	if(error_count)
		fail("[error_count] design error(s) found. Every research design should cost more than what its product is worth when recycled.")
	else
		pass("All [tested_count] research designs with recyclable products have correct material costs.")

	return 1


/datum/unit_test/stack_recipe_cost
	name = "RECIPES: Stack Recipes"

/datum/unit_test/stack_recipe_cost/start_test()
	var/tested_count = 0
	var/error_count = 0
	SSmaterials.create_material_lists() // just in case
	for(var/material/D in SSmaterials.materials)
		var/list/datum/stack_recipe_list/recipe_lists = D.get_recipes()
		var/list/temp_matter = D.get_matter()
		for(var/datum/stack_recipe_list/L in recipe_lists)
			for(var/datum/stack_recipe/R in L.recipes)
				if(!ispath(R.result_type, /obj/item))
					continue
				var/obj/item/I = R.Produce()
				if(I.matter && I.recyclable) // non-recyclable items can't be exploited
					tested_count++
					for(var/mat in I.matter)
						if(mat in temp_matter)
							var/item_matter_value = I.matter[mat] * R.res_amount
							var/consumed_matter_value = temp_matter[mat] * R.req_amount
							if(item_matter_value > consumed_matter_value)
								fail("Recipe '[R.title]' on material '[D.name]' consumes less material '[mat]' ([R.req_amount] × [temp_matter[mat]] = [consumed_matter_value]) than the product is worth ([R.res_amount] × [I.matter[mat]] = [item_matter_value]).")
								error_count++
						else
							warn("Recipe '[R.title]' on material '[D.name]' creates product with material '[mat]', but that material is not required by the recipe.")
				qdel(I)
		qdel(D)

	if(error_count)
		fail("[error_count] stack recipe error(s) found. Every stack recipe should cost more than what its product is worth when recycled.")
	else
		pass("All [tested_count] stack recipes with recyclable /obj/item products have correct material costs.")

	return 1

/*
 *  Unit Tests for various recipes.
 *
 */

/datum/unit_test/research_design_cost
	name = "RECIPES: Design Cost"
	groups = list("generic", "research")

/datum/unit_test/research_design_cost/start_test()
	var/tested_count = 0
	var/error_count = 0
	for(var/datum/design/D in GLOB.designs)
		if(ispath(D.build_path, /obj/item))
			var/obj/item/I = D.Fabricate()
			if(I.matter && D.materials && I.recyclable) // non-recyclable items can't be exploited
				var/list/product_matter = I.matter.Copy()
				var/list/design_materials = D.materials.Copy()
				SSmaterials.normalize_material_amounts(product_matter)
				SSmaterials.normalize_material_amounts(design_materials)
				for(var/mat in product_matter)
					tested_count++
					if(mat in design_materials)
						if(product_matter[mat] > design_materials[mat])
							TEST_FAIL("Design '[D.name]' costs less material '[SSmaterials.material_display_name(mat)]' ([design_materials[mat]]) than the product is worth ([product_matter[mat]]).")
							error_count++
					else
						TEST_FAIL("Design '[D.name]' does not require material '[SSmaterials.material_display_name(mat)]' even though the product is worth [product_matter[mat]].")
						error_count++
			qdel(I)
		qdel(D)

	if(error_count)
		TEST_FAIL("[error_count] design error(s) found. Every research design should cost more than what its product is worth when recycled.")
	else
		TEST_PASS("All [tested_count] research designs with recyclable products have correct material costs.")

	return 1


/datum/unit_test/stack_recipe_cost
	name = "RECIPES: Stack Recipes"
	groups = list("generic")

/datum/unit_test/stack_recipe_cost/start_test()
	var/tested_count = 0
	var/error_count = 0
	var/list/materials = GET_SINGLETON_SUBTYPE_MAP(/singleton/material)
	for(var/singleton/material/D in materials)
		var/list/datum/stack_recipe_list/recipe_lists = D.get_recipes()
		var/list/temp_matter = D.get_matter()
		SSmaterials.normalize_material_amounts(temp_matter)
		for(var/datum/stack_recipe_list/L in recipe_lists)
			for(var/datum/stack_recipe/R in L.recipes)
				if(!ispath(R.result_type, /obj/item))
					continue
				var/obj/item/I = R.Produce()
				if(I.matter && I.recyclable) // non-recyclable items can't be exploited
					tested_count++
					var/list/product_matter = I.matter.Copy()
					SSmaterials.normalize_material_amounts(product_matter)
					for(var/mat in product_matter)
						if(mat in temp_matter)
							var/item_matter_value = product_matter[mat] * R.res_amount
							var/consumed_matter_value = temp_matter[mat] * R.req_amount
							if(item_matter_value > consumed_matter_value)
								TEST_FAIL("Recipe '[R.title]' on material '[D.name]' consumes less material '[SSmaterials.material_display_name(mat)]' ([R.req_amount] × [temp_matter[mat]] = [consumed_matter_value]) than the product is worth ([R.res_amount] × [product_matter[mat]] = [item_matter_value]).")
								error_count++
						else
							TEST_WARN("Recipe '[R.title]' on material '[D.name]' creates product with material '[SSmaterials.material_display_name(mat)]', but that material is not required by the recipe.")
				qdel(I)

	if(error_count)
		TEST_FAIL("[error_count] stack recipe error(s) found. Every stack recipe should cost more than what its product is worth when recycled.")
	else
		TEST_PASS("All [tested_count] stack recipes with recyclable /obj/item products have correct material costs.")

	return 1

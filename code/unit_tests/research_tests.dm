/*
 *  Research Unit Tests.
 *
 */

#define SUCCESS 1
#define FAILURE 0

datum/unit_test/research_design_cost
	name = "RESEARCH: Design Cost"

datum/unit_test/research_design_cost/start_test()
	var/error_count = 0
	for(var/T in subtypesof(/datum/design))
		var/datum/design/D = new T
		if(ispath(D.build_path, /obj/item))
			var/obj/item/I = D.Fabricate()
			if(I.matter && D.materials && I.recyclable) // non-recyclable items can't be exploited
				for(var/mat in I.matter)
					if(mat in D.materials)
						if(I.matter[mat] > D.materials[mat])
							fail("Design '[D.name]' costs less material '[mat]' ([D.materials[mat]]) than the product is worth ([I.matter[mat]]).")
							error_count++
					else
						fail("Design '[D.name]' does not require material '[mat]' even though the product is worth [I.matter[mat]].")
						error_count++
			qdel(I)

	if(error_count)
		fail("[error_count] design error(s) found. Every research design should cost more than what its product is worth.")
	else
		pass("All research designs have correct material costs.")

	return 1

#undef SUCCESS
#undef FAILURE

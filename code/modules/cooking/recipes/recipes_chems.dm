/decl/recipe/chem
	appliance = null // specify on subtypes
	result_quantity = 0 // so no attempts is made to create the null recipe
	var/list/resulting_reagents // for example, list(/decl/reagent/tea = 10)

/decl/recipe/chem/make_food(obj/container/C)
	for(chem in resulting_reagents)
		C.reagents.add_reagent(chem, resulting_reagents[chem])
	. = ..()

/decl/recipe/messatea
	appliance = SAUCEPAN | POT
	fruit = list("mtear" = 1)
	reagents = list(/decl/reagent/water = 10)
	resulting_reagents = list(/decl/reagent/messatea)

/decl/recipe/friedkois
	appliance = SKILLET
	fruit = list("koisspore" = 1)
	result = /obj/item/reagent_containers/food/snacks/friedkois

/decl/recipe/koiswaffles
	appliance = SKILLET
	items = list(/obj/item/reagent_containers/food/snacks/soup/kois)
	result = /obj/item/reagent_containers/food/snacks/koiswaffles

/decl/recipe/koisjelly
	appliance = SAUCEPAN
	fruit = list("koisspore" = 2)
	items = list(/obj/item/reagent_containers/food/snacks/soup/kois)
	result = /obj/item/reagent_containers/food/snacks/koisjelly

/decl/recipe/koissteak
	appliance = SKILLET
	items = list(/obj/item/reagent_containers/food/snacks/friedkois)
	result = /obj/item/reagent_containers/food/snacks/koissteak

/decl/recipe/koismuffin
	appliance = OVEN
	items = list(/obj/item/reagent_containers/food/snacks/soup/kois)
	result = /obj/item/reagent_containers/food/snacks/koismuffin

/decl/recipe/koisburger
	items = list(
				/obj/item/reagent_containers/food/snacks/friedkois,
				/obj/item/reagent_containers/food/snacks/friedkois
	)
	result = /obj/item/reagent_containers/food/snacks/koisburger

/decl/recipe/koisdonut
	appliance = FRYER
	items = list(/obj/item/reagent_containers/food/snacks/friedkois)
	result = /obj/item/reagent_containers/food/snacks/donut/kois
	result_quantity = 2
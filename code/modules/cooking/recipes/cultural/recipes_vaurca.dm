/singleton/recipe/friedkois
	appliance = SKILLET
	fruit = list("koisspore" = 1)
	result = /obj/item/reagent_containers/food/snacks/friedkois

/singleton/recipe/koiswaffles
	appliance = SKILLET
	items = list(/obj/item/reagent_containers/food/snacks/soup/kois)
	result = /obj/item/reagent_containers/food/snacks/koiswaffles

/singleton/recipe/koisjelly
	appliance = SAUCEPAN
	fruit = list("koisspore" = 2)
	items = list(/obj/item/reagent_containers/food/snacks/soup/kois)
	result = /obj/item/reagent_containers/food/snacks/koisjelly

/singleton/recipe/koissteak
	appliance = SKILLET
	items = list(/obj/item/reagent_containers/food/snacks/friedkois)
	result = /obj/item/reagent_containers/food/snacks/koissteak

/singleton/recipe/koisdonut
	appliance = FRYER
	items = list(/obj/item/reagent_containers/food/snacks/friedkois)
	result = /obj/item/reagent_containers/food/snacks/donut/kois
	result_quantity = 2

/singleton/recipe/koismuffin
	appliance = OVEN
	items = list(/obj/item/reagent_containers/food/snacks/soup/kois)
	result = /obj/item/reagent_containers/food/snacks/koismuffin

/singleton/recipe/koisburger
	items = list(
				/obj/item/reagent_containers/food/snacks/friedkois,
				/obj/item/reagent_containers/food/snacks/friedkois
	)
	result = /obj/item/reagent_containers/food/snacks/koisburger

/singleton/recipe/vkrexiwrap
	items = list(
		/obj/item/reagent_containers/food/snacks/tortilla,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/meatball
	)
	reagents = list(/singleton/reagent/mental/vkrexi = 1)
	result = /obj/item/reagent_containers/food/snacks/vkrexiwrap

/singleton/recipe/vkrexiwrap/veggie
	fruit = list("chili" = 1, "cabbage" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/tortilla,
	)
	result = /obj/item/reagent_containers/food/snacks/vkrexiwrap/veggie

/singleton/recipe/loadedbakedpotato
	appliance = OVEN
	fruit = list("potato" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/cheesewedge)
	result = /obj/item/reagent_containers/food/snacks/loadedbakedpotato

/singleton/recipe/ribplate //Putting this here for not seeing a roast section.
	appliance = OVEN
	reagents = list(/singleton/reagent/nutriment/honey = 5, /singleton/reagent/spacespice = 2, /singleton/reagent/blackpepper = 1)
	items = list(/obj/item/reagent_containers/food/snacks/meat)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/ribplate

/singleton/recipe/eggplantparm
	appliance = OVEN
	fruit = list("eggplant" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
		)
	result = /obj/item/reagent_containers/food/snacks/eggplantparm

/singleton/recipe/meat_pocket
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/meat_pocket
	result_quantity = 2

/singleton/recipe/donkpocket
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/meatball
	)
	result = /obj/item/reagent_containers/food/snacks/donkpocket //does it make sense for newly made donk to come out cold? no, do I care? coincidentally, also no.

/singleton/recipe/plumphelmetbiscuit
	appliance = OVEN
	fruit = list("plumphelmet" = 1)
	reagents = list(/singleton/reagent/water = 5, /singleton/reagent/nutriment/flour = 5)
	result = /obj/item/reagent_containers/food/snacks/plumphelmetbiscuit

/singleton/recipe/spacylibertyduff
	appliance = OVEN
	reagents = list(/singleton/reagent/water = 5, /singleton/reagent/alcohol/vodka = 5, /singleton/reagent/drugs/psilocybin = 5)
	result = /obj/item/reagent_containers/food/snacks/spacylibertyduff

/singleton/recipe/hotdiggitydonk //heated donk, in lieu of a microwave
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/donkpocket
	)
	result = /obj/item/reagent_containers/food/snacks/donkpocket/warm

/singleton/recipe/donkteriyaki //heated donk, in lieu of a microwave
	appliance = OVEN
	items = list(/obj/item/reagent_containers/food/snacks/donkpocket/teriyaki)
	result = /obj/item/reagent_containers/food/snacks/donkpocket/teriyaki/warm

/singleton/recipe/donktakoyaki //heated donk, in lieu of a microwave
	appliance = OVEN
	items = list(/obj/item/reagent_containers/food/snacks/donkpocket/takoyaki)
	result = /obj/item/reagent_containers/food/snacks/donkpocket/takoyaki/warm

/singleton/recipe/meat_lasagna_tray
	appliance = OVEN
	fruit = list("tomato" = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/meat_lasagna_tray
	reagent_mix = RECIPE_REAGENT_REPLACE //Replacing the ingredients and filling in a bit extra for simplicity's sake

/singleton/recipe/veggie_lasagna_tray
	appliance = OVEN
	fruit = list("tomato" = 3, "eggplant" = 1, "onion" = 1, "mushroom" = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/veggie_lasagna_tray
	reagent_mix = RECIPE_REAGENT_REPLACE //Replacing the ingredients and filling in a bit extra for simplicity's sake

/singleton/recipe/pigs_in_a_blanket
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/sausage,
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/reagent_containers/food/snacks/doughslice
	)
	result = /obj/item/reagent_containers/food/snacks/pig_in_a_blanket
	result_quantity = 3

/singleton/recipe/stuffed_peppers_meat
	appliance = OVEN
	fruit = list("bellpepper" = 1, "tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/meat
	)
	result = /obj/item/reagent_containers/food/snacks/stuffed_pepper_meat
	result_quantity = 2

/singleton/recipe/stuffed_peppers_rice
	appliance = OVEN
	fruit = list("bellpepper" = 1, "corn" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/boiledrice
	)
	result = /obj/item/reagent_containers/food/snacks/stuffed_pepper_rice
	result_quantity = 2

/singleton/recipe/baked_apple
	appliance = OVEN
	fruit = list("apple" = 1)
	reagents = list(/singleton/reagent/sugar = 5, /singleton/reagent/spacespice = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/no_raisin
	)
	result = /obj/item/reagent_containers/food/snacks/baked_apple
	reagent_mix = RECIPE_REAGENT_REPLACE

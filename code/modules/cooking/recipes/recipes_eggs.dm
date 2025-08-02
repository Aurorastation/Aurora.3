
/singleton/recipe/chocolateegg
	appliance = SAUCEPAN | POT | MICROWAVE // melt the chocolate
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/chocolatebar
	)
	result = /obj/item/reagent_containers/food/snacks/chocolateegg

/singleton/recipe/friedegg
	appliance = SKILLET | MICROWAVE
	items = list(
		/obj/item/reagent_containers/food/snacks/friedegg/overeasy
	)
	result = /obj/item/reagent_containers/food/snacks/friedegg

/singleton/recipe/friedegg_easy
	appliance = SKILLET | MICROWAVE
	reagents = list(/singleton/reagent/sodiumchloride = 1, /singleton/reagent/blackpepper = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/egg
	)
	result = /obj/item/reagent_containers/food/snacks/friedegg/overeasy

/singleton/recipe/boiledegg
	appliance = SAUCEPAN | POT | MICROWAVE
	reagents = list(/singleton/reagent/water = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/egg
	)
	result = /obj/item/reagent_containers/food/snacks/boiledegg

/singleton/recipe/bacon_and_eggs
	appliance = SKILLET | MICROWAVE
	items = list(
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/friedegg
	)
	result = /obj/item/reagent_containers/food/snacks/bacon_and_eggs

/singleton/recipe/omelette
	appliance = SKILLET
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	reagents = list(/singleton/reagent/nutriment/protein/egg = 6)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/omelette

/singleton/recipe/poachedegg
	appliance = SKILLET | SAUCEPAN
	reagents = list(/singleton/reagent/spacespice = 1, /singleton/reagent/sodiumchloride = 1, /singleton/reagent/blackpepper = 1, /singleton/reagent/water = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/egg
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Get that water outta here
	result = /obj/item/reagent_containers/food/snacks/poachedegg

/singleton/recipe/chawanmushi
	appliance = SAUCEPAN
	fruit = list("mushroom" = 1)
	reagents = list(/singleton/reagent/water = 5, /singleton/reagent/nutriment/soysauce = 5, /singleton/reagent/nutriment/protein/egg = 6)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/chawanmushi

/singleton/recipe/shakshouka
	appliance = SKILLET
	fruit = list("tomato" = 2)
	reagent_mix = RECIPE_REAGENT_REPLACE //Get that water outta here
	reagents = list(/singleton/reagent/spacespice = 2, /singleton/reagent/blackpepper = 1, /singleton/reagent/nutriment/protein/egg = 6)
	result = /obj/item/reagent_containers/food/snacks/shakshouka

/singleton/recipe/eggs_benedict
	appliance = MIX
	reagents = list(/singleton/reagent/nutriment/protein/egg = 3, /singleton/reagent/blackpepper = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/plumphelmetbiscuit,
		/obj/item/reagent_containers/food/snacks/poachedegg,
		/obj/item/reagent_containers/food/snacks/cutlet
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/eggs_benedict

/singleton/recipe/nakarka_omelette
	appliance = SKILLET
	items = list(
		/obj/item/reagent_containers/food/snacks/nakarka_wedge,
		/obj/item/reagent_containers/food/snacks/nakarka_wedge
	)
	reagents = list(/singleton/reagent/nutriment/protein/egg = 6)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/nakarka_omelette

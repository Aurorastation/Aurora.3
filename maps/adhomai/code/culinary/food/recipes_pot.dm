/datum/recipe/tajaran_stew
	fruit = list("nifberries" = 2, "nfrihi" = 1, "mtear" = 1)
	reagents = list("water" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/adhomai,
		/obj/item/weapon/reagent_containers/food/snacks/meat/adhomai
	)
	appliance = MICROWAVE | POT
	result = /obj/item/weapon/reagent_containers/food/snacks/tajaran_stew

/datum/recipe/spicy_clams
	fruit = list("nifberries" = 1)
	reagents = list("blackpepper" = 1, "spacespice" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/clam,
		/obj/item/weapon/reagent_containers/food/snacks/clam
	)
	appliance = MICROWAVE | POT
	result = /obj/item/weapon/reagent_containers/food/snacks/spicy_clams

/datum/recipe/tajaran_chowder
	fruit = list("nfrihi" = 1)
	reagents = list("blackpepper" = 1, "sodiumchloride" = 1, "spacespice" = 2)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/clam,
		/obj/item/weapon/reagent_containers/food/snacks/clam,
		/obj/item/weapon/reagent_containers/food/snacks/spreads/butter
	)
	appliance = MICROWAVE | POT
	result = /obj/item/weapon/reagent_containers/food/snacks/tajaran_chowder

/datum/recipe/earthenroot_soup
	fruit = list("earthenroot" = 2)
	reagents = list("water" = 10, "spacespice" = 1, "sodiumchloride" = 1)
	appliance = MICROWAVE | POT
	result = /obj/item/weapon/reagent_containers/food/snacks/soup/earthenroot

/datum/recipe/fatshouter_cheese
	fruit = list("nifberries" = 2)
	reagents = list("fatshouter_milk" = 40, "sodiumchloride" = 2)
	appliance = POT
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/cheesewheel/fatshouter

/datum/recipe/purifiedwater
	reagents = list("salt_water")
	appliance = POT
	result = /obj/item/weapon/reagent_containers/food/snacks/coarsesalt
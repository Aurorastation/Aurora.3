/datum/recipe/pizzamargherita
	appliance = OVEN
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita

/datum/recipe/meatpizza
	appliance = OVEN
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza

/datum/recipe/syntipizza
	appliance = OVEN
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza

/datum/recipe/mushroompizza
	appliance = OVEN
	fruit = list("mushroom" = 5, "tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)

	reagent_mix = RECIPE_REAGENT_REPLACE //No vomit taste in finished product from chanterelles
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza

/datum/recipe/vegetablepizza
	appliance = OVEN
	fruit = list("eggplant" = 1, "carrot" = 1, "corn" = 1, "tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza

/datum/recipe/pineapplepizza
	appliance = OVEN
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/pineapple_ring,
		/obj/item/reagent_containers/food/snacks/pineapple_ring
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/pineapple

/datum/recipe/bacon_flatbread
	appliance = OVEN
	fruit = list("tomato" = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/bacon
	)
	result = /obj/item/reagent_containers/food/snacks/bacon_flatbread

/datum/recipe/soywafers
	appliance = OVEN
	fruit = list("soybeans" = 1)
	reagents = list(/datum/reagent/nutriment/flour = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/soywafers

/datum/recipe/berryclafoutis
	appliance = OVEN
	fruit = list("berries" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/reagent_containers/food/snacks/berryclafoutis

/datum/recipe/loadedbakedpotato
	appliance = OVEN
	fruit = list("potato" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/cheesewedge)
	result = /obj/item/reagent_containers/food/snacks/loadedbakedpotato

/datum/recipe/dionaroast
	appliance = OVEN
	fruit = list("apple" = 1)
	reagents = list(/datum/reagent/acid/polyacid = 5) //It dissolves the carapace. Still poisonous, though.
	items = list(/obj/item/reagent_containers/food/snacks/meat/dionanymph)
	result = /obj/item/reagent_containers/food/snacks/sliceable/dionaroast
	reagent_mix = RECIPE_REAGENT_REPLACE //No eating polyacid

/datum/recipe/ribplate //Putting this here for not seeing a roast section.
	appliance = OVEN
	reagents = list(/datum/reagent/nutriment/honey = 5, /datum/reagent/spacespice = 2, /datum/reagent/blackpepper = 1)
	items = list(/obj/item/reagent_containers/food/snacks/meat)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/ribplate

/datum/recipe/eggplantparm
	appliance = OVEN
	fruit = list("eggplant" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
		)
	result = /obj/item/reagent_containers/food/snacks/eggplantparm

/datum/recipe/meat_pocket
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/meat_pocket
	result_quantity = 2

/datum/recipe/donkpocket
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/meatball
	)
	result = /obj/item/reagent_containers/food/snacks/donkpocket //does it make sense for newly made donk to come out cold? no, do I care? coincidentally, also no.

/datum/recipe/plumphelmetbiscuit
	appliance = OVEN
	fruit = list("plumphelmet" = 1)
	reagents = list(/datum/reagent/water = 5, /datum/reagent/nutriment/flour = 5)
	result = /obj/item/reagent_containers/food/snacks/plumphelmetbiscuit

/datum/recipe/spacylibertyduff
	appliance = OVEN
	reagents = list(/datum/reagent/water = 5, /datum/reagent/alcohol/ethanol/vodka = 5, /datum/reagent/psilocybin = 5)
	result = /obj/item/reagent_containers/food/snacks/spacylibertyduff

/datum/recipe/hotdiggitydonk //heated donk, in lieu of a microwave
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/donkpocket
	)
	result = /obj/item/reagent_containers/food/snacks/donkpocket/warm

/datum/recipe/rofflewaffles
	appliance = OVEN
	reagents = list(/datum/reagent/psilocybin = 5, /datum/reagent/sugar = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/rofflewaffles

/singleton/recipe/pizzamargherita
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

/singleton/recipe/meatpizza
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

/singleton/recipe/syntipizza
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

/singleton/recipe/mushroompizza
	appliance = OVEN
	fruit = list("mushroom" = 5, "tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)

	reagent_mix = RECIPE_REAGENT_REPLACE //No vomit taste in finished product from chanterelles
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza

/singleton/recipe/vegetablepizza
	appliance = OVEN
	fruit = list("eggplant" = 1, "carrot" = 1, "corn" = 1, "tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza

/singleton/recipe/pineapplepizza
	appliance = OVEN
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/pineapple_ring,
		/obj/item/reagent_containers/food/snacks/pineapple_ring
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/pineapple

/singleton/recipe/bacon_flatbread
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

/singleton/recipe/soywafers
	appliance = OVEN
	fruit = list("soybeans" = 1)
	reagents = list(/singleton/reagent/nutriment/flour = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/soywafers

/singleton/recipe/berryclafoutis
	appliance = OVEN
	fruit = list("berries" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/reagent_containers/food/snacks/berryclafoutis

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
	reagents = list(/singleton/reagent/water = 5, /singleton/reagent/alcohol/vodka = 5, /singleton/reagent/psilocybin = 5)
	result = /obj/item/reagent_containers/food/snacks/spacylibertyduff

/singleton/recipe/hotdiggitydonk //heated donk, in lieu of a microwave
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/donkpocket
	)
	result = /obj/item/reagent_containers/food/snacks/donkpocket/warm

/singleton/recipe/rofflewaffles
	appliance = OVEN
	reagents = list(/singleton/reagent/psilocybin = 5, /singleton/reagent/sugar = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/rofflewaffles

/singleton/recipe/moss_dumplings
	appliance = OVEN
	fruit = list("moss" = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/moss_dumplings
	result_quantity = 2
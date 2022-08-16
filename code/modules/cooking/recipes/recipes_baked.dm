/decl/recipe/pizzamargherita
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

/decl/recipe/meatpizza
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

/decl/recipe/syntipizza
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

/decl/recipe/mushroompizza
	appliance = OVEN
	fruit = list("mushroom" = 5, "tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)

	reagent_mix = RECIPE_REAGENT_REPLACE //No vomit taste in finished product from chanterelles
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza

/decl/recipe/vegetablepizza
	appliance = OVEN
	fruit = list("eggplant" = 1, "carrot" = 1, "corn" = 1, "tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza

/decl/recipe/pineapplepizza
	appliance = OVEN
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/pineapple_ring,
		/obj/item/reagent_containers/food/snacks/pineapple_ring
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/pineapple

/decl/recipe/bacon_flatbread
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

/decl/recipe/soywafers
	appliance = OVEN
	fruit = list("soybeans" = 1)
	reagents = list(/decl/reagent/nutriment/flour = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/soywafers

/decl/recipe/berryclafoutis
	appliance = OVEN
	fruit = list("berries" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/reagent_containers/food/snacks/berryclafoutis

/decl/recipe/loadedbakedpotato
	appliance = OVEN
	fruit = list("potato" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/cheesewedge)
	result = /obj/item/reagent_containers/food/snacks/loadedbakedpotato

/decl/recipe/ribplate //Putting this here for not seeing a roast section.
	appliance = OVEN
	reagents = list(/decl/reagent/nutriment/honey = 5, /decl/reagent/spacespice = 2, /decl/reagent/blackpepper = 1)
	items = list(/obj/item/reagent_containers/food/snacks/meat)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/ribplate

/decl/recipe/eggplantparm
	appliance = OVEN
	fruit = list("eggplant" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
		)
	result = /obj/item/reagent_containers/food/snacks/eggplantparm

/decl/recipe/meat_pocket
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/meatball,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/meat_pocket
	result_quantity = 2

/decl/recipe/donkpocket
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/meatball
	)
	result = /obj/item/reagent_containers/food/snacks/donkpocket //does it make sense for newly made donk to come out cold? no, do I care? coincidentally, also no.

/decl/recipe/plumphelmetbiscuit
	appliance = OVEN
	fruit = list("plumphelmet" = 1)
	reagents = list(/decl/reagent/water = 5, /decl/reagent/nutriment/flour = 5)
	result = /obj/item/reagent_containers/food/snacks/plumphelmetbiscuit

/decl/recipe/spacylibertyduff
	appliance = OVEN
	reagents = list(/decl/reagent/water = 5, /decl/reagent/alcohol/vodka = 5, /decl/reagent/psilocybin = 5)
	result = /obj/item/reagent_containers/food/snacks/spacylibertyduff

/decl/recipe/hotdiggitydonk //heated donk, in lieu of a microwave
	appliance = OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/donkpocket
	)
	result = /obj/item/reagent_containers/food/snacks/donkpocket/warm

/decl/recipe/rofflewaffles
	appliance = OVEN
	reagents = list(/decl/reagent/psilocybin = 5, /decl/reagent/sugar = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/rofflewaffles

/decl/recipe/moss_dumplings
	appliance = OVEN
	fruit = list("moss" = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/moss_dumplings
	result_quantity = 2
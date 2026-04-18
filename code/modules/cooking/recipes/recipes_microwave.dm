/singleton/recipe/microwave_olive_pizza
	appliance = MICROWAVE | OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/frozen_microwave_pizza/olive
	)
	result = /obj/item/reagent_containers/food/snacks/microwave_pizza/olive
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/microwave_district6_pizza
	appliance = MICROWAVE | OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/frozen_microwave_pizza/district6
	)
	result = /obj/item/reagent_containers/food/snacks/microwave_pizza/district6
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/microwave_pepperoni_pizza
	appliance = MICROWAVE | OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/frozen_microwave_pizza/district6
	)
	result = /obj/item/reagent_containers/food/snacks/microwave_pizza/district6
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/microwave_pizza_homemade
	appliance = MICROWAVE | OVEN
	reagents = list(/singleton/reagent/nutriment/ketchup = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/microwave_pizza

/singleton/recipe/microwave_pizza
	appliance = MICROWAVE | OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/frozen_microwave_pizza
	)
	result = /obj/item/reagent_containers/food/snacks/microwave_pizza
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/instant_mac_and_cheeze
	appliance = MICROWAVE
	items = list(
		/obj/item/reagent_containers/food/snacks/packaged_microwave_mac_and_cheeze
	)
	result = /obj/item/reagent_containers/food/snacks/instant_mac
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/instant_fiery_mac_and_cheeze
	appliance = MICROWAVE
	items = list(
		/obj/item/reagent_containers/food/snacks/packaged_microwave_fiery_mac_and_cheeze
	)
	result = /obj/item/reagent_containers/food/snacks/instant_mac_fiery
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/microwave_burger
	appliance = MICROWAVE | OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/frozen_burger
	)
	result = /obj/item/reagent_containers/food/snacks/quick_e_burger
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/microwave_mossburger
	appliance = MICROWAVE | OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/frozen_mossburger
	)
	result = /obj/item/reagent_containers/food/snacks/burger/moss/sad
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/microwave_curry
	appliance = MICROWAVE
	items = list(
		/obj/item/reagent_containers/food/snacks/quick_curry
	)
	result = /obj/item/reagent_containers/food/snacks/quick_curry_prepared
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/microwave_hv_dinner
	appliance = MICROWAVE
	items = list(
		/obj/item/reagent_containers/food/snacks/hv_dinner
	)
	result = /obj/item/reagent_containers/food/snacks/hv_dinner_prepared
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/strawberry_toptart
	appliance = MICROWAVE | OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/toptart_strawberry_raw
	)
	result = /obj/item/reagent_containers/food/snacks/toptart_strawberry
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/chocolate_peanutbutter_toptart
	appliance = MICROWAVE | OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/toptart_chocolate_peanutbutter_raw
	)
	result = /obj/item/reagent_containers/food/snacks/toptart_chocolate_peanutbutter
	reagent_mix = RECIPE_REAGENT_REPLACE

/singleton/recipe/blueberry_toptart
	appliance = MICROWAVE | OVEN
	items = list(
		/obj/item/reagent_containers/food/snacks/toptart_blueberry_raw
	)
	result = /obj/item/reagent_containers/food/snacks/toptart_blueberry
	reagent_mix = RECIPE_REAGENT_REPLACE

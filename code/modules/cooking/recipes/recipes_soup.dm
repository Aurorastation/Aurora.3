
/singleton/recipe/meatballsoup
	appliance = SAUCEPAN | POT
	fruit = list("carrot" = 1, "potato" = 1)
	reagents = list(/singleton/reagent/water = 10)
	items = list(/obj/item/reagent_containers/food/snacks/meatball)
	result = /obj/item/reagent_containers/food/snacks/soup/meatball

/singleton/recipe/bloodsoup
	appliance = SAUCEPAN | POT
	reagents = list(/singleton/reagent/blood = 30)
	result = /obj/item/reagent_containers/food/snacks/soup/blood

/singleton/recipe/slimesoup
	appliance = SAUCEPAN | POT
	reagents = list(/singleton/reagent/water = 10, /singleton/reagent/slimejelly = 5)
	items = list()
	result = /obj/item/reagent_containers/food/snacks/soup/slime

/singleton/recipe/vegetablesoup
	appliance = SAUCEPAN | POT
	fruit = list("carrot" = 1, "potato" = 1, "corn" = 1, "eggplant" = 1)
	reagents = list(/singleton/reagent/water = 10)
	result = /obj/item/reagent_containers/food/snacks/soup/vegetable

/singleton/recipe/nettlesoup
	appliance = SAUCEPAN | POT
	fruit = list("nettle" = 1, "potato" = 1, )
	reagents = list(/singleton/reagent/water = 10, /singleton/reagent/nutriment/protein/egg = 3)
	result = /obj/item/reagent_containers/food/snacks/soup/nettle

/singleton/recipe/mysterysoup
	appliance = POT
	reagents = list(/singleton/reagent/water = 10, /singleton/reagent/nutriment/protein/egg = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/badrecipe,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/soup/mystery

/singleton/recipe/wishsoup
	appliance = SAUCEPAN | POT
	reagents = list(/singleton/reagent/water = 20)
	result= /obj/item/reagent_containers/food/snacks/soup/wish

/singleton/recipe/onionsoup
	appliance = SAUCEPAN | POT
	fruit = list("onion" = 1)
	reagents = list(/singleton/reagent/water = 10)
	result = /obj/item/reagent_containers/food/snacks/soup/onion

/singleton/recipe/tomatosoup
	appliance = SAUCEPAN | POT
	fruit = list("tomato" = 2)
	reagents = list(/singleton/reagent/water = 10)
	result = /obj/item/reagent_containers/food/snacks/soup/tomato

/singleton/recipe/bluespacetomatosoup
	appliance = SAUCEPAN | POT
	fruit = list("bluespacetomato" = 2)
	reagents = list(/singleton/reagent/water = 10)
	result = /obj/item/reagent_containers/food/snacks/soup/bluespace

/singleton/recipe/misosoup
	appliance = POT
	reagents = list(/singleton/reagent/water = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/soydope,
		/obj/item/reagent_containers/food/snacks/soydope,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/soup/miso

/singleton/recipe/mushroomsoup
	appliance = SAUCEPAN | POT
	fruit = list("mushroom" = 1)
	reagents = list(/singleton/reagent/water = 5, /singleton/reagent/drink/milk = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/soup/mushroom

/singleton/recipe/beetsoup
	appliance = SAUCEPAN | POT
	fruit = list("whitebeet" = 1, "cabbage" = 1)
	reagents = list(/singleton/reagent/water = 10)
	result = /obj/item/reagent_containers/food/snacks/soup/beet

// Stews
/singleton/recipe/stew
	appliance = POT
	fruit = list("potato" = 1, "tomato" = 1, "carrot" = 1, "eggplant" = 1, "mushroom" = 1)
	reagents = list(/singleton/reagent/water = 10)
	items = list(/obj/item/reagent_containers/food/snacks/meat)
	result = /obj/item/reagent_containers/food/snacks/stew

/singleton/recipe/bearstew
	appliance = POT
	fruit = list("potato" = 1, "tomato" = 1, "carrot" = 1, "eggplant" = 1, "mushroom" = 1)
	reagents = list(/singleton/reagent/water = 10)
	items = list(/obj/item/reagent_containers/food/snacks/bearmeat)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/stew/bear

// Chili
/singleton/recipe/bearchili
	appliance = SAUCEPAN | POT
	fruit = list("chili" = 1, "tomato" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/bearmeat)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/bearchili

/singleton/recipe/hotchili
	appliance = SAUCEPAN | POT
	fruit = list("chili" = 1, "tomato" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/meat)
	result = /obj/item/reagent_containers/food/snacks/hotchili

/singleton/recipe/coldchili
	appliance = SAUCEPAN | POT
	fruit = list("icechili" = 1, "tomato" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/meat)
	result = /obj/item/reagent_containers/food/snacks/coldchili

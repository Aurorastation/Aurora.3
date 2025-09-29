
/singleton/recipe/meatballsoup
	appliance = SAUCEPAN | POT | MICROWAVE
	fruit = list("carrot" = 1, "potato" = 1)
	reagents = list(/singleton/reagent/water = 10)
	items = list(/obj/item/reagent_containers/food/snacks/meatball)
	result = /obj/item/reagent_containers/food/snacks/soup/meatball

/singleton/recipe/bloodsoup
	appliance = SAUCEPAN | POT | MICROWAVE
	reagents = list(/singleton/reagent/blood = 30)
	result = /obj/item/reagent_containers/food/snacks/soup/blood

/singleton/recipe/slimesoup
	appliance = SAUCEPAN | POT | MICROWAVE
	reagents = list(/singleton/reagent/water = 10, /singleton/reagent/slimejelly = 5)
	items = list()
	result = /obj/item/reagent_containers/food/snacks/soup/slime

/singleton/recipe/vegetablesoup
	appliance = SAUCEPAN | POT | MICROWAVE
	fruit = list("carrot" = 1, "potato" = 1, "corn" = 1, "eggplant" = 1)
	reagents = list(/singleton/reagent/water = 10)
	result = /obj/item/reagent_containers/food/snacks/soup/vegetable

/singleton/recipe/nettlesoup
	appliance = SAUCEPAN | POT | MICROWAVE
	fruit = list("nettle" = 1, "potato" = 1, )
	reagents = list(/singleton/reagent/water = 10, /singleton/reagent/nutriment/protein/egg = 3)
	result = /obj/item/reagent_containers/food/snacks/soup/nettle

/singleton/recipe/mysterysoup
	appliance = POT | MICROWAVE
	reagents = list(/singleton/reagent/water = 10, /singleton/reagent/nutriment/protein/egg = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/badrecipe,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/soup/mystery

/singleton/recipe/wishsoup
	appliance = SAUCEPAN | POT | MICROWAVE
	reagents = list(/singleton/reagent/water = 20)
	result= /obj/item/reagent_containers/food/snacks/soup/wish

/singleton/recipe/onionsoup
	appliance = SAUCEPAN | POT | MICROWAVE
	fruit = list("onion" = 1)
	reagents = list(/singleton/reagent/water = 10)
	result = /obj/item/reagent_containers/food/snacks/soup/onion

/singleton/recipe/tomatosoup
	appliance = SAUCEPAN | POT | MICROWAVE
	fruit = list("tomato" = 2)
	reagents = list(/singleton/reagent/water = 10)
	result = /obj/item/reagent_containers/food/snacks/soup/tomato

/singleton/recipe/spiralsoup
	appliance = SAUCEPAN | POT | MICROWAVE
	fruit = list("bluespacetomato" = 1, "icechili" = 1 )
	reagents = list(/singleton/reagent/water = 10, /singleton/reagent/drink/milk/cream = 5)
	result = /obj/item/reagent_containers/food/snacks/soup/spiralsoup

/singleton/recipe/misosoup
	appliance = POT | MICROWAVE
	reagents = list(/singleton/reagent/water = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/soydope,
		/obj/item/reagent_containers/food/snacks/soydope,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/soup/miso

/singleton/recipe/mushroomsoup
	appliance = SAUCEPAN | POT | MICROWAVE
	fruit = list("mushroom" = 1)
	reagents = list(/singleton/reagent/water = 5, /singleton/reagent/drink/milk = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/soup/mushroom

/singleton/recipe/beetsoup
	appliance = SAUCEPAN | POT | MICROWAVE
	fruit = list("whitebeet" = 1, "cabbage" = 1)
	reagents = list(/singleton/reagent/water = 10)
	result = /obj/item/reagent_containers/food/snacks/soup/beet

/singleton/recipe/krakensoup
	appliance = SAUCEPAN | POT | MICROWAVE
	fruit = list("pumpkin" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/squidmeat)
	reagents = list(/singleton/reagent/water = 10, /singleton/reagent/spacespice = 2)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/soup/krakensoup

/singleton/recipe/peasoup
	appliance = SAUCEPAN | POT | MICROWAVE
	fruit = list("whitebeet" = 1, "peas" = 1, "carrot" = 1)
	reagents = list(/singleton/reagent/water = 10)
	result = /obj/item/reagent_containers/food/snacks/soup/pea

/singleton/recipe/gazpacho
	appliance = MIX
	reagents = list(/singleton/reagent/water = 10, /singleton/reagent/sodiumchloride = 1, /singleton/reagent/blackpepper = 1)
	fruit = list("tomato" = 1, "bellpepper" = 1) //if cucumbers are added to the game please add them to this recipe
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/soup/gazpacho

/singleton/recipe/pumpkin_soup
	appliance = SAUCEPAN | POT | MICROWAVE
	fruit = list("pumpkin" = 1) //if cucumbers are added to the game please add them to this recipe
	reagents = list(/singleton/reagent/water = 5, /singleton/reagent/drink/milk/cream = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/soup/pumpkin

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

/singleton/recipe/black_eyed_gumbo
	appliance = SAUCEPAN | POT
	fruit = list("onion" = 1, "chili" = 1, "bellpepper" = 1)
	reagents = list(/singleton/reagent/nutriment/rice = 5, /singleton/reagent/water = 10)
	items = list(/obj/item/reagent_containers/food/snacks/meat)
	result = /obj/item/reagent_containers/food/snacks/black_eyed_gumbo

/singleton/recipe/black_eyed_gumbo_alt
	appliance = SAUCEPAN | POT
	fruit = list("onion" = 1, "chili" = 1, "bellpepper" = 1)
	reagents = list(/singleton/reagent/nutriment/rice = 5, /singleton/reagent/water = 10)
	items = list(/obj/item/reagent_containers/food/snacks/fish)
	result = /obj/item/reagent_containers/food/snacks/black_eyed_gumbo

// Chili
/singleton/recipe/bearchili
	appliance = SAUCEPAN | POT
	fruit = list("chili" = 1, "tomato" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/bearmeat)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/bearchili

/singleton/recipe/hotchili
	appliance = SAUCEPAN | POT | MICROWAVE
	fruit = list("chili" = 1, "tomato" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/meat)
	result = /obj/item/reagent_containers/food/snacks/hotchili

/singleton/recipe/coldchili
	appliance = SAUCEPAN | POT | MICROWAVE
	fruit = list("icechili" = 1, "tomato" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/meat)
	result = /obj/item/reagent_containers/food/snacks/coldchili

//oatmeal and porridges
/singleton/recipe/oatmeal
	appliance = SAUCEPAN | POT
	fruit = list("wheat" = 2)
	reagents = list(/singleton/reagent/water = 10, /singleton/reagent/drink/milk = 10)
	result = /obj/item/reagent_containers/food/snacks/oatmeal
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product

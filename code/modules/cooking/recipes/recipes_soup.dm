/decl/recipe/onionsoup
	appliance = SAUCEPAN | POT
	fruit = list("onion" = 1)
	reagents = list(/decl/reagent/water = 10)
	result = /obj/item/reagent_containers/food/snacks/soup/onion

/decl/recipe/bluespacetomatosoup
	appliance = SAUCEPAN | POT
	fruit = list("bluespacetomato" = 2)
	reagents = list(/decl/reagent/water = 10)
	result = /obj/item/reagent_containers/food/snacks/soup/bluespace

/decl/recipe/meatballsoup
	appliance = SAUCEPAN | POT
	fruit = list("carrot" = 1, "potato" = 1)
	reagents = list(/decl/reagent/water = 10)
	items = list(/obj/item/reagent_containers/food/snacks/meatball)
	result = /obj/item/reagent_containers/food/snacks/soup/meatball

/decl/recipe/vegetablesoup
	appliance = SAUCEPAN | POT
	fruit = list("carrot" = 1, "potato" = 1, "corn" = 1, "eggplant" = 1)
	reagents = list(/decl/reagent/water = 10)
	result = /obj/item/reagent_containers/food/snacks/soup/vegetable

/decl/recipe/nettlesoup
	appliance = SAUCEPAN | POT
	fruit = list("nettle" = 1, "potato" = 1, )
	reagents = list(/decl/reagent/water = 10, /decl/reagent/nutriment/protein/egg = 3)
	result = /obj/item/reagent_containers/food/snacks/soup/nettle

/decl/recipe/wishsoup
	appliance = SAUCEPAN | POT
	reagents = list(/decl/reagent/water = 20)
	result= /obj/item/reagent_containers/food/snacks/soup/wish

/decl/recipe/tomatosoup
	appliance = SAUCEPAN | POT
	fruit = list("tomato" = 2)
	reagents = list(/decl/reagent/water = 10)
	result = /obj/item/reagent_containers/food/snacks/soup/tomato

/decl/recipe/milosoup
	appliance = POT
	reagents = list(/decl/reagent/water = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/soydope,
		/obj/item/reagent_containers/food/snacks/soydope,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/soup/milo

/decl/recipe/bloodsoup
	appliance = SAUCEPAN | POT
	reagents = list(/decl/reagent/blood = 30)
	result = /obj/item/reagent_containers/food/snacks/soup/blood

/decl/recipe/slimesoup
	appliance = SAUCEPAN | POT
	reagents = list(/decl/reagent/water = 10, /decl/reagent/slimejelly = 5)
	items = list()
	result = /obj/item/reagent_containers/food/snacks/soup/slime

/decl/recipe/mysterysoup
	appliance = POT
	reagents = list(/decl/reagent/water = 10, /decl/reagent/nutriment/protein/egg = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/badrecipe,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/soup/mystery

/decl/recipe/mushroomsoup
	appliance = SAUCEPAN | POT
	fruit = list("mushroom" = 1)
	reagents = list(/decl/reagent/water = 5, /decl/reagent/drink/milk = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/soup/mushroom

/decl/recipe/chawanmushi
	appliance = SAUCEPAN
	fruit = list("mushroom" = 1)
	reagents = list(/decl/reagent/water = 5, /decl/reagent/nutriment/soysauce = 5, /decl/reagent/nutriment/protein/egg = 6)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/chawanmushi

/decl/recipe/beetsoup
	appliance = SAUCEPAN | POT
	fruit = list("whitebeet" = 1, "cabbage" = 1)
	reagents = list(/decl/reagent/water = 10)
	result = /obj/item/reagent_containers/food/snacks/soup/beet

/decl/recipe/pozole
	appliance = SAUCEPAN | POT
	fruit = list("dyn leaf" = 1, "cabbage" = 1, "tomato" = 1)
	reagents = list(/decl/reagent/water = 10)
	items = list(/obj/item/reagent_containers/food/snacks/meat)
	result = /obj/item/reagent_containers/food/snacks/soup/pozole

/decl/recipe/brudet
	appliance = SAUCEPAN | POT
	fruit = list ("tomato" = 1)
	reagents = list(/decl/reagent/water = 10)
	items = list(/obj/item/reagent_containers/food/snacks/fish)
	result = /obj/item/reagent_containers/food/snacks/soup/brudet

/decl/recipe/maeuntang
	appliance = SAUCEPAN | POT
	fruit = list("chili" = 1, "moss" = 1)
	reagents = list(/decl/reagent/water = 10)
	items = list(/obj/item/reagent_containers/food/snacks/fish)
	result = /obj/item/reagent_containers/food/snacks/soup/maeuntang

/decl/recipe/miyeokguk
	appliance = SAUCEPAN | POT
	fruit = list("moss" = 1, "seaweed" = 1)
	reagents = list(/decl/reagent/water = 10)
	items = list(/obj/item/reagent_containers/food/snacks/meat)
	result = /obj/item/reagent_containers/food/snacks/soup/miyeokguk

// Stews
/decl/recipe/stew
	appliance = POT
	fruit = list("potato" = 1, "tomato" = 1, "carrot" = 1, "eggplant" = 1, "mushroom" = 1)
	reagents = list(/decl/reagent/water = 10)
	items = list(/obj/item/reagent_containers/food/snacks/meat)
	result = /obj/item/reagent_containers/food/snacks/stew

/decl/recipe/bearstew
	appliance = POT
	fruit = list("potato" = 1, "tomato" = 1, "carrot" = 1, "eggplant" = 1, "mushroom" = 1)
	reagents = list(/decl/reagent/water = 10)
	items = list(/obj/item/reagent_containers/food/snacks/bearmeat)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/stew/bear

// Chili
/decl/recipe/bearchili
	appliance = SAUCEPAN | POT
	fruit = list("chili" = 1, "tomato" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/bearmeat)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/bearchili

/decl/recipe/hotchili
	appliance = SAUCEPAN | POT
	fruit = list("chili" = 1, "tomato" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/meat)
	result = /obj/item/reagent_containers/food/snacks/hotchili

/decl/recipe/coldchili
	appliance = SAUCEPAN | POT
	fruit = list("icechili" = 1, "tomato" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/meat)
	result = /obj/item/reagent_containers/food/snacks/coldchili

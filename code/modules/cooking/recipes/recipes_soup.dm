/datum/recipe/onionsoup
	appliance = SAUCEPAN | POT
	fruit = list("onion" = 1)
	reagents = list(/datum/reagent/water = 10)
	result = /obj/item/reagent_containers/food/snacks/soup/onion

/datum/recipe/bluespacetomatosoup
	appliance = SAUCEPAN | POT
	fruit = list("bluespacetomato" = 2)
	reagents = list(/datum/reagent/water = 10)
	result = /obj/item/reagent_containers/food/snacks/soup/bluespace

/datum/recipe/meatballsoup
	appliance = SAUCEPAN | POT
	fruit = list("carrot" = 1, "potato" = 1)
	reagents = list(/datum/reagent/water = 10)
	items = list(/obj/item/reagent_containers/food/snacks/meatball)
	result = /obj/item/reagent_containers/food/snacks/soup/meatball

/datum/recipe/vegetablesoup
	appliance = SAUCEPAN | POT
	fruit = list("carrot" = 1, "potato" = 1, "corn" = 1, "eggplant" = 1)
	reagents = list(/datum/reagent/water = 10)
	result = /obj/item/reagent_containers/food/snacks/soup/vegetable

/datum/recipe/nettlesoup
	appliance = SAUCEPAN | POT
	fruit = list("nettle" = 1, "potato" = 1, )
	reagents = list(/datum/reagent/water = 10, /datum/reagent/nutriment/protein/egg = 3)
	result = /obj/item/reagent_containers/food/snacks/soup/nettle

/datum/recipe/wishsoup
	appliance = SAUCEPAN | POT
	reagents = list(/datum/reagent/water = 20)
	result= /obj/item/reagent_containers/food/snacks/soup/wish

/datum/recipe/tomatosoup
	appliance = SAUCEPAN | POT
	fruit = list("tomato" = 2)
	reagents = list(/datum/reagent/water = 10)
	result = /obj/item/reagent_containers/food/snacks/soup/tomato

/datum/recipe/milosoup
	appliance = POT
	reagents = list(/datum/reagent/water = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/soydope,
		/obj/item/reagent_containers/food/snacks/soydope,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/soup/milo

/datum/recipe/bloodsoup
	appliance = SAUCEPAN | POT
	reagents = list(/datum/reagent/blood = 30)
	result = /obj/item/reagent_containers/food/snacks/soup/blood

/datum/recipe/slimesoup
	appliance = SAUCEPAN | POT
	reagents = list(/datum/reagent/water = 10, /datum/reagent/slimejelly = 5)
	items = list()
	result = /obj/item/reagent_containers/food/snacks/soup/slime

/datum/recipe/mysterysoup
	appliance = POT
	reagents = list(/datum/reagent/water = 10, /datum/reagent/nutriment/protein/egg = 3)
	items = list(
		/obj/item/reagent_containers/food/snacks/badrecipe,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/soup/mystery

/datum/recipe/mushroomsoup
	appliance = SAUCEPAN | POT
	fruit = list("mushroom" = 1)
	reagents = list(/datum/reagent/water = 5, /datum/reagent/drink/milk = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/soup/mushroom

/datum/recipe/chawanmushi
	appliance = SAUCEPAN
	fruit = list("mushroom" = 1)
	reagents = list(/datum/reagent/water = 5, /datum/reagent/nutriment/soysauce = 5, /datum/reagent/nutriment/protein/egg = 6)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/chawanmushi

/datum/recipe/beetsoup
	appliance = SAUCEPAN | POT
	fruit = list("whitebeet" = 1, "cabbage" = 1)
	reagents = list(/datum/reagent/water = 10)
	result = /obj/item/reagent_containers/food/snacks/soup/beet

// Stews
/datum/recipe/stew
	appliance = POT
	fruit = list("potato" = 1, "tomato" = 1, "carrot" = 1, "eggplant" = 1, "mushroom" = 1)
	reagents = list(/datum/reagent/water = 10)
	items = list(/obj/item/reagent_containers/food/snacks/meat)
	result = /obj/item/reagent_containers/food/snacks/stew

/datum/recipe/bearstew
	appliance = POT
	fruit = list("potato" = 1, "tomato" = 1, "carrot" = 1, "eggplant" = 1, "mushroom" = 1)
	reagents = list(/datum/reagent/water = 10)
	items = list(/obj/item/reagent_containers/food/snacks/bearmeat)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/stew/bear

// Chili
/datum/recipe/bearchili
	appliance = SAUCEPAN | POT
	fruit = list("chili" = 1, "tomato" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/bearmeat)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/bearchili

/datum/recipe/hotchili
	appliance = SAUCEPAN | POT
	fruit = list("chili" = 1, "tomato" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/meat)
	result = /obj/item/reagent_containers/food/snacks/hotchili

/datum/recipe/coldchili
	appliance = SAUCEPAN | POT
	fruit = list("icechili" = 1, "tomato" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/meat)
	result = /obj/item/reagent_containers/food/snacks/coldchili

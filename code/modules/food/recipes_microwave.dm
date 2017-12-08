
// see code/datums/recipe.dm


/* No telebacon. just no...
/datum/recipe/telebacon
	items = list(
		/obj/item/device/assembly/signaler
	)

I said no!
/datum/recipe/syntitelebacon
	items = list(
		/obj/item/device/assembly/signaler
	)
*/

/datum/recipe/friedegg
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(
	)

/datum/recipe/boiledegg
	reagents = list("water" = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
	)





/datum/recipe/humanburger
	items = list(
	)

/datum/recipe/plainburger
	items = list(
	)

/datum/recipe/syntiburger
	items = list(
	)

/datum/recipe/brainburger
	items = list(
		/obj/item/organ/brain
	)

/datum/recipe/roburger
	items = list(
		/obj/item/robot_parts/head
	)

/datum/recipe/xenoburger
	items = list(
	)

/datum/recipe/fishburger
	items = list(
	)

/datum/recipe/tofuburger
	items = list(
	)

/datum/recipe/ghostburger
	items = list(
	)

/datum/recipe/clownburger
	items = list(
		/obj/item/clothing/mask/gas/clown_hat
	)

/datum/recipe/mimeburger
	items = list(
		/obj/item/clothing/head/beret
	)

/datum/recipe/mouseburger
	items = list(
	)

/datum/recipe/hotdog
	items = list(
	)

/datum/recipe/classichotdog
	items = list(
	)


/datum/recipe/waffles
	reagents = list("sugar" = 10)
	items = list(
	)

/datum/recipe/donkpocket
	items = list(
	)
		being_cooked.heat()
	make_food(var/obj/container as obj)
		. = ..(container)
			if (!D.warm)
				warm_up(D)

/datum/recipe/donkpocket/warm
	reagents = list() //This is necessary since this is a child object of the above recipe and we don't want donk pockets to need flour
	items = list(
	)



/datum/recipe/omelette
	items = list(
	)
	reagents = list("egg" = 6)
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/muffin
	reagents = list("milk" = 5, "sugar" = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
	)

/datum/recipe/eggplantparm
	fruit = list("eggplant" = 1)
	items = list(
		)

/datum/recipe/soylenviridians
	fruit = list("soybeans" = 1)
	reagents = list("flour" = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/soylentgreen
	reagents = list("flour" = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
	)

/datum/recipe/berryclafoutis
	fruit = list("berries" = 1)
	items = list(
	)

/datum/recipe/wingfangchu
	reagents = list("soysauce" = 5)
	items = list(
	)


/datum/recipe/humankabob
	items = list(
		/obj/item/stack/rods,
	)

/datum/recipe/monkeykabob
	items = list(
		/obj/item/stack/rods,
	)

/datum/recipe/syntikabob
	items = list(
		/obj/item/stack/rods,
	)

/datum/recipe/tofukabob
	items = list(
		/obj/item/stack/rods,
	)



/datum/recipe/loadedbakedpotato
	fruit = list("potato" = 1)

/datum/recipe/microchips
	appliance = MICROWAVE
	items = list(
	)

/datum/recipe/cheesyfries
	items = list(
	)



/datum/recipe/popcorn
	fruit = list("corn" = 1)



/datum/recipe/meatsteak
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)

/datum/recipe/syntisteak
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)



/datum/recipe/spacylibertyduff
	reagents = list("water" = 5, "vodka" = 5, "psilocybin" = 5)

/datum/recipe/amanitajelly
	reagents = list("water" = 5, "vodka" = 5, "amatoxin" = 5)
	make_food(var/obj/container as obj)

		. = ..(container)
			being_cooked.reagents.del_reagent("amatoxin")

/datum/recipe/meatballsoup
	fruit = list("carrot" = 1, "potato" = 1)
	reagents = list("water" = 10)

/datum/recipe/vegetablesoup
	fruit = list("carrot" = 1, "potato" = 1, "corn" = 1, "eggplant" = 1)
	reagents = list("water" = 10)

/datum/recipe/nettlesoup
	fruit = list("nettle" = 1, "potato" = 1, )
	reagents = list("water" = 10, "egg" = 3)

/datum/recipe/wishsoup
	reagents = list("water" = 20)

/datum/recipe/hotchili
	fruit = list("chili" = 1, "tomato" = 1)

/datum/recipe/coldchili
	fruit = list("icechili" = 1, "tomato" = 1)



/datum/recipe/spellburger
	items = list(
		/obj/item/clothing/head/wizard
	)

/datum/recipe/bigbiteburger
	items = list(
	)
	reagents = list("egg" = 3)
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/fishandchips
	items = list(
	)

/datum/recipe/sandwich
	items = list(
	)

/datum/recipe/toastedsandwich
	items = list(
	)

/datum/recipe/grilledcheese
	items = list(
	)

/datum/recipe/tomatosoup
	fruit = list("tomato" = 2)
	reagents = list("water" = 10)

/datum/recipe/rofflewaffles
	reagents = list("psilocybin" = 5, "sugar" = 10)
	items = list(
	)

/datum/recipe/stew
	fruit = list("potato" = 1, "tomato" = 1, "carrot" = 1, "eggplant" = 1, "mushroom" = 1)
	reagents = list("water" = 10)

/datum/recipe/slimetoast
	reagents = list("slimejelly" = 5)
	items = list(
	)

/datum/recipe/jelliedtoast
	reagents = list("cherryjelly" = 5)
	items = list(
	)

/datum/recipe/milosoup
	reagents = list("water" = 10)
	items = list(
	)

/datum/recipe/stewedsoymeat
	fruit = list("carrot" = 1, "tomato" = 1)
	items = list(
	)

/*/datum/recipe/spagetti We have the processor now
	items = list(
	)

/datum/recipe/boiledspagetti
	reagents = list("water" = 5)
	items = list(
	)

/datum/recipe/boiledrice
	reagents = list("water" = 5, "rice" = 10)

/datum/recipe/ricepudding
	reagents = list("milk" = 5, "rice" = 10)

/datum/recipe/pastatomato
	fruit = list("tomato" = 2)
	reagents = list("water" = 5)

/datum/recipe/meatballspagetti
	reagents = list("water" = 5)
	items = list(
	)

/datum/recipe/spesslaw
	reagents = list("water" = 5)
	items = list(
	)

/datum/recipe/superbiteburger
	fruit = list("tomato" = 1)
	reagents = list("sodiumchloride" = 5, "blackpepper" = 5)
	items = list(
	)

/datum/recipe/candiedapple
	fruit = list("apple" = 1)
	reagents = list("water" = 5, "sugar" = 5)

/datum/recipe/applepie
	fruit = list("apple" = 1)

/datum/recipe/slimeburger
	reagents = list("slimejelly" = 5)
	items = list(
	)

/datum/recipe/jellyburger
	reagents = list("cherryjelly" = 5)
	items = list(
	)

/datum/recipe/twobread
	reagents = list("wine" = 5)
	items = list(
	)

/datum/recipe/slimesandwich
	reagents = list("slimejelly" = 5)
	items = list(
	)

/datum/recipe/cherrysandwich
	reagents = list("cherryjelly" = 5)
	items = list(
	)

/datum/recipe/bloodsoup
	reagents = list("blood" = 30)

/datum/recipe/slimesoup
	reagents = list("water" = 10, "slimejelly" = 5)
	items = list()


/datum/recipe/boiledslimeextract
	reagents = list("water" = 5)
	items = list(
		/obj/item/slime_extract
	)

/datum/recipe/chocolateegg
	items = list(
	)

/datum/recipe/sausage
	items = list(
	)
	result_quantity = 2

/datum/recipe/fishfingers
	reagents = list("flour" = 10,"egg" = 3)
	items = list(
	)
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/mysterysoup
	reagents = list("water" = 10, "egg" = 3)
	items = list(
	)
	reagent_mix = RECIPE_REAGENT_REPLACE



/datum/recipe/plumphelmetbiscuit
	fruit = list("plumphelmet" = 1)
	reagents = list("water" = 5, "flour" = 5)

/datum/recipe/mushroomsoup
	fruit = list("mushroom" = 1)
	reagents = list("water" = 5, "milk" = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/chawanmushi
	fruit = list("mushroom" = 1)
	reagents = list("water" = 5, "soysauce" = 5, "egg" = 6)
	reagent_mix = RECIPE_REAGENT_REPLACE

/datum/recipe/beetsoup
	fruit = list("whitebeet" = 1, "cabbage" = 1)
	reagents = list("water" = 10)



/datum/recipe/tossedsalad
	fruit = list("cabbage" = 2, "tomato" = 1, "carrot" = 1, "apple" = 1)

/datum/recipe/aesirsalad
	fruit = list("goldapple" = 1, "ambrosiadeus" = 1)

/datum/recipe/validsalad
	fruit = list("potato" = 1, "ambrosia" = 3)
	make_food(var/obj/container as obj)

		. = ..(container)
			being_cooked.reagents.del_reagent("toxin")



/datum/recipe/stuffing
	reagents = list("water" = 5, "sodiumchloride" = 1, "blackpepper" = 1)
	items = list(
	)

/datum/recipe/tofurkey
	items = list(
	)

// Fuck Science!
/datum/recipe/ruinedvirusdish
	items = list(
	)

//////////////////////////////////////////
// bs12 food port stuff
//////////////////////////////////////////

/datum/recipe/taco
	items = list(
	)





/datum/recipe/meatball
	items = list(
	)

/datum/recipe/cutlet
	items = list(
	)



/datum/recipe/mint
	reagents = list("sugar" = 5, "frostoil" = 5)




/datum/recipe/friedkois
	fruit = list("koisspore" = 1)

/datum/recipe/koiswaffles

/datum/recipe/koisjelly
	fruit = list("koisspore" = 2)

/datum/recipe/neuralbroke
	items = list(/obj/item/organ/vaurca/neuralsocket)


/////////////////////////////////////////////////////////////
//Synnono Meme Foods
//
//Most recipes replace reagents with RECIPE_REAGENT_REPLACE
//to simplify the end product and balance the amount of reagents
//in some foods. Many require the space spice reagent/condiment
//to reduce the risk of future recipe conflicts.
/////////////////////////////////////////////////////////////


/datum/recipe/redcurry
	reagents = list("cream" = 5, "spacespice" = 2, "rice" = 5)
	items = list(
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product

/datum/recipe/greencurry
	reagents = list("cream" = 5, "spacespice" = 2, "rice" = 5)
	fruit = list("chili" = 1)
	items = list(
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product

/datum/recipe/yellowcurry
	reagents = list("cream" = 5, "spacespice" = 2, "rice" = 5)
	fruit = list("peanut" = 2, "potato" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product

/datum/recipe/bearburger
	items = list(
	)

/datum/recipe/bearchili
	fruit = list("chili" = 1, "tomato" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product

/datum/recipe/bearstew
	fruit = list("potato" = 1, "tomato" = 1, "carrot" = 1, "eggplant" = 1, "mushroom" = 1)
	reagents = list("water" = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product

/datum/recipe/bibimbap
	fruit = list("carrot" = 1, "cabbage" = 1, "mushroom" = 1)
	reagents = list("rice" = 5, "spacespice" = 2)
	items = list(
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product

/datum/recipe/friedrice
	reagents = list("water" = 5, "rice" = 10, "soysauce" = 5)
	fruit = list("carrot" = 1, "cabbage" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product

/datum/recipe/lomein
	reagents = list("water" = 5, "soysauce" = 5)
	fruit = list("carrot" = 1, "cabbage" = 1)
	items = list(
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product

/datum/recipe/chickenfillet //Also just combinable, like burgers and hot dogs.
	items = list(
	)

/datum/recipe/chilicheesefries
	items = list(
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product

/datum/recipe/meatbun
	reagents = list("spacespice" = 1, "water" = 5)
	items = list(
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Water used up in cooking

/datum/recipe/custardbun
	reagents = list("spacespice" = 1, "water" = 5, "egg" = 3)
	items = list(
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Water, egg used up in cooking

/datum/recipe/chickenmomo
	reagents = list("spacespice" = 2, "water" = 5)
	items = list(
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product

/datum/recipe/veggiemomo
	reagents = list("spacespice" = 2, "water" = 5)
	fruit = list("carrot" = 1, "cabbage" = 1)
	items = list(
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Get that water outta here

/datum/recipe/risotto
	reagents = list("wine" = 5, "rice" = 10, "spacespice" = 1)
	fruit = list("mushroom" = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE //Get that rice and wine outta here

/datum/recipe/poachedegg
	reagents = list("spacespice" = 1, "sodiumchloride" = 1, "blackpepper" = 1, "water" = 5)
	items = list(
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Get that water outta here

/datum/recipe/honeytoast
	reagents = list("honey" = 5)
	items = list(
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product


/datum/recipe/donerkebab
	fruit = list("tomato" = 1, "cabbage" = 1)
	reagents = list("sodiumchloride" = 1)
	items = list(
	)


/datum/recipe/sashimi
	reagents = list("soysauce" = 5)
	items = list(
	)


/datum/recipe/nugget
	reagents = list("flour" = 5)
	items = list(
	)
	reagent_mix = RECIPE_REAGENT_REPLACE

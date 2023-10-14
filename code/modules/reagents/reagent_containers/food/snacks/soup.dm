
/obj/item/reagent_containers/food/snacks/soup
	name = "water soup"
	desc = "Water. And it tastes...fuck all."
	icon = 'icons/obj/item/reagent_containers/food/soup.dmi'
	icon_state = "wishsoup"
	reagent_data = list(/singleton/reagent/nutriment = list("soup" = 5))
	trash = /obj/item/trash/snack_bowl
	center_of_mass = list("x"=16, "y"=8)
	bitesize = 5
	is_liquid = TRUE

/obj/item/reagent_containers/food/snacks/soup/meatball
	name = "meatball soup"
	desc = "You've got balls kid, BALLS!"
	icon = 'icons/obj/item/reagent_containers/food/soup.dmi'
	icon_state = "meatballsoup"
	filling_color = "#785210"

	reagents_to_add = list(/singleton/reagent/nutriment/protein = 8, /singleton/reagent/water = 5)

/obj/item/reagent_containers/food/snacks/soup/slime
	name = "slime soup"
	desc = "If no water is available, you may substitute tears."
	filling_color = "#C4DBA0"

	reagents_to_add = list(/singleton/reagent/slimejelly = 5, /singleton/reagent/water = 10)

/obj/item/reagent_containers/food/snacks/soup/blood
	name = "tomato soup"
	desc = "Smells like copper."
	icon = 'icons/obj/item/reagent_containers/food/soup.dmi'
	icon_state = "tomatosoup"
	filling_color = "#FF0000"

	reagents_to_add = list(/singleton/reagent/nutriment/protein = 2, /singleton/reagent/blood = 10, /singleton/reagent/water = 5)

/obj/item/reagent_containers/food/snacks/clownstears
	name = "clown's tears"
	desc = "Not very funny."
	icon = 'icons/obj/item/reagent_containers/food/soup.dmi'
	icon_state = "clownstears"
	filling_color = "#C4FBFF"
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/drink/banana = 5, /singleton/reagent/water = 10)
	reagent_data = list(/singleton/reagent/nutriment = list("salt" = 1, "the worst joke" = 3))

/obj/item/reagent_containers/food/snacks/soup/vegetable
	name = "vegetable soup"
	desc = "A true vegan meal" //TODO
	icon_state = "vegetablesoup"
	filling_color = "#AFC4B5"
	reagents_to_add = list(/singleton/reagent/nutriment = 8, /singleton/reagent/water = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("carrot" = 2, "corn" = 2, "eggplant" = 2, "potato" = 2))

/obj/item/reagent_containers/food/snacks/soup/nettle
	name = "nettle soup"
	desc = "To think, the botanist would've beat you to death with one of these."
	icon = 'icons/obj/item/reagent_containers/food/soup.dmi'
	icon_state = "nettlesoup"
	filling_color = "#AFC4B5"
	reagents_to_add = list(/singleton/reagent/nutriment = 8, /singleton/reagent/water = 5, /singleton/reagent/tricordrazine = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("salad" = 4, "egg" = 2, "potato" = 2))

/obj/item/reagent_containers/food/snacks/soup/mystery
	name = "mystery soup"
	desc = "The mystery is, why aren't you eating it?"
	icon = 'icons/obj/item/reagent_containers/food/soup.dmi'
	icon_state = "mysterysoup"
	filling_color = "#F082FF"
	reagents_to_add = list(/singleton/reagent/nutriment = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("backwash" = 1))

/obj/item/reagent_containers/food/snacks/soup/mystery/Initialize()
	. = ..()
	switch(rand(1,10))
		if(1)
			reagents.add_reagent(/singleton/reagent/nutriment, 6)
			reagents.add_reagent(/singleton/reagent/capsaicin, 3)
			reagents.add_reagent(/singleton/reagent/drink/tomatojuice, 2)
		if(2)
			reagents.add_reagent(/singleton/reagent/nutriment, 6)
			reagents.add_reagent(/singleton/reagent/frostoil, 3)
			reagents.add_reagent(/singleton/reagent/drink/tomatojuice, 2)
		if(3)
			reagents.add_reagent(/singleton/reagent/nutriment, 5)
			reagents.add_reagent(/singleton/reagent/water, 5)
			reagents.add_reagent(/singleton/reagent/tricordrazine, 5)
		if(4)
			reagents.add_reagent(/singleton/reagent/nutriment, 5)
			reagents.add_reagent(/singleton/reagent/water, 10)
		if(5)
			reagents.add_reagent(/singleton/reagent/nutriment, 2)
			reagents.add_reagent(/singleton/reagent/drink/banana, 10)
		if(6)
			reagents.add_reagent(/singleton/reagent/nutriment, 6)
			reagents.add_reagent(/singleton/reagent/blood, 10)
		if(7)
			reagents.add_reagent(/singleton/reagent/slimejelly, 10)
			reagents.add_reagent(/singleton/reagent/water, 10)
		if(8)
			reagents.add_reagent(/singleton/reagent/carbon, 10)
			reagents.add_reagent(/singleton/reagent/toxin, 10)
		if(9)
			reagents.add_reagent(/singleton/reagent/nutriment, 5)
			reagents.add_reagent(/singleton/reagent/drink/tomatojuice, 10)
		if(10)
			reagents.add_reagent(/singleton/reagent/nutriment, 6)
			reagents.add_reagent(/singleton/reagent/drink/tomatojuice, 5)
			reagents.add_reagent(/singleton/reagent/oculine, 5)

/obj/item/reagent_containers/food/snacks/soup/wish
	name = "wish soup"
	desc = "I wish this was soup."
	icon = 'icons/obj/item/reagent_containers/food/soup.dmi'
	icon_state = "wishsoup"
	filling_color = "#D1F4FF"
	reagents_to_add = list(/singleton/reagent/water = 10)

/obj/item/reagent_containers/food/snacks/soup/wish/Initialize()
	. = ..()
	if(prob(25))
		src.desc = "A wish come true!"
		reagents.add_reagent(/singleton/reagent/nutriment, 8, list("something good" = 8))

/obj/item/reagent_containers/food/snacks/soup/onion
	name = "onion soup"
	desc = "A soup with layers."
	icon = 'icons/obj/item/reagent_containers/food/soup.dmi'
	icon_state = "onionsoup"
	filling_color = "#E0C367"

	reagents_to_add = list(/singleton/reagent/nutriment = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("onion" = 2, "soup" = 2))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/soup/tomato
	name = "tomato soup"
	desc = "Drinking this feels like being a vampire! A tomato vampire..."
	icon = 'icons/obj/item/reagent_containers/food/soup.dmi'
	icon_state = "tomatosoup"
	filling_color = "#D92929"
	bitesize = 3
	reagents_to_add = list(/singleton/reagent/drink/tomatojuice = 10, /singleton/reagent/nutriment = 5)

/obj/item/reagent_containers/food/snacks/soup/bluespace
	name = "bluespace tomato soup"
	desc = "A scientific experiment turned into a possibly unsafe meal."
	icon = 'icons/obj/item/reagent_containers/food/soup.dmi'
	icon_state = "spiral_soup"
	filling_color = "#0066FF"
	bitesize = 3

	reagents_to_add = list(/singleton/reagent/bluespace_dust = 5, /singleton/reagent/nutriment = 5)

/obj/item/reagent_containers/food/snacks/soup/miso
	name = "miso soup"
	desc = "Miso paste, dashi, and tofu."
	icon = 'icons/obj/item/reagent_containers/food/soup.dmi'
	icon_state = "miso_soup"
	filling_color = "#774f0f"
	reagents_to_add = list(/singleton/reagent/nutriment = 8, /singleton/reagent/water = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("savory soy broth" = 8))
	bitesize = 4

/obj/item/reagent_containers/food/snacks/soup/mushroom
	name = "chantrelle soup"
	desc = "A delicious and hearty mushroom soup."
	icon = 'icons/obj/item/reagent_containers/food/soup.dmi'
	icon_state = "mushroomsoup"
	filling_color = "#E386BF"
	reagents_to_add = list(/singleton/reagent/nutriment = 8)
	reagent_data = list(/singleton/reagent/nutriment = list("mushroom" = 8, "milk" = 2))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/soup/beet
	name = "borscht"
	desc = "A hearty beet soup that's hard to spell."
	icon = 'icons/obj/item/reagent_containers/food/soup.dmi'
	icon_state = "beetsoup"
	filling_color = "#FAC9FF"
	reagents_to_add = list(/singleton/reagent/nutriment = 8)
	reagent_data = list(/singleton/reagent/nutriment = list("tomato" = 4, "beet" = 4))
	bitesize = 2

// Stew

/obj/item/reagent_containers/food/snacks/stew
	name = "stew"
	desc = "A nice and warm stew. Healthy and strong."
	icon = 'icons/obj/item/reagent_containers/food/soup.dmi'
	icon_state = "stew"
	trash = /obj/item/trash/stew
	drop_sound = 'sound/items/drop/shovel.ogg'
	pickup_sound = 'sound/items/pickup/shovel.ogg'
	filling_color = "#9E673A"
	center_of_mass = list("x"=16, "y"=5)
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/nutriment/protein = 4, /singleton/reagent/drink/tomatojuice = 5, /singleton/reagent/oculine = 5, /singleton/reagent/water = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("potato" = 2, "carrot" = 2, "eggplant" = 2, "mushroom" = 2))
	bitesize = 10
	is_liquid = TRUE

/obj/item/reagent_containers/food/snacks/stew/bear
	name = "bear stew"
	gender = PLURAL
	desc = "A thick, dark stew of bear meat and vegetables."
	icon = 'icons/obj/item/reagent_containers/food/soup.dmi'
	icon_state = "bearstew"
	reagent_data = list(/singleton/reagent/nutriment = list("mushroom" = 2, "potato" = 2, "carrot" = 2))
	bitesize = 6

	reagents_to_add = list(/singleton/reagent/nutriment/protein = 4, /singleton/reagent/hyperzine = 5, /singleton/reagent/drink/tomatojuice = 5, /singleton/reagent/oculine = 5, /singleton/reagent/water = 5)

// Chilli

/obj/item/reagent_containers/food/snacks/hotchili
	name = "hot chili"
	desc = "A five alarm Texan Chili!"
	icon = 'icons/obj/item/reagent_containers/food/soup.dmi'
	icon_state = "hotchili"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FF3C00"
	center_of_mass = list("x"=15, "y"=9)
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment = 3, /singleton/reagent/capsaicin = 3, /singleton/reagent/drink/tomatojuice = 2)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/coldchili
	name = "cold chili"
	desc = "This slush is barely a liquid!"
	icon = 'icons/obj/item/reagent_containers/food/soup.dmi'
	icon_state = "coldchili"
	filling_color = "#2B00FF"
	center_of_mass = list("x"=15, "y"=9)
	trash = /obj/item/trash/snack_bowl
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment = 3, /singleton/reagent/frostoil = 3, /singleton/reagent/drink/tomatojuice = 2)
	bitesize = 5

/obj/item/reagent_containers/food/snacks/bearchili
	name = "bear chili"
	gender = PLURAL
	desc = "A dark, hearty chili. Can you bear the heat?"
	icon = 'icons/obj/item/reagent_containers/food/soup.dmi'
	icon_state = "bearchili"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#702708"
	center_of_mass = list("x"=15, "y"=9)
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/protein = 3, /singleton/reagent/capsaicin = 3, /singleton/reagent/drink/tomatojuice = 2, /singleton/reagent/hyperzine = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("chili peppers" = 3))
	bitesize = 5

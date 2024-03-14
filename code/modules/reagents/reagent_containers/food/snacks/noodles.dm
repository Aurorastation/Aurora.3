/obj/item/reagent_containers/food/snacks/spaghetti
	name = "spaghetti"
	desc = "A bundle of raw spaghetti."
	icon = 'icons/obj/item/reagent_containers/food/noodles.dmi'
	icon_state = "spaghetti"
	filling_color = "#EDDD00"
	center_of_mass = list("x"=16, "y"=16)
	reagents_to_add = list(/singleton/reagent/nutriment = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("noodles" = 2))
	bitesize = 1

/obj/item/reagent_containers/food/snacks/boiledspaghetti
	name = "boiled spaghetti"
	desc = "A plain dish of noodles, this sucks."
	icon = 'icons/obj/item/reagent_containers/food/noodles.dmi'
	icon_state = "spaghettiboiled"
	trash = /obj/item/trash/plate
	filling_color = "#FCEE81"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/nutriment = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("noodles" = 2))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/pastatomato
	name = "spaghetti"
	desc = "Spaghetti and crushed tomatoes."
	icon = 'icons/obj/item/reagent_containers/food/noodles.dmi'
	icon_state = "pastatomato"
	trash = /obj/item/trash/plate
	filling_color = "#DE4545"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/drink/tomatojuice = 10)
	reagent_data = list(/singleton/reagent/nutriment = list("tomato" = 3, "noodles" = 3))
	bitesize = 4

/obj/item/reagent_containers/food/snacks/meatballspaghetti
	name = "spaghetti and meatballs"
	desc = "Now thats a nic'e meatball!"
	icon = 'icons/obj/item/reagent_containers/food/noodles.dmi'
	icon_state = "meatballspaghetti"
	trash = /obj/item/trash/plate
	filling_color = "#DE4545"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/nutriment/protein = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("noodles" = 4))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/spesslaw
	name = "spesslaw"
	desc = "A lawyers favourite."
	icon = 'icons/obj/item/reagent_containers/food/noodles.dmi'
	icon_state = "spesslaw"
	filling_color = "#DE4545"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/nutriment/protein = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("noodles" = 4))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/lomein
	name = "lo mein"
	gender = PLURAL
	desc = "A popular Chinese noodle dish. Chopsticks optional."
	icon = 'icons/obj/item/reagent_containers/food/noodles.dmi'
	icon_state = "lomein"
	trash = /obj/item/trash/plate
	filling_color = "#FCEE81"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/nutriment = 8, /singleton/reagent/nutriment/protein = 2, /singleton/reagent/drink/carrotjuice = 3, /singleton/reagent/oculine = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("rice" = 2, "mushroom" = 2, "cabbage" = 2))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/matsuul
	name = "Matsuul"
	desc = "Several places claim to be the origin place of Matsuul'hu (Matsuul for short), but all that's known for a fact is that this bowl of stir-fried, thinly sliced fish, tiny squares of earthern root pasta, eki mushrooms, and mint, is a local street food available in any melting pot where multiple species live together."
	icon = 'icons/obj/item/reagent_containers/food/noodles.dmi'
	icon_state = "matsuul"
	trash = /obj/item/trash/purplebowl
	filling_color = "#70c9c1"
	reagents_to_add = list(/singleton/reagent/nutriment = 5, /singleton/reagent/nutriment/protein/seafood = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("earthenroot pasta" = 2, "mushroom" = 2, "mint" = 2))
	bitesize = 2
	drop_sound = 'sound/items/drop/bottle.ogg'
	pickup_sound = 'sound/items/pickup/bottle.ogg'

/obj/item/reagent_containers/food/snacks/matsuul/update_icon()
	var/percent_matsuul = round((reagents.total_volume / 8) * 100)
	switch(percent_matsuul)
		if(0 to 50)
			icon_state = "matsuulhalf"
		if(51 to INFINITY)
			icon_state = "matsuul"
/obj/item/reagent_containers/food/snacks/macandcheese
	name = "mac and cheese"
	desc = "Cheesy, simple, messy fun."
	icon = 'icons/obj/item/reagent_containers/food/noodles.dmi'
	icon_state = "macandcheese"
	trash = /obj/item/trash/snack_bowl/macandcheese
	filling_color = "#F1C022"
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/nutriment/protein/cheese = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("pasta" = 5))

/obj/item/reagent_containers/food/snacks/macandcheese/bacon
	name = "bacon mac and cheese"
	icon_state = "baconmacandcheese"
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/nutriment/protein/cheese = 5, /singleton/reagent/nutriment/protein = 3)

/obj/item/reagent_containers/food/snacks/ramenbowl
	name = "ramen bowl"
	desc = "There are many different types of Ramen, and this one is... one of them. Not to be confused with the instant, vending machine kind, this elaborate bowl is a celebration of noodles, vegetables, and pork, chicken or fish."
	icon = 'icons/obj/item/reagent_containers/food/noodles.dmi'
	icon_state = "ramenbowl"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#91682b"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/nutriment = 5, /singleton/reagent/nutriment/protein = 4, /singleton/reagent/water = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("noodles" = 5 , "rich vegetable broth" = 3, "egg" =3))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/aoyama_ramen
	name = "aoyama ramen"
	desc = "A bowl of Konyang-style spicy ramen composed of ramen noodles, fish, moss, ginger, chili peppers, and a slice of Narutomaki. The urban legend is that it was created by 5-Cheung gang members as a test to see if their new recruits can handle how spicy it is, but given that it's a popular dish that's not much spicier than many other foods out in the universe, that's probably nonsense. Most likely it was made by Konyang settlers looking to make Ramen out of local ingredients."
	icon = 'icons/obj/item/reagent_containers/food/noodles.dmi'
	icon_state = "aoyama_ramen"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#91682b"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/nutriment = 2, /singleton/reagent/nutriment/moss = 2, /singleton/reagent/nutriment/protein = 5, /singleton/reagent/water = 2, /singleton/reagent/capsaicin = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("noodles" = 5 , "chili" = 4, "rich vegetable broth" = 3), /singleton/reagent/nutriment/protein = list("fish" = 5))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/spaghettibolognese
	name = "spaghetti bolognese"
	desc = "If it's not from the bologna region of italy it's really just sparkling noodles."
	icon = 'icons/obj/item/reagent_containers/food/noodles.dmi'
	icon_state = "bolognese"
	trash = /obj/item/trash/plate
	filling_color = "#a15b0a"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/drink/tomatojuice = 5, /singleton/reagent/nutriment/protein = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("spaghetti" = 5, "seasoned vegetables" = 4), /singleton/reagent/nutriment/protein= list ("ground beef" = 5))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/ravioli
	abstract_type = /obj/item/reagent_containers/food/snacks/ravioli
	icon = 'icons/obj/item/reagent_containers/food/noodles.dmi'
	icon_state = "ravioli"
	trash = /obj/item/trash/plate
	filling_color = "#e9c880"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/nutriment = 6)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/ravioli/cheese
	name = "cheese ravioli"
	desc = "Ravioli with ricotta filling and creamy tomato sauce."
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/nutriment/protein/cheese = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("pasta" = 5, "tomato sauce" = 5), /singleton/reagent/nutriment/protein/cheese = list("ricotta cheese" = 10))

/obj/item/reagent_containers/food/snacks/ravioli/meat
	name = "meat ravioli"
	icon_state = "raviolimeat"
	desc = "Ravioli with ground meat filling and creamy tomato sauce."
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/nutriment/protein = 6)
	reagent_data = list(/singleton/reagent/nutriment = list("pasta" = 5, "tomato sauce" = 5), /singleton/reagent/nutriment/protein = list ("ground meat" = 5))

/obj/item/reagent_containers/food/snacks/ravioli/earthenroot
	name = "earthenroot ravioli"
	icon_state = "veganravioli"
	desc = "This bizzarely colored dish is not actually Tajaran in origin, but the Earthenroot pasta, together with the creamy tomato sauce makes for a pink-and blue dish that's vegan, delicious, and truly bizzare to look at."
	reagents_to_add = list(/singleton/reagent/nutriment = 8)
	reagent_data = list(/singleton/reagent/nutriment = list("pasta" = 5, "pumpkin squash" = 5, "creamy sauce" = 5))
	filling_color = "#80d1e9"

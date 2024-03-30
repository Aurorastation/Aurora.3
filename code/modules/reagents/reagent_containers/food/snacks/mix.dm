/obj/item/reagent_containers/food/snacks/monkeykabob
	name = "meat-kabob"
	icon = 'icons/obj/item/reagent_containers/food/mix.dmi'
	icon_state = "kabob"
	desc = "Delicious meat, on a stick."
	trash = /obj/item/stack/rods
	filling_color = "#A85340"
	center_of_mass = list("x"=17, "y"=15)
	bitesize = 2

	reagents_to_add = list(/singleton/reagent/nutriment/protein = 8)

/obj/item/reagent_containers/food/snacks/tofukabob
	name = "tofu-kabob"
	icon = 'icons/obj/item/reagent_containers/food/mix.dmi'
	icon_state = "kabob"
	desc = "Vegan meat, on a stick."
	trash = /obj/item/stack/rods
	filling_color = "#FFFEE0"
	center_of_mass = list("x"=17, "y"=15)
	bitesize = 2

	reagents_to_add = list(/singleton/reagent/nutriment/protein/tofu = 8)

// Salads

/obj/item/reagent_containers/food/snacks/salad/aesirsalad
	name = "aesir salad"
	desc = "Probably too incredible for mortal men to fully enjoy."
	icon = 'icons/obj/item/reagent_containers/food/mix.dmi'
	icon_state = "aesirsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#468C00"

	reagents_to_add = list(/singleton/reagent/nutriment = 8, /singleton/reagent/drink/doctorsdelight = 8, /singleton/reagent/tricordrazine = 8)
	reagent_data = list(/singleton/reagent/nutriment = list("apples" = 3,"salad" = 5))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/salad/tossedsalad
	name = "tossed salad"
	desc = "A proper salad, basic and simple, with little bits of carrot, tomato and apple intermingled. Vegan!"
	icon = 'icons/obj/item/reagent_containers/food/mix.dmi'
	icon_state = "herbsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#76B87F"
	center_of_mass = list("x"=17, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 8)
	reagent_data = list(/singleton/reagent/nutriment = list("salad" = 2, "tomato" = 2, "carrot" = 2, "apple" = 2))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/salad/validsalad
	name = "valid salad"
	desc = "It's just a salad of questionable 'herbs' with meatballs and fried potato slices. Nothing suspicious about it."
	icon = 'icons/obj/item/reagent_containers/food/mix.dmi'
	icon_state = "validsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#76B87F"
	center_of_mass = list("x"=17, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/nutriment/protein = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("potato" = 4, "herbs" = 4))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/hengsharolls
	name = "hengsha rolls"
	desc = "Originally created in times of scarcity during New Gibson's settlement as a meal requiring basic, readily available ingredients and no electricity to make, these rolls made of cabbage leaves stuffed with mashed potato, corn and tofu cubes are now considered a cultural Gibsonite staple."
	icon = 'icons/obj/item/reagent_containers/food/mix.dmi'
	icon_state = "hengsharolls"
	trash = /obj/item/trash/board
	filling_color = "#9fd6a7"
	reagents_to_add = list(/singleton/reagent/nutriment = 8)
	reagent_data = list(/singleton/reagent/nutriment = list("mashed potatoes" = 4, "corn" = 3, "cabbage" = 1))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/salad/tabboulehsalad
	name = "tabbouleh salad"
	desc = "Freshly ground bulgur wheat, tomato, lemon juice, oil, cucumber, and onion. Nutritious, fresh, healthy, and- NO WE'RE NOT HAVING A PIZZA, DANGIT!"
	icon = 'icons/obj/item/reagent_containers/food/mix.dmi'
	icon_state = "tabboulehsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#5a9c62"
	center_of_mass = list("x"=17, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 8)
	reagent_data = list(/singleton/reagent/nutriment = list("salad" = 2, "tomato" = 2, "bulgur" = 2, "greens" = 2))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/salad/tunasalad
	name = "tuna salad"
	desc = "Tunalicious!"
	icon = 'icons/obj/item/reagent_containers/food/mix.dmi'
	icon_state = "tunasalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#e6d89a"
	center_of_mass = list("x"=17, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/protein/seafood = 3)
	reagent_data = list(/singleton/reagent/nutriment/protein/seafood = list("tuna"  = 3), /singleton/reagent/nutriment = list("mayo" = 3))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/salad/tunapasta
	name = "tuna pasta salad"
	desc = "Probably the furthest you can possibly get from a salad and still call it a salad without looking like a weirdo."
	icon = 'icons/obj/item/reagent_containers/food/mix.dmi'
	icon_state = "tunasalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#e6d89a"
	center_of_mass = list("x"=17, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 5, /singleton/reagent/nutriment/protein/seafood = 3)
	reagent_data = list(/singleton/reagent/nutriment/protein/seafood = list("tuna"  = 3), /singleton/reagent/nutriment = list("mayo" = 3, "pasta" =4))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/salad/potato_salad
	name = "potato salad"
	desc = "Potatoes that have been saladed."
	icon = 'icons/obj/item/reagent_containers/food/mix.dmi'
	icon_state = "potatosalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#e6d89a"
	center_of_mass = list("x"=17, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 12, /singleton/reagent/nutriment/protein/egg = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("potato"  = 5, "mayonnaise" = 5, "zest" = 3))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/salad/fruit_salad
	name = "fruit salad"
	desc = "Delicious, nutritious, sweet and delicious!"
	icon = 'icons/obj/item/reagent_containers/food/mix.dmi'
	icon_state = "fruitsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#f3a126"
	center_of_mass = list("x"=17, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 10, /singleton/reagent/drink/grapejuice = 3, /singleton/reagent/drink/orangejuice = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("apple"  = 5, "orange" = 5, "grapes" = 5, "watermelon" = 3))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/salad/caesar_salad
	name = "caesar salad"
	desc = "Lettuce, croutons, lemon juice, olive oil, egg yolks, anchovies, and so much flavoring! Truly a salad to rule an empire."
	icon = 'icons/obj/item/reagent_containers/food/mix.dmi'
	icon_state = "caesarsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#3b8d34"
	center_of_mass = list("x"=17, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/nutriment/protein = 8)
	reagent_data = list(/singleton/reagent/nutriment = list("crunchy greens"  = 5), /singleton/reagent/nutriment/protein = list("anchovies" = 5, "cheese" = 4))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/salad/jungle_salad
	name = "jungle salad"
	desc = "An exotic fruit salad, made with real jungle!"
	icon = 'icons/obj/item/reagent_containers/food/mix.dmi'
	icon_state = "junglesalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#f3a126"
	center_of_mass = list("x"=17, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 10, /singleton/reagent/drink/grapejuice = 3, /singleton/reagent/drink/banana = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("apple"  = 5, "banana" = 5, "grapes" = 5, "watermelon" = 3))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/salad/citrus_delight
	name = "citrus delight"
	desc = "A fruit salad made of various citrus fruits. Probably very healthy for you! You know... If you ignore all the natural sugar in it."
	icon = 'icons/obj/item/reagent_containers/food/mix.dmi'
	icon_state = "citrusdelight"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#f3a126"
	center_of_mass = list("x"=17, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 7, /singleton/reagent/drink/orangejuice = 3, /singleton/reagent/drink/lemonjuice = 3, /singleton/reagent/drink/limejuice = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("tangy sourness"  = 5))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/salad/spring_salad
	name = "spring salad"
	desc = "A simple salad of carrots, lettuce and peas drizzled in oil with a pinch of salt."
	icon = 'icons/obj/item/reagent_containers/food/mix.dmi'
	icon_state = "springsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#5a9c62"
	center_of_mass = list("x"=17, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 8)
	reagent_data = list(/singleton/reagent/nutriment = list("salad" = 2, "tomato" = 2, "bulgur" = 2, "greens" = 2))
	bitesize = 3

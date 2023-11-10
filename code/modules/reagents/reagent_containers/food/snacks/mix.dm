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


/obj/item/reagent_containers/food/snacks/falafel
	name = "falafel"
	desc = "Falafel balls in a fluffy pita with some hummus, chips, and/or salad - popular, beloved, cheap street food. Originates in the middle east, also common in Elyria."
	icon = 'icons/obj/item/reagent_containers/food/mix.dmi'
	icon_state = "falafel"
	filling_color = "#b4b876"
	reagents_to_add = list(/singleton/reagent/nutriment = 6)
	reagent_data = list(/singleton/reagent/nutriment = list("fried chickpeas" = 3, "hummus" = 2, "pita bread" = 2))

/obj/item/reagent_containers/food/snacks/hengsharolls
	name = "hengsha rolls"
	desc = "Originally created in times of scarcity during New Gibson's settlement as a meal requiring basic, readily available ingredients and no electricity to make, these rolls made of cabbage leaves stuffed with mashed potato, corn and tofu cubes are now considered a cultural Gibsonite staple."
	icon = 'icons/obj/item/reagent_containers/food/mix.dmi'
	icon_state = "hengsharolls"
	trash = /obj/item/trash/board
	filling_color = "#9fd6a7"
	reagents_to_add = list(/singleton/reagent/nutriment = 8)
	reagent_data = list(/singleton/reagent/nutriment = list("mashed potatoes" = 4, "corn" = 3, "cabbage" = 1))
	bitesize = 3

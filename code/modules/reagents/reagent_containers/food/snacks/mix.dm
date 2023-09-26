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

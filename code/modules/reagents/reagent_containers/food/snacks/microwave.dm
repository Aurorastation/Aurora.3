/obj/item/reagent_containers/food/snacks/frozen_microwave_pizza
	name = "frozen microwave pizza"
	desc = "A personal sized frozen 'pizza', using that term very, very loosely."
	icon = 'icons/obj/item/reagent_containers/food/microwave.dmi'
	icon_state = "pizza_plain_frozen"
	center_of_mass = list("x"=16, "y"=11)
	filling_color = "#ce7667"
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/drink/ice = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("self loathing" = 10))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/microwave_pizza
	name = "microwave pizza"
	desc = "A personal sized 'pizza' - using that term very, very loosely. Never tell the chef you're eating this. Or anyone from Italy. Or, honestly, anyone over the age of 10."
	icon = 'icons/obj/item/reagent_containers/food/microwave.dmi'
	icon_state = "pizza_plain"
	center_of_mass = list("x"=16, "y"=11)
	filling_color = "#b32b13"
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/nutriment/protein/cheese = 2, /singleton/reagent/drink/tomatojuice = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("pizza" = 10))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/microwave_pizza/update_icon()
	var/expected_initial_reagent_volume
	for(var/k in src.reagents_to_add)
		expected_initial_reagent_volume += reagents_to_add[k]
	var/percent_microwave_pizza = round((reagents.total_volume / expected_initial_reagent_volume) * 100)
	switch(percent_microwave_pizza)
		if(0 to 49)
			icon_state = "pizza_plain_half"
		if(50 to INFINITY)
			icon_state = "pizza_plain"

/obj/item/reagent_containers/food/snacks/frozen_microwave_pizza/olive
	name = "frozen microwave olive pizza"
	desc = "A personal sized frozen 'pizza', using that term very, very loosely. There's a few tiny green circles on it, hidden under a sheet of ice and thin strings of cheese. There's a lot fewer of them than you expected."
	icon_state = "pizza_olive_frozen"
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/drink/ice = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("self loathing" = 10))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/microwave_pizza/olive
	name = "microwave olive pizza"
	desc = "A personal sized 'pizza' - using that term very, very loosely. There's a few mysterious green circles on it which you believe are called 'olives', whatever those are."
	icon_state = "pizza_olive"
	reagent_data = list(/singleton/reagent/nutriment = list("pizza" = 10, "olives" = 3))

/obj/item/reagent_containers/food/snacks/microwave_pizza/olive/update_icon()
	var/expected_initial_reagent_volume
	for(var/k in src.reagents_to_add)
		expected_initial_reagent_volume += reagents_to_add[k]
	var/percent_microwave_olive_pizza = round((reagents.total_volume / expected_initial_reagent_volume) * 100)
	switch(percent_microwave_olive_pizza)
		if(0 to 49)
			icon_state = "pizza_olive_half"
		if(50 to INFINITY)
			icon_state = "pizza_olive"

/obj/item/reagent_containers/food/snacks/frozen_microwave_pizza/district6
	name = "frozen microwave district6 pizza"
	desc = "A personal sized frozen 'pizza', using that term very, very loosely. There's a few limp strings of earthenroot and some unevenly scattered dirtberries on it in an attempt to recreate the famous pizza from District 6 of Mendell."
	icon_state = "pizza_district6_frozen"
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/drink/ice = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("self loathing" = 10))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/microwave_pizza/district6
	name = "microwave district 6 pizza"
	desc = "A personal sized 'pizza' - using that term very, very loosely. There's a few loose, limp earthenroot slices and chopped dirtberries lying on it haphazardly. Honestly, given the economy in district 6, this is probably more authentic than anything you'd find in any actual pizza place."
	icon_state = "pizza_district6"
	reagent_data = list(/singleton/reagent/nutriment = list("earthenroot pizza" = 10, "crunchy dirtberries" = 3))

/obj/item/reagent_containers/food/snacks/microwave_pizza/district6/update_icon()
	var/expected_initial_reagent_volume
	for(var/k in src.reagents_to_add)
		expected_initial_reagent_volume += reagents_to_add[k]
	var/percent_microwave_district6_pizza = round((reagents.total_volume / expected_initial_reagent_volume) * 100)
	switch(percent_microwave_district6_pizza)
		if(0 to 49)
			icon_state = "pizza_district6_half"
		else
			icon_state = "pizza_district6"

/obj/item/reagent_containers/food/snacks/frozen_microwave_pizza/pepperoni
	name = "frozen microwave pepperoni pizza"
	desc = "A personal sized frozen 'pizza', using that term very, very loosely. Oh wow, there's three whole lumps of something vaguely resembling sausage slices on this. The culinary thrills you'll have."
	icon_state = "pizza_pepperoni_frozen"
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/protein/ = 3, /singleton/reagent/drink/ice = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("self loathing" = 10))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/microwave_pizza/pepperoni
	name = "microwave pepperoni pizza"
	desc = "A personal sized 'pizza' - using that term very, very loosely. Those lumps could, uh... KIND of pass for pepperoni, you guess. Maybe if you squint?"
	icon_state = "pizza_pepperoni"
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/protein/ = 3, /singleton/reagent/nutriment/protein/cheese = 2, /singleton/reagent/drink/tomatojuice = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("pizza" = 10, "pepperonish" = 3))

/obj/item/reagent_containers/food/snacks/microwave_pizza/pepperoni/update_icon()
	var/expected_initial_reagent_volume
	for(var/k in src.reagents_to_add)
		expected_initial_reagent_volume += reagents_to_add[k]
	var/percent_microwave_pepperoni_pizza = round((reagents.total_volume / expected_initial_reagent_volume) * 100)
	switch(percent_microwave_pepperoni_pizza)
		if(0 to 49)
			icon_state = "pizza_pepperoni_half"
		else
			icon_state = "pizza_pepperoni"

/obj/item/reagent_containers/food/snacks/frozen_burger
	name = "frozen hamburger"
	desc = "Millions of these are being shipped to branches of quick-e-burger all across the spur right at this moment. Isn't it amazing? Wait... Weren't there fries on the wrapper? I thought there'd be fries."
	icon = 'icons/obj/item/reagent_containers/food/microwave.dmi'
	icon_state = "quick_e_burger_frozen"
	w_class = WEIGHT_CLASS_SMALL
	center_of_mass = list("x"=16, "y"=11)
	filling_color = "#7e603e"
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/protein/ = 3, /singleton/reagent/drink/ice = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("self loathing" = 10), /singleton/reagent/nutriment/protein/ = list("health code violations" = 3))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/quick_e_burger
	name = "quick-e-burger"
	desc = "Listen, it doesn't have to look good, it just has to be ready quickly and taste vaguely burgerish."
	icon = 'icons/obj/item/reagent_containers/food/microwave.dmi'
	icon_state = "quick_e_burger"
	filling_color = "#4b2d15"
	w_class = WEIGHT_CLASS_SMALL
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/protein/ = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("soggy bun" = 10), /singleton/reagent/nutriment/protein/ = list("probably meat" = 10))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/quick_e_burger/update_icon()
	var/expected_initial_reagent_volume
	for(var/k in src.reagents_to_add)
		expected_initial_reagent_volume += reagents_to_add[k]
	var/percent_quickeburger = round((reagents.total_volume / expected_initial_reagent_volume) * 100)
	switch(percent_quickeburger)
		if(0 to 50)
			icon_state = "quick_e_burger_half"
		if(51 to INFINITY)
			icon_state = "quick_e_burger"

/obj/item/reagent_containers/food/snacks/frozen_mossburger
	name = "frozen mossburger"
	desc = "A small frozen burger with a bit of limp moss on it, waiting to be heated up in a microwave so it can gain some semblence of normality."
	icon = 'icons/obj/item/reagent_containers/food/microwave.dmi'
	icon_state = "quick_e_burger_moss_frozen"
	w_class = WEIGHT_CLASS_SMALL
	filling_color = "#7e603e"
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/protein/ = 3, /singleton/reagent/drink/ice = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("self loathing" = 10), /singleton/reagent/nutriment/protein/ = list("health code violations" = 3))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/toptart_strawberry_raw
	name = "uncooked strawberry toptart"
	desc = "A very pink Getmore Toptart. Might want to warm it up before eating it, or you might not!"
	icon = 'icons/obj/item/reagent_containers/food/microwave.dmi'
	icon_state = "toptart_strawberry_raw"
	w_class = WEIGHT_CLASS_SMALL
	filling_color = "#c57896"
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 2, /singleton/reagent/drink/strawberryjuice = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("strawberry jelly" = 5, "cold pastry" = 4))

/obj/item/reagent_containers/food/snacks/toptart_strawberry
	name = "strawberry toptart"
	desc = "A very pink Getmore Toptart. It has been toasted golden brown, mmmmm!"
	icon = 'icons/obj/item/reagent_containers/food/microwave.dmi'
	icon_state = "toptart_strawberry"
	w_class = WEIGHT_CLASS_SMALL
	filling_color = "#c57896"
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 2, /singleton/reagent/drink/strawberryjuice = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("strawberry jelly" = 5, "crumbly dough" = 4))

/obj/item/reagent_containers/food/snacks/toptart_strawberry/update_icon()
	var/expected_initial_reagent_volume
	for(var/k in src.reagents_to_add)
		expected_initial_reagent_volume += reagents_to_add[k]
	var/percent_toptart_strawberry = round((reagents.total_volume / expected_initial_reagent_volume) * 100)
	switch(percent_toptart_strawberry)
		if(0 to 50)
			icon_state = "toptart_strawberry_half"
		else
			icon_state = "toptart_strawberry"

/obj/item/reagent_containers/food/snacks/toptart_chocolate_peanutbutter_raw
	name = "uncooked chocolate peanut butter toptart"
	desc = "A Getmore Toptart coated in chocolate and filled with peanut butter. Might want to warm it up before eating it, or you might not!"
	icon = 'icons/obj/item/reagent_containers/food/microwave.dmi'
	icon_state = "toptart_chocolate_raw"
	w_class = WEIGHT_CLASS_SMALL
	filling_color = "#6d462d"
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 2, /singleton/reagent/nutriment/peanutbutter = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("chocolate" = 5, "peanut butter" = 5, "cold pastry" = 5))

/obj/item/reagent_containers/food/snacks/toptart_chocolate_peanutbutter
	name = "chocolate peanut butter toptart"
	desc = "A Getmore Toptart coated in chocolate and filled with peanut butter. It's been toasted and the chocolate is just a tiny bit melty."
	icon = 'icons/obj/item/reagent_containers/food/microwave.dmi'
	icon_state = "toptart_chocolate"
	w_class = WEIGHT_CLASS_SMALL
	filling_color = "#8a5d22"
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 2, /singleton/reagent/nutriment/peanutbutter = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("gooey chocolate" = 5, "peanut butter" = 5, "crumbly dough" = 5))

/obj/item/reagent_containers/food/snacks/toptart_chocolate_peanutbutter/update_icon()
	var/expected_initial_reagent_volume
	for(var/k in src.reagents_to_add)
		expected_initial_reagent_volume += reagents_to_add[k]
	var/percent_toptart_chocolate = round((reagents.total_volume / expected_initial_reagent_volume) * 100)
	switch(percent_toptart_chocolate)
		if(0 to 50)
			icon_state = "toptart_chocolate_half"
		else
			icon_state = "toptart_chocolate"

/obj/item/reagent_containers/food/snacks/toptart_blueberry_raw
	name = "uncooked blueberry toptart"
	desc = "A Getmore Toptart filled with blueberry jelly. It's the only kind that isn't frosted so it's probably not as bad for you as the other ones. Hurray for being health concious? Might want to warm it up before eating it, or you might not!"
	icon = 'icons/obj/item/reagent_containers/food/microwave.dmi'
	icon_state = "toptart_blueberry_raw"
	w_class = WEIGHT_CLASS_SMALL
	filling_color = "#506c91"
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 2, /singleton/reagent/drink/blueberryjuice = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("blueberries" = 5, "cold pastry" = 5))

/obj/item/reagent_containers/food/snacks/toptart_blueberry
	name = "blueberry toptart"
	desc = "A Getmore Toptart filled with blueberry jelly. It's the only kind that isn't frosted so it's probably not as bad for you as the other ones. Hurray for being health concious? It's been toasted golden brown."
	icon = 'icons/obj/item/reagent_containers/food/microwave.dmi'
	icon_state = "toptart_blueberry"
	w_class = WEIGHT_CLASS_SMALL
	filling_color = "#18569c"
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 2, /singleton/reagent/drink/blueberryjuice = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("blueberries" = 5, "crumbly dough" = 5))

/obj/item/reagent_containers/food/snacks/toptart_blueberry/update_icon()
	var/expected_initial_reagent_volume
	for(var/k in src.reagents_to_add)
		expected_initial_reagent_volume += reagents_to_add[k]
	var/percent_toptart_blueberry = round((reagents.total_volume / expected_initial_reagent_volume) * 100)
	switch(percent_toptart_blueberry)
		if(0 to 50)
			icon_state = "toptart_blueberry_half"
		else
			icon_state = "toptart_blueberry"

/////////////////////////////////////////////////Sliceable////////////////////////////////////////
// All the food items that can be sliced into smaller bits like Meatbread and Cheesewheels

// sliceable is just an organization type path, it doesn't have any additional code or variables tied to it.

/obj/item/reagent_containers/food/snacks/sliceable
	w_class = WEIGHT_CLASS_NORMAL //Whole pizzas and cakes shouldn't fit in a pocket, you can slice them if you want to do that.

/obj/item/reagent_containers/food/snacks/sliceable/cheesewheel
	name = "cheese wheel"
	desc = "A big wheel of delcious Cheddar."
	icon = 'icons/obj/item/reagent_containers/food/ingredients.dmi'
	icon_state = "cheesewheel"
	slice_path = /obj/item/reagent_containers/food/snacks/cheesewedge
	slices_num = 8
	filling_color = "#FFF700"
	center_of_mass = list("x"=16, "y"=10)
	bitesize = 2

	reagents_to_add = list(/singleton/reagent/nutriment/protein/cheese = 20)

/obj/item/reagent_containers/food/snacks/cheesewedge
	name = "cheese wedge"
	desc = "A wedge of delicious Cheddar. The cheese wheel it was cut from can't have gone far."
	icon = 'icons/obj/item/reagent_containers/food/ingredients.dmi'
	icon_state = "cheesewedge"
	ingredient_name = "cheese"
	filling_color = "#FFF700"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/snacks/cheesewedge/filled/reagents_to_add = list(/singleton/reagent/nutriment/protein/cheese = 4)

/obj/item/reagent_containers/food/snacks/sliceable/nakarka
	name = "nakarka cheese wheel"
	desc = "Nakarka is Vaurcan cheese made of Ne'miik with a sharp, tangy flavor. Nakarka directly translates to mean 'cheese'. It can cause gastric discomfort to some other species in it's raw form. There are ways to prepare it to decrease those effects, however." //basically an in-world reason to feel free to use it in recipes that are meant for humans as well.
	icon = 'icons/obj/item/reagent_containers/food/ingredients.dmi'
	icon_state = "nakarka"
	slice_path = /obj/item/reagent_containers/food/snacks/nakarka_wedge
	slices_num = 8
	filling_color = "#7be717"
	center_of_mass = list("x"=16, "y"=10)
	bitesize = 2

	reagents_to_add = list(/singleton/reagent/nakarka = 20)

/obj/item/reagent_containers/food/snacks/nakarka_wedge
	name = "nakarka cheese wedge"
	desc = "Zzztop calling it Nakarka cheezzze. You sound ridicoulouzzz. Nakarka meanzzz cheezzze. You are literally calling it cheezzze cheezzze."
	icon = 'icons/obj/item/reagent_containers/food/ingredients.dmi'
	icon_state = "nakarka_wedge"
	ingredient_name = "nakarka"
	filling_color = "#7be717"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/snacks/nakarka_wedge/filled/reagents_to_add = list(/singleton/reagent/nakarka = 4)


/obj/item/reagent_containers/food/snacks/spreads
	name = "nutri-spread"
	desc = "A stick of plant-based nutriments in a semi-solid form. I can't believe it's not margarine!"
	icon = 'icons/obj/item/reagent_containers/food/ingredients.dmi'
	icon_state = "marge"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=16)
	reagents_to_add = list(/singleton/reagent/nutriment = 20)
	reagent_data = list(/singleton/reagent/nutriment = list("margarine" = 1))
	filling_color = "#FFFBB8"

/obj/item/reagent_containers/food/snacks/spreads/butter
	name = "butter"
	desc = "A stick of pure butterfat made from milk products."
	icon = 'icons/obj/item/reagent_containers/food/ingredients.dmi'
	icon_state = "butter"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=16)
	reagents_to_add = list(/singleton/reagent/nutriment/triglyceride = 20, /singleton/reagent/sodiumchloride = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("butter" = 1))

/obj/item/reagent_containers/food/snacks/spreads/lard
	name = "lard"
	desc = "A stick of animal fat."
	icon = 'icons/obj/item/reagent_containers/food/ingredients.dmi'
	icon_state = "lard"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=16)
	reagents_to_add = list(/singleton/reagent/nutriment/triglyceride = 5)

/obj/item/reagent_containers/food/snacks/watermelonslice
	name = "watermelon slice"
	desc = "A slice of watery goodness."
	icon = 'icons/obj/hydroponics_misc.dmi'
	icon_state = "watermelonslice"
	filling_color = "#FF3867"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=10)

/obj/item/reagent_containers/food/snacks/watermelonslice/filled
	reagents_to_add = list(/singleton/reagent/nutriment = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("watermelon" = 2))

/obj/item/reagent_containers/food/snacks/pineapple_ring
	name = "pineapple ring"
	desc = "What the hell is this?"
	icon = 'icons/obj/hydroponics_misc.dmi'
	icon_state = "pineapple_ring"
	reagents_to_add = list(/singleton/reagent/nutriment = 2, /singleton/reagent/drink/pineapplejuice = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("sweetness" = 2))
	filling_color = "#FFF97D"

/obj/item/reagent_containers/food/snacks/dough
	name = "dough"
	desc = "A piece of dough."
	icon = 'icons/obj/item/reagent_containers/food/ingredients.dmi'
	icon_state = "dough"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=13)
	reagents_to_add = list(/singleton/reagent/nutriment = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("uncooked dough" = 3))
	filling_color = "#EDE0AF"

// Dough + rolling pin = flat dough
/obj/item/reagent_containers/food/snacks/dough/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/material/kitchen/rollingpin))
		new /obj/item/reagent_containers/food/snacks/sliceable/flatdough(src)
		to_chat(user, "You flatten the dough.")
		qdel(src)

// slicable into 3xdoughslices
/obj/item/reagent_containers/food/snacks/sliceable/flatdough
	name = "flat dough"
	desc = "A flattened dough."
	icon = 'icons/obj/item/reagent_containers/food/ingredients.dmi'
	icon_state = "flat dough"
	slice_path = /obj/item/reagent_containers/food/snacks/doughslice
	slices_num = 3
	center_of_mass = list("x"=16, "y"=16)
	reagents_to_add = list(/singleton/reagent/nutriment = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("uncooked dough" = 3))
	filling_color = "#EDE0AF"

/obj/item/reagent_containers/food/snacks/doughslice
	name = "dough slice"
	desc = "A building block of an impressive dish."
	icon = 'icons/obj/item/reagent_containers/food/ingredients.dmi'
	icon_state = "doughslice"
	slice_path = /obj/item/reagent_containers/food/snacks/spaghetti
	slices_num = 1
	bitesize = 2
	center_of_mass = list("x"=17, "y"=19)
	reagents_to_add = list(/singleton/reagent/nutriment = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("uncooked dough" = 1))
	filling_color = "#EDE0AF"

// potato + knife = raw sticks
/obj/item/reagent_containers/food/snacks/grown/potato/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/material/kitchen/utensil/knife))
		new /obj/item/reagent_containers/food/snacks/rawsticks(src)
		to_chat(user, "You cut the potato.")
		qdel(src)
	else
		..()

/obj/item/reagent_containers/food/snacks/rawsticks
	name = "raw potato sticks"
	desc = "Raw fries, not very tasty."
	icon = 'icons/obj/item/reagent_containers/food/ingredients.dmi'
	icon_state = "rawsticks"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=12)
	reagents_to_add = list(/singleton/reagent/nutriment = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("uncooked potatos" = 3))
	filling_color = "#EDF291"

/obj/item/reagent_containers/food/snacks/carrotfries
	name = "carrot fries"
	desc = "Tasty fries from fresh Carrots."
	icon = 'icons/obj/item/reagent_containers/food/ingredients.dmi'
	icon_state = "carrotfries"
	trash = /obj/item/trash/plate
	filling_color = "#FAA005"
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/oculine = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("carrot" = 3, "salt" = 1))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/soydope
	name = "soy dope"
	desc = "Dope from a soy."
	icon = 'icons/obj/item/reagent_containers/food/ingredients.dmi'
	icon_state = "soydope"
	trash = /obj/item/trash/plate
	filling_color = "#C4BF76"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/nutriment = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("soy" = 2))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/tofu
	name = "tofu"
	icon = 'icons/obj/item/reagent_containers/food/ingredients.dmi'
	icon_state = "tofu"
	desc = "We all love tofu."
	filling_color = "#FFFEE0"
	center_of_mass = list("x"=17, "y"=10)
	bitesize = 3

	reagents_to_add = list(/singleton/reagent/nutriment/protein/tofu = 3)

/obj/item/reagent_containers/food/snacks/chocolatebar
	name = "chocolate bar"
	desc = "Such sweet, fattening food."
	icon = 'icons/obj/item/reagent_containers/food/ingredients.dmi'
	icon_state = "chocolatebar"
	filling_color = "#7D5F46"

	reagents_to_add = list(/singleton/reagent/nutriment = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("chocolate" = 5))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/whitechocolate
	name = "white chocolate bar"
	desc = "Claimed by some to not really be chocolate. Most don't care."
	icon = 'icons/obj/item/reagent_containers/food/ingredients.dmi'
	icon_state = "whitechocolate"
	filling_color = "#E3E3C7"

	reagents_to_add = list(/singleton/reagent/nutriment = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("white chocolate" = 5))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/whitechocolate/wrapped
	icon_state = "whitechocolate_wrapped"

/obj/item/reagent_containers/food/snacks/mashedpotato
	name = "mashed potato"
	desc = "Pillowy mounds of mashed potato."
	icon = 'icons/obj/item/reagent_containers/food/ingredients.dmi'
	icon_state = "mashedpotato"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	center_of_mass = list("x"=16, "y"=11)

	reagents_to_add = list(/singleton/reagent/nutriment = 6)
	reagent_data = list(/singleton/reagent/nutriment = list("mashed potatoes" = 4))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/mashedpotato/on_reagent_change()
	if(reagents.has_reagent(/singleton/reagent/condiment/gravy))
		name = "mashed potato and gravy"
		desc = "Pillowy mounds of mashed potato covered in thick gravy."
		icon_state = "mashedpotatogravy"

/obj/item/reagent_containers/food/snacks/sauerkraut
	name = "sauerkraut"
	desc = "Finely cut and fermented cabbage. A light pickled delight!"
	icon = 'icons/obj/item/reagent_containers/food/ingredients.dmi'
	icon_state = "sauerkraut"
	filling_color = "#EBE699"
	reagents_to_add = list(/singleton/reagent/nutriment = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("pickled lettuce" = 4))
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_containers/food/snacks/plaincrepe
	name = "plain crepe"
	desc = "A very thin type of pancake, typically used to wrap sweet things for desserts or, more controversially, savory things."
	icon = 'icons/obj/item/reagent_containers/food/ingredients.dmi'
	icon_state = "plaincrepe"
	bitesize = 2
	reagent_data = list(/singleton/reagent/nutriment = list("dough" = 2))
	center_of_mass = list("x"=16, "y"=16)
	reagents_to_add = list(/singleton/reagent/nutriment = 1)
	filling_color = "#caa178"

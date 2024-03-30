/obj/item/reagent_containers/food/snacks/chilied_eggs
	name = "chilied eggs"
	desc = "Three deviled eggs floating in a bowl of meat chili. A popular lunchtime meal for Unathi in Ouerea."
	icon = 'icons/obj/item/reagent_containers/food/cultural/unathi.dmi'
	icon_state = "chilied_eggs"
	trash = /obj/item/trash/snack_bowl
	reagents_to_add = list(/singleton/reagent/nutriment/protein/egg = 6, /singleton/reagent/nutriment/protein = 2)
	filling_color = "#FC5647"

/obj/item/reagent_containers/food/snacks/hatchling_suprise
	name = "hatchling suprise"
	desc = "A poached egg on top of three slices of bacon. A typical breakfast for hungry Unathi children."
	icon = 'icons/obj/item/reagent_containers/food/cultural/unathi.dmi'
	icon_state = "hatchling_suprise"
	trash = /obj/item/trash/snack_bowl
	reagents_to_add = list(/singleton/reagent/nutriment/protein/egg = 2, /singleton/reagent/nutriment/protein = 4)
	filling_color = "#FC5647"

/obj/item/reagent_containers/food/snacks/red_sun_special
	name = "red sun special"
	desc = "One lousey piece of sausage sitting on melted cheese curds. A cheap meal for the Unathi peasants of Moghes."
	icon = 'icons/obj/item/reagent_containers/food/cultural/unathi.dmi'
	icon_state = "red_sun_special"
	trash = /obj/item/trash/plate
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 2)
	filling_color = "#FC5647"

/obj/item/reagent_containers/food/snacks/riztizkzi_sea
	name = "moghresian sea delight"
	desc = "Three raw eggs floating in a sea of blood. An authentic replication of an ancient Unathi delicacy."
	icon = 'icons/obj/item/reagent_containers/food/cultural/unathi.dmi'
	icon_state = "riztizkzi_sea"
	trash = /obj/item/trash/snack_bowl
	reagents_to_add = list(/singleton/reagent/nutriment/protein/egg = 4)
	filling_color = "#FC5647"

/obj/item/reagent_containers/food/snacks/father_breakfast
	name = "breakfast of champions"
	desc = "A sausage and an omelette on top of a grilled steak."
	icon = 'icons/obj/item/reagent_containers/food/cultural/unathi.dmi'
	icon_state = "father_breakfast"
	trash = /obj/item/trash/plate
	reagents_to_add = list(/singleton/reagent/nutriment/protein/egg = 4, /singleton/reagent/nutriment/protein = 6)
	filling_color = "#FC5647"

/obj/item/reagent_containers/food/snacks/stuffed_meatball
	name = "stuffed meatball"
	desc = "A meatball loaded with cheese."
	icon = 'icons/obj/item/reagent_containers/food/cultural/unathi.dmi'
	icon_state = "stuffed_meatball"
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 4)
	filling_color = "#FC5647"

/obj/item/reagent_containers/food/snacks/egg_pancake
	name = "meat pancake"
	desc = "An omelette baked on top of a giant meat patty. This monstrousity is typically shared between four people during a dinnertime meal."
	icon = 'icons/obj/item/reagent_containers/food/cultural/unathi.dmi'
	icon_state = "egg_pancake"
	trash = /obj/item/trash/tray
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 6, /singleton/reagent/nutriment/protein/egg = 2)
	filling_color = "#FFFA6b"

/obj/item/reagent_containers/food/snacks/sliceable/grilled_carp
	name = "korlaaskak"
	desc = "A well-dressed fish, seared to perfection and adorned with herbs and spices. Can be sliced into proper serving sizes."
	icon = 'icons/obj/item/reagent_containers/food/cultural/unathi.dmi'
	icon_state = "grilled_carp"
	slice_path = /obj/item/reagent_containers/food/snacks/grilled_carp_slice
	slices_num = 6
	trash = /obj/item/trash/snacktray
	filling_color = "#FFA8E5"

	reagents_to_add = list(/singleton/reagent/nutriment/protein/seafood = 12)

/obj/item/reagent_containers/food/snacks/grilled_carp_slice
	name = "korlaaskak slice"
	desc = "A well-dressed fillet of fish, seared to perfection and adorned with herbs and spices."
	icon = 'icons/obj/item/reagent_containers/food/cultural/unathi.dmi'
	icon_state = "grilled_carp_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FFA8E5"

/obj/item/reagent_containers/food/snacks/sliceable/sushi_roll
	name = "ouerean fish log"
	desc = "A giant fish roll wrapped in special grass that combines unathi and human cooking techniques. Can be sliced into proper serving sizes."
	icon = 'icons/obj/item/reagent_containers/food/cultural/unathi.dmi'
	icon_state = "sushi_roll"
	slice_path = /obj/item/reagent_containers/food/snacks/sushi_serve
	slices_num = 3
	filling_color = "#525252"

	reagents_to_add = list(/singleton/reagent/nutriment/protein/seafood = 6)

/obj/item/reagent_containers/food/snacks/sushi_serve
	name = "ouerean fish cake"
	desc = "A serving of fish roll wrapped in special grass that combines unathi and human cooking techniques."
	icon = 'icons/obj/item/reagent_containers/food/cultural/unathi.dmi'
	icon_state = "sushi_serve"
	filling_color = "#525252"

/obj/item/reagent_containers/food/snacks/bacon_stick
	name = "eggpop"
	desc = "A bacon wrapped boiled egg, conviently skewered on a wooden stick."
	icon = 'icons/obj/item/reagent_containers/food/cultural/unathi.dmi'
	icon_state = "bacon_stick"
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 3, /singleton/reagent/nutriment/protein/egg = 1)
	filling_color = "#FFFEE8"

/obj/item/reagent_containers/food/snacks/batwings
	name = "spiced shrieker wings"
	desc = "Wings of a small flying mammal, enriched with a dizzying amount of fat, and spiced with chilis."
	icon = 'icons/obj/item/reagent_containers/food/cultural/unathi.dmi'
	icon_state = "batwings"
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 3, /singleton/reagent/nutriment/triglyceride = 2, /singleton/reagent/capsaicin = 5)
	bitesize = 4
	trash = /obj/item/trash/plate

/obj/item/reagent_containers/food/snacks/jellystew
	name = "jelly stew"
	desc = "A fatty, spicy, stew with crunchy chunks of meat floating amongst rich slimy globules. The texture is most definitely acquired."
	icon = 'icons/obj/item/reagent_containers/food/cultural/unathi.dmi'
	icon_state = "jellystew"
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/protein/seafood = 6, /singleton/reagent/nutriment/protein = 3, /singleton/reagent/nutriment/triglyceride = 3, /singleton/reagent/capsaicin = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("slippery slime" = 3))
	bitesize = 7
	trash = /obj/item/trash/snack_bowl

/obj/item/reagent_containers/food/snacks/stuffedfish
	name = "stuffed fish fillet"
	desc = "A fish fillet stuffed with small eggs and cheese."
	icon = 'icons/obj/item/reagent_containers/food/cultural/unathi.dmi'
	icon_state = "stuffedfish"
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/protein/seafood = 7, /singleton/reagent/nutriment/protein/cheese = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("brine" = 3, "fish" = 3))
	bitesize = 5
	trash = /obj/item/trash/plate

/obj/item/reagent_containers/food/snacks/stuffedcarp
	name = "stuffed fish fillet"
	desc = "A fish fillet stuffed with small eggs and cheese."
	icon = 'icons/obj/item/reagent_containers/food/cultural/unathi.dmi'
	icon_state = "stuffedfish"
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/protein/seafood = 7, /singleton/reagent/nutriment/protein/cheese = 2, /singleton/reagent/toxin/carpotoxin = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("brine" = 3, "fish" = 3))
	bitesize = 6
	trash = /obj/item/trash/plate

/obj/item/reagent_containers/food/snacks/razirnoodles
	name = "razir noodles"
	desc = "While this dish appears to be noodles at a glance, it is in fact thin strips of meat coated in an egg based sauce, topped with sliced limes. An authentic variant of this is commonly eaten in and around Razir."
	icon = 'icons/obj/item/reagent_containers/food/cultural/unathi.dmi'
	icon_state = "razirnoodles"
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/protein/seafood = 8, /singleton/reagent/nutriment/protein/egg = 3, /singleton/reagent/hyperzine = 5, /singleton/reagent/acid/polyacid = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("molten heat" = 3, "slippery noodles" = 3))
	bitesize = 10
	trash = /obj/item/trash/plate

/obj/item/reagent_containers/food/snacks/sintapudding
	name = "sinta pudding"
	desc = "Reddish, and extremely smooth, chocolate pudding, rich in iron!"
	icon = 'icons/obj/item/reagent_containers/food/cultural/unathi.dmi'
	icon_state = "sintapudding"
	reagents_to_add = list(/singleton/reagent/nutriment = 1, /singleton/reagent/nutriment/protein = 1, /singleton/reagent/blood = 6, /singleton/reagent/nutriment/coco = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("iron" = 3))
	bitesize = 6

/obj/item/reagent_containers/food/snacks/stokkebab
	name = "stok skewers"
	desc = "Two hearty skewers of seared meat, glazed in a tangy spice. A popular Skalamar street food - despite the name, it can be made with just about any meat."
	icon = 'icons/obj/item/reagent_containers/food/cultural/unathi.dmi'
	icon_state = "stok-skewers"
	reagents_to_add = list(/singleton/reagent/nutriment = 1, /singleton/reagent/nutriment/protein = 2, /singleton/reagent/capsaicin = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("tangy and gamey meat" = 3))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/gukhefish
	name = "gukhe fish"
	desc = "A fish cutlet cured in a bitter gukhe rub, served with a tangy dipping sauce and a garnish of seaweed. A staple of Ouerean and Mictlani Unathi cooking."
	icon = 'icons/obj/item/reagent_containers/food/cultural/unathi.dmi'
	icon_state = "gukhe-fish"
	reagents_to_add = list(/singleton/reagent/nutriment = 1, /singleton/reagent/nutriment/protein/seafood = 6, /singleton/reagent/capsaicin = 2, /singleton/reagent/sodiumchloride = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("tangy fish" = 3, "bitter gukhe" = 3))
	bitesize = 5

/obj/item/reagent_containers/food/snacks/aghrasshcake
	name = "aghrassh cake"
	desc = "A dense, calorie-packed puck of aghrassh paste, spices, and ground meat, usually eaten as an Unathi field ration. This one has an egg cracked over it to make it a bit more palatable."
	icon = 'icons/obj/item/reagent_containers/food/cultural/unathi.dmi'
	icon_state = "aghrassh-cake"
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/protein = 8, /singleton/reagent/nutriment/coco = 3, /singleton/reagent/blackpepper = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("aghrassh nuts" = 3, "mealy paste" = 3))
	bitesize = 5

/obj/item/reagent_containers/food/snacks/sliceable/eyebowl
	name = "eyebowl"
	desc = "A zesty stew of ground meat, Moghesian tomato pulp, and ground agghrash nut mixed together and topped with two egg yolks staring back at you like eyes. It can be made with different kinds of meat, and seasoned with either hot sauce or blood. This is a large serving, typically reserved for hungry Unathi, miners, or other folks who have to get by on one big meal to last them a whole day."
	icon = 'icons/obj/item/reagent_containers/food/cultural/unathi.dmi'
	icon_state = "eyebowl"
	trash = /obj/item/trash/custard_bowl
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/protein = 12, /singleton/reagent/blackpepper = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("aghrassh nuts" = 3, "zesty tomatoes" = 5))
	bitesize = 5
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'
	slice_path = /obj/item/reagent_containers/food/snacks/hatchbowl
	slices_num = 2
	filling_color = "#771504"

/obj/item/reagent_containers/food/snacks/hatchbowl
	name = "hatchbowl"
	desc = "Short for 'hatchling eyebowl', this zesty stew of ground meat, Moghesian tomato pulp, and ground agghrash nut topped with an egg yolk is a smaller serving of the eyebowl. It is usually eaten by smaller Unathi, non-Unathi species, or by grown Unathi who just aren't all that hungry. The dish spread throughout the spur and is often enjoyed by other species as well. It can be made with different kinds of meat, and seasoned with either hot sauce or blood."
	icon = 'icons/obj/item/reagent_containers/food/cultural/unathi.dmi'
	icon_state = "eyebowl_small"
	trash = /obj/item/trash/custard_bowl
	bitesize = 3
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'


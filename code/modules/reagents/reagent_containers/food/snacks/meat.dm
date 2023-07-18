/obj/item/reagent_containers/food/snacks/rawcutlet
	name = "raw cutlet"
	desc = "A thin piece of raw meat."
	icon = 'icons/obj/item/reagent_containers/food/meat.dmi'
	icon_state = "rawcutlet"
	bitesize = 1
	center_of_mass = list("x"=17, "y"=20)
	slice_path = /obj/item/reagent_containers/food/snacks/rawbacon
	slices_num = 2
	filling_color = "#D45D6B"

/obj/item/reagent_containers/food/snacks/cutlet
	name = "cutlet"
	desc = "A tasty meat slice."
	icon = 'icons/obj/item/reagent_containers/food/meat.dmi'
	icon_state = "cutlet"
	bitesize = 2
	center_of_mass = list("x"=17, "y"=20)
	filling_color = "#D45D6B"

	reagents_to_add = list(/singleton/reagent/nutriment/protein = 2)

/obj/item/reagent_containers/food/snacks/rawmeatball
	name = "raw meatball"
	desc = "A raw meatball."
	icon = 'icons/obj/item/reagent_containers/food/meat.dmi'
	icon_state = "rawmeatball"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=15)
	filling_color = "#D45D6B"

	reagents_to_add = list(/singleton/reagent/nutriment/protein = 2)

/obj/item/reagent_containers/food/snacks/meatball
	name = "meatball"
	desc = "A great meal all round."
	icon = 'icons/obj/item/reagent_containers/food/meat.dmi'
	icon_state = "meatball"
	item_state = "meatball"
	filling_color = "#DB0000"
	bitesize = 2

	reagents_to_add = list(/singleton/reagent/nutriment/protein = 3)

/obj/item/reagent_containers/food/snacks/rawbacon
	name = "raw bacon"
	desc = "A very thin piece of raw meat, cut from beef."
	icon = 'icons/obj/item/reagent_containers/food/meat.dmi'
	icon_state = "rawbacon"
	bitesize = 1
	center_of_mass = list("x"=16, "y"=16)
	filling_color = "#FF3826"

/obj/item/reagent_containers/food/snacks/bacon
	name = "bacon"
	desc = "A tasty meat slice. You don't see any pigs on this station, do you?"
	icon = 'icons/obj/item/reagent_containers/food/meat.dmi'
	icon_state = "bacon"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=16)
	filling_color = "#FC5647"

/obj/item/reagent_containers/food/snacks/bacon/oven
	name = "oven-cooked bacon"
	desc = "A tasty meat slice. You don't see any pigs on this station, do you?"
	icon = 'icons/obj/item/reagent_containers/food/meat.dmi'
	icon_state = "bacon"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=16)
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 0.33, /singleton/reagent/nutriment/triglyceride = 1)
	filling_color = "#FC5647"

/obj/item/reagent_containers/food/snacks/bacon/pan
	name = "pan-cooked bacon"
	desc = "A tasty meat slice. You don't see any pigs on this station, do you?"
	icon = 'icons/obj/item/reagent_containers/food/meat.dmi'
	icon_state = "bacon"
	bitesize = 2
	filling_color = "#FC5647"

/obj/item/reagent_containers/food/snacks/hotdog
	name = "hotdog"
	desc = "Hot dog, you say? Commoners have resorted to eating dog now, how dreadful."
	icon = 'icons/obj/item/reagent_containers/food/meat.dmi'
	icon_state = "hotdog"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=17)
	filling_color = "#D45D6B"

	reagents_to_add = list(/singleton/reagent/nutriment/protein = 6)

/obj/item/reagent_containers/food/snacks/classichotdog
	name = "classic hotdog"
	desc = "Going literal."
	icon = 'icons/obj/item/reagent_containers/food/meat.dmi'
	icon_state = "hotcorgi"
	center_of_mass = "x=16;y=17"
	bitesize = 6
	filling_color = "#D45D6B"

	reagents_to_add = list(/singleton/reagent/nutriment/protein = 16)

/obj/item/reagent_containers/food/snacks/meat
	name = "meat"
	desc = "A slab of meat."
	icon = 'icons/obj/item/reagent_containers/food/meat.dmi'
	icon_state = "meat"
	item_state = "meat" // don't change the item_state unless you know what you're doing, or i will kill you. -Wezzy
	health = 180
	filling_color = "#FF1C1C"
	center_of_mass = list("x"=16, "y"=14)
	cooked_icon = "meatstake"
	slice_path = /obj/item/reagent_containers/food/snacks/rawcutlet
	slices_num = 3
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 6, /singleton/reagent/nutriment/triglyceride = 2)
	bitesize = 1.5
	contained_sprite = TRUE

/obj/item/reagent_containers/food/snacks/meat/cook()

	if (!isnull(cooked_icon))
		icon_state = cooked_icon
		flat_icon = null //Force regenating the flat icon for coatings, since we've changed the icon of the thing being coated
	..()

	if (name == initial(name))
		name = "cooked [name]"

/obj/item/reagent_containers/food/snacks/meat/syntiflesh
	name = "synthetic meat"
	desc = "A synthetic slab of flesh."

// TODO cancelled, subtypes are fine. recipes use istype checks
/obj/item/reagent_containers/food/snacks/meat/human

/obj/item/reagent_containers/food/snacks/meat/bug
	icon_state = "bugmeat"
	filling_color = "#E6E600"
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 6, /singleton/reagent/nutriment/triglyceride = 2, /singleton/reagent/toxin/phoron = 27)
	bitesize = 1.5

/obj/item/reagent_containers/food/snacks/meat/monkey
	//same as plain meat

/obj/item/reagent_containers/food/snacks/meat/neaera
	name = "neaera meat"
	icon_state = "neaera_meat"
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 3, /singleton/reagent/nutriment/protein/seafood = 3, /singleton/reagent/nutriment/triglyceride = 2)

/obj/item/reagent_containers/food/snacks/meat/corgi
	name = "corgi meat"
	desc = "Tastes like... well, you know."

/obj/item/reagent_containers/food/snacks/meat/chicken
	name = "chicken meat"
	icon_state = "chickenbreast"
	cooked_icon = "chickenbreast_cooked"
	filling_color = "#BBBBAA"
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 6) //Chicken is low fat. Less total calories than other meats

/obj/item/reagent_containers/food/snacks/meat/pig
	name = "pig meat"
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 6, /singleton/reagent/nutriment/triglyceride = 4)

/obj/item/reagent_containers/food/snacks/meat/biogenerated
	name = "meat substitute"
	desc = "A slab of extruded plant bits that pretends to be meat."
	icon_state = "plantmeat"
	filling_color = "#A8AA00"
	reagents_to_add = list(/singleton/reagent/nutriment = 6)

/obj/item/reagent_containers/food/snacks/meat/undead
	name = "rotten meat"
	desc = "A slab of rotten meat."
	icon_state = "rottenmeat"
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 6, /singleton/reagent/toxin/undead = 5)

/obj/item/reagent_containers/food/snacks/meat/adhomai
	name = "adhomian meat"
	desc = "A slab of an animal native from Adhomai."
	icon_state = "adhomai_meat"
	desc_extended = "For much of Tajaran history, the herbivorous and graceful Nav'twir were the main prey of Tajaran hunters, and still are today in rural areas of the planet. \
	Their meat was nice and hearty and healthy, and the thick furs were good for making clothes to keep themselves warm in the snow. As the modern ages came, the hunting of the \
	'striders', as their name translates, slowed as the Tajara started to learn how to capture and farm them for their resources more efficiently. That being said, not that the modern \
	day Adhomai needs their resources less thanks to synthetic fabric and more efficient food sources, both the meat and the fur of the nav'twir has become an export of the Adhomai \
	people. In the olden days, carved nav'twir antlers were used as decoration for pelts and armors."

/obj/item/reagent_containers/food/snacks/meat/rat
	name = "rat meat"
	icon_state = "chickenbreast"
	desc = "You have reached the epitome of poorness: eating the station's vermin."
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 5, /singleton/reagent/nutriment/triglyceride = 2)
	bitesize = 1.5

/obj/item/reagent_containers/food/snacks/meat/dionanymph
	name = "diona nymph meat"
	desc = "A slab of weird green meat."
	icon_state = "plantmeat"
	reagents_to_add = list(/singleton/reagent/diona_powder = 10)

/obj/item/reagent_containers/food/snacks/meat/vannatusk
	desc = "A slab of weird blue meat."
	icon_state = "vannameat"
	item_state = "vannameat"
	contained_sprite = TRUE
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 6, /singleton/reagent/mindbreaker = 6)

/obj/item/reagent_containers/food/snacks/meat/bat
	name = "bat wings"
	desc = "Like chicken wings, but with even less meat!"
	icon_state = "batmeat"
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 1)

// not meat subtypes

/obj/item/reagent_containers/food/snacks/hugemushroomslice
	name = "huge mushroom slice"
	desc = "There wasn't much room for that mushroom."
	icon = 'icons/obj/item/reagent_containers/food/meat.dmi'
	icon_state = "hugemushroomslice"
	filling_color = "#E0D7C5"

	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/drugs/psilocybin = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("raw" = 2, "mushroom" = 2))
	bitesize = 6

/obj/item/reagent_containers/food/snacks/tomatomeat
	name = "tomato slice"
	desc = "A slice from a huge tomato."
	icon = 'icons/obj/item/reagent_containers/food/meat.dmi'
	icon_state = "tomatomeat"
	filling_color = "#DB0000"

	reagents_to_add = list(/singleton/reagent/nutriment = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("raw" = 2, "tomato" = 3))
	bitesize = 6

/obj/item/reagent_containers/food/snacks/bearmeat
	name = "bear meat"
	desc = "I can bearly control myself."
	icon = 'icons/obj/item/reagent_containers/food/meat.dmi'
	icon_state = "bearmeat"
	filling_color = "#DB0000"
	bitesize = 3
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 12, /singleton/reagent/hyperzine = 5)

/obj/item/reagent_containers/food/snacks/xenomeat
	name = "meat"
	desc = "A slab of green meat. Smells like acid."
	icon = 'icons/obj/item/reagent_containers/food/meat.dmi'
	icon_state = "xenomeat"
	filling_color = "#43DE18"
	bitesize = 6

	reagents_to_add = list(/singleton/reagent/nutriment/protein = 6, /singleton/reagent/acid/polyacid = 6)

/obj/item/reagent_containers/food/snacks/xenomeat/grilled
	name = "grilled xeno steak"
	desc = "A piece of grilled xeno meat. The process converts the dangerous acids within into tasty fats, even though the final look might be... upsetting."
	icon = 'icons/obj/item/reagent_containers/food/meat.dmi'
	icon_state = "xenosteak"

	trash = /obj/item/trash/plate/steak
	center_of_mass = list("x"=16, "y"=13)
	bitesize = 2
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 6, /singleton/reagent/nutriment/triglyceride = 2, /singleton/reagent/capsaicin = 2)

/obj/item/reagent_containers/food/snacks/xenomeat/grilled/update_icon()
	var/percent = round((reagents.total_volume / 10) * 100)
	switch(percent)
		if(0 to 10)
			icon_state = "xenosteak_10"
		if(11 to 25)
			icon_state = "xenosteak_25"
		if(26 to 40)
			icon_state = "xenosteak_40"
		if(41 to 60)
			icon_state = "xenosteak_60"
		if(61 to 75)
			icon_state = "xenosteak_75"
		if(76 to INFINITY)
			icon_state = "xenosteak"

/obj/item/reagent_containers/food/snacks/meatsteak
	name = "meat steak"
	desc = "A piece of hot spicy meat."
	icon = 'icons/obj/item/reagent_containers/food/meat.dmi'
	icon_state = "steak"
	trash = /obj/item/trash/plate/steak
	filling_color = "#7A3D11"
	center_of_mass = list("x"=16, "y"=13)
	bitesize = 2
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 6, /singleton/reagent/nutriment/triglyceride = 2, /singleton/reagent/sodiumchloride = 1, /singleton/reagent/blackpepper = 1)

/obj/item/reagent_containers/food/snacks/meatsteak/update_icon()
	var/percent = round((reagents.total_volume / 10) * 100)
	switch(percent)
		if(0 to 10)
			icon_state = "steak_10"
		if(11 to 25)
			icon_state = "steak_25"
		if(26 to 40)
			icon_state = "steak_40"
		if(41 to 60)
			icon_state = "steak_60"
		if(61 to 75)
			icon_state = "steak_75"
		if(76 to INFINITY)
			icon_state = "steak"

/obj/item/reagent_containers/food/snacks/meatsteak/grilled
	name = "grilled steak"
	desc = "A piece of meat grilled to absolute perfection. Sssssssip. This is the life."
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 6, /singleton/reagent/nutriment/triglyceride = 2, /singleton/reagent/sodiumchloride = 1, /singleton/reagent/blackpepper = 1)

/obj/item/reagent_containers/food/snacks/meatsteak/grilled/spicy
	desc = "A piece of meat grilled to absolute perfection, spiced to tastebud specification. Sssssssip. This is the life."
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 6, /singleton/reagent/nutriment/triglyceride = 2, /singleton/reagent/sodiumchloride = 1, /singleton/reagent/blackpepper = 1, /singleton/reagent/spacespice = 2)

/obj/item/reagent_containers/food/snacks/sausage
	name = "sausage"
	desc = "A piece of mixed, long meat."
	icon = 'icons/obj/item/reagent_containers/food/meat.dmi'
	icon_state = "sausage"
	filling_color = "#DB0000"
	bitesize = 2

	reagents_to_add = list(/singleton/reagent/nutriment/protein = 6)

/obj/item/reagent_containers/food/snacks/pepperoni
	name = "pepperoni"
	desc = "A stick of pepperoni sausage."
	icon = 'icons/obj/item/reagent_containers/food/meat.dmi'
	icon_state = "pepperoni"
	filling_color = "#DB0000"
	bitesize = 2

	reagents_to_add = list(/singleton/reagent/nutriment/protein = 6)

/obj/item/reagent_containers/food/snacks/nugget
	name = "chicken nugget"
	icon = 'icons/obj/item/reagent_containers/food/meat.dmi'
	icon_state = "nugget_lump"
	bitesize = 3
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 4)
	filling_color = "#EDF291"

/obj/item/reagent_containers/food/snacks/nugget/Initialize()
	. = ..()
	var/shape = pick("lump", "star", "lizard", "corgi")
	desc = "A chicken nugget vaguely shaped like a [shape]."
	icon = 'icons/obj/item/reagent_containers/food/meat.dmi'
	icon_state = "nugget_[shape]"

/obj/item/reagent_containers/food/snacks/squidmeat
	name = "squid meat"
	desc = "Soylent squid is (not) people!"
	icon = 'icons/obj/item/reagent_containers/food/meat.dmi'
	icon_state = "squidmeat"
	reagents_to_add = list(/singleton/reagent/nutriment/protein/seafood = 3)

/obj/item/reagent_containers/food/snacks/squidmeat/attackby(var/obj/item/W, var/mob/user)
	if(is_sharp(W) && (locate(/obj/structure/table) in loc))
		var/transfer_amt = Floor(reagents.total_volume/3)
		for(var/i = 1 to 3)
			var/obj/item/reagent_containers/food/snacks/sashimi/sashimi = new(get_turf(src), "squid")
			reagents.trans_to(sashimi, transfer_amt)
		qdel(src)

/obj/item/reagent_containers/food/snacks/lasagna
	name = "lasagna"
	desc = "Favorite of cats."
	icon = 'icons/obj/item/reagent_containers/food/meat.dmi'
	icon_state = "lasagna"
	trash = /obj/item/trash/grease
	drop_sound = /singleton/sound_category/tray_hit_sound
	center_of_mass = list("x"=16, "y"=17)
	filling_color = "#EDF291"

	reagents_to_add = list(/singleton/reagent/nutriment = 12, /singleton/reagent/nutriment/protein = 12)
	reagent_data = list(/singleton/reagent/nutriment = list("pasta" = 4, "tomato" = 2))
	bitesize = 6

/obj/item/reagent_containers/food/snacks/donerkebab
	name = "doner kebab"
	desc = "A delicious sandwich-like food from ancient Earth. The meat is typically cooked on a vertical rotisserie."
	icon = 'icons/obj/item/reagent_containers/food/meat.dmi'
	icon_state = "doner_kebab"
	filling_color = "#D45D6B"

	reagents_to_add = list(/singleton/reagent/nutriment = 5, /singleton/reagent/nutriment/protein = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("dough" = 4, "cabbage" = 2))
	bitesize = 3

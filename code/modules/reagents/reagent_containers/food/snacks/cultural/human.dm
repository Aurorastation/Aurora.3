/obj/item/reagent_containers/food/snacks/redcurry
	name = "red curry"
	gender = PLURAL
	desc = "A bowl of creamy red curry with meat and rice. This one looks savory."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "redcurry"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#f73333"
	center_of_mass = list("x"=16, "y"=8)
	reagents_to_add = list(/singleton/reagent/nutriment = 8, /singleton/reagent/nutriment/protein = 7, /singleton/reagent/spacespice = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("rice" = 4, "curry" = 4))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/greencurry
	name = "green curry"
	gender = PLURAL
	desc = "A bowl of creamy green curry with tofu, hot peppers and rice. This one looks spicy!"
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "greencurry"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#58b76c"
	center_of_mass = list("x"=16, "y"=8)
	reagents_to_add = list(/singleton/reagent/nutriment = 8, /singleton/reagent/nutriment/protein/tofu = 5, /singleton/reagent/spacespice = 2, /singleton/reagent/capsaicin = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("rice" = 2, "curry" = 4, "tofu" = 4))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/yellowcurry
	name = "yellow curry"
	gender = PLURAL
	desc = "A bowl of creamy yellow curry with potatoes, peanuts and rice. This one looks mild."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "yellowcurry"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#bc9509"
	center_of_mass = list("x"=16, "y"=8)
	reagents_to_add = list(/singleton/reagent/nutriment = 8, /singleton/reagent/spacespice = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("rice" = 2, "curry" = 2, "potato" = 2, "peanut" = 2))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/chana_masala
	name = "chana masala"
	desc = "Curried chickpeas on rice."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "chana_masala"
	filling_color = "#C97F02"
	reagents_to_add = list(/singleton/reagent/nutriment = 8, /singleton/reagent/nutriment/rice = 10, /singleton/reagent/spacespice = 2, /singleton/reagent/capsaicin = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("spicy chickpeas" = 4))
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_containers/food/snacks/friedrice
	name = "fried rice"
	gender = PLURAL
	desc = "A less-boring dish of less-boring rice!"
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "friedrice"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FFFBDB"
	center_of_mass = list("x"=17, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 8, /singleton/reagent/nutriment/rice = 5, /singleton/reagent/drink/carrotjuice = 3, /singleton/reagent/oculine = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("soy" = 2,))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/risotto
	name = "risotto"
	gender = PLURAL
	desc = "A creamy, savory rice dish from southern Europe, typically cooked slowly with wine and broth. This one has bits of mushroom."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "risotto"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#edd7d7"
	center_of_mass = list("x"=15, "y"=9)
	reagents_to_add = list(/singleton/reagent/nutriment = 9, /singleton/reagent/nutriment/protein = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("rich" = 2, "spices" = 2, "mushroom" = 4))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/boiledrice
	name = "boiled rice"
	desc = "A boring dish of boring rice."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "boiledrice"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FFFBDB"
	center_of_mass = list("x"=17, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("rice" = 2))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/ricepudding
	name = "rice pudding"
	desc = "Where's the jam?"
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "rpudding"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FFFBDB"
	center_of_mass = list("x"=17, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("rice" = 2))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/bibimbap
	name = "bibimbap bowl"
	desc = "A traditional Korean meal of meat and mixed vegetables. It's served on a bed of rice, and topped with a fried egg."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "bibimbap"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#4f2100"
	center_of_mass = list("x"=15, "y"=9)
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/nutriment/protein = 6, /singleton/reagent/oculine = 3, /singleton/reagent/spacespice = 2, /singleton/reagent/nutriment/protein/egg = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("rice" = 2, "mushroom" = 2, "carrot" = 2))
	bitesize = 4

/obj/item/reagent_containers/food/snacks/stewedsoymeat
	name = "stewed soy meat"
	desc = "Even non-vegetarians will LOVE this!"
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "stewedsoymeat"
	trash = /obj/item/trash/plate
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/nutriment = 8)
	reagent_data = list(/singleton/reagent/nutriment = list("soy" = 4, "tomato" = 4))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/tofurkey
	name = "tofurkey"
	desc = "A fake turkey made from tofu."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "tofurkey"
	filling_color = "#FFFEE0"

	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/nutriment/protein/tofu = 6, /singleton/reagent/soporific = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("turkey" = 3))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/meatbun
	name = "meat bun"
	desc = "A soft, fluffy flour bun also known as baozi. This one is filled with a spiced meat filling."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "meatbun"
	filling_color = "#edd7d7"
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 5, /singleton/reagent/nutriment/protein = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("buns" = 2, "spices" = 2))
	bitesize = 5

/obj/item/reagent_containers/food/snacks/custardbun
	name = "custard bun"
	desc = "A soft, fluffy flour bun also known as baozi. This one is filled with an egg custard."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "meatbun"
	filling_color = "#ebedc2"
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/nutriment/protein/egg = 2, /singleton/reagent/nutriment/protein = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("buns" = 2, "spices" = 2))
	bitesize = 6

/obj/item/reagent_containers/food/snacks/chickenmomo
	name = "chicken momo"
	gender = PLURAL
	desc = "A plate of spiced and steamed chicken dumplings. The style originates from south Asia."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "momo"
	trash = /obj/item/trash/snacktray
	filling_color = "#edd7d7"
	center_of_mass = list("x"=15, "y"=9)
	reagents_to_add = list(/singleton/reagent/nutriment = 9, /singleton/reagent/nutriment/protein = 6, /singleton/reagent/spacespice = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("buns" = 4))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/veggiemomo
	name = "veggie momo"
	gender = PLURAL
	desc = "A plate of spiced and steamed vegetable dumplings. The style originates from south Asia."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "momo"
	trash = /obj/item/trash/snacktray
	filling_color = "#edd7d7"
	center_of_mass = list("x"=15, "y"=9)
	reagents_to_add = list(/singleton/reagent/nutriment = 13, /singleton/reagent/spacespice = 4, /singleton/reagent/drink/carrotjuice = 3, /singleton/reagent/oculine = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("buns" = 2, "cabbage" = 4))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/porkbowl
	name = "pork bowl"
	desc = "A bowl of fried rice with cuts of meat."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "porkbowl"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FFFBDB"
	bitesize = 2

	reagents_to_add = list(/singleton/reagent/nutriment/rice = 6, /singleton/reagent/nutriment/protein = 4)

/obj/item/reagent_containers/food/snacks/crabmeat
	name = "crab legs"
	desc = "... Coffee? Is that you?"
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "crabmeat"
	bitesize = 1

	reagents_to_add = list(/singleton/reagent/nutriment/protein/seafood = 2)

/obj/item/reagent_containers/food/snacks/crab_legs
	name = "steamed crab legs"
	desc = "Crab legs steamed and buttered to perfection. One day when the boss gets hungry..."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "crablegs"

	reagents_to_add = list(/singleton/reagent/nutriment = 2, /singleton/reagent/nutriment/protein/seafood = 6, /singleton/reagent/sodiumchloride = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("savory butter" = 2))
	bitesize = 2
	trash = /obj/item/trash/plate
	filling_color = "#FFA8E5"

// Konyang

/obj/item/reagent_containers/food/snacks/mossbowl
	name = "moss bowl"
	desc = "A bowl of fried rice with moss on top."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "mossbowl"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FFFBDB"
	bitesize = 2
	reagents_to_add = list(/singleton/reagent/nutriment/moss = 6, /singleton/reagent/nutriment/protein/egg = 3)

/obj/item/reagent_containers/food/snacks/moss_dumplings
	name = "moss dumplings"
	desc = "A relatively common Konyanger dish, this appears to be steamed moss set in steamed dough."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "moss_dumplings"
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/moss = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("steamed dough" = 3, "moss" = 3))
	filling_color = "#589755"

/obj/item/reagent_containers/food/snacks/soup/maeuntang
	name = "maeuntang"
	desc = "A popular fish soup originating from Korea, this spicy dish has been given a distinctly Konyanger twist by the addition of \
	moss to the ingredients, and has since proven to be a staple on the planet."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "maeuntang"
	reagent_data = list(/singleton/reagent/nutriment = list("hot stew" = 3, "spices" = 1, "vegetables" = 1, "fish" = 2, "moss" = 2))
	reagents_to_add = list(/singleton/reagent/nutriment = 8, /singleton/reagent/water = 5)

/obj/item/reagent_containers/food/snacks/soup/miyeokguk
	name = "miyeokguk"
	desc = "A simple soup made from fish broth, beef, seaweed, and moss. It is known for its health properties and commonly eaten on celebrations."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "miyeokguk"
	reagent_data = list(/singleton/reagent/nutriment = list("hot stew" = 3, "beef" = 1, "seaweed" = 2, "moss" = 2))
	reagents_to_add = list(/singleton/reagent/nutriment = 8, /singleton/reagent/water = 5)

/obj/item/reagent_containers/food/snacks/ricetub
	name = "packed rice bowl"
	desc = "Boiled rice packed in a sealed plastic tub with the Nojosuru Foods logo on it. There appears to be a pair of chopsticks clipped to the side."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "ricetub"
	trash = /obj/item/trash/ricetub/sticks
	filling_color = "#A66829"
	center_of_mass = list("x"=17, "y"=16)
	reagents_to_add = list(/singleton/reagent/nutriment = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("rice" = 1))
	var/sticks = 1

/obj/item/reagent_containers/food/snacks/ricetub/verb/remove_sticks()
	set name = "Remove Chopsticks"
	set category = "Object"
	set src in usr

	var/obj/item/material/kitchen/utensil/fork/chopsticks/cheap/S = new()

	if(use_check_and_message(usr))
		return

	if(!sticks)
		to_chat(usr, SPAN_WARNING("There are no chopsticks attached to \the [src]."))
		return

	sticks = 0
	trash = /obj/item/trash/ricetub
	desc = "Boiled rice packed in a sealed plastic tub with the Nojosuru Foods logo on it. There appears to have once been something clipped to the side."
	usr.put_in_hands(S)

	update_icon()
	to_chat(usr, SPAN_NOTICE("You remove the chopsticks from \the [src]."))

/obj/item/reagent_containers/food/snacks/ricetub/update_icon()
	var/percent = round((reagents.total_volume / 5) * 100)
	switch(percent)
		if(0 to 90)
			if(sticks)
				icon_state = "ricetub_s_90"
			else
				icon_state = "ricetub_90"
		if(91 to INFINITY)
			if(sticks)
				icon_state = "ricetub_s"
			else
				icon_state = "ricetub"

/obj/item/reagent_containers/food/snacks/seaweed
	name = "Go-Go Gwok! Authentic Konyanger moss"
	desc = "Genuine Konyanger moss packaged into a neat bag for easy consumption. A light amount of salt has been applied to this moss, to enhance the natural flavour. The box features Gwok herself on the \
	box's cover, smiling broadly and giving a thumbs up!"
	desc_extended = "Go-Go Gwok! is one of the most unusual brands on Konyang, as it is owned by an IPC rather than a human. Gwok-0783, originally produced by Terraneus Diagnostics as a baseline hydroponicist and now \
	the shell Go-Go Gwok! lovers throughout the Orion Spur know and love, has - through a series of legal technicalities and loopholes that would make an Eridanian Suit blush with envy - managed to become the CEO \
	and majority shareholder in this fairly small Solarian corporation.	Through her headquarters on Xanu Prime, Gwok-0783 revels in her existence as one of the Orion Spur's wealthiest IPCs, her image now plastered \
	on delicious (yet affordable) moss packets consumed across the Orion Spur."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "seaweed"
	trash = /obj/item/trash/seaweed
	filling_color = "#A66829"
	center_of_mass = list("x"=17, "y"=16)
	reagents_to_add = list(/singleton/reagent/nutriment = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("seaweed" = 1))

/obj/item/reagent_containers/food/snacks/seaweed/update_icon()
	var/percent = round((reagents.total_volume / 4) * 100)
	switch(percent)
		if(0 to 90)
			icon_state = "seaweed_90"
		if(91 to INFINITY)
			icon_state = "seaweed"

/obj/item/reagent_containers/food/snacks/riceball
	name = "rice ball"
	desc = "A bundle of rice wrapped in seaweed. This one seems to have a fish flake filling inside."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "riceball"
	filling_color = "#A66829"
	center_of_mass = list("x"=17, "y"=16)
	reagents_to_add = list(/singleton/reagent/nutriment = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("seaweed" = 0.5, "rice" = 0.5, "soysauce" = 0.5))

/obj/item/reagent_containers/food/snacks/riceball/update_icon()
	var/percent = round((reagents.total_volume / 3) * 100)
	switch(percent)
		if(0 to 90)
			icon_state = "riceball_90"
		if(91 to INFINITY)
			icon_state = "riceball"

// Mictlani

/obj/item/reagent_containers/food/snacks/soup/pozole
	name = "dyn pozole"
	desc = "The traditional Mictlanian pozole, incorporating dyn to add flavor."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "dynpozole"
	reagent_data = list(/singleton/reagent/nutriment = list("peppermint" = 2, "salad" = 4, "hot stew" = 2))
	reagents_to_add = list(/singleton/reagent/nutriment = 8, /singleton/reagent/water = 5, /singleton/reagent/drink/dynjuice =2)

// Dominia
/obj/item/reagent_containers/food/snacks/moroz_flatbread
	name = "morozian flatbread"
	desc = "One of the fundamental dishes of the Dominian Empire, also known as Imperial flatbread."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "moroz_flatbread"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=16)
	reagents_to_add = list(/singleton/reagent/nutriment = 10)
	reagent_data = list(/singleton/reagent/nutriment = list("bread" = 3))
	filling_color = "#B89F61"

/obj/item/reagent_containers/food/snacks/soup/brudet
	name = "morozian brudet"
	desc = "The most popular dish from the Dominian Empire, this stew is a staple of Imperial cuisine."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "brudet"
	reagent_data = list(/singleton/reagent/nutriment = list("hot stew" = 3, "spices" = 1, "vegetables" = 1, "fish" = 2))
	reagents_to_add = list(/singleton/reagent/nutriment = 8, /singleton/reagent/water = 5)

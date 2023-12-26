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
	icon = 'icons/obj/item/reagent_containers/food/meat.dmi'
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

	var/obj/item/material/kitchen/utensil/fork/chopsticks/bamboo/S = new()

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

/obj/item/reagent_containers/food/snacks/imperial_pot
	name = "imperial pot"
	desc = "A massive wooden pot of morozian seafood and rice, traditionally served in dominian feasts and festivals. It is a communal dish shared among friends, family and neighbors. Grab a bowl, you're not finishing this one by yourself."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "imperialpotfull"
	reagent_data = list(/singleton/reagent/nutriment/protein/seafood = list ("seafood" = 10), /singleton/reagent/nutriment = list("rice" = 10, "potatoes" = 8, "vegetables" = 6))
	reagents_to_add = list(/singleton/reagent/nutriment/protein/seafood = 20, /singleton/reagent/nutriment/rice = 20, /singleton/reagent/nutriment = 20, /singleton/reagent/drink/lemonjuice = 20, /singleton/reagent/spacespice = 5, /singleton/reagent/dylovene = 5)
	filling_color = "#d4b756"
	center_of_mass = list("x"=16, "y"=10)
	bitesize = 3
	trash = /obj/item/trash/imperial_pot_empty
	drop_sound = 'sound/items/drop/shovel.ogg'
	pickup_sound = 'sound/items/pickup/shovel.ogg'
	is_liquid = TRUE

/obj/item/reagent_containers/food/snacks/imperial_pot/update_icon()
	var/percent_chetroinuoc = round((reagents.total_volume / 10) * 100)
	switch(percent_chetroinuoc)
		if(0 to 1)
			icon_state = "imperialpotempty"
		if(2 to INFINITY)
			icon_state = "imperialpotfull"

/obj/item/reagent_containers/food/snacks/jadrica
	name = "jadrica"
	desc = "A high-end dominian dish from Novi Jadran made of slow cooked braised beef, cloves, carrots and bacon. It is a very complex and difficult dish to make properly - A task usually only succeeded by the most skilled, high-end chefs. In a time crunch, enzymes can be used to speed along the slow cooking process."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "jadrica"
	trash = /obj/item/trash/wooden_platter
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 8, /singleton/reagent/nutriment = 4, /singleton/reagent/nutriment/triglyceride = 4, /singleton/reagent/spacespice = 2)
	reagent_data = list(/singleton/reagent/nutriment/protein = list("braised beef" = 10, "bacon" = 10), /singleton/reagent/nutriment = list("cloves" = 5, "vinegar" = 5))
	bitesize = 3
	filling_color = "#49251b"

/obj/item/reagent_containers/food/snacks/imperial_scallops
	name = "imperial scallops"
	desc = "Saltwater boiled dominian scallops. While originally this dish was served with just a few herbs, newer iterations add an abundance of flavor to show the dish and the Dominian culture's lavishness."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "imperialscallops"
	trash = /obj/item/trash/plate
	bitesize = 2
	filling_color = "#dbb06f"
	reagents_to_add = list(/singleton/reagent/nutriment/protein/seafood/mollusc = 6, /singleton/reagent/nutriment = 2, /singleton/reagent/water = 5, /singleton/reagent/sodiumchloride = 2)
	reagent_data = list(/singleton/reagent/nutriment/protein/seafood/mollusc = list("pillowy scallops" = 10, "salt" = 5), /singleton/reagent/nutriment = list("butter" = 10))

//New Hai Phong

/obj/item/reagent_containers/food/snacks/chetroinuoc
	name = "che troi nuoc"
	desc = "Traditional solarian dessert from New Hai Phong, these triangular sweet rice dumplings are filled with beans."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "chetroinuoc3"
	trash = /obj/item/trash/leaf
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/nutriment/rice = 6)
	reagent_data = list(/singleton/reagent/nutriment = list("sweet rice" = 4, "beans" = 2))
	bitesize = 2
	filling_color = "#bb9b9b"

/obj/item/reagent_containers/food/snacks/chetroinuoc/update_icon()
	var/percent_chetroinuoc = round((reagents.total_volume / 12) * 100)
	switch(percent_chetroinuoc)
		if(0 to 33)
			icon_state = "chetroinuoc1"
		if(34 to 66)
			icon_state = "chetroinuoc2"
		if(67 to INFINITY)
			icon_state = "chetroinuoc3"

// Europa

/obj/item/reagent_containers/food/snacks/deepdive
	name = "deep dive"
	desc = "A traditional savory stacked layer dish from Europa, made of fish pastes, cream cheese, seaweed on top, and occasionaly some sauce, served in a transparent deep dish."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "deepdive"
	trash = /obj/item/trash/deepdive
	filling_color = "#006666"
	reagents_to_add = list(/singleton/reagent/nutriment/ = 3, /singleton/reagent/nutriment/protein/seafood = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("nori" = 3, "cream cheese" = 2))
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'

// Biesel

/obj/item/reagent_containers/food/snacks/bluemoon
	name = "blue moon"
	desc = "This way of serving a white chocolate-raspberry mousse was originally made popular in Mendell's Vega De Rosa district in the 24th century and has since gained popularity around Tau Ceti."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "bluemoon"
	trash = /obj/item/trash/bluemoon
	filling_color = "#4377E2"
	reagents_to_add = list(/singleton/reagent/nutriment/ = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("blue raspberry" = 5, "white chocolate" = 3))
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'


// Eridani

/obj/item/reagent_containers/food/snacks/bowl
	abstract_type = /obj/item/reagent_containers/food/snacks/bowl
	name = "a bowl of item"
	desc = "If you're seeing this, something has gone wrong D:"
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "puffpuffbowl"
	trash = /obj/item/trash/snack_bowl
	var/vendingobject = /obj/item/reagent_containers/food/snacks/puffpuff
	///This is the item itself that the bowl dispenses, as an obj. I have it set to puff puffs by default but if you reuse this code for a different food - change accordingly.
	reagent_data = list(/singleton/reagent/nutriment = list("fried dough" = 10, "ginger" = 4))
	bitesize = 4
	reagents_to_add = list(/singleton/reagent/nutriment = 24)
	var/unitname = "contained_food" ///this is the NAME of the item the bowl dispenses, as it would show up in a sentence.

/obj/item/reagent_containers/food/snacks/bowl/puffpuffs
	name = "puff-puff bowl"
	desc = "A bowl of puffy dough balls. Much like donut balls except pan fried, chewier, and often served savory, not just sweet. It originates in Nigeria, but this is the Eridani variant, which is made with ginger instead of pepper."
	bitesize = 4
	reagents_to_add = list(/singleton/reagent/nutriment/ = 24)
	unitname = "puff-puff"
	filling_color = "#bb8a41"

/obj/item/reagent_containers/food/snacks/bowl/attack_hand(mob/user as mob)
	var/obj/item/reagent_containers/food/snacks/returningitem = new vendingobject(loc)
	returningitem.reagents.clear_reagents()
	reagents.trans_to(returningitem, bitesize)
	returningitem.bitesize = bitesize/2
	user.put_in_hands(returningitem)
	if (reagents && reagents.total_volume)
		to_chat(user, "You take a [unitname] from the plate.")
	else
		to_chat(user, "You take the last [unitname] from the plate.")
		var/obj/waste = new trash(loc)
		if (loc == user)
			user.put_in_hands(waste)
		qdel(src)

/obj/item/reagent_containers/food/snacks/bowl/puffpuffs/update_icon()
	switch(reagents.total_volume)
		if(1 to 8)
			icon_state = "puffpuffbowlfew"
		if(9 to INFINITY)
			icon_state = "puffpuffbowl"

/obj/item/reagent_containers/food/snacks/puffpuff
	name = "puff-puff"
	desc = "A nice, puffy, puff-puff. Mmmm, fried dough. You can feel your arteries clogging already!"
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "puffpuff"
	bitesize = 2
	filling_color = "#bb8a41"

/obj/item/reagent_containers/food/snacks/bowl/fufus
	name = "fufu dumplings"
	desc = "These Eridanian dumplings are made from plantains, and while dense, they are not typically supposed to be served on their own, but rather as a side dish for various Eridanian soups."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "fufubowl"
	filling_color = "#eee0b1"
	vendingobject = /obj/item/reagent_containers/food/snacks/fufu
	bitesize = 3
	reagents_to_add = list(/singleton/reagent/nutriment = 9)
	reagent_data = list(/singleton/reagent/nutriment = list("plantains" = 10))

/obj/item/reagent_containers/food/snacks/bowl/fufus/update_icon()
	switch(reagents.total_volume)
		if(1 to 4)
			icon_state = "fufufew"
		if(5 to INFINITY)
			icon_state = "fufubowl"

/obj/item/reagent_containers/food/snacks/fufu
	name = "fufu dumpling"
	desc = "A big plantain dumpling meant to be dipped or eaten alongside soup."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "fufuone"
	bitesize = 2
	filling_color = "#eee0b1"

//Silversun

/obj/item/reagent_containers/food/snacks/clams_casino
	name = "silversun clams casino"
	desc = "A true silversun classic, clams on the halfshell with breadcrumbs, bacon, and bell peppers. Somehow landing right in the middle ring between average joe finger food and upper class fanciness."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "clamscasino"
	trash = /obj/item/trash/plate
	bitesize = 2
	filling_color = "#a5683f"
	reagents_to_add = list(/singleton/reagent/nutriment/protein/seafood/mollusc = 6, /singleton/reagent/nutriment/protein = 2, /singleton/reagent/nutriment = 2)
	reagent_data = list(/singleton/reagent/nutriment/protein/seafood/mollusc = list("buttery clams" = 15), /singleton/reagent/nutriment/protein = list ("bacon" = 15), /singleton/reagent/nutriment = list("breadcrumbs" = 10, "bell peppers" = 10))

/obj/item/reagent_containers/food/snacks/sliceable/lady_lulaine
	name = "lady lulaine"
	desc = "This rich and creamy berry-coated dessert was invented in a small coastal town on Silversun. It's very tricky to get it stable enough to not collapse under it's own weight. What are you waiting for? Slice it up!"
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "ladylulaine"
	slice_path = /obj/item/reagent_containers/food/snacks/lady_lulaine_slice
	trash = /obj/item/trash/plate
	slices_num = 5
	filling_color = "#dbddff"
	reagents_to_add = list(/singleton/reagent/nutriment = 15, /singleton/reagent/drink/berryjuice = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("custard" = 10, "blueberries" = 10, "tangy berries" = 5))

/obj/item/reagent_containers/food/snacks/lady_lulaine_slice
	name = "lady lulaine slice"
	desc = "A Silversun classic, this dessert is somewhere between a frozen custard, ice cream cake, and berry pie. It is often photographed next to a cocktail with a sunset or a sunrise behind it."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "ladylulaine_slice"
	filling_color = "#dbddff"
	trash = /obj/item/trash/plate

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

/obj/item/reagent_containers/food/snacks/sliceable/roast_chicken
	name = "roast chicken"
	desc = "Roasted and stuffed chicken surrounded by potatoes, all ready for the carving! Dibs on the drumsticks!"
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "roast_chicken"
	slice_path = /obj/item/reagent_containers/food/snacks/roast_chicken_slice
	slices_num = 6
	trash = /obj/item/tray/plate //Yes, this isn't the "trash" kind of plate. It's a big dish, so it's served on a large serving plate.
	filling_color = "#9b5e2c"
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 24, /singleton/reagent/nutriment = 12, /singleton/reagent/soporific = 3)
	reagent_data = list(/singleton/reagent/nutriment/protein = list("chicken" = 6), /singleton/reagent/nutriment = list("potatoes" = 5, "stuffing" = 5))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/roast_chicken_slice
	name = "roast chicken slice"
	desc = "A slice of juicy roasted chicken with potatoes. Get ready to loosen your belt!"
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "roast_chicken_slice"
	trash = /obj/item/trash/plate
	filling_color = "#9b5e2c"

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

/obj/item/reagent_containers/food/snacks/hash_browns
	name = "hash browns"
	desc = "diner-style, thinly-sliced, fried potatoes. so greasy they might as well be singing about cars."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "hashbrowns"

	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/triglyceride/oil/corn = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("crunchy potatoes" = 10))
	bitesize = 2
	filling_color = "#bb8432"

/obj/item/reagent_containers/food/snacks/biscuits_and_gravy
	name = "biscuits and gravy"
	gender = PLURAL
	desc = "Plump biscuits in a thick, rich sausage gravy. A meal traditionally popular in the southern United States, and it's not hard to see why."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "gravybiscuits"
	trash = /obj/item/trash/plate

	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/nutriment/protein = 3, /singleton/reagent/condiment/gravy =3)
	reagent_data = list(/singleton/reagent/nutriment = list("flaky biscuits" = 10), /singleton/reagent/nutriment/protein = list("sausage gravy" = 5))
	bitesize = 3
	filling_color = "#bb8432"

/obj/item/reagent_containers/food/snacks/biscuits_and_gravy/update_icon()
	var/expected_initial_reagent_volume
	for(var/k in src.reagents_to_add)
		expected_initial_reagent_volume += reagents_to_add[k]
	var/percent_biscuits_and_gravy = round((reagents.total_volume / expected_initial_reagent_volume) * 100)
	switch(percent_biscuits_and_gravy)
		if(0 to 49)
			icon_state = "gravybiscuits_half"
		if(50 to INFINITY)
			icon_state = "gravybiscuits"

/obj/item/reagent_containers/food/snacks/bowl/mozzarella_sticks
	name = "mozzarella sticks"
	gender = PLURAL
	desc = "Fried sticks of molten mozzarrella cheese hidden in a deep fried breaded coating. "
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "mozzarella_sticks"
	unitname = "mozzarella stick"
	filling_color = "#fabe17"
	trash = /obj/item/trash/plate
	vendingobject = /obj/item/reagent_containers/food/snacks/mozzarella_stick
	bitesize = 1
	reagents_to_add = list(/singleton/reagent/nutriment/protein/cheese = 4, /singleton/reagent/nutriment = 4)
	reagent_data = list(/singleton/reagent/nutriment/protein/cheese = list("molten cheese" = 5), /singleton/reagent/nutriment = list("crunchy coating" = 5))

/obj/item/reagent_containers/food/snacks/bowl/mozzarella_sticks/update_icon()
	switch(reagents.total_volume)
		if(1 to 3)
			icon_state = "mozzarella_sticks_half"
		if(4 to INFINITY)
			icon_state = "mozzarella_sticks"

/obj/item/reagent_containers/food/snacks/mozzarella_stick
	name = "mozzarella stick"
	desc = "A cheese stick by any other name would taste as savory."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "mozzarella_stick"
	filling_color = "#fabe17"

/obj/item/reagent_containers/food/snacks/jambalaya
	name = "jambalaya"
	desc = "A Creole/Cajun-American dish popularized in Louisiana with origins in Africa and Asia. It is a flavorful mixture of seafood, meats, rice, spices and vegetables. A real celebration of all that is food."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "jambalaya"
	trash = /obj/item/trash/shakshouka
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 6, /singleton/reagent/nutriment = 6)
	reagent_data = list(/singleton/reagent/nutriment/protein = list("chicken" = 5, "shrimp" = 5, "sausage" = 4), /singleton/reagent/nutriment = list("rice" = 5, "rich spicy flavors" = 5))
	filling_color = "#c06917"

/obj/item/reagent_containers/food/snacks/jambalaya/update_icon()
	var/percent_jambalaya = round((reagents.total_volume / 12) * 100)
	switch(percent_jambalaya)
		if(0 to 50)
			icon_state = "jambalaya_half"
		else
			icon_state = "jambalaya"

/obj/item/reagent_containers/food/snacks/bowl/pop_shrimp_bowl
	name = "bowl of pop shrimp" //Popcorn shrimp were invented in the 70's (after the timeline divergence date) so I figured I'd call them something similar but different in this universe.
	desc = "A bowl of fried shrimp so small and crunchy you can just pop them right in your mouth!"
	icon = 'icons/obj/item/reagent_containers/food/fryer.dmi'
	icon_state = "popshrimp_full"
	unitname = "pop shrimp"
	filling_color = "#be7017"
	trash = /obj/item/trash/snack_bowl
	vendingobject = /obj/item/reagent_containers/food/snacks/pop_shrimp
	bitesize = 1
	reagents_to_add = list(/singleton/reagent/nutriment/protein/seafood = 5, /singleton/reagent/nutriment = 1)
	reagent_data = list(/singleton/reagent/nutriment/protein/seafood = list("crunchy fried shrimp" = 5), /singleton/reagent/nutriment = list("seasoning" = 5))

/obj/item/reagent_containers/food/snacks/bowl/pop_shrimp_bowl/update_icon()
	switch(reagents.total_volume)
		if(1 to 3)
			icon_state = "popshrimp_half"
		if(4 to INFINITY)
			icon_state = "popshrimp_full"

/obj/item/reagent_containers/food/snacks/pop_shrimp
	name = "pop shrimp"
	gender = PLURAL
	desc = "A handful of crunchy, fried shrampies!"
	icon = 'icons/obj/item/reagent_containers/food/fryer.dmi'
	icon_state = "popshrimp"
	bitesize = 10
	filling_color = "#be7017"

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
	set category = "Object.Held"
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

/obj/item/reagent_containers/food/snacks/sweet_chili_chicken
	name = "sweet chili chicken"
	desc = "Konyanger style chicken bursting with flavor served over a bed of rice, covered in sesame and green onions with a healthy helping of sweet chili sauce. A little bit spicy, a little bit sweet, a little bit connected to it's roots in Asia, and a little bit modern. In other words - Very Konyang."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "sweetchilichicken"
	filling_color = "#C97F02"
	trash = /obj/item/trash/bowl_small
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 4, /singleton/reagent/nutriment = 1, /singleton/reagent/nutriment/rice = 3, /singleton/reagent/capsaicin = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("rice" = 4), /singleton/reagent/nutriment/protein = list("sweet and spicy chicken" = 5))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/bowl/eggrolls_vegetable
	name = "vegetable eggrolls"
	gender = PLURAL
	desc = "Fried, crispy eggrolls full of carrots, cabbage and ginger. Contrary to popular belief, eggrolls are frequently made without any eggs, using rice paper or wheat based wraps instead."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "eggrolls_veg_full"
	unitname = "eggroll"
	filling_color = "#b19445"
	trash = /obj/item/trash/plate
	vendingobject = /obj/item/reagent_containers/food/snacks/eggroll_vegetable
	bitesize = 2
	reagents_to_add = list(/singleton/reagent/nutriment = 6)
	reagent_data = list(/singleton/reagent/nutriment = list("vegetables" = 5, "crunchy coating" = 5, "ginger" = 3))

/obj/item/reagent_containers/food/snacks/bowl/eggrolls_vegetable/update_icon()
	switch(reagents.total_volume)
		if(1 to 2)
			icon_state = "eggrolls_veg_one"
		if(3 to INFINITY)
			icon_state = "eggrolls_veg_full"

/obj/item/reagent_containers/food/snacks/eggroll_vegetable
	name = "vegetable eggroll"
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	desc = "A crunchy eggroll full of crispy veggies."
	icon_state = "eggroll_veg"
	filling_color = "#b19445"

/obj/item/reagent_containers/food/snacks/bowl/eggrolls_meat
	name = "meat eggrolls"
	gender = PLURAL
	desc = "Fried, crispy eggrolls full of meat, traditionally either pork or chicken, although other kinds exist around the spur. Contrary to popular belief, eggrolls are frequently made without any eggs, using rice paper or wheat based wraps instead."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "eggrolls_meat_full"
	unitname = "eggroll"
	filling_color = "#613e16"
	trash = /obj/item/trash/plate
	vendingobject = /obj/item/reagent_containers/food/snacks/eggroll_meat
	bitesize = 2
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 3, /singleton/reagent/nutriment = 3)
	reagent_data = list(/singleton/reagent/nutriment/protein = list("meat" = 5), /singleton/reagent/nutriment = list("crunchy coating" = 5, "ginger" = 3))

/obj/item/reagent_containers/food/snacks/bowl/eggrolls_meat/update_icon()
	switch(reagents.total_volume)
		if(1 to 2)
			icon_state = "eggrolls_meat_one"
		if(3 to INFINITY)
			icon_state = "eggrolls_meat_full"

/obj/item/reagent_containers/food/snacks/eggroll_meat
	name = "meat eggroll"
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	desc = "A crunchy eggroll full of meat and ginger."
	icon_state = "eggroll_meat"
	filling_color = "#613e16"

// Mictlani

/obj/item/reagent_containers/food/snacks/soup/pozole
	name = "dyn pozole"
	desc = "The traditional Mictlanian pozole, incorporating dyn to add flavor."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "dynpozole"
	reagent_data = list(/singleton/reagent/nutriment = list("peppermint" = 2, "salad" = 4, "hot stew" = 2))
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 5, /singleton/reagent/nutriment = 4, /singleton/reagent/water = 5, /singleton/reagent/drink/dynjuice =2)

/obj/item/reagent_containers/food/snacks/elotes
	name = "elotes"
	gender = PLURAL
	desc = "Grilled mexican sweet corn with chili powder, mayonnaise, cheese, sour cream, and seasonings."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "elotes"
	trash = /obj/item/trash/plate
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/nutriment/protein = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("corn" = 5, "zesty seasoning" = 3, "lime" = 3), /singleton/reagent/nutriment/protein = list("cheese" = 5))
	bitesize = 2
	filling_color = "#d8ab18"

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

ABSTRACT_TYPE(/obj/item/reagent_containers/food/snacks/bowl)
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

/obj/item/reagent_containers/food/snacks/bowl/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params) //Dropping the bowl of food onto the user
	var/mob/mob_dropped_over = over
	if(istype(mob_dropped_over) && !use_check_and_message(mob_dropped_over))
		mob_dropped_over.put_in_active_hand(src)
		src.pickup(mob_dropped_over)
		return

	. = ..()

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
	unitname = "fufu dumpling"
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

/obj/item/reagent_containers/food/snacks/dodo_ikire
	name = "dodo ikire"
	desc = "Originally a Nigerian dish, dodo ikire is traditionally made of over-ripe plantains fried in palm oil with crushed chili, sometimes with onion or ginger for additional flavoring. an Eridanian favorite!"
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "dodo"
	filling_color = "#331d13"
	reagents_to_add = list(/singleton/reagent/nutriment/ = 5, /singleton/reagent/capsaicin = 2)
	bitesize = 2
	trash = /obj/item/trash/plate
	reagent_data = list(/singleton/reagent/nutriment = list("plantains" = 5, "chili" = 3, "zest" = 2))

/obj/item/reagent_containers/food/snacks/dodo_ikire/update_icon()
	var/percent_dodo = round((reagents.total_volume / 7) * 100)
	switch(percent_dodo)
		if(0 to 49)
			icon_state = "dodo_half"
		if(50 to INFINITY)
			icon_state = "dodo"

/obj/item/reagent_containers/food/snacks/crimson_lime
	name = "crimson lime"
	desc = "Possibly named after the presidential crimson house of Suwong, the Konyanger city this dessert originates from, or possibly named after the hint of chili that's mixed into this dessert. Crimson fruit are typically various jungle or citrus fruits coated in dark chili chocolate. It typically favors fruit that is less aggressively sweet so the opposite flavors can play off of each other without overpowering one another."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "crimson_lime"
	filling_color = "#2d460d"
	trash = /obj/item/trash/plate
	reagents_to_add = list(/singleton/reagent/nutriment/ = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("lime" = 5, "chocolate" = 5, "chili" = 2))

/obj/item/reagent_containers/food/snacks/bowl/alfajores
	name = "alfajores"
	desc = "A plate of delicious vanilla sandwich cookies filled with dulche de leche and covered in coconut shavings. A sweet South American treat!"
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "alfajores_full"
	filling_color = "#c48c4c"
	unitname = "alfajor"
	vendingobject = /obj/item/reagent_containers/food/snacks/alfajor
	trash = /obj/item/trash/plate
	reagents_to_add = list(/singleton/reagent/nutriment = 12)
	bitesize = 2
	reagent_data = list(/singleton/reagent/nutriment = list("dulce de leche" = 5, "vanilla cookie" = 5, "coconut" = 2))

/obj/item/reagent_containers/food/snacks/bowl/alfajores/update_icon()
	switch(reagents.total_volume)
		if(1 to 3)
			icon_state = "alfajores_one"
		if(4 to 6)
			icon_state = "alfajores_half"
		if(7 to INFINITY)
			icon_state = "alfajores_full"

/obj/item/reagent_containers/food/snacks/alfajor
	name = "alfajor"
	desc = "A plump south american sandwich cookie made out of two crumbly vanilla cookies, dulche de leche filling, and a coating of coconut shavings."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "alfajor"
	filling_color = "#dab166"

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

/obj/item/reagent_containers/food/snacks/pazillo
	name = "pazillo"
	desc = "A simple handheld pastry that originates from Assunzione, this is a calzone filled with a mixture of ground chickpeas, onions and tomatoes mixed together. It is sometimes served with olive oil, artichoke spread, or garlic sauce, but can also be eaten on it's own. It's tradtionally considered street food, but can occasionally be found in proper restaurants."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "pazillo"
	filling_color = "#5c802e"
	reagents_to_add = list(/singleton/reagent/nutriment/ = 8)
	bitesize = 2
	reagent_data = list(/singleton/reagent/nutriment = list("dough" = 5, "chickpeas" = 3, "onion" = 3, "tomato" = 3))


/obj/item/reagent_containers/food/snacks/pazillo/update_icon()
	var/percent_pazillo = round((reagents.total_volume / 8) * 100)
	switch(percent_pazillo)
		if(0 to 50)
			icon_state = "pazillo_small"
		if(51 to 95)
			icon_state = "pazillo_bitten"
		if(96 to INFINITY)
			icon_state = "pazillo"

//Luna

/obj/item/reagent_containers/food/snacks/traumwurst
	name = "traumwurst"
	desc = "Hearty pork sausages slathered with creamy eggplant sauce and served with a side of fried mushrooms, Traumwurst is served in many fine dining experiences across Luna, and one of very few dishes that can really be called Lunarian in origin. It was originally called Weltraumwurst (Space Sausage), but it was soon shortened to Traumwurst (Dream Sausage)."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "traumwurst"
	trash = /obj/item/trash/plate
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 7, /singleton/reagent/nutriment = 4)
	reagent_data = list(/singleton/reagent/nutriment/protein = list("pork" = 5), /singleton/reagent/nutriment = list("eggplant sauce" = 5, "fried mushrooms" = 4))
	bitesize = 3
	filling_color = "#daad84"

/obj/item/reagent_containers/food/snacks/traumwurst/update_icon()
	var/percent_traumwurst = round((reagents.total_volume / 10) * 100)
	switch(percent_traumwurst)
		if(0 to 49)
			icon_state = "traumwurst_half"
		if(50 to INFINITY)
			icon_state = "traumwurst"

// Xanu Prime
/obj/item/reagent_containers/food/snacks/steakxanu
	name = "steak xanu"
	desc = "The official dish of the city of Nouvelle-Rochelle, capital of the All-Xanu Republic. A piece of steak, marinated in a warm broth mixture before being pan-fried in ghee and spices and topped with a rich cream sauce."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "steakxanu"
	filling_color = "#dacb47"
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/nutriment/protein = 4, /singleton/reagent/spacespice = 2)
	bitesize = 3
	reagent_data = list(/singleton/reagent/nutriment = list("creamy sauce" = 2, "savory spices" = 2), /singleton/reagent/nutriment/protein = list("tender steak" = 6))

/obj/item/reagent_containers/food/snacks/xanu_curry
	name = "pataliputra curried rice"
	desc = "Xanu Prime's most enduring cultural export. A rice-and-peanut curry, made from a thick buttermilk-spice sauce, typically served with some sort of meat or seafood. The official dish of Pataliputra, though every cook has their own take on the true 'best' recipe for this particular curry."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "xanucurry"
	filling_color = "#dacb47"
	reagents_to_add = list(/singleton/reagent/nutriment = 8, /singleton/reagent/spacespice = 2)
	bitesize = 4
	reagent_data = list(/singleton/reagent/nutriment = list("rice" = 4, "rich spices" = 4))

/obj/item/reagent_containers/food/snacks/bunkerbuster
	name = "bunker buster sandwich"
	desc = "A renowned All-Xanu street food, the bunker buster is an open-faced egg sandwich with mustard, garam masala, mayo, and shredded cheese, served over naan bread. Born of necessity, it earned its name from the workers responsible for rebuilding Xanu Prime after the Interstellar War, who often bunked together in the underground complexes of Kshatragarh."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "bunkerbuster"
	filling_color = "#dacb47"
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/nutriment/protein/egg = 2, /singleton/reagent/spacespice = 2)
	bitesize = 3
	reagent_data = list(/singleton/reagent/nutriment = list("dijon mustard" = 2, "cheese" = 2, "fluffy bread" = 2))

/obj/item/reagent_containers/food/snacks/crozets
	name = "naya khyber crozets"
	desc = "The official dish of the Xanan city of Foy-Nijlen, this is typically a sort of buckwheat pasta served in a spicy tomato-basil sauce alongside the city's usual seafoods, like penguin or shellfish. Tradition dictates this to be served in a stoneware bowl, but it is often an accepted casualty of interstellar travel."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "crozets"
	bitesize = 2
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/nutriment/protein/seafood = 2, /singleton/reagent/spacespice = 2, )
	reagent_data = list(/singleton/reagent/nutriment = list("buckwheat pasta" = 3, "spicy tomato bisque" = 3))

/obj/item/reagent_containers/food/snacks/seafoodplatter
	name = "north sixty sea platter"
	desc = "While it lacks a traditional 'recipe', the North Sixty Sea Platter is a Xanan seafood platter focused on fresh, local seafood- fried, grilled, stewed, or raw- caught north of sixty degrees latitude. While there is no ocean on the Horizon, a faithful recreation of the famous side sauce can help adhere a few, more alien ingredients."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "seafoodplatter"
	reagents_to_add = list(/singleton/reagent/nutriment = 2, /singleton/reagent/nutriment/protein/seafood = 4, /singleton/reagent/nutriment/protein/seafood/mollusc = 4)
	bitesize = 2
	reagent_data = list(/singleton/reagent/nutriment = list("malted vinegar" = 1, "creamy garlic sauce" = 1))

/obj/item/reagent_containers/food/snacks/xanuvindaloo
	name = "paaskraan vindaloo"
	desc = "Traditionally made with the meat of the Paaskraan, a waterfowl native to Xanu Prime, this version uses chicken, instead. Unlike a typical vindaloo, paaskraani vindaloo only adds the meat at the end, after pan-frying it to a crunchy crisp in a sweet vanilla sauce. Served over rice, this is the official dish of Paastad."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "xanuvindaloo"
	bitesize = 2
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/nutriment/protein = 4, /singleton/reagent/spacespice = 2, )
	reagent_data = list(/singleton/reagent/nutriment = list("vanilla" = 2, "fresh herbs" = 2), /singleton/reagent/nutriment/protein = list("sweet-and-savory chicken" = 4))

// Himeo

/obj/item/reagent_containers/food/snacks/minerpie
	name = "miner's pie"
	desc = "A Himean traditional recipe, consisting mainly of mushrooms, meat, and gravy, served inside a crisp pastry crust. Could feed you for a thousand years."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "minerpie"
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/nutriment/protein = 4)
	bitesize = 3
	reagent_data = list(/singleton/reagent/nutriment = list("savory gravy" = 2, "vegetables" = 2, "pastry" = 2))

/obj/item/reagent_containers/food/snacks/hakhmaparm
	name = "hakhma parm hero"
	desc = "A fried hakhma cutlet, served on a toasted hoagie roll with cheese and tomato sauce. The unofficial sandwich of Horner Station."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "parmsandwich"
	filling_color = "#d47d2b"
	center_of_mass = list("x"=16, "y"=16)
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/nutriment/protein = 4)
	bitesize = 3
	reagent_data = list(/singleton/reagent/nutriment = list("cheese" = 3, "tomato sauce" = 3), /singleton/reagent/nutriment/protein = list("chicken" = 4))

/obj/item/reagent_containers/food/snacks/steelworkersandwich
	name = "steelworker's sandwich"
	desc = "Popular in the foundries of Rautakaivos Kaupunki, this is a helping of grilled meat buried under coleslaw, french fries, deli mustard, and pickled tomatoes, typically served on a mushroom roll."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "steelworkersandwich"
	filling_color = "#d47d2b"
	center_of_mass = list("x"=16, "y"=16)
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/nutriment/protein = 4)
	bitesize = 3
	reagent_data = list(/singleton/reagent/nutriment = list("mustard" = 2, "french fries" = 2, "coleslaw" = 2))

//Gadpathur

/obj/item/reagent_containers/food/snacks/paneer_gadpathur //Made to commemorate the most amazing dish from a place that closed down, RIP Captain Curry!
	name = "paneer gadpathur"
	desc = "A moderately spicy Gadpathurian curry made with large cubes of Paneer cheese, rice, sour cream, lentil daal and spicy sauces. Unlike Indian Paneer cheese, Gadpathurian Paneer is chewy, having an almost chicken-like texture. Traditionally the dish was made with a local plant called agnadi gola, but as it was rendered nearly extinct in the devestation from the interstellar war, the dish is now more commonly made with a mixture of hot peppers, tomato sauce and turmeric."
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "paneer"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#d47d2b"
	reagents_to_add = list(/singleton/reagent/nutriment = 10)
	bitesize = 2
	reagent_data = list(/singleton/reagent/nutriment = list("paneer cheese" = 5, "rice" = 5, "spices" = 5, "sour cream" = 3))

/obj/item/reagent_containers/food/snacks/paneer_gadpathur/update_icon()
	var/percent_lasagna_meat_slice = round((reagents.total_volume / 10) * 100)
	switch(percent_lasagna_meat_slice)
		if(0 to 69)
			icon_state = "paneer_half"
		if(70 to INFINITY)
			icon_state = "paneer"

//Galatea

/obj/item/reagent_containers/food/snacks/baked_golden_apple
	name = "baked golden apple"
	desc = "Shiny and glamorous, this genetically modified golden apple is stuffed with raisins, nuts, brown sugar, cinnamon, and topped with whipped cream. It is a shining star of Galatean cuisine and of hoity toity rich people around the spur. Contains real gold! Don't eat the cinnamon sticks they're there as a garnish."
	icon = 'icons/obj/item/reagent_containers/food/baked.dmi'
	icon_state = "baked_gold_apple"
	trash = /obj/item/trash/plate
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/gold = 5, /singleton/reagent/nutriment/glucose = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("fancyness" = 5, "apple" = 5, "raisins" = 3, "nuts" = 3))
	filling_color = "#ffba25"

/obj/item/reagent_containers/food/snacks/fire_loaf
	name = "fire loaf"
	desc = "A very spicy Galatean dish, traditionally made with synthmeat marinated in a special kelotane-infused mixture to give the dish it's strong color and help balance out the spicyness of the dish, as well as the chili peppers it is served with. Most cultures would just use dairy products to balance out a dish's spicyness. But most cultures aren't Galatea." //Does Kelotane even affect spicyness? Probably not. But it's good marketing.
	icon = 'icons/obj/item/reagent_containers/food/cultural/human.dmi'
	icon_state = "fireloaf"
	trash = /obj/item/trash/plate
	bitesize = 2
	filling_color = "#8f2106"
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 5, /singleton/reagent/kelotane = 3, /singleton/reagent/capsaicin = 5)
	reagent_data = list(/singleton/reagent/nutriment/protein = list("spicy meat" = 5, "chili" = 4, "onion" = 3, "unusual flavoring" = 3))

/obj/item/reagent_containers/food/snacks/fire_loaf/update_icon()
	var/expected_initial_reagent_volume
	for(var/k in src.reagents_to_add)
		expected_initial_reagent_volume += reagents_to_add[k]
	var/percent_fire_loaf = round((reagents.total_volume / expected_initial_reagent_volume) * 100)
	switch(percent_fire_loaf)
		if(0 to 49)
			icon_state = "fireloaf_half"
		if(50 to INFINITY)
			icon_state = "fireloaf"

/obj/item/reagent_containers/food/snacks/lortl
	name = "lortl"
	desc = "Dehydrated and salted q'lort slices, a very common Skrellian snack."
	icon = 'icons/obj/hydroponics_misc.dmi'
	filling_color = "#B7D6BF"
	bitesize = 2
	reagents_to_add = list(/singleton/reagent/nutriment = 2, /singleton/reagent/sodiumchloride = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("dried fruit" = 2))

/obj/item/reagent_containers/food/snacks/lortl/Initialize()
	. = ..()
	if(!GLOB.fruit_icon_cache["rind-#B1E4BE"])
		var/image/I = image(icon,"fruit_rind")
		I.color = "#B1E4BE"
		GLOB.fruit_icon_cache["rind-#B1E4BE"] = I
	AddOverlays(GLOB.fruit_icon_cache["rind-#B1E4BE"])
	if(!GLOB.fruit_icon_cache["slice-#B1E4BE"])
		var/image/I = image(icon,"fruit_slice")
		I.color = "#9FE4B0"
		GLOB.fruit_icon_cache["slice-#B1E4BE"] = I
	AddOverlays(GLOB.fruit_icon_cache["slice-#B1E4BE"])

/obj/item/reagent_containers/food/snacks/soup/qilvo
	name = "qilvo"
	desc = "Qilvo is a hot chowder made with algaes, sea grass, and mollusc meat. A beloved dish on Aliose."
	icon = 'icons/obj/item/reagent_containers/food/cultural/skrell.dmi'
	icon_state = "qilvo"
	filling_color = "#CFBA76"
	bitesize = 4
	reagents_to_add = list(/singleton/reagent/nutriment = 5, /singleton/reagent/nutriment/protein/seafood = 3, /singleton/reagent/water = 5, /singleton/reagent/drink/milk/cream = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("cream" = 3, "seaweed" = 2))

/obj/item/reagent_containers/food/snacks/soup/zantiri
	name = "zantiri"
	desc = "A soupy mush comprised of guami and eki, two plants native to Qerrbalak. In a bowl, it looks not unlike staring into a starry sky."
	icon = 'icons/obj/item/reagent_containers/food/cultural/skrell.dmi'
	icon_state = "zantiri"
	filling_color = "#141452"
	bitesize = 5
	reagents_to_add = list(/singleton/reagent/nutriment = 8, /singleton/reagent/water = 6)
	reagent_data = list(/singleton/reagent/nutriment = list("inky mush" = 5, "crunchy lichen" = 3))

/obj/item/reagent_containers/food/snacks/xuqqil
	name = "xuq'qil"
	desc = "A large mushroom cap stuffed with cheese and gnazillae. Originally from the Traverse, the recipe has been adapted for the enjoyment of Skrell with an appreciation for the flavors of human cuisine"
	icon = 'icons/obj/item/reagent_containers/food/cultural/skrell.dmi'
	icon_state = "xuqqil"
	filling_color = "#833D67"
	center_of_mass = list("x"=16, "y"=13)
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/nutriment/protein/cheese = 3, /singleton/reagent/nutriment/protein/seafood = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("mushroom" = 4))
	bitesize = 2

//Neaera food
/obj/item/reagent_containers/food/snacks/stew/neaera
	name = "neaera stew"
	desc = "Stew made from neaera meat. It is typically garnished with other foods such as guami, eki, or dyn depending on taste."
	icon = 'icons/obj/item/reagent_containers/food/cultural/skrell.dmi'
	icon_state = "neaera_stew"
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/nutriment/protein/seafood = 6, /singleton/reagent/drink/dynjuice = 4)
	reagent_data = list(/singleton/reagent/nutriment/protein/seafood = list("meaty mushroom" = 2))
	filling_color = "#7C66DD"

/obj/item/reagent_containers/food/snacks/neaerakabob
	name = "neaera-kabob"
	icon = 'icons/obj/item/reagent_containers/food/cultural/skrell.dmi'
	icon_state = "neaera_skewer"
	desc = "Neaera meat and organs that have been cooked on a skewer. Typical street vendor food in the Nralakk Federation."
	trash = /obj/item/stack/rods
	reagents_to_add = list(/singleton/reagent/nutriment/protein/seafood = 8)
	reagent_data = list(/singleton/reagent/nutriment/protein/seafood = list("fatty meat" = 2))
	filling_color = "#7C66DD"
	center_of_mass = list("x"=17, "y"=15)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/neaeraloaf
	name = "neaera brain loaf"
	icon = 'icons/obj/item/reagent_containers/food/cultural/skrell.dmi'
	icon_state = "neaera_brain_loaf"
	desc = "A neaera brain baked in the oven and glazed with cream. Has a similar consistency to yogurt."
	trash = /obj/item/trash/tray
	reagents_to_add = list(/singleton/reagent/nutriment/protein/seafood = 6, /singleton/reagent/nutriment/triglyceride = 2, /singleton/reagent/drink/milk/cream = 2)
	reagent_data = list(/singleton/reagent/nutriment/protein/seafood = list("creamy, sweet meat" = 6))
	filling_color = "#7C66DD"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/neaeraloaf/update_icon()
	var/percent = round((reagents.total_volume / 10) * 100)
	switch(percent)
		if(0 to 50)
			icon_state = "neaera_brain_loaf_half"
		if(51 to INFINITY)
			icon_state = "neaera_brain_loaf"

/obj/item/reagent_containers/food/snacks/chipplate/neaeracandy
	name = "plate of candied neaera eyes"
	desc = "Candied neaera eyes shaped into cubes. The mix of savoury and sweet is generally acceptable for most species, although the dish is not commonly liked due to the use of eyes."
	icon = 'icons/obj/item/reagent_containers/food/cultural/skrell.dmi'
	icon_state = "neaera_candied_eyes20"
	trash = /obj/item/trash/candybowl
	vendingobject = /obj/item/reagent_containers/food/snacks/neaeracandy
	reagent_data = list(/singleton/reagent/nutriment = list("creamy, fatty meat" = 1))
	bitesize = 1
	reagents_to_add = list(/singleton/reagent/nutriment/protein/seafood = 20)
	unitname = "candied eye"
	filling_color = "#7C66DD"

/obj/item/reagent_containers/food/snacks/chipplate/neaeracandy/update_icon()
	switch(reagents.total_volume)
		if(1)
			icon_state = "neaera_candied_eyes1"
		if(2 to 5)
			icon_state = "neaera_candied_eyes5"
		if(6 to 10)
			icon_state = "neaera_candied_eyes10"
		if(11 to 15)
			icon_state = "neaera_candied_eyes15"
		if(20 to INFINITY)
			icon_state = "neaera_candied_eyes20"

/obj/item/reagent_containers/food/snacks/neaeracandy
	name = "candied neaera eye"
	desc = "A candied neaera eye shaped into a cube. The mix of savoury and sweet is generally acceptable for most species, although the dish is not commonly liked due to the use of eyes."
	icon = 'icons/obj/item/reagent_containers/food/cultural/skrell.dmi'
	icon_state = "neaera_candied_eye"
	reagents_to_add = list(/singleton/reagent/nutriment/protein/seafood = 1)
	reagent_data = list(/singleton/reagent/nutriment/protein/seafood = list("creamy, fatty meat" = 3))
	bitesize = 1
	filling_color = "#7C66DD"

/obj/item/reagent_containers/food/snacks/fjylozynboiled
	name = "boiled fjylozyn"
	desc = "Originating from Fjylo, this red seaweed-like vegetable is a primary source of protein for Skrell who don't eat meat. It is typically boiled, and while it can be eaten on its own, is notably one of the main ingredients in gnaqmi."
	icon = 'icons/obj/item/reagent_containers/food/cultural/skrell.dmi'
	icon_state = "fjylozyn_boiled"
	reagents_to_add = list(/singleton/reagent/nutriment = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("sweet turnips" = 3))
	bitesize = 2
	filling_color = "#7C66DD"

/obj/item/reagent_containers/food/snacks/gnaqmi
	name = "gnaqmi"
	desc = "Fried neaera organs stuffed with boiled fjylozyn. It tastes like sweet turnips and meat, and is usually served as an after dinner snack to round off the evening at Skrell gatherings."
	icon = 'icons/obj/item/reagent_containers/food/cultural/skrell.dmi'
	icon_state = "gnaqmi"
	reagents_to_add = list(/singleton/reagent/nutriment/protein/seafood = 4, /singleton/reagent/nutriment = 8)
	reagent_data = list(/singleton/reagent/nutriment/protein/seafood = list("fatty meat" = 4), /singleton/reagent/nutriment = list("sweet turnips" = 4))
	bitesize = 3
	filling_color = "#7C66DD"

/obj/item/reagent_containers/food/snacks/jyalrafresh
	name = "jyalra"
	desc = "Dyn leaves peeled and mashed into a savoury puree."
	desc_extended = "Jyalra is created by peeling and mashing dyn until it becomes a thick blue puree. Unlike the fruit, it has a dry, savoury flavour to it. While used as a meal replacement by busy scientists, it is considered junk food by the Skrell and is eaten more as a snack than a proper meal."
	icon = 'icons/obj/item/reagent_containers/food/cultural/skrell.dmi'
	icon_state = "jyalrafresh"
	filling_color = "#321b85"
	reagents_to_add = list(/singleton/reagent/nutriment = 10, /singleton/reagent/drink/dynjuice = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("dry mush" = 2, "something savoury" = 4))
	bitesize = 2
	trash = /obj/item/trash/plate

/obj/item/reagent_containers/food/snacks/qlguabi
	name = "qlguabi"
	desc = "An old dish from Aweji's terraforming days, made by blending a large amount of Guami fruit with Dyn juice into a gelatin-like concotion, traditionally with a sweet, hardened Dyn syrup drizzled on top. You will find many booths selling it at the Aweijiin Bazaar. Despite being considered a sweet side dish in Skrell culture, in other cultures it is often considered a dessert due it's sweet and light nature."
	icon = 'icons/obj/item/reagent_containers/food/cultural/skrell.dmi'
	icon_state = "qlguabi"
	trash = /obj/item/trash/plate
	filling_color = "#97eaff7a"
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/gelatin = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("sweetened mint" = 5))

/obj/item/reagent_containers/food/snacks/konaqu
	name = "konaqu"
	desc = "Literally translating to 'whirpool orb', konaqu are popular pastry-like confections beloved among Nralakk youth. They tend to be soft and gooey underwater, or soft and brittle when dry. When served on dry land, they are often served with a small bowl or glass of water or milk to give people the option of dunking them."
	icon = 'icons/obj/item/reagent_containers/food/cultural/skrell.dmi'
	icon_state = "konaqu1"
	filling_color = "#64e3faff"
	reagents_to_add = list(/singleton/reagent/nutriment = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("fruity dough" = 5, "sweetness" = 5))

/obj/item/reagent_containers/food/snacks/konaqu/Initialize()
	. = ..()
	var/shape = pick("konaqu1", "konaqu2")
	icon = 'icons/obj/item/reagent_containers/food/cultural/skrell.dmi'
	src.icon_state = "[shape]"

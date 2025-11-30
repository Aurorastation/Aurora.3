/obj/item/reagent_containers/food/snacks/fries
	name = "space fries"
	desc = "AKA: French Fries, Freedom Fries, etc."
	icon = 'icons/obj/item/reagent_containers/food/fryer.dmi'
	icon_state = "fries"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/nutriment/triglyceride/oil = 1.2)
	reagent_data = list(/singleton/reagent/nutriment = list("fresh fries" = 4))
	bitesize = 2//This is mainly for the benefit of adminspawning

///makes fries gain the visual look of whatever sauce you add to them
/obj/item/reagent_containers/food/snacks/fries/on_reagent_change()

	if(reagents.has_any_reagent(list(/singleton/reagent/nutriment/flour, /singleton/reagent/spacecleaner, /singleton/reagent/antidexafen, /singleton/reagent/carbon))) //For when the scrubbers inevitably attack the kitchen.
		name = "ruined fries"
		desc = "A tragic, innocent casualty in the war against scrubbers."
		icon_state = "fries_ruined"

	else if(reagents.has_reagent(/singleton/reagent/nutriment/ketchup))
		name = "fries with ketchup"
		desc = "A classic."
		icon_state = "fries_redsauce"

	else if(reagents.has_reagent(/singleton/reagent/nutriment/mayonnaise))
		name = "fries with mayonnaise"
		desc = "A European classic."
		icon_state = "fries_whitesauce"

	else if(reagents.has_reagent(/singleton/reagent/nutriment/garlicsauce))
		name = "fries with garlic sauce"
		desc = "Delicious! Just... Don't breathe in anyone's direction for a while after eating them."
		icon_state = "fries_garlicsauce"

	else if(reagents.has_reagent(/singleton/reagent/condiment/syrup_chocolate))
		name = "fries with chocolate sauce"
		desc = "Someone has a case of the munchies."
		icon_state = "fries_brownsauce"

	else if(reagents.has_reagent(/singleton/reagent/nutriment/barbecue))
		name = "fries with barbecue sauce"
		desc = "As you stare deep into this plate of fries, somewhere in the distance you think you hear a faint 'yee haw'."
		icon_state = "fries_brownsauce"

	else if(reagents.has_reagent(/singleton/reagent/nutriment/sweet_chili))
		name = "fries with sweet chili sauce"
		desc = "A plate of fries giving off those mid-tier mall food court vibes."
		icon_state = "fries_redsauce"

/obj/item/reagent_containers/food/snacks/microchips
	name = "micro chips"
	desc = "Soft and rubbery. Should have fried them."
	icon = 'icons/obj/item/reagent_containers/food/fryer.dmi'
	icon_state = "microchips"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("fresh fries" = 4))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/ovenchips
	name = "oven chips"
	desc = "Dark and crispy, but a bit dry"
	icon = 'icons/obj/item/reagent_containers/food/fryer.dmi'
	icon_state = "ovenchips"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("fresh fries" = 4))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/cheesyfries
	name = "cheesy fries"
	desc = "Fries. Covered in cheese. Duh."
	icon = 'icons/obj/item/reagent_containers/food/fryer.dmi'
	icon_state = "cheesyfries"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/nutriment/protein/cheese = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("fresh fries" = 3))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/chilicheesefries
	name = "chili cheese fries"
	gender = PLURAL
	desc = "A mighty plate of fries, drowned in hot chili and cheese sauce. Because your arteries are overrated."
	icon = 'icons/obj/item/reagent_containers/food/fryer.dmi'
	icon_state = "chilicheesefries"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	center_of_mass = list("x"=18, "y"=14)
	reagents_to_add = list(/singleton/reagent/nutriment = 8, /singleton/reagent/nutriment/protein = 2, /singleton/reagent/capsaicin = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("fresh fries" = 4, "cheese" = 2, "chili peppers" = 2))
	bitesize = 4

/obj/item/reagent_containers/food/snacks/jalapeno_poppers
	name = "jalapeno popper"
	desc = "A battered, deep-fried chili pepper"
	icon = 'icons/obj/item/reagent_containers/food/fryer.dmi'
	icon_state = "popper"
	filling_color = "#00AA00"
	do_coating_prefix = 0

	reagents_to_add = list(/singleton/reagent/nutriment = 2, /singleton/reagent/nutriment/coating/batter = 2, /singleton/reagent/nutriment/triglyceride/oil = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("chili pepper" = 2))
	bitesize = 1
	coating = /singleton/reagent/nutriment/coating/batter

/obj/item/reagent_containers/food/snacks/friedmushroom
	name = "fried mushroom"
	desc = "A tender, beer-battered plump helmet, fried to crispy perfection."
	icon = 'icons/obj/item/reagent_containers/food/fryer.dmi'
	icon_state = "friedmushroom"
	filling_color = "#EDDD00"
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/nutriment/protein = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("fried mushroom" = 4))
	bitesize = 5

/obj/item/reagent_containers/food/snacks/risottoballs
	name = "risotto balls"
	gender = PLURAL
	desc = "Mushroom risotto that has been battered and deep fried. The best use of leftovers!"
	icon = 'icons/obj/item/reagent_containers/food/fryer.dmi'
	icon_state = "risottoballs"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#edd7d7"
	center_of_mass = list("x"=15, "y"=9)
	reagents_to_add = list(/singleton/reagent/nutriment = 2, /singleton/reagent/sodiumchloride = 1, /singleton/reagent/blackpepper = 1, /singleton/reagent/nutriment/rice = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("spices" = 2, "mushroom" = 2))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/onionrings
	name = "onion rings"
	desc = "Like circular fries but better."
	icon = 'icons/obj/item/reagent_containers/food/fryer.dmi'
	icon_state = "onionrings"
	trash = /obj/item/trash/plate
	filling_color = "#eddd00"
	center_of_mass = "x=16;y=11"
	reagents_to_add = list(/singleton/reagent/nutriment = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("fried onions" = 5))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sweet_and_sour
	name = "sweet and sour pork"
	desc = "A traditional ancient sol recipie with a few liberties taken with meat selection."
	icon = 'icons/obj/item/reagent_containers/food/fryer.dmi'
	icon_state = "sweet_and_sour"
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/nutriment/protein = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("sweet and sour" = 6))
	trash = /obj/item/trash/plate
	filling_color = "#FC5647"


/obj/item/reagent_containers/food/snacks/wingfangchu
	name = "wing fang chu"
	desc = "A savory dish of alien wing wang in soy."
	icon = 'icons/obj/item/reagent_containers/food/fryer.dmi'
	icon_state = "wingfangchu"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#43DE18"
	center_of_mass = list("x"=17, "y"=9)
	bitesize = 2

	reagents_to_add = list(/singleton/reagent/nutriment/protein = 6)

/obj/item/reagent_containers/food/snacks/roefritters
	name = "roe fritters"
	desc = "Fried patties made from fish eggs."
	icon = 'icons/obj/item/reagent_containers/food/fryer.dmi'
	icon_state = "fritters"
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/coating/batter = 5, /singleton/reagent/nutriment/protein/seafood = 6)
	reagent_data = list(/singleton/reagent/nutriment = list("brine" = 3, "fish" = 3))
	bitesize = 6
	trash = /obj/item/trash/plate

//Fishy Recipes
//==================
/obj/item/reagent_containers/food/snacks/fishandchips
	name = "fish and chips"
	desc = "I do say so myself chap."
	icon = 'icons/obj/item/reagent_containers/food/fryer.dmi'
	icon_state = "fishandchips"
	filling_color = "#E3D796"
	center_of_mass = list("x"=16, "y"=16)
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/protein/seafood = 7)
	reagent_data = list(/singleton/reagent/nutriment = list("salt" = 1, "chips" = 3))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/cubancarp
	name = "cuban fish sandwich"
	desc = "A sandwich that burns your tongue and then leaves it numb!"
	icon = 'icons/obj/item/reagent_containers/food/fryer.dmi'
	icon_state = "cubancarp"
	trash = /obj/item/trash/plate
	filling_color = "#E9ADFF"
	center_of_mass = list("x"=12, "y"=5)
	bitesize = 3
	reagents_to_add = list(/singleton/reagent/nutriment/protein/seafood = 3, /singleton/reagent/nutriment = 3, /singleton/reagent/capsaicin = 3)


/obj/item/reagent_containers/food/snacks/fishfingers
	name = "fish fingers"
	desc = "A finger of fish."
	icon = 'icons/obj/item/reagent_containers/food/fryer.dmi'
	icon_state = "fishfingers"
	filling_color = "#FFDEFE"
	bitesize = 3
	reagents_to_add = list(/singleton/reagent/nutriment/protein/seafood = 7)


/obj/item/reagent_containers/food/snacks/donut
	name = "donut"
	desc = "Goes great with Robust Coffee."
	icon = 'icons/obj/item/reagent_containers/food/fryer.dmi'
	icon_state = "donut1"
	item_state = "donut1"
	filling_color = "#D9C386"
	overlay_state = "box-donut1"
	reagent_data = list(/singleton/reagent/nutriment = list("sweetness" = 1, "donut" = 2))

/obj/item/reagent_containers/food/snacks/donut/normal
	name = "donut"
	desc = "Goes great with Robust Coffee."
	icon = 'icons/obj/item/reagent_containers/food/fryer.dmi'
	icon_state = "donut1"
	reagents_to_add = list(/singleton/reagent/nutriment = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("sweetness" = 1, "donut" = 2))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/donut/normal/psdonut
	name = "pumpkin spice donut"
	desc = "A limited edition seasonal pastry."
	icon = 'icons/obj/item/reagent_containers/food/fryer.dmi'
	icon_state = "donut_ps"
	reagent_data = list(/singleton/reagent/nutriment = list("pumpkin spice" = 1, "donut" = 2))

	reagents_to_add = list(/singleton/reagent/nutriment/sprinkles = 1)

/obj/item/reagent_containers/food/snacks/donut/normal/Initialize()
	. = ..()
	if(prob(30))
		src.icon_state = "donut2"
		src.item_state = "donut2"
		src.overlay_state = "box-donut2"
		src.name = "frosted donut"
		reagents.add_reagent(/singleton/reagent/nutriment/sprinkles, 2)

/obj/item/reagent_containers/food/snacks/donut/chaos
	name = "chaos donut"
	desc = "Like life, it never quite tastes the same."
	icon = 'icons/obj/item/reagent_containers/food/fryer.dmi'
	icon_state = "donut1"
	item_state = "donut1"
	filling_color = "#ED11E6"
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment = 5, /singleton/reagent/nutriment/sprinkles = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("sweetness" = 1, "donut" = 2))
	bitesize = 10

/obj/item/reagent_containers/food/snacks/donut/chaos/Initialize()
	. = ..()
	var/chaosselect = pick(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
	switch(chaosselect)
		if(1)
			reagents.add_reagent(/singleton/reagent/nutriment, 3)
		if(2)
			reagents.add_reagent(/singleton/reagent/capsaicin, 3)
		if(3)
			reagents.add_reagent(/singleton/reagent/frostoil, 3)
		if(4)
			reagents.add_reagent(/singleton/reagent/nutriment/sprinkles, 3)
		if(5)
			reagents.add_reagent(/singleton/reagent/toxin/phoron, 3)
		if(6)
			reagents.add_reagent(/singleton/reagent/nutriment/coco, 3)
		if(7)
			reagents.add_reagent(/singleton/reagent/slimejelly, 3)
		if(8)
			reagents.add_reagent(/singleton/reagent/drink/banana, 3)
		if(9)
			reagents.add_reagent(/singleton/reagent/drink/berryjuice, 3)
		if(10)
			reagents.add_reagent(/singleton/reagent/tricordrazine, 3)
	if(prob(30))
		src.icon_state = "donut2"
		src.overlay_state = "box-donut2"
		src.name = "Frosted Chaos Donut"
		reagents.add_reagent(/singleton/reagent/nutriment/sprinkles, 2)

/obj/item/reagent_containers/food/snacks/donut/jelly
	name = "jelly donut"
	desc = "You jelly?"
	icon = 'icons/obj/item/reagent_containers/food/fryer.dmi'
	icon_state = "jdonut1"
	filling_color = "#ED1169"
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/sprinkles = 1, /singleton/reagent/drink/berryjuice = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("sweetness" = 1, "donut" = 2))
	bitesize = 5

/obj/item/reagent_containers/food/snacks/donut/jelly/Initialize()
	. = ..()
	if(prob(30))
		src.icon_state = "jdonut2"
		src.overlay_state = "box-donut2"
		src.name = "Frosted Jelly Donut"
		reagents.add_reagent(/singleton/reagent/nutriment/sprinkles, 2)

/obj/item/reagent_containers/food/snacks/donut/slimejelly
	name = "jelly donut"
	desc = "You jelly?"
	icon = 'icons/obj/item/reagent_containers/food/fryer.dmi'
	icon_state = "jdonut1"
	filling_color = "#ED1169"
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/sprinkles = 1, /singleton/reagent/slimejelly = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("sweetness" = 1, "donut" = 2))
	bitesize = 5

/obj/item/reagent_containers/food/snacks/donut/slimejelly/Initialize()
	. = ..()
	if(prob(30))
		src.icon_state = "jdonut2"
		src.overlay_state = "box-donut2"
		src.name = "Frosted Jelly Donut"
		reagents.add_reagent(/singleton/reagent/nutriment/sprinkles, 2)

/obj/item/reagent_containers/food/snacks/donut/cherryjelly
	name = "jelly donut"
	desc = "You jelly?"
	icon = 'icons/obj/item/reagent_containers/food/fryer.dmi'
	icon_state = "jdonut1"
	filling_color = "#ED1169"
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/sprinkles = 1, /singleton/reagent/nutriment/cherryjelly = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("sweetness" = 1, "donut" = 2))
	bitesize = 5

/obj/item/reagent_containers/food/snacks/donut/cherryjelly/Initialize()
	. = ..()
	if(prob(30))
		src.icon_state = "jdonut2"
		src.overlay_state = "box-donut2"
		src.name = "Frosted Jelly Donut"
		reagents.add_reagent(/singleton/reagent/nutriment/sprinkles, 2)

/obj/item/reagent_containers/food/snacks/pisanggoreng
	name = "pisang goreng"
	gender = PLURAL
	desc = "Crispy, starchy, sweet banana fritters. Popular street food in parts of Sol."
	icon = 'icons/obj/item/reagent_containers/food/fryer.dmi'
	icon_state = "pisanggoreng"
	trash = /obj/item/trash/plate
	filling_color = "#301301"
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 8)
	reagent_data = list(/singleton/reagent/nutriment = list("fried bananas" = 4))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/funnelcake
	name = "funnel cake"
	desc = "Funnel cakes rule!"
	icon = 'icons/obj/item/reagent_containers/food/fryer.dmi'
	icon_state = "funnelcake"
	filling_color = "#Ef1479"
	do_coating_prefix = 0
	bitesize = 2
	reagents_to_add = list(/singleton/reagent/nutriment/coating/batter = 10, /singleton/reagent/sugar = 5)

/obj/item/reagent_containers/food/snacks/corn_dog
	name = "corn dog"
	desc = "A cornbread covered sausage deepfried in oil."
	icon = 'icons/obj/item/reagent_containers/food/fryer.dmi'
	icon_state = "corndog"
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/nutriment/protein = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("corn batter" = 4))
	filling_color = "#FFF97D"



/obj/item/reagent_containers/food/snacks/chickenkatsu
	name = "chicken katsu"
	desc = "A terran delicacy consisting of chicken fried in a light beer batter"
	icon = 'icons/obj/item/reagent_containers/food/fryer.dmi'
	icon_state = "katsu"
	trash = /obj/item/trash/plate
	filling_color = "#E9ADFF"
	center_of_mass = list("x"=16, "y"=16)
	do_coating_prefix = 0
	bitesize = 1.5
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 6, /singleton/reagent/nutriment/coating/beerbatter = 2, /singleton/reagent/nutriment/triglyceride/oil = 1)

//Squiddle dee dee it's time to use that squid meat
/obj/item/reagent_containers/food/snacks/north60squid
	name = "north 60 squid"
	desc = "Xanan dish, Crunchy squid with a side of shrimp, swimming in a pool of garlic sauce. You'll often hear friendly arguments around Himavat City about which bar serves the best version of this."
	icon = 'icons/obj/item/reagent_containers/food/fryer.dmi'
	icon_state = "north60squid"
	trash = /obj/item/trash/north60squidempty
	filling_color = "#c79e77"
	reagents_to_add = list(/singleton/reagent/nutriment/protein/seafood = 4, /singleton/reagent/nutriment = 1, /singleton/reagent/nutriment/garlicsauce = 3)
	reagent_data = list(/singleton/reagent/nutriment/protein/seafood = list("crunchy seafood" = 10), /singleton/reagent/nutriment = list("apple" = 5, "lemon" = 5), /singleton/reagent/nutriment/garlicsauce = list("garlic sauce" = 10))
	drop_sound = 'sound/items/drop/bottle.ogg'
	pickup_sound = 'sound/items/pickup/bottle.ogg'


/obj/item/reagent_containers/food/snacks/north60squid/update_icon()
	var/percent_north60squid = round((reagents.total_volume / 6) * 100)
	switch(percent_north60squid)
		if(0 to 70)
			icon_state = "north60squidhalf"
		if(71 to INFINITY)
			icon_state = "north60squid"

/obj/item/reagent_containers/food/snacks/falafelballs
	name = "falafel balls"
	desc = "A middle eastern dish also popular in Elyra, these crunchy fried chickpea balls are often served as a side to a dish of Hummus, in a Pita, or some sort of wrap."
	icon = 'icons/obj/item/reagent_containers/food/fryer.dmi'
	icon_state = "falafelballs"
	trash = /obj/item/trash/plate
	filling_color = "#74812c"
	reagents_to_add = list(/singleton/reagent/nutriment = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("fried chickpeas" = 3))

/obj/item/reagent_containers/food/snacks/fries_olympia_with_cheese
	name = "fries olympia with cheese"
	gender = PLURAL
	desc = "A simple Martian street food dish of crispy spiral-cut potatoes that are cut in two, deep fried, coated in paprika, and optionally covered in molten cheese. This is the cheesy version! It is sometimes called 'Chips Olympia', especially after 'Fries Olympia' became the punch line to a bunch of dark jokes about Violet Dawn."
	icon = 'icons/obj/item/reagent_containers/food/fryer.dmi'
	icon_state = "fries_olympia_cheesy"
	filling_color = "#c0871d"
	bitesize = 3
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/nutriment/triglyceride/oil = 1.2, /singleton/reagent/capsaicin = 2, /singleton/reagent/nutriment/protein/cheese = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("crispy potato" = 5), /singleton/reagent/capsaicin = list("paprika" = 5))

/obj/item/reagent_containers/food/snacks/fries_olympia
	name = "fries olympia"
	gender = PLURAL
	desc = "A simple Martian street food dish of crispy spiral-cut potatoes that are cut in two, deep fried, coated in paprika, and optionally covered in molten cheese. This is the non-cheesy version! It is sometimes called 'Chips Olympia', especially after 'Fries Olympia' became the punch line to a bunch of dark jokes about Violet Dawn."
	icon = 'icons/obj/item/reagent_containers/food/fryer.dmi'
	icon_state = "fries_olympia_no_cheese"
	filling_color = "#c0871d"
	bitesize = 3
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/nutriment/triglyceride/oil = 1.2, /singleton/reagent/capsaicin = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("crispy potato" = 5), /singleton/reagent/capsaicin = list("paprika" = 5))

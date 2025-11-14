//Baked sweets:
//---------------
// Convention follows recipies. Should be in the same order as the recipie file for sanity reasons

////////////////////////////////////////////MUFFINS////////////////////////////////////////////
/obj/item/reagent_containers/food/snacks/muffin
	name = "muffin"
	desc = "A delicious and spongy little cake."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "muffin"
	filling_color = "#E0CF9B"
	reagents_to_add = list(/singleton/reagent/nutriment = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("sweetness" = 3, "muffin" = 3))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/muffin/berry
	name = "berry muffin"
	desc = "A delicious and spongy little cake, with berries."
	icon_state = "muffin_berry"
	reagent_data = list(/singleton/reagent/nutriment = list("sweetness" = 1, "muffin" = 2, "berries" = 2))

/obj/item/reagent_containers/food/snacks/muffin/chocolate
	name = "chocolate muffin"
	desc = "A delicious and spongy little cake, with chocolate chips."
	icon_state = "muffin_chocolate"
	reagent_data = list(/singleton/reagent/nutriment = list("sweetness" = 1, "muffin" = 2, "chocolate" = 2))

/obj/item/reagent_containers/food/snacks/muffin/whitechocolate
	name = "white chocolate muffin"
	desc = "A delicious and spongy little cake, with white chocolate chips."
	icon_state = "muffin_whitechocolate"
	reagent_data = list(/singleton/reagent/nutriment = list("sweetness" = 1, "muffin" = 2, "white chocolate" = 2))

/obj/item/reagent_containers/food/snacks/muffin/cheese
	name = "cheese muffin"
	desc = "A delicious and spongy little cake, with cheese."
	icon_state = "muffin_cheese"
	reagent_data = list(/singleton/reagent/nutriment = list("sweetness" = 1, "muffin" = 2, "cheese" = 2))

/obj/item/reagent_containers/food/snacks/muffin/butter
	name = "butter muffin"
	desc = "A delicious, buttery and soft little cake."
	icon_state = "muffin_butter"
	reagent_data = list(/singleton/reagent/nutriment = list("sweetness" = 1, "muffin" = 2, "butter" = 2))

/obj/item/reagent_containers/food/snacks/muffin/raisin
	name = "raisin muffin"
	desc = "A delicious and spongy little cake, with raisins."
	icon_state = "muffin_raisin"
	reagent_data = list(/singleton/reagent/nutriment = list("sweetness" = 1, "muffin" = 2, "raisins" = 2))

/obj/item/reagent_containers/food/snacks/muffin/meat
	name = "meat muffin"
	desc = "A delicious and spongy little cake, with meat."
	icon_state = "muffin_meat"
	reagent_data = list(/singleton/reagent/nutriment = list("sweetness" = 1, "muffin" = 2, "meat" = 2))

////////////////////////////////////////////PANCAKES////////////////////////////////////////////

/obj/item/reagent_containers/food/snacks/pancakes
	name = "pancakes"
	gender = PLURAL
	desc = "Pancakes, delicious."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "pancakes"
	trash = /obj/item/trash/plate
	reagents_to_add = list(/singleton/reagent/nutriment = 8)
	reagent_data = list(/singleton/reagent/nutriment = list("pancake" = 8))
	bitesize = 3
	filling_color = "#facf7e"

///makes pancakes change their look and name, flavor and description when you add syrup to them instead of having to have them each be an entirely separate food item that has to be made by the cook. This also means ingredient contents carry over if you turn one type of pancake into another.
/obj/item/reagent_containers/food/snacks/pancakes/on_reagent_change()
	if(reagents.has_reagent(/singleton/reagent/condiment/syrup_chocolate))
		name = "chocolate pancakes"
		desc = "Delicious pancakes covered in chocolate syrup."
		icon_state = "pancakes_chocolate"

	if(reagents.has_reagent(/singleton/reagent/condiment/syrup_berry))
		name = "berry pancakes"
		desc = "Delicious pancakes covered in berry syrup."
		icon_state = "pancakes_berry"

	if(reagents.has_reagent(/singleton/reagent/condiment/syrup_strawberry))
		name = "strawberry pancakes"
		desc = "Delicious pancakes covered in strawberry syrup."
		icon_state = "pancakes_strawberry"

	if(reagents.has_reagent(/singleton/reagent/condiment/syrup_caramel))
		name = "caramel pancakes"
		desc = "Delicious pancakes covered in caramel syrup."
		icon_state = "pancakes_caramel"

	if(reagents.has_reagent(/singleton/reagent/condiment/syrup_vanilla))
		name = "vanilla pancakes"
		desc = "Delicious pancakes covered in vanilla syrup."
		icon_state = "pancakes_vanilla"

	if(reagents.has_reagent(/singleton/reagent/condiment/syrup_pumpkin))
		name = "pumpkin spice pancakes"
		desc = "A delicious autumn breakfast."
		icon_state = "pancakes_pumpkin"

	if(reagents.has_reagent(/singleton/reagent/condiment/syrup_ylphaberry))
		name = "ylpha berry pancakes"
		desc = "Overwhelmingly sweet with a side of tangy, a delicious way to wake up!"
		icon_state = "pancakes_ylpha"

	if(reagents.has_any_reagent(list(/singleton/reagent/nutriment/ketchup, /singleton/reagent/nutriment/mayonnaise, /singleton/reagent/antidexafen, /singleton/reagent/carbon))) //Because scrubbers and quirky people exist.
		name = "ruined pancakes"
		desc = "Why? Who hurt you?"
		icon_state = "pancakes_ruined"

	if(reagents.has_reagent(/singleton/reagent/condiment/syrup_blueberry))
		name = "blueberry pancakes"
		desc = "They're a little... TOO neon blue, aren't they? Doesn't look right... Oh well, they're full of sugar so who cares!"
		icon_state = "pancakes_blueberry"

	if(reagents.has_reagent(/singleton/reagent/condiment/syrup_raspberry))
		name = "raspberry pancakes"
		desc = "Your inner 12-year-old-girl-having-a-birthday party is squealing with overwhelming glee the longer you look at this."
		icon_state = "pancakes_raspberry"

	if(reagents.has_reagent(/singleton/reagent/condiment/syrup_blueraspberry))
		name = "blue raspberry pancakes"
		desc = "Delicious pancakes covered in blue raspberry syrup."
		icon_state = "pancakes_blue_raspberry"

	if(reagents.has_reagent(/singleton/reagent/condiment/syrup_dirtberry))
		name = "nifnif pancakes"
		desc = "Dirtberry pancakes with little bits of roasted nifnif for extra crunch! It may not be traditional adhomian cuisine but it sure is popular there now anyway!"
		icon_state = "pancakes_nifnif"

/obj/item/reagent_containers/food/snacks/pancakes/berry
	name = "berry pancakes"
	desc = "Pancakes with berries, delicious."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "pancakes_berry"

////////////////////////////////////////////WAFFLES////////////////////////////////////////////

/obj/item/reagent_containers/food/snacks/waffles
	name = "waffles"
	desc = "Mmm, waffles."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "waffles"
	trash = /obj/item/trash/waffles
	drop_sound = /singleton/sound_category/tray_hit_sound
	filling_color = "#E6DEB5"
	center_of_mass = list("x"=15, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 8)
	reagent_data = list(/singleton/reagent/nutriment = list("waffle" = 8))
	bitesize = 2

///makes waffles change their look based on which syrup they have applied to them
/obj/item/reagent_containers/food/snacks/waffles/on_reagent_change()
	if(reagents.has_any_reagent(list(/singleton/reagent/nutriment/flour, /singleton/reagent/spacecleaner, /singleton/reagent/antidexafen, /singleton/reagent/carbon))) //For when the scrubbers inevitably attack the kitchen.
		name = "ruined waffles"
		desc = "Oh boy! Look at all that powdered suga- wait, wait, no, that's... no, that's not sugar. Oh, these poor waffles."
		icon_state = "waffles_ruined"

	else if(reagents.has_reagent(/singleton/reagent/nutriment/ketchup))
		name = "waffles with ketchup"
		desc = "Why? Just why?"
		icon_state = "waffles_redsauce"

	else if(reagents.has_reagent(/singleton/reagent/nutriment/mayonnaise))
		name = "waffles with mayonnaise"
		desc = "All of the cholesterol with none of the joy."
		icon_state = "waffles_vanilla"

	else if(reagents.has_reagent(/singleton/reagent/condiment/syrup_chocolate))
		name = "waffles with chocolate sauce"
		desc = "Mmm, waffles with chocolate sauce."
		icon_state = "waffles_chocolate"

		if(reagents.has_reagent(/singleton/reagent/condiment/syrup_vanilla))
			name = "checkerboard waffles"
			desc = "Waffles with chocolate and vanilla sauces carefully applied in a checkerboard pattern. Extremely fancy, in a 12 year old birthday party kind of way."
			icon_state = "waffles_checkers"

	else if(reagents.has_reagent(/singleton/reagent/condiment/syrup_vanilla))
		name = "Mmm, waffles with vanilla sauce."
		icon_state = "waffles_vanilla"

		if(reagents.has_reagent(/singleton/reagent/condiment/syrup_chocolate))
			name = "checkerboard waffles"
			desc = "Waffles with chocolate and vanilla sauces carefully applied in a checkerboard pattern. Extremely fancy, in a 12 year old birthday party kind of way."
			icon_state = "waffles_checkers"

	else if(reagents.has_reagent(/singleton/reagent/condiment/syrup_strawberry))
		name = "waffles with strawberry sauce"
		desc = "Don't worry! They're so neon red, there's no CHANCE anything nutritious got through to them!"
		icon_state = "waffles_redsauce"

	else if(reagents.has_reagent(/singleton/reagent/condiment/syrup_berry))
		name = "waffles with berry sauce"
		desc = "Waffles with neon red berry sauce. Stretching the term 'berries' to the absolute furthest limits allowed by food health and safety regulations."
		icon_state = "waffles_redsauce"

	else if(reagents.has_reagent(/singleton/reagent/condiment/syrup_caramel))
		name = "waffles with caramel sauce"
		desc = "Because some people just want to chug a whole keg of sugar and get away with calling it breakfast."
		icon_state = "waffles_lightbrownsauce"

	else if(reagents.has_reagent(/singleton/reagent/condiment/syrup_pumpkin))
		name = "waffles with pumpkin spice sauce"
		desc = "For that perfect social media breakfast photo on an autumn morning."
		icon_state = "waffles_lightbrownsauce"

	else if(reagents.has_reagent(/singleton/reagent/condiment/syrup_dirtberry))
		name = "waffles with dirtberry sauce"
		desc = "Parrrt of this complete brrreakfast!"
		icon_state = "waffles_lightbrownsauce"

	else if(reagents.has_reagent(/singleton/reagent/condiment/syrup_blueberry))
		name = "waffles with blueberry sauce"
		desc = "You could have had waffles with actual blueberries to maybe get just a little bit of nutrition in there along with the flavor, but no. You chose this."
		icon_state = "waffles_bluesauce"

	else if(reagents.has_reagent(/singleton/reagent/condiment/syrup_blueraspberry))
		name = "waffles with blue raspberry sauce"
		desc = "Introducing breakfast to colors it was never meant to be! Wow!"
		icon_state = "waffles_bluesauce"

	else if(reagents.has_reagent(/singleton/reagent/condiment/syrup_raspberry))
		name = "waffles with raspberry sauce"
		desc = "Glamour waffles."
		icon_state = "waffles_pinksauce"

	else if(reagents.has_reagent(/singleton/reagent/condiment/syrup_ylphaberry))
		name = "waffles with ylpha sauce"
		desc = "How delicious is this? Ylpha-nd out soon enough!" //Hurr hurr
		icon_state = "waffles_pinksauce"

/obj/item/reagent_containers/food/snacks/soywafers
	name = "Soy Wafers"
	desc = "Simple pressed soy wafers."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "soylent_yellow"
	trash = /obj/item/trash/waffles
	drop_sound = /singleton/sound_category/tray_hit_sound
	filling_color = "#E6FA61"
	center_of_mass = list("x"=15, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 10)
	reagent_data = list(/singleton/reagent/nutriment = list("bland dry soy" = 5))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/rofflewaffles
	name = "roffle waffles"
	desc = "Waffles from Roffle. Co."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "rofflewaffles"
	trash = /obj/item/trash/waffles
	drop_sound = /singleton/sound_category/tray_hit_sound
	filling_color = "#FF00F7"
	center_of_mass = list("x"=15, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 8, /singleton/reagent/drugs/psilocybin = 8)
	reagent_data = list(/singleton/reagent/nutriment = list("waffle" = 7, "sweetness" = 1))
	bitesize = 4

////////////////////////////////////////////OTHER////////////////////////////////////////////

/obj/item/reagent_containers/food/snacks/cookie
	name = "cookie"
	desc = "A cookie."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "COOKIE!!!"
	filling_color = "#DBC94F"
	reagents_to_add = list(/singleton/reagent/nutriment = 2, /singleton/reagent/sugar = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("cookie" = 2))
	bitesize = 1

/obj/item/reagent_containers/food/snacks/fortunecookie
	name = "fortune cookie"
	desc = "A true prophecy in each cookie!"
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "fortune_cookie"
	filling_color = "#E8E79E"
	center_of_mass = list("x"=15, "y"=14)
	reagents_to_add = list(/singleton/reagent/nutriment = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("fortune cookie" = 2))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/brownies
	name = "brownies"
	gender = PLURAL
	desc = "Halfway to fudge, or halfway to cake? Who cares!"
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "brownies"
	slice_path = /obj/item/reagent_containers/food/snacks/browniesslice
	slices_num = 4
	trash = /obj/item/trash/brownies
	filling_color = "#301301"
	center_of_mass = list("x"=15, "y"=9)
	reagents_to_add = list(/singleton/reagent/nutriment = 8, /singleton/reagent/browniemix = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("brownies" = 5))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/browniesslice
	name = "brownie"
	desc = "a dense, decadent chocolate brownie."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "browniesslice"
	trash = /obj/item/trash/plate
	filling_color = "#F5B951"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=12)

/obj/item/reagent_containers/food/snacks/browniesslice/filled
	reagents_to_add = list(/singleton/reagent/nutriment = 1, /singleton/reagent/browniemix = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("brownies" = 2))

/obj/item/reagent_containers/food/snacks/sliceable/cosmicbrownies
	name = "cosmic brownies"
	gender = PLURAL
	desc = "Like, ultra-trippy. Brownies HAVE no gender, man." //Except I had to add one!
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "cosmicbrownies"
	slice_path = /obj/item/reagent_containers/food/snacks/cosmicbrowniesslice
	slices_num = 4
	trash = /obj/item/trash/brownies
	filling_color = "#301301"
	center_of_mass = list("x"=15, "y"=9)
	reagents_to_add = list(/singleton/reagent/nutriment = 8, /singleton/reagent/browniemix = 4, /singleton/reagent/drugs/ambrosia_extract = 4, /singleton/reagent/bicaridine = 2, /singleton/reagent/kelotane = 2, /singleton/reagent/toxin = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("brownies" = 5))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/cosmicbrowniesslice
	name = "cosmic brownie slice"
	desc = "A dense, decadent and fun-looking chocolate brownie."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "cosmicbrowniesslice"
	trash = /obj/item/trash/plate
	filling_color = "#F5B951"
	bitesize = 3
	center_of_mass = list("x"=16, "y"=12)

/obj/item/reagent_containers/food/snacks/cosmicbrowniesslice/filled
	reagents_to_add = list(/singleton/reagent/nutriment = 1, /singleton/reagent/browniemix = 1, /singleton/reagent/drugs/ambrosia_extract = 1, /singleton/reagent/bicaridine = 1, /singleton/reagent/kelotane = 1, /singleton/reagent/toxin = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("brownies" = 2))

/obj/item/reagent_containers/food/snacks/sliceable/cranberry_orange_rolls
	name = "cranberry orange rolls"
	desc = "A tray full of one big, gooey pastry, ready to become a bunch of lovely individual sweet rolls once you slice them apart."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "cranberryrolls"
	slice_path = /obj/item/reagent_containers/food/snacks/cranberry_orange_roll
	slices_num = 5
	trash = /obj/item/trash/brownies
	filling_color = "#c43934"
	center_of_mass = list("x"=15, "y"=9)
	reagents_to_add = list(/singleton/reagent/nutriment = 15)
	reagent_data = list(/singleton/reagent/nutriment = list("cranberry" = 5, "orange" = 5, "sweet dough" = 5))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/cranberry_orange_roll
	name = "cranberry orange roll"
	desc = "A lovely glazed sweet roll full of cranberry-orange flavor. A delicious treat whether for a thanksgiving meal in Sol, or a nice walk through Xanu Prime's many pastry shops."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "cranberryroll"
	filling_color = "#c43934"
	bitesize = 1

/obj/item/reagent_containers/food/snacks/cranberry_orange_roll/update_icon()
	if(bitecount>=1)
		icon_state = "cranberryroll_half"
	else
		icon_state = "cranberryroll"

/obj/item/reagent_containers/food/snacks/cranberry_orange_roll/filled
	reagents_to_add = list(/singleton/reagent/nutriment = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("cranberry" = 5, "orange" = 5, "sweet dough" = 5))

// Cakes.
//============
/obj/item/reagent_containers/food/snacks/sliceable/cake
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'

/obj/item/reagent_containers/food/snacks/cakeslice
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'

/obj/item/reagent_containers/food/snacks/sliceable/cake/plain
	name = "vanilla cake"
	desc = "A plain cake, not a lie."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "plaincake"
	slice_path = /obj/item/reagent_containers/food/snacks/cakeslice/plain
	slices_num = 5
	filling_color = "#F7EDD5"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/nutriment = 20)
	reagent_data = list(/singleton/reagent/nutriment = list("cake" = 10, "sweetness" = 10, "vanilla" = 15))

/obj/item/reagent_containers/food/snacks/cakeslice/plain
	name = "vanilla cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "plaincake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#F7EDD5"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)

/obj/item/reagent_containers/food/snacks/cakeslice/plain/filled
	reagents_to_add = list(/singleton/reagent/nutriment = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("cake" = 5, "sweetness" = 5, "vanilla" = 5))

/obj/item/reagent_containers/food/snacks/sliceable/cake/carrot
	name = "carrot cake"
	desc = "A favorite desert of a certain wascally wabbit. Not a lie."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "carrotcake"
	slice_path = /obj/item/reagent_containers/food/snacks/cakeslice/carrot
	slices_num = 5
	filling_color = "#FFD675"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/nutriment = 25, /singleton/reagent/oculine = 10)
	reagent_data = list(/singleton/reagent/nutriment = list("cake" = 10, "sweetness" = 10, "carrot" = 15))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/cakeslice/carrot
	name = "carrot cake slice"
	desc = "Carrotty slice of Carrot Cake, carrots are good for your eyes! Also not a lie."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "carrotcake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FFD675"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)

/obj/item/reagent_containers/food/snacks/cakeslice/carrot/filled
	reagents_to_add = list(/singleton/reagent/nutriment = 5, /singleton/reagent/oculine = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("cake" = 5, "sweetness" = 5, "carrot" = 5))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/cake/cheese
	name = "cheese cake"
	desc = "DANGEROUSLY cheesy."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "cheesecake"
	slice_path = /obj/item/reagent_containers/food/snacks/cakeslice/cheese
	slices_num = 5
	filling_color = "#FAF7AF"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/nutriment = 10, /singleton/reagent/nutriment/protein/cheese = 15)
	reagent_data = list(/singleton/reagent/nutriment = list("cake" = 10, "cream" = 10))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/cakeslice/cheese
	name = "cheese cake slice"
	desc = "Slice of pure cheestisfaction"
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "cheesecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FAF7AF"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)

/obj/item/reagent_containers/food/snacks/cakeslice/cheese/filled
	reagents_to_add = list(/singleton/reagent/nutriment = 2, /singleton/reagent/nutriment/protein/cheese = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("cake" = 5, "cream" = 5))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/cake/orange
	name = "orange cake"
	desc = "A cake with added orange."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "orangecake"
	slice_path = /obj/item/reagent_containers/food/snacks/cakeslice/orange
	slices_num = 5
	filling_color = "#FADA8E"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/nutriment = 20)
	reagent_data = list(/singleton/reagent/nutriment = list("cake" = 10, "sweetness" = 10, "orange" = 15))

/obj/item/reagent_containers/food/snacks/cakeslice/orange
	name = "orange cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "orangecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FADA8E"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)

/obj/item/reagent_containers/food/snacks/cakeslice/orange/filled
	reagents_to_add = list(/singleton/reagent/nutriment = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("cake" = 5, "sweetness" = 5, "orange" = 5))

/obj/item/reagent_containers/food/snacks/sliceable/cake/lime
	name = "lime cake"
	desc = "A cake with added lime."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "limecake"
	slice_path = /obj/item/reagent_containers/food/snacks/cakeslice/lime
	slices_num = 5
	filling_color = "#CBFA8E"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/nutriment = 20)
	reagent_data = list(/singleton/reagent/nutriment = list("cake" = 10, "sweetness" = 10, "lime" = 15))

/obj/item/reagent_containers/food/snacks/cakeslice/lime
	name = "lime cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "limecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#CBFA8E"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)

/obj/item/reagent_containers/food/snacks/cakeslice/lime/filled
	reagents_to_add = list(/singleton/reagent/nutriment = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("cake" = 5, "sweetness" = 5, "lime" = 5))

/obj/item/reagent_containers/food/snacks/sliceable/cake/lemon
	name = "lemon cake"
	desc = "A cake with added lemon."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "lemoncake"
	slice_path = /obj/item/reagent_containers/food/snacks/cakeslice/lemon
	slices_num = 5
	filling_color = "#FAFA8E"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/nutriment = 20)
	reagent_data = list(/singleton/reagent/nutriment = list("cake" = 10, "sweetness" = 10, "lemon" = 15))

/obj/item/reagent_containers/food/snacks/cakeslice/lemon
	name = "lemon cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "lemoncake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FAFA8E"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)

/obj/item/reagent_containers/food/snacks/cakeslice/lemon/filled
	reagents_to_add = list(/singleton/reagent/nutriment = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("cake" = 5, "sweetness" = 5, "lemon" = 5))

/obj/item/reagent_containers/food/snacks/sliceable/cake/chocolate
	name = "chocolate cake"
	desc = "A cake with added chocolate."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "chocolatecake"
	slice_path = /obj/item/reagent_containers/food/snacks/cakeslice/chocolate
	slices_num = 5
	filling_color = "#805930"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/nutriment = 20)
	reagent_data = list(/singleton/reagent/nutriment = list("cake" = 10, "sweetness" = 10, "chocolate" = 15))

/obj/item/reagent_containers/food/snacks/cakeslice/chocolate
	name = "chocolate cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "chocolatecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#805930"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)

/obj/item/reagent_containers/food/snacks/cakeslice/chocolate/filled
	reagents_to_add = list(/singleton/reagent/nutriment = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("cake" = 5, "sweetness" = 5, "chocolate" = 5))

/obj/item/reagent_containers/food/snacks/sliceable/cake/birthday
	name = "birthday cake"
	desc = "Happy Birthday..."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "birthdaycake"
	slice_path = /obj/item/reagent_containers/food/snacks/cakeslice/birthday
	slices_num = 5
	filling_color = "#FFD6D6"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/nutriment = 20, /singleton/reagent/nutriment/sprinkles = 10)
	reagent_data = list(/singleton/reagent/nutriment = list("cake" = 10, "sweetness" = 10))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/cakeslice/birthday
	name = "birthday cake slice"
	desc = "A slice of your birthday."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "birthdaycakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#FFD6D6"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)

/obj/item/reagent_containers/food/snacks/cakeslice/birthday/filled
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/nutriment/sprinkles = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("cake" = 5, "sweetness" = 5))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/sliceable/cake/apple
	name = "apple cake"
	desc = "A cake centred with apples."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "applecake"
	slice_path = /obj/item/reagent_containers/food/snacks/cakeslice/apple
	slices_num = 5
	filling_color = "#EBF5B8"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/nutriment = 15)
	reagent_data = list(/singleton/reagent/nutriment = list("cake" = 10, "sweetness" = 10, "apple" = 15))

/obj/item/reagent_containers/food/snacks/cakeslice/apple
	name = "apple cake slice"
	desc = "A slice of heavenly cake."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "applecakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#EBF5B8"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)

/obj/item/reagent_containers/food/snacks/cakeslice/apple/filled
	reagents_to_add = list(/singleton/reagent/nutriment = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("cake" = 5, "sweetness" = 5, "apple" = 5))

/obj/item/reagent_containers/food/snacks/sliceable/cake/ntella_cheesecake
	name = "NTella cheesecake"
	desc = "An elaborate layer cheesecake made with chocolate hazelnut spread. You gain calories just by looking at it for too long."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "NTellacheesecake"
	slice_path = /obj/item/reagent_containers/food/snacks/cakeslice/ntella_cheesecake_slice
	slices_num = 5
	filling_color = "#331c03"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/nutriment = 20)
	reagent_data = list(/singleton/reagent/nutriment = list("hazelnut chocolate" = 15, "creamy cheese" = 10, "crunchy cookie base" = 5))

/obj/item/reagent_containers/food/snacks/cakeslice/ntella_cheesecake_slice
	name = "NTella cheesecake slice"
	desc = "A slice of cake marrying the chocolate taste of NTella with the creamy smoothness of cheesecake, all on a cookie crumble base."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "NTellacheesecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#331c03"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)

/obj/item/reagent_containers/food/snacks/sliceable/cake/starcake //
	name = "starcake"
	desc = "This pound cake mixes citrus fruits with cocoa, and has a layer of creamy glaze on top. It's dense and relatively simple to make. You can find it in various coffee shops and bakeries around the spur, but for some uknown reason, in the weeping stars system it has become somewhat associated with funerals over the years."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "starcake"
	slice_path = /obj/item/reagent_containers/food/snacks/cakeslice/starcake
	slices_num = 6
	filling_color = "#f0b97b"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/nutriment = 15, /singleton/reagent/nutriment/glucose = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("cake" = 10, "cocoa" = 10, "orange" = 15))

/obj/item/reagent_containers/food/snacks/cakeslice/starcake
	name = "starcake slice"
	desc = "A thin slice of pound cake that mixes citrus fruits with cocoa, and has a layer of creamy glaze on top. Enjoyed with a side of coffee or tea all over the spur, in the weeping stars system it is also frequently served in funerals for some reason."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "starcake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#f0b97b"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=14)

//Predesigned pies
//=======================
/obj/item/reagent_containers/food/snacks/berryclafoutis
	name = "berry clafoutis"
	desc = "No black birds, this is a good sign."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "berryclafoutis"
	trash = /obj/item/trash/plate
	center_of_mass = list("x"=16, "y"=13)
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/drink/berryjuice = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("sweetness" = 2, "pie" = 3))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/meatpie
	name = "meat-pie"
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "meatpie"
	item_state = "pie"
	desc = "An old barber recipe, very delicious!"
	trash = /obj/item/trash/plate
	filling_color = "#948051"
	center_of_mass = list("x"=16, "y"=13)
	bitesize = 2

	reagents_to_add = list(/singleton/reagent/nutriment/protein = 10)

/obj/item/reagent_containers/food/snacks/tofupie
	name = "tofu-pie"
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "meatpie"
	item_state = "pie"
	desc = "A delicious tofu pie."
	trash = /obj/item/trash/plate
	filling_color = "#FFFEE0"
	center_of_mass = list("x"=16, "y"=13)
	reagents_to_add = list(/singleton/reagent/nutriment = 8, /singleton/reagent/nutriment/protein/tofu = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("pie" = 8))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/xemeatpie
	name = "xeno-pie"
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "xenomeatpie"
	item_state = "pie"
	desc = "A delicious meatpie. Probably heretical."
	trash = /obj/item/trash/plate
	filling_color = "#43DE18"
	center_of_mass = list("x"=16, "y"=13)
	bitesize = 2

	reagents_to_add = list(/singleton/reagent/nutriment/protein = 10)

/obj/item/reagent_containers/food/snacks/pie
	name = "banana cream pie"
	desc = "Just like back home, on clown planet! HONK!"
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "pie"
	item_state = "pie"
	trash = /obj/item/trash/plate
	filling_color = "#FBFFB8"
	center_of_mass = list("x"=16, "y"=13)
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/drink/banana = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("pie" = 3, "cream" = 2))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/pie/throw_impact(atom/hit_atom)
	..()
	new/obj/effect/decal/cleanable/pie_smudge(src.loc)
	src.visible_message(SPAN_DANGER("\The [src.name] splats."), SPAN_DANGER("You hear a splat."))
	qdel(src)

/obj/item/reagent_containers/food/snacks/applepie
	name = "apple pie"
	desc = "A pie containing sweet sweet love... or apple."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "applepie"
	item_state = "pie"
	filling_color = "#E0EDC5"
	center_of_mass = list("x"=16, "y"=13)
	reagents_to_add = list(/singleton/reagent/nutriment = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("sweetness" = 2, "apple" = 2, "pie" = 2))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/cherrypie
	name = "cherry pie"
	desc = "Taste so good, make a grown man cry."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "cherrypie"
	item_state = "pie"
	filling_color = "#FF525A"
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("sweetness" = 2, "cherry" = 2, "pie" = 2))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/sliceable/cranberry_pie
	name = "cranberry pie"
	desc = "A perfectly delicious pie to be divided and shared among friends and family... Or secretly scarfed down all by yourself! Don't worry, I won't tell, I'm just a food description!"
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "cranberry_pie"
	item_state = "pie"
	filling_color = "#9e0057"
	slice_path = /obj/item/reagent_containers/food/snacks/cranberry_pie_slice
	slices_num = 3
	trash = /obj/item/trash/plate
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/drink/cranberryjuice = 3, /singleton/reagent/nutriment/glucose = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("cranberry" = 4, "crumbly pie dough" = 4))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/cranberry_pie_slice
	name = "slice of cranberry pie"
	desc = "A delightful sweet and tangy slice of cranberry pie in a crumbly crust."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "cranberry_pie_slice"
	trash = /obj/item/trash/plate
	filling_color = "#9e0057"
	bitesize = 1
	center_of_mass = list("x"=16, "y"=12)

/obj/item/reagent_containers/food/snacks/amanita_pie
	name = "amanita pie"
	desc = "Sweet and tasty poison pie."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "amanita_pie"
	filling_color = "#FFCCCC"
	center_of_mass = list("x"=17, "y"=9)
	reagents_to_add = list(/singleton/reagent/nutriment = 5, /singleton/reagent/toxin/amatoxin = 3, /singleton/reagent/drugs/psilocybin = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("sweetness" = 3, "mushroom" = 3, "pie" = 2))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/plump_pie
	name = "plump pie"
	desc = "I bet you love stuff made out of plump helmets!"
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "plump_pie"
	filling_color = "#B8279B"
	center_of_mass = list("x"=17, "y"=9)
	reagents_to_add = list(/singleton/reagent/nutriment = 8)
	reagent_data = list(/singleton/reagent/nutriment = list("heartiness" = 2, "mushroom" = 3, "pie" = 3))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/plump_pie/Initialize()
	. = ..()
	if(prob(10))
		name = "exceptional plump pie"
		desc = "Microwave is taken by a fey mood! It has cooked an exceptional plump pie!"
		reagents.add_reagent(/singleton/reagent/tricordrazine, 5)

/obj/item/reagent_containers/food/snacks/sliceable/pumpkinpie
	name = "pumpkin pie"
	desc = "A delicious treat for the autumn months."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "pumpkinpie"
	slice_path = /obj/item/reagent_containers/food/snacks/pumpkinpieslice
	slices_num = 5
	filling_color = "#F5B951"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/nutriment = 15)
	reagent_data = list(/singleton/reagent/nutriment = list("pie" = 5, "cream" = 5, "pumpkin" = 5))

/obj/item/reagent_containers/food/snacks/pumpkinpieslice
	name = "pumpkin pie slice"
	desc = "A slice of pumpkin pie, with whipped cream on top. Perfection."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "pumpkinpieslice"
	trash = /obj/item/trash/plate
	filling_color = "#F5B951"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=12)

/obj/item/reagent_containers/food/snacks/pumpkinpieslice/filled
	reagents_to_add = list(/singleton/reagent/nutriment = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("pie" = 2, "cream" = 2, "pumpkin" = 2))

/obj/item/reagent_containers/food/snacks/sliceable/keylimepie
	name = "key lime pie"
	desc = "A tart, sweet dessert. What's a key lime, anyway?"
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "keylimepie"
	slice_path = /obj/item/reagent_containers/food/snacks/keylimepieslice
	slices_num = 5
	filling_color = "#F5B951"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/nutriment = 16)
	reagent_data = list(/singleton/reagent/nutriment = list("pie" = 10, "cream" = 10, "lime" = 15))

/obj/item/reagent_containers/food/snacks/keylimepieslice
	name = "slice of key lime pie"
	desc = "A slice of tart pie, with whipped cream on top."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "keylimepieslice"
	trash = /obj/item/trash/plate
	filling_color = "#F5B951"
	bitesize = 3
	center_of_mass = list("x"=16, "y"=12)

/obj/item/reagent_containers/food/snacks/keylimepieslice/filled
	reagents_to_add = list(/singleton/reagent/nutriment = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("pie" = 5, "cream" = 5, "lime" = 5))

/obj/item/reagent_containers/food/snacks/sliceable/quiche
	name = "quiche"
	desc = "Real men eat this, contrary to popular belief."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "quiche"
	slice_path = /obj/item/reagent_containers/food/snacks/quicheslice
	slices_num = 5
	filling_color = "#F5B951"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/nutriment = 10, /singleton/reagent/nutriment/protein/cheese = 10)
	reagent_data = list(/singleton/reagent/nutriment = list("pie" = 5, "cheese" = 5))

/obj/item/reagent_containers/food/snacks/quicheslice
	name = "slice of quiche"
	desc = "A slice of delicious quiche. Eggy, cheesy goodness."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "quicheslice"
	trash = /obj/item/trash/plate
	filling_color = "#F5B951"
	bitesize = 3
	center_of_mass = list("x"=16, "y"=12)

/obj/item/reagent_containers/food/snacks/quicheslice/filled
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/protein/cheese = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("pie" = 2))

/obj/item/reagent_containers/food/snacks/appletart
	name = "golden apple streusel tart"
	desc = "A tasty dessert that won't make it through a metal detector."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "gappletart"
	trash = /obj/item/trash/plate
	filling_color = "#FFFF00"
	center_of_mass = list("x"=16, "y"=18)
	reagents_to_add = list(/singleton/reagent/nutriment = 8, /singleton/reagent/gold = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("apple" = 8))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/truffle
	name = "chocolate truffle"
	desc = "Rich bite-sized chocolate."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "truffle"
	reagents_to_add = list(/singleton/reagent/nutriment/coco = 6)
	bitesize = 4
	filling_color = "#9C6b1E"

/obj/item/reagent_containers/food/snacks/truffle/random
	name = "mystery chocolate truffle"
	desc = "Rich bite-sized chocolate with a mystery filling!"

/obj/item/reagent_containers/food/snacks/truffle/random/Initialize()
	. = ..()
	var/reagent_type = pick(list(/singleton/reagent/drink/milk/cream,/singleton/reagent/nutriment/cherryjelly,/singleton/reagent/nutriment/mint,/singleton/reagent/frostoil,/singleton/reagent/capsaicin,/singleton/reagent/drink/milk/cream,/singleton/reagent/drink/coffee,/singleton/reagent/drink/milkshake))
	reagents.add_reagent(reagent_type, 4)

/obj/item/reagent_containers/food/snacks/sliceable/giffypie
	name = "giffy pie"
	desc = "Popularized in recent years after a Solarian mother was shown serving it on a cooking reality show. She wasn't even one of the participants."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "giffypie"
	slice_path = /obj/item/reagent_containers/food/snacks/giffypieslice
	slices_num = 5
	filling_color = "#a58cc5"
	reagents_to_add = list(/singleton/reagent/nutriment = 15)
	reagent_data = list(/singleton/reagent/nutriment = list("pie" = 10, "peanut butter ganache" = 10, "grape jelly" = 15))


/obj/item/reagent_containers/food/snacks/giffypieslice
	name = "slice of giffy pie"
	desc = "A thick layer of peanut butter ganache with a layer of grape jelly above, and some blue cream on top. Just like on the reality show that made it popular!"
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "giffypieslice"
	trash = /obj/item/trash/plate
	filling_color = "#a58cc5"
	bitesize = 3
	center_of_mass = list("x"=16, "y"=12)


//roulades (currently 1, more to come)

/obj/item/reagent_containers/food/snacks/sliceable/chocolateroulade
	name = "chocolate roulade"
	desc = "chocolate cake with a twist."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "chocolateroulade"
	trash = /obj/item/trash/plate
	filling_color = "#573a2f"
	center_of_mass = list("x"=16, "y"=12)
	slice_path = /obj/item/reagent_containers/food/snacks/chocolaterouladeslice
	slices_num = 5
	reagents_to_add = list(/singleton/reagent/nutriment = 15)
	reagent_data = list(/singleton/reagent/nutriment = list("baked goods" = 10, "chocolate" = 10))

/obj/item/reagent_containers/food/snacks/chocolaterouladeslice
	name = "slice of chocolate roulade"
	desc = "a slice of chocolate cake with a twist!"
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "chocolaterouladeslice"
	trash = /obj/item/trash/plate
	filling_color = "#573a2f"
	bitesize = 3
	center_of_mass = list("x"=16, "y"=12)

/obj/item/reagent_containers/food/snacks/sliceable/ylpharoulade
	name = "ylpha roulade"
	desc = "A sweet roll made of Ylpha Berries and white chocolate!"
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "ylpharoulade"
	trash = /obj/item/trash/plate
	filling_color = "#be5d92"
	center_of_mass = list("x"=16, "y"=12)
	slice_path = /obj/item/reagent_containers/food/snacks/ylpharouladeslice
	slices_num = 5
	reagents_to_add = list(/singleton/reagent/nutriment = 15)
	reagent_data = list(/singleton/reagent/nutriment = list("baked goods" = 10, "white chocolate" = 10, "ylpha berry" = 10))

/obj/item/reagent_containers/food/snacks/ylpharouladeslice
	name = "slice of ylpha roulade"
	desc = "The deliciousness of Ylpha berries and white chocolate rolled into one!"
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "ylpharouladeslice"
	trash = /obj/item/trash/plate
	filling_color = "#be5d92"
	bitesize = 3
	center_of_mass = list("x"=16, "y"=12)

/obj/item/reagent_containers/food/snacks/cakepopselection
	name = "cake pop"
	desc = "Clearly it's the healthier choice if you're only having a SMALL lump of sugary dough coated in sugar with some sugar on top. How responsible of you!"
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	bitesize = 3
	trash = /obj/item/trash/stick
	reagents_to_add = list(/singleton/reagent/nutriment = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("sugar" = 4, "cake" = 2))

/obj/item/reagent_containers/food/snacks/sliceable/strawberrybars
	name = "strawberry crumble bars"
	gender = PLURAL
	desc = "a tray full of delicious sweet bars of strawberry jam and sugary crumbs of dough on top. Might wanna slice it."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "strawberrybars"
	slice_path = /obj/item/reagent_containers/food/snacks/strawberrybar
	slices_num = 4
	trash = /obj/item/trash/brownies
	filling_color = "#6e0202"
	center_of_mass = list("x"=15, "y"=9)
	reagents_to_add = list(/singleton/reagent/nutriment = 10)
	reagent_data = list(/singleton/reagent/nutriment = list("strawberry" = 8, "crumbly dough" = 8, "rhubarb" = 4))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/strawberrybar
	name = "strawberry crumble bar"
	desc = "A jammy strawberry delight coated in some seriously crumbly dough."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "strawberrybar"
	trash = /obj/item/trash/plate
	filling_color = "#6e0202"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=12)

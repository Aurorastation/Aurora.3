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
	center_of_mass = list("x"=17, "y"=4)
	reagents_to_add = list(/singleton/reagent/nutriment = 6)
	reagent_data = list(/singleton/reagent/nutriment = list("sweetness" = 3, "muffin" = 3))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/berrymuffin
	name = "berry muffin"
	desc = "A delicious and spongy little cake, with berries."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "berrymuffin"
	filling_color = "#E0CF9B"
	center_of_mass = list("x"=17, "y"=4)

	reagents_to_add = list(/singleton/reagent/nutriment = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("sweetness" = 1, "muffin" = 2, "berries" = 2))
	bitesize = 2

////////////////////////////////////////////PANCAKES////////////////////////////////////////////

/obj/item/reagent_containers/food/snacks/pancakes
	name = "pancakes"
	desc = "Pancakes, delicious."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "pancakes"
	trash = /obj/item/trash/plate
	reagents_to_add = list(/singleton/reagent/nutriment = 8)
	reagent_data = list(/singleton/reagent/nutriment = list("pancake" = 8))
	bitesize = 2
	filling_color = "#EDF291"

/obj/item/reagent_containers/food/snacks/pancakes/berry
	name = "berry pancakes"
	desc = "Pancakes with berries, delicious."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "berry_pancakes"

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
	reagents_to_add = list(/singleton/reagent/nutriment = 8, /singleton/reagent/psilocybin = 8)
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
	reagents_to_add = list(/singleton/reagent/nutriment = 8, /singleton/reagent/browniemix = 4, /singleton/reagent/ambrosia_extract = 4, /singleton/reagent/bicaridine = 2, /singleton/reagent/kelotane = 2, /singleton/reagent/toxin = 2)
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
	reagents_to_add = list(/singleton/reagent/nutriment = 1, /singleton/reagent/browniemix = 1, /singleton/reagent/ambrosia_extract = 1, /singleton/reagent/bicaridine = 1, /singleton/reagent/kelotane = 1, /singleton/reagent/toxin = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("brownies" = 2))

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
	filling_color = "#FF525A"
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("sweetness" = 2, "cherry" = 2, "pie" = 2))
	bitesize = 3


/obj/item/reagent_containers/food/snacks/amanita_pie
	name = "amanita pie"
	desc = "Sweet and tasty poison pie."
	icon = 'icons/obj/item/reagent_containers/food/pastries.dmi'
	icon_state = "amanita_pie"
	filling_color = "#FFCCCC"
	center_of_mass = list("x"=17, "y"=9)
	reagents_to_add = list(/singleton/reagent/nutriment = 5, /singleton/reagent/toxin/amatoxin = 3, /singleton/reagent/psilocybin = 1)
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


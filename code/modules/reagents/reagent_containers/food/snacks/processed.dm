/obj/item/reagent_containers/food/snacks/badrecipe
	name = "burned mess"
	desc = "Someone should be demoted from chef for this."
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "badrecipe"
	filling_color = "#211F02"
	center_of_mass = list("x"=16, "y"=12)
	bitesize = 2
	reagents_to_add = list(/singleton/reagent/toxin = 1, /singleton/reagent/carbon = 3)

/obj/item/reagent_containers/food/snacks/monkeycube
	name = "monkey cube"
	desc = "Just add water!"
	atom_flags = 0
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "monkeycube"
	bitesize = 12
	filling_color = "#ADAC7F"
	center_of_mass = list("x"=16, "y"=14)
	desc_extended = "The manufacture of a cubed animal produces subjects that are similar but have marked differences compared to their ordinary cousins. Higher brain functions are all but destroyed \
	and the life expectancy of the cubed animal is greatly reduced, with most expiring only a few days after introduction with water."

	var/wrapped = 0
	var/monkey_type = SPECIES_MONKEY

	reagents_to_add = list(/singleton/reagent/nutriment/protein = 10)

/obj/item/reagent_containers/food/snacks/monkeycube/afterattack(obj/O as obj, var/mob/living/carbon/human/user as mob, proximity)
	if(!proximity) return
	if(( istype(O, /obj/structure/reagent_dispensers/watertank) || istype(O,/obj/structure/sink) ) && !wrapped)
		to_chat(user, "You place \the [name] under a stream of water...")
		if(istype(user))
			user.unEquip(src)
		src.forceMove(get_turf(src))
		return Expand()
	..()

/obj/item/reagent_containers/food/snacks/monkeycube/attack_self(mob/user as mob)
	if(wrapped)
		Unwrap(user)

/obj/item/reagent_containers/food/snacks/monkeycube/proc/Expand()
	src.visible_message(SPAN_NOTICE("\The [src] expands!"))
	if(istype(loc, /obj/item/gripper)) // fixes ghost cube when using syringe
		var/obj/item/gripper/G = loc
		G.drop_item()
	var/mob/living/carbon/human/H = new(get_turf(src))
	H.set_species(monkey_type)
	H.real_name = H.species.get_random_name()
	H.name = H.real_name
	src.forceMove(null)
	qdel(src)
	return 1

/obj/item/reagent_containers/food/snacks/monkeycube/proc/Unwrap(mob/user as mob)
	icon_state = "monkeycube"
	desc = "Just add water!"
	to_chat(user, "You unwrap the cube.")
	wrapped = 0
	return

/obj/item/reagent_containers/food/snacks/monkeycube/wrapped
	desc = "Still wrapped in some paper."
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "monkeycubewrap"
	wrapped = 1
	desc_extended = "The manufacture of a cubed animal produces subjects that are similar but have marked differences compared to their ordinary cousins. Higher brain functions are all but destroyed \
	and the life expectancy of the cubed animal is greatly reduced, with most expiring only a few days after introduction with water."

/obj/item/reagent_containers/food/snacks/monkeycube/farwacube
	name = "farwa cube"
	monkey_type = SPECIES_MONKEY_TAJARA

/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/farwacube
	name = "farwa cube"
	monkey_type = SPECIES_MONKEY_TAJARA

/obj/item/reagent_containers/food/snacks/monkeycube/stokcube
	name = "stok cube"
	monkey_type = SPECIES_MONKEY_UNATHI

/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/stokcube
	name = "stok cube"
	monkey_type = SPECIES_MONKEY_UNATHI

/obj/item/reagent_containers/food/snacks/monkeycube/neaeracube
	name = "neaera cube"
	monkey_type = SPECIES_MONKEY_SKRELL

/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/neaeracube
	name = "neaera cube"
	monkey_type = SPECIES_MONKEY_SKRELL

/obj/item/reagent_containers/food/snacks/monkeycube/vkrexicube
	name = "v'krexi cube"
	monkey_type = SPECIES_MONKEY_VAURCA

/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/vkrexicube
	name = "v'krexi cube"
	monkey_type = SPECIES_MONKEY_VAURCA

/obj/item/reagent_containers/food/snacks/tuna
	name = "\improper Tuna Snax"
	desc = "A packaged fish snack. Guaranteed to not contain space carp."
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "tuna"
	filling_color = "#FFDEFE"
	center_of_mass = list("x"=17, "y"=13)
	bitesize = 2
	trash = /obj/item/trash/tuna

	reagents_to_add = list(/singleton/reagent/nutriment/protein/seafood = 4)

/obj/item/reagent_containers/food/snacks/koisbar_clean
	name = "k'ois bar"
	desc = "Bland NanoTrasen produced K'ois bars, rich in syrup and injected with extra phoron; it has a label on it warning that it is unsafe for human consumption."
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "koisbar"
	trash = /obj/item/trash/koisbar
	filling_color = "#dcd9cd"
	bitesize = 5
	reagents_to_add = list(/singleton/reagent/kois/clean = 10, /singleton/reagent/toxin/phoron = 15)

/obj/item/reagent_containers/food/snacks/koisbar
	name = "organic k'ois bar"
	desc = "100% certified organic NanoTrasen produced K'ois bars, rich in REAL unfiltered kois. No preservatives added!"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "koisbar"
	trash = /obj/item/trash/koisbar
	filling_color = "#dcd9cd"
	bitesize = 5
	reagents_to_add = list(/singleton/reagent/kois = 10, /singleton/reagent/toxin/phoron = 15)

/obj/item/reagent_containers/food/snacks/candy
	name = "candy"
	desc = "Nougat, love it or hate it. Made with real sugar, and no artificial preservatives!"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "candy"
	item_state = "candy"
	trash = /obj/item/trash/candy
	filling_color = "#7D5F46"

	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/sugar = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("chocolate" = 2, "nougat" = 1))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/candy/koko
	name = "koko bar"
	desc = "A sweet and gritty candy bar cultivated exclusively on the Compact ruled world of Ha'zana. A good pick-me-up for Unathi, but has no effect on other species."
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "kokobar"
	trash = /obj/item/trash/kokobar
	filling_color = "#7D5F46"

	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/sugar = 3, /singleton/reagent/mental/kokoreed = 7)
	reagent_data = list(/singleton/reagent/nutriment = list("koko reed" = 2, "fibers" = 1))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/proteinbar
	name = "protein bar"
	desc = "SwoleMAX brand protein bars, guaranteed to get you feeling perfectly overconfident."
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "proteinbar"
	item_state = "candy"
	trash = /obj/item/trash/proteinbar
	bitesize = 6

/obj/item/reagent_containers/food/snacks/proteinbar/Initialize()
	. = ..()
	reagents.add_reagent(/singleton/reagent/nutriment, 9)
	reagents.add_reagent(/singleton/reagent/nutriment/protein, 4)
	var/list/decl_flavors = GET_SINGLETON_SUBTYPE_MAP(/singleton/proteinbar_flavor)
	var/singleton/proteinbar_flavor/PB = GET_SINGLETON(pick(decl_flavors))
	name = "[PB.name] [name]"
	var/count = length(PB.reagents)
	if(count)
		for(var/type in PB.reagents)
			reagents.add_reagent(type, round(4 / count, 0.1))
	else
		reagents.add_reagent(PB.reagents, 4)

/obj/item/reagent_containers/food/snacks/skrellsnacks
	name = "\improper SkrellSnax"
	desc = "Cured eki shipped all the way from Nralakk IV, almost like jerky! Almost."
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "skrellsnacks"
	item_state = "candy"
	trash = /obj/item/trash/skrellsnacks
	filling_color = "#A66829"
	center_of_mass = list("x"=15, "y"=12)
	reagents_to_add = list(/singleton/reagent/nutriment = 10)
	reagent_data = list(/singleton/reagent/nutriment = list("alien fungus" = 10))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/tastybread
	name = "bread tube"
	desc = "Bread in a tube. Chewy."
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "tastybread"
	item_state = "candy"
	trash = /obj/item/trash/tastybread
	filling_color = "#A66829"
	center_of_mass = list("x"=17, "y"=16)
	reagent_data = list(/singleton/reagent/nutriment = list("stale bread" = 4))
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/sodiumchloride = 3)

/obj/item/reagent_containers/food/snacks/chips
	name = "\improper Getmore salted potato chips"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	desc = "Getmore potato chips. Wafers of potato paste, flash-fried and salted, delicious!"
	icon_state = "chips"
	gender = PLURAL
	trash = /obj/item/trash/chips
	filling_color = "#E8C31E"
	reagents_to_add = list(/singleton/reagent/nutriment = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("salted chips" = 3))
	bitesize = 1

/obj/item/reagent_containers/food/snacks/chips/cucumber
	name = "\improper Getmore cucumber potato chips"
	desc = "Getmore cucumber flavoured potato chips. Wafers of potato paste, flash-fried and flavoured, delicious!"
	icon_state = "cucumberchips"
	trash = /obj/item/trash/chips/cucumber
	reagent_data = list(/singleton/reagent/nutriment = list("cucumber flavoured chips" = 3))

/obj/item/reagent_containers/food/snacks/chips/chicken
	name = "\improper Getmore chicken potato chips"
	desc = "Getmore chicken flavoured potato chips. Wafers of potato paste, flash-fried and flavoured, delicious!"
	icon_state = "chickenchips"
	trash = /obj/item/trash/chips/chicken
	reagent_data = list(/singleton/reagent/nutriment = list("unseasoned chicken flavoured chips" = 3))

/obj/item/reagent_containers/food/snacks/chips/dirtberry
	name = "\improper Getmore dirtberry potato chips"
	desc = "Getmore dirtberry flavoured potato chips. Made in collaboration between Getmore and the People's Republic of Adhomai. Delicious! Doesn't actually contain dirtberries, though."
	icon_state = "dirtberrychips"
	trash = /obj/item/trash/chips/dirtberry
	reagent_data = list(/singleton/reagent/nutriment = list("nutty flavoured chips" = 3))

/obj/item/reagent_containers/food/snacks/chips/phoron
	name = "\improper Getmore phoron potato chips"
	desc = "Getmore 'phoron' flavoured potato chips. Delicious! Doesn't actually contain phoron, of course, and is really just a rebranding of their shrimp cocktail chips."
	icon_state = "phoronchips"
	trash = /obj/item/trash/chips/phoron
	reagent_data = list(/singleton/reagent/nutriment = list("shrimp cocktail flavoured chips" = 3))


/obj/item/reagent_containers/food/snacks/meatsnack
	name = "mo'gunz meat pie"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "meatsnack"
	item_state = "chips"
	desc = "Made from stok meat, packed into a crispy crust."
	trash = /obj/item/trash/meatsnack
	filling_color = "#631212"
	bitesize = 5
	reagents_to_add = list(/singleton/reagent/nutriment = 2, /singleton/reagent/nutriment/protein = 12, /singleton/reagent/sodiumchloride = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("pie crust" = 2))

/obj/item/reagent_containers/food/snacks/maps
	name = "maps salty ham"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "maps"
	desc = "Various processed meat from Moghes with 600% the amount of recommended daily sodium per can."
	trash = /obj/item/trash/maps
	filling_color = "#631212"
	bitesize = 3
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 6, /singleton/reagent/sodiumchloride = 6)

/obj/item/reagent_containers/food/snacks/nathisnack
	name = "razi-snack corned beef"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "cbeef"
	desc = "Delicious corned beef and preservatives. Imported from Earth, canned on Ourea."
	trash = /obj/item/trash/nathisnack
	filling_color = "#631212"
	bitesize = 4
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 10, /singleton/reagent/iron = 3, /singleton/reagent/sodiumchloride = 6)


/obj/item/reagent_containers/food/snacks/popcorn
	name = "popcorn"
	desc = "Now let's find some cinema."
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "popcorn"
	item_state = "candy"
	trash = /obj/item/trash/popcorn
	var/unpopped = 0
	filling_color = "#FFFAD4"
	center_of_mass = list("x"=16, "y"=8)
	reagents_to_add = list(/singleton/reagent/nutriment = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("popcorn" = 3))
	bitesize = 0.1 //this snack is supposed to be eating during looooong time. And this it not dinner food! --rastaf0

/obj/item/reagent_containers/food/snacks/popcorn/Initialize()
	. = ..()
	unpopped = rand(1,10)

/obj/item/reagent_containers/food/snacks/popcorn/on_consume()
	if(prob(unpopped))	//lol ...what's the point? // IMPLEMENT DENTISTRY WHEN?
		to_chat(usr, SPAN_WARNING("You bite down on an un-popped kernel!"))
		unpopped = max(0, unpopped-1)
	..()

/obj/item/reagent_containers/food/snacks/sosjerky
	name = "Scaredy's Private Reserve beef jerky"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "sosjerky"
	item_state = "candy"
	desc = "Beef jerky. A little oversalted, actually."
	trash = /obj/item/trash/sosjerky
	filling_color = "#631212"
	center_of_mass = list("x"=15, "y"=9)
	bitesize = 3

	reagents_to_add = list(/singleton/reagent/nutriment/protein = 4, /singleton/reagent/sodiumchloride = 3)

/obj/item/reagent_containers/food/snacks/no_raisin
	name = "Getmore Raisins"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "4no_raisins"
	desc = "Getmore Raisins. Dry, flavorless, and oversweetened. Sounds about right."
	trash = /obj/item/trash/raisins
	filling_color = "#343834"
	center_of_mass = list("x"=15, "y"=4)
	reagents_to_add = list(/singleton/reagent/nutriment = 6)
	reagent_data = list(/singleton/reagent/nutriment = list("dried raisins" = 6))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/spacetwinkie
	name = "creamy spongecake"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "space_twinkie"
	desc = "Contrary to popular belief, Getmore's sponge cakes don't last forever. They do, however, leave a plastic-esque film coating the inside of your mouth."
	trash = /obj/item/trash/space_twinkie
	filling_color = "#FFE591"
	center_of_mass = list("x"=15, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/sugar = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("cake" = 3, "cream filling" = 1))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/cheesiehonkers
	name = "Cheesie Honkers"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "cheesie_honkers"
	desc = "Bite sized cheesie snacks, made with real cheese! A little bit of it, anyway."
	trash = /obj/item/trash/cheesie
	filling_color = "#FFA305"
	center_of_mass = list("x"=15, "y"=9)
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/nutriment/protein/cheese = 3, /singleton/reagent/sodiumchloride = 6)
	reagent_data = list(/singleton/reagent/nutriment = list("chips" = 2))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/syndicake
	name = "\improper Nutri-Cakes"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "syndi_cakes"
	desc = "An extremely moist snack cake."
	filling_color = "#FF5D05"
	center_of_mass = list("x"=16, "y"=10)
	trash = /obj/item/trash/syndi_cakes
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/drink/doctorsdelight = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("cake" = 1,"cream filling" = 3, ))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/candy_corn
	name = "candy corn"
	desc = "It's a handful of candy corn. Cannot be stored in a detective's hat, alas."
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "candy_corn"
	filling_color = "#FFFCB0"

	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/sugar = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("candy corn" = 4))
	bitesize = 2

/obj/item/storage/box/fancy/cookiesnack
	name = "\improper Carps Ahoy! miniature cookies"
	desc = "A packet of Cap'n Carpie's miniature cookies! Now 100% carpotoxin free!"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "cookiesnack"
	icon_type = "cookie"
	storage_type = "packaging"
	starts_with = list(/obj/item/reagent_containers/food/snacks/cookiesnack = 6)
	can_hold = list(/obj/item/reagent_containers/food/snacks/cookiesnack)
	make_exact_fit = TRUE

	use_sound = 'sound/items/storage/wrapper.ogg'
	drop_sound = 'sound/items/drop/wrapper.ogg'
	pickup_sound = 'sound/items/pickup/wrapper.ogg'

	trash = /obj/item/trash/cookiesnack
	closable = FALSE
	icon_overlays = FALSE

/obj/item/reagent_containers/food/snacks/cookiesnack
	name = "miniature cookie"
	desc = "These are a lot smaller than you've imagined. They don't even deserve to be dunked in milk."
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "cookie_mini"
	slot_flags = SLOT_EARS
	filling_color = "#DBC94F"

	reagents_to_add = list(/singleton/reagent/nutriment = 0.5)
	reagent_data = list(/singleton/reagent/nutriment =  list("sweetness" = 1, "stale cookie" = 2, "childhood disappointment" = 1))
	bitesize = 1

/obj/item/storage/box/fancy/gum
	name = "\improper Chewy Fruit flavored gum"
	desc = "A small pack of chewing gum in various flavors."
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "gum_pack"
	item_state = "candy"
	icon_type = "gum stick"
	storage_type = "packaging"
	slot_flags = SLOT_EARS
	w_class = WEIGHT_CLASS_TINY
	starts_with = list(/obj/item/clothing/mask/chewable/candy/gum = 5)
	can_hold = list(/obj/item/clothing/mask/chewable/candy/gum, /obj/item/trash/spitgum)
	make_exact_fit = TRUE

	use_sound = 'sound/items/storage/wrapper.ogg'
	drop_sound = 'sound/items/drop/wrapper.ogg'
	pickup_sound = 'sound/items/pickup/wrapper.ogg'

	trash = /obj/item/trash/gum
	closable = FALSE
	icon_overlays = FALSE

/obj/item/reagent_containers/food/snacks/mint
	name = "mint"
	desc = "It is only wafer thin."
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "mint"
	filling_color = "#F2F2F2"
	center_of_mass = list("x"=16, "y"=14)
	bitesize = 1

	reagents_to_add = list(/singleton/reagent/nutriment/mint = 1)
	reagent_data = list(/singleton/reagent/nutriment/mint =  list("sweetness" = 1, "menthol" = 1))

/obj/item/reagent_containers/food/snacks/mint/admints
	desc = "Spearmint, peppermint's non-festive cousin."
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "admint"

/obj/item/storage/box/fancy/admints
	name = "Ad-mints"
	desc = "A pack of air fresheners for your mouth."
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "admint_pack"
	item_state = "candy"
	icon_type = "mint"
	storage_type = "packaging"
	slot_flags = SLOT_EARS
	w_class = WEIGHT_CLASS_TINY
	starts_with = list(/obj/item/reagent_containers/food/snacks/mint/admints = 6)
	can_hold = list(/obj/item/reagent_containers/food/snacks/mint/admints)
	make_exact_fit = TRUE

	use_sound = 'sound/items/storage/wrapper.ogg'
	drop_sound = 'sound/items/drop/wrapper.ogg'
	pickup_sound = 'sound/items/pickup/wrapper.ogg'

	trash = /obj/item/trash/admints
	closable = FALSE
	icon_overlays = FALSE

/obj/item/reagent_containers/food/snacks/liquidfood
	name = "LiquidFood ration"
	desc = "A prepackaged grey slurry of all the essential nutrients for a spacefarer on the go. Should this be crunchy? Now with artificial flavoring!"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "liquidfood"
	trash = /obj/item/trash/liquidfood
	filling_color = "#A8A8A8"
	center_of_mass = list("x"=16, "y"=15)
	bitesize = 4
	is_liquid = TRUE
	reagents_to_add = list(/singleton/reagent/nutriment = 10, /singleton/reagent/iron = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("chalk" = 1))

/obj/item/reagent_containers/food/snacks/liquidfood/Initialize()
	set_flavor()
	reagent_data[/singleton/reagent/nutriment][flavor] = 9
	return ..()

/obj/item/reagent_containers/food/snacks/liquidfood/set_flavor()
	flavor = pick("chocolate", "peanut butter cookie", "scrambled eggs", "beef taco", "tofu", "pizza", "spaghetti", "cheesy potatoes", "hamburger", "baked beans", "maple sausage", "chili macaroni", "veggie burger")
	return ..()

/obj/item/reagent_containers/food/snacks/cb01
	name = "tau ceti bar"
	desc = "A dark chocolate caramel and nougat bar made famous in Biesel."
	filling_color = "#552200"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "cb01"

	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/sugar = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("chocolate" = 2, "nougat" = 1, "caramel" = 1))
	bitesize = 2
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/cb02
	name = "hundred thousand credit bar"
	desc = "An ironically cheap puffed rice caramel milk chocolate bar."
	filling_color = "#552200"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "cb02"

	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/sugar = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("chocolate" = 2, "caramel" = 1, "puffed rice" = 1))
	bitesize = 2
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/cb03
	name = "spacewind bar"
	desc = "Bubbly milk chocolate."
	filling_color = "#552200"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "cb03"
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/sugar = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("chocolate" = 4))
	bitesize = 2
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/cb04
	name = "crunchy crisp"
	desc = "An almond flake bar covered in milk chocolate."
	filling_color = "#552200"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "cb04"
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/sugar = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("chocolate" = 3, "almonds" = 1))
	bitesize = 2
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/cb05
	name = "hearsay bar"
	desc = "A cheap milk chocolate bar loaded with sugar."
	filling_color = "#552200"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "cb05"

	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/sugar = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("chocolate" = 2, "vomit" = 1))
	bitesize = 3
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/cb06
	name = "latte crunch"
	desc = "A large latte flavored wafer chocolate bar."
	filling_color = "#552200"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "cb06"
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/sugar = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("chocolate" = 2, "coffee" = 1, "vanilla wafer" = 1))
	bitesize = 3
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/cb07
	name = "martian bar"
	desc = "Dark chocolate with a nougat and caramel center. Known as the first chocolate bar grown and produced on Mars."
	filling_color = "#552200"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "cb07"
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/sugar = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("chocolate" = 2, "caramel" = 1, "nougat" = 1))
	bitesize = 3
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/cb08
	name = "crisp bar"
	desc = "A large puffed rice milk chocolate bar."
	filling_color = "#552200"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "cb08"
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/sugar = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("chocolate" = 2, "puffed rice" = 1))
	bitesize = 3
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/cb09
	name = "oh daddy bar"
	desc = "A massive cluster of peanuts covered in caramel and chocolate."
	filling_color = "#552200"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "cb09"

	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/sugar = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("chocolate" = 3, "caramel" = 1, "peanuts" = 2))
	bitesize = 3
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/cb10
	name = "laughter bar"
	desc = "Nuts, nougat, peanuts, and caramel covered in chocolate."
	filling_color = "#552200"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "cb10"

	reagents_to_add = list(/singleton/reagent/nutriment = 5, /singleton/reagent/sugar = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("chocolate" = 2, "caramel" = 1, "peanuts" = 1, "nougat" = 1))
	bitesize = 3
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/meatcube
	name = "cubed meat"
	desc = "Fried, salted lean meat compressed into a cube. Not very appetizing."
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "meatcube"
	filling_color = "#7a3d11"
	center_of_mass = list("x"=16, "y"=16)
	bitesize = 3
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 15)

/obj/item/reagent_containers/food/snacks/amanitajelly
	name = "amanita jelly"
	desc = "Looks curiously toxic."
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "amanitajelly"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#ED0758"
	center_of_mass = list("x"=16, "y"=5)
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/toxin/amatoxin = 6, /singleton/reagent/drugs/psilocybin = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("jelly" = 3, "mushroom" = 3))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/pudding
	name = "figgy pudding"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "pudding"
	desc = "Bring it to me."
	trash = /obj/item/trash/plate
	filling_color = "#FFFEE0"
	reagents_to_add = list(/singleton/reagent/nutriment = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("fruit cake" = 4))
	bitesize = 2

// coalition snax go here

/obj/item/reagent_containers/food/snacks/fishjerky
	name = "Go-Go Gwok! Great Grouper"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "fishjerky"
	desc = "Ethically-sourced Konyang fish, seasoned with the classic Go-Go Gwok! spice blend."
	filling_color = "#a7633f"
	center_of_mass = list("x"=15, "y"=9)
	trash = /obj/item/trash/fishjerky
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 4, /singleton/reagent/sodiumchloride = 3)
	bitesize = 3
	reagent_data = list(/singleton/reagent/nutriment/protein = list("dried fish" = 2, "gwok spices" = 2))

/obj/item/reagent_containers/food/snacks/pepperoniroll
	name = "Inverkeithing Imports Number-Nine Roll"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "pepperoniroll"
	desc = "A warm bread roll stuffed with meat and cheese. A classic miner's lunch."
	filling_color = "#a7633f"
	center_of_mass = list("x"=15, "y"=9)
	trash = /obj/item/trash/pepperoniroll
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 4, /singleton/reagent/sodiumchloride = 2)
	bitesize = 2
	reagent_data = list(/singleton/reagent/nutriment/protein = list("pepperoni" = 2, "cheesy bread" = 2))

/obj/item/reagent_containers/food/snacks/salmiak
	name = "Inverkeithing Imports Viipuri Salmiak"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "saltyliquorice"
	desc = "A generous portion of salted mushroom licorice. An incredibly difficult-to-acquire taste. Traditionally found on the desks of unpleasant Himean government workers."
	filling_color = "#1d141f"
	trash = /obj/item/trash/salmiakpack
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/sodiumchloride = 4)
	bitesize = 1
	reagent_data = list(/singleton/reagent/nutriment = list("medicine" = 3,"black licorice" = 3))

/obj/item/reagent_containers/food/snacks/hakhspam
	name = "maps salty hakhma"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "hakhmaps"
	desc = "A variant of the famous spiced ham product. Popular among Scarabs and the Star-Men."
	filling_color = "#7f168d"
	center_of_mass = list("x"=15, "y"=9)
	trash = /obj/item/trash/hakhmaps
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 6, /singleton/reagent/sodiumchloride = 4)
	bitesize = 3
	reagent_data = list(/singleton/reagent/nutriment/protein = list("alien meat" = 6))

/obj/item/reagent_containers/food/snacks/pemmicanbar
	name = "Vedabar"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "pemmicanbar"
	desc = "A bar of dried ohdker meat and berries. Excellent for hiking!"
	filling_color = "#a7633f"
	center_of_mass = list("x"=15, "y"=9)
	trash = /obj/item/trash/pemmican
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 6)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/choctruffles
	name = "Dalyoni Dimlights"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "choctruffles"
	desc = "A bag of Assunzionii chocolate truffles. Remarkably unremarkable."
	filling_color = "#a7633f"
	center_of_mass = list("x"=15, "y"=9)
	trash = /obj/item/trash/trufflebag
	reagents_to_add = list(/singleton/reagent/nutriment = 5, /singleton/reagent/sugar = 1)
	bitesize = 2
	reagent_data = list(/singleton/reagent/nutriment = list("rich dark chocolate" = 3, "cocoa powder" = 2))

/obj/item/reagent_containers/food/snacks/peanutsnack
	name = "Annapurna Classic Munch"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "peanuts_xanu"
	desc = "A bag of roasted peanuts."
	filling_color = "#e48552"
	center_of_mass = list("x"=15, "y"=9)
	trash = /obj/item/trash/peanutsnack
	reagents_to_add = list(/singleton/reagent/nutriment = 5, /singleton/reagent/sodiumchloride = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("peanuts" = 5))
	bitesize = 4

/obj/item/reagent_containers/food/snacks/peanutsnack/pepper
	name = "Annapurna Salt N' Pepper"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "peanuts_sp"
	desc = "A bag of roasted peanuts, seasoned with salt and pepper."
	trash = /obj/item/trash/peanutsnack/pepper
	reagent_data = list(/singleton/reagent/nutriment = list("peanuts" = 2,"pepper" = 3))

/obj/item/reagent_containers/food/snacks/peanutsnack/choc
	name = "Annapurna Cinnamon Chocolate"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "peanuts_choc"
	desc = "A bag of roasted peanuts, coated with chocolate and cinnamon."
	trash = /obj/item/trash/peanutsnack/choc
	reagent_data = list(/singleton/reagent/nutriment = list("peanuts" = 2,"chocolate" = 2, "cinnamon" = 1))

/obj/item/reagent_containers/food/snacks/peanutsnack/masala
	name = "Annapurna Masala Masterpiece"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "peanuts_masala"
	desc = "A bag of roasted peanuts, seasoned with Xanan garam masala."
	trash = /obj/item/trash/peanutsnack/masala
	reagent_data = list(/singleton/reagent/nutriment = list("peanuts" = 2,"garam masala" = 3))

/obj/item/reagent_containers/food/snacks/chana
	name = "NexChana Mild"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "chanamild"
	desc = "Seasoned, crispy chickpeas. A proud product of the All-Xanu Republic."
	filling_color = "#e48552"
	center_of_mass = list("x"=15, "y"=9)
	trash = /obj/item/trash/chana
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/sodiumchloride = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("roasted chickpeas" = 3,"spices" = 3))
	bitesize = 4

/obj/item/reagent_containers/food/snacks/chana/wild
	name = "NexChana Wild"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "chanawild"
	desc = "Crispy chickpeas, coated in a spicy masala mix."
	trash = /obj/item/trash/chana/wild
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/capsaicin = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("roasted chickpeas" = 3,"spices" = 3))

/obj/item/reagent_containers/food/snacks/papad
	name = "Vollendaal Papad Crackers"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "papad"
	desc = "A Xanan brand of crispy papad crackers. Brighten up your snacking!"
	trash = /obj/item/trash/papad
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/sodiumchloride = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("fried chickpeas" = 3,"salt" = 1))
	bitesize = 4

/obj/item/reagent_containers/food/snacks/papad/garlic
	name = "Vollendaal Gracious Garlic"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "papadgarlic"
	desc = "The All-Xanu Republic's favorite papad crackers. A sunrise of natural garlic flavor!"
	trash = /obj/item/trash/papad/garlic
	reagent_data = list(/singleton/reagent/nutriment = list("fried chickpeas" = 2,"garlic" = 2))

/obj/item/reagent_containers/food/snacks/papad/ginger
	name = "Vollendaal Ginger Justice"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "papadginger"
	desc = "The sale of this box of crackers directly funds the Frontier Protection Bureau."
	trash = /obj/item/trash/papad/ginger
	reagent_data = list(/singleton/reagent/nutriment = list("fried chickpeas" = 2,"fresh ginger" = 2))

/obj/item/reagent_containers/food/snacks/papad/apple
	name = "Vollendaal Awesome Apple"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "papadapple"
	desc = "A healthy, crispy comrade to any lunchbox sandwich or movie night."
	trash = /obj/item/trash/papad/apple
	reagent_data = list(/singleton/reagent/nutriment = list("fried chickpeas" = 2,"crisp apples" = 2))

/obj/item/storage/box/fancy/foysnack
	name = "Brown Palace cocoa biscuits"
	desc = "A little packet of cocoa biscuits. A companion for any afternoon tea."
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "foypack"
	icon_type = "cookie"
	storage_type = "packaging"
	starts_with = list(/obj/item/reagent_containers/food/snacks/foy = 6)
	can_hold = list(/obj/item/reagent_containers/food/snacks/foy)
	make_exact_fit = TRUE

	use_sound = 'sound/items/storage/wrapper.ogg'
	drop_sound = 'sound/items/drop/wrapper.ogg'
	pickup_sound = 'sound/items/pickup/wrapper.ogg'

	trash = /obj/item/trash/foysnack
	closable = FALSE
	icon_overlays = FALSE

/obj/item/reagent_containers/food/snacks/foy
	name = "foy biscuit"
	icon = 'icons/obj/item/reagent_containers/food/processed.dmi'
	icon_state = "cookie_foy"
	desc = "Tea's favorite cookie."
	reagents_to_add = list(/singleton/reagent/nutriment = 0.5)
	reagent_data = list(/singleton/reagent/nutriment = list("light cocoa" = 2))
	bitesize = 1

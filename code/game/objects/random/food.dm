
/obj/random/mre
	name = "random MRE"
	desc = "This is a random single MRE."
	icon = 'icons/obj/food.dmi'
	icon_state = "mre"
	spawnlist = list(/obj/item/storage/box/fancy/mre,
					 /obj/item/storage/box/fancy/mre/menu2,
					 /obj/item/storage/box/fancy/mre/menu3,
					 /obj/item/storage/box/fancy/mre/menu4,
					 /obj/item/storage/box/fancy/mre/menu5,
					 /obj/item/storage/box/fancy/mre/menu6,
					 /obj/item/storage/box/fancy/mre/menu7,
					 /obj/item/storage/box/fancy/mre/menu8,
					 /obj/item/storage/box/fancy/mre/menu9,
					 /obj/item/storage/box/fancy/mre/menu10)

/obj/random/mre/main
	name = "random MRE main course"
	desc = "This is a random main course for MREs."
	icon_state = "pouch_medium"
	spawnlist = list(/obj/item/storage/box/fancy/mrebag,
					 /obj/item/storage/box/fancy/mrebag/menu2,
					 /obj/item/storage/box/fancy/mrebag/menu3,
					 /obj/item/storage/box/fancy/mrebag/menu4,
					 /obj/item/storage/box/fancy/mrebag/menu5,
					 /obj/item/storage/box/fancy/mrebag/menu6,
					 /obj/item/storage/box/fancy/mrebag/menu7,
					 /obj/item/storage/box/fancy/mrebag/menu8)

/obj/random/mre/dessert
	name = "random MRE dessert"
	desc = "This is a random dessert for MREs."
	icon_state = "pouch_medium"
	spawnlist = list(/obj/item/reagent_containers/food/snacks/candy,
					 /obj/item/reagent_containers/food/snacks/cb01, //finally, a use of these outside hallowe'en
					 /obj/item/reagent_containers/food/snacks/cb02,
					 /obj/item/reagent_containers/food/snacks/cb03,
					 /obj/item/reagent_containers/food/snacks/cb04,
					 /obj/item/reagent_containers/food/snacks/cb05,
					 /obj/item/reagent_containers/food/snacks/cb06,
					 /obj/item/reagent_containers/food/snacks/cb07,
					 /obj/item/reagent_containers/food/snacks/cb08,
					 /obj/item/reagent_containers/food/snacks/cb09,
					 /obj/item/reagent_containers/food/snacks/cb10,
					 /obj/item/reagent_containers/food/snacks/proteinbar,
					 /obj/item/reagent_containers/food/snacks/donut/normal,
					 /obj/item/reagent_containers/food/snacks/donut/cherryjelly,
					 /obj/item/reagent_containers/food/snacks/chocolatebar,
					 /obj/item/reagent_containers/food/snacks/cookie,
					 /obj/item/reagent_containers/food/snacks/poppypretzel,
					 /obj/item/storage/box/fancy/gum)

/obj/random/mre/dessert/vegan
	name = "random vegan MRE dessert"
	desc = "This is a random vegan dessert for MREs."
	spawnlist = list(/obj/item/reagent_containers/food/snacks/candy,
					 /obj/item/reagent_containers/food/snacks/cb01,
					 /obj/item/reagent_containers/food/snacks/cb02,
					 /obj/item/reagent_containers/food/snacks/cb03,
					 /obj/item/reagent_containers/food/snacks/cb04,
				 	 /obj/item/reagent_containers/food/snacks/cb05,
				 	 /obj/item/reagent_containers/food/snacks/cb06,
					 /obj/item/reagent_containers/food/snacks/cb07,
				 	 /obj/item/reagent_containers/food/snacks/cb08,
					 /obj/item/reagent_containers/food/snacks/cb09,
					 /obj/item/reagent_containers/food/snacks/cb10,
					 /obj/item/reagent_containers/food/snacks/chocolatebar,
					 /obj/item/reagent_containers/food/snacks/donut/cherryjelly,
					 /obj/item/reagent_containers/food/snacks/plumphelmetbiscuit)

/obj/random/mre/drink
	name = "random MRE drink"
	desc = "This is a random drink for MREs."
	icon_state = "packet_small"
	spawnlist = list(/obj/item/reagent_containers/food/condiment/small/packet/coffee,
					 /obj/item/reagent_containers/food/condiment/small/packet/tea,
					 /obj/item/reagent_containers/food/condiment/small/packet/cocoa,
					 /obj/item/reagent_containers/food/condiment/small/packet/grape,
					 /obj/item/reagent_containers/food/condiment/small/packet/orange,
					 /obj/item/reagent_containers/food/condiment/small/packet/watermelon,
					 /obj/item/reagent_containers/food/condiment/small/packet/apple)

/obj/random/mre/spread
	name = "random MRE spread"
	desc = "This is a random spread packet for MREs."
	icon_state = "packet_small"
	spawnlist = list(/obj/item/reagent_containers/food/condiment/small/packet/jelly,
					  /obj/item/reagent_containers/food/condiment/small/packet/honey)

/obj/random/mre/spread/vegan
	name = "random vegan MRE spread"
	desc = "This is a random vegan spread packet for MREs."
	spawnlist = list(/obj/item/reagent_containers/food/condiment/small/packet/jelly)

/obj/random/mre/sauce
	name = "random MRE sauce"
	desc = "This is a random sauce packet for MREs."
	icon_state = "packet_small"
	spawnlist = list(/obj/item/reagent_containers/food/condiment/small/packet/salt,
					/obj/item/reagent_containers/food/condiment/small/packet/pepper,
					/obj/item/reagent_containers/food/condiment/small/packet/sugar,
					/obj/item/reagent_containers/food/condiment/small/packet/capsaicin,
					/obj/item/reagent_containers/food/condiment/small/packet/ketchup,
					/obj/item/reagent_containers/food/condiment/small/packet/mayo,
					/obj/item/reagent_containers/food/condiment/small/packet/soy)

/obj/random/mre/sauce/vegan
	spawnlist = list(/obj/item/reagent_containers/food/condiment/small/packet/salt,
					/obj/item/reagent_containers/food/condiment/small/packet/pepper,
					/obj/item/reagent_containers/food/condiment/small/packet/sugar,
					/obj/item/reagent_containers/food/condiment/small/packet/soy)

/obj/random/mre/sauce/sugarfree
	spawnlist = list(/obj/item/reagent_containers/food/condiment/small/packet/salt,
					/obj/item/reagent_containers/food/condiment/small/packet/pepper,
					/obj/item/reagent_containers/food/condiment/small/packet/capsaicin,
					/obj/item/reagent_containers/food/condiment/small/packet/ketchup,
					/obj/item/reagent_containers/food/condiment/small/packet/mayo,
					/obj/item/reagent_containers/food/condiment/small/packet/soy)

/obj/random/mre/sauce/crayon
	spawnlist = list(/obj/item/reagent_containers/food/condiment/small/packet/crayon,
					 /obj/item/reagent_containers/food/condiment/small/packet/crayon/red,
					 /obj/item/reagent_containers/food/condiment/small/packet/crayon/orange,
					 /obj/item/reagent_containers/food/condiment/small/packet/crayon/yellow,
					 /obj/item/reagent_containers/food/condiment/small/packet/crayon/green,
					 /obj/item/reagent_containers/food/condiment/small/packet/crayon/blue,
					 /obj/item/reagent_containers/food/condiment/small/packet/crayon/purple,
					 /obj/item/reagent_containers/food/condiment/small/packet/crayon/grey,
					 /obj/item/reagent_containers/food/condiment/small/packet/crayon/brown)

/obj/random/booze
	name = "random alcoholic drink"
	desc = "This is a random alcoholic drink."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "broken_bottle"
	spawnlist = list(
		/obj/item/reagent_containers/food/drinks/bottle/gin,
		/obj/item/reagent_containers/food/drinks/bottle/whiskey,
		/obj/item/reagent_containers/food/drinks/bottle/vodka,
		/obj/item/reagent_containers/food/drinks/bottle/tequila,
		/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing,
		/obj/item/reagent_containers/food/drinks/bottle/rum,
		/obj/item/reagent_containers/food/drinks/bottle/champagne,
		/obj/item/reagent_containers/food/drinks/bottle/vermouth,
		/obj/item/reagent_containers/food/drinks/bottle/kahlua,
		/obj/item/reagent_containers/food/drinks/bottle/cognac,
		/obj/item/reagent_containers/food/drinks/bottle/wine,
		/obj/item/reagent_containers/food/drinks/bottle/absinthe,
		/obj/item/reagent_containers/food/drinks/bottle/melonliquor,
		/obj/item/reagent_containers/food/drinks/bottle/pwine,
		/obj/item/reagent_containers/food/drinks/bottle/brandy,
		/obj/item/reagent_containers/food/drinks/bottle/guinness,
		/obj/item/reagent_containers/food/drinks/bottle/drambuie,
		/obj/item/reagent_containers/food/drinks/bottle/cremeyvette,
		/obj/item/reagent_containers/food/drinks/bottle/cremewhite,
		/obj/item/reagent_containers/food/drinks/bottle/chartreuseyellow,
		/obj/item/reagent_containers/food/drinks/bottle/chartreusegreen,
		/obj/item/reagent_containers/food/drinks/bottle/grenadine,
		/obj/item/reagent_containers/food/drinks/bottle/bluecuracao,
		/obj/item/reagent_containers/food/drinks/bottle/bitters,
		/obj/item/reagent_containers/food/drinks/bottle/champagne,
		/obj/item/reagent_containers/food/drinks/bottle/mintsyrup,
		/obj/item/reagent_containers/food/drinks/bottle/sarezhiwine,
		/obj/item/reagent_containers/food/drinks/bottle/small/beer,
		/obj/item/reagent_containers/food/drinks/bottle/small/ale,
		/obj/item/reagent_containers/food/drinks/bottle/small/xuizijuice
	)

/obj/random/keg
	name = "random alcohol keg"
	desc = "Contains a random alcohol keg."
	icon = 'icons/obj/reagent_dispensers.dmi'
	icon_state = "beertankTEMP"
	spawnlist = list(
		/obj/structure/reagent_dispensers/keg/beerkeg = 2,
		/obj/structure/reagent_dispensers/keg/xuizikeg =  0.5,
		/obj/structure/reagent_dispensers/keg/mead = 0.5
	)

/obj/random/pizzabox
	name = "random pizzabox"
	desc = "Contains a random pizzabox."
	icon = 'icons/obj/food.dmi'
	icon_state = "pizzabox1"
	spawnlist = list(
		/obj/item/pizzabox/margherita,
		/obj/item/pizzabox/vegetable,
		/obj/item/pizzabox/mushroom,
		/obj/item/pizzabox/meat,
		/obj/item/pizzabox/pineapple
	)

//Sometimes the chef will have spare oil in storage.
//Sometimes they wont, and will need to order it from cargo
//Variety is the spice of life!
/obj/random/cookingoil
	name = "random cooking oil"
	desc = "Has a 50% chance of spawning a tank of cooking oil, otherwise nothing"
	icon = 'icons/obj/reagent_dispensers.dmi'
	icon_state = "oiltank"
	spawn_nothing_percentage = 50

	spawnlist = list(
		/obj/structure/reagent_dispensers/cookingoil
	)

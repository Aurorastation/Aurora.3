/singleton/cargo_item/meat
	category = "hospitality"
	name = "meat (x5)"
	supplier = "getmore"
	description = "Slabs of real meat, from real animals. Freshly frozen and extremely not-vegan."
	price = 160
	items = list(
		/obj/item/reagent_containers/food/snacks/meat
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 5

/singleton/cargo_item/chicken
	category = "hospitality"
	name = "chicken breast (x5)"
	supplier = "getmore"
	description = "Boneless chicken breast fillets, for chicken-y recipes."
	price = 160
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/chicken
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 5

/singleton/cargo_item/synthmeat
	category = "hospitality"
	name = "synthetic meat (x5)"
	supplier = "getmore"
	description = "Slabs of synthetic meat, grown in a factory. More or less identical to the real thing, but without the animal sacrifice."
	price = 140
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 5

/singleton/cargo_item/adhomianmeat
	category = "hospitality"
	name = "adhomian meat (x5)"
	supplier = "zharkov"
	description = "A handful of meat slices from Adhomian animals. Freshly frozen."
	price = 200
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/adhomai
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 5

/singleton/cargo_item/fishfillet
	category = "hospitality"
	name = "fish fillet (x5)"
	supplier = "getmore"
	description = "Raw fish fillets, sourced from an aquaponics farm. Freshly frozen."
	price = 150
	items = list(
		/obj/item/reagent_containers/food/snacks/fish/fishfillet
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 5

/singleton/cargo_item/moghresianmeat
	category = "hospitality"
	name = "moghresian meat (x5)"
	supplier = "arizi"
	description = "Slabs of meat from animals native to Moghes. Freshly frozen."
	price = 200
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/moghes
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 5

/singleton/cargo_item/squidmeat
	category = "hospitality"
	name = "squid meat (x5)"
	supplier = "getmore"
	description = "Squid meat, meat from squid. Makes for some tasty calamari."
	price = 150
	items = list(
		/obj/item/reagent_containers/food/snacks/squidmeat
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 5

/singleton/cargo_item/wormfillet
	category = "hospitality"
	name = "worm fillet (x5)"
	supplier = "nanotrasen"
	description = "Exotic meat from a Cavern Dweller. Mildly toxic if prepared improperly."
	price = 350
	items = list(
		/obj/item/reagent_containers/food/snacks/dwellermeat
	)
	access = ACCESS_KITCHEN
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 5

/singleton/cargo_item/roesack
	category = "hospitality"
	name = "roe sack (x5)"
	supplier = "getmore"
	description = "A fleshy organ filled with fish eggs."
	price = 160
	items = list(
		/obj/item/reagent_containers/food/snacks/fish/roe
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 5

/singleton/cargo_item/crablegs_box
	category = "hospitality"
	name = "box of Silversun crab legs"
	supplier = "idris"
	description = "A box filled with high-quality crab legs from Silversun. Shipped by popular demand!"
	price = 200
	items = list(
		/obj/item/storage/box/crabmeat
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/rasvalclams_box
	category = "hospitality"
	name = "box of Ras'val clams"
	supplier = "zharkov"
	description = "A box filled with clams from the Ras'val sea, imported from Adhomai."
	price = 200
	items = list(
		/obj/item/storage/box/clams
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/producebox
	category = "hospitality"
	name = "produce box"
	supplier = "nanotrasen"
	description = "A large box of random, leftover produce."
	price = 50
	items = list(
		/obj/item/storage/box/produce
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/spacespices
	category = "hospitality"
	name = "space spices"
	supplier = "getmore"
	description = "An exotic blend of spices for cooking. It must flow."
	price = 60
	items = list(
		/obj/item/reagent_containers/food/condiment/shaker/spacespice
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/peppermill
	category = "hospitality"
	name = "pepper mill"
	supplier = "getmore"
	description = "Often used to flavor food or make people sneeze."
	price = 20
	items = list(
		/obj/item/reagent_containers/food/condiment/shaker/peppermill
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/saltshaker
	category = "hospitality"
	name = "salt shaker"
	supplier = "getmore"
	description = "Salt. From space oceans, presumably."
	price = 10
	items = list(
		/obj/item/reagent_containers/food/condiment/shaker/salt
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/barbecuesauce
	category = "hospitality"
	name = "barbecue sauce"
	supplier = "getmore"
	description = "A bottle of tangy barbecue sauce."
	price = 50
	items = list(
		/obj/item/reagent_containers/food/condiment/barbecue
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/hotsauce
	category = "hospitality"
	name = "hot sauce"
	supplier = "getmore"
	description = "A bottle of spicy hot sauce."
	price = 50
	items = list(
		/obj/item/reagent_containers/food/condiment/hot_sauce
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/garlicsauce
	category = "hospitality"
	name = "garlic sauce"
	supplier = "getmore"
	description = "A bottle of pungent garlic sauce."
	price = 50
	items = list(
		/obj/item/reagent_containers/food/condiment/garlicsauce
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/honey
	category = "hospitality"
	name = "honey"
	supplier = "vysoka"
	description = "A premium bottle of bee honey."
	price = 200
	items = list(
		/obj/item/reagent_containers/food/condiment/honey
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/soy_sauce
	category = "hospitality"
	name = "soy sauce"
	supplier = "getmore"
	description = "Savory, savory soy sauce."
	price = 50
	items = list(
		/obj/item/reagent_containers/food/condiment/soysauce
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/ketchup
	category = "hospitality"
	name = "ketchup"
	supplier = "getmore"
	description = "Tomato ketchup. The condiment that needs no introduction."
	price = 50
	items = list(
		/obj/item/reagent_containers/food/condiment/ketchup
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/mayonnaise
	category = "hospitality"
	name = "mayonnaise"
	supplier = "getmore"
	description = "A bottle of creamy mayonnaise."
	price = 50
	items = list(
		/obj/item/reagent_containers/food/condiment/mayonnaise
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/NTella_jar
	category = "hospitality"
	name = "NTella jar"
	supplier = "getmore"
	description = "A jar of popular NTella-brand hazelnut chocolate spread."
	price = 40
	items = list(
		/obj/item/reagent_containers/food/condiment/ntella
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/peanutbutterjar
	category = "hospitality"
	name = "peanut butter jar"
	supplier = "getmore"
	description = "Simultaneously smooth and chunky."
	price = 40
	items = list(
		/obj/item/reagent_containers/food/condiment/peanut_butter
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/cherryjellyjar
	category = "hospitality"
	name = "cherry jelly jar"
	supplier = "getmore"
	description = "A cherry jelly jar."
	price = 40
	items = list(
		/obj/item/reagent_containers/food/condiment/cherry_jelly
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/grapejellyjar
	category = "hospitality"
	name = "grape jelly jar"
	supplier = "getmore"
	description = "A grape jelly jar."
	price = 40
	items = list(
		/obj/item/reagent_containers/food/condiment/grape_jelly
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/triglyceridebottle
	category = "hospitality"
	name = "triglyceride bottle"
	supplier = "virgo"
	description = "A small bottle. Contains triglyceride."
	price = 50
	items = list(
		/obj/item/reagent_containers/glass/bottle/triglyceride
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/drinkingglasses_box
	category = "hospitality"
	name = "box of drinking glasses"
	supplier = "virgo"
	description = "A box of drinking glasses, for drinking purposes."
	price = 21
	items = list(
		/obj/item/storage/box/drinkingglasses
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/eggcarton
	category = "hospitality"
	name = "egg carton"
	supplier = "vysoka"
	description = "Eggs from mostly chicken."
	price = 40
	items = list(
		/obj/item/storage/box/fancy/egg_box
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/floursack
	category = "hospitality"
	name = "flour sack"
	supplier = "getmore"
	description = "A big bag of flour. Good for baking!"
	price = 50
	items = list(
		/obj/item/reagent_containers/food/condiment/flour
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/sugarsack
	category = "hospitality"
	name = "sugar sack"
	supplier = "getmore"
	description = "A big bag of sugar. Highly addictive."
	price = 40
	items = list(
		/obj/item/reagent_containers/food/condiment/sugar
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/ricesack
	category = "hospitality"
	name = "rice sack"
	supplier = "vysoka"
	description = "A big bag of rice. For all your rice needs."
	price = 50
	items = list(
		/obj/item/reagent_containers/food/condiment/rice
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/universalenzyme
	category = "hospitality"
	name = "universal enzyme"
	supplier = "getmore"
	description = "Used in cooking various dishes."
	price = 30
	items = list(
		/obj/item/reagent_containers/food/condiment/enzyme
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/milk
	category = "hospitality"
	name = "milk carton"
	supplier = "getmore"
	description = "It's milk. White and nutritious goodness!"
	price = 10
	items = list(
		/obj/item/reagent_containers/food/drinks/carton/milk
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/soymilk
	category = "hospitality"
	name = "soymilk carton"
	supplier = "getmore"
	description = "It's soy milk. White and nutritious vegan goodness!"
	price = 15
	items = list(
		/obj/item/reagent_containers/food/drinks/carton/soymilk
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/chipmultipackcrate
	category = "hospitality"
	name = "chip multipack crate"
	supplier = "getmore"
	description = "A Getmore supply crate of multipack chip bags."
	price = 400
	items = list(
		/obj/item/storage/box/fancy/chips,
		/obj/item/storage/box/fancy/chips/cucumber,
		/obj/item/storage/box/fancy/chips/chicken,
		/obj/item/storage/box/fancy/chips/dirtberry,
		/obj/item/storage/box/fancy/chips/phoron,
		/obj/item/storage/box/fancy/chips/variety
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/dryrag
	category = "hospitality"
	name = "dry rags (x5)"
	supplier = "blam"
	description = "For cleaning up messes, you suppose."
	price = 20
	items = list(
		/obj/item/reagent_containers/glass/rag,
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 5

/singleton/cargo_item/flask
	category = "hospitality"
	name = "flask"
	supplier = "virgo"
	description = "For those who can't be bothered to hang out at the bar to drink."
	price = 55
	items = list(
		/obj/item/reagent_containers/food/drinks/flask/barflask
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/goldschlager
	category = "hospitality"
	name = "Goldschlager"
	supplier = "zharkov"
	description = "A gold laced drink imported from noble houses within S'rand'marr."
	price = 460
	items = list(
		/obj/item/reagent_containers/food/drinks/bottle/goldschlager
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/burszi_ale
	category = "hospitality"
	name = "Burszi-ale"
	supplier = "getmore"
	description = "A half-dozen crate of Burszi-ale bottles, for cracking open a cold one."
	price = 220
	items = list(
		/obj/item/reagent_containers/food/drinks/bottle/small/ale
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 6

/singleton/cargo_item/beer
	category = "hospitality"
	name = "Virklunder beer (x6)"
	supplier = "getmore"
	description = "A half-dozen crate of Virklunder beers, for cracking open a cold one."
	price = 220
	items = list(
		/obj/item/reagent_containers/food/drinks/bottle/small/beer
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 6

/singleton/cargo_item/champagne
	category = "hospitality"
	name = "Silverport champagne"
	supplier = "idris"
	description = "A rather fancy bottle of champagne, fit for collecting and storing in a cellar for decades."
	price = 450
	items = list(
		/obj/item/reagent_containers/food/drinks/bottle/champagne
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/wrappartistepatron
	category = "hospitality"
	name = "Wrapp Artiste patron"
	supplier = "idris"
	description = "Silver laced tequila, served in space night clubs across the galaxy."
	price = 510
	items = list(
		/obj/item/reagent_containers/food/drinks/bottle/patron
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/sarezhiwine
	category = "hospitality"
	name = "Sarezhi Wine"
	supplier = "arizi"
	description = "A premium Moghean wine made from Sareszhi berries. Bottled by the Arizi Guild for over 200 years."
	price = 400
	items = list(
		/obj/item/reagent_containers/food/drinks/bottle/sarezhiwine
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/shaker
	category = "hospitality"
	name = "shaker"
	supplier = "virgo"
	description = "A metal shaker to mix drinks in."
	price = 85
	items = list(
		/obj/item/reagent_containers/food/drinks/shaker
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/pizzabox_margherita
	category = "hospitality"
	name = "pizza box, margherita"
	supplier = "orion"
	description = "Classic Orion Express Pizza, delivered across the galaxy piping hot and ready to eat."
	price = 50
	items = list(
		/obj/item/pizzabox/margherita
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/pizzabox_meat
	category = "hospitality"
	name = "pizza box, meat"
	supplier = "orion"
	description = "Meaty Orion Express Pizza, delivered across the galaxy piping hot and ready to eat."
	price = 50
	items = list(
		/obj/item/pizzabox/meat
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/pizzabox_mushroom
	category = "hospitality"
	name = "pizza box, mushroom"
	supplier = "orion"
	description = "Earthy Orion Express Pizza, delivered across the galaxy piping hot and ready to eat."
	price = 50
	items = list(
		/obj/item/pizzabox/mushroom
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/pizzabox_pineapple
	category = "hospitality"
	name = "pizza box, pineapple"
	supplier = "orion"
	description = "Tropical Orion Express Pizza, delivered across the galaxy piping hot and ready to eat."
	price = 50
	items = list(
		/obj/item/pizzabox/pineapple
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1
/singleton/cargo_item/pizzabox_vegetable
	category = "hospitality"
	name = "pizza box, vegetable"
	supplier = "orion"
	description = "Vegetarian Orion Express Pizza, delivered across the galaxy piping hot and ready to eat."
	price = 50
	items = list(
		/obj/item/pizzabox/vegetable
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/pizzabox_random
	category = "hospitality"
	name = "pizza box, random"
	supplier = "orion"
	description = "An order of Orion Express ready-to-eat pizza with special instructions, 'Surprise Me'."
	price = 40
	items = list(
		/obj/random/pizzabox
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/redlipstick
	category = "hospitality"
	name = "red lipstick"
	supplier = "nanotrasen"
	description = "A generic brand of lipstick."
	price = 8
	items = list(
		/obj/item/lipstick/random
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/xuizijuicekeg
	category = "hospitality"
	name = "xuizi juice keg"
	supplier = "virgo"
	description = "A keg full of Xuizi juice, blended flower buds from the Moghean Xuizi cactus. The export stamp of the Arizi Guild is imprinted on the side."
	price = 200
	items = list(
		/obj/structure/reagent_dispensers/keg/xuizikeg
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/beerkeg
	category = "hospitality"
	name = "beer keg"
	supplier = "virgo"
	description = "A keg of refreshing, intoxicating beer."
	price = 500
	items = list(
		/obj/structure/reagent_dispensers/keg/beerkeg
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/meadbarrel
	category = "hospitality"
	name = "mead barrel"
	supplier = "virgo"
	description = "A wooden mead barrel."
	price = 650
	items = list(
		/obj/structure/reagent_dispensers/keg/mead
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

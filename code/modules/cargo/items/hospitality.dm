/singleton/cargo_item/meat
	category = "hospitality"
	name = "meat (x5)"
	supplier = "getmore"
	description = "Slabs of real meat, from real animals. Freshly frozen and extremely not-vegan."
	price = 55
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
	price = 65
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
	price = 55
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
	price = 75
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
	price = 55
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
	price = 80
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
	price = 65
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
	price = 90
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
	price = 80
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
	price = 120
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
	price = 85
	items = list(
		/obj/item/storage/box/clams
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/hmatrrafillet
	category = "hospitality"
	name = "Hma'trra fillet"
	supplier = "zharkov"
	description = "A fillet of glacier worm meat."
	price = 45
	items = list(
		/obj/item/reagent_containers/food/snacks/hmatrrameat
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
	price = 35
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
	price = 15
	items = list(
		/obj/item/reagent_containers/food/condiment/shaker/spacespice
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/sliced_bread
	category = "hospitality"
	name = "sliced bread"
	supplier = "getmore"
	description = "Factory-grade, machine-baked, machine-sliced, machine-bagged bread. Just like mama used to make."
	price = 8
	items = list(
		/obj/item/storage/box/fancy/food/sliced_bread
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/packaged_shrimp
	category = "hospitality"
	name = "packaged shrimp"
	supplier = "getmore"
	description = "Frozen shrimp available at reasonable prices for any place in the Spur that can't get them fresh! Each pack contains 4 servings' worth of shrimp."
	price = 90
	items = list(
		/obj/item/storage/box/fancy/food/packaged_shrimp
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
	price = 12
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
	price = 5
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
	price = 8
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
	price = 8
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
	price = 8
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
	price = 20
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
	price = 8
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
	price = 6
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
	price = 6
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
	price = 12
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
	price = 9
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
	price = 11
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
	price = 11
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
	price = 20
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
	price = 25
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
	price = 25
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
	price = 25
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
	price = 20
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
	price = 22
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
	price = 15
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
	price = 5
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
	price = 3.50
	items = list(
		/obj/item/reagent_containers/food/drinks/carton/soymilk
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/cream
	category = "hospitality"
	name = "milk cream carton"
	supplier = "getmore"
	description = "It's cream. Made from milk. What else did you think you'd find in there?"
	price = 3.50
	items = list(
		/obj/item/reagent_containers/food/drinks/carton/cream
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/fatshouters
	category = "hospitality"
	name = "fatshouters milk carton"
	supplier = "getmore"
	description = "Fatty fatshouters milk in a carton."
	price = 8.50
	items = list(
		/obj/item/reagent_containers/food/drinks/carton/fatshouters
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/orangejuice
	category = "hospitality"
	name = "orange juice carton"
	supplier = "getmore"
	description = "Full of vitamins and deliciousness!"
	price = 4
	items = list(
		/obj/item/reagent_containers/food/drinks/carton/orangejuice
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/tomatojuice
	category = "hospitality"
	name = "tomato juice carton"
	supplier = "getmore"
	description = "Well, at least it LOOKS like tomato juice. You can't tell with all that redness."
	price = 4
	items = list(
		/obj/item/reagent_containers/food/drinks/carton/tomatojuice
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/limejuice
	category = "hospitality"
	name = "lime juice carton"
	supplier = "getmore"
	description = "Sweet-sour goodness."
	price = 4
	items = list(
		/obj/item/reagent_containers/food/drinks/carton/limejuice
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/cranberryjuice
	category = "hospitality"
	name = "cranberry juice carton"
	supplier = "getmore"
	description = "Tart and sweet. A unique flavor for a unique berry."
	price = 4
	items = list(
		/obj/item/reagent_containers/food/drinks/carton/cranberryjuice
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/lemonjuice
	category = "hospitality"
	name = "lemon juice carton"
	supplier = "getmore"
	description = "This juice is VERY sour."
	price = 4
	items = list(
		/obj/item/reagent_containers/food/drinks/carton/lemonjuice
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/dynjuice
	category = "hospitality"
	name = "dyn juice carton"
	supplier = "getmore"
	description = "Juice from a Skrell medicinal herb. It's supposed to be diluted."
	price = 4
	items = list(
		/obj/item/reagent_containers/food/drinks/carton/dynjuice
	)
	access = 0
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/applejuice
	category = "hospitality"
	name = "apple juice carton"
	supplier = "getmore"
	description = "Juice from an apple. Yes."
	price = 4
	items = list(
		/obj/item/reagent_containers/food/drinks/carton/applejuice
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
	price = 25
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
	price = 10
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
	price = 15
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
	price = 40
	items = list(
		/obj/item/reagent_containers/food/drinks/bottle/goldschlager
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/champagne
	category = "hospitality"
	name = "Silverport champagne"
	supplier = "idris"
	description = "A rather fancy bottle of champagne, fit for collecting and storing in a cellar for decades."
	price = 40
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
	price = 45
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
	price = 35
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
	price = 20
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
	price = 10
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
	price = 10
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
	price = 10
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
	price = 10
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
	price = 10
	items = list(
		/obj/item/pizzabox/vegetable
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/pizzabox_pepperoni
	category = "hospitality"
	name = "pizza box, pepperoni"
	supplier = "orion"
	description = "Traditional Orion Express Pizza, delivered across the galaxy piping hot and ready to eat."
	price = 10
	items = list(
		/obj/item/pizzabox/pepperoni
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
	price = 10
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
	price = 5
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
	price = 80
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
	price = 220
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
	price = 300
	items = list(
		/obj/structure/reagent_dispensers/keg/mead
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/beer
	category = "hospitality"
	name = "Virklunder beer (x6)"
	supplier = "getmore"
	description = "A 6-pack yoke of Virklunder beers, for cracking open a cold one."
	price = 18
	items = list(
		/obj/item/storage/box/fancy/yoke/beer
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/ebisu
	category = "hospitality"
	name = "Ebisu Super Dry rice beer (x6)"
	supplier = "getmore"
	description = "A 6-pack yoke of Ebisu Super Dry rice beer, for cracking open a cold one."
	price = 22
	items = list(
		/obj/item/storage/box/fancy/yoke/ebisu
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/shimauma
	category = "hospitality"
	name = "Shimauma Ichiban rice beer (x6)"
	supplier = "getmore"
	description = "A 6-pack yoke of Shimauma Ichiban rice beer, for cracking open a cold one."
	price = 20
	items = list(
		/obj/item/storage/box/fancy/yoke/shimauma
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/moonlabor
	category = "hospitality"
	name = "Moonlabor Malt's rice beer (x6)"
	supplier = "getmore"
	description = "A 6-pack yoke of Moonlabor Malt's rice beer, for cracking open a cold one."
	price = 18
	items = list(
		/obj/item/storage/box/fancy/yoke/moonlabor
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/earthmover
	category = "hospitality"
	name = "Inverkeithing Imports Earthmover ale (x6)"
	supplier = "getmore"
	description = "A 6-pack yoke of Inverkeithing Imports Earthmover ale, for cracking open a cold one."
	price = 21
	items = list(
		/obj/item/storage/box/fancy/yoke/earthmover
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/whistlingforest
	category = "hospitality"
	name = "Whistling Forest Pale Ale (x6)"
	supplier = "getmore"
	description = "A 6-pack yoke of Whistling Forest Pale Ale, for cracking open a cold one."
	price = 23
	items = list(
		/obj/item/storage/box/fancy/yoke/whistlingforest
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/cola
	category = "hospitality"
	name = "Comet Cola (x6)"
	supplier = "getmore"
	description = "A 6-pack yoke of Comet Cola for cracking open a cold one."
	price = 8
	items = list(
		/obj/item/storage/box/fancy/yoke/cola
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/space_mountain_wind
	category = "hospitality"
	name = "Stellar Jolt (x6)"
	supplier = "getmore"
	description = "A 6-pack yoke of Stellar Jolt for cracking open a cold one."
	price = 8
	items = list(
		/obj/item/storage/box/fancy/yoke/space_mountain_wind
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/thirteenloko
	category = "hospitality"
	name = "Getmore Energy (x6)"
	supplier = "getmore"
	description = "A 6-pack yoke of Getmore Energy for cracking open a cold one."
	price = 8
	items = list(
		/obj/item/storage/box/fancy/yoke/thirteenloko
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/dr_gibb
	category = "hospitality"
	name = "Getmore Root-Cola (x6)"
	supplier = "getmore"
	description = "A 6-pack yoke of Getmore Root-Cola for cracking open a cold one."
	price = 8
	items = list(
		/obj/item/storage/box/fancy/yoke/dr_gibb
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/starkist
	category = "hospitality"
	name = "Orange Starshine (x6)"
	supplier = "getmore"
	description = "A 6-pack yoke of Orange Starshine for cracking open a cold one."
	price = 8
	items = list(
		/obj/item/storage/box/fancy/yoke/starkist
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/vacuum_fizz
	category = "hospitality"
	name = "Vacuum Fizz (x6)"
	supplier = "getmore"
	description = "A 6-pack yoke of Vacuum Fizz for cracking open a cold one."
	price = 8
	items = list(
		/obj/item/storage/box/fancy/yoke/space_up
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/lemon_lime
	category = "hospitality"
	name = "Lemon-Lime soda (x6)"
	supplier = "getmore"
	description = "A 6-pack yoke of Lemon-Lime for cracking open a cold one."
	price = 8
	items = list(
		/obj/item/storage/box/fancy/yoke/lemon_lime
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/iced_tea
	category = "hospitality"
	name = "Silversun Wave Iced Tea (x6)"
	supplier = "getmore"
	description = "A 6-pack yoke of Silversun Wave Iced Tea for cracking open a cold one."
	price = 8
	items = list(
		/obj/item/storage/box/fancy/yoke/iced_tea
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/grape_juice
	category = "hospitality"
	name = "Grapel Juice (x6)"
	supplier = "getmore"
	description = "A 6-pack yoke of Grapel Juice for cracking open a cold one."
	price = 8
	items = list(
		/obj/item/storage/box/fancy/yoke/grape_juice
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/tonic
	category = "hospitality"
	name = "T-Borg's Tonic Water (x6)"
	supplier = "getmore"
	description = "A 6-pack yoke of T-Borg's Tonic Water for cracking open a cold one."
	price = 8
	items = list(
		/obj/item/storage/box/fancy/yoke/tonic
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/sodawater
	category = "hospitality"
	name = "Soda Water (x6)"
	supplier = "getmore"
	description = "A 6-pack yoke of Soda Water for cracking open a cold one."
	price = 8
	items = list(
		/obj/item/storage/box/fancy/yoke/sodawater
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/root_beer
	category = "hospitality"
	name = "Getmore Root Beer (x6)"
	supplier = "getmore"
	description = "A 6-pack yoke of Getmore Root Beer for cracking open a cold one."
	price = 8
	items = list(
		/obj/item/storage/box/fancy/yoke/root_beer
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/diet_cola
	category = "hospitality"
	name = "Diet Comet Cola (x6)"
	supplier = "getmore"
	description = "A 6-pack yoke of Diet Comet Cola for cracking open a cold one."
	price = 8
	items = list(
		/obj/item/storage/box/fancy/yoke/diet_cola
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/peach_soda
	category = "hospitality"
	name = "Xanu Rush! Peach Soda (x6)"
	supplier = "getmore"
	description = "A 6-pack yoke of Xanu Rush! Peach Soda for cracking open a cold one."
	price = 8
	items = list(
		/obj/item/storage/box/fancy/yoke/peach_soda
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/melon_soda
	category = "hospitality"
	name = "Kansumi Melon Soda (x6)"
	supplier = "getmore"
	description = "A 6-pack yoke of Kansumi Melon Soda for cracking open a cold one."
	price = 8
	items = list(
		/obj/item/storage/box/fancy/yoke/melon_soda
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/himeokvass
	category = "hospitality"
	name = "Dorshafen Deluxe Kvass (x6)"
	supplier = "getmore"
	description = "A 6-pack yoke of Dorshafen Deluxe Kvass for cracking open a cold one."
	price = 22
	items = list(
		/obj/item/storage/box/fancy/yoke/himeokvass
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/xanuchai
	category = "hospitality"
	name = "Brown Palace Champion Chai (x6)"
	supplier = "getmore"
	description = "A 6-pack yoke of Brown Palace Champion Chai for cracking open a cold one."
	price = 10
	items = list(
		/obj/item/storage/box/fancy/yoke/xanuchai
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/beetle_milk
	category = "hospitality"
	name = "Hakhma Beetle Milk (x6)"
	supplier = "getmore"
	description = "A 6-pack yoke of Hakhma Beetle Milk for cracking open a cold one."
	price = 8
	items = list(
		/obj/item/storage/box/fancy/yoke/beetle_milk
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/burszi_ale
	category = "hospitality"
	name = "Burszi-ale (x6)"
	supplier = "getmore"
	description = "A half-dozen pack of Burszi-ale bottles, for cracking open a cold one."
	price = 22
	items = list(
		/obj/item/storage/box/ale
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/beer
	category = "hospitality"
	name = "Virklunder Beer (x6)"
	supplier = "getmore"
	description = "A half-dozen pack of Virklunder beers, for cracking open a cold one."
	price = 17
	items = list(
		/obj/item/storage/box/beer
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/skrellbeerdyn
	category = "hospitality"
	name = "Qel'Zvol Hospitality's Prestige Dyn Beer (x6)"
	supplier = "getmore"
	description = "A half-dozen pack of Qel'Zvol Hospitality's Prestige dyn beers, for cracking open a cold one."
	price = 21
	items = list(
		/obj/item/storage/box/skrellbeerdyn
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/xuizijuice
	category = "hospitality"
	name = "Xuizi Juice (x6)"
	supplier = "getmore"
	description = "A half-dozen pack of Xuiji Juice, for cracking open a cold one."
	price = 14
	items = list(
		/obj/item/storage/box/xuizijuice
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/khlibnyz
	category = "hospitality"
	name = "Khlibnyz (x6)"
	supplier = "getmore"
	description = "A half-dozen pack of Khlibnyz, for cracking open a cold one."
	price = 12
	items = list(
		/obj/item/storage/box/khlibnyz
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/cola_bottle
	category = "hospitality"
	name = "Comet Cola Bottles (x6)"
	supplier = "getmore"
	description = "A half-dozen pack of Comet Cola, for cracking open a cold one."
	price = 8
	items = list(
		/obj/item/storage/box/cola
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/space_mountain_wind_bottle
	category = "hospitality"
	name = "Stellar Jolt Bottles (x6)"
	supplier = "getmore"
	description = "A half-dozen pack of Stellar Jolt, for cracking open a cold one."
	price = 8
	items = list(
		/obj/item/storage/box/space_mountain_wind
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/space_up_bottle
	category = "hospitality"
	name = "Space Up Bottles (x6)"
	supplier = "getmore"
	description = "A half-dozen pack of Space Up, for cracking open a cold one."
	price = 8
	items = list(
		/obj/item/storage/box/space_up
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/hrozamal_soda
	category = "hospitality"
	name = "Hrozamal Soda (x6)"
	supplier = "getmore"
	description = "A half-dozen pack of Hrozamal Soda, for cracking open a cold one."
	price = 12
	items = list(
		/obj/item/storage/box/hrozamal_soda
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/midynhr_water
	category = "hospitality"
	name = "Midynhr Water (x6)"
	supplier = "getmore"
	description = "A half-dozen pack of Midynhr Water, for cracking open a cold one."
	price = 18
	items = list(
		/obj/item/storage/box/midynhr_water
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/dental_hygiene
	category = "hospitality"
	name = "Dental Hygiene Kit"
	supplier = "getmore"
	description = "A box containing a toothbrush, a tube of toothpaste, and a bottle of mouthwash."
	price = 25
	items = list(
		/obj/item/storage/box/toothpaste
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/sencha
	category = "hospitality"
	name = "Sencha Tins (x7)"
	supplier = "getmore"
	description = "A box containing some tins of green tea leaves."
	price = 20
	items = list(
		/obj/item/storage/box/tea
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/tieguanyin
	category = "hospitality"
	name = "Tieguanyin-cha Tins (x7)"
	supplier = "getmore"
	description = "A box containing some tins of oolong tea leaves."
	price = 20
	items = list(
		/obj/item/storage/box/tea/tieguanyin
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/jaekseol
	category = "hospitality"
	name = "Jaeksol-cha Tins (x7)"
	supplier = "getmore"
	description = "A box containing some tins of black tea leaves."
	price = 20
	items = list(
		/obj/item/storage/box/tea/jaekseol
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/vkrexi_organ
	category = "hospitality"
	name = "V'krexi Swollen Organ"
	supplier = "getmore"
	description = "A traditional Sedantian alcoholic drink, packaged in the stomach it's fermented in."
	price = 50
	items = list(
		/obj/item/storage/box/fancy/vkrexi_swollen_organ
	)
	access = 0
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/dominian_wine
	category = "hospitality"
	name = "Jadrani Consecrated Geneboosted Wine"
	supplier = "getmore"
	description = "A bottle of artisanally-crafted, highly sought-after Dominian red wine. Sanctified and exported via House Caladius."
	price = 50
	items = list(
		/obj/item/reagent_containers/food/drinks/bottle/dominian_wine
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/algae_wine
	category = "hospitality"
	name = "Reacher's Triumph 2423 Algae Wine"
	supplier = "getmore"
	description = "A bottle of wine, brewed from algae, made in the traditional style of the Imperial Viceroyalty of Sun Reach, a Dominian frontier-world."
	price = 50
	items = list(
		/obj/item/reagent_containers/food/drinks/bottle/algae_wine
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/assunzione_wine
	category = "hospitality"
	name = "\improper Assunzioni Sera Stellata di Dalyan Wine"
	supplier = "getmore"
	description = "A bottle of velvety smooth red wine from the underground vineyards of Dalyan, Assunzione."
	price = 50
	items = list(
		/obj/item/reagent_containers/food/drinks/bottle/assunzione_wine
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/skrellwineylpha
	category = "hospitality"
	name = "Federation's Finest Ylpha Wine"
	supplier = "getmore"
	description = "A popular type of Skrell wine made from fermented ylpha berries."
	price = 30
	items = list(
		/obj/item/reagent_containers/food/drinks/bottle/skrellwineylpha
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/mushroomvodka
	category = "hospitality"
	name = "Inverkeithing Import Mushroom Vodka"
	supplier = "getmore"
	description = "A mushroom-based vodka imported from the breweries of Inverkeithing on Himeo."
	price = 35
	items = list(
		/obj/item/reagent_containers/food/drinks/bottle/vodka/mushroom
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/victorygin
	category = "hospitality"
	name = "Victory Gin"
	supplier = "getmore"
	description = "A Tajaran gin considered to be the official drink of the People's Republic of Adhomai."
	price = 25
	items = list(
		/obj/item/reagent_containers/food/drinks/bottle/victorygin
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/sugartree_liquor
	category = "hospitality"
	name = "Sugar Tree Liquor"
	supplier = "getmore"
	description = "Called Nm'shaan Liquor in native Siik'maas, this strong Adhomian liquor is reserved for special occasions. A label on the bottle recommends diluting it with icy water before drinking."
	price = 35
	items = list(
		/obj/item/reagent_containers/food/drinks/bottle/sugartree_liquor
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/messa_mead
	category = "hospitality"
	name = "messa's mead"
	supplier = "getmore"
	description = "A bottle of Messa's mead. Bottled somewhere in the icy world of Adhomai."
	price = 30
	items = list(
		/obj/item/reagent_containers/food/drinks/bottle/messa_mead
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/kvass
	category = "hospitality"
	name = "Neubach Original Kvass"
	supplier = "getmore"
	description = "A bottle of authentic Fisanduhian kvass, a cereal alcohol."
	price = 20
	items = list(
		/obj/item/reagent_containers/food/drinks/bottle/kvass
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/tarasun
	category = "hospitality"
	name = "Frostdancer Distillery Tarasun"
	supplier = "getmore"
	description = "A bottle of Lyodii tarasun, an alcoholic beverage made from tenelote milk."
	price = 25
	items = list(
		/obj/item/reagent_containers/food/drinks/bottle/tarasun
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/valokki_wine
	category = "hospitality"
	name = "Frostdancer Distillery Valokki Wine"
	supplier = "getmore"
	description = "A bottle of wine distilled from the Morozi cloudberry."
	price = 42
	items = list(
		/obj/item/reagent_containers/food/drinks/bottle/valokki_wine
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/twentytwoseventyfive
	category = "hospitality"
	name = "2275 Classic Brandy"
	supplier = "getmore"
	description = "A bottle of Xanan mid-range brandy."
	price = 35
	items = list(
		/obj/item/reagent_containers/food/drinks/bottle/twentytwoseventyfive
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/saintjacques
	category = "hospitality"
	name = "Saint-Jacques Black Label Cognac"
	supplier = "getmore"
	description = "An expensive bottle of Saint-Jacques Black Label, a Xanan luxury cognac."
	price = 40
	items = list(
		/obj/item/reagent_containers/food/drinks/bottle/saintjacques
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/nemiik
	category = "hospitality"
	name = "Vrozka Farms Ne'miik"
	supplier = "getmore"
	description = "A bottle of Ne'miik under the label 'Vrozka Farms' from Caprice. The Vaurcan analogue for milk."
	price = 12
	items = list(
		/obj/item/reagent_containers/food/drinks/bottle/nemiik
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/ogogoro
	category = "hospitality"
	name = "Ogogoro Jar"
	supplier = "getmore"
	description = "A traditional Eridani palm wine drink, stored in a mason jar."
	price = 16
	items = list(
		/obj/item/reagent_containers/food/drinks/bottle/ogogoro
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

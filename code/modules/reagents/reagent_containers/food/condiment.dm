
///////////////////////////////////////////////Condiments
//Notes by Darem: The condiments food-subtype is for stuff you don't actually eat but you use to modify existing food. They all
//	leave empty containers when used up and can be filled/re-filled with other items. Formatting for first section is identical
//	to mixed-drinks code. If you want an object that starts pre-loaded, you need to make it in addition to the other code.

//Food items that aren't eaten normally and leave an empty container behind.
/obj/item/reagent_containers/food/condiment
	name = "condiment container"
	desc = "Just your average condiment container."
	icon = 'icons/obj/item/reagent_containers/food/condiment.dmi'
	icon_state = "emptycondiment"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	possible_transfer_amounts = list(1,5,10)
	center_of_mass = list("x"=16, "y"=6)
	volume = 50
	var/next_shake
	var/fixed_state = FALSE

/obj/item/reagent_containers/food/condiment/Initialize(var/force = TRUE)
	. = ..()
	on_reagent_change(force)

/obj/item/reagent_containers/food/condiment/proc/shake(var/mob/user)
	if(world.time >= next_shake)
		if(reagents.total_volume > 0)
			user.visible_message(pick(SPAN_NOTICE("[user] shakes [src]."), SPAN_NOTICE("[user] gives [src] a good shake.")), SPAN_NOTICE("You give [src] a good shake."))
			playsound(get_turf(src),'sound/items/condiment_shaking.ogg', rand(10,50), 1)
		else
			user.visible_message(pick(SPAN_NOTICE("[user] shakes [src], but it makes no noise."), SPAN_NOTICE("[user] gives [src] a good shake, but it makes no noise.")), SPAN_NOTICE("You give [src] a good shake, but it makes no noise."))
		next_shake = world.time + 30

/obj/item/reagent_containers/food/condiment/feed_sound(var/mob/user)
	playsound(user.loc, 'sound/items/drink.ogg', rand(10, 50), 1)

/obj/item/reagent_containers/food/condiment/self_feed_message(var/mob/user)
	to_chat(user, SPAN_NOTICE("You swallow some of the contents of [src]."))

/obj/item/reagent_containers/food/condiment/on_reagent_change(var/force = FALSE)
	if(fixed_state && !force)
		return
	if(isemptylist(reagents.reagent_volumes))
		name = "condiment bottle"
		desc = "An empty condiment bottle."
		return

	var/singleton/reagent/master = reagents.get_primary_reagent_decl()
	name = master.condiment_name || (reagents.reagent_volumes.len == 1 ? "[lowertext(master.name)] bottle" : "condiment bottle")
	desc = master.condiment_desc || (reagents.reagent_volumes.len == 1 ? master.description : "A mixture of various condiments. [master.name] is one of them.")
	icon = master.condiment_icon || 'icons/obj/item/reagent_containers/food/condiment.dmi'
	icon_state = master.condiment_icon_state || "mixedcondiments"
	center_of_mass = master.condiment_center_of_mass || list("x"=16, "y"=6)

/obj/item/reagent_containers/food/condiment/enzyme
	icon_state = "enzyme" // for map preview
	fixed_state = TRUE
	reagents_to_add = list(/singleton/reagent/enzyme = 50)

/obj/item/reagent_containers/food/condiment/sugar
	icon_state = "sugar"
	fixed_state = TRUE
	reagents_to_add = list(/singleton/reagent/sugar = 50)

/obj/item/reagent_containers/food/condiment/shaker
	name = "shaker"
	empty_icon_state = "emptyshaker"
	volume = 20
	center_of_mass = list("x"=17, "y"=11)
	amount_per_transfer_from_this = 1

/obj/item/reagent_containers/food/condiment/shaker/Initialize()
	. = ..()
	possible_transfer_amounts = list(1, volume)

/obj/item/reagent_containers/food/condiment/shaker/attack_self(mob/user)
	shake(user)

/obj/item/reagent_containers/food/condiment/shaker/salt
	icon_state = "saltshakersmall"
	reagents_to_add = list(/singleton/reagent/sodiumchloride = 20)

/obj/item/reagent_containers/food/condiment/shaker/peppermill
	icon_state = "peppermillsmall"
	reagents_to_add = list(/singleton/reagent/blackpepper = 20)

/obj/item/reagent_containers/food/condiment/shaker/diona
	icon_state = "dionaepowder"
	reagents_to_add = list(/singleton/reagent/diona_powder = 20)

/obj/item/reagent_containers/food/condiment/shaker/spacespice
	icon_state = "spacespicebottle"
	volume = 40
	reagents_to_add = list(/singleton/reagent/spacespice = 40)

/obj/item/reagent_containers/food/condiment/shaker/sprinkles
	icon_state = "sprinklesbottle"
	volume = 40
	reagents_to_add = list(/singleton/reagent/nutriment/sprinkles = 40)

/obj/item/reagent_containers/food/condiment/shaker/pumpkinspice
	icon_state = "spacespicebottle"
	volume = 40
	reagents_to_add = list(/singleton/reagent/spacespice/pumpkinspice = 40)

/obj/item/reagent_containers/food/condiment/flour
	name = "flour sack"
	desc = "A big bag of flour. Good for baking!"
	icon_state = "flour"
	center_of_mass = list("x"=16, "y"=8)
	volume = 220
	fixed_state = TRUE
	reagents_to_add = list(/singleton/reagent/nutriment/flour = 200)

/obj/item/reagent_containers/food/condiment/barbecue
	icon_state = "barbecue"
	fixed_state = TRUE
	name = "barbecue sauce"
	reagents_to_add = list(/singleton/reagent/nutriment/barbecue = 20)

/obj/item/reagent_containers/food/condiment/garlicsauce
	icon_state = "garlic_sauce"
	fixed_state = TRUE
	name = "garlic sauce"
	reagents_to_add = list(/singleton/reagent/nutriment/garlicsauce = 50)

/obj/item/reagent_containers/food/condiment/pacid
	name = "culinary acid"
	reagents_to_add = list(/singleton/reagent/acid/polyacid = 50)

/obj/item/reagent_containers/food/condiment/honey
	icon_state = "honey"
	fixed_state = TRUE
	name = "honey"
	reagents_to_add = list(/singleton/reagent/nutriment/honey = 50)

/obj/item/reagent_containers/food/condiment/soysauce
	icon_state = "soysauce"
	fixed_state = TRUE
	name = "soy sauce"
	reagents_to_add = list(/singleton/reagent/nutriment/soysauce = 50)

/obj/item/reagent_containers/food/condiment/ketchup
	icon_state = "ketchup"
	fixed_state = TRUE
	name = "ketchup"
	reagents_to_add = list(/singleton/reagent/nutriment/ketchup = 50)

/obj/item/reagent_containers/food/condiment/mayonnaise
	icon_state = "mayonnaise"
	fixed_state = TRUE
	name = "mayonnaise"
	reagents_to_add = list(/singleton/reagent/nutriment/mayonnaise = 50)

/obj/item/reagent_containers/food/condiment/ntella
	icon_state = "NTellajar"
	fixed_state = TRUE
	name = "NTella jar"
	reagents_to_add = list(/singleton/reagent/nutriment/choconutspread = 50)

/obj/item/reagent_containers/food/condiment/peanut_butter
	icon_state = "pbjar"
	fixed_state = TRUE
	name = "peanut butter jar"
	reagents_to_add = list(/singleton/reagent/nutriment/peanutbutter = 50)

/obj/item/reagent_containers/food/condiment/cherry_jelly
	icon_state = "jellyjar"
	fixed_state = TRUE
	name = "cherry jelly jar"
	reagents_to_add = list(/singleton/reagent/nutriment/cherryjelly = 50)

/obj/item/reagent_containers/food/condiment/hot_sauce
	icon_state = "hotsauce"
	name = "hot sauce"
	fixed_state = TRUE
	reagents_to_add = list(/singleton/reagent/capsaicin = 50)

/obj/item/reagent_containers/food/condiment/grape_jelly
	icon_state = "grapejelly"
	fixed_state = TRUE
	name = "grape jelly jar"
	reagents_to_add = list(/singleton/reagent/nutriment/grapejelly = 50)

/obj/item/reagent_containers/food/condiment/syrup_simple
	icon_state = "syrup_simple"
	fixed_state = TRUE
	name = "simple syrup"
	reagents_to_add = list(/singleton/reagent/condiment/syrup_simple = 50)

/obj/item/reagent_containers/food/condiment/syrup_chocolate
	icon_state = "syrup_chocolate"
	fixed_state = TRUE
	name = "chocolate syrup"
	reagents_to_add = list(/singleton/reagent/condiment/syrup_chocolate = 50)

/obj/item/reagent_containers/food/condiment/syrup_strawberry
	icon_state = "syrup_strawberry"
	fixed_state = TRUE
	name = "strawberry syrup"
	reagents_to_add = list(/singleton/reagent/condiment/syrup_strawberry = 50)

/obj/item/reagent_containers/food/condiment/syrup_strawberry
	icon_state = "syrup_strawberry"
	fixed_state = TRUE
	name = "strawberry syrup"
	reagents_to_add = list(/singleton/reagent/condiment/syrup_strawberry = 50)

/obj/item/reagent_containers/food/condiment/syrup_berry
	icon_state = "syrup_berry"
	fixed_state = TRUE
	name = "berry syrup"
	reagents_to_add = list(/singleton/reagent/condiment/syrup_berry = 50)

/obj/item/reagent_containers/food/condiment/syrup_raspberry
	icon_state = "syrup_raspberry"
	fixed_state = TRUE
	name = "raspberry syrup"
	reagents_to_add = list(/singleton/reagent/condiment/syrup_raspberry = 50)

/obj/item/reagent_containers/food/condiment/syrup_blueberry
	icon_state = "syrup_blueberry"
	fixed_state = TRUE
	name = "blueberry syrup"
	reagents_to_add = list(/singleton/reagent/condiment/syrup_blueberry = 50)

/obj/item/reagent_containers/food/condiment/syrup_blue_raspberry
	icon_state = "syrup_blue_raspberry"
	fixed_state = TRUE
	name = "blue raspberry syrup"
	reagents_to_add = list(/singleton/reagent/condiment/syrup_blueberry = 50)

/obj/item/reagent_containers/food/condiment/syrup_ylphaberry
	icon_state = "syrup_ylpha"
	fixed_state = TRUE
	name = "ylpha berry syrup"
	reagents_to_add = list(/singleton/reagent/condiment/syrup_ylphaberry = 50)

/obj/item/reagent_containers/food/condiment/syrup_caramel
	icon_state = "syrup_caramel"
	fixed_state = TRUE
	name = "caramel syrup"
	reagents_to_add = list(/singleton/reagent/condiment/syrup_caramel = 50)

/obj/item/reagent_containers/food/condiment/syrup_pumpkin
	icon_state = "syrup_pumpkin"
	fixed_state = TRUE
	name = "pumpkin syrup"
	reagents_to_add = list(/singleton/reagent/condiment/syrup_pumpkin = 50)

/obj/item/reagent_containers/food/condiment/syrup_vanilla
	icon_state = "syrup_vanilla"
	fixed_state = TRUE
	name = "vanilla syrup"
	reagents_to_add = list(/singleton/reagent/condiment/syrup_vanilla = 50)

/obj/item/reagent_containers/food/condiment/syrup_dirtberry
	icon_state = "syrup_dirtberry"
	fixed_state = TRUE
	name = "dirtberry syrup"
	reagents_to_add = list(/singleton/reagent/condiment/syrup_dirtberry = 50)

/obj/item/reagent_containers/food/condiment/gelatin
	icon_state = "gello"
	fixed_state = TRUE
	name = "gelatin"
	reagents_to_add = list(/singleton/reagent/nutriment/gelatin = 50)

/obj/item/reagent_containers/food/condiment/batter
	icon_state = "batter"
	fixed_state = TRUE
	name = "batter mix"
	reagents_to_add = list(/singleton/reagent/nutriment/coating/batter = 50)

/obj/item/reagent_containers/food/condiment/vanilla
	icon_state = "vanilla"
	fixed_state = TRUE
	name = "vanilla extract"
	reagents_to_add = list(/singleton/reagent/nutriment/vanilla = 50)

/obj/item/reagent_containers/food/condiment/rice
	name = "rice sack"
	desc = "A big bag of rice. Good for cooking!"
	icon_state = "rice"
	center_of_mass = list("x"=16, "y"=8)
	volume = 220
	fixed_state = TRUE
	reagents_to_add = list(/singleton/reagent/nutriment/rice = 200)

/obj/item/reagent_containers/food/condiment/cocoa //not exactly a condiment, but not exactly NOT a condiment, right?
	icon_state = "cocoapowder"
	fixed_state = TRUE
	name = "cocoa powder"
	reagents_to_add = list(/singleton/reagent/nutriment/coco = 50)

/obj/item/reagent_containers/food/condiment/blood
	fixed_state = TRUE
	name = "synthetic blood"
	reagents_to_add = list(/singleton/reagent/blood = 50)

//MRE condiments and drinks.

/obj/item/reagent_containers/food/condiment/small/packet
	icon_state = "packet_small"
	fixed_state = TRUE
	w_class = WEIGHT_CLASS_TINY
	possible_transfer_amounts = list(1,5,10)
	amount_per_transfer_from_this = 1
	volume = 10

/obj/item/reagent_containers/food/condiment/small/packet/Initialize()
	. = ..(FALSE)

/obj/item/reagent_containers/food/condiment/small/packet/salt
	name = "salt packet"
	desc = "Contains 5u of table salt."
	icon_state = "packet_small_white"
	reagents_to_add = list(/singleton/reagent/sodiumchloride = 5)

/obj/item/reagent_containers/food/condiment/small/packet/pepper
	name = "pepper packet"
	desc = "Contains 5u of black pepper."
	icon_state = "packet_small_black"
	reagents_to_add = list(/singleton/reagent/blackpepper = 5)

/obj/item/reagent_containers/food/condiment/small/packet/sugar
	name = "sugar packet"
	desc = "Contains 5u of refined sugar."
	icon_state = "packet_small_white"
	reagents_to_add = list(/singleton/reagent/sugar = 5)

/obj/item/reagent_containers/food/condiment/small/packet/jelly
	name = "jelly packet"
	desc = "Contains 10u of cherry jelly. Best used for spreading on crackers."
	reagents_to_add = list(/singleton/reagent/nutriment/cherryjelly = 10)
	icon_state = "packet_medium"

/obj/item/reagent_containers/food/condiment/small/packet/honey
	name = "honey packet"
	desc = "Contains 10u of honey."
	reagents_to_add = list(/singleton/reagent/sugar = 10)
	icon_state = "packet_medium"

/obj/item/reagent_containers/food/condiment/small/packet/capsaicin
	name = "hot sauce packet"
	desc = "Contains 5u of hot sauce. Enjoy in moderation."
	icon_state = "packet_small_red"
	reagents_to_add = list(/singleton/reagent/capsaicin = 5)

/obj/item/reagent_containers/food/condiment/small/packet/ketchup
	name = "ketchup packet"
	desc = "Contains 5u of ketchup."
	icon_state = "packet_small_red"
	reagents_to_add = list(/singleton/reagent/nutriment/ketchup = 5)

/obj/item/reagent_containers/food/condiment/small/packet/mayo
	name = "mayonnaise packet"
	desc = "Contains 5u of mayonnaise."
	icon_state = "packet_small_white"
	reagents_to_add = list(/singleton/reagent/nutriment/mayonnaise = 5)

/obj/item/reagent_containers/food/condiment/small/packet/soy
	name = "soy sauce packet"
	desc = "Contains 5u of soy sauce."
	icon_state = "packet_small_black"
	reagents_to_add = list(/singleton/reagent/nutriment/soysauce = 5)

/obj/item/reagent_containers/food/condiment/small/packet/coffee
	name = "instant coffee powder packet"
	desc = "Contains 5u of instant coffee powder. Mix with 25u of water."
	reagents_to_add = list(/singleton/reagent/nutriment/coffeegrounds = 3)

/obj/item/reagent_containers/food/condiment/small/packet/tea
	name = "instant tea powder packet"
	desc = "Contains 5u of instant black tea powder. Mix with 25u of water."
	reagents_to_add = list(/singleton/reagent/nutriment/teagrounds = 5)

/obj/item/reagent_containers/food/condiment/small/packet/cocoa
	name = "cocoa powder packet"
	desc = "Contains 5u of cocoa powder. Mix with 25u of water and heat."
	reagents_to_add = list(/singleton/reagent/nutriment/coco = 5)

/obj/item/reagent_containers/food/condiment/small/packet/grape
	name = "grape juice powder packet"
	desc = "Contains 5u of powdered grape juice. Mix with 15u of water."
	reagents_to_add = list(/singleton/reagent/nutriment/instantjuice/grape = 5)

/obj/item/reagent_containers/food/condiment/small/packet/orange
	name = "orange juice powder packet"
	desc = "Contains 5u of powdered orange juice. Mix with 15u of water."
	reagents_to_add = list(/singleton/reagent/nutriment/instantjuice/orange = 5)

/obj/item/reagent_containers/food/condiment/small/packet/watermelon
	name = "watermelon juice powder packet"
	desc = "Contains 5u of powdered watermelon juice. Mix with 15u of water."
	reagents_to_add = list(/singleton/reagent/nutriment/instantjuice/watermelon = 5)

/obj/item/reagent_containers/food/condiment/small/packet/apple
	name = "apple juice powder packet"
	desc = "Contains 5u of powdered apple juice. Mix with 15u of water."
	reagents_to_add = list(/singleton/reagent/nutriment/instantjuice/apple = 5)

/obj/item/reagent_containers/food/condiment/small/packet/protein
	name = "protein powder packet"
	desc = "Contains 10u of powdered protein. Mix with 20u of water."
	icon_state = "packet_medium"
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 10)

/obj/item/reagent_containers/food/condiment/small/packet/crayon
	name = "crayon powder packet"
	desc = "Contains 10u of powdered crayon. Mix with 30u of water."
	reagents_to_add = list(/singleton/reagent/crayon_dust = 10)

/obj/item/reagent_containers/food/condiment/small/packet/crayon/red
	reagents_to_add = list(/singleton/reagent/crayon_dust/red = 10)

/obj/item/reagent_containers/food/condiment/small/packet/crayon/orange
	reagents_to_add = list(/singleton/reagent/crayon_dust/orange = 10)

/obj/item/reagent_containers/food/condiment/small/packet/crayon/yellow
	reagents_to_add = list(/singleton/reagent/crayon_dust/yellow = 10)

/obj/item/reagent_containers/food/condiment/small/packet/crayon/green
	reagents_to_add = list(/singleton/reagent/crayon_dust/green = 10)

/obj/item/reagent_containers/food/condiment/small/packet/crayon/blue
	reagents_to_add = list(/singleton/reagent/crayon_dust/blue = 10)

/obj/item/reagent_containers/food/condiment/small/packet/crayon/purple
	reagents_to_add = list(/singleton/reagent/crayon_dust/purple = 10)

/obj/item/reagent_containers/food/condiment/small/packet/crayon/grey
	reagents_to_add = list(/singleton/reagent/crayon_dust/grey = 10)

/obj/item/reagent_containers/food/condiment/small/packet/crayon/brown
	reagents_to_add = list(/singleton/reagent/crayon_dust/brown = 10)

/obj/item/reagent_containers/food/condiment/small/packet/toothpaste
	name = "toothpaste packet"
	desc = "Contains 5u of toothpaste."
	icon_state = "packet_small_white"
	reagents_to_add = list(/singleton/reagent/drink/toothpaste = 5)

/obj/item/reagent_containers/food/condiment/small/packet/phoron
	name = "phoron packet"
	desc = "Contains 5u of phoron."
	icon_state = "packet_small_yellow"
	reagents_to_add = list(/singleton/reagent/toxin/phoron = 5)

/obj/item/reagent_containers/food/condiment/sweet_chili
	icon_state = "sweet_chili"
	name = "sweet chili"
	empty_icon_state = "sweet_chili_empty"
	reagents_to_add = list(/singleton/reagent/nutriment/sweet_chili = 50)
	amount_per_transfer_from_this = 1

/obj/item/reagent_containers/food/condiment/wulumunusha
	name = "wulumunusha extract bottle"
	desc = "A small dropper bottle full of a stoner's paradise. A warning label warns of muteness as a side effect."
	icon_state = "wuluextract"
	fixed_state = TRUE
	reagents_to_add = list(/singleton/reagent/wulumunusha = 30)

/obj/item/reagent_containers/food/condiment/ambrosia
	name = "ambrosia extract bottle"
	desc = "A small dropper bottle full of a stoner's paradise. The label warns of lethargy and confusion as a side effect, and cautions against operating heavy machinery while under the influence."
	icon_state = "ambrosiaextract"
	fixed_state = TRUE
	reagents_to_add = list(/singleton/reagent/drugs/ambrosia_extract = 30)

/obj/item/reagent_containers/food/condiment/diet_diesel
	name = "diet diesel bottle"
	desc = "A Hephaestus-trademarked jar, containing some kind of unpleasant-smelling gray sludge. The label says it's for Diona-based consumption only."
	icon_state = "dietdiesel"
	fixed_state = TRUE
	reagents_to_add = list(/singleton/reagent/drugs/dionae_stimulant/diet = 30)

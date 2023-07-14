
///////////////////////////////////////////////Condiments
//Notes by Darem: The condiments food-subtype is for stuff you don't actually eat but you use to modify existing food. They all
//	leave empty containers when used up and can be filled/re-filled with other items. Formatting for first section is identical
//	to mixed-drinks code. If you want an object that starts pre-loaded, you need to make it in addition to the other code.

//Food items that aren't eaten normally and leave an empty container behind.
/obj/item/reagent_containers/food/condiment
	name = "condiment container"
	desc = "Just your average condiment container."
	icon = 'icons/obj/food.dmi'
	icon_state = "emptycondiment"
	flags = OPENCONTAINER
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
		icon_state = "emptycondiment"
		name = "condiment bottle"
		desc = "An empty condiment bottle."
		center_of_mass = list("x"=16, "y"=6)
		return

	var/singleton/reagent/master = reagents.get_primary_reagent_decl()
	name = master.condiment_name || (reagents.reagent_volumes.len == 1 ? "[lowertext(master.name)] bottle" : "condiment bottle")
	desc = master.condiment_desc || (reagents.reagent_volumes.len == 1 ? master.description : "A mixture of various condiments. [master.name] is one of them.")
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
	volume = 20
	fixed_state = TRUE
	center_of_mass = list("x"=17, "y"=11)
	amount_per_transfer_from_this = 1
	volume = 20
	fixed_state = TRUE

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

/obj/item/reagent_containers/food/condiment/flour
	name = "flour sack"
	desc = "A big bag of flour. Good for baking!"
	icon_state = "flour"
	center_of_mass = list("x"=16, "y"=8)
	volume = 220
	fixed_state = TRUE
	reagents_to_add = list(/singleton/reagent/nutriment/flour = 200)

/obj/item/reagent_containers/food/condiment/barbecue
	fixed_state = TRUE
	reagents_to_add = list(/singleton/reagent/nutriment/barbecue = 20)

/obj/item/reagent_containers/food/condiment/garlicsauce
	fixed_state = TRUE
	reagents_to_add = list(/singleton/reagent/nutriment/garlicsauce = 50)

/obj/item/reagent_containers/food/condiment/pacid
	name = "culinary acid"
	reagents_to_add = list(/singleton/reagent/acid/polyacid = 50)

//MRE condiments and drinks.

/obj/item/reagent_containers/food/condiment/small/packet
	icon_state = "packet_small"
	fixed_state = TRUE
	w_class = ITEMSIZE_TINY
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


//End of MRE stuff.

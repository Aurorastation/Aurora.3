
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

/obj/item/reagent_containers/food/condiment/Initialize()
	. = ..()
	on_reagent_change(force = TRUE)

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

	var/decl/reagent/master = reagents.get_primary_reagent_decl()
	name = master.condiment_name || (reagents.reagent_volumes.len == 1 ? "[lowertext(master.name)] bottle" : "condiment bottle")
	desc = master.condiment_desc || (reagents.reagent_volumes.len == 1 ? master.description : "A mixture of various condiments. [master.name] is one of them.")
	icon_state = master.condiment_icon_state || "mixedcondiments"
	center_of_mass = master.condiment_center_of_mass || list("x"=16, "y"=6)

/obj/item/reagent_containers/food/condiment/enzyme
	icon_state = "enzyme" // for map preview
	fixed_state = TRUE
	reagents_to_add = list(/decl/reagent/enzyme = 50)

/obj/item/reagent_containers/food/condiment/sugar
	icon_state = "sugar"
	fixed_state = TRUE
	reagents_to_add = list(/decl/reagent/sugar = 50)

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
	reagents_to_add = list(/decl/reagent/sodiumchloride = 20)

/obj/item/reagent_containers/food/condiment/shaker/peppermill
	icon_state = "peppermillsmall"
	reagents_to_add = list(/decl/reagent/blackpepper = 20)

/obj/item/reagent_containers/food/condiment/shaker/diona
	icon_state = "dionaepowder"
	reagents_to_add = list(/decl/reagent/diona_powder = 20)

/obj/item/reagent_containers/food/condiment/shaker/spacespice
	icon_state = "spacespicebottle"
	volume = 40
	reagents_to_add = list(/decl/reagent/spacespice = 40)

/obj/item/reagent_containers/food/condiment/flour
	name = "flour sack"
	desc = "A big bag of flour. Good for baking!"
	icon_state = "flour"
	center_of_mass = list("x"=16, "y"=8)
	volume = 220
	fixed_state = TRUE
	reagents_to_add = list(/decl/reagent/nutriment/flour = 200)

/obj/item/reagent_containers/food/condiment/barbecue
	fixed_state = TRUE
	reagents_to_add = list(/decl/reagent/nutriment/barbecue = 20)

/obj/item/reagent_containers/food/condiment/garlicsauce
	fixed_state = TRUE
	reagents_to_add = list(/decl/reagent/nutriment/garlicsauce = 50)

/obj/item/reagent_containers/food/condiment/pacid
	name = "culinary acid"
	reagents_to_add = list(/decl/reagent/acid/polyacid = 50)

/obj/item/reagent_containers/food/snacks/egg
	name = "egg"
	desc = "Can I offer you a nice egg in this trying time?"
	icon = 'icons/obj/item/reagent_containers/food/egg.dmi'
	icon_state = "egg"
	item_state = "egg" // don't change the item_state unless you know what you're doing, or i will kill you. -Wezzy
	filling_color = "#FDFFD1"
	volume = 10
	reagents_to_add = list(/singleton/reagent/nutriment/protein/egg = 3)
	var/hatchling = /mob/living/simple_animal/chick

/obj/item/reagent_containers/food/snacks/egg/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(!(proximity && O.is_open_container()))
		return ..()
	if(istype(O, /obj/item/reagent_containers/cooking_container) && user.a_intent == I_HELP)
		return ..() // don't crack it into a container on help intent
	to_chat(user, "You crack \the [src] into \the [O].")
	reagents.trans_to(O, reagents.total_volume)
	qdel(src)

/obj/item/reagent_containers/food/snacks/egg/throw_impact(atom/hit_atom)
	..()
	new/obj/effect/decal/cleanable/egg_smudge(src.loc)
	src.reagents.splash(hit_atom, reagents.total_volume)
	src.visible_message(SPAN_WARNING("\The [src] has been squashed!"), SPAN_WARNING("You hear a smack."))
	qdel(src)

/obj/item/reagent_containers/food/snacks/egg/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/pen/crayon ))
		var/obj/item/pen/crayon/C = attacking_item
		var/clr = C.colourName

		if(!(clr in list("blue","green","mime","orange","purple","rainbow","red","yellow")))
			to_chat(usr, SPAN_NOTICE("The egg refuses to take on this color!"))
			return TRUE

		to_chat(usr, SPAN_NOTICE("You color \the [src] [clr]"))
		icon_state = "egg-[clr]"
		item_state = icon_state
		return TRUE
	return ..()

/obj/item/reagent_containers/food/snacks/egg
	var/amount_grown = 0

/obj/item/reagent_containers/food/snacks/egg/process()
	if(isturf(loc))
		amount_grown += rand(1,2)
		if(amount_grown >= 100)
			visible_message("[src] hatches with a quiet cracking sound.")
			new hatchling(get_turf(src))
			STOP_PROCESSING(SSprocessing, src)
			qdel(src)
	else
		STOP_PROCESSING(SSprocessing, src)

/obj/item/reagent_containers/food/snacks/egg/blue
	icon_state = "egg-blue"
	item_state = "egg-blue"

/obj/item/reagent_containers/food/snacks/egg/green
	icon_state = "egg-green"
	item_state = "egg-green"

/obj/item/reagent_containers/food/snacks/egg/mime
	icon_state = "egg-mime"
	item_state = "egg-mime"

/obj/item/reagent_containers/food/snacks/egg/orange
	icon_state = "egg-orange"
	item_state = "egg-orange"

/obj/item/reagent_containers/food/snacks/egg/purple
	icon_state = "egg-purple"
	item_state = "egg-purple"

/obj/item/reagent_containers/food/snacks/egg/rainbow
	icon_state = "egg-rainbow"
	item_state = "egg-rainbow"

/obj/item/reagent_containers/food/snacks/egg/red
	icon_state = "egg-red"
	item_state = "egg-red"

/obj/item/reagent_containers/food/snacks/egg/yellow
	icon_state = "egg-yellow"
	item_state = "egg-yellow"

/obj/item/reagent_containers/food/snacks/egg/schlorrgo
	name = "alien egg"
	desc = "A large mysterious egg."
	icon_state = "schlorrgo_egg"
	filling_color = "#e9ffd1"
	volume = 20
	hatchling = /mob/living/simple_animal/schlorrgo/baby

/obj/item/reagent_containers/food/snacks/egg/ice_tunnelers
	name = "ice tunneler egg"
	desc = "An egg laid by an Adhomian animal."
	icon_state = "tunneler_egg"
	filling_color = "#eff5e9"
	hatchling = /mob/living/simple_animal/ice_tunneler/baby

// egg dishes
/obj/item/reagent_containers/food/snacks/chocolateegg
	name = "chocolate egg"
	desc = "Eggcellent."
	icon = 'icons/obj/item/reagent_containers/food/egg.dmi'
	icon_state = "chocolateegg"
	filling_color = "#7D5F46"

	reagents_to_add = list(/singleton/reagent/nutriment = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("chocolate" = 5))
	bitesize = 2

//a random egg that can spawn only on easter. It has really good food values because it's rare
/obj/item/reagent_containers/food/snacks/goldenegg
	name = "golden egg"
	desc = "It's the golden egg!"
	icon = 'icons/obj/item/reagent_containers/food/egg.dmi'
	icon_state = "egg-yellow"
	item_state = "egg-yellow"
	filling_color = "#7D5F46"

	reagents_to_add = list(/singleton/reagent/nutriment = 12)
	reagent_data = list(/singleton/reagent/nutriment = list("chocolate" = 5))
	bitesize = 6

/obj/item/reagent_containers/food/snacks/friedegg
	name = "fried egg"
	desc = "A fried egg, with a touch of salt and pepper."
	icon = 'icons/obj/item/reagent_containers/food/egg.dmi'
	icon_state = "friedegg"
	filling_color = "#FFDF78"
	bitesize = 1
	reagents_to_add = list(/singleton/reagent/nutriment/protein/egg = 3, /singleton/reagent/sodiumchloride = 1, /singleton/reagent/blackpepper = 1)

/obj/item/reagent_containers/food/snacks/friedegg/overeasy
	name = "over-easy fried egg"
	desc = "A fried egg, with a touch of salt and pepper. The yolk looks a bit runny."

/obj/item/reagent_containers/food/snacks/boiledegg
	name = "boiled egg"
	desc = "Hard to beat, aren't they?"
	icon = 'icons/obj/item/reagent_containers/food/egg.dmi'
	icon_state = "egg"
	filling_color = "#FFFFFF"

	reagents_to_add = list(/singleton/reagent/nutriment/protein/egg = 2)

/obj/item/reagent_containers/food/snacks/bacon_and_eggs
	name = "bacon and eggs"
	desc = "A piece of bacon and two fried eggs."
	icon = 'icons/obj/item/reagent_containers/food/egg.dmi'
	icon_state = "bacon_and_eggs"
	trash = /obj/item/trash/plate
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 3, /singleton/reagent/nutriment/protein/egg = 1)
	filling_color = "#FC5647"

/obj/item/reagent_containers/food/snacks/omelette
	name = "omelette du fromage"
	desc = "That's all you can say!"
	icon = 'icons/obj/item/reagent_containers/food/egg.dmi'
	icon_state = "omelette"
	trash = /obj/item/trash/plate
	filling_color = "#FFF9A8"
	center_of_mass = list("x"=16, "y"=13)
	bitesize = 1

	reagents_to_add = list(/singleton/reagent/nutriment/protein/egg = 8)

/obj/item/reagent_containers/food/snacks/poachedegg
	name = "poached egg"
	desc = "A delicately poached egg with a runny yolk. Healthier than its fried counterpart."
	icon = 'icons/obj/item/reagent_containers/food/egg.dmi'
	icon_state = "poachedegg"
	trash = /obj/item/trash/plate
	filling_color = "#FFDF78"
	center_of_mass = list("x"=16, "y"=14)
	reagents_to_add = list(/singleton/reagent/nutriment = 1, /singleton/reagent/blackpepper = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("egg" = 3))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/chawanmushi
	name = "chawanmushi"
	desc = "A legendary egg custard that makes friends out of enemies. Probably too hot for a cat to eat."
	icon = 'icons/obj/item/reagent_containers/food/egg.dmi'
	icon_state = "chawanmushi"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#F0F2E4"
	center_of_mass = list("x"=17, "y"=10)
	bitesize = 1

	reagents_to_add = list(/singleton/reagent/nutriment/protein = 5)

/obj/item/reagent_containers/food/snacks/shakshouka
	name = "shakshouka"
	desc = "A spicy middle eastern tomato and egg dish that has gained vast popularity in Elyra."
	icon = 'icons/obj/item/reagent_containers/food/egg.dmi'
	icon_state = "shakshouka"
	trash = /obj/item/trash/shakshouka
	reagents_to_add = list(/singleton/reagent/nutriment/protein/egg = 3, /singleton/reagent/nutriment = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("zesty tomatoes" = 4))
	filling_color = "#BB2912"

/obj/item/reagent_containers/food/snacks/eggs_benedict
	name = "eggs benedict"
	gender = PLURAL
	desc = "A dish consisting of poached eggs and sliced ham on half a toasted english muffin, then covered with hollandaise sauce. Usually served in pairs."
	icon = 'icons/obj/item/reagent_containers/food/egg.dmi'
	icon_state = "benedict"
	reagents_to_add = list(/singleton/reagent/nutriment/protein/egg = 6, /singleton/reagent/nutriment/protein = 2, /singleton/reagent/nutriment = 4)
	reagent_data = list(/singleton/reagent/nutriment/protein/egg = list("rich, creamy eggs" = 10), /singleton/reagent/nutriment = list("toasted bread" = 5, "ham" = 3))
	filling_color = "#ebcd49"
	bitesize = 3

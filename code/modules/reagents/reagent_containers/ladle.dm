/obj/item/reagent_containers/ladle
	name = "ladle"
	desc = "A serving ladle. Holds 30u."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "ladle"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(10, 15, 30)
	w_class = ITEMSIZE_SMALL
	volume = 30
	force = 6
	flags = OPENCONTAINER | NOBLUDGEON
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'
	center_of_mass = list("x"=14, "y"=6)

/obj/item/reagent_containers/ladle/afterattack(var/obj/target, var/mob/user, var/flag)
	if(!target.is_open_container() || !flag)
		return ..(target, user, flag)
	if(reagents.total_volume)
		if(!target.reagents?.get_free_space())
			to_chat(user, SPAN_NOTICE("[target] is full."))
			return TRUE
		var/trans = reagents.trans_to(target, amount_per_transfer_from_this) //sprinkling reagents on generic non-mobs
		user.visible_message(
			"<b>[user]</b> pours into [target] from [src].",
			SPAN_NOTICE("You transfer [trans] units of the solution.")
		)
		return TRUE
	if(!target.reagents || !target.reagents.total_volume)
		to_chat(user, SPAN_NOTICE("[target] is empty."))
		return TRUE
	if(istype(target, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/S = target
		if(!S.is_liquid)
			return TRUE
	var/trans = target.reagents.trans_to_obj(src, amount_per_transfer_from_this)
	user.visible_message(
		"<b>[user]</b> scoops from [target] with [src].",
		SPAN_NOTICE("You scoop up [trans] units with [src].")
	)
	return TRUE

/obj/item/reagent_containers/ladle/on_reagent_change()
	update_icon()

/obj/item/reagent_containers/ladle/update_icon()
	cut_overlays()
	if(!reagents.total_volume)
		return
	var/image/over = image(icon, "ladle_overlay")
	over.color = reagents.get_color()
	add_overlay(over)

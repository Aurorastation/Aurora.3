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
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'

/obj/item/reagent_containers/ladle/afterattack(var/obj/target, var/mob/user, var/flag)
	if(!target.is_open_container()) // Taking from something, or trying to hit someone?
		return ..()
	if(target.reagents || !target.reagents.total_volume)
		to_chat(user, SPAN_NOTICE("[target] is empty."))
		return TRUE

	var/trans = target.reagents.trans_to_obj(src, amount_per_transfer_from_this)
	to_chat(user, SPAN_NOTICE("You scoop up [trans] units with [src]."))
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

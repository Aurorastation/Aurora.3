/obj/item/reagent_containers/glass/beaker/teapot
	name = "teapot"
	desc = "An elegant teapot. It simply oozes class."
	icon_state = "teapot"
	item_state = "teapot"
	unacidable = TRUE
	amount_per_transfer_from_this = 10
	volume = 120

/obj/item/reagent_containers/glass/beaker/teapot/lidded
	name = "gaiwan"
	desc = "A lidded ceramic bowl of Chinese origin. Used to infuse a large amount of tea into a small amount of water. \
			To pour, the lid is pinched down into the bowl with a small gap left open for the tea. Traditionally used across the Alliance."
	icon = 'icons/obj/item/reagent_containers/teaware.dmi'
	icon_state = "gaiwan"
	item_state = "gaiwan"
	contained_sprite = TRUE
	drop_sound = 'sound/items/drop/bottle.ogg'
	pickup_sound = 'sound/items/pickup/bottle.ogg'
	volume = 60
	fragile = 0
	var/lid_type = /obj/item/teapot_lid
	var/obj/item/teapot_lid/lid

/obj/item/reagent_containers/glass/beaker/teapot/lidded/Initialize()
	. = ..()
	lid = new lid_type()
	update_icon()

/obj/item/reagent_containers/glass/beaker/teapot/lidded/update_icon()
	if(lid)
		icon_state = initial(icon_state) + "_lid"
		cut_overlays()
	else
		..()
		icon_state = initial(icon_state)

/obj/item/reagent_containers/glass/beaker/teapot/lidded/attackby(obj/item/W, mob/user)
	. = ..()
	if(istype(W, lid_type) && !lid)
		user.drop_from_inventory(W, src)
		lid = W
		to_chat(user, SPAN_NOTICE("You slide the lid onto \the [src]."))
		update_icon()
		return TRUE

/obj/item/reagent_containers/glass/beaker/teapot/lidded/attack_self(mob/user)
	if(lid)
		if(user.put_in_hands(lid))
			lid = null
			to_chat(user, SPAN_NOTICE("You slide off \the [src]'s lid."))
			update_icon()
			return TRUE

/obj/item/reagent_containers/glass/beaker/teapot/lidded/is_open_container()
	return lid ? FALSE : TRUE

/obj/item/reagent_containers/glass/beaker/teapot/lidded/kyusu
	name = "kyusu"
	desc = "A ceramic yokode kyusu - or side-handle teapot. This sort of teapot is popular on Konyang, owing to the Japanese origins of some of its population. \
			To pour, one grasps the handle while holding the lid down with the index finger."
	icon_state = "kyusu"
	item_state = "kyusu"
	lid_type = /obj/item/teapot_lid/kyusu

/obj/item/teapot_lid
	name = "gaiwan lid"
	desc = "A lid for a gaiwan."
	icon = 'icons/obj/item/reagent_containers/teaware.dmi'
	icon_state = "gaiwan-lid"

/obj/item/teapot_lid/kyusu
	name = "kyusu lid"
	desc = "A lid for a yokode kyusu."
	icon_state = "kyusu-lid"

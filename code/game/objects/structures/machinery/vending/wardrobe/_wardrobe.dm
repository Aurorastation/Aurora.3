
ABSTRACT_TYPE(/obj/structure/machinery/vending/wardrobe)
	icon_state = "robotics"
	light_mask = "robotics-light-mask"
	light_color = COLOR_GREEN
	vend_id = "wardrobe"
	persistent_stock = FALSE
	random_itemcount = FALSE
	restock_items = TRUE

ABSTRACT_TYPE(/obj/structure/machinery/vending/wardrobe/themed)
	default_item_amount = 8

/**
 * A one-use token that lets the user pick one thing out of `spawn_options`,
 * spawns it on the token's turf, and then deletes itself.
 */
ABSTRACT_TYPE(/obj/item/item_spawn_token)
	name = "spawn token"
	desc = "A token that can be redeemed for something. Use it in hand."
	w_class = WEIGHT_CLASS_SMALL
	icon = /obj/item/coin/gold::icon
	icon_state = /obj/item/coin/gold::icon_state
	/// Assoc list of display name -> type path to spawn.
	var/list/spawn_options = list()
	/// Title of the selection window.
	var/selection_title = "Select an Item"

/obj/item/item_spawn_token/attack_self(mob/user)
	if(!length(spawn_options))
		return

	var/choice = tgui_input_list(
		user, "Select what to spawn. This will use up the token.",
		selection_title, spawn_options
	)

	if(!choice || QDELETED(src) || !user.Adjacent(src))
		return

	var/spawn_type = spawn_options[choice]
	if(!spawn_type)
		return

	var/turf/spawn_turf = get_turf(src)
	new spawn_type(spawn_turf)
	to_chat(user, SPAN_NOTICE("You redeem \the [src] for \a [choice]."))
	qdel(src)

/obj/item/item_spawn_token/themed_wardrobe
	name = "themed wardrobe token"
	desc = "A token that can be redeemed for a themed clothing vendor. Use it in hand to choose one."
	selection_title = "Select a Themed Wardrobe"
	spawn_options = list(
		/obj/structure/machinery/vending/wardrobe/themed/tajara_generic::name = /obj/structure/machinery/vending/wardrobe/themed/tajara_generic,
		/obj/structure/machinery/vending/wardrobe/themed/merc::name = /obj/structure/machinery/vending/wardrobe/themed/merc,
		/obj/structure/machinery/vending/wardrobe/themed/sol::name = /obj/structure/machinery/vending/wardrobe/themed/sol,
	)

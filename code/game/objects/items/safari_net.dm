/*
	Safari Net
*/
/obj/item/energy_net/safari
	name = "safari net"
	desc = "A low power energized net meant to subdue animals."
	icon_state = "safarinet"
	net_type = /obj/effect/energy_net/safari

/obj/effect/energy_net/safari
	name = "safari net"
	desc = "A low power energized net meant to subdue animals."
	icon_state = "safari_net"

	health = 5

/obj/item/net_container
	name = "safari net container"
	desc = "A cylindrical device designed to stabilise safari energy nets for transport."
	icon = 'icons/obj/item/net_container.dmi'
	icon_state = "net_tube"
	item_state = "net_tube"
	/**
	 * How many nets we have "stored"
	 */
	var/nets = 0

/obj/item/net_container/attackby(obj/item/attacking_item, mob/user, params)
	. = ..()
	if(istype(attacking_item, /obj/item/energy_net/safari))
		if(nets < 3)
			nets++
			to_chat(user, SPAN_NOTICE("\The [src] hums as it stores the energy of \the [attacking_item] inside."))
			qdel(attacking_item)
			update_icon()
			return
		to_chat(user, SPAN_NOTICE("\The [src] is too full to store \the [attacking_item]!"))
		return

/obj/item/net_container/attack_hand(mob/user)
	if(nets)
		nets--
		to_chat(user, SPAN_NOTICE("\The [src] hums as it forms a new net in your hand."))
		var/obj/item/energy_net/safari/net = new /obj/item/energy_net/safari(src)
		user.put_in_active_hand(net)
		update_icon()
		return
	return ..()

/obj/item/net_container/update_icon()
	. = ..()
	ClearOverlays()
	if(nets)
		var/image/over = overlay_image(icon, "[icon_state]_[nets]")
		AddOverlays(over)

/obj/structure/net_dispenser
	name = "safari net dispenser"
	desc = "A wall mounted dispenser capable to producing low power energy nets, suitable for trapping fauna."
	icon = 'icons/obj/item/net_container.dmi'
	icon_state = "net_dispenser"
	/**
	 * How many nets we can dispense.
	 * This should be enough, as they're not really meant to be limitted on this end
	 */
	var/nets = 30

/obj/structure/net_dispenser/attack_hand(mob/living/user)
	if(nets)
		nets--
		to_chat(user, SPAN_NOTICE("\The [src] hums as it forms a new net in your hand."))
		var/obj/item/energy_net/safari/net = new /obj/item/energy_net/safari(src)
		user.put_in_active_hand(net)
		return
	return ..()




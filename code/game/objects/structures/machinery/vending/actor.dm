/*
 *	Generic Clothing Vendor
 *	Actor Vendor
 **/

/obj/structure/machinery/vending/actor
	name = "\improper Actor Vendor"
	desc = "Has all your odyssey actor items, to let you effectively do your odysseying and actoring."
	vend_id = "actor"
	icon_state = "generic"
	icon_vend = "generic-vend"
	light_mask = "generic-lightmask"
	products = list(
		/obj/item/radio/headset/ship/odyssey = 12,
		/obj/item/portable_map_reader/odyssey = 12,
		/obj/item/card/id/syndicate = 12,
		/obj/item/storage/box/syndie_kit/chameleon = 12,
	)
	light_color = COLOR_GUNMETAL
	random_itemcount = FALSE

/obj/structure/closet/malf/suits
	desc = "It's a storage unit for operational gear."
	icon_state = "syndicate"
	icon_closed = "syndicate"
	icon_opened = "syndicateopen"

/obj/structure/closet/malf/suits/fill()
	new /obj/item/tank/jetpack/void(src)
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/clothing/head/helmet/space/void(src)
	new /obj/item/clothing/suit/space/void(src)
	new /obj/item/crowbar(src)
	new /obj/item/cell(src)
	new /obj/item/device/multitool(src)

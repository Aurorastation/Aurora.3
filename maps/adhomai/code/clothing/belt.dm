/obj/item/weapon/storage/belt/security/tactical/nka
	name = "military belt"
	desc = "A belt designated to hold ammunition and other related military gear.."
	icon = 'icons/adhomai/clothing.dmi'
	icon_state = "nkacombat"
	item_state = "nkacombat"
	contained_sprite = TRUE
	can_hold = list(
		/obj/item/weapon/storage/box/clip_pouch,
		/obj/item/device/flashlight,
		/obj/item/weapon/grenade,
		/obj/item/stack/medical/bruise_pack/adhomai,
		/obj/item/stack/medical/ointment/adhomai,
		/obj/item/weapon/reagent_containers/food/drinks/flask/canteen/adhomian/nka,
		/obj/item/device/radio/adhomai/nka,
		)

/obj/item/weapon/storage/belt/apron/nka
	name = "royal apron"
	desc = "An apron with golden embroidery at the fringes of the bottom. Probably for all your cooking needs."
	icon = 'icons/adhomai/clothing.dmi'
	icon_state = "nkapron"
	item_state = "nkapron"
	contained_sprite = TRUE
	storage_slots = 9
	allowed = list(
		/obj/item/weapon/material/kitchen/rollingpin,
		/obj/item/weapon/material/hatchet/butch,
		/obj/item/weapon/material/knife,
		/obj/item/weapon/reagent_containers/food/condiment/spacespice,
		/obj/item/weapon/reagent_containers/food/condiment/peppermill,
		/obj/item/weapon/reagent_containers/food/condiment/saltshaker,
		/obj/item/weapon/reagent_containers/food/condiment/sugar,
		/obj/item/weapon/reagent_containers/glass/rag,
		/obj/item/clothing/gloves/black/oven
		)
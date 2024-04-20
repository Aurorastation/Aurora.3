//
// Marooning Equipment
//
/obj/structure/closet/secure_closet/marooning_equipment
	name = "marooning equipment locker"
	icon_state = "maroon"
	req_one_access = list(ACCESS_HEADS, ACCESS_SECURITY) // Marooned personnel would likely be marooned by security and/or command.

/obj/structure/closet/secure_closet/marooning_equipment/fill()
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/clothing/under/color/yellow(src)
	new /obj/item/clothing/shoes/workboots/grey(src)
	new /obj/item/clothing/head/helmet/space/emergency/marooning_equipment(src)
	new /obj/item/clothing/suit/space/emergency/marooning_equipment(src)
	new /obj/item/tank/oxygen/marooning_equipment(src)
	new /obj/item/storage/backpack/duffel/marooning_equipment(src)

/obj/item/storage/backpack/duffel/marooning_equipment
	name = "marooning equipment duffel bag"
	desc = "A duffel bag full of marooning equipment."
	starts_with = list(
		// Tools
		/obj/item/crowbar/red = 1,
		/obj/item/device/flashlight/heavy = 1,
		/obj/item/device/gps/marooning_equipment = 1,
		/obj/item/airbubble = 1,

		// Rations
		/obj/item/storage/box/fancy/mre/random = 2,
		/obj/item/reagent_containers/food/drinks/waterbottle = 4,

		// Medical Supplies
		/obj/item/storage/firstaid/stab = 1
	)

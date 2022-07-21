/* Closets for specific jobs
 * Contains:
 *		Bartender
 *		Chef
 *		Lawyer
 */

/*
 * Bartender
 */
/obj/structure/closet/gmcloset
	name = "formal closet"
	desc = "It's a storage unit for formal clothing."
	icon_door = "black"

/obj/structure/closet/gmcloset/fill()
	new /obj/item/clothing/head/that(src)
	new /obj/item/clothing/head/that(src)
	new /obj/item/device/radio/headset/headset_service(src)
	new /obj/item/device/radio/headset/headset_service(src)
	new /obj/item/clothing/head/pin/flower(src)
	new /obj/item/clothing/head/pin/flower/pink(src)
	new /obj/item/clothing/head/pin/flower/yellow(src)
	new /obj/item/clothing/head/pin/flower/blue(src)
	new /obj/item/clothing/head/pin/magnetic(src)
	new /obj/item/clothing/under/sl_suit(src)
	new /obj/item/clothing/under/sl_suit(src)
	new /obj/item/clothing/under/rank/bartender(src)
	new /obj/item/clothing/under/rank/bartender(src)
	new /obj/item/clothing/accessory/wcoat(src)
	new /obj/item/clothing/accessory/wcoat(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)

/*
 * Chef
 */
/obj/structure/closet/chefcloset
	name = "chef's closet"
	desc = "It's a storage unit for foodservice garments."
	icon_door = "black"

/obj/structure/closet/chefcloset/fill()
	new /obj/item/clothing/under/waiter(src)
	new /obj/item/clothing/under/waiter(src)
	if(prob(1))
		new /obj/item/gun/energy/mousegun(src)
	new /obj/item/device/radio/headset/headset_service(src)
	new /obj/item/device/radio/headset/headset_service(src)
	new /obj/item/storage/box/gloves(src)
	new /obj/item/storage/box/mousetraps(src)
	new /obj/item/clothing/under/rank/chef/nt(src)
	new /obj/item/clothing/under/rank/chef/idris(src)
	new /obj/item/clothing/head/chefhat/nt(src)
	new /obj/item/clothing/head/chefhat/idris(src)
	new /obj/item/clothing/head/hairnet(src)
	new /obj/item/clothing/head/hairnet(src)

/*
 * Lawyer
 */
/obj/structure/closet/lawcloset
	name = "legal closet"
	desc = "It's a storage unit for courtroom apparel and items."
	icon_door = "blue"

/obj/structure/closet/lawcloset/fill()
	new /obj/item/clothing/under/lawyer/red(src)
	new /obj/item/clothing/under/lawyer/purple(src)
	new /obj/item/clothing/suit/storage/lawyer/purpjacket(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/clothing/shoes/black(src)
/obj/structure/closet/l3closet
	name = "level-3 biohazard suit closet"
	desc = "It's a storage unit for level-3 biohazard gear."
	icon_state = "bio"

/obj/structure/closet/l3closet/general/fill()
	new /obj/item/clothing/suit/hazmat/general(src)
	new /obj/item/clothing/head/hazmat/general(src)
	new /obj/item/clothing/mask/gas/half(src)
	new /obj/item/clothing/suit/hazmat/general(src)
	new /obj/item/clothing/head/hazmat/general(src)
	new /obj/item/clothing/mask/gas/half(src)

/obj/structure/closet/l3closet/security
	icon_state = "bio_sec"

/obj/structure/closet/l3closet/security/fill()
	new /obj/item/clothing/suit/hazmat/security(src)
	new /obj/item/clothing/head/hazmat/security(src)
	new /obj/item/clothing/mask/gas/half(src)

/obj/structure/closet/l3closet/janitor
	name = "level 3 biohazard custodial gear closet"
	desc = "It's a storage unit for level 3 biohazard custodial gear."
	icon_state = "bio_jan"

/obj/structure/closet/l3closet/janitor/fill()
	new /obj/item/clothing/suit/hazmat/janitor(src)
	new /obj/item/clothing/head/hazmat/janitor(src)
	new /obj/item/clothing/mask/gas/half(src)
	new /obj/item/watertank/janitor(src)

/obj/structure/closet/l3closet/scientist
	icon_state = "bio_scientist"

/obj/structure/closet/l3closet/scientist/fill()
	new /obj/item/clothing/suit/hazmat/scientist(src)
	new /obj/item/clothing/head/hazmat/scientist(src)
	new /obj/item/clothing/mask/gas/half(src)
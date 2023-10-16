//
// Hazmat Closets
//

// Parent Object
/obj/structure/closet/hazmat
	name = "hazmat gear closet parent object"
	desc = DESC_PARENT

// General
/obj/structure/closet/hazmat/general
	name = "hazmat gear closet"
	desc = "A closet for hazmat gear."
	icon_state = "hazmat"

/obj/structure/closet/hazmat/general/fill()
	new /obj/item/clothing/head/hazmat/general(src)
	new /obj/item/clothing/head/hazmat/general(src)
	new /obj/item/clothing/suit/hazmat/general(src)
	new /obj/item/clothing/suit/hazmat/general(src)
	new /obj/item/clothing/mask/gas/half(src)
	new /obj/item/clothing/mask/gas/half(src)

// Research
/obj/structure/closet/hazmat/research
	name = "research hazmat gear closet"
	desc = "A closet for research hazmat gear."
	icon_state = "hazmat"

/obj/structure/closet/hazmat/research/fill()
	new /obj/item/clothing/head/hazmat/research(src)
	new /obj/item/clothing/head/hazmat/research(src)
	new /obj/item/clothing/suit/hazmat/research(src)
	new /obj/item/clothing/suit/hazmat/research(src)
	new /obj/item/clothing/mask/gas/half(src)
	new /obj/item/clothing/mask/gas/half(src)

// Security
/obj/structure/closet/hazmat/security
	name = "security hazmat gear closet"
	desc = "A closet for security hazmat gear."
	icon_state = "hazmat"

/obj/structure/closet/hazmat/security/fill()
	new /obj/item/clothing/head/hazmat/security(src)
	new /obj/item/clothing/head/hazmat/security(src)
	new /obj/item/clothing/suit/hazmat/security(src)
	new /obj/item/clothing/suit/hazmat/security(src)
	new /obj/item/clothing/mask/gas/half(src)
	new /obj/item/clothing/mask/gas/half(src)

// Custodial
/obj/structure/closet/hazmat/custodial
	name = "custodial hazmat gear closet"
	desc = "A closet for custodial hazmat gear."
	icon_state = "hazmat_custodial"

/obj/structure/closet/hazmat/custodial/fill()
	new /obj/item/clothing/head/hazmat/custodial(src)
	new /obj/item/clothing/suit/hazmat/custodial(src)
	new /obj/item/clothing/mask/gas/half(src)
	new /obj/item/watertank/janitor(src)

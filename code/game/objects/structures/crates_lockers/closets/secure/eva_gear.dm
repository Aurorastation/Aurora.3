//
// EVA Gear Lockers
//

// Parent Object
/obj/structure/closet/secure_closet/eva_gear
	name = "\improper EVA gear locker parent object"
	desc = DESC_PARENT
	anchored = TRUE
	canbemoved = TRUE

// Softsuits
/obj/structure/closet/secure_closet/eva_gear/softsuits
	name = "softsuits EVA gear locker"
	desc = "An EVA gear locker with room for 2 sets of softsuits."
	req_access = list(access_brig)

/obj/structure/closet/secure_closet/eva_gear/softsuits/fill()
	new /obj/item/clothing/head/helmet/space(src)
	new /obj/item/clothing/head/helmet/space(src)
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/clothing/suit/space(src)
	new /obj/item/clothing/suit/space(src)

// Security
/obj/structure/closet/secure_closet/eva_gear/security
	name = "security EVA gear locker"
	desc = "An EVA gear locker with room for 2 sets of softsuits."
	req_access = list(access_brig)
	icon_state = "sec"

/obj/structure/closet/secure_closet/eva_gear/security/fill()
	new /obj/item/clothing/head/helmet/space/void/security(src)
	new /obj/item/clothing/head/helmet/space/void/security(src)
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/clothing/suit/space/void/security(src)
	new /obj/item/clothing/suit/space/void/security(src)
	new /obj/item/clothing/shoes/magboots(src)
	new /obj/item/clothing/shoes/magboots(src)

// Medical
/obj/structure/closet/secure_closet/eva_gear/medical
	name = "medical EVA gear locker"
	req_access = list(access_medical)
	icon_state = "med"

/obj/structure/closet/secure_closet/eva_gear/medical/fill()
	new /obj/item/clothing/head/helmet/space/void/medical(src)
	new /obj/item/clothing/head/helmet/space/void/medical(src)
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/clothing/suit/space/void/medical(src)
	new /obj/item/clothing/suit/space/void/medical(src)
	new /obj/item/clothing/shoes/magboots(src)
	new /obj/item/clothing/shoes/magboots(src)

// Research
/obj/structure/closet/secure_closet/eva_gear/research
	name = "research EVA gear locker"
	req_access = list(access_research)
	icon_state = "science"

/obj/structure/closet/secure_closet/eva_gear/research/fill()
	new /obj/item/clothing/head/helmet/space/void/sci(src)
	new /obj/item/clothing/head/helmet/space/void/sci(src)
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/clothing/suit/space/void/sci(src)
	new /obj/item/clothing/suit/space/void/sci(src)
	new /obj/item/clothing/shoes/magboots(src)
	new /obj/item/clothing/shoes/magboots(src)
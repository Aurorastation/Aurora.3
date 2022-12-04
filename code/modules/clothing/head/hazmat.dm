//
// Hazmat Hoods
//

// Hazmat Hood
/obj/item/clothing/head/hazmat
	name = "hazmat hood"
	desc = "A hood that protects against biological hazards."
	icon_state = "hazmat"
	item_state = "hazmat"
	contained_sprite = TRUE
	permeability_coefficient = 0
	gas_transfer_coefficient = 0
	siemens_coefficient = 0.75
	armor = list(
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
	)
	body_parts_covered = HEAD | FACE | EYES
	flags_inv = HIDEMASK | HIDEEARS | HIDEEYES | BLOCKHAIR

// General
/obj/item/clothing/head/hazmat/general
	icon_state = "hazmat_general"
	item_state = "hazmat_general"

// Research
/obj/item/clothing/head/hazmat/scientist
	icon_state = "hazmat_research"
	item_state = "hazmat_research"

// Security
/obj/item/clothing/head/hazmat/security
	icon_state = "hazmat_security"
	item_state = "hazmat_security"

// Custodial
/obj/item/clothing/head/hazmat/janitor
	icon_state = "hazmat_custodial"
	item_state = "hazmat_custodial"
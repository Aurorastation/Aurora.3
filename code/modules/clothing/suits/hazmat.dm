//
// Hazmat Suits
//

// Hazmat Suit
/obj/item/clothing/suit/hazmat
	name = "hazmat suit"
	desc = "A suit that protects against biological hazards."
	icon = 'icons/contained_items/bottomwear/hazmat.dmi'
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
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	flags_inv = HIDEWRISTS | HIDEGLOVES | HIDESHOES | HIDEJUMPSUIT | HIDETAIL
	allowed = list(/obj/item/tank/emergency_oxygen)

// General
/obj/item/clothing/suit/hazmat/general
	icon_state = "hazmat_general"
	item_state = "hazmat_general"

// Research
/obj/item/clothing/suit/hazmat/research
	icon_state = "hazmat_research"
	item_state = "hazmat_research"

// Security
/obj/item/clothing/suit/hazmat/security
	icon_state = "hazmat_security"
	item_state = "hazmat_security"

// Custodial
/obj/item/clothing/suit/hazmat/custodial
	icon_state = "hazmat_custodial"
	item_state = "hazmat_custodial"

// Plague Doctor
// Mask in "clothing/masks/gasmask.dm".
/obj/item/clothing/suit/hazmat/plaguedoctorsuit
	name = "plague doctor suit"
	desc = "It protected doctors from the Black Death, back then. You bet your arse it's gonna help you against viruses."
	icon_state = "plaguedoctor"
	item_state = "hazmat"
	flags_inv = HIDEWRISTS|HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL
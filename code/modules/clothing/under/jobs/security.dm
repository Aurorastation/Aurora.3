/*
 * Contains:
 *		Security
 *		Detective
 *		Head of Security
 */

/*
 * Security
 */

/obj/item/clothing/under/rank/security
	name = "security officer's uniform"
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for robust protection."
	icon_state = "officer_standard"
	worn_state = "officer_standard"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.75

/obj/item/clothing/under/rank/security/corp
	icon_state = "officer_corporate"
	worn_state = "officer_corporate"

/obj/item/clothing/under/rank/security/blue
	icon_state = "officer_blue"
	worn_state = "officer_blue"

/obj/item/clothing/under/rank/security/blue/alt
	icon_state = "officer_bluealt"
	worn_state = "officer_bluealt"

/obj/item/clothing/under/rank/security/navy
	icon_state = "officer_navy"
	worn_state = "officer_navy"

/obj/item/clothing/under/rank/security/darknavy
	icon_state = "officer_darknavy"
	worn_state = "officer_darknavy"

/obj/item/clothing/under/rank/security/tan
	icon_state = "officer_tan"
	worn_state = "officer_tan"

/obj/item/clothing/under/rank/cadet
	name = "security cadet's uniform"
	desc = "It's made of a slightly sturdier material, to allow for robust protection."
	icon_state = "cadet_standard"
	worn_state = "cadet_standard"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.75

/obj/item/clothing/under/rank/cadet/navy
	icon_state = "cadet_navy"
	worn_state = "cadet_navy"

/obj/item/clothing/under/rank/warden
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for more robust protection. It has the word \"Warden\" written on the shoulders."
	name = "warden's uniform"
	icon_state = "warden_standard"
	worn_state = "warden_standard"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.75

/obj/item/clothing/under/rank/warden/corp
	icon_state = "warden_corporate"
	worn_state = "warden_corporate"

/obj/item/clothing/under/rank/warden/dark_blue
	icon_state = "warden_darkblue"
	worn_state = "warden_darkblue"

/obj/item/clothing/under/rank/warden/blue
	icon_state = "warden_blue"
	worn_state = "warden_blue"

/obj/item/clothing/under/rank/warden/tan
	icon_state = "warden_tan"
	worn_state = "warden_tan"

/obj/item/clothing/under/rank/warden/navy
	icon_state = "warden_navy"
	worn_state = "warden_navy"

/*
 * Detective / Forensics
 */

/obj/item/clothing/under/det
	name = "tan investigator's uniform"
	desc = "Someone who wears this means business."
	icon_state = "detective_standard"
	worn_state = "detective_standard"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.75

/obj/item/clothing/under/det/black
	name = "hard-worn suit"
	icon_state = "detective_black"
	worn_state = "detective_black"

/obj/item/clothing/under/det/classic
	name = "hard-worn suit"
	icon_state = "detective_classic"
	worn_state = "detective_classic"

/obj/item/clothing/under/det/grey
	name = "hard-worn suit"
	icon_state = "detective_grey"
	worn_state = "detective_grey"

/obj/item/clothing/under/det/grey/waistcoat
	icon_state = "detective_grey_waistcoat"
	worn_state = "detective_grey_waistcoat"

/obj/item/clothing/under/det/muted
	name = "hard-worn suit"
	icon_state = "detective2"
	worn_state = "detective2"

/obj/item/clothing/under/det/muted/waistcoat
	icon_state = "detective2_waistcoat"
	worn_state = "detective2_waistcoat"

/obj/item/clothing/under/det/blue
	name = "hard-worn suit"
	icon_state = "detective3"
	worn_state = "detective3"

/obj/item/clothing/under/det/corporate
	name = "corporate investigator's uniform"
	icon_state = "detective_corporate"
	worn_state = "detective_corporate"

/obj/item/clothing/under/det/skirt
	icon_state = "detective_skirt"
	worn_state = "detective_skirt"

/obj/item/clothing/under/det/forensics
	name = "grey investigator's uniform"
	icon_state = "forensic_standard"
	worn_state = "forensic_standard"

/*
 * Head of Security
 */
/obj/item/clothing/under/rank/head_of_security
	desc = "It's a jumpsuit worn by those few with the dedication to achieve the position of \"Head of Security\". It has additional armor to protect the wearer."
	name = "head of security's uniform"
	icon_state = "hos_standard"
	worn_state = "hos_standard"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.75

/obj/item/clothing/under/rank/head_of_security/corp
	icon_state = "hos_corporate"
	worn_state = "hos_corporate"

/obj/item/clothing/under/rank/head_of_security/navy
	icon_state = "hos_navy"
	worn_state = "hos_navy"

/obj/item/clothing/under/rank/head_of_security/tan
	icon_state = "hos_tan"
	worn_state = "hos_tan"

/obj/item/clothing/under/rank/head_of_security/darknavy
	icon_state = "hos_darknavy"
	worn_state = "hos_darknavy"

/*
 * Contractors
 */

/obj/item/clothing/under/rank/security/zavodskoi
	name = "Zavodskoi Interstellar security uniform"
	desc = "A uniform worn by Zavodskoi Interstellar security forces."
	icon_state = "necro_sec"
	worn_state = "necro_sec"

/obj/item/clothing/under/rank/security/zavodskoi/alt
	icon_state = "necro_sec_alt"
	worn_state = "necro_sec_alt"

/obj/item/clothing/under/rank/security/idris
	name = "Idris Incorporated security uniform"
	desc = "A uniform worn by Idris Incorporated employees and contractors."
	icon_state = "idris_sec"
	worn_state = "idris_sec"

/obj/item/clothing/under/rank/security/eridani
	name = "Eridani PMC uniform"
	desc = "A uniform worn by contracted Eridani security forces."
	icon_state = "erisec"
	worn_state = "erisec"

/obj/item/clothing/under/rank/security/eridani/alt
	icon_state = "erisec_alt"
	worn_state = "erisec_alt"

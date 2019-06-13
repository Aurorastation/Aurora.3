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
	name = "security officer's jumpsuit"
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for robust protection."
	icon_state = "standard_officer"
	worn_state = "standard_officer"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/under/rank/security2
	name = "security cadet's uniform"
	desc = "It's made of a slightly sturdier material, to allow for robust protection."
	icon_state = "standard_cadet"
	worn_state = "standard_cadet"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/under/rank/security/corp
	icon_state = "corporate_officer"
	worn_state = "corporate_officer"

/obj/item/clothing/under/rank/security/blue
	icon_state = "blue_officer"
	worn_state = "blue_officer"

/obj/item/clothing/under/rank/cadet
	name = "security cadet's uniform"
	desc = "It's made of a slightly sturdier material, to allow for robust protection."
	icon_state = "standard_cadet"
	worn_state = "standard_cadet"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/under/rank/cadet/navy
	icon_state = "navy_cadet"
	worn_state = "navy_cadet"

/obj/item/clothing/under/rank/warden
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for more robust protection. It has the word \"Warden\" written on the shoulders."
	name = "warden's jumpsuit"
	icon_state = "standard_warden"
	worn_state = "standard_warden"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/under/rank/warden/corp
	icon_state = "corporate_warden"
	worn_state = "corporate_warden"

/obj/item/clothing/under/rank/warden/dark_blue
	icon_state = "darkblue_warden"
	worn_state = "darkblue_warden"

/*
 * Contractors
 */

/obj/item/clothing/under/rank/security/necropolis
	name = "Necropolis Industries security uniform"
	desc = "A uniform worn by Necropolis Industries security forces."
	icon_state = "necro_sec"
	worn_state = "necro_sec"

/obj/item/clothing/under/rank/security/idris
	name = "Idris Incorporated security uniform"
	desc = "A uniform worn by Idris Incorporated employees and contractors."
	icon_state = "idris_sec"
	worn_state = "idris_sec"

/obj/item/clothing/under/rank/security/idris/alt
	icon_state = "idris_alt"
	worn_state = "idris_alt"

/obj/item/clothing/under/rank/security/eridani
	name = "Eridani PMC uniform"
	desc = "A uniform worn by contracted Eridani security forces."
	icon_state = "erisec"
	worn_state = "erisec"

/obj/item/clothing/under/rank/security/eridani/alt
	icon_state = "erisec_alt"
	worn_state = "erisec_alt"

/*
 * Detective
 */

/obj/item/clothing/under/det
	name = "detective's uniform"
	desc = "Someone who wears this means business."
	icon_state = "standard_detective"
	item_state = "standard_detective"
	worn_state = "standard_detective"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/under/det/black
	name = "hard-worn suit"
	icon_state = "detective2"
	worn_state = "detective2"
	item_state = "sl_suit"

/obj/item/clothing/under/det/slob
	name = "hard-worn suit"
	icon_state = "polsuit"
	worn_state = "polsuit"

/obj/item/clothing/under/det/forensics
	name = "forensics technician's uniform"
	desc = "A gray service uniform worn by a forensics officer."
	icon_state = "standard_forensic"
	item_state = "standard_forensic"
	worn_state = "standard_forensic"

/*
 * Head of Security
 */
/obj/item/clothing/under/rank/head_of_security
	desc = "It's a jumpsuit worn by those few with the dedication to achieve the position of \"Head of Security\". It has additional armor to protect the wearer."
	name = "head of security's jumpsuit"
	icon_state = "standard_hos"
	worn_state = "standard_hos"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/under/rank/head_of_security/corp
	icon_state = "corporate_hos"
	worn_state = "corporate_hos"
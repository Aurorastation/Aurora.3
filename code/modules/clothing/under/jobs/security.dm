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
	icon_state = "standard_officer"
	worn_state = "standard_officer"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.75

/obj/item/clothing/under/rank/security/corp
	icon_state = "corporate_officer"
	worn_state = "corporate_officer"

/obj/item/clothing/under/rank/security/blue
	icon_state = "alternate_officer"
	worn_state = "alternate_officer"

/obj/item/clothing/under/rank/cadet
	name = "security cadet's uniform"
	desc = "It's made of a slightly sturdier material, to allow for robust protection."
	icon_state = "cadet_standard"
	worn_state = "cadet_standard"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.75

/obj/item/clothing/under/rank/warden
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for more robust protection. It has the word \"Warden\" written on the shoulders."
	name = "warden's uniform"
	icon_state = "standard_warden"
	worn_state = "standard_warden"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.75

/obj/item/clothing/under/rank/warden/corp
	icon_state = "corporate_warden"
	worn_state = "corporate_warden"

/obj/item/clothing/under/rank/warden/blue
	icon_state = "alternate_warden"
	worn_state = "alternate_warden"

/*
 * Detective / Forensics
 */

/obj/item/clothing/under/det
	name = "detective's uniform"
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

/obj/item/clothing/under/det/forensics
	name = "forensics technician's uniform"
	icon_state = "forensic_standard"
	worn_state = "forensic_standard"

/*
 * Head of Security
 */
/obj/item/clothing/under/rank/head_of_security
	desc = "It's a jumpsuit worn by those few with the dedication to achieve the position of \"Head of Security\". It has additional armor to protect the wearer."
	name = "head of security's uniform"
	icon_state = "standard_hos"
	worn_state = "standard_hos"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.75

/obj/item/clothing/under/rank/head_of_security/corp
	icon_state = "corporate_hos"
	worn_state = "corporate_hos"

/obj/item/clothing/under/rank/head_of_security/blue
	icon_state = "alternate_hos"
	worn_state = "alternate_hos"

/*
 * Contractors
 */

/obj/item/clothing/under/rank/security/necropolis
	name = "Necropolis Industries security uniform"
	desc = "A uniform worn by Necropolis Industries security forces."
	icon_state = "necro_sec"
	worn_state = "necro_sec"

/obj/item/clothing/under/rank/security/necropolis/alt
	icon_state = "necro_sec_alt"
	worn_state = "necro_sec_alt"

/obj/item/clothing/under/rank/security/idris
	name = "Idris Incorporated security uniform"
	desc = "A uniform worn by Idris Incorporated employees and contractors."
	icon_state = "idris_sec"
	worn_state = "idris_sec"

/obj/item/clothing/under/rank/security/idris/alt
	icon_state = "tactical_idris"
	worn_state = "tactical_idris"

/obj/item/clothing/under/rank/security/eridani
	name = "Eridani PMC uniform"
	desc = "A uniform worn by contracted Eridani security forces."
	icon_state = "erisec"
	worn_state = "erisec"

/obj/item/clothing/under/rank/security/eridani/alt
	icon_state = "erisec_alt"
	worn_state = "erisec_alt"

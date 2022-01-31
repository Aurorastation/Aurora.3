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
	armor = list(
		melee = ARMOR_MELEE_SMALL
		)
	siemens_coefficient = 0.75

/obj/item/clothing/under/rank/security/zavod
	icon = 'icons/obj/contained_items/department_uniforms/security.dmi'
	icon_state = "zav_officer"
	item_state = "zav_officer"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/security/idris
	icon = 'icons/obj/contained_items/department_uniforms/security.dmi'
	icon_state = "idris_officer"
	item_state = "idris_officer"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/security/pmc
	icon = 'icons/obj/contained_items/department_uniforms/security.dmi'
	icon_state = "epmc_officer"
	item_state = "epmc_officer"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/cadet
	name = "security cadet's uniform"
	desc = "It's made of a slightly sturdier material, to allow for robust protection."
	icon_state = "cadet_standard"
	worn_state = "cadet_standard"
	armor = list(
		melee = ARMOR_MELEE_SMALL
		)
	siemens_coefficient = 0.75

/obj/item/clothing/under/rank/cadet/zavod
	icon = 'icons/obj/contained_items/department_uniforms/security.dmi'
	icon_state = "zav_cadet"
	item_state = "zav_cadet"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/cadet/idris
	icon = 'icons/obj/contained_items/department_uniforms/security.dmi'
	icon_state = "idris_cadet"
	item_state = "idris_cadet"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/cadet/pmc
	icon = 'icons/obj/contained_items/department_uniforms/security.dmi'
	icon_state = "epmc_cadet"
	item_state = "epmc_cadet"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/warden
	name = "warden's uniform"
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for more robust protection. It has the word \"Warden\" written on the shoulders."
	icon_state = "warden_standard"
	worn_state = "warden_standard"
	armor = list(
		melee = ARMOR_MELEE_SMALL
		)
	siemens_coefficient = 0.75

/obj/item/clothing/under/rank/warden/remote
	name = "remote warden's uniform"
	desc = "It's made of a slightly sturdier material than standard jumpsuits. It has the words \"Remote Warden\" written on the shoulders and it's bolted straight onto the chassis."
	canremove = FALSE

/obj/item/clothing/under/rank/warden/remote/Initialize()
	. = ..()
	sensor_mode = 0

/obj/item/clothing/under/rank/warden/zavod
	icon = 'icons/obj/contained_items/department_uniforms/security.dmi'
	icon_state = "zav_warden"
	item_state = "zav_warden"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/warden/idris
	icon = 'icons/obj/contained_items/department_uniforms/security.dmi'
	icon_state = "idris_warden"
	item_state = "idris_warden"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/warden/pmc
	icon = 'icons/obj/contained_items/department_uniforms/security.dmi'
	icon_state = "epmc_warden"
	item_state = "epmc_warden"
	contained_sprite = TRUE

/*
 * Detective / Forensics
 */

/obj/item/clothing/under/det
	name = "investigator's uniform"
	desc = "Someone who wears this means business."
	icon_state = "detective_standard"
	worn_state = "detective_standard"
	armor = list(
		melee = ARMOR_MELEE_SMALL
		)
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
	name = "grey investigator's uniform"
	icon_state = "forensic_standard"
	worn_state = "forensic_standard"

/obj/item/clothing/under/det/zavod
	icon = 'icons/obj/contained_items/department_uniforms/security.dmi'
	icon_state = "zav_invest"
	item_state = "zav_invest"
	contained_sprite = TRUE

/obj/item/clothing/under/det/idris
	icon = 'icons/obj/contained_items/department_uniforms/security.dmi'
	icon_state = "idris_invest"
	item_state = "idris_invest"
	contained_sprite = TRUE

/obj/item/clothing/under/det/pmc
	icon = 'icons/obj/contained_items/department_uniforms/security.dmi'
	icon_state = "epmc_invest"
	item_state = "epmc_invest"
	contained_sprite = TRUE

/*
 * Head of Security
 */
/obj/item/clothing/under/rank/head_of_security
	desc = "It's a jumpsuit worn by those few with the dedication to achieve the position of \"Head of Security\". It has additional armor to protect the wearer."
	name = "head of security's uniform"
	icon = 'icons/obj/contained_items/department_uniforms/command.dmi'
	icon_state = "head_of_security"
	item_state = "head_of_security"
	contained_sprite = TRUE
	armor = list(
		melee = ARMOR_MELEE_SMALL
		)
	siemens_coefficient = 0.75


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

/obj/item/clothing/under/rank/security/eridani
	name = "Eridani PMC uniform"
	desc = "A uniform worn by contracted Eridani security forces."
	icon_state = "erisec"
	worn_state = "erisec"

/obj/item/clothing/under/rank/security/eridani/alt
	icon_state = "erisec_alt"
	worn_state = "erisec_alt"

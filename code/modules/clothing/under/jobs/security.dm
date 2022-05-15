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
	icon = 'icons/obj/contained_items/department_uniforms/security.dmi'
	icon_state = "nt_officer"
	worn_state = "nt_officer"
	armor = list(
		melee = ARMOR_MELEE_SMALL
		)
	siemens_coefficient = 0.75
	contained_sprite = TRUE

/obj/item/clothing/under/rank/security/zavod
	icon_state = "zav_officer"
	item_state = "zav_officer"

/obj/item/clothing/under/rank/security/idris
	icon_state = "idris_officer"
	item_state = "idris_officer"

/obj/item/clothing/under/rank/security/pmc
	icon_state = "pmc_officer"
	item_state = "pmc_officer"

/obj/item/clothing/under/rank/security/pmc/epmc // VTD: Item Icon placeholder
	icon_state = "epmc_officer"
	item_state = "epmc_officer"

/obj/item/clothing/under/rank/security/pmc/epmc_alt // VTD: Item Icon placeholder
	icon_state = "epmc_officer_alt"
	item_state = "epmc_officer_alt"

/obj/item/clothing/under/rank/cadet
	name = "security cadet's uniform"
	desc = "It's made of a slightly sturdier material, to allow for robust protection."
	icon = 'icons/obj/contained_items/department_uniforms/security.dmi'
	icon_state = "nt_cadet"
	worn_state = "nt_cadet"
	armor = list(
		melee = ARMOR_MELEE_SMALL
		)
	siemens_coefficient = 0.75
	contained_sprite = TRUE

/obj/item/clothing/under/rank/cadet/zavod
	icon_state = "zav_cadet"
	item_state = "zav_cadet"

/obj/item/clothing/under/rank/cadet/idris
	icon_state = "idris_cadet"
	item_state = "idris_cadet"

/obj/item/clothing/under/rank/cadet/pmc
	icon_state = "pmc_cadet"
	item_state = "pmc_cadet"

/* VTD: Look deep into yourself and ask if this thing is really something you want to do
/obj/item/clothing/under/rank/cadet/pmc/epmc
	icon_state = "epmc_cadet"
	item_state = "epmc_cadet"
*/

/obj/item/clothing/under/rank/warden
	name = "warden's uniform"
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for more robust protection."
	icon = 'icons/obj/contained_items/department_uniforms/security.dmi'
	icon_state = "nt_warden"
	worn_state = "nt_warden"
	armor = list(
		melee = ARMOR_MELEE_SMALL
		)
	siemens_coefficient = 0.75
	contained_sprite = TRUE

/obj/item/clothing/under/rank/warden/remote
	name = "remote warden's uniform"
	desc = "It's made of a slightly sturdier material than standard jumpsuits. It has the words \"Remote Warden\" written on the shoulders and it's bolted straight onto the chassis."
	canremove = FALSE

/obj/item/clothing/under/rank/warden/remote/Initialize()
	. = ..()
	sensor_mode = 0

/obj/item/clothing/under/rank/warden/zavod
	icon_state = "zav_warden"
	item_state = "zav_warden"

/obj/item/clothing/under/rank/warden/idris
	icon_state = "idris_warden"
	item_state = "idris_warden"

/obj/item/clothing/under/rank/warden/pmc
	icon_state = "pmc_warden"
	item_state = "pmc_warden"

/* VTD: Look deep into yourself and ask if this thing is really something you want to do
/obj/item/clothing/under/rank/warden/pmc/epmc
	icon_state = "epmc_warden"
	item_state = "epmc_warden"
*/

/*
 * Detective / Forensics
 */

/obj/item/clothing/under/det
	name = "investigator's uniform"
	desc = "Someone who wears this means business."
	icon = 'icons/obj/contained_items/department_uniforms/security.dmi'
	icon_state = "nt_invest"
	item_state = "nt_invest"
	armor = list(
		melee = ARMOR_MELEE_SMALL
		)
	siemens_coefficient = 0.75
	contained_sprite = TRUE

/obj/item/clothing/under/det/zavod
	icon_state = "zav_invest"
	item_state = "zav_invest"

/obj/item/clothing/under/det/idris
	icon_state = "idris_invest"
	item_state = "idris_invest"

/obj/item/clothing/under/det/pmc
	icon_state = "pmc_invest"
	item_state = "pmc_invest"

/* VTD: Look deep into yourself and ask if this thing is really something you want to do
/obj/item/clothing/under/det/pmc/epmc
	icon_state = "epmc_invest"
	item_state = "epmc_invest"
*/

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

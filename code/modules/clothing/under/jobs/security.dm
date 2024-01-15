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
	icon = 'icons/obj/item/clothing/department_uniforms/security.dmi'
	icon_state = "nt_officer"
	item_state = "nt_officer"
	armor = list(
		melee = ARMOR_MELEE_SMALL
		)
	siemens_coefficient = 0.75
	contained_sprite = TRUE

/obj/item/clothing/under/rank/security/zavod
	name = "zavodskoi interstellar security officer's uniform"
	icon_state = "zav_officer"
	item_state = "zav_officer"

/obj/item/clothing/under/rank/security/zavod/zavodsec
	name = "zavodskoi interstellar security uniform"
	icon_state = "zavod"
	item_state = "zavod"

/obj/item/clothing/under/rank/security/zavod/zavodsec/alt
	icon_state = "zavod_alt"
	item_state = "zavod_alt"

/obj/item/clothing/under/rank/security/idris
	name = "idris incorporated security officer's uniform"
	icon_state = "idris_officer"
	item_state = "idris_officer"

/obj/item/clothing/under/rank/security/idris/idrissec
	name = "idris incorporated security uniform"
	icon_state = "idris"
	item_state = "idris"

/obj/item/clothing/under/rank/security/idris/idrissec/alt
	icon_state = "idris_alt"
	item_state = "idris_alt"

/obj/item/clothing/under/rank/security/pmc
	name = "PMCG security officer's uniform"
	icon_state = "pmc_officer"
	item_state = "pmc_officer"

/obj/item/clothing/under/rank/security/pmc/pmcsec
	name = "PMCG security uniform"
	icon_state = "pmc"
	item_state = "pmc"

/obj/item/clothing/under/rank/security/pmc/pmcsec/alt
	icon_state = "pmc_alt"
	item_state = "pmc_alt"

/obj/item/clothing/under/rank/security/pmc/epmc // Note: Item Icon placeholder
	name = "EPMC security uniform"
	desc_extended = "The EPMC is a subsidiary of the PMCG."
	icon_state = "epmc"
	item_state = "epmc"

/obj/item/clothing/under/rank/security/pmc/epmc/alt // Note: Item Icon placeholder
	icon_state = "epmc_alt"
	item_state = "epmc_alt"

/obj/item/clothing/under/rank/cadet
	name = "security cadet's uniform"
	desc = "It's made of a slightly sturdier material, to allow for robust protection."
	icon = 'icons/obj/item/clothing/department_uniforms/security.dmi'
	icon_state = "nt_cadet"
	item_state = "nt_cadet"
	armor = list(
		melee = ARMOR_MELEE_SMALL
		)
	siemens_coefficient = 0.75
	contained_sprite = TRUE

/obj/item/clothing/under/rank/cadet/zavod
	name = "zavodskoi interstellar security cadet's uniform"
	icon_state = "zav_cadet"
	item_state = "zav_cadet"

/obj/item/clothing/under/rank/cadet/idris
	name = "idris incorporated security cadet's uniform"
	icon_state = "idris_cadet"
	item_state = "idris_cadet"

/obj/item/clothing/under/rank/cadet/pmc
	name = "PMCG security cadet's uniform"
	icon_state = "pmc_cadet"
	item_state = "pmc_cadet"

/obj/item/clothing/under/rank/security/heph
	name = "hephaestus security officer uniform"
	desc = "A green-and-orange uniform worn by Security Officers of smaller Hephaestus Industries vessels."
	icon = 'icons/clothing/under/uniforms/cyclops_uniforms.dmi'
	icon_state = "heph_security"
	item_state = "heph_security"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/warden
	name = "warden's uniform"
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for more robust protection."
	icon = 'icons/obj/item/clothing/department_uniforms/security.dmi'
	icon_state = "nt_warden"
	item_state = "nt_warden"
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
	name = "zavodskoi interstellar warden's uniform"
	icon_state = "zav_warden"
	item_state = "zav_warden"

/obj/item/clothing/under/rank/warden/idris
	name = "idris incorporated warden's uniform"
	icon_state = "idris_warden"
	item_state = "idris_warden"

/obj/item/clothing/under/rank/warden/pmc
	name = "PMCG warden's uniform"
	icon_state = "pmc_warden"
	item_state = "pmc_warden"

/*
 * Detective / Forensics
 */

/obj/item/clothing/under/det
	name = "investigator's uniform"
	desc = "Someone who wears this means business."
	icon = 'icons/obj/item/clothing/department_uniforms/security.dmi'
	icon_state = "nt_invest"
	item_state = "nt_invest"
	armor = list(
		melee = ARMOR_MELEE_SMALL
		)
	siemens_coefficient = 0.75
	contained_sprite = TRUE

/obj/item/clothing/under/det/zavod
	name = "zavodskoi interstellar investigator's uniform"
	icon_state = "zav_invest"
	item_state = "zav_invest"

/obj/item/clothing/under/det/idris
	name = "idris incorporated investigator's uniform"
	icon_state = "idris_invest"
	item_state = "idris_invest"

/obj/item/clothing/under/det/pmc
	name = "PMCG investigator's uniform"
	icon_state = "pmc_invest"
	item_state = "pmc_invest"

/obj/item/clothing/under/det/zavod/alt
	name = "zavodskoi interstellar detective's uniform"
	icon_state = "zav_invest_alt"
	item_state = "zav_invest_alt"

/obj/item/clothing/under/det/idris/alt
	name = "idris incorporated detective's uniform"
	icon_state = "idris_invest_alt"
	item_state = "idris_invest_alt"

/obj/item/clothing/under/det/pmc/alt
	name = "PMCG detective's uniform"
	icon_state = "pmc_invest_alt"
	item_state = "pmc_invest_alt"


/*
 * Head of Security
 */
/obj/item/clothing/under/rank/head_of_security
	desc = "It's a jumpsuit worn by those few with the dedication to achieve the position of \"Head of Security\". It has additional armor to protect the wearer."
	name = "head of security's uniform"
	icon = 'icons/obj/item/clothing/department_uniforms/command.dmi'
	icon_state = "head_of_security"
	item_state = "head_of_security"
	contained_sprite = TRUE
	armor = list(
		melee = ARMOR_MELEE_SMALL
		)
	siemens_coefficient = 0.75

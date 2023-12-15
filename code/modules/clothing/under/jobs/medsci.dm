/*
 * Science
 */
/obj/item/clothing/under/rank/research_director
	desc = "It's a jumpsuit worn by those with the know-how to achieve the position of \"Research Director\". Its fabric provides minor protection from biological contaminants."
	name = "research director's jumpsuit"
	icon = 'icons/obj/item/clothing/department_uniforms/command.dmi'
	icon_state = "research_director"
	item_state = "research_director"
	contained_sprite = TRUE
	armor = list(
		bio = ARMOR_BIO_MINOR
	)

// Scientist
/obj/item/clothing/under/rank/scientist
	name = "scientist's jumpsuit"
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has markings that denote the wearer as a scientist."
	icon = 'icons/obj/item/clothing/department_uniforms/science.dmi'
	icon_state = "nt_scientist"
	item_state = "nt_scientist"
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
	)
	contained_sprite = TRUE

/obj/item/clothing/under/rank/scientist/zeng
	icon_state = "zeng_scientist"
	item_state = "zeng_scientist"

/obj/item/clothing/under/rank/scientist/zavod
	icon_state = "zav_scientist"
	item_state = "zav_scientist"

// Xenobotanist

/obj/item/clothing/under/rank/scientist/botany
	desc = "It's made of a special fiber that provides minor protection against biohazards. Its colour denotes the wearer as a xenobotanist."
	icon_state = "nt_xenob"
	item_state = "nt_xenob"

/obj/item/clothing/under/rank/scientist/botany/zeng
	icon_state = "zeng_xenob"
	item_state = "zeng_xenob"

/obj/item/clothing/under/rank/scientist/botany/zavod
	icon_state = "zav_xenob"
	item_state = "zav_xenob"

// Xenobiologist

/obj/item/clothing/under/rank/scientist/xenobio
	desc = "It's made of a special fiber that provides minor protection against biohazards. Its colour denotes the wearer as a xenobiologist."
	icon_state = "nt_xenob"
	item_state = "nt_xenob"

/obj/item/clothing/under/rank/scientist/xenobio/zeng
	icon_state = "zeng_xenob"
	item_state = "zeng_xenob"

/obj/item/clothing/under/rank/scientist/xenobio/zavod
	icon_state = "zav_xenob"
	item_state = "zav_xenob"

// Lab Assistant.
/obj/item/clothing/under/rank/scientist/intern
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has markings that denote the wearer as a laboratory assistant."
	name = "laboratory assistant's jumpsuit"
	icon_state = "nt_assistant"
	item_state = "nt_assistant"

/obj/item/clothing/under/rank/scientist/intern/zeng
	icon_state = "zeng_assistant"
	item_state = "zeng_assistant"

/obj/item/clothing/under/rank/scientist/intern/zavod
	icon_state = "zav_assistant"
	item_state = "zav_assistant"

// Xenoarchaeologist
/obj/item/clothing/under/rank/scientist/xenoarchaeologist
	name = "xenoarchaeologist's jumpsuit"
	desc = "It's made of a special fiber that provides minor protection against explosions. It has markings that denote the wearer as a xenoarchaeologist."
	icon_state = "nt_xenoarch"
	item_state = "nt_xenoarch"
	permeability_coefficient = 0.50
	armor = list(
		bomb = ARMOR_BOMB_MINOR
	)

/obj/item/clothing/under/rank/scientist/xenoarchaeologist/zeng
	icon_state = "zeng_xenoarch"
	item_state = "zeng_xenoarch"

/obj/item/clothing/under/rank/scientist/xenoarchaeologist/zavod
	icon_state = "zav_xenoarch"
	item_state = "zav_xenoarch"

/*
 * Medical
 */

/obj/item/clothing/under/rank/chief_medical_officer
	desc = "It's a jumpsuit worn by those with the experience to be \"Chief Medical Officer\". It provides minor biological protection."
	name = "chief medical officer's jumpsuit"
	icon = 'icons/obj/item/clothing/department_uniforms/command.dmi'
	icon_state = "chief_medical_officer"
	item_state = "chief_medical_officer"
	contained_sprite = TRUE
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
	)

/obj/item/clothing/under/rank/iacjumpsuit
	desc = "It's a blue and white jumpsuit, the IAC logo plastered across the back."
	name = "IAC uniform"
	icon = 'icons/clothing/under/uniforms/iac_uniform.dmi'
	icon_state = "iac"
	item_state = "iac"
	contained_sprite = TRUE
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
	)

// Physician

/obj/item/clothing/under/rank/medical
	name = "physician's jumpsuit"
	desc = "It's made of a special fiber that provides minor protection against biohazards. It denotes that the wearer is a trained medical physician."
	icon = 'icons/obj/item/clothing/department_uniforms/medical.dmi'
	icon_state = "nt_phys"
	item_state = "nt_phys"
	contained_sprite = TRUE
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
	)

/obj/item/clothing/under/rank/medical/generic
	icon_state = "generic_scrubs"
	item_state = "generic_scrubs"
	icon = 'icons/clothing/under/uniforms/generic_scrubs.dmi'
	has_accents = TRUE

/obj/item/clothing/under/rank/medical/zeng
	icon_state = "zeng_phys"
	item_state = "zeng_phys"

/obj/item/clothing/under/rank/medical/pmc
	icon_state = "pmc_phys"
	item_state = "pmc_phys"

/obj/item/clothing/under/rank/medical/pmc/alt
	icon_state = "pmc_alt_phys"
	item_state = "pmc_alt_phys"

// Intern

/obj/item/clothing/under/rank/medical/intern
	name = "medical intern's jumpsuit"
	desc = "It's made of a special fiber that provides minor protection against biohazards. It denotes that the wearer is a medical intern."
	icon_state = "nt_intern"
	item_state = "nt_intern"

/obj/item/clothing/under/rank/medical/intern/zeng
	icon_state = "zeng_intern"
	item_state = "zeng_intern"

/obj/item/clothing/under/rank/medical/intern/pmc
	icon_state = "pmc_intern"
	item_state = "pmc_intern"

/obj/item/clothing/under/rank/medical/intern/pmc/alt
	icon_state = "pmc_alt_intern"
	item_state = "pmc_alt_intern"

// First Responder

/obj/item/clothing/under/rank/medical/first_responder
	name = "first responder jumpsuit"
	desc = "It's made of a special fiber that provides minor protection against biohazards. It's a special jumpsuit made for first responders."
	icon_state = "nt_emt"
	item_state = "nt_emt"

/obj/item/clothing/under/rank/medical/first_responder/zeng
	icon_state = "zeng_emt"
	item_state = "zeng_emt"

/obj/item/clothing/under/rank/medical/first_responder/pmc
	icon_state = "pmc_emt"
	item_state = "pmc_emt"

/obj/item/clothing/under/rank/medical/first_responder/pmc/alt
	icon_state = "pmc_emt"
	item_state = "pmc_emt"

/obj/item/clothing/under/rank/medical/first_responder/pmc/epmc
	icon_state = "epmc_emt"
	item_state = "epmc_emt"

/obj/item/clothing/under/rank/medical/first_responder/pmc/sekh
	icon_state = "sekh_emt"
	item_state = "sekh_emt"

// Surgeon
/obj/item/clothing/under/rank/medical/surgeon
	name = "surgeon's scrubs"
	desc = "It's made of a special fiber that provides minor protection against biohazards. Specially fitted to ensure surgical precision."
	icon_state = "nt_surgeon"
	item_state = "nt_surgeon"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/medical/surgeon/zeng
	icon_state = "zeng_surgeon"
	item_state = "zeng_surgeon"

/obj/item/clothing/under/rank/medical/surgeon/pmc
	icon_state = "pmc_surgeon"
	item_state = "pmc_surgeon"

/obj/item/clothing/under/rank/medical/surgeon/pmc/alt
	icon_state = "pmc_alt_surgeon"
	item_state = "pmc_alt_surgeon"

// Zavodskoi and Idris don't have medical jobs, but jobs like xenobiologist and investigators use them ancilliarily.

/obj/item/clothing/under/rank/medical/surgeon/zavod
	icon_state = "zav_surgeon"
	item_state = "zav_surgeon"

/obj/item/clothing/under/rank/medical/surgeon/idris
	icon_state = "idris_surgeon"
	item_state = "idris_surgeon"

// Psychiatrist

/obj/item/clothing/under/rank/medical/psych
	name = "psychiatrist's jumpsuit"
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has markings that denote the wearer as a psychiatrist."
	icon_state = "nt_psych"
	item_state = "nt_psych"

/obj/item/clothing/under/rank/medical/psych/zeng
	icon_state = "zeng_psych"
	item_state = "zeng_psych"

/obj/item/clothing/under/rank/medical/psych/pmc
	icon_state = "pmc_psych"
	item_state = "pmc_psych"

/obj/item/clothing/under/rank/medical/psych/pmc/alt
	icon_state = "pmc_alt_psych"
	item_state = "pmc_alt_psych"

// Pharmacist

/obj/item/clothing/under/rank/medical/pharmacist
	name = "pharmacist's jumpsuit"
	desc = "It's made of a special fiber that gives special protection against biohazards. It has markings that denote the wearer as a pharmacist."
	icon_state = "nt_chemist"
	item_state = "nt_chemist"

/obj/item/clothing/under/rank/medical/pharmacist/zeng
	icon_state = "zeng_chemist"
	item_state = "zeng_chemist"

/obj/item/clothing/under/rank/medical/pharmacist/pmc
	icon_state = "pmc_chemist"
	item_state = "pmc_chemist"

/obj/item/clothing/under/rank/medical/pharmacist/pmc/alt
	icon_state = "pmc_chemist"
	item_state = "pmc_chemist"

/*
 * Science
 */
/obj/item/clothing/under/rank/research_director
	desc = "It's a jumpsuit worn by those with the know-how to achieve the position of \"Research Director\". Its fabric provides minor protection from biological contaminants."
	name = "research director's jumpsuit"
	icon = 'icons/obj/contained_items/department_uniforms/command.dmi'
	icon_state = "research_director"
	item_state = "research_director"
	contained_sprite = TRUE
	armor = list(
		bio = ARMOR_BIO_MINOR
	)


/obj/item/clothing/under/rank/scientist
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has markings that denote the wearer as a scientist."
	name = "scientist's jumpsuit"
	icon_state = "science"
	item_state = "w_suit"
	worn_state = "science"
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
	)

/obj/item/clothing/under/rank/scientist/nt
	icon = 'icons/obj/contained_items/department_uniforms/science.dmi'
	icon_state = "nt_scientist"
	item_state = "nt_scientist"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/scientist/zeng
	icon = 'icons/obj/contained_items/department_uniforms/science.dmi'
	icon_state = "zeng_scientist"
	item_state = "zeng_scientist"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/scientist/zavod
	icon = 'icons/obj/contained_items/department_uniforms/science.dmi'
	icon_state = "zav_scientist"
	item_state = "zav_scientist"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/scientist/botany
	desc = "It's made of a special fiber that provides minor protection against biohazards. Its colour denotes the wearer as a xenobotanist."
	icon = 'icons/obj/contained_items/department_uniforms/science.dmi'
	icon_state = "nt_xenob"
	item_state = "nt_xenob"
	contained_sprite = TRUE
	armor = list(
		bio = ARMOR_BIO_MINOR
	)

/obj/item/clothing/under/rank/scientist/botany/zeng
	icon = 'icons/obj/contained_items/department_uniforms/science.dmi'
	icon_state = "zeng_xenob"
	item_state = "zeng_xenob"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/scientist/botany/zavod
	icon = 'icons/obj/contained_items/department_uniforms/science.dmi'
	icon_state = "zav_xenob"
	item_state = "zav_xenob"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/scientist/xenobio
	desc = "It's made of a special fiber that provides minor protection against biohazards. Its colour denotes the wearer as a xenobiologist."
	icon = 'icons/obj/contained_items/department_uniforms/science.dmi'
	icon_state = "nt_xenob"
	item_state = "nt_xenob"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/scientist/xenobio/zeng
	icon = 'icons/obj/contained_items/department_uniforms/science.dmi'
	icon_state = "zeng_xenob"
	item_state = "zeng_xenob"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/scientist/xenobio/zavod
	icon = 'icons/obj/contained_items/department_uniforms/science.dmi'
	icon_state = "zav_xenob"
	item_state = "zav_xenob"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/scientist/intern
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has markings that denote the wearer as a laboratory assistant."
	name = "laboratory assistant's jumpsuit"
	icon_state = "intern_science"
	worn_state = "intern_science"

/obj/item/clothing/under/rank/scientist/intern/nt
	icon = 'icons/obj/contained_items/department_uniforms/science.dmi'
	icon_state = "nt_assistant"
	item_state = "nt_assistant"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/scientist/intern/zeng
	icon = 'icons/obj/contained_items/department_uniforms/science.dmi'
	icon_state = "zeng_assistant"
	item_state = "zeng_assistant"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/scientist/intern/zavod
	icon = 'icons/obj/contained_items/department_uniforms/science.dmi'
	icon_state = "zav_assistant"
	item_state = "zav_assistant"
	contained_sprite = TRUE


/obj/item/clothing/under/rank/xenoarcheologist
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has markings that denote the wearer as a xenoarcheologist."
	name = "xenoarcheologist's jumpsuit"
	icon_state = "xenoarcheology"
	item_state = "w_suit"
	worn_state = "xenoarcheology"
	permeability_coefficient = 0.50
	armor = list(
		bomb = ARMOR_BOMB_MINOR
	)

/obj/item/clothing/under/rank/xenoarcheologist/nt
	icon = 'icons/obj/contained_items/department_uniforms/science.dmi'
	icon_state = "nt_xenoarch"
	item_state = "nt_xenoarch"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/xenoarcheologist/zeng
	icon = 'icons/obj/contained_items/department_uniforms/science.dmi'
	icon_state = "zeng_xenoarch"
	item_state = "zeng_xenoarch"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/xenoarcheologist/zavod
	icon = 'icons/obj/contained_items/department_uniforms/science.dmi'
	icon_state = "zav_xenoarch"
	item_state = "zav_xenoarch"
	contained_sprite = TRUE

/*
 * Medical
 */
/obj/item/clothing/under/rank/chief_medical_officer
	desc = "It's a jumpsuit worn by those with the experience to be \"Chief Medical Officer\". It provides minor biological protection."
	name = "chief medical officer's jumpsuit"
	icon = 'icons/obj/contained_items/department_uniforms/command.dmi'
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
	icon_state = "iacuniform"
	item_state = "iacuniform"
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
	)

/obj/item/clothing/under/rank/medical
	desc = "It's made of a special fiber that provides minor protection against biohazards. It denotes that the wearer is trained medical personnel."
	name = "physician's jumpsuit"
	icon_state = "medical"
	item_state = "w_suit"
	worn_state = "medical"
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
	)

/obj/item/clothing/under/rank/medical/intern
	desc = "It's made of a special fiber that provides minor protection against biohazards. It denotes that the wearer is still a medical intern."
	name = "medical intern's jumpsuit"
	icon_state = "intern_medical"
	worn_state = "intern_medical"

/obj/item/clothing/under/rank/medical/intern/zeng
	icon = 'icons/obj/contained_items/department_uniforms/medical.dmi'
	icon_state = "zeng_intern"
	item_state = "zeng_intern"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/medical/intern/nt
	icon = 'icons/obj/contained_items/department_uniforms/medical.dmi'
	icon_state = "nt_intern"
	item_state = "nt_intern"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/medical/intern/pmc
	icon = 'icons/obj/contained_items/department_uniforms/medical.dmi'
	icon_state = "epmc_intern"
	item_state = "epmc_intern"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/medical/blue
	name = "medical scrubs"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in baby blue."
	icon_state = "scrubsblue"
	item_state = "b_suit"
	worn_state = "scrubsblue"

/obj/item/clothing/under/rank/medical/green
	name = "medical scrubs"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in dark green."
	icon_state = "scrubsgreen"
	item_state = "g_suit"
	worn_state = "scrubsgreen"

/obj/item/clothing/under/rank/medical/purple
	name = "medical scrubs"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in deep purple."
	icon_state = "scrubspurple"
	item_state = "p_suit"
	worn_state = "scrubspurple"

/obj/item/clothing/under/rank/medical/black
	name = "medical scrubs"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in black."
	icon_state = "scrubsblack"
	item_state = "bl_suit"
	worn_state = "scrubsblack"

/obj/item/clothing/under/rank/medical/zeng
	icon = 'icons/obj/contained_items/department_uniforms/medical.dmi'
	icon_state = "zeng_phys"
	item_state = "zeng_phys"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/medical/nt
	icon = 'icons/obj/contained_items/department_uniforms/medical.dmi'
	icon_state = "nt_phys"
	item_state = "nt_phys"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/medical/pmc
	icon = 'icons/obj/contained_items/department_uniforms/medical.dmi'
	icon_state = "epmc_phys"
	item_state = "epmc_phys"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/medical/first_responder
	name = "first responder jumpsuit"
	desc = "A jumpsuit that denotes the wearer as a Nanotrasen First Responder."
	icon = 'icons/clothing/kit/first_responder.dmi'
	contained_sprite = TRUE
	icon_state = "firstresponderjumpsuit"
	item_state = "firstresponderjumpsuit"
	worn_state = "firstresponderjumpsuit"

/obj/item/clothing/under/rank/medical/first_responder/zeng
	icon = 'icons/obj/contained_items/department_uniforms/medical.dmi'
	icon_state = "zeng_emt"
	item_state = "zeng_emt"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/medical/first_responder/nt
	icon = 'icons/obj/contained_items/department_uniforms/medical.dmi'
	icon_state = "nt_emt"
	item_state = "nt_emt"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/medical/first_responder/pmc
	icon = 'icons/obj/contained_items/department_uniforms/medical.dmi'
	icon_state = "epmc_emt"
	item_state = "epmc_emt"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/medical/surgeon/zeng
	icon = 'icons/obj/contained_items/department_uniforms/medical.dmi'
	icon_state = "zeng_surgeon"
	item_state = "zeng_surgeon"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/medical/surgeon/nt
	icon = 'icons/obj/contained_items/department_uniforms/medical.dmi'
	icon_state = "nt_surgeon"
	item_state = "nt_surgeon"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/medical/surgeon/pmc
	icon = 'icons/obj/contained_items/department_uniforms/medical.dmi'
	icon_state = "epmc_surgeon"
	item_state = "epmc_surgeon"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/psych
	desc = "A basic white jumpsuit. It has turqouise markings that denote the wearer as a psychiatrist."
	name = "psychiatrist's jumpsuit"
	icon_state = "psych"
	item_state = "w_suit"
	worn_state = "psych"

/obj/item/clothing/under/rank/psych/zeng
	icon = 'icons/obj/contained_items/department_uniforms/medical.dmi'
	icon_state = "zeng_psych"
	item_state = "zeng_psych"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/psych/nt
	icon = 'icons/obj/contained_items/department_uniforms/medical.dmi'
	icon_state = "nt_psych"
	item_state = "nt_psych"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/psych/pmc
	icon = 'icons/obj/contained_items/department_uniforms/medical.dmi'
	icon_state = "epmc_psych"
	item_state = "epmc_psych"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/pharmacist
	desc = "It's made of a special fiber that gives special protection against biohazards. It has a pharmacist rank stripe on it."
	name = "pharmacist's jumpsuit"
	icon_state = "chemistry"
	item_state = "w_suit"
	worn_state = "chemistry"
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
	)

/obj/item/clothing/under/rank/pharmacist/zeng
	icon = 'icons/obj/contained_items/department_uniforms/medical.dmi'
	icon_state = "zeng_chemist"
	item_state = "zeng_chemist"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/pharmacist/nt
	icon = 'icons/obj/contained_items/department_uniforms/medical.dmi'
	icon_state = "nt_chemist"
	item_state = "nt_chemist"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/pharmacist/pmc
	icon = 'icons/obj/contained_items/department_uniforms/medical.dmi'
	icon_state = "epmc_chemist"
	item_state = "epmc_chemist"
	contained_sprite = TRUE
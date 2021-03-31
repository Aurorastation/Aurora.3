/*
 * Science
 */
/obj/item/clothing/under/rank/research_director
	desc = "It's a jumpsuit worn by those with the know-how to achieve the position of \"Research Director\". Its fabric provides minor protection from biological contaminants."
	name = "research director's jumpsuit"
	icon_state = "rd"
	item_state = "lb_suit"
	worn_state = "rd"
	armor = list(
		bio = ARMOR_BIO_MINOR
	)

/obj/item/clothing/under/rank/research_director/rdalt
	desc = "A dress suit and slacks stained with hard work and dedication to science. Perhaps other things as well, but mostly hard work and dedication."
	name = "head researcher uniform"
	icon_state = "rdalt"
	item_state = "lb_suit"
	worn_state = "rdalt"
	armor = list(
		bio = ARMOR_BIO_MINOR
	)

/obj/item/clothing/under/rank/research_director/dress_rd
	name = "research director dress uniform"
	desc = "Feminine fashion for the style concious RD. Its fabric provides minor protection from biological contaminants."
	icon_state = "dress_rd"
	item_state = "lb_suit"
	worn_state = "dress_rd"
	armor = list(
		bio = ARMOR_BIO_MINOR
	)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

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
/obj/item/clothing/under/rank/scientist/xenoarcheologist
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has markings that denote the wearer as a scientist."
	name = "xenoarcheologist's jumpsuit"
	icon_state = "xenoarcheology"
	item_state = "w_suit"
	worn_state = "xenoarcheology"
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
	)

/obj/item/clothing/under/rank/scientist/science_alt
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has markings that denote the wearer as a scientist."
	name = "scientist's uniform"
	icon_state = "science_alt"
	item_state = "w_suit"
	worn_state = "science_alt"
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
	)

/obj/item/clothing/under/rank/scientist/botany
	desc = "It's made of a special fiber that provides minor protection against biohazards. Its colour denotes the wearer as a xenobotanist."
	icon_state = "botany"
	worn_state = "botany"
	armor = list(
		bio = ARMOR_BIO_MINOR
	)

/obj/item/clothing/under/rank/scientist/intern
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has markings that denote the wearer as a laboratory assistant."
	name = "laboratory assistant's jumpsuit"
	icon_state = "intern_science"
	worn_state = "intern_science"

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

/*
 * Medical
 */
/obj/item/clothing/under/rank/chief_medical_officer
	desc = "It's a jumpsuit worn by those with the experience to be \"Chief Medical Officer\". It provides minor biological protection."
	name = "chief medical officer's jumpsuit"
	icon_state = "cmo"
	item_state = "w_suit"
	worn_state = "cmo"
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
	)

/obj/item/clothing/under/rank/geneticist
	desc = "It's made of a special fiber that gives special protection against biohazards. It has a genetics rank stripe on it."
	name = "geneticist's jumpsuit"
	icon_state = "genetics"
	item_state = "w_suit"
	worn_state = "geneticswhite"
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
	)

/obj/item/clothing/under/rank/virologist
	desc = "It's made of a special fiber that gives special protection against biohazards. It has a virologist rank stripe on it."
	name = "virologist's jumpsuit"
	icon_state = "virology"
	item_state = "w_suit"
	worn_state = "virology"
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

/obj/item/clothing/under/rank/medical/first_responder
	name = "first responder jumpsuit"
	desc = "A jumpsuit that denotes the wearer as a Nanotrasen First Responder."
	icon = 'icons/clothing/kit/first_responder.dmi'
	contained_sprite = TRUE
	icon_state = "firstresponderjumpsuit"
	item_state = "firstresponderjumpsuit"
	worn_state = "firstresponderjumpsuit"

/obj/item/clothing/under/rank/psych
	desc = "A basic white jumpsuit. It has turqouise markings that denote the wearer as a psychiatrist."
	name = "psychiatrist's jumpsuit"
	icon_state = "psych"
	item_state = "w_suit"
	worn_state = "psych"

/obj/item/clothing/under/rank/biochemist
	desc = "Made of a special fiber that gives increased protection against hazards."
	name = "chemist's jumpsuit"
	icon_state = "virology"
	item_state = "w_suit"
	worn_state = "virology"
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
	)

/obj/item/clothing/under/rank/nanomachine
	name = "nanomachine technician's jumpsuit"
	desc = "A stylish white jumpsuit. Its purple lining denotes the wearer as a nanomachine technician."
	icon = 'icons/clothing/kit/nanomachine_technician.dmi'
	icon_state = "nanomachine_jumpsuit"
	item_state = "nanomachine_jumpsuit"
	contained_sprite = TRUE
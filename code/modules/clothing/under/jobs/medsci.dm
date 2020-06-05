/*
 * Science
 */
/obj/item/clothing/under/rank/research_director
	desc = "It's a jumpsuit worn by those with the know-how to achieve the position of \"Research Director\". Its fabric provides minor protection from biological contaminants."
	name = "research director's jumpsuit"
	icon_state = "rd"
	item_state = "lb_suit"
	worn_state = "rd"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/research_director/rdalt
	desc = "A dress suit and slacks stained with hard work and dedication to science. Perhaps other things as well, but mostly hard work and dedication."
	name = "head researcher uniform"
	icon_state = "rdalt"
	item_state = "lb_suit"
	worn_state = "rdalt"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/research_director/dress_rd
	name = "research director dress uniform"
	desc = "Feminine fashion for the style concious RD. Its fabric provides minor protection from biological contaminants."
	icon_state = "dress_rd"
	item_state = "lb_suit"
	worn_state = "dress_rd"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/rank/scientist
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has markings that denote the wearer as a scientist."
	name = "scientist's jumpsuit"
	icon_state = "science"
	item_state = "w_suit"
	worn_state = "science"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/under/rank/scientist/xenoarcheologist
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has markings that denote the wearer as a scientist."
	name = "xenoarcheologist's jumpsuit"
	icon_state = "xenoarcheology"
	item_state = "w_suit"
	worn_state = "xenoarcheology"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/under/rank/scientist/science_alt
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has markings that denote the wearer as a scientist."
	name = "scientist's uniform"
	icon_state = "science_alt"
	item_state = "w_suit"
	worn_state = "science_alt"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/under/rank/scientist/botany
	desc = "It's made of a special fiber that provides minor protection against biohazards. Its colour denotes the wearer as a xenobotanist."
	icon_state = "botany"
	worn_state = "botany"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 10, bio = 5, rad = 0)

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
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/xenoarcheologist
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has markings that denote the wearer as a xenoarcheologist."
	name = "xenoarcheologist's jumpsuit"
	icon_state = "xenoarcheology"
	item_state = "w_suit"
	worn_state = "xenoarcheology"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 10, bio = 0, rad = 0)

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
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/geneticist
	desc = "It's made of a special fiber that gives special protection against biohazards. It has a genetics rank stripe on it."
	name = "geneticist's jumpsuit"
	icon_state = "genetics"
	item_state = "w_suit"
	worn_state = "geneticswhite"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/virologist
	desc = "It's made of a special fiber that gives special protection against biohazards. It has a virologist rank stripe on it."
	name = "virologist's jumpsuit"
	icon_state = "virology"
	item_state = "w_suit"
	worn_state = "virology"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/iacjumpsuit
	desc = "It's a blue and white jumpsuit, the IAC logo plastered across the back."
	name = "IAC uniform"
	icon_state = "iacuniform"
	item_state = "iacuniform"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 15, rad = 5)

/obj/item/clothing/under/rank/medical
	desc = "It's made of a special fiber that provides minor protection against biohazards. It denotes that the wearer is trained medical personnel."
	name = "physician's jumpsuit"
	icon_state = "medical"
	item_state = "w_suit"
	worn_state = "medical"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/medical/intern
	desc = "It's made of a special fiber that provides minor protection against biohazards. It denotes that the wearer is still a medical intern."
	name = "medical resident's jumpsuit"
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
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

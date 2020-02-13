//Alphabetical order of civilian jobs.

/obj/item/clothing/under/rank/bartender
	desc = "It looks like it could use some more flair."
	name = "bartender's uniform"
	icon_state = "ba_suit"
	item_state = "ba_suit"
	worn_state = "ba_suit"

/obj/item/clothing/under/rank/captain //Alright, technically not a 'civilian' but its better then giving a .dm file for a single define.
	desc = "It's a blue jumpsuit with some gold markings denoting the rank of \"Captain\"."
	name = "captain's jumpsuit"
	icon_state = "captain"
	item_state = "b_suit"
	worn_state = "captain"

/obj/item/clothing/under/rank/cargo
	name = "quartermaster's jumpsuit"
	desc = "It's a jumpsuit worn by the quartermaster. It's specially designed to prevent back injuries caused by pushing paper."
	icon_state = "qm"
	item_state = "lb_suit"
	worn_state = "qm"

/obj/item/clothing/under/rank/cargotech
	name = "cargo technician's jumpsuit"
	desc = "The future of cargo tech apparel: long, stuffy slacks. We never said it was a bright future."
	icon_state = "cargotech"
	item_state = "lb_suit"
	worn_state = "cargo"

/obj/item/clothing/under/rank/cargotech/alt
	desc = "Shooooorts! They're comfy and easy to wear!"
	icon_state = "cargotech_alt"
	worn_state = "cargo_alt"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/rank/chaplain
	desc = "It's a black jumpsuit, often worn by religious folk."
	name = "chaplain's jumpsuit"
	icon_state = "chaplain"
	item_state = "bl_suit"
	worn_state = "chapblack"

/obj/item/clothing/under/rank/chef
	desc = "It's an apron which is given only to the most <b>hardcore</b> chefs in space."
	name = "chef's uniform"
	icon_state = "chef"
	item_state = "w_suit"
	worn_state = "chef"

/obj/item/clothing/under/rank/clown
	name = "clown suit"
	desc = "<i>'HONK!'</i>"
	icon_state = "clown"
	item_state = "clown"
	worn_state = "clown"

/obj/item/clothing/under/rank/head_of_personnel
	desc = "It's a jumpsuit worn by someone who works in the position of \"Head of Personnel\"."
	name = "head of personnel's jumpsuit"
	icon_state = "hop"
	item_state = "b_suit"
	worn_state = "hop"

/obj/item/clothing/under/rank/head_of_personnel_whimsy
	desc = "A blue jacket and red tie, with matching red cuffs! Snazzy. Wearing this makes you feel more important than your job title does."
	name = "head of personnel's suit"
	icon_state = "hopwhimsy"
	item_state = "b_suit"
	worn_state = "hopwhimsy"

/obj/item/clothing/under/rank/hydroponics
	desc = "It's a jumpsuit designed to protect against minor plant-related hazards."
	name = "botanist's jumpsuit"
	icon_state = "hydroponics"
	item_state = "g_suit"
	worn_state = "hydroponics"
	permeability_coefficient = 0.50

/obj/item/clothing/under/rank/liaison
	desc = "The plain, professional attire of a corporate liaison. The collar is <i>immaculately</i> starched."
	name = "corporate liaison uniform"
	icon_state = "internalaffairs"
	item_state = "ba_suit"
	worn_state = "internalaffairs"

/obj/item/clothing/under/rank/janitor
	desc = "It's the official uniform of the station's janitor. It has minor protection from biohazards."
	name = "janitor's jumpsuit"
	icon_state = "janitor"
	worn_state = "janitor"
	item_state = "janitor"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/lawyer
	desc = "Slick threads."
	name = "lawyer suit"

/obj/item/clothing/under/lawyer/black
	name = "black lawyer suit"
	icon_state = "lawyer_black"
	item_state = "lawyer_black"
	worn_state = "lawyer_black"

/obj/item/clothing/under/lawyer/female
	name = "black lawyer suit"
	icon_state = "black_suit_fem"
	item_state = "lawyer_black"
	worn_state = "black_suit_fem"

/obj/item/clothing/under/lawyer/red
	name = "red Lawyer suit"
	icon_state = "lawyer_red"
	item_state = "lawyer_red"
	worn_state = "lawyer_red"

/obj/item/clothing/under/lawyer/blue
	name = "blue Lawyer suit"
	icon_state = "lawyer_blue"
	item_state = "lawyer_blue"
	worn_state = "lawyer_blue"

/obj/item/clothing/under/lawyer/bluesuit
	name = "blue suit"
	desc = "A classy suit and tie"
	icon_state = "bluesuit"
	item_state = "ba_suit"
	worn_state = "bluesuit"

/obj/item/clothing/under/lawyer/purpsuit
	name = "purple suit"
	icon_state = "lawyer_purp"
	item_state = "ba_suit"
	worn_state = "lawyer_purp"

/obj/item/clothing/under/lawyer/oldman
	name = "old man's suit"
	desc = "A classic suit for the older gentleman with built in back support."
	icon_state = "oldman"
	item_state = "johnny"
	worn_state = "oldman"

/obj/item/clothing/under/librarian
	name = "sensible suit"
	desc = "It's very... sensible."
	icon_state = "red_suit"
	item_state = "lawyer_red"
	worn_state = "red_suit"

/obj/item/clothing/under/mime
	name = "mime's outfit"
	desc = "It's not very colourful."
	icon_state = "mime"
	item_state = "ba_suit"
	worn_state = "mime"

/obj/item/clothing/under/rank/miner
	desc = "It's a snappy miner's jumpsuit, sans overalls and caked with dirt."
	name = "shaft miner's jumpsuit"
	icon_state = "miner"
	item_state = "lb_suit"
	worn_state = "miner"

/obj/item/clothing/under/rank/hephaestus
	name = "Hephaestus Industries engineer uniform"
	desc = "A uniform worn by Hephaestus Industries engineers."
	icon_state = "heph_engineer"
	worn_state = "heph_engineer"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 10)
	siemens_coefficient = 0.75	

/obj/item/clothing/under/rank/hephaestus/tech
	name = "Hephaestus Industries technician uniform"
	desc = "A uniform worn by Hephaestus Industries technicians."
	icon_state = "heph_technician"
	worn_state = "heph_technician"

/obj/item/clothing/under/rank/hephaestus/research
	name = "Hephaestus Industries research uniform"
	desc = "A uniform worn by Hephaestus Industries researchers."
	icon_state = "heph_research"
	worn_state = "heph_research"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 10, bio = 0, rad = 10)	

/obj/item/clothing/under/rank/necropolis
	name = "Necropolis Industries uniform"
	desc = "A uniform worn by Necropolis Industries employees and contractors."
	icon_state = "necro"
	worn_state = "necro"

/obj/item/clothing/under/rank/necropolis/research
	name = "Necropolis Industries research uniform"
	desc = "A uniform worn by Necropolis Industries researchers."
	icon_state = "necro_research"
	worn_state = "necro_research"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 10, bio = 0, rad = 0)	

/obj/item/clothing/under/rank/necropolis/research/alt
	icon_state = "necro_research_alt"
	worn_state = "necro_research_alt"

/obj/item/clothing/under/rank/idris
	name = "Idris Incorporated uniform"
	desc = "A uniform worn by Idris Incorporated employees and contractors."
	icon_state = "idris_service"
	worn_state = "idris_service"

/obj/item/clothing/under/rank/idris/service
	name = "Idris Incorporated service uniform"
	desc = "A uniform worn by Idris Incorporated service personnel."

/obj/item/clothing/under/rank/idris/service/alt
	icon_state = "idris_service_alt"
	worn_state = "idris_service_alt"

/obj/item/clothing/under/rank/einstein_engines
	name = "Einstein Engines uniform"
	desc = "A uniform worn by Einstein Engines Incorporated employees and contractors."
	icon_state = "einstein_engine"
	worn_state = "einstein_engine"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 10)
	siemens_coefficient = 0.75	

/obj/item/clothing/under/rank/zeng
	name = "Zeng-Hu uniform"
	desc = "A uniform worn by Zeng-Hu medical doctors and researchers."
	icon_state = "zeng_research"
	worn_state = "zeng_research"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 10, bio = 10, rad = 0)	

/obj/item/clothing/under/rank/zeng/alt
	icon_state = "zeng_research_alt"
	worn_state = "zeng_research_alt"

/obj/item/clothing/under/rank/zeng/civilian
	name = "Zeng-Hu civilian uniform"
	desc = "A uniform worn by Zeng-Hu employees."
	icon_state = "zeng_service"
	worn_state = "zeng_service"

/obj/item/clothing/under/rank/eridani_medic
	name = "Eridani PMC medic uniform"
	desc = "A uniform worn by Eridani PMC paramedics."
	icon_state = "eridani_medic"
	worn_state = "eridani_medic"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 10, rad = 0)		


// side project placeholders of what needs to be done, using other codebase sprites or present ones

//ranger stuff
/obj/item/clothing/under/rank/ranger
	name = "Ranger uniform"
	desc = "A uniform utilized by rank and file rangers."
	icon_state = "necro_research_alt"
	worn_state = "necro_research_alt"

/obj/item/clothing/under/rank/ranger/lead
	name = "Ranger Lieutenant uniform"
	desc = "A uniform utilized by ranking ranger officers."

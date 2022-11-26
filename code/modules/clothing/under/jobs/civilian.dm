//Alphabetical order of civilian jobs.

/obj/item/clothing/under/rank/bartender
	name = "bartender's uniform"
	desc = "It looks like it could use some more flair."
	icon = 'icons/obj/contained_items/department_uniforms/service.dmi'
	contained_sprite = TRUE
	icon_state = "nt_bartender"
	item_state = "nt_bartender"

/obj/item/clothing/under/rank/bartender/idris
	icon_state = "idris_bartender"
	item_state = "idris_bartender"
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

/obj/item/clothing/under/rank/chef/nt
	icon = 'icons/obj/contained_items/department_uniforms/service.dmi'
	contained_sprite = TRUE
	icon_state = "nt_chef"
	item_state = "nt_chef"

/obj/item/clothing/under/rank/chef/idris
	icon = 'icons/obj/contained_items/department_uniforms/service.dmi'
	contained_sprite = TRUE
	icon_state = "idris_chef"
	item_state = "idris_chef"

/obj/item/clothing/under/rank/hydroponics
	desc = "It's a jumpsuit designed to protect against minor plant-related hazards."
	name = "botanist's jumpsuit"
	icon = 'icons/obj/contained_items/department_uniforms/service.dmi'
	icon_state = "nt_gardener"
	item_state = "nt_gardener"
	permeability_coefficient = 0.50
	contained_sprite = TRUE
/obj/item/clothing/under/rank/hydroponics/idris
	icon_state = "idris_gardener"
	item_state = "idris_gardener"

// Liaison, a.k.a. Internal Affairs

/obj/item/clothing/under/rank/liaison
	name = "corporate liaison uniform"
	desc = "The plain, professional attire of a corporate liaison. The collar is <i>immaculately</i> starched."
	icon = 'icons/obj/contained_items/department_uniforms/service.dmi'
	icon_state = "nt_liaison"
	item_state = "nt_liaison"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/liaison/zeng
	icon_state = "zeng_liaison"
	item_state = "zeng_liaison"

/obj/item/clothing/under/rank/liaison/zavod
	icon_state = "zav_liaison"
	item_state = "zav_liaison"

/obj/item/clothing/under/rank/liaison/heph
	icon_state = "heph_liaison"
	item_state = "heph_liaison"

/obj/item/clothing/under/rank/liaison/pmc
	icon_state = "pmc_liaison"
	item_state = "pmc_liaison"

/obj/item/clothing/under/rank/liaison/idris
	icon_state = "idris_liaison"
	item_state = "idris_liaison"

/obj/item/clothing/under/rank/liaison/orion
	icon_state = "orion_liaison"
	item_state = "orion_liaison"

// Janitor
/obj/item/clothing/under/rank/janitor
	desc = "It's the official uniform of the facilities janitor. It has minor protection from biohazards."
	name = "janitor's jumpsuit"
	icon = 'icons/obj/contained_items/department_uniforms/service.dmi'
	icon_state = "nt_janitor"
	item_state = "nt_janitor"
	contained_sprite = TRUE
	armor = list(
		bio = ARMOR_BIO_MINOR
	)

/obj/item/clothing/under/rank/janitor/alt
	icon_state = "nt_janitor_alt"
	item_state = "nt_janitor_alt"

/obj/item/clothing/under/rank/janitor/idris
	icon_state = "idris_janitor"
	item_state = "idris_janitor"

/obj/item/clothing/under/rank/janitor/idris/alt
	icon_state = "idris_janitor_alt"
	item_state = "idris_janitor_alt"

// Lawyer (to be replaced by modularization)

/obj/item/clothing/under/lawyer
	desc = "Slick threads."
	name = "lawyer suit"

/obj/item/clothing/under/lawyer/red
	name = "garish red suit"
	icon_state = "lawyer_red"
	item_state = "lawyer_red"
	worn_state = "lawyer_red"

/obj/item/clothing/under/lawyer/purple
	name = "garish purple suit"
	icon_state = "lawyer_purple"
	item_state = "ba_suit"
	worn_state = "lawyer_purple"

// Librarian

/obj/item/clothing/under/librarian
	name = "sensible suit"
	desc = "It's very... sensible."
	icon = 'icons/obj/contained_items/department_uniforms/service.dmi'
	contained_sprite = TRUE
	icon_state = "nt_librarian"
	item_state = "nt_librarian"

/obj/item/clothing/under/librarian/idris
	icon_state = "idris_librarian"
	item_state = "idris_librarian"

// Miner

/obj/item/clothing/under/rank/miner
	desc = "It's a snappy miner's jumpsuit, complete with overalls and caked-on dirt."
	name = "miner's jumpsuit"
	icon = 'icons/obj/contained_items/department_uniforms/operations.dmi'
	contained_sprite = TRUE
	icon_state = "nt_miner"
	item_state = "nt_miner"

/obj/item/clothing/under/rank/miner/heph
	icon_state = "heph_miner"
	item_state = "heph_miner"

/obj/item/clothing/under/rank/miner/orion
	icon_state = "orion_miner"
	item_state = "orion_miner"

/obj/item/clothing/under/rank/operations_manager
	name = "operations manager's jumpsuit"
	desc = "A uniform worn by the operations manager. It has the SCC insignia on it."
	icon = 'icons/obj/contained_items/department_uniforms/command.dmi'
	icon_state = "operations_manager"
	item_state = "operations_manager"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/hangar_technician
	name = "hangar technician's jumpsuit"
	desc = "The future of hangar tech apparel: long, stuffy slacks. We never said it was a bright future."
	icon = 'icons/obj/contained_items/department_uniforms/operations.dmi'
	icon_state = "nt_tech"
	item_state = "nt_tech"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/hangar_technician/heph
	icon_state = "heph_tech"
	item_state = "heph_tech"

/obj/item/clothing/under/rank/hangar_technician/orion
	icon_state = "orion_tech"
	item_state = "orion_tech"

/obj/item/clothing/under/rank/bridge_crew
	name = "bridge crew's jumpsuit"
	desc = "The uniform worn by the SCC's bridge crew."
	icon = 'icons/obj/contained_items/department_uniforms/command.dmi'
	icon_state = "bridge_crew"
	item_state = "bridge_crew"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/bridge_crew/alt
	name = "bridge crew's skirt"
	desc = "The uniform worn by the SCC's bridge crew, featuring a skirt."
	icon = 'icons/contained_items/clothing/bottomwear/bridge_crew_alt.dmi'
	icon_state = "bridge_crew_alt"
	item_state = "bridge_crew_alt"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/bridge_crew/alt/white
	icon_state = "bridge_crew_alt_white"
	item_state = "bridge_crew_alt_white"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/bridge_crew/sancolette
	name = "bridge crew's uniform"
	desc = "A bridge staff uniform in SCC colors but Colettish style, consisting of trousers and meant to be paired with a jacket. Fancy!"
	desc_extended = "This uniform is based upon an officer's uniform of the Civil Guard of San Colette. The blue-and-white \
	uniforms of the Civil Guard are one of the more striking uniforms found in the local military forces of the Alliance, and are often copied by both corporate and civil actors."
	icon = 'icons/contained_items/clothing/bottomwear/bridge_crew_sancol.dmi'
	icon_state = "bridge_crew_sancol"
	item_state = "bridge_crew_sancol"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/bridge_crew/sancolette/alt
	name = "bridge crew's uniform"
	desc = "A bridge staff uniform in SCC colors but Colettish style, consisting of navy trousers and meant to be paired with a jacket. Fancy!"
	desc_extended = "This uniform is based upon an officer's uniform of the Civil Guard of San Colette. The blue-and-white \
	uniforms of the Civil Guard are one of the more striking uniforms found in the local military forces of the Alliance, and are often copied by both corporate and civil actors."
	icon = 'icons/contained_items/clothing/bottomwear/bridge_crew_sancol.dmi'
	icon_state = "bridge_crew_sancol_alt"
	item_state = "bridge_crew_sancol_alt"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/xo
	name = "executive officer's jumpsuit"
	desc = "The uniform worn by the SCC's executive officers."
	icon = 'icons/obj/contained_items/department_uniforms/command.dmi'
	icon_state = "executive_officer"
	item_state = "executive_officer"
	contained_sprite = TRUE

/obj/item/clothing/under/rank/machinist
	name = "machinist's jumpsuit"
	desc = "A practical uniform designed for industrial work."
	icon = 'icons/obj/contained_items/department_uniforms/operations.dmi'
	contained_sprite = TRUE
	icon_state = "nt_machinist"
	item_state = "nt_machinist"

/obj/item/clothing/under/rank/machinist/heph
	icon_state = "heph_machinist"
	item_state = "heph_machinist"

/obj/item/clothing/under/rank/machinist/orion
	icon_state = "orion_machinist"
	item_state = "orion_machinist"

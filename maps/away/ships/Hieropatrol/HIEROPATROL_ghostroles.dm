/datum/ghostspawner/human/hieropatrol_crew
	short_name = "hieropatrol_crew"
	name = "Rotunnkc Compact Corvette Enforcer"
	desc = "A Bruzh of a Rotunnkc Compact Corvette, Protect the teritories of the Rotunnkc Compact and learn from your Senior."
	tags = list("External")

	spawnpoints = list("bruzh")
	max_count = 1

	outfit = /obj/outfit/admin/hierotheria/military/bruzh
	possible_species = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	uses_species_whitelist = FALSE
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Bruzh"
	special_role = "Bruzh"
	respawn_flag = null

/datum/ghostspawner/human/hieropatrol_crew/senior
	short_name = "senior"
	name = "Rotunnkc Compact Corvette Senior Explorer"
	desc = "A Senior Bruzh of a Rotunnkc Compact Corvette, take charge of your crew as what is most-likely the eldest member of the ship and use your bluespace tools wisely."
	tags = list("External")

	spawnpoints = list("senior")
	max_count = 1

	outfit = /obj/outfit/admin/hierotheria/military/bruzh/senior
	possible_species = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	uses_species_whitelist = TRUE
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Senior Bruzh"
	special_role = "Senior Bruzh"
	respawn_flag = null

/datum/ghostspawner/human/hieropatrol_crew/kal
	short_name = "kal"
	name = "Rotunnkc Compact Corvette Engineer"
	desc = "A Kal of a Rotunnkc Compact Corvette, maintain the vessel for your fellows and improve the systems how you see fit."
	tags = list("External")

	spawnpoints = list("kal")
	max_count = 1

	outfit = /obj/outfit/admin/hierotheria/military/kal
	possible_species = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	uses_species_whitelist = FALSE
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Kal"
	special_role = "Kal"
	respawn_flag = null

/datum/ghostspawner/human/hieropatrol_crew/jetan
	short_name = "jetan"
	name = "Rotunnkc Compact Corvette Medic"
	desc = "A Jetan of a Rotunnkc Compact Corvette, keep your fellow members of the vessel alive and well-grown and produce new nymphs and biomass for the vessel."
	tags = list("External")

	spawnpoints = list("jetan")
	max_count = 1

	outfit = /obj/outfit/admin/hierotheria/military/jetan
	possible_species = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	uses_species_whitelist = FALSE
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Jetan"
	special_role = "Jetan"
	respawn_flag = null

/obj/outfit/admin/hierotheria/military/kal
	name = "Kal"
	uniform = /obj/item/clothing/under/gearharness
	suit = /obj/item/clothing/accessory/poncho/hieroaetherian_poncho/kal
	back = /obj/item/storage/backpack/satchel
	id = /obj/item/card/id/hieropatrol
	l_ear = /obj/item/radio/headset/ship
	backpack_contents = list(/obj/item/flashlight/survival = 1, /obj/item/storage/belt/hydro/full = 1)
	belt = /obj/item/storage/belt/military

/obj/outfit/admin/hierotheria/military/bruzh
	name = "Bruzh"
	uniform = /obj/item/clothing/under/gearharness
	suit = /obj/item/clothing/accessory/poncho/hieroaetherian_poncho/bruzh
	back = /obj/item/storage/backpack/satchel
	id = /obj/item/card/id/hieropatrol
	l_ear = /obj/item/radio/headset/ship
	backpack_contents = list(/obj/item/flashlight/survival = 1)
	belt = /obj/item/storage/belt/military

/obj/outfit/admin/hierotheria/military/jetan
	name = "Jetan"
	uniform = /obj/item/clothing/under/gearharness
	suit = /obj/item/clothing/accessory/poncho/hieroaetherian_poncho/jetan
	back = /obj/item/storage/backpack/satchel
	id = /obj/item/card/id/hieropatrol
	l_ear = /obj/item/radio/headset/ship
	backpack_contents = list(/obj/item/flashlight/survival = 1, /obj/item/storage/belt/hydro/full = 1, /obj/item/storage/belt/medical/paramedic/combat = 1)
	belt = /obj/item/storage/belt/military

/obj/outfit/admin/hierotheria/military/bruzh/senior
	name = "Senior Bruzh"
	uniform = /obj/item/clothing/under/gearharness
	suit = /obj/item/clothing/accessory/poncho/hieroaetherian_poncho/bruzh/senior
	back = /obj/item/storage/backpack/satchel
	id = /obj/item/card/id/hieropatrol
	l_ear = /obj/item/radio/headset/ship
	backpack_contents = list(/obj/item/flashlight/survival = 1)
	belt = /obj/item/storage/belt/military

//items
/obj/item/card/id/hieropatrol
	name = "rotunnkc compact corvette id"
	access = list(ACCESS_HIEROTHERIA_MILITARY, ACCESS_EXTERNAL_AIRLOCKS)

/obj/item/clothing/accessory/poncho/hieroaetherian_poncho/bruzh
	accent_color = "#e03b19"
	color = "#4e754d"

/obj/item/clothing/accessory/poncho/hieroaetherian_poncho/bruzh/senior
	accent_color = "#5112a4"
	color = "#77af75"

/obj/item/clothing/accessory/poncho/hieroaetherian_poncho/jetan
	accent_color = "#19e073"
	color = "#4e754d"

/obj/item/clothing/accessory/poncho/hieroaetherian_poncho/kal
	accent_color = "#e0c219"
	color = "#4e754d"

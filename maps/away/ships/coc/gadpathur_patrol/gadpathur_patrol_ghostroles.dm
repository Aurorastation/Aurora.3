/datum/ghostspawner/human/gadpathur_patrol
	short_name = "gadpathur_patroller"
	name = "Gadpathurian Patrol Corvette Security Cadre Member"
	desc = "Crew a Gadpathurian patrol vessel, and ensure the Coalition never again falls to its enemies."
	tags = list("External")
	spawnpoints = list("gadpathur_patroller")
	welcome_message = "You are a member of the cadre of the United Planetary Defense Council of Gadpathur. You have been assigned to a section leader, and have been ordered to patrol this sector. Ensure that pirates, Dominians, and especially Solarians do not threaten this area. Characters must have names and physical characteristics typical of people from the modern-day Indian Subcontinent."

	max_count = 4
	respawn_flag = null
	outfit = /datum/outfit/admin/gadpathur_patrol

	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Patrol Crew"
	faction = "United Planetary Defense Council of Gadpathur"
	respawn_flag = null

	culture_restriction = list(/singleton/origin_item/culture/coalition)
	origin_restriction = list(/singleton/origin_item/origin/gadpathur)

/datum/outfit/admin/gadpathur_patrol
	name = "Gadpathurian Security Cadre Member"

	head = list(/obj/item/clothing/head/beret/gadpathur, /obj/item/clothing/head/gadpathur)
	uniform = /obj/item/clothing/under/uniform/gadpathur
	suit = /obj/item/clothing/suit/storage/gadpathur
	suit_accessory = /obj/item/clothing/accessory/armband/gadpathur
	shoes = /obj/item/clothing/shoes/combat
	back = /obj/item/storage/backpack/rucksack/tan

	id = /obj/item/card/id

	l_ear = /obj/item/device/radio/headset/ship/coalition_navy

	backpack_contents = list(/obj/item/storage/box/survival = 1)


/datum/outfit/admin/gadpathur_patrol/get_id_access()
	return list(access_external_airlocks, access_generic_away_site, access_coalition, access_coalition_navy, access_gadpathur_navy)

/datum/ghostspawner/human/gadpathur_patrol/medical
	short_name = "gadpathur_patroller_surgeon"
	name = "Gadpathurian Patrol Corvette Medical Cadre Member"
	desc = "Practice medicine on the crew of a Gadpathurian patrol vessel, and ensure your comrades are healthy enough to ensure the Coalition never again falls to its enemies."
	spawnpoints = list("gadpathur_surgeon")
	welcome_message = "You are a detached member of the medical cadre of the United Planetary Defense Council of Gadpathur. You have been assigned as the surgeon of this crew. Your experience confers you with a higher rank than most of the crew, but you are not a section leader; you are a healer first, a soldier second. Characters must have names and physical characteristics typical of people from the modern-day Indian Subcontinent."

	max_count = 1

	outfit = /datum/outfit/admin/gadpathur_patrol/medic

	assigned_role = "Patrol Surgeon"

/datum/outfit/admin/gadpathur_patrol/medic
	name = "Gadpathurian Medical Cadre Member"

	head = /obj/item/clothing/head/beret/gadpathur/medical
	suit_accessory = /obj/item/clothing/accessory/armband/gadpathur/med
	back = /obj/item/storage/backpack/satchel/med

	backpack_contents = list(/obj/item/storage/box/survival/engineer = 1)

/datum/outfit/admin/gadpathur_patrol/medic/get_id_access()
	return list(access_external_airlocks, access_generic_away_site, access_coalition, access_coalition_navy, access_gadpathur_navy, access_gadpathur_navy_officer)

/datum/ghostspawner/human/gadpathur_patrol/section_leader
	short_name = "gadpathur_patroller_section_leader"
	name = "Gadpathurian Patrol Corvette Section Leader"
	desc = "Command the crew of a Gadpathurian patrol vessel, and ensure the Coalition never again falls to its enemies."
	spawnpoints = list("gadpathur_leader")
	welcome_message = "You are a section leader of the United Planetary Defense Council of Gadpathur. You have been assigned to command this crew and patrol this sector for enemies and threats to the Coalition. Decisively deal with pirates and renegades, but use caution with others; Gadpathur is not interested in starting a new Interstellar War... today, and you do not command a full warship. Characters must have names and physical characteristics typical of people from the modern-day Indian Subcontinent."

	max_count = 1

	outfit = /datum/outfit/admin/gadpathur_patrol/section_leader

	assigned_role = "Section Leader"

/datum/outfit/admin/gadpathur_patrol/section_leader
	name = "Gadpathurian Section Leader"

	accessory = /obj/item/clothing/accessory/gadpathurian_leader

/datum/outfit/admin/gadpathur_patrol/section_leader/get_id_access()
	return list(access_external_airlocks, access_generic_away_site, access_coalition, access_coalition_navy, access_gadpathur_navy, access_gadpathur_navy_officer)

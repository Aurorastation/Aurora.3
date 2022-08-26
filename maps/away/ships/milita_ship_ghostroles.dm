/datum/ghostspawner/human/militia_crew
	short_name = "militia_crew"
	name = "Militiaman"
	desc = "Crew the militia ship. Help those that need it, try to keep your slice of space clean and safe of anyone the TCFL and SCC miss - there are people counting on you. Double as a hired gun, to make a few bucks."
	tags = list("External")

	spawnpoints = list("militiaman")
	max_count = 3

	outfit = /datum/outfit/admin/militia_crew
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Militiaman"
	special_role = "Militiaman"
	respawn_flag = null


/datum/outfit/admin/militia_crew
	name = "Militiaman"

	uniform = /obj/item/clothing/under/tactical
	shoes = /obj/item/clothing/shoes/workboots/dark
	back = /obj/item/storage/backpack/satchel/norm

	id = /obj/item/card/id/militia_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1)

/datum/outfit/admin/militia_crew/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(isoffworlder(H))
		H.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)
/datum/outfit/admin/militia_crew/get_id_access()
	return list(access_external_airlocks)

/datum/ghostspawner/human/militia_crew/captain
	short_name = "militia_crew_captain"
	name = "Militia Captain"
	desc = "Captain the militia ship. Help those that need it, try to keep your slice of space clean and safe of anyone the TCFL and SCC miss - there are people counting on you. Double as a hired gun, to make a few bucks."

	spawnpoints = list("militia_crew_captain")
	max_count = 1

	outfit = /datum/outfit/admin/militia_crew/captain
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Militia Captain"
	special_role = "Militia Captain"


/datum/outfit/admin/militia_crew/captain
	name = "Militia Captain"

	accessory = /obj/item/clothing/accessory/sash/red

/obj/item/card/id/militia_ship
	name = "militia ship id"
	access = list(access_external_airlocks)

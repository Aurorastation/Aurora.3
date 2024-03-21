/datum/map_template/ruin/exoplanet/konyang_zombies
	name = "Crashed Hephaestus Shuttle"
	id = "konyang_zombies"
	description = "A wrecked Hephaestus shuttle in the Konyang jungle, carrying several infected IPCs."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("konyang/zombies.dmm")

/obj/effect/landmark/corpse/heph_pilot
	name = "Hephaestus Pilot"
	corpseuniform = /obj/item/clothing/under/rank/hangar_technician/heph
	corpsesuit = /obj/item/clothing/suit/storage/hazardvest/green
	corpseshoes = /obj/item/clothing/shoes/workboots
	corpsehelmet = /obj/item/clothing/head/helmet/pilot
	corpseid = TRUE
	corpseidjob = "Shuttle Pilot"
	corpseidicon = "heph_card"
	species = SPECIES_HUMAN

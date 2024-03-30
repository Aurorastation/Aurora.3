/datum/map_template/ruin/exoplanet/rural_clinic
	name = "Abandoned Rural Clinic"
	id = "rural_clinic"
	description = "A rural clinic servicing the local villages, this one is abandoned."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("konyang/abandoned/rural_clinic.dmm")

/area/konyang/rural_clinic
	name = "Konyang Rural Clinic"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_RAD_SHIELDED
	base_turf = /turf/simulated/floor/exoplanet/dirt_konyang
	sound_environment = SOUND_ENVIRONMENT_ROOM

/obj/effect/landmark/corpse/konyang_cop
	name = "Konyang National Police Patrolman"
	corpseuniform = /obj/item/clothing/under/rank/konyang/police
	corpseshoes = /obj/item/clothing/shoes/jackboots
	corpsehelmet = /obj/item/clothing/head/konyang/police
	corpsebelt = /obj/item/storage/belt/security
	corpsepocket2 = /obj/item/device/radio
	corpsepocket1 = /obj/item/storage/wallet/random
	corpseback = /obj/item/storage/backpack/satchel
	corpseid = FALSE
	species = SPECIES_HUMAN

/obj/effect/landmark/corpse/konyang_clinic_worker
	name = "Konyang Clinic Worker"
	corpseuniform = /obj/item/clothing/under/color/white
	corpseshoes = /obj/item/clothing/shoes/sneakers/medsci
	corpseback = /obj/item/storage/backpack/satchel/med
	corpsepocket2 = /obj/item/storage/wallet/random
	corpseid = FALSE
	species = SPECIES_HUMAN

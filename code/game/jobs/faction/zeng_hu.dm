/datum/faction/zeng_hu
	name = "Zeng-Hu Pharmaceuticals"
	description = "Zeng-Hu Pharmaceuticals, born of a merger of two major biotech companies on Earth in 2032, was the first to successfully develop cryogenics in the 21st century for the purposes of space travel. This development, crucial to interstellar colonization, helped propel them to their current position as the largest pharmaceutical and medical corporation in the Orion Spur. In more recent years, they were also the first mega-corporation to partner with the newly-discovered Skrell, working closely with this alien species to pioneer cloning, a once controversial field that is now more accepted today."
	title_suffix = "Zeng"

	allowed_role_types = list(
		/datum/job/doctor = TRUE,
		/datum/job/pharmacist = TRUE,
		/datum/job/psychiatrist = TRUE,
		/datum/job/paramedic = TRUE,
		/datum/job/representative = TRUE
	)

	allowed_species_types = list(
		/datum/species/human,
		/datum/species/skrell,
		/datum/species/machine,
		/datum/species/bug
	)

	titles_to_loadout = list(
		"Medical Doctor" = /datum/outfit/job/doctor/zeng_hu,
		"Pharmacist" = /datum/outfit/job/pharmacist/zeng_hu,
		"Psychiatrist" = /datum/outfit/job/psychiatrist/zeng_hu,
		"Paramedic" = /datum/outfit/job/paramedic/zeng_hu,
		"Corporate Liaison" = /datum/outfit/job/representative/zeng_hu
	)

/datum/outfit/job/doctor/zeng_hu
	name = "Medical Doctor - Zeng-Hu"
	uniform = /obj/item/clothing/under/rank/zeng

/datum/outfit/job/pharmacist/zeng_hu
	name = "Pharmacist - Zeng-Hu"
	uniform = /obj/item/clothing/under/rank/zeng

/datum/outfit/job/psychiatrist/zeng_hu
	name = "Psychiatrist - Zeng-Hu"
	uniform = /obj/item/clothing/under/rank/zeng

/datum/outfit/job/psychiatrist/zeng_hu
	name = "Psychiatrist - Zeng-Hu"
	uniform = /obj/item/clothing/under/rank/zeng

/datum/outfit/job/paramedic/zeng_hu
	name = "Paramedic - Zeng-Hu"
	uniform = /obj/item/clothing/under/rank/zeng

/datum/outfit/job/representative/zeng_hu
	name = "Corporate Liaison - Zeng-Hu"
	uniform = /obj/item/clothing/under/rank/zeng
	head = null
	suit = null
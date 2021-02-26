/datum/faction/jargon_fed
	name = "Jargon Federation Employee Leasing"
	description = {"<p>
    The Jargon Federation is the primary Skrellian authority in the Orion Spur. A stable, secretive galactic giant with a strong planned economy, \
    it is most famous for its scientific advancements, made possible with the Federation's impeccable education programs. \
    The megacorporations of the galaxy, especially Zeng-Hu Pharmaceuticals, always have a very high demand for Skrellian medics and researchers, \
    who are considered to always be masters of their craft. The Jargon Federation usually answers these demands by leasing out some of its professionals, \
    as it is also interested in the internal dealings of other factions in the galaxy...
	</p>"}
	title_suffix = "Jargon"

	allowed_role_types = list(
		/datum/job/doctor,
		/datum/job/surgeon,
		/datum/job/pharmacist,
		/datum/job/psychiatrist,
        /datum/job/scientist,
		/datum/job/roboticist,
		/datum/job/xenobiologist,
	)

	allowed_species_types = list(
		/datum/species/skrell
	)

	titles_to_loadout = list(
		"Physician" = /datum/outfit/job/doctor/jargon,
		"Surgeon" = /datum/outfit/job/doctor/surgeon/jargon,
		"Pharmacist" = /datum/outfit/job/pharmacist/jargon,
		"Psychiatrist" = /datum/outfit/job/psychiatrist/jargon,
		"Psychologist" = /datum/outfit/job/psychiatrist/jargon,
		"Scientist" = /datum/outfit/job/scientist/jargon,
		"Xenoarcheologist" = /datum/outfit/job/scientist/xenoarcheologist/jargon,
		"Anomalist" = /datum/outfit/job/scientist/jargon,
		"Xenoarcheologist" = /datum/outfit/job/scientist/jargon,
		"Phoron Researcher" = /datum/outfit/job/scientist/jargon,
		"Roboticist" = /datum/outfit/job/roboticist/jargon,
		"Xenobiologist" = /datum/outfit/job/scientist/xenobiologist/jargon,
		"Xenobotanist" = /datum/outfit/job/scientist/xenobiologist/xenobotanist/jargon,
	)

/datum/outfit/job/doctor/jargon
	name = "Physician - Jargon Federation"
	suit_accessory = /obj/item/clothing/accessory/poncho/shoulder_cape/fed
	id = /obj/item/card/id/jargon

/datum/outfit/job/doctor/surgeon/jargon
	name = "Surgeon - Jargon Federation"
	suit_accessory = /obj/item/clothing/accessory/poncho/shoulder_cape/fed
	id = /obj/item/card/id/jargon

/datum/outfit/job/psychiatrist/jargon
	name = "Psychiatrist/Psychologist - Jargon Federation"
	suit_accessory = /obj/item/clothing/accessory/poncho/shoulder_cape/fed
	id = /obj/item/card/id/jargon

/datum/outfit/job/pharmacist/jargon
	name = "Pharmacist - Jargon Federation"
	suit_accessory = /obj/item/clothing/accessory/poncho/shoulder_cape/fed
	id = /obj/item/card/id/jargon

/datum/outfit/job/scientist/jargon
	name = "Scientist - Jargon Federation"
	suit_accessory = /obj/item/clothing/accessory/poncho/shoulder_cape/fed
	id = /obj/item/card/id/jargon

/datum/outfit/job/scientist/xenoarcheologist/jargon
	name = "Xenoarcheologist - Jargon Federation"
	suit_accessory = /obj/item/clothing/accessory/poncho/shoulder_cape/fed
	id = /obj/item/card/id/jargon

/datum/outfit/job/roboticist/jargon
	name = "Roboticist - Jargon Federation"
	suit_accessory = /obj/item/clothing/accessory/poncho/shoulder_cape/fed
	id = /obj/item/card/id/jargon

/datum/outfit/job/scientist/xenobiologist/jargon
	name = "Xenobiologist - Jargon Federation"
	suit_accessory = /obj/item/clothing/accessory/poncho/shoulder_cape/fed
	id = /obj/item/card/id/jargon

/datum/outfit/job/scientist/xenobiologist/xenobotanist/jargon
	name = "Xenobotanist - Jargon Federation"
	suit_accessory = /obj/item/clothing/accessory/poncho/shoulder_cape/fed
	id = /obj/item/card/id/jargon
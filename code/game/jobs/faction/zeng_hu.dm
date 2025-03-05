/datum/faction/zeng_hu
	name = "Zeng-Hu Pharmaceuticals"
	description = {"<p>
	Zeng-Hu Pharmaceuticals, born of a merger of two major biotech companies on
	Earth in 2032, was the first to successfully develop cryogenics in the 21st
	century for the purposes of space travel. This development, crucial to
	interstellar colonization, helped propel them to their current position as the
	largest pharmaceutical and medical corporation in the Orion Spur. In more recent
	years, they were also the first mega-corporation to partner with the newly-discovered
	Skrell, working closely with this alien species to pioneer cloning, a once
	controversial field that is now more accepted today.
	</p>"}

	departments = {"Medical<br>Research"}
	title_suffix = "Zeng"

	allowed_role_types = ZENG_ROLES

	allowed_species_types = list(
		/datum/species/human,
		/datum/species/skrell,
		/datum/species/machine,
		/datum/species/bug = TRUE,
		/datum/species/bug/type_b = TRUE,
		/datum/species/bug/type_b/type_bb = TRUE,
		/datum/species/bug/type_e = TRUE,
		/datum/species/diona
	)

	job_species_blacklist = list(
		"Corporate Liaison" = list(
			SPECIES_UNATHI,
			SPECIES_TAJARA,
			SPECIES_TAJARA_MSAI,
			SPECIES_TAJARA_ZHAN,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_ATTENDANT,
			SPECIES_VAURCA_BULWARK,
			SPECIES_VAURCA_BREEDER
		)
	)

	titles_to_loadout = list(
		"Physician" = /obj/outfit/job/doctor/zeng_hu,
		"Surgeon" = /obj/outfit/job/doctor/surgeon/zeng_hu,
		"Pharmacist" = /obj/outfit/job/pharmacist/zeng_hu,
		"Psychiatrist" = /obj/outfit/job/psychiatrist/zeng_hu,
		"Psychologist" = /obj/outfit/job/psychiatrist/zeng_hu,
		"Paramedic" = /obj/outfit/job/med_tech/zeng_hu,
		"Medical Intern" = /obj/outfit/job/intern_med/zeng_hu,
		"Scientist" = /obj/outfit/job/scientist/zeng_hu,
		"Xenobiologist" = /obj/outfit/job/scientist/xenobiologist/zeng_hu,
		"Anomalist" = /obj/outfit/job/scientist/anomalist/zeng_hu,
		"Xenobotanist" = /obj/outfit/job/scientist/xenobotanist/zeng_hu,
		"Research Intern" = /obj/outfit/job/intern_sci/zeng_hu,
		"Xenoarchaeologist"= /obj/outfit/job/scientist/xenoarchaeologist/zeng_hu,
		"Corporate Reporter" = /obj/outfit/job/journalist/zeng_hu,
		"Corporate Liaison" = /obj/outfit/job/representative/zeng_hu,
		"Assistant" = /obj/outfit/job/assistant/zeng_hu,
		"Medical Orderly" = /obj/outfit/job/assistant/med_assistant/zeng_hu,
		"Lab Assistant" = /obj/outfit/job/assistant/lab_assistant/zeng_hu,
		"Off-Duty Crew Member" = /obj/outfit/job/visitor/zeng_hu,
		"Science Personnel" = /obj/outfit/job/scientist/event/zeng_hu,
		"Medical Personnel" = /obj/outfit/job/med_tech/event/zeng_hu
	)

/obj/outfit/job/doctor/zeng_hu
	name = "Physician - Zeng-Hu"

	uniform = /obj/item/clothing/under/rank/medical/zeng
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/zeng
	id = /obj/item/card/id/zeng_hu
	shoes = /obj/item/clothing/shoes/sneakers/medsci/zeng

	backpack_faction = /obj/item/storage/backpack/zeng
	satchel_faction = /obj/item/storage/backpack/satchel/zeng
	dufflebag_faction = /obj/item/storage/backpack/duffel/zeng
	messengerbag_faction = /obj/item/storage/backpack/messenger/zeng

/obj/outfit/job/doctor/surgeon/zeng_hu
	name = "Surgeon - Zeng-Hu"

	uniform = /obj/item/clothing/under/rank/medical/surgeon/zeng
	suit = /obj/item/clothing/suit/storage/surgical_gown/zeng
	id = /obj/item/card/id/zeng_hu
	shoes = /obj/item/clothing/shoes/sneakers/medsci/zeng

	backpack_faction = /obj/item/storage/backpack/zeng
	satchel_faction = /obj/item/storage/backpack/satchel/zeng
	dufflebag_faction = /obj/item/storage/backpack/duffel/zeng
	messengerbag_faction = /obj/item/storage/backpack/messenger/zeng

/obj/outfit/job/doctor/surgeon/zeng_hu/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!isskrell(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/zeng(H), slot_head)

/obj/outfit/job/pharmacist/zeng_hu
	name = "Pharmacist - Zeng-Hu"

	uniform = /obj/item/clothing/under/rank/medical/pharmacist/zeng
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/zeng
	id = /obj/item/card/id/zeng_hu
	shoes = /obj/item/clothing/shoes/sneakers/medsci/zeng

	backpack_faction = /obj/item/storage/backpack/zeng
	satchel_faction = /obj/item/storage/backpack/satchel/zeng
	dufflebag_faction = /obj/item/storage/backpack/duffel/zeng
	messengerbag_faction = /obj/item/storage/backpack/messenger/zeng

/obj/outfit/job/psychiatrist/zeng_hu
	name = "Psychiatrist - Zeng-Hu"

	uniform = /obj/item/clothing/under/rank/medical/psych/zeng
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/zeng
	id = /obj/item/card/id/zeng_hu
	shoes = /obj/item/clothing/shoes/sneakers/medsci/zeng

	backpack_faction = /obj/item/storage/backpack/zeng
	satchel_faction = /obj/item/storage/backpack/satchel/zeng
	dufflebag_faction = /obj/item/storage/backpack/duffel/zeng
	messengerbag_faction = /obj/item/storage/backpack/messenger/zeng

/obj/outfit/job/med_tech/zeng_hu
	name = "Paramedic - Zeng-Hu"

	head = /obj/item/clothing/head/softcap/zeng
	uniform = /obj/item/clothing/under/rank/medical/paramedic/zeng
	suit = /obj/item/clothing/suit/storage/toggle/para_jacket/zeng
	id = /obj/item/card/id/zeng_hu

	backpack_faction = /obj/item/storage/backpack/zeng
	satchel_faction = /obj/item/storage/backpack/satchel/zeng
	dufflebag_faction = /obj/item/storage/backpack/duffel/zeng
	messengerbag_faction = /obj/item/storage/backpack/messenger/zeng

/obj/outfit/job/intern_med/zeng_hu
	name = "Medical Intern - Zeng-Hu"

	uniform = /obj/item/clothing/under/rank/medical/intern/zeng
	id = /obj/item/card/id/zeng_hu
	shoes = /obj/item/clothing/shoes/sneakers/medsci/zeng

	backpack_faction = /obj/item/storage/backpack/zeng
	satchel_faction = /obj/item/storage/backpack/satchel/zeng
	dufflebag_faction = /obj/item/storage/backpack/duffel/zeng
	messengerbag_faction = /obj/item/storage/backpack/messenger/zeng

/obj/outfit/job/scientist/zeng_hu
	name = "Scientist - Zeng-Hu"

	uniform = /obj/item/clothing/under/rank/scientist/zeng
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/zeng/alt
	id = /obj/item/card/id/zeng_hu
	shoes = /obj/item/clothing/shoes/sneakers/medsci/zeng

	backpack_faction = /obj/item/storage/backpack/zeng
	satchel_faction = /obj/item/storage/backpack/satchel/zeng
	dufflebag_faction = /obj/item/storage/backpack/duffel/zeng
	messengerbag_faction = /obj/item/storage/backpack/messenger/zeng

/obj/outfit/job/scientist/xenobiologist/zeng_hu
	name = "Xenobiologist - Zeng-Hu"

	uniform = /obj/item/clothing/under/rank/scientist/xenobio/zeng
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/zeng/alt
	id = /obj/item/card/id/zeng_hu
	shoes = /obj/item/clothing/shoes/sneakers/medsci/zeng

	backpack_faction = /obj/item/storage/backpack/zeng
	satchel_faction = /obj/item/storage/backpack/satchel/zeng
	dufflebag_faction = /obj/item/storage/backpack/duffel/zeng
	messengerbag_faction = /obj/item/storage/backpack/messenger/zeng

/obj/outfit/job/scientist/xenobotanist/zeng_hu
	name = "Xenobotanist - Zeng-Hu"

	uniform = /obj/item/clothing/under/rank/scientist/botany/zeng
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/zeng
	id = /obj/item/card/id/zeng_hu
	shoes = /obj/item/clothing/shoes/sneakers/medsci/zeng

	backpack_faction = /obj/item/storage/backpack/zeng
	satchel_faction = /obj/item/storage/backpack/satchel/zeng
	dufflebag_faction = /obj/item/storage/backpack/duffel/zeng
	messengerbag_faction = /obj/item/storage/backpack/messenger/zeng

/obj/outfit/job/scientist/xenoarchaeologist/zeng_hu
	name = "Xenoarchaeologist - Zeng-Hu"

	uniform = /obj/item/clothing/under/rank/scientist/xenoarchaeologist/zeng
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/zeng/alt
	id = /obj/item/card/id/zeng_hu
	shoes = /obj/item/clothing/shoes/sneakers/medsci/zeng

	backpack_faction = /obj/item/storage/backpack/zeng
	satchel_faction = /obj/item/storage/backpack/satchel/zeng
	dufflebag_faction = /obj/item/storage/backpack/duffel/zeng
	messengerbag_faction = /obj/item/storage/backpack/messenger/zeng

/obj/outfit/job/scientist/anomalist/zeng_hu
	name = "Xenoarchaeologist - Zeng-Hu"

	uniform = /obj/item/clothing/under/rank/scientist/anomalist/zeng
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/zeng/alt
	id = /obj/item/card/id/zeng_hu
	shoes = /obj/item/clothing/shoes/sneakers/medsci/zeng

	backpack_faction = /obj/item/storage/backpack/zeng
	satchel_faction = /obj/item/storage/backpack/satchel/zeng
	dufflebag_faction = /obj/item/storage/backpack/duffel/zeng
	messengerbag_faction = /obj/item/storage/backpack/messenger/zeng

/obj/outfit/job/intern_sci/zeng_hu
	name = "Research Intern - Zeng-Hu"

	uniform = /obj/item/clothing/under/rank/scientist/intern/zeng
	id = /obj/item/card/id/zeng_hu
	shoes = /obj/item/clothing/shoes/sneakers/medsci/zeng

	backpack_faction = /obj/item/storage/backpack/zeng
	satchel_faction = /obj/item/storage/backpack/satchel/zeng
	dufflebag_faction = /obj/item/storage/backpack/duffel/zeng
	messengerbag_faction = /obj/item/storage/backpack/messenger/zeng

/obj/outfit/job/representative/zeng_hu
	name = "Zeng-Hu Corporate Liaison"

	head = /obj/item/clothing/head/beret/corporate/zeng
	uniform = /obj/item/clothing/under/rank/liaison/zeng
	suit = /obj/item/clothing/suit/storage/liaison/zeng
	id = /obj/item/card/id/zeng_hu
	accessory = /obj/item/clothing/accessory/tie/corporate/zeng
	suit_accessory = /obj/item/clothing/accessory/pin/corporate/zeng

	backpack_faction = /obj/item/storage/backpack/zeng
	satchel_faction = /obj/item/storage/backpack/satchel/zeng
	dufflebag_faction = /obj/item/storage/backpack/duffel/zeng
	messengerbag_faction = /obj/item/storage/backpack/messenger/zeng

	backpack_contents = list(
		/obj/item/device/camera = 1,
		/obj/item/gun/energy/pistol = 1,
		/obj/item/stamp/zeng_hu = 1
	)
/obj/outfit/job/journalist/zeng_hu
	name = "Corporate Reporter - Zeng-Hu"

	uniform = /obj/item/clothing/under/librarian/zeng
	id = /obj/item/card/id/zeng_hu

	backpack_faction = /obj/item/storage/backpack/zeng
	satchel_faction = /obj/item/storage/backpack/satchel/zeng
	dufflebag_faction = /obj/item/storage/backpack/duffel/zeng
	messengerbag_faction = /obj/item/storage/backpack/messenger/zeng

/obj/outfit/job/assistant/zeng_hu
	name = "Assistant - Zeng-Hu"

	id = /obj/item/card/id/zeng_hu

	backpack_faction = /obj/item/storage/backpack/zeng
	satchel_faction = /obj/item/storage/backpack/satchel/zeng
	dufflebag_faction = /obj/item/storage/backpack/duffel/zeng
	messengerbag_faction = /obj/item/storage/backpack/messenger/zeng

/obj/outfit/job/assistant/med_assistant/zeng_hu
	name = "Medical Orderly - Zeng-Hu"

	id = /obj/item/card/id/zeng_hu

	backpack_faction = /obj/item/storage/backpack/zeng
	satchel_faction = /obj/item/storage/backpack/satchel/zeng
	dufflebag_faction = /obj/item/storage/backpack/duffel/zeng
	messengerbag_faction = /obj/item/storage/backpack/messenger/zeng

/obj/outfit/job/assistant/lab_assistant/zeng_hu
	name = "Lab Assistant - Zeng-Hu"

	id = /obj/item/card/id/zeng_hu

	backpack_faction = /obj/item/storage/backpack/zeng
	satchel_faction = /obj/item/storage/backpack/satchel/zeng
	dufflebag_faction = /obj/item/storage/backpack/duffel/zeng
	messengerbag_faction = /obj/item/storage/backpack/messenger/zeng

/obj/outfit/job/visitor/zeng_hu
	name = "Off-Duty Crew Member - Zeng-Hu"

	id = /obj/item/card/id/zeng_hu

	backpack_faction = /obj/item/storage/backpack/zeng
	satchel_faction = /obj/item/storage/backpack/satchel/zeng
	dufflebag_faction = /obj/item/storage/backpack/duffel/zeng
	messengerbag_faction = /obj/item/storage/backpack/messenger/zeng

/obj/outfit/job/med_tech/event/zeng_hu
	name = "Medical Personnel - Zeng-Hu"

	head = /obj/item/clothing/head/softcap/zeng
	uniform = /obj/item/clothing/under/rank/medical/paramedic/zeng
	suit = /obj/item/clothing/suit/storage/toggle/para_jacket/zeng
	id = /obj/item/card/id/zeng_hu

	backpack_faction = /obj/item/storage/backpack/zeng
	satchel_faction = /obj/item/storage/backpack/satchel/zeng
	dufflebag_faction = /obj/item/storage/backpack/duffel/zeng
	messengerbag_faction = /obj/item/storage/backpack/messenger/zeng

/obj/outfit/job/scientist/event/zeng_hu
	name = "Research Personnel - Zeng-Hu"

	uniform = /obj/item/clothing/under/rank/scientist/zeng
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/zeng/alt
	id = /obj/item/card/id/zeng_hu
	shoes = /obj/item/clothing/shoes/sneakers/medsci/zeng

	backpack_faction = /obj/item/storage/backpack/zeng
	satchel_faction = /obj/item/storage/backpack/satchel/zeng
	dufflebag_faction = /obj/item/storage/backpack/duffel/zeng
	messengerbag_faction = /obj/item/storage/backpack/messenger/zeng

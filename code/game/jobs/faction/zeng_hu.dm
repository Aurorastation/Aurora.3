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
	</p>
	<p>Some character examples are:
	<ul>
	<li><b>Senior Surgeon</b>: Zeng-Hu has some of the best medical staff in the world and you are one of them.
	Highly-trained and highly-experienced you are better then the rest, aside from your colleagues in Zeng-Hu.
	You expect to be heard and obeyed, as your coworkers really should be taking advice from you in the absence of
	a chief medical officer. Your bedside manner is impeccable and far outclasses standard NanoTrasen training and
	procedure. You are the product of the most rigorous employee hiring and training process for medical staff in the
	Orion Spur, and are expected to act like it. Failure is you will not tolerate.</li>
	<li><b>Biomechanical Engineer</b>: Our ability to combine medical research with robotics
	is the best and you know this. We do, after all, own Bishop Cybernetics - the
	best premium augmentation subsidiary in the known galaxy. Unlike your medical cousins
	you are much more likely to generate a friendly working atmosphere with non Zeng-Hu colleagues,
	due to gaps in your training surrounding the exosuits Hephaestus' "well-trained roboticists"
	love to build. Remember to be professional, effective, driven, and dedicated in your work.
	Zeng-Hu expects the best from you, Doctor. Do not fail us or our shareholders in Eridani, or
	you will find your career failing in short order.</li>
	</ul></p>"}
	title_suffix = "Zeng"

	allowed_role_types = list(
		/datum/job/visitor,
		/datum/job/doctor,
		/datum/job/surgeon,
		/datum/job/pharmacist,
		/datum/job/psychiatrist,
		/datum/job/med_tech,
		/datum/job/roboticist,
		/datum/job/xenobiologist,
		/datum/job/representative
	)

	allowed_species_types = list(
		/datum/species/human,
		/datum/species/skrell,
		/datum/species/machine,
		/datum/species/bug,
		/datum/species/diona
	)

	titles_to_loadout = list(
		"Physician" = /datum/outfit/job/doctor/zeng_hu,
		"Surgeon" = /datum/outfit/job/doctor/zeng_hu,
		"Trauma Physician" = /datum/outfit/job/doctor/zeng_hu,
		"Nurse" = /datum/outfit/job/doctor/zeng_hu,
		"Pharmacist" = /datum/outfit/job/pharmacist/zeng_hu,
		"Chemist" = /datum/outfit/job/pharmacist/zeng_hu,
		"Psychiatrist" = /datum/outfit/job/psychiatrist/zeng_hu,
		"Psychologist" = /datum/outfit/job/psychiatrist/zeng_hu,
		"Paramedic" = /datum/outfit/job/med_tech/paramed/zeng_hu,
		"Emergency Medical Technician" = /datum/outfit/job/med_tech/paramed/zeng_hu,
		"Roboticist" = /datum/outfit/job/roboticist/zeng_hu,
		"Biomechanical Engineer" = /datum/outfit/job/roboticist/zeng_hu,
		"Mechatronic Engineer" = /datum/outfit/job/roboticist/zeng_hu,
		"Xenobiologist" = /datum/outfit/job/scientist/xenobiologist/zeng_hu,
		"Xenobotanist" = /datum/outfit/job/scientist/xenobiologist/zeng_hu,
		"Corporate Liaison" = /datum/outfit/job/representative/zeng_hu
	)

/datum/outfit/job/doctor/zeng_hu
	name = "Physician - Zeng-Hu"
	uniform = /obj/item/clothing/under/rank/zeng
	id = /obj/item/card/id/zeng_hu

/datum/outfit/job/roboticist/zeng_hu
	name = "Roboticist - Zeng-Hu"
	uniform = /obj/item/clothing/under/rank/zeng
	id = /obj/item/card/id/zeng_hu

/datum/outfit/job/pharmacist/zeng_hu
	name = "Pharmacist - Zeng-Hu"
	uniform = /obj/item/clothing/under/rank/zeng
	id = /obj/item/card/id/zeng_hu

/datum/outfit/job/psychiatrist/zeng_hu
	name = "Psychiatrist - Zeng-Hu"
	uniform = /obj/item/clothing/under/rank/zeng
	id = /obj/item/card/id/zeng_hu

/datum/outfit/job/psychiatrist/zeng_hu
	name = "Psychiatrist - Zeng-Hu"
	uniform = /obj/item/clothing/under/rank/zeng
	id = /obj/item/card/id/zeng_hu

/datum/outfit/job/med_tech/paramed/zeng_hu
	name = "Paramedic - Zeng-Hu"
	uniform = /obj/item/clothing/under/rank/zeng
	id = /obj/item/card/id/zeng_hu

/datum/outfit/job/scientist/xenobiologist/zeng_hu
	name = "Xenobiologist - Zeng-Hu"
	uniform = /obj/item/clothing/under/rank/zeng
	id = /obj/item/card/id/zeng_hu

/datum/outfit/job/representative/zeng_hu
	name = "Zeng-Hu Corporate Liaison"
	uniform = /obj/item/clothing/under/rank/zeng/civilian
	head = null
	suit = null
	implants = null
	id = /obj/item/card/id/zeng_hu
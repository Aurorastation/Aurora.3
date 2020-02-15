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
	<li><b>Senior Physician</b>: Zeng-Hu has some of the best medical staff
	in the world and you are one of them. Highly trained and highly experienced
	you are better then the rest save your colleagues in Zeng-Hu. You expect to
	be heard and obeyed. Your bedside manner is impeccable and far out classes
	standard NT training and procedure. The only thing that NT might have that is
	potentially superior is their chemical recipes and medical equipment. The only
	way to know this for sure is if you bring some samples back with you - medical
	cocktails from the pharmacy or perhaps high tech surgical gear. Bring it back
	to the Odin so we might analyze and assess these NT products.</li>
	<li><b>Geneticist</b>: Our genetics and robotics research is leagues above
	the rest and you know. We do own the best premium augmentation subsidiary in
	the known galaxy - Bishop Cybernetics - after all. Unlike your medical cousins
	you are much more likely to generate a friendly working atmosphere with non
	Zeng-Hu colleagues, of course you would? How else would you be able to get
	your hands on the experimental technologies NT is cooking up on station? We need
	to know what sort of robotics technology or bio-tech NT are currently dealing with.
	How you go about this is up to you, so long as you don't comprise yourself or
	your Zeng-Hu colleagues.</li>
	</ul></p>"}
	title_suffix = "Zeng"

	allowed_role_types = list(
		/datum/job/doctor,
		/datum/job/surgeon,
		/datum/job/pharmacist,
		/datum/job/psychiatrist,
		/datum/job/paramedic,
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
		"Biochemist" = /datum/outfit/job/pharmacist/zeng_hu,
		"Psychiatrist" = /datum/outfit/job/psychiatrist/zeng_hu,
		"Psychologist" = /datum/outfit/job/psychiatrist/zeng_hu,
		"Paramedic" = /datum/outfit/job/paramedic/zeng_hu,
		"Emergency Medical Technician" = /datum/outfit/job/paramedic/zeng_hu,
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

/datum/outfit/job/paramedic/zeng_hu
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
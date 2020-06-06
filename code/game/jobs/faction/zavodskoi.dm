/datum/faction/zavodskoi_interstellar
	name = "Zavodskoi Interstellar"
	description = {"<p>
	The largest weapons producer in human space, Zavodskoi Interstellar initially
	found its place with the invention of a militarized voidsuit for use in the Interstellar War.
	With many extraordinarily weapons contracts thanks to the Sol Alliance, as well as acquisitions of
	other major armaments companies, Zavodskoi weapons can be found in the hands of nearly every
	military force across the Orion Spur. They are the main corporation found in the Empire of
	Dominia, and are at the forefront of weapons development technology.
	</p>

	<p><font size='5' color='red'><b> DO NOT PLAY AN IPC AS A ZAVODSKOI LIAISON, THIS IS UNINTENDED. JOINING AS ONE WILL RESULT IN AN IPC/HEAD WHITELIST STRIP.</b></font>
	</p>

	<p>Some character examples are:
	<ul>
	<li><b>Surgical Specialist</b>: Unit to unit Zavodskoi ships the most firearms and weapons compared
	to any other corporation in the known galaxy and you're proud of it, but know the business comes with
	its hazards. Your medical experience has allowed you to survive the closing of many genetics testing
	centers during the recent transfer of leadership, and you know it. Zeng-Hu may have a reputation for
	being the best in the Orion Spur, but they are in the past - Zavodskoi is the future. You are a
	professional through-and-through, and consider yourself a (literal) cut above whatever washouts
	NanoTrasen can hire as surgeons. Just remember, you need to prove that you're better than Zeng-Hu.
	We need these medical contracts, lest we have to cut back the medical division just like the genetics one.</li>
	<li><b>Personal Security Professional</b>:Excellent customer service and client
	care is why Zavodskoi's private security personnel win security contracts and
	you know this. A cut above the rest, you are clear, calm, concise and polite when
	working. As a security force you were voted the most professional private security
	force to work for and as such, you have corporate standards to uphold! The protection
	of Zavodskoi staff is your first priority, but every member of the crew
	should be treated as a valued customer. After all, imagine how bad it would look to
	the shareholders if you were found beating a drunk like some kind of NanoTrasen officer.
	The reputation would last, but your career certainly wouldn't.</li>
	</ul></p>"}
	title_suffix = "Zavod"

	allowed_role_types = list(
		/datum/job/visitor,
		/datum/job/officer,
		/datum/job/warden,
		/datum/job/scientist,
		/datum/job/roboticist,
		/datum/job/surgeon,
		/datum/job/representative
	)

	allowed_species_types = list(
		/datum/species/human,
		/datum/species/skrell,
		/datum/species/unathi,
		/datum/species/diona,
		/datum/species/machine
	)

	titles_to_loadout = list(
		"Security Officer" = /datum/outfit/job/officer/zavodskoi,
		"Surgeon" = /datum/outfit/job/doctor/zavodskoi,
		"Warden" = /datum/outfit/job/warden/zavodskoi,
		"Scientist" = /datum/outfit/job/scientist/zavodskoi,
		"Phoron Researcher" = /datum/outfit/job/scientist/zavodskoi,
		"Xenoarcheologist" = /datum/outfit/job/scientist/zavodskoi,
		"Anomalist" = /datum/outfit/job/scientist/zavodskoi,
		"Roboticist" = /datum/outfit/job/roboticist/zavodskoi,
		"Biomechanical Engineer" = /datum/outfit/job/roboticist/zavodskoi,
		"Mechatronic Engineer" = /datum/outfit/job/roboticist/zavodskoi,
		"Corporate Liaison" = /datum/outfit/job/representative/zavodskoi
	)

/datum/outfit/job/officer/zavodskoi
	name = "Security Officer - Zavodskoi Interstellar"
	uniform = /obj/item/clothing/under/rank/security/zavodskoi
	id = /obj/item/card/id/zavodskoi/sec

/datum/outfit/job/warden/zavodskoi
	name = "Warden - Zavodskoi Interstellar"
	uniform = /obj/item/clothing/under/rank/security/zavodskoi
	id = /obj/item/card/id/zavodskoi/sec

/datum/outfit/job/scientist/zavodskoi
	name = "Scientist - Zavodskoi Interstellar"
	uniform = /obj/item/clothing/under/rank/zavodskoi/research
	id = /obj/item/card/id/zavodskoi

/datum/outfit/job/roboticist/zavodskoi
	name = "Roboticist - Zavodskoi Interstellar"
	uniform = /obj/item/clothing/under/rank/zavodskoi/research
	id = /obj/item/card/id/zavodskoi

/datum/outfit/job/doctor/zavodskoi
	name = "Physician - Zavodskoi Interstellar"
	uniform = /obj/item/clothing/under/rank/zavodskoi/research
	id = /obj/item/card/id/zavodskoi

/datum/outfit/job/representative/zavodskoi
	name = "Zavodskoi Interstellar Corporate Liaison"
	uniform = /obj/item/clothing/under/rank/zavodskoi
	head = null
	suit = null
	implants = null
	id = /obj/item/card/id/zavodskoi

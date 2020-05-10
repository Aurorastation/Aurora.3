/datum/faction/necropolis_industries
	name = "Necropolis Industries"
	description = {"<p>
	The largest weapons producer in human space, Necropolis Industries initially
	found their place with the invention of a militarized RIG suit for use in the
	Interstellar War. With many extraordinarily weapons contracts thanks to SolGov,
	as well as acquisitions of other major armaments companies, Necropolis Industries
	weapons can be found in the hands of nearly every military force across the Orion
	Spur. They are prominently associated with the Empire of Dominia, and are at
	the forefront of genetic modification technology.
	</p>
	<p>Some character examples are:
	<ul>
	<li><b>Bio-technician</b>: Unit to unit Necropolis ships the most firearms
	and weapons compared to any other corporation in the known galaxy and you're
	proud of it just as you take a vulgar pride in your known unscrupulous and
	slimy mannerisms, if only they knew the fools. Your genetics research has
	seen the advent of geneboosted sentients championed by the Dominian Empire,
	a civilization your company is very close to. The ethical concerns of both
	of those achievements are largely irrelevant compared to the general benefits
	and of course profits to be had. Your one rival in both these fields is NT
	whose cloning technologies and weapons technology outpaces all others. You
	need to get your hands on that tech without compromising Necropolises contract,
	and you think you might know how.</li>
	<li><b>Personal Security Professional</b>: Excellent customer service and client
	care is why Necropolis wins security contracts and you know this. A cut above
	the rest, you are clear, calm, concise and polite when working. As a security
	force you were voted the top firm to employ and as such, NanoTrasen Security should really
	be referring to your better judgement with security issues as far as you're
	concerned. All crew are your customers and as such deserve a top notch customer
	experience.</li>
	</ul></p>"}
	title_suffix = "Necro"

	allowed_role_types = list(
		/datum/job/officer,
		/datum/job/forensics,
		/datum/job/warden,
		/datum/job/doctor,
		/datum/job/surgeon,
		/datum/job/pharmacist,
		/datum/job/scientist,
		/datum/job/roboticist,
		/datum/job/representative
	)

	allowed_species_types = list(
		/datum/species/human,
		/datum/species/skrell,
		/datum/species/unathi,
		/datum/species/diona
	)

	titles_to_loadout = list(
		"Security Officer" = /datum/outfit/job/officer/necropolis,
		"Warden" = /datum/outfit/job/warden/necropolis,
		"Physician" = /datum/outfit/job/doctor/necropolis,
		"Surgeon" = /datum/outfit/job/doctor/necropolis,
		"Trauma Physician" = /datum/outfit/job/doctor/necropolis,
		"Nurse" = /datum/outfit/job/doctor/necropolis,
		"Pharmacist" = /datum/outfit/job/pharmacist/necropolis,
		"Biochemist" = /datum/outfit/job/pharmacist/necropolis,
		"Scientist" = /datum/outfit/job/scientist/necropolis,
		"Phoron Researcher" = /datum/outfit/job/scientist/necropolis,
		"Xenoarcheologist" = /datum/outfit/job/scientist/necropolis,
		"Anomalist" = /datum/outfit/job/scientist/necropolis,
		"Forensic Technician" = /datum/outfit/job/forensics/necropolis,
		"Crime Scene Investigator" = /datum/outfit/job/forensics/necropolis,
		"Roboticist" = /datum/outfit/job/roboticist/necropolis,
		"Biomechanical Engineer" = /datum/outfit/job/roboticist/necropolis,
		"Mechatronic Engineer" = /datum/outfit/job/roboticist/necropolis,
		"Corporate Liaison" = /datum/outfit/job/representative/necropolis
	)

/datum/outfit/job/officer/necropolis
	name = "Security Officer - Necropolis"
	uniform = /obj/item/clothing/under/rank/security/necropolis
	id = /obj/item/card/id/necropolis/sec

/datum/outfit/job/forensics/necropolis
	name = "Forensics Technician - Necropolis"
	uniform = /obj/item/clothing/under/rank/security/necropolis
	id = /obj/item/card/id/necropolis/sec

/datum/outfit/job/warden/necropolis
	name = "Warden - Necropolis"
	uniform = /obj/item/clothing/under/rank/security/necropolis
	id = /obj/item/card/id/necropolis/sec

/datum/outfit/job/doctor/necropolis
	name = "Physician - Necropolis"
	uniform = /obj/item/clothing/under/rank/necropolis/research
	id = /obj/item/card/id/necropolis

/datum/outfit/job/pharmacist/necropolis
	name = "Pharmacist - Necropolis"
	uniform = /obj/item/clothing/under/rank/necropolis/research
	id = /obj/item/card/id/necropolis

/datum/outfit/job/scientist/necropolis
	name = "Scientist - Necropolis"
	uniform = /obj/item/clothing/under/rank/necropolis/research
	id = /obj/item/card/id/necropolis

/datum/outfit/job/roboticist/necropolis
	name = "Roboticist - Necropolis"
	uniform = /obj/item/clothing/under/rank/necropolis/research
	id = /obj/item/card/id/necropolis

/datum/outfit/job/representative/necropolis
	name = "Necropolis Corporate Liaison"
	uniform = /obj/item/clothing/under/rank/necropolis
	head = null
	suit = null
	implants = null
	id = /obj/item/card/id/necropolis

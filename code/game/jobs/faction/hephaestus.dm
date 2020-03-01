/datum/faction/hephaestus_industries
	name = "Hephaestus Industries"
	description = {"<p>Hephaestus Industries, a sprawling and diverse mega-corporation
	focused on engineering and manufacturing on a massive scale, found their start
	as a conglomerate of several aerospace companies in the 22nd century. Initially
	funded by sales of new designs for warp technology, the company fell on hard times
	during the Second Great Depression in the late 23rd century. Receiving bailouts
	from SolGov and securing several crucial production contracts, they have slowly
	worked their way to become the dominant manufacturing mega-corporation in the
	Sol Alliance, pioneering interstellar logistics and construction on an awe-inspiring scale.
	</p>
	<p>Some character examples are:
	<ul>
	<li><b>Hephaestus Senior Engineer</b>: Hephaestus engineers are second
	to none when dealing with machine construction and maintenance and exceptional
	builders. As a Hephaestus engineer your customer service towards NT employees should
	be quite high. That being said you would be extremely keen to get hold of NTs
	secrets regarding construction materials and designs. Should a few phoron sheets
	or circuit boards find their way into your backpack when you hit the Odin, well,
	perhaps some credits might find their way into your account.</li>
	<li><b>Cargo Specialist</b>: In contrast to your engineer cousins your customer
	service level is subpar to be sure. You make up for it with your unshakable
	work ethic - no mining job too dangerous! You know that Hephaestus mining and
	logistics teams are superior to NanoTrasen's and in a perfect world the
	phoron reserves would belong to Hephaestus. Alas it isn't a perfect world.
	Perhaps that's a good thing, or people like you wouldn't exist. Getting hold
	of NanoTrasen's mech and mining research is key. How you go about this is up to you.</li>
	</ul></p>"}
	title_suffix = "Hepht"

	allowed_role_types = list(
		/datum/job/engineer,
		/datum/job/atmos,
		/datum/job/scientist,
		/datum/job/roboticist,
		/datum/job/mining,
		/datum/job/cargo_tech,
		/datum/job/qm,
		/datum/job/representative
	)

	allowed_species_types = list(
		/datum/species/human,
		/datum/species/skrell,
		/datum/species/machine,
		/datum/species/unathi,
		/datum/species/bug,
		/datum/species/tajaran,
		/datum/species/diona
	)

	titles_to_loadout = list(
		"Station Engineer" = /datum/outfit/job/engineer/hephaestus,
		"Maintenance Technician" = /datum/outfit/job/engineer/hephaestus,
		"Engine Technician" = /datum/outfit/job/engineer/hephaestus,
		"Electrician" = /datum/outfit/job/engineer/hephaestus,
		"Atmospheric Technician" = /datum/outfit/job/atmos/hephaestus,
		"Scientist" = /datum/outfit/job/scientist/hephaestus,
		"Phoron Researcher" = /datum/outfit/job/scientist/hephaestus,
		"Xenoarcheologist" = /datum/outfit/job/scientist/hephaestus,
		"Anomalist" = /datum/outfit/job/scientist/hephaestus,
		"Roboticist" = /datum/outfit/job/roboticist/hephaestus,
		"Shaft Miner" = /datum/outfit/job/mining/hephaestus,
		"Quartermaster" = /datum/outfit/job/qm/hephaestus,
		"Cargo Technician" = /datum/outfit/job/cargo_tech/hephaestus,
		"Corporate Liaison" = /datum/outfit/job/representative/hephaestus
	)

/datum/outfit/job/engineer/hephaestus
	name = "Station Engineer - Hephaestus"
	uniform = /obj/item/clothing/under/rank/hephaestus
	id = /obj/item/card/id/hephaestus

/datum/outfit/job/atmos/hephaestus
	name = "Atmospherics Technician - Hephaestus"
	uniform = /obj/item/clothing/under/rank/hephaestus
	id = /obj/item/card/id/hephaestus

/datum/outfit/job/scientist/hephaestus
	name = "Scientist - Hephaestus"
	uniform = /obj/item/clothing/under/rank/hephaestus/research
	id = /obj/item/card/id/hephaestus

/datum/outfit/job/roboticist/hephaestus
	name = "Roboticist - Hephaestus"
	uniform = /obj/item/clothing/under/rank/hephaestus/research
	id = /obj/item/card/id/hephaestus

/datum/outfit/job/mining/hephaestus
	name = "Miner - Hephaestus"
	uniform = /obj/item/clothing/under/rank/hephaestus/tech
	id = /obj/item/card/id/hephaestus

/datum/outfit/job/qm/hephaestus
	name = "Quartermaster - Hephaestus"
	uniform = /obj/item/clothing/under/rank/hephaestus/tech
	id = /obj/item/card/id/hephaestus

/datum/outfit/job/cargo_tech/hephaestus
	name = "Cargo Technician - Hephaestus"
	uniform = /obj/item/clothing/under/rank/hephaestus/tech
	id = /obj/item/card/id/hephaestus

/datum/outfit/job/representative/hephaestus
	name = "Hephaestus Corporate Liaison"
	uniform = /obj/item/clothing/under/rank/hephaestus
	head = null
	suit = null
	implants = null
	id = /obj/item/card/id/hephaestus

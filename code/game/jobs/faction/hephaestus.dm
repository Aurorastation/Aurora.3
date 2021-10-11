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
	<p>Hephaestus Industries employees can be in the following departments:
	<ul>
	<li><b>Engineering</b>
	<li><b>Operations</b>
	</ul></p>"}

	title_suffix = "Hepht"

	allowed_role_types = HEPH_ROLES

	allowed_species_types = list(
		/datum/species/human,
		/datum/species/skrell,
		/datum/species/machine,
		/datum/species/unathi,
		/datum/species/bug = TRUE,
		/datum/species/bug/type_b = TRUE,
		/datum/species/bug/type_e = TRUE,
		/datum/species/tajaran,
		/datum/species/diona
	)


	job_species_blacklist = list(
		"Corporate Liaison" = list(
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_BULWARK
		)
	)

/datum/outfit/job/engineer/hephaestus
	name = "Station Engineer - Hephaestus"
	uniform = /obj/item/clothing/under/rank/hephaestus
	id = /obj/item/card/id/hephaestus

/datum/outfit/job/atmos/hephaestus
	name = "Atmospherics Technician - Hephaestus"
	uniform = /obj/item/clothing/under/rank/hephaestus
	id = /obj/item/card/id/hephaestus

/datum/outfit/job/manufacturing_tech/hephaestus
	name = "Manufacturing Technician - Hephaestus"
	uniform = /obj/item/clothing/under/rank/hephaestus/research
	id = /obj/item/card/id/hephaestus

/datum/outfit/job/mining/hephaestus
	name = "Miner - Hephaestus"
	uniform = /obj/item/clothing/under/rank/hephaestus/tech
	id = /obj/item/card/id/hephaestus

/datum/outfit/job/hangar_tech/hephaestus
	name = "Hangar Technician - Hephaestus"
	uniform = /obj/item/clothing/under/rank/hephaestus/tech
	id = /obj/item/card/id/hephaestus

/datum/outfit/job/representative/hephaestus
	name = "Hephaestus Corporate Liaison"
	uniform = /obj/item/clothing/under/rank/hephaestus
	head = null
	suit = null
	implants = null
	id = /obj/item/card/id/hephaestus

	backpack_contents = list(
		/obj/item/device/camera = 1,
		/obj/item/gun/energy/pistol = 1,
		/obj/item/stamp/hephaestus = 1
	)

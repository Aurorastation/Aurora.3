/datum/faction/orin_express
	name = "Orion Express"
	description = {"<p>
	Hephaestus Industries, a sprawling and diverse mega-corporation
	focused on engineering and manufacturing on a massive scale, found their start
	as a conglomerate of several aerospace companies in the 22nd century. Initially
	funded by sales of new designs for warp technology, the company fell on hard times
	during the Second Great Depression in the late 23rd century. Receiving bailouts
	from SolGov and securing several crucial production contracts, they have slowly
	worked their way to become the dominant manufacturing mega-corporation in the
	Sol Alliance, pioneering interstellar logistics and construction on an awe-inspiring scale.
	</p>
	<p>Orion Express employees can be in the following departments:
	<ul>
	<li><b>Operations</b>
	</ul></p>"}

	title_suffix = "Orion"

	allowed_role_types = ORION_ROLES

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
			SPECIES_VAURCA_BULWARK,
			SPECIES_VAURCA_BREEDER
		)
	)
	titles_to_loadout = list(
		"Hangar Technician" = /datum/outfit/job/hangar_tech/orion,
		"Shaft Miner" = /datum/outfit/job/mining/orion,
		"Machinist" = /datum/outfit/job/machinist/orion
	)

/datum/outfit/job/hangar_tech/orion
	name = "Hangar Technician - Orion Express"
	uniform = /obj/item/clothing/under/rank/hangar_technician/orion

/datum/outfit/job/machinist/orion
	name = "Machinist - Orion Express"
	uniform = /obj/item/clothing/under/rank/machinist/orion
	suit = null

/datum/outfit/job/mining/orion
	name = "Shaft Miner - Orion Express"
	uniform = /obj/item/clothing/under/rank/miner/orion

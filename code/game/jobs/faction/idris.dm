/datum/faction/idris_incorporated
	name = "Idris Incorporated"
	description = {"<p>
	The Orion Spur's largest interstellar banking conglomerate, Idris Incorporated
	is operated by the mysterious Idris family. Idris Incorporated's influence
	can be found in nearly every corner of human space with their financing of
	nearly every type of business and enterprise. Their higher risk ventures have
	payment enforced by the infamous Idris Reclamation Units, shell IPCs sent to
	claim payment from negligent loan takers. In recent years, they have begun
	diversifying into more service-based industries.
	</p>
	<p>Idris Incorporated employees can be in the following departments:
	<ul>
	<li><b>Service</b>
	<li><b>Security</b>
	</ul></p>"}

	title_suffix = "Idris"

	allowed_role_types = IDRIS_ROLES

	allowed_species_types = list(
		/datum/species/human,
		/datum/species/skrell,
		/datum/species/machine,
		/datum/species/tajaran,
		/datum/species/diona
	)

	job_species_blacklist = list(
		"Corporate Liaison" = list(
			SPECIES_TAJARA,
			SPECIES_TAJARA_MSAI,
			SPECIES_TAJARA_ZHAN,
			SPECIES_UNATHI,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR
		)
	)

/datum/outfit/job/officer/idris
	name = "Security Officer - Idris"
	uniform = /obj/item/clothing/under/rank/security/idris
	id = /obj/item/card/id/idris/sec

/datum/outfit/job/detective/idris
	name = "Detective - Idris"
	uniform = /obj/item/clothing/under/rank/security/idris
	id = /obj/item/card/id/idris/sec

/datum/outfit/job/forensics/idris
	name = "Forensics Technician - Idris"
	uniform = /obj/item/clothing/under/rank/security/idris
	id = /obj/item/card/id/idris/sec

/datum/outfit/job/bartender/idris
	name = "Bartender - Idris"
	uniform = /obj/item/clothing/under/rank/idris/service
	id = /obj/item/card/id/idris

/datum/outfit/job/chef/idris
	name = "Chef - Idris"
	uniform = /obj/item/clothing/under/rank/idris/service
	id = /obj/item/card/id/idris

/datum/outfit/job/hydro/idris
	name = "Gardener - Idris"
	uniform = /obj/item/clothing/under/rank/idris/service
	id = /obj/item/card/id/idris

/datum/outfit/job/representative/idris
	name = "Idris Corporate Liaison"
	uniform = /obj/item/clothing/under/rank/idris
	head = null
	suit = null
	implants = null
	id = /obj/item/card/id/idris

	backpack_contents = list(
		/obj/item/device/camera = 1,
		/obj/item/gun/energy/pistol = 1,
		/obj/item/stamp/idris = 1
	)

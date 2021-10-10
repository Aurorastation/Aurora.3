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
	<li><b>Cargo Specialist</b>: In contrast to your engineer cousins your customer
	service level is subpar to be sure. You make up for it with your unshakable
	work ethic - no mining job too dangerous! You know that Hephaestus mining and
	logistics teams are superior to NanoTrasen's and in a perfect world the
	phoron reserves would belong to Hephaestus. Alas it isn't a perfect world.
	Perhaps that's a good thing, or people like you wouldn't exist. Getting hold
	of NanoTrasen's mech and mining research is key. How you go about this is up to you.</li>
	<li><b>Hephaestus Senior Engineer</b>: Hephaestus engineers are second to none when
	dealing with machine construction and maintenance. They are exceptional builders no
	matter the environment: in EVA, in a phoron fire, in a vented room, and everywhere else the
	Hephaestus Industries engineer is the best pick for the job. As a professional engineer your
	customer service towards NT employees should be quite high. You aren't some kind of
	wet-behind-the-ears underqualified NanoTrasen engineer that barely passed his qualifications - you're
	Hephaestus, and your NanoTrasen coworkers should really follow your lead when a crisis hits.</li>
	<li><b>Mechatronic Engineer</b>: In contrast to your engineering coworkers, you
	represent Hephaestus' robust research wing. Robotics specialists such as yourself
	have produced heavy-duty industrial exosuits and IPCs for decades, and you are just
	as able as they are. Unlike your counterparts in Zeng-Hu Pharmaceuticals, you don't
	built dainty augments and fragile IPCs that crumple in a stiff wind. Hephaestus builds
	equipment to last, and your products are no exception - even if they're being produced
	on contract.</li>
	</ul></p>"}
	title_suffix = "Hepht"


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

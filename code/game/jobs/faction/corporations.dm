/datum/faction/nano_trasen
	name = "NanoTrasen"
	description = "The most powerful mega-corporation in the entirety of known space, NanoTrasen Corporation wields power and influence on par with some small nations. One of the youngest mega-corporations, founded in 2346 by Benjamin Trasen, they were propelled to greatness through aggressive business tactics and shark-like business deals. They became the corporate power they are today with their discovery of Phoron in the Romanovich Cloud in Tau Ceti in 2417, allowing for immense electricity generation and newer, and vastly superior, FTL travel. This relative monopoly on this crucial resource has firmly secured their position as the wealthiest and most influential mega-corporation in the Orion Spur"
	//icon_file =

	is_default = TRUE

/datum/faction/nano_trasen/New()
	..()

	allowed_role_types = list()

	for (var/datum/job/job in SSjobs.occupations)
		allowed_role_types[job.type] = TRUE

/datum/faction/hephaestus_industries
	name = "Hephaestus Industries"
	description = "Hephaestus Industries, a sprawling and diverse mega-corporation focused on engineering and manufacturing on a massive scale, found their start as a conglomerate of several aerospace companies in the 22nd century. Initially funded by sales of new designs for warp technology, the company fell on hard times during the Second Great Depression in the late 23rd century. Receiving bailouts from SolGov and securing several crucial production contracts, they have slowly worked their way to become the dominant manufacturing mega-corporation in the Sol Alliance, pioneering interstellar logistics and construction on an awe-inspiring scale."
	//icon_file

	allowed_role_types = list(
		/datum/job/engineer = TRUE,
		/datum/job/atmos = TRUE,
		/datum/job/scientist = TRUE,
		/datum/job/roboticist = TRUE,
		/datum/job/mining = TRUE
	)

	allowed_species_types = list(
		/datum/species/human,
		/datum/species/skrell,
		/datum/species/machine,
		/datum/species/unathi,
		/datum/species/bug
	)

/datum/faction/idris_incorporated
	name = "Idris Incorporated"
	description = "The Orion Spur’s largest interstellar banking conglomerate, Idris Incorporated is operated by the mysterious Idris family. Idris Incorporated’s influence can be found in nearly every corner of human space with their financing of nearly every type of business and enterprise. Their higher risk ventures have payment enforced by the infamous Idris Reclamation Units, shell IPCs sent to claim payment from negligent loan takers. In recent years, they have begun diversifying into more service-based industries."

	allowed_role_types = list(
		/datum/job/officer = TRUE,
		/datum/job/bartender = TRUE,
		/datum/job/chef = TRUE,
		/datum/job/hydro = TRUE,
		/datum/job/cargo_tech = TRUE
	)

	allowed_species_types = list(
		/datum/species/human,
		/datum/species/skrell,
		/datum/species/machine,
		/datum/species/tajaran
	)

/datum/faction/necropolis_industries
	name = "Necropolis Industries"
	description = "The largest weapons producer in human space, Necropolis Industries initially found their place with the invention of a militarized RIG suit for use in the Interstellar War. With many extraordinarily weapons contracts thanks to SolGov, as well as acquisitions of other major armaments companies, Necropolis Industries weapons can be found in the hands of nearly every military force across the Orion Spur. They are prominently associated with the Empire of Dominia, and are at the forefront of genetic modification technology."

	allowed_role_types = list(
		/datum/job/officer = TRUE,
		/datum/job/warden = TRUE,
		/datum/job/doctor = TRUE,
		/datum/job/pharmacist  = TRUE,
		/datum/job/scientist = TRUE,
		/datum/job/roboticist = TRUE
	)

	allowed_species_types = list(
		/datum/species/human,
		/datum/species/skrell,
		/datum/species/tajaran,
		/datum/species/unathi
	)

/datum/faction/eridani_pmc
	name = "Eridani Private Military Contractors"
	description = {"Essentially the security branch of the Eridani Federation Military, the EPMC is renowned for its brutal yet efficient and above all legal security functions across the known galaxy. Staying as close as possible to the famed Eridanian “Non Aggression Protocol” in which no one within should conspire to damage, take part in damaging or incite others to damage corporate interests. EPMCs tend to lean heavily towards giving fines to regulation breakers. However, when the need to suppress civil disorder appears hell hath no fury like that of an Eridian security contractor with a stun baton."}

	allowed_role_types = list(
		/datum/job/officer = TRUE,
		/datum/job/warden = TRUE,
		/datum/job/forensics = TRUE,
		/datum/job/paramedic = TRUE
	)

	allowed_species_types = list(
		/datum/species/human,
		/datum/species/skrell,
		/datum/species/tajaran,
		/datum/species/unathi,
		/datum/species/bug
	)

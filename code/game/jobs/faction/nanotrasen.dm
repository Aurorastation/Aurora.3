/datum/faction/nano_trasen
	name = "NanoTrasen"
	description = "The most powerful mega-corporation in the entirety of known space, NanoTrasen Corporation wields power and influence on par with some small nations. One of the youngest mega-corporations, founded in 2346 by Benjamin Trasen, they were propelled to greatness through aggressive business tactics and shark-like business deals. They became the corporate power they are today with their discovery of Phoron in the Romanovich Cloud in Tau Ceti in 2417, allowing for immense electricity generation and newer, and vastly superior, FTL travel. This relative monopoly on this crucial resource has firmly secured their position as the wealthiest and most influential mega-corporation in the Orion Spur"
	title_suffix = "NT"

	is_default = TRUE

/datum/faction/nano_trasen/New()
	..()

	allowed_role_types = list()

	for (var/datum/job/job in SSjobs.occupations)
		allowed_role_types[job.type] = TRUE

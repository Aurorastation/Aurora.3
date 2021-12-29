/datum/map_template/ruin
	//name = "A Chest of Doubloons"
	name = null
	var/description = "In the middle of a clearing in the rockface, there's a chest filled with gold coins with Spanish engravings. \
	How is there a wooden container filled with 18th century coinage in the middle of a lavawracked hellscape? \
	It is clearly a mystery."

	var/spawn_weight = 1
	var/cost = null

	var/prefix = null
	var/suffix = null
	template_flags = 0 // No duplicates by default

/datum/map_template/ruin/New()
	if (suffix)
		mappath += (prefix + suffix)

	..()

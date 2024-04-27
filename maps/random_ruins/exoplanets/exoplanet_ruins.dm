/datum/map_template/ruin/exoplanet
	abstract_type = /datum/map_template/ruin/exoplanet

	prefix = "maps/random_ruins/exoplanets/"
	template_flags = TEMPLATE_FLAG_NO_RUINS
	spawn_weight = 1
	spawn_cost = 1

	/// See __defines/ruin_tags.dm
	var/planet_types = ALL_PLANET_TYPES
	var/ruin_tags = RUIN_ALL_TAGS

/datum/map_template/ruin/exoplanet/New(list/paths, rename)

	//Apply the prefix to the childs
	prefix = "maps/random_ruins/exoplanets/[prefix]"

	..()

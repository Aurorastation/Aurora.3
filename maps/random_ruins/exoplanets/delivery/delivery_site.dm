/datum/map_template/ruin/exoplanet/delivery_site
	name = "Delivery Site"
	id = "deliverysite"
	description = "An Orion Express branded delivery site."

	spawn_weight = 1
	spawn_cost = 1

	// going with the assumption that most exoplanets in corporate zones have some sort of base on it, maybe searching for phoron? doesn't really matter, it's mostly a gameplay concession
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED
	// however, it's an orion express system, so they'll obviously only appear in places that corporations have access to
	sectors = ALL_CORPORATE_SECTORS
	// available to all exoplanets, no filters
	ruin_tags = 0
	suffixes = list("delivery/delivery_site.dmm")

/datum/map_template/ruin/exoplanet/abandoned_prison
	name = "Abandoned Prison Mine"
	id = "abandoned_prison"
	description = "An abandoned penal mining colony."

	sectors = list(ALL_COALITION_SECTORS)
	sectors_blacklist = list(SECTOR_HANEUNIM)
	suffixes = list("asteroid/abandoned_prison/abandoned_prison.dmm")

	planet_types = PLANET_ASTEROID|PLANET_BARREN
	ruin_tags = RUIN_AIRLESS|RUIN_LOWPOP

/area/abandoned_prison
	name = "abandoned prison"
	icon_state = "unknown"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = TRUE

/area/abandoned_prison/eva_prep
	name = "EVA Preparation Room"
	icon_state = "eva"

/area/abandoned_prison/cells
	name = "Cells"
	icon_state = "brig"

/area/abandoned_prison/kitchen
	name = "Kitchen"
	icon_state = "kitchen"

/area/abandoned_prison/wardenoffice
	name = "Wardens Office"
	icon_state = "Warden"

/area/abandoned_prison/hydroponics
	name = "Hydroponics"
	icon_state = "hydro"

/area/abandoned_prison/engineering
	name = "Engineering"
	icon_state = "engineering"

/area/abandoned_prison/wardenbathroom
	name = "Warden Bathroom"
	icon_state = "restrooms"

/area/abandoned_prison/bathroom
	name = "Bathroom"
	icon_state = "restrooms"

/area/abandoned_prison/medbay
	name = "Medical Bay"
	icon_state = "medbay"

/area/abandoned_prison/exterior
	name = "Exterior"
	icon_state = "space"

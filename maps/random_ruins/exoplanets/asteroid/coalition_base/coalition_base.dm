/datum/map_template/ruin/exoplanet/coalition_base
    name = "Abandoned Coalition Relay"
    id = "coalition_base"
    description = "hehehe cock base"

    sectors = list(ALL_COALITION_SECTORS)
    suffixes = list("asteroid/coalition_base/coalition_base.dmm")

    planet_types = PLANET_ASTEROID|PLANET_BARREN
    ruin_tags = RUIN_AIRLESS|RUIN_LOWPOP

/area/coalition_base
  name = "coalition base"
  icon_state = "unknown"
  requires_power = TRUE
  dynamic_lighting = TRUE
  no_light_control = TRUE

/area/coalition_base/eva_prep
	name = "EVA Preparation Room"
	icon_state = "eva"

/area/coalition_base/lounge
	name = "Smoking Lounge"
	icon_state = "lounge"

/area/coalition_base/kitchen
	name = "Kitchen"
	icon_state = "kitchen"

/area/coalition_base/armoury
	name = "Armoury"
	icon_state = "armory"

/area/coalition_base/hydroponics
	name = "Hydroponics"
	icon_state = "hydro"

/area/coalition_base/engineering
	name = "Engineering"
	icon_state = "engineering"

/area/coalition_base/telecomms
	name = "Telecommunications"
	icon_state = "tcomsatcham"

/area/coalition_base/bathroom
	name = "Bathroom"
	icon_state = "restrooms"

/area/coalition_base/barracks
	name = "Barracks Room"
	icon_state = "crew_quarters"

/area/coalition_base/medbay
	name = "Medical Bay"
	icon_state = "medbay"

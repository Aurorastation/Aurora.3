// ------------------------- base/parent

/area/dinakk
	icon_state = "white128a"
	requires_power = FALSE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/snow
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS | AREA_FLAG_IS_BACKGROUND
	holomap_color = "#494949"
	is_outside = OUTSIDE_YES

// ------------------------- outside

/area/dinakk/outside
	name = "Din'akk Valley"
	is_outside = OUTSIDE_YES
	requires_power = FALSE

/area/dinakk/outside/mountains
	name = "Din'akk Mountains"
	color = "#2e2e2e"

/area/firebase_dinakk/outside/firebase_dinakk
	name = "Firebase Din'akk"
	is_outside = OUTSIDE_YES
	color = "#2e2e2e"

/area/firebase_dinakk/outside/firebase_dinakk/artillery
	name = "Firebase Din'akk, Outdoors - Field Gun Emplacement"

/area/firebase_dinakk/outside/firebase_dinakk/artillery/tent
	is_outside = OUTSIDE_NO

/area/firebase_dinakk/outside/firebase_dinakk/parade
	name = "Firebase Din'akk, Outdoors - Parade Grounds"

/area/firebase_dinakk/outside/firebase_dinakk/cages
	name = "Firebase Din'akk, Outdoors - Ha'rron Kennel"

/area/firebase_dinakk/outside/firebase_dinakk/landing_pad
	name = "Firebase Din'akk, Outdoors - Landing Pad"
// --------

// Unsorted Building Insides
/area/firebase_dinakk/inside
	name = "Firebase Din'akk - Base Type"
	requires_power = FALSE

/area/firebase_dinakk/inside/checkpoint
	name = "Firebase Din'akk - Checkpoint"

/area/firebase_dinakk/inside/garage
	name = "Firebase Din'akk - Garage"

/area/firebase_dinakk/inside/armoury
	name = "Firebase Din'akk - Armoury"

/area/firebase_dinakk/inside/infirmary
	name = "Firebase Din'akk - Infirmary"
// --------

// Barracks
/area/firebase_dinakk/inside/barracks
	name = "Firebase Din'akk, Barracks - Base Type"

/area/firebase_dinakk/inside/barracks/hallway
	name = "Firebase Din'akk, Barracks - Hallway"

/area/firebase_dinakk/inside/barracks/bunks
	name = "Firebase Din'akk, Barracks - Bunks"

/area/firebase_dinakk/inside/barracks/lavatory
	name = "Firebase Din'akk, Barracks - Lavatory"

/area/firebase_dinakk/inside/barracks/kitchen
	name = "Firebase Din'akk, Barracks - Kitchen"

/area/firebase_dinakk/inside/barracks/hydro
	name = "Firebase Din'akk, Barracks - Hydroponics"
// --------

// Presidium
/area/firebase_dinakk/inside/presidium
	name = "Firebase Din'akk, Presidium - Base Type"

/area/firebase_dinakk/inside/presidium/antechamber
	name = "Firebase Din'akk, Presidium - Antechamber"

/area/firebase_dinakk/inside/presidium/briefing
	name = "Firebase Din'akk, Presidium - Briefing Room"

/area/firebase_dinakk/inside/presidium/commander_office
	name = "Firebase Din'akk, Presidium - Commander's Office"

/area/firebase_dinakk/inside/presidium/commander_quarters
	name = "Firebase Din'akk, Presidium - Commander's Quarters"
// --------

// Basement
/area/firebase_dinakk/inside/basement
	name = "Firebase Din'akk, Basement - Base Type"

/area/firebase_dinakk/inside/basement/hallway_upper
	name = "Firebase Din'akk, Basement - Hallway"

/area/firebase_dinakk/inside/basement/hallway_lower
	name = "Firebase Din'akk, Basement - Hallway"

/area/firebase_dinakk/inside/basement/atc
	name = "Firebase Din'akk, Basement - Air Traffic Control"

/area/firebase_dinakk/inside/basement/helipad
	name = "Firebase Din'akk, Basement - Helipad"
	is_outside = OUTSIDE_YES

/area/firebase_dinakk/inside/basement/vault
	name = "Firebase Din'akk, Basement - Vault"
// --------

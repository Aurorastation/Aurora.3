// ------------------------- base/parent

/area/cryo_outpost
	name = "Outpost"
	icon_state = "bluenew"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/barren
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS | AREA_FLAG_IS_BACKGROUND
	holomap_color = "#494949"
	is_outside = OUTSIDE_NO

// ------------------------- outside

/area/cryo_outpost/outside
	area_blurb = "An oasis in the middle of a desert. Red rocks mar a fairly scenic environment. In the distance is a large, red cave, with an ominous entrance."
	is_outside = OUTSIDE_YES

/area/cryo_outpost/outside/landing
	name = "Landing Pad"
	icon_state = "yellow"

/area/cryo_outpost/outside/surface
	name = "Surface"

/area/cryo_outpost/outside/cave
	name = "Cave"
	icon_state = "red"
	is_outside = OUTSIDE_NO
	holomap_color = "#2e2e2e"

/area/cryo_outpost/outside/buildings
	name = "Building"
	is_outside = OUTSIDE_NO

// ------------------------- inside

/area/cryo_outpost/inside
	area_blurb = "The cold, distasteful smell of a sterile environment hits your nostrils. The temperature seems to be a perfectly cool twenty degrees. \
				You get an ominous feeling just by being here."
	is_outside = OUTSIDE_NO
	holomap_color = "#777777"

// ------------- hallways

/area/cryo_outpost/inside/entrance_main
	name = "Entrance, Main"
	icon_state = "storage"
	holomap_color = "#8d8d8d"

/area/cryo_outpost/inside/entrance_aux_east
	name = "Entrance, Aux East"
	icon_state = "storage"
	holomap_color = "#8d8d8d"

/area/cryo_outpost/inside/entrance_aux_west
	name = "Entrance, Aux West"
	icon_state = "storage"
	holomap_color = "#8d8d8d"

/area/cryo_outpost/inside/hallway_central
	name = "Hallway, Central"
	icon_state = "hallC"
	holomap_color = "#8d8d8d"

/area/cryo_outpost/inside/hallway_east
	name = "Hallway, East"
	icon_state = "hallC"
	holomap_color = "#8d8d8d"

/area/cryo_outpost/inside/hallway_west
	name = "Hallway, West"
	icon_state = "hallC"
	holomap_color = "#8d8d8d"

// ------------- crew

/area/cryo_outpost/inside/habitation_east
	name = "Habitation, East"
	icon_state = "crew_quarters"
	holomap_color = "#54654c"

/area/cryo_outpost/inside/habitation_west
	name = "Habitation, West"
	icon_state = "crew_quarters"
	holomap_color = "#54654c"

/area/cryo_outpost/inside/canteen
	name = "Kitchen"
	icon_state = "kitchen"
	holomap_color = "#54654c"

/area/cryo_outpost/inside/botany
	name = "Hydroponics"
	icon_state = "garden"
	holomap_color = "#b19664"

/area/cryo_outpost/inside/medical
	name = "Medical"
	icon_state = "medbay"
	holomap_color = "#8daf6a"

/area/cryo_outpost/inside/comms
	name = "Communications"
	icon_state = "bridge"
	holomap_color = "#708997"

/area/cryo_outpost/inside/security
	name = "Security"
	icon_state = "security"
	holomap_color = "#708997"

// ------------- labs

/area/cryo_outpost/inside/labs_hallway
	name = "Labs, Hallway"
	icon_state = "hallC"
	holomap_color = "#8a7387"

/area/cryo_outpost/inside/labs_cryo_n
	name = "Labs, Cryo North"
	icon_state = "cryo"
	holomap_color = "#8a7387"

/area/cryo_outpost/inside/labs_cryo_s
	name = "Labs, Cryo South"
	icon_state = "cryo"
	holomap_color = "#8a7387"

/area/cryo_outpost/inside/labs_cryo_pods
	name = "Labs, Cryo Pods"
	icon_state = "cryo"
	holomap_color = "#8a7387"

/area/cryo_outpost/inside/labs_offices
	name = "Labs, Offices"
	icon_state = "research"
	holomap_color = "#8a7387"

/area/cryo_outpost/inside/labs_surgery
	name = "Labs, Surgery"
	icon_state = "surgery"
	holomap_color = "#cc9090"

/area/cryo_outpost/inside/labs_rnd
	name = "Labs, RnD"
	icon_state = "research"
	holomap_color = "#cc9090"

/area/cryo_outpost/inside/labs_maint_w
	name = "Labs, Maint, West"
	icon_state = "maintenance"

/area/cryo_outpost/inside/labs_maint_e
	name = "Labs, Maint, East"
	icon_state = "maintenance"

/area/cryo_outpost/inside/labs_pharmacy
	name = "Labs, Pharmacy"
	icon_state = "phar"
	holomap_color = "#cc9090"

// ------------- engineering

/area/cryo_outpost/inside/warehouse
	name = "Warehouse"
	icon_state = "storage"
	holomap_color = "#ceb689"

/area/cryo_outpost/inside/engineering
	name = "Engineering"
	icon_state = "engineering"
	holomap_color = "#ceb689"

/area/cryo_outpost/inside/engi_powergen
	name = "Engineering, Power Generation"
	icon_state = "engineering"
	holomap_color = "#ceb689"

/area/cryo_outpost/inside/engi_atmos
	name = "Engineering, Atmospherics"
	icon_state = "engineering"
	holomap_color = "#ceb689"

/area/cryo_outpost/inside/sensors_iff
	name = "Sensors and IFF"
	icon_state = "engineering"
	holomap_color = "#ceb689"

/area/cryo_outpost/inside/eva
	name = "EVA"
	icon_state = "engineering"

// ------------------------- maint

/area/cryo_outpost/inside/maint_medbay
	name = "Maint, Medbay"
	icon_state = "maintenance"

/area/cryo_outpost/inside/maint_habitation
	name = "Maint, Habitation"
	icon_state = "maintenance"

/area/cryo_outpost/inside/maint_warehouse
	name = "Maint, Warehouse"
	icon_state = "maintenance"

/area/cryo_outpost/inside/maint_botany
	name = "Maint, Botany"
	icon_state = "maintenance"

/area/cryo_outpost/inside/maint_entrance
	name = "Maint, Entrance"
	icon_state = "maintenance"

/area/cryo_outpost/inside/maint_engineering
	name = "Maint, Engineering"
	icon_state = "maintenance"

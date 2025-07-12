
// ================================ hangars

/obj/effect/shuttle_landmark/horizon/hangar1
	name = "First Deck Port Hangar Bay 1a"
	landmark_tag = "nav_horizon_hangar_1"
	base_turf = /turf/simulated/floor/plating
	base_area = /area/horizon/hangar/auxiliary

/obj/effect/shuttle_landmark/horizon/hangar2
	name = "First Deck Port Hangar Bay 2a"
	landmark_tag = "nav_horizon_hangar_2"
	base_turf = /turf/simulated/floor/plating
	base_area = /area/horizon/hangar/auxiliary

// ================================ exterior docks

#define NAV_HORIZON_DOCK_ALL list(\
	"nav_horizon_dock_deck_3_starboard_1",\
	"nav_horizon_dock_deck_3_starboard_2",\
	"nav_horizon_dock_deck_3_starboard_3",\
	"nav_horizon_dock_deck_3_port_2",\
	"nav_horizon_dock_deck_3_port_4",\
	"nav_horizon_dock_deck_3_port_5",\
)

/obj/effect/shuttle_landmark/horizon/dock/deck_3/starboard_1
	name = "Third Deck Starboard Dock 1"
	landmark_tag = "nav_horizon_dock_deck_3_starboard_1"
	docking_controller = "airlock_horizon_dock_deck_3_starboard_1"
	base_turf = /turf/simulated/floor/reinforced/airless
	base_area = /area/space

/obj/effect/shuttle_landmark/horizon/dock/deck_3/starboard_2
	name = "Third Deck Starboard Dock 2"
	landmark_tag = "nav_horizon_dock_deck_3_starboard_2"
	docking_controller = "airlock_horizon_dock_deck_3_starboard_2"
	base_turf = /turf/simulated/floor/reinforced/airless
	base_area = /area/space

/obj/effect/shuttle_landmark/horizon/dock/deck_3/starboard_3
	name = "Third Deck Starboard Dock 3"
	landmark_tag = "nav_horizon_dock_deck_3_starboard_3"
	docking_controller = "airlock_horizon_dock_deck_3_starboard_3"
	base_turf = /turf/simulated/floor/reinforced/airless
	base_area = /area/space

/obj/effect/shuttle_landmark/horizon/dock/deck_3/port_1
	name = "Third Deck Port Dock 1"
	landmark_tag = "nav_horizon_dock_deck_3_port_2"
	docking_controller = "airlock_horizon_dock_deck_3_port_2"
	base_turf = /turf/simulated/floor/reinforced/airless
	base_area = /area/space

/obj/effect/shuttle_landmark/horizon/dock/deck_3/port_2
	name = "Third Deck Port Dock 2"
	landmark_tag = "nav_horizon_dock_deck_3_port_4"
	docking_controller = "airlock_horizon_dock_deck_3_port_4"
	base_turf = /turf/simulated/floor/reinforced/airless
	base_area = /area/space

/obj/effect/shuttle_landmark/horizon/dock/deck_3/port_3
	name = "Third Deck Port Dock 3"
	landmark_tag = "nav_horizon_dock_deck_3_port_5"
	docking_controller = "airlock_horizon_dock_deck_3_port_5"
	base_turf = /turf/simulated/floor/reinforced/airless
	base_area = /area/space

// ================================ exterior

#define NAV_HORIZON_EXTERIOR_ALL_DECKS list(NAV_HORIZON_EXTERIOR_ALL_DECK_1, NAV_HORIZON_EXTERIOR_ALL_DECK_2, NAV_HORIZON_EXTERIOR_ALL_DECK_3)

/obj/effect/shuttle_landmark/horizon/exterior
	base_turf = /turf/space
	base_area = /area/space

// ================================ exterior deck 1

#define NAV_HORIZON_EXTERIOR_ALL_DECK_1 list(\
	"nav_horizon_exterior_deck_1_fore",\
	"nav_horizon_exterior_deck_1_port",\
	"nav_horizon_exterior_deck_1_starboard",\
	"nav_horizon_exterior_deck_1_aft",\
	"nav_horizon_exterior_deck_1_port_propulsion",\
	"nav_horizon_exterior_deck_1_starboard_propulsion",\
)

/obj/effect/shuttle_landmark/horizon/exterior/deck_1/fore
	name = "Deck One, Fore of Horizon"
	landmark_tag = "nav_horizon_exterior_deck_1_fore"

/obj/effect/shuttle_landmark/horizon/exterior/deck_1/port
	name = "Deck One, Port of Horizon"
	landmark_tag = "nav_horizon_exterior_deck_1_port"

/obj/effect/shuttle_landmark/horizon/exterior/deck_1/starboard
	name = "Deck One, Starboard of Horizon"
	landmark_tag = "nav_horizon_exterior_deck_1_starboard"

/obj/effect/shuttle_landmark/horizon/exterior/deck_1/aft
	name = "Deck One, Aft of Horizon"
	landmark_tag = "nav_horizon_exterior_deck_1_aft"

/obj/effect/shuttle_landmark/horizon/exterior/deck_1/port_propulsion
	name = "Deck One, Near Port Propulsion"
	landmark_tag = "nav_horizon_exterior_deck_1_port_propulsion"

/obj/effect/shuttle_landmark/horizon/exterior/deck_1/starboard_propulsion
	name = "Deck One, Near Starboard Propulsion"
	landmark_tag = "nav_horizon_exterior_deck_1_starboard_propulsion"

// ================================ exterior deck 2

#define NAV_HORIZON_EXTERIOR_ALL_DECK_2 list(\
	"nav_horizon_exterior_deck_2_fore",\
	"nav_horizon_exterior_deck_2_starboard_fore",\
	"nav_horizon_exterior_deck_2_port_fore",\
	"nav_horizon_exterior_deck_2_aft",\
	"nav_horizon_exterior_deck_2_starboard_aft",\
	"nav_horizon_exterior_deck_2_port_aft",\
)

/obj/effect/shuttle_landmark/horizon/exterior/deck_2/fore
	name = "Deck Two, Fore of Horizon"
	landmark_tag = "nav_horizon_exterior_deck_2_fore"

/obj/effect/shuttle_landmark/horizon/exterior/deck_2/starboard_fore
	name = "Deck Two, Starboard Fore of Horizon"
	landmark_tag = "nav_horizon_exterior_deck_2_starboard_fore"

/obj/effect/shuttle_landmark/horizon/exterior/deck_2/port_fore
	name = "Deck Two, Port Fore of Horizon"
	landmark_tag = "nav_horizon_exterior_deck_2_port_fore"

/obj/effect/shuttle_landmark/horizon/exterior/deck_2/aft
	name = "Deck Two, Aft of Horizon"
	landmark_tag = "nav_horizon_exterior_deck_2_aft"

/obj/effect/shuttle_landmark/horizon/exterior/deck_2/starboard_aft
	name = "Deck One, Starboard Aft of horizon"
	landmark_tag = "nav_horizon_exterior_deck_2_starboard_aft"

/obj/effect/shuttle_landmark/horizon/exterior/deck_2/port_aft
	name = "Deck One, Port Aft of Horizon"
	landmark_tag = "nav_horizon_exterior_deck_2_port_aft"

// ================================ exterior deck 3

#define NAV_HORIZON_EXTERIOR_ALL_DECK_3 list(\
	"nav_horizon_exterior_deck_3_fore",\
	"nav_horizon_exterior_deck_3_starboard_fore",\
	"nav_horizon_exterior_deck_3_port_fore",\
	"nav_horizon_exterior_deck_3_port_aft",\
	"nav_horizon_exterior_deck_3_aft",\
)

/obj/effect/shuttle_landmark/horizon/exterior/deck_3/fore
	name = "Deck Three, Fore of Horizon"
	landmark_tag = "nav_horizon_exterior_deck_3_fore"

/obj/effect/shuttle_landmark/horizon/exterior/deck_3/starboardfore
	name = "Deck Three, Starboard Fore of Horizon"
	landmark_tag = "nav_horizon_exterior_deck_3_starboard_fore"

/obj/effect/shuttle_landmark/horizon/exterior/deck_3/portfore
	name = "Deck Three, Fore Port of Horizon"
	landmark_tag = "nav_horizon_exterior_deck_3_port_fore"

/obj/effect/shuttle_landmark/horizon/exterior/deck_3/portaft
	name = "Deck Three, Aft Port of Horizon"
	landmark_tag = "nav_horizon_exterior_deck_3_port_aft"

/obj/effect/shuttle_landmark/horizon/exterior/deck_3/aft
	name = "Deck Three, Aft of Horizon"
	landmark_tag = "nav_horizon_exterior_deck_3_aft"

// ================================ exterior sneaky antag-only landmarks

#define NAV_HORIZON_EXTERIOR_ALL_SNEAKY list(\
	"nav_horizon_exterior_sneaky_starboard_nacelle_1",\
	"nav_horizon_exterior_sneaky_starboard_nacelle_2",\
)

/obj/effect/shuttle_landmark/horizon/exterior/sneaky/starboard_nacelle_1
	name = "Deck Two, Starboard Nacelle 1"
	landmark_tag = "nav_horizon_exterior_sneaky_starboard_nacelle_1"

/obj/effect/shuttle_landmark/horizon/exterior/sneaky/starboard_nacelle_2
	name = "Deck Two, Starboard Nacelle 2"
	landmark_tag = "nav_horizon_exterior_sneaky_starboard_nacelle_2"

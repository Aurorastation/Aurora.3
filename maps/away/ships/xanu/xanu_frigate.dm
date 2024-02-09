/datum/map_template/ruin/away_site/xanu_frigate
	name = "Xanu Spacefleet Frigate"
	description = "The Shrike-class frigate is a formidable warship in use by the All-Xanu Spacefleet and forms a ubiquitous part of its naval force. \
	Despite it making up a large portion of the planet's navy, no expense was spared in engineering this warship, with thick hull plating and redundant\
	power, engines, and life support systems making this craft notoriously survivable even when taking massive blows, leaving it intact enough \
	to return the favor in a gunfight."
	suffixes = list("ships/xanu/xanu_frigate.dmm")
	sectors = list(ALL_COALITION_SECTORS)
	spawn_weight = 1
	ship_cost = 1
	id = "xanu_frigate"
	unit_test_groups = list(3)
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

/singleton/submap_archetype/xanu_frigate
	map = "Xanu Spacefleet Frigate"
	descriptor = "The Shrike-class frigate is a formidable warship in use by the All-Xanu Spacefleet and forms a ubiquitous part of its naval force. \
	Despite it making up a large portion of the planet's navy, no expense was spared in engineering this warship, with thick hull plating and redundant\
	power, engines, and life support systems making this craft notoriously survivable even when taking massive blows, leaving it intact enough \
	to return the favor in a gunfight."

// ship

/obj/effect/overmap/visitable/ship/xanu_frigate
	name = "Xanu Spacefleet Frigate"
	class = "AXSV"
	desc = "The Shrike-class frigate is a formidable warship in use by the All-Xanu Spacefleet and forms a ubiquitous part of its naval force. \
	Despite it making up a large portion of the planet's navy, no expense was spared in engineering this warship, with thick hull plating and redundant\
	power, engines, and life support systems making this craft notoriously survivable even when taking massive blows, leaving it intact enough \
	to return the favor in a gunfight."
	icon_state = "xanu_frigate"
	moving_state = "xanu_frigate_moving"
	colors = "#899997"
	designer = "dNA Defense & Aerospace Shipyards"
	volume = "108 meters length, 71 meters beam/width, 45 meters vertical height"
	drive = "Medium-Speed Warp Acceleration FTL Drive"
	propulsion = "Superheated Composite Gas Thrust"
	weapons = "Dual extruding fore caliber ballistic armaments, aft obscured flight craft bay"
	sizeclass = "Shrike-class Frigate"
	shiptype = "Naval frigate"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 6000
	vessel_size = SHIP_SIZE_LARGE
	fore_dir = SOUTH
	invisible_until_ghostrole_spawn = FALSE

/obj/effect/overmap/visitable/ship/xanu_frigate/New()
	designation = "[pick("Sterrenlicht", "Riviere", "Vandenberg", "Sterkarm", "Fontaine", "Souverain", "Zilverberg", "Vanhoorn", "Lefebure", "Eclairant", "Liberte", "Huyghe", "Montclair")]"
	..()

//Fighter

/obj/effect/overmap/visitable/ship/landable/xanu_fighter
	name = "Xanu Fighter"
	class = "AXSS"
	desc = "The A-42 'Arbalest' heavy fighter is a trademark of the All-Xanu Spacefleet's fighter contingent and the standard strike craft of choice on non-carrier vessels with a hangar. It boasts the maneuverability and speed of a light fighter while also \
	possessing the armor and range capabilities of a larger vessel. Compared to its carrier-based cousins, the Arbalest-class is more capable of holding ground on its own, and it is usually fielded as a compliment to a larger mothership."
	shuttle = "Xanu Fighter"
	icon_state = "canary"
	moving_state = "canary_moving"
	colors = "#899997"
	max_speed = 1/(2 SECONDS)
	burn_delay = 0.5 SECONDS
	vessel_mass = 800
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY
	designer = "dNA Defense & Aerospace Shipyards"
	volume = "12 meters length, 9 meters beam/width, 6 meters vertical height"
	weapons = "Extruding fore-mounted low-caliber ballistic rotary armament"
	sizeclass = "Heavy fighter and interceptor"
	shiptype = "Anti-ship high-speed combat and interception"

/obj/effect/overmap/visitable/ship/landable/xanu_fighter/New()
	designation = "Xanu Fighter"
	..()

/obj/machinery/computer/shuttle_control/explore/terminal/xanu_fighter
	name = "fightercraft control console"
	shuttle_tag = "Xanu Fighter"

/datum/shuttle/autodock/overmap/xanu_fighter
	name = "Xanu Fighter"
	move_time = 15
	shuttle_area = list(/area/shuttle/xanu_fighter)
	dock_target = "xanu_fighter"
	current_location = "xanufrigate_hangar"
	landmark_transition = "xanufrigate_transit_b"
	range = 1
	fuel_consumption = 1
	logging_home_tag = "xanufrigate_hangar"
	defer_initialisation = TRUE

//Boarder

/obj/effect/overmap/visitable/ship/landable/xanu_boarder
	name = "Xanu Boarder"
	class = "AXSS"
	desc = "The Wren-class boarding craft is a high-capacity shuttlecraft used by the All-Xanu Spacefleet to conduct both normal crew transportation and combat boarding actions. While unremarkable in design, it still \
	boasts long range, high maneuverability, and good survivability."
	shuttle = "Xanu Boarder"
	icon_state = "intrepid"
	moving_state = "intrepid_moving"
	colors = "#899997"
	max_speed = 1/(2 SECONDS)
	burn_delay = 0.5 SECONDS
	vessel_mass = 1500
	fore_dir = EAST
	vessel_size = SHIP_SIZE_TINY
	designer = "dNA Defense & Aerospace Shipyards"
	volume = "23 meters length, 9 meters beam/width, 10 meters vertical height"
	sizeclass = "Military transporter shuttlecraft"
	shiptype = "Transportation and combat boarding"

/obj/effect/overmap/visitable/ship/landable/xanu_boarder/New()
	designation = "[pick("Phoebe", "Lark", "Siskin", "Grosbeak", "Cormorant", "Skua", "Gannet")]"
	..()

/obj/machinery/computer/shuttle_control/explore/terminal/xanu_boarder
	name = "shuttle control console"
	shuttle_tag = "Xanu Boarder"

/datum/shuttle/autodock/overmap/xanu_boarder
	name = "Xanu Boarder"
	move_time = 15
	shuttle_area = list(/area/shuttle/xanu_boarder, /area/shuttle/xanu_boarder/cockpit, /area/shuttle/xanu_boarder/engineering)
	dock_target = "xanu_boarder"
	current_location = "xanufrigate_aft"
	landmark_transition = "xanufrigate_transit_a"
	range = 1
	fuel_consumption = 1
	logging_home_tag = "xanufrigate_aft"
	defer_initialisation = TRUE

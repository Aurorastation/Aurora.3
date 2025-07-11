#define COLOR_HIMEO_NAVY "#313d73"

/obj/machinery/door/airlock/himeo_patrol
	door_frame_color = COLOR_RAIDER
	door_color = COLOR_HIMEO_NAVY
	req_access = list(ACCESS_HIMEO_PATROL_SHIP)

/obj/machinery/door/airlock/glass/himeo_patrol
	door_frame_color = COLOR_RAIDER
	door_color = COLOR_HIMEO_NAVY
	req_access = list(ACCESS_HIMEO_PATROL_SHIP)

/obj/machinery/door/airlock/highsecurity/himeo_patrol
	door_frame_color = COLOR_RAIDER
	req_access = list(ACCESS_HIMEO_PATROL_SHIP)

/obj/machinery/door/airlock/external/himeo_patrol
	door_frame_color = COLOR_RAIDER
	door_color = COLOR_DARK_RED
	req_access = list(ACCESS_HIMEO_PATROL_SHIP)

/obj/machinery/door/airlock/hatch/himeo_patrol
	door_frame_color = COLOR_RAIDER
	req_access = list(ACCESS_HIMEO_PATROL_SHIP)

/obj/machinery/door/airlock/multi_tile/glass/himeo_patrol
	door_frame_color = COLOR_RAIDER
	door_color = COLOR_RAIDER
	req_access = list(ACCESS_HIMEO_PATROL_SHIP)
	name = "Glass Airlock"

/obj/machinery/door/airlock/multi_tile/flipped/glass/himeo_patrol
	door_frame_color = COLOR_RAIDER
	door_color = COLOR_RAIDER
	req_access = list(ACCESS_HIMEO_PATROL_SHIP)
	name = "Glass Airlock"

// Engineering
/obj/machinery/door/airlock/himeo_patrol/engineering
	name = "Engineering"
	stripe_color = COLOR_ORANGE

/obj/machinery/door/airlock/himeo_patrol/engineering/tools
	name = "Tool storage"

/obj/machinery/door/airlock/himeo_patrol/engineering/distribution
	name = "Distribution"

/obj/machinery/door/airlock/external/himeo_patrol/combustion
	name = "Combustion Chamber"
	icon_state = "door_locked"
	id_tag = "himeo_military_teg_door"
	locked = 1

// High Security
/obj/machinery/door/airlock/highsecurity/himeo_patrol/gunnery
	name = "Gunnery"
	stripe_color = COLOR_RED

/obj/machinery/door/airlock/highsecurity/himeo_patrol/gunnery/ammunition
	name = "Ammunition Stowage"

// Propulsion
/obj/machinery/door/airlock/hatch/himeo_patrol/propulsion
	name = "Propulsion"
	stripe_color = COLOR_PURPLE_GRAY

// Bridge
/obj/machinery/door/airlock/highsecurity/himeo_patrol/bridge
	name = "Bridge"
	stripe_color = COLOR_RED

/obj/machinery/door/airlock/highsecurity/himeo_patrol/bridge/armoury
	name = "Armoury"

/obj/machinery/door/airlock/highsecurity/himeo_patrol/bridge/eva
	name = "Eva Preparation"
// Docks
/obj/machinery/door/airlock/himeo_patrol/docks
	name = "Docking arm"
	stripe_color = COLOR_DARK_BLUE_GRAY
/obj/machinery/door/airlock/himeo_patrol/docks/storage
	name = "Storage Room"

/obj/machinery/door/airlock/highsecurity/himeo_patrol/docks
	name = "Checkpoint"
	stripe_color = COLOR_DARK_BLUE_GRAY

// Medical
/obj/machinery/door/airlock/himeo_patrol/medical
	name = "Medbay"
	stripe_color = COLOR_GREEN

// Personnel
/obj/machinery/door/airlock/himeo_patrol/personnel
	name = "Personnel"
	stripe_color = COLOR_BROWN

/obj/machinery/door/airlock/himeo_patrol/personnel/quarters
	name = "Crew Quarters"

/obj/machinery/door/airlock/himeo_patrol/personnel/washroom
	name = "Washroom"

/obj/machinery/door/airlock/himeo_patrol/personnel/messhall
	name = "Messhall"

/obj/machinery/door/airlock/himeo_patrol/personnel/hydroponics
	name = "Hydroponics"

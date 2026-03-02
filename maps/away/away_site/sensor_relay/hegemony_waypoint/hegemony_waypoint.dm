/datum/map_template/ruin/away_site/hegemony_waypoint
	name = "hegemony waypoint"
	description = "This is a waypoint station manufactued en masse by the Izweski Hegemony, designed to guide vessels through potentially perilous routes, and to maintain a watchful eye for pirates. These are cramped facilities that tend only to be manned for days at a time as contracted technicians see to the maintenance of their systems in a short stay before leaving to the next installation. Many waypoints in Uueoa-Esa have fallen into disrepair since their initial constructions, prone to structural damage, electrical malfunctions, and infestations of dangerous pests. The Izweski Hegemony is known to offer financial compensation for third parties willing to return them to full operational capacity. The exact condition of this one is challenging to ascertain from sensor scans, but it is likely to be inactive."
	prefix = "away_site/sensor_relay/hegemony_waypoint/"
	suffix = "hegemony_waypoint.dmm"

	sectors = list(SECTOR_UUEOAESA)
	id = "hegemony_waypoint"

	unit_test_groups = list(1)

/singleton/submap_archetype/hegemony_waypoint
	map = "Hegemony Waypoint"
	descriptor = "A hegemony waypoint."

/obj/effect/overmap/visitable/ship/stationary/hegemony_waypoint
	name = "hegemony waypoint"
	class = "IHSS"
	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	icon_state = "waypoint"
	color = COLOR_CHESTNUT
	desc = "This is a waypoint station manufactued en masse by the Izweski Hegemony, designed to guide vessels through potentially perilous routes, and to maintain a watchful eye for pirates. These are cramped facilities that tend only to be manned for days at a time as contracted technicians see to the maintenance of their systems in a short stay before leaving to the next installation. Many waypoints in Uueoa-Esa have fallen into disrepair since their initial constructions, prone to structural damage, electrical malfunctions, and infestations of dangerous pests. The Izweski Hegemony is known to offer financial compensation for third parties willing to return them to full operational capacity. The exact condition of this one is challenging to ascertain from sensor scans, but it is likely to be inactive."
	comms_support = TRUE
	comms_name = "Hegemony Waypoint"
	volume = "48 meters length, 22 meters beam/width, 20 meters vertical height"
	designer = "Izweski Hegemony"
	sizeclass = "Waypoint Station"
	initial_generic_waypoints = list(
		"hegemony_waypoint_dock_n",
		"hegemony_waypoint_dock_e",
		"hegemony_waypoint_dock_w",
		"hegemony_waypoint_dock_s",
		"hegemony_waypoint_n_space",
		"hegemony_waypoint_e_space",
		"hegemony_waypoint_w_space",
		"hegemony_waypoint_s_space"
	)

/obj/effect/overmap/visitable/ship/stationary/hegemony_waypoint/New(loc, ...)
	designation = "Waypoint Station #[rand(100, 999)]"
	..()

// Areas
/area/hegemony_waypoint
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP
	requires_power = TRUE
	ambience = AMBIENCE_GENERIC
	base_turf = /turf/space
	icon_state = "green"

/area/hegemony_waypoint/monitoring
	name = "Hegemonic Waypoint Installation - Monitoring Station"

/area/hegemony_waypoint/hallway
	name = "Hegemonic Waypoint Installation - Central Hallway"

/area/hegemony_waypoint/kitchen
	name = "Hegemonic Waypoint Installation - Kitchen"

/area/hegemony_waypoint/custodial
	name = "Hegemonic Waypoint Installation - Laundry Chamber"

/area/hegemony_waypoint/washroom
	name = "Hegemonic Waypoint Installation - Washroom"

/area/hegemony_waypoint/hydroponics
	name = "Hegemonic Waypoint Installation - Hydroponics"

/area/hegemony_waypoint/eva
	name = "Hegemonic Waypoint Installation - Equipment Chamber"

/area/hegemony_waypoint/engineering
	name = "Hegemonic Waypoint Installation - Power Management Chamber"

/area/hegemony_waypoint/atmos
	name = "Hegemonic Waypoint Installation - Atmospherics Management Chamber"

/area/hegemony_waypoint/shrine
	name = "Hegemonic Waypoint Installation - Ritual Space"

/area/hegemony_waypoint/bunks
	name = "Hegemonic Waypoint Installation - Technicians Quarters"

/area/hegemony_waypoint/exterior
	name = "Hegemonic Waypoint Installation - Exterior"
	has_gravity = FALSE
	requires_power = FALSE
	icon_state = "exterior"

// Unique objects
/obj/item/paper/fluff/hegemony_waypoint_1
	name = "Technician's Entry 2465-07-23"
	desc = "A paper."
	info = "Entry 02-22, 2466<BR><BR>GENERAL ASSESSMENT: Installation is in a passable state, with full functionality. Hearing odd things in pressurised walls, might be pests. Check at later date?<BR><BR>ASSESSMENT OF FUNCTIONALITY: Sensor array fully functional, but notable drag on disk is acknowledged. Probably a mechanical fault with motors, or was just made wrong to begin with. Should be looked at, could cause the whole thing from moving at all.<BR><BR>ASSESSMENT OF LIVABILITY: 6-10 days max, you go mad for longer than that. Water is fine, food is fine.<BR><BR><BR><BR>- Technician Ka'ssitiri"
	language = LANGUAGE_UNATHI

/obj/item/paper/fluff/hegemony_waypoint_2
	name = "Technician's Entry 2465-11-03"
	desc = "A paper."
	info = "Entry 02-22, 2466<BR><BR>GENERAL ASSESSMENT: Pest issues, shitty sensor array itself is being a dick. All stopped at the turning mechanism, so we were getting a very good look at  1/3 of the space we should. Patched as well as I could?<BR><BR>ASSESSMENT OF FUNCTIONALITY: Array functional, but prone to problematic behaviour.<BR><BR>ASSESSMENT OF LIVABILITY: I can hear rats in the walls. Ancestors, I can tell by the little pit-pat-pit, these are rats for sure. Laying out traps, not much more can be done. Air is dry, raising a little.<BR><BR><BR><BR>- Junior Technician R'ssan"
	language = LANGUAGE_UNATHI

/obj/item/paper/fluff/hegemony_waypoint_3
	name = "Technician's Entry 2466-02-22"
	desc = "A paper."
	info = "Entry 02-22, 2466<BR><BR>GENERAL ASSESSMENT: Sk'akh help me, this is a shithole. Leak in water supply means humidity was too high, means mass corrosion, means faulty wiring, means lights are shuttering on and off. Water supply is also full of copper for the same reasons. This compounds on existing structural problems, this place was fucked from the start. Recommending a large team be sent as soon as possible, or else we may as well let this fall to derelict.<BR><BR>ASSESSMENT OF FUNCTIONALITY: I mean, it works. Sensor array itself is undamaged, though looks like someone patched it up somehow terrible - maybe they sent warriors rather than fishers again, and the technician did not know that a welding tool should be handled differently from a bludgeon. Do not expect it to stay functional for too long, wiring on external structure is looking weak. Probably needs replacement soon.<BR><BR>ASSESSMENT OF LIVABILITY: Food supply in freezer is good, but do not recommend trying to subsist here for more than two, maybe three days. Sk'akhs scales, you'll need a lot of Xuizi. The creaking gets to my ears.<BR><BR><BR><BR>- Technician Hassari<BR><BR><BR><BR>P.S. Heard the brass are paying aliens to handle this work. If you have a translator to read this, hello, alien. May want to get photographic proof of your fixes, yes?"
	language = LANGUAGE_UNATHI

/obj/item/paper/fluff/hegemony_waypoint_4
	name = "scrawled note"
	desc = "A paper."
	info = "Care for Unzi the Oztek for he is very stupid and idiotic but my senior techncician will not let me take him away from this dismal place. Leave food and water or take to a better place."

// Mapmanip stuff

// Kitchen
/obj/effect/map_effect/marker/mapmanip/submap/extract/hegemony_waypoint/kitchen
	name = "Hegemony Waypoint - Kitchen"

/obj/effect/map_effect/marker/mapmanip/submap/insert/hegemony_waypoint/kitchen
	name = "Hegemony Waypoint - Kitchen"

// Chapel
/obj/effect/map_effect/marker/mapmanip/submap/extract/hegemony_waypoint/chapel
	name = "Hegemony Waypoint - Chapel"

/obj/effect/map_effect/marker/mapmanip/submap/insert/hegemony_waypoint/chapel
	name = "Hegemony Waypoint - Chapel"

// Dorms
/obj/effect/map_effect/marker/mapmanip/submap/extract/hegemony_waypoint/dorms
	name = "Hegemony Waypoint - Technicians Quarters"

/obj/effect/map_effect/marker/mapmanip/submap/insert/hegemony_waypoint/dorms
	name = "Hegemony Waypoint - Technicians Quarters"

// Equipment Storage
/obj/effect/map_effect/marker/mapmanip/submap/extract/hegemony_waypoint/eva
	name = "Hegemony Waypoint - Equipment Storage"

/obj/effect/map_effect/marker/mapmanip/submap/insert/hegemony_waypoint/eva
	name = "Hegemony Waypoint - Equipment Storage"

// Atmospherics
/obj/effect/map_effect/marker/mapmanip/submap/extract/hegemony_waypoint/atmos
	name = "Hegemony Waypoint - Atmospherics"

/obj/effect/map_effect/marker/mapmanip/submap/insert/hegemony_waypoint/atmos
	name = "Hegemony Waypoint - Atmospherics"

// Hydroponics
/obj/effect/map_effect/marker/mapmanip/submap/extract/hegemony_waypoint/hydro
	name = "Hegemony Waypoint - Hydroponics"

/obj/effect/map_effect/marker/mapmanip/submap/insert/hegemony_waypoint/hydro
	name = "Hegemony Waypoint - Hydroponics"


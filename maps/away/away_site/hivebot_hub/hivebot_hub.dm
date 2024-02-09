/datum/map_template/ruin/away_site/hivebot_hub
	name = "derelict supply hub"
	description = "derelict supply hub"

	id = "hivebot_hub"
	suffixes = list("away_site/hivebot_hub/hivebot_hub.dmm")
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_NEW_ANKARA, SECTOR_BADLANDS, SECTOR_AEMAQ, ALL_COALITION_SECTORS)
	spawn_weight = 1
	spawn_cost = 1
	// template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

	unit_test_groups = list(1)

/singleton/submap_archetype/hivebot_hub
	map = "derelict supply hub"
	descriptor = "A derelict supply hub."

/obj/effect/overmap/visitable/sector/hivebot_hub
	name = "derelict supply hub"
	icon_state = "depot"
	color = "#a37f5e"
	static_vessel = TRUE
	generic_object = FALSE
	desc = "A small, independent supply hub and fuel depot, that apparently vanished off scopes some years ago. The installation appears to have been breached at several points, and scans indicate total depressurisation, with no clear lifesigns within. Most curiously, something at the centre of the installation is transmitting an extremely eclectic collection of signals; they vary in frequency, and alternate rapidly between binary and ternary. They do not seem to be encrypted using any familiar method, but they are nontheless incomprehensible to scopes. Despite an absence of lifesigns, there appear to be many small objects moving erratically inside."
	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	volume = "50 meters length, 67 meters beam/width, 11 meters vertical height"
	sizeclass = "Small supply hub and fuel depot"
	initial_generic_waypoints = list(
	"hivebot_nav1",
	"hivebot_nav2",
	"hivebot_nav3",
	"hivebot_nav4",
	"hivebot_nav5",
	"hivebot_nav6"
	)

// Areas
/area/hivebothub
	icon_state = "red"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/space
	area_flags = AREA_FLAG_RAD_SHIELDED
	has_gravity = FALSE

/area/hivebothub/portdocks
	name = "Independent Supply Hub - Port Docks"

/area/hivebothub/starboarddocks
	name = "Independent Supply Hub - Starboard Docks"

/area/hivebothub/starboarddocks
	name = "Independent Supply Hub - Starboard Docks"

/area/hivebothub/centralhall
	name = "Independent Supply Hub - Central Hallway"

/area/hivebothub/engi
	name = "Independent Supply Hub - Engineering"

/area/hivebothub/atmos
	name = "Independent Supply Hub - Atmospherics"

/area/hivebothub/dorm1
	name = "Independent Supply Hub - Dormitory #1"

/area/hivebothub/dorm2
	name = "Independent Supply Hub - Dormitory #2"

/area/hivebothub/kitchen
	name = "Independent Supply Hub - Kitchen"

/area/hivebothub/washroom
	name = "Independent Supply Hub - Washroom"

/area/hivebothub/secure
	name = "Independent Supply Hub - Secure Storage"

/area/hivebothub/bridge
	name = "Independent Supply Hub - Bridge"

/area/hivebothub/exterior
	name = "Independent Supply Hub - Exterior"
	icon_state = "exterior"

// Docks
/obj/effect/shuttle_landmark/hivebot_hub
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/hivebot_hub/nav1
	name = "Independent Supply Hub - Port Dock #1"
	landmark_tag = "hivebot_nav1"

/obj/effect/shuttle_landmark/hivebot_hub/nav2
	name = "Independent Supply Hub - Port Dock #2"
	landmark_tag = "hivebot_nav2"

/obj/effect/shuttle_landmark/hivebot_hub/nav3
	name = "Independent Supply Hub - Port Dock #3"
	landmark_tag = "hivebot_nav3"

/obj/effect/shuttle_landmark/hivebot_hub/nav4
	name = "Independent Supply Hub - Starboard Dock #1"
	landmark_tag = "hivebot_nav4"

/obj/effect/shuttle_landmark/hivebot_hub/nav5
	name = "Independent Supply Hub - Starboard Dock #2"
	landmark_tag = "hivebot_nav5"

/obj/effect/shuttle_landmark/hivebot_hub/nav6
	name = "Independent Supply Hub - Starboard Dock #3"
	landmark_tag = "hivebot_nav6"

// Unique Stuff
/mob/living/simple_animal/hostile/hivebotbeacon/weakened
	name = "dilapidated hivebot beacon"
	desc = "An odd and primitive looking machine. It emanates of strange and powerful energies. It bears no manufacturer markings of any kind. This one appears to have been badly damaged by something."
	health = 100

/obj/item/paper/hivebot_hub/diary1
	name = "Diary Entry 2463-03-01"
	desc = "A handwritten note."
	info = "\
		2463-03-01 <br>\
		<br>\
		<br>\
		We just had our last big haul. Enough phoron to satisfy half of Elyra, if we liked. <br>\
		It cost the skipper a lot, I know. Sold off whatever was left of our shuttle for it. <br>\
		No easy way off this tincan til it's sold. <br>\
		But if we can sell this at a decent price, maybe it'll be over? <br>\
		No more living on the edge of space. No more darkness, and silence, and worrying for the next buyer that'll find us. <br>\
		I could go home. See grass again. Trees. Never realise how much you miss them. <br>\
		Shit, this needs to work. <br>\
		~ H.E.B.
		"

/obj/item/paper/hivebot_hub/diary2
	name = "Diary Entry 2463-04-04"
	desc = "A handwritten note."
	info = "\
		2463-04-04 <br>\
		<br>\
		<br>\
		Starting to think. <br>\
		I hate this place. I never realised, it never came to mind, how much I did. <br>\
		It isn't going to get better, either. With everything happening home. News is rare, all depends on the relays. <br>\
		But sometimes, we get it. And it's some new horrible shit. Civil war, they're calling it, now. <br>\
		Feels like giving it credence. I guess it's really here. Glad I'm not there for it.<br>\
		That make me a coward? Dunno. <br>\
		~ H.E.B.
		"

/obj/item/paper/hivebot_hub/diary3
	name = "Diary Entry 2463-04-05"
	desc = "A handwritten note."
	info = "\
		2463-04-05 <br>\
		<br>\
		<br>\
		Got a call, skipper just said. A buyer. Some merchant vessel, not much better on their luck than we are. <br>\
		Price isn't great, but it's enough. No position to haggle. They'll be here in a couple of weeks. <br>\
		Not sure if she wants to see me, after all this time. Soon, I'll find out. It'll all be over. <br>\
		But, I think, after that? I'm moving. Or we're moving, maybe. <br>\
		Biesel is too close. Xanu, maybe? Somewhere else? <br>\
		I don't know. Glad this chapter of my life is over, at least. <br>\
		Odd thing, though. Merchants say they're hearing things. Scratching in the walls. <br>\
		Feels like something trying to get in. Or out. They say. <br>\
		Last thing we need is xenofauna right now. Keeping my shorty near. <br>\
		We can't lose that phoron. <br>\
		~ H.E.B.
		"

/datum/map_template/ruin/away_site/sfa_light_cruiser
	name = "SFA Light Cruiser"
	description = "big, green and very, very mean grrr."
	prefix = "maps/event/"
	suffixes = "sol_light_cruiser/sol_light_cruiser.dmm"
	spawn_weight = 0
	spawn_cost = 1
	id = "sfa_light_cruiser"

/singleton/submap_archetype/sfa_light_cruiser
	map = "sfa light cruiser"
	descriptor = "big, green and very, very mean grrr."

//ship stuff

/obj/effect/overmap/visitable/ship/sfa_light_cruiser
	name = "SFA Light Cruiser"
	class = "SFAV"
	desc = "The Yincheng-class is a typical Solarian light or “patrol” cruiser intended for anti-piracy and convoy escort operations across the \
	Middle and Outer Rings prior to the Collapse. Armed with only a limited number of energy turrets, the Yincheng draws most of its firepower from large missile batteries \
	located on the sides of its hull. Intended to operate for long distances without being resupplied, Yinchengs are often employed by admirals in the \
	Middle and Outer Ring to lead squadrons of smaller vessels such as destroyers, frigates, and corvettes. Never intended to openly contest enemy fleets in spaceborne combat \
	and only meant to stamp out pirates and other marauders. The Yincheng would become one of the most prominent ships in the arsenal of the warlords across the Wildlands \
	due to its prominent position in the Middle and Outer Rings. \
		\
	This particular light cruiser has received some substantial field modifications which make it pose only a fraction of the danger it usually would. Most significant of which is the removal of its energy \
	and missile emplacements, replaced with large coilguns."
	icon_state = "ship_green"
	moving_state = "ship_green_moving"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 250000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_LARGE

	initial_generic_waypoints = list(
		"nav_sfa_light_cruiser_1",
		"nav_sfa_light_cruiser_2",
		"nav_sfa_light_cruiser_3",
		"nav_sfa_light_cruiser_4",
		"nav_sfa_light_cruiser_5",
		"nav_sfa_light_cruiser_6",
		"nav_sfa_light_cruiser_7",
		"nav_sfa_light_cruiser_8",
		"nav_sfa_light_cruiser_9",
		"nav_sfa_light_cruiser_10",
		"nav_sfa_light_cruiser_11"
	)

/obj/effect/overmap/visitable/ship/sfa_light_cruiser/New()
	designation = "[pick("A Frank Exchange of Views", "Ace of Spades", "Don't Make Me Come Over There", "As Advertised", "Maniacal Laughter", "Innocent Until Proven", "Easy Does It", "Contrarian", "Final Word", "Shit Happens", "Determinist", "So Much For Subtlety", "Killing Time", "Reasonable Excuse", "Uninvited Guest", "Appeal To Reason")]"
	..()

/obj/effect/shuttle_landmark/sfa_light_cruiser/nav1
	name = "SFA Cruiser - Aft Thrusters Exterior"
	landmark_tag = "nav_sfa_light_cruiser_1"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/sfa_light_cruiser/nav2
	name = "SFA Cruiser - Starboard Engineering Exterior"
	landmark_tag = "nav_sfa_light_cruiser_2"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/sfa_light_cruiser/nav3
	name = "SFA Cruiser - Port Engineering Exterior"
	landmark_tag = "nav_sfa_light_cruiser_3"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/sfa_light_cruiser/nav4
	name = "SFA Cruiser - Starboard Aft Hallway Exterior"
	landmark_tag = "nav_sfa_light_cruiser_4"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/sfa_light_cruiser/nav5
	name = "SFA Cruiser - Port Intrepid Docking"
	landmark_tag = "nav_sfa_light_cruiser_5"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/sfa_light_cruiser/nav6
	name = "SFA Light Cruiser Gunnery Deck - Starboard Central Hall Exterior"
	landmark_tag = "nav_sfa_light_cruiser_6"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/sfa_light_cruiser/nav7
	name = "SFA Light Cruiser Gunnery Deck - Port Central Hall Exterior"
	landmark_tag = "nav_sfa_light_cruiserp_7"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/sfa_light_cruiser/nav8
	name = "SFA Light Cruiser Gunnery Deck - Starboard Fore Hall Exterior"
	landmark_tag = "nav_sfa_light_cruiser_8"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/sfa_light_cruiser/nav9
	name = "SFA Light Cruiser Gunnery Deck - Port Fore Hall Exterior"
	landmark_tag = "nav_sfa_light_cruiser_9"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/sfa_light_cruiser/nav10
	name = "SFA Light Cruiser Gunnery Deck - Starboard Coilgun"
	landmark_tag = "nav_sfa_light_cruiser_10"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/sfa_light_cruiser/nav11
	name = "SFA Light Cruiser Gunnery Deck - Port Coilgun"
	landmark_tag = "nav_sfa_light_cruiser_11"
	base_turf = /turf/space/dynamic
	base_area = /area/space

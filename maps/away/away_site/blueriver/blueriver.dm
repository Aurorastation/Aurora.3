/datum/map_template/ruin/away_site/blueriver
	name = "Bluespace River"
	id = "blueriver"
	spawn_cost = 1
	spawn_weight = 1
	description = "An arctic planet and an alien underground surface."
	suffixes = list("away_site/blueriver/blueriver-1.dmm","away_site/blueriver/blueriver-2.dmm")
	generate_mining_by_z = 2
	sectors = list(SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, ALL_COALITION_SECTORS)
	sectors_blacklist = list(SECTOR_BURZSIA, SECTOR_HANEUNIM, SECTOR_TAU_CETI, SECTOR_SRANDMARR) //it's a whole ass planet, shouldn't have it in predefined sectors

	unit_test_groups = list(1)
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/blueriver_ship)

/singleton/submap_archetype/blueriver
	map = "bluespace river"
	descriptor = "An arctic planet and an alien underground surface."

/obj/effect/overmap/visitable/sector/blueriver
	name = "arctic planetoid"
	desc = "Sensor array detects an arctic planet with a small vessel on the planet's surface. Scans further indicate strange energy emissions from below the planet's surface."
	in_space = FALSE
	icon_state = "globe"
	initial_generic_waypoints = list(
		"nav_blueriv_1",
		"nav_blueriv_2",
		"nav_blueriv_3",
		"nav_blueriv_4"
	)
	initial_restricted_waypoints = list(
		"EERV Eureka" = list("nav_start_blueriver_ship")
	)

/obj/effect/overmap/visitable/sector/blueriver/New(nloc, max_x, max_y)
	name = "[generate_planet_name()], \a [name]"
	..()

/obj/effect/shuttle_landmark/nav_blueriv/nav1
	name = "Arctic Planet Landing Point #1"
	landmark_tag = "nav_blueriv_1"
	base_area = /area/bluespaceriver/ground

/obj/effect/shuttle_landmark/nav_blueriv/nav2
	name = "Arctic Planet Landing Point #2"
	landmark_tag = "nav_blueriv_2"
	base_area = /area/bluespaceriver/ground

/obj/effect/shuttle_landmark/nav_blueriv/nav3
	name = "Arctic Planet Landing Point #3"
	landmark_tag = "nav_blueriv_3"
	base_area = /area/bluespaceriver/ground

/obj/effect/shuttle_landmark/nav_blueriv/nav4
	name = "Arctic Planet Navpoint #4"
	landmark_tag = "nav_blueriv_4"
	base_area = /area/bluespaceriver/ground

/turf/simulated/floor/away/blueriver/alienfloor
	name = "glowing floor"
	desc = "The floor glows without any apparent reason."
	icon = 'maps/away/away_site/blueriver/riverturfs.dmi'
	icon_state = "floor"
	temperature = 250

/turf/simulated/floor/away/blueriver/alienfloor/Initialize()
	.=..()

	set_light(0.7, 1, 5, l_color = "#0066ff")

/turf/unsimulated/wall/away/blueriver/livingwall
	name = "strange wall"
	desc = "A strange wall. Its surface seems to be constantly moving, as if it were breathing."
	icon = 'maps/away/away_site/blueriver/riverturfs.dmi'
	icon_state = "evilwall_1"
	opacity = 1
	density = TRUE
	temperature = 250

/turf/unsimulated/wall/away/blueriver/livingwall/Initialize()
	.=..()

	if(prob(80))
		icon_state = "evilwall_[rand(1,8)]"

/turf/unsimulated/wall/supermatter/no_spread/blueriver
	name = "blue liquid"
	desc = "The viscous liquid glows and moves as if it were alive."
	icon = 'maps/away/away_site/blueriver/blueriver.dmi'
	icon_state = "bluespacecrystal1"
	opacity = 0
	dynamic_lighting = 0

/turf/unsimulated/wall/supermatter/no_spread/blueriver/Initialize()
	. = ..()
	icon_state = "bluespacecrystal[rand(1,3)]"
	set_light(0.7, 1, 5, l_color = "#0066ff")

/obj/structure/deity
	name = "crystal altar"
	icon = 'icons/obj/cult.dmi'
	icon_state = "tomealtar"
	density = TRUE
	anchored = TRUE

/obj/structure/deity/attackby(obj/item/attacking_item, mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src)
	user.visible_message(
		"<span class='danger'>[user] hits \the [src] with \the [attacking_item]!</span>",
		"<span class='danger'>You hit \the [src] with \the [attacking_item]!</span>",
		"<span class='danger'>You hear something breaking!</span>"
		)

/obj/item/paper/blueriver/expedition_log_1
	name = "expedition log #1"
	info = "Well, it only took three weeks... but we finally found something worth investigating! An energy signature, just on or under the planet's surface. It's bizarre, similar to a bluespace signature, but... not. I'll need to get down there to really get a reading on it, but this could be the kind of discovery that makes a career. We've identified a landing site, so our pilot is setting the ship down there in the next couple of hours. it'll take some more time after that to set up a base camp and such."

/obj/item/paper/blueriver/expedition_log_2
	name = "expedition log #2"
	info = "We've landed, and aside from the permafrost, there's not a lot to mention on this rock. The readings are strongest in the middle of an open field near the ship, but there's nothing there, meaning we really only have one choice. Digging down. One of the others thinks theres a good chance that it's underground, so we might as well see if they're onto something. We don't have any other decent plans, and we need this find. Fortunate we brought the larger scale excavation equipment."

/obj/item/paper/blueriver/expedition_log_3
	name = "expedition log #3"
	info = "Well, it didn't take the three days I was betting on, so i'm out twenty bucks, but we managed to punch through into a cave of some sort with the drilling equipment. We're lowering a ladder down now and sending one of the guards down to check that there's no greimorians in there or anything. Once they report back, we'll move the whole basecamp down there. Coincidentally they just did as I finished this paragraph, so I'll continue this shortly! We've moved down into the cave now, and what we've found is astounding! It looks a LOT like a lake or river of bluespace, which doesn't make sense does it? I took some scans, but couldn't pick anything up aside from radiation spikes from the pool. I also lowered a swab into the pool to take a sample, but when I touched the swab to the surface of the... fluid? the Swab just... ceased to exist. Yes, that's the best way I can describe it. It just stopped existing in my hand. We figure it's best we DON'T touch it for now. one of our help has started moving supplies down into the cave to build a bridge of sorts though across the pool. We spotted some sort of structure on the far side, and the bridge is the only way to get to it, so now we wait. I don't want to think of what might happen if a person touches this blue river, so we're taking it nice and slow."

/obj/item/paper/blueriver/expedition_log_4
	name = "expedition log #4"
	info = "We've finished the bridge and began our initial investigation into the site. Thus far, we're finding structures clearly made by a sapient species, one that from all indications was relatively advanced, but no signs of what actually happened to them. There's clear signs of habitation, but no signs of what caused abandonment. Due to this I'm beginning to suspect that what we've encountered is an area rich in bluespace phenomena like the Romanovich Cloud in Tau Ceti. I've seen some interesting research papers come out of there regarding xenoarchaeological finds. That aside, we're setting up camp in the ruins tonight so that we can continue studying as long as possible before our scheduled departure for refueling, but I feel confident we'll have enough to secure funds for the forseeable future at least! This might just give us the edge against NanoTrasen."

/obj/item/paper/blueriver/expedition_log_5
	name = "expedition log #5"
	info = "One of the researchers and a guard disappeared last night. We've started looking for them, figuring maybe they got trapped somewhere in the ruins, maybe a booby trap or something that was still functioning, but we haven't seen any sign of them. Their equipment, both of their equipment, is still in the ship, and there's no signs of anything grabbing them in the night, they're just... Gone. The implication here is not lost on me. My colleagues seem to be reaching the same conclusion. If we don't find them, well... Tomorrow morning we have to head back into space to go resupply and submit what we've found so far, but when we come back we'll have more than enough manpower to secure the area and dig into this place, I hope."

//Shuttle
/obj/effect/overmap/visitable/ship/landable/blueriver_ship
	name = "Einstein Shuttle"
	desc = "The Observer-class shuttle is an Einstein Engines design used primarily for deep-space exploration and reconnaisance missions. It is designed to be landed on a planet for months at a time for extended surveying and research."
	class = "EERV"
	designation = "Eureka"
	designer = "Einstein Engines"
	sizeclass = "Observer-class research shuttle"
	shiptype = "Exoplanetary survey and research vessel."
	shuttle = "EERV Eureka"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#18e9b5", "#6aa9dd")
	max_speed = 1/(3 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 3000 //Hard to move
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/blueriver_ship
	name = "shuttle control console"
	shuttle_tag = "EERV Eureka"

/datum/shuttle/autodock/overmap/blueriver_ship
	name = "EERV Eureka"
	move_time = 90
	shuttle_area = list(/area/shuttle/blueriver_ship)
	current_location = "nav_start_blueriver_ship"
	landmark_transition = "nav_transit_blueriver_ship"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_start_blueriver_ship"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/blueriver_ship/start
	name = "Arctic Planetoid - EERV Eureka Landing Zone"
	landmark_tag = "nav_start_blueriver_ship"
	base_turf = /turf/simulated/floor/exoplanet/snow
	base_area = /area/bluespaceriver/ground
	docking_controller = "airlock_blueriver_ship"
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/blueriver_ship/transit
	name = "In transit"
	landmark_tag = "nav_transit_blueriver_ship"
	base_turf = /turf/space/transit/north

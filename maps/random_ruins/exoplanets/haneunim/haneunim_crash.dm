/datum/map_template/ruin/exoplanet/haneunim_crash
	name = "Crashed Shuttle"
	id = "haneunim_crash"
	description = "A weapons smuggler's crashed shuttle."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("haneunim/haneunim_crash.dmm")
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/haneunim_crash)

/area/shuttle/haneunim_crash
	name = "Crashed Shuttle"
	requires_power = TRUE

/obj/effect/overmap/visitable/ship/landable/haneunim_crash
	name = "Crashed League Shuttle"
	desc = "The Ferryman-class cargo shuttle is an unsung pillar of Solarian military might, a small but irreplacable part of the Navy's vast logistic system now often seen in civilian hands. This one appears to be displaying heavy damage."
	class = "ICV" //man thought he was hiding :skull:
	designation = "Merry Wanderer"
	designer = "Hephaestus Industries, Sol Alliance Navy"
	sizeclass = "Minnow-class transport shuttle"
	shiptype = "Cargo transport and supply operations."
	shuttle = "Crashed League Shuttle"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#ad3d3d", "#d0d1d0")
	max_speed = 1/(3 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 3000 //Hard to move
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/haneunim_crash
	name = "shuttle control console"
	shuttle_tag = "Crashed League Shuttle"

/datum/shuttle/autodock/overmap/haneunim_crash
	name = "Crashed League Shuttle"
	move_time = 90
	shuttle_area = list(/area/shuttle/haneunim_crash)
	current_location = "nav_start_haneunim_crash"
	landmark_transition = "nav_transit_haneunim_crash"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_start_haneunim_crash"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/haneunim_crash/start
	name = "Haneunim Asteroid - Shuttle Crash Site"
	landmark_tag = "nav_start_haneunim_crash"
	base_turf = /turf/simulated/floor/exoplanet/ice/dark
	base_area = /area/exoplanet/barren/asteroid
	docking_controller = "airlock_haneunim_crash"
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/haneunim_crash/transit
	name = "In transit"
	landmark_tag = "nav_transit_haneunim_crash"
	base_turf = /turf/space/transit/north

/obj/effect/landmark/corpse/league_smuggler
	name = "League Smuggler"
	corpseuniform = /obj/item/clothing/under/rank/sol
	corpsesuit = /obj/item/clothing/suit/space/void/sol/league
	corpseshoes = /obj/item/clothing/shoes/jackboots
	corpseid = FALSE
	species = SPECIES_HUMAN

/obj/effect/landmark/corpse/league_smuggler/do_extra_customization(mob/living/carbon/human/M)
	M.change_skin_tone(rand(10, 200))
	M.adjustBruteLoss(rand(200,400))
	M.dir = pick(GLOB.cardinal)

/obj/item/paper/fluff/haneunim_crash
	name = "scrawled message"
	info = "They fucking sold us out. I told the LT not to make a deal with those 5-Cheung fucks, but did she listen? No, course not. Bastards are barely better than the corps. Fucking KASF were on us before we had time to blink. Blew out half the engines, was barely able to get us down here, but\
	it'd take a miracle to get back up again. Either gonna wait for the Konyangers to come arrest us, or wait to starve. If anyone finds this, I didn't want to be a smuggler. Just saw what the corps were doing to Sol, figured I had to take a stand. Fat lot of good that did. Whoever's reading this, take my body back to Mars. Bury me at home, if there's anything left of it."


/obj/item/paper/fluff/haneunim_crash/Initialize()
	. = ..()
	var/languagetext = "\[lang=1\]"
	languagetext += "[info]\[/lang\]"
	info = parsepencode(languagetext)
	icon_state = "scrap_bloodied"

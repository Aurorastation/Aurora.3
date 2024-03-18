/datum/map_template/ruin/away_site/konyang_wreck
	name = "Konyang Wrecked Cargo Ship"
	id = "konyang_wreck"
	description = "Orion Express cargo ship, home to an unfortunate outbreak of infected IPCs."
	suffixes = list("ships/konyang_wreck/konyang_wreck.dmm")
	spawn_cost = 1
	spawn_weight = 1
	sectors = list(SECTOR_HANEUNIM)

	unit_test_groups = list(3)

/obj/effect/overmap/visitable/ship/konyang_wreck
	name = "Konyang Wreck"
	desc = "An Orion Express Packhorse-class freighter. This one appears to be drifting. Sensors register no life signs aboard."
	class = "OEV"
	icon_state = "freighter_large"
	moving_state = "freighter_large_moving"
	colors = list("#c3c7eb", "#a0a8ec")
	designer = "Orion Express"
	volume = "41 meters length, 36 meters beam/width, 11 meters vertical height"
	sizeclass = "Packhorse-class cargo freighter"
	shiptype = "Long-range cargo transport"
	vessel_mass = 5000
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_size = SHIP_SIZE_SMALL
	initial_generic_waypoints = list(
		"konyang_wreck_nav1",
		"konyang_wreck_nav2",
		"konyang_wreck_nav3",
		"konyang_wreck_nav4",
		"konyang_wreck_dock1",
		"konyang_wreck_dock2",
		"konyang_wreck_dock3",
		"konyang_wreck_dock4"
	)
	fore_dir = SOUTH

/obj/effect/overmap/visitable/ship/konyang_wreck/New()
	. = ..()
	designation = "[pick("Hauler", "Special Delivery", "50% Off Shipping", "Courier", "Telegram")]"

/obj/effect/shuttle_landmark/konyang_wreck
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/konyang_wreck/nav1
	name = "Orion Express Cargo Vessel - Fore"
	landmark_tag = "konyang_wreck_nav1"

/obj/effect/shuttle_landmark/konyang_wreck/nav2
	name = "Orion Express Cargo Vessel - Aft"
	landmark_tag = "konyang_wreck_nav2"

/obj/effect/shuttle_landmark/konyang_wreck/nav3
	name = "Orion Express Cargo Vessel - Port"
	landmark_tag = "konyang_wreck_nav3"

/obj/effect/shuttle_landmark/konyang_wreck/nav4
	name = "Orion Express Cargo Vessel - Starboard"
	landmark_tag = "konyang_wreck_nav4"

/obj/effect/shuttle_landmark/konyang_wreck/dock1
	name = "Orion Express Cargo Vessel - Port Dock #1"
	landmark_tag = "konyang_wreck_dock1"

/obj/effect/shuttle_landmark/konyang_wreck/dock2
	name = "Orion Express Cargo Vessel - Port Dock #2"
	landmark_tag = "konyang_wreck_dock2"

/obj/effect/shuttle_landmark/konyang_wreck/dock3
	name = "Orion Express Cargo Vessel - Starboard Dock #1"
	landmark_tag = "konyang_wreck_dock3"

/obj/effect/shuttle_landmark/konyang_wreck/dock4
	name = "Orion Express Cargo Vessel - Starboard Dock #2"
	landmark_tag = "konyang_wreck_dock4"

//Corpses & Fluff Items
/obj/effect/landmark/corpse/orionexpress
	name = "Orion Express Worker"
	corpseuniform = /obj/item/clothing/under/rank/hangar_technician/orion/ship
	corpseshoes = /obj/item/clothing/shoes/workboots
	corpsehelmet = /obj/item/clothing/head/hardhat
	corpseglasses = /obj/item/clothing/glasses/safety/goggles
	corpseid = TRUE
	corpseidjob = "Cargo Crew (Orion)"
	corpseidicon = "orion_card"
	corpsepocket1 = /obj/item/storage/wallet/random
	species = SPECIES_HUMAN

/obj/effect/landmark/corpse/orionexpress/do_extra_customization(mob/living/carbon/human/M)
	M.adjustBruteLoss(rand(200,400))
	M.change_skin_tone(rand(0, 100))
	M.dir = pick(GLOB.cardinal)

/obj/effect/landmark/corpse/orionexpress/captain
	name = "Orion Express Captain"
	corpseuniform = /obj/item/clothing/under/rank/operations_manager/orion_ship
	corpsehelmet = /obj/item/clothing/head/beret/corporate/orion
	corpseglasses = null
	corpseidjob = "Captain (Orion)"

/obj/item/paper/fluff/konyang_wreck_manifest
	name = "\improper Cargo Manifest"
	desc = "An Orion Express cargo manifest."
	info = "Cargo Manifest<br>\
	POD 1: 4x crates plasteel, Hephaestus, Burzsia -> Konyang.<br>\
	2x crates replacement shell frame parts, Einstein, Konyang -> Xanu.<br>\
	2x crates Chem-Master cartridges, Zeng-Hu, Konyang -> Xanu<br>\
	POD 2: 24x Baseline IPC frames & storage units, Hephaestus, Konyang -> Burzsia<br>\
	4x crates IPC recharging units, Hephaestus, Konyang -> Burzsia<br>\
	POD 3: 18x Getmore vending machines, Getmore, Xanu -> Konyang<br>\
	12x Idris Re-Fresh vending machines, Idris, Xanu -> Konyang<br>\
	5x Zo'ra Soda vending machines, Zo'ra Hive, Tau Ceti -> Tret<br>\
	1x BODA vending machine, ???, destination unknown.<br>\
	6x Hot Drinks vending machines, Getmore, Tau Ceti -> Konyang<br>\
	6x cigarette vending machines, Xanu -> Konyang<br>\
	POD 4: 18x IPC storage units, Einstein, Konyang -> Tau Ceti<br>\
	4x crates industrial-grade microbatteries, Einstein, Konyang -> Tau Ceti<br>\
	POD 5: 5x crates borosilicate glass, Hephaestus, Tret -> Konyang<br>\
	2x crates atmospheric refinement apparatus, Einstein, Konyang -> Callistio<br>\
	POD 6: 4x mining drills, Hephaestus, Konyang -> Burzsia<br>\
	18x ore crates, Hephaestus, Konyang -> Burzsia<br>\
	3x crates mining drill parts, Hephaestus, Konyang -> Burzsia<br>\
	POD 7: 2x crates exosuit recharge points, Hephaestus, Konyang -> Burzsia<br>\
	2x crates unrefined plasteel, Hephaestus, Burzsia -> Konyang<br>\
	1x crates body scanners, Zeng-Hu, Konyang -> Mictlan<br>\
	3x crates empty He3 canisters, Einstein, Konyang -> Callisto<br>\
	POD 8: 1x crates sleepers, Zeng-Hu, Konyang -> Mictlan<br>\
	2x crates ChemMaster 3000, Zeng-Hu, Konyang -> Tau Ceti<br>\
	1x crates anomaly isolation chambers, Zeng-Hu, Konyang -> Assunzione<br>\
	12x crates medical supplies, Zeng-Hu, Konyang -> Mictlan<br>\
	6x IV stands, Zeng-Hu, Konyang -> Mictlan<br>\
	6x crates O- blood, Zeng-Hu, Konyang -> Mictlan."

/obj/item/paper/fluff/konyang_wreck_fax
	name = "unfinished fax"
	desc = "What looks like a half-finished report."
	info = "Are you sure that the synthetics we just picked up from Hephaestus are all offline? One of my crew keeps saying he's hearing banging and scraping\
	from Pod #2. Probably just his imagination getting the best of him, we just picked him up from Xanu and the kid' never been on a spaceship before. Still, figured it'd be\
	good to check. If any of them are active, could use the extra hands. In all seriousness, I"

/obj/item/paper/fluff/konyang_wreck_goodbye
	name = "bloodstained note"
	desc = "A scrap of paper, covered in blood."
	info = "I don't know how, but the IPCs we were shipping to Burzsia woke up. They killed the captain right in front of me, just beat him until you couldn't see anything but red.<br>\
	It's a virus or something, spread to our IPCs. I can hear them out there, they're trying to get to the AI. Going to try and shut it off, before they can... do whatever this is to it. Probably not going to make it past the turrets, though.<br>\
	Whoever's reading this, you have to destroy those things. If this virus reaches a planet, reaches anywhere with enough IPCs... it'd be a slaughter. I've shut off the power, and now I'm going for the AI. Whatever's happened to them, they don't seem smart enough to use tools, or to fix it - I hope.<br>\
	If someone else is reading this, better luck than me, I guess."

/obj/item/paper/fluff/konyang_wreck_warning
	name = "WARNING: QUARANTINE VIOLATION"
	desc = "An official-looking fax, seemingly untouched."
	info = "WARNING: ORION VESSEL<br>\
	A SECTOR-WIDE QUARANTINE OF HANEUNIM IS CURRENTLY IN EFFECT.<br>\
	YOU ARE TO RETURN TO ORBIT OF KONYANG IMMEDIATELY.<br>\
	IF YOUR WARP SIGNATURE IS DETECTED LEAVING, AEROSPACE FORCES WILL BE AUTHORISED TO SHOOT YOUR VESSEL DOWN<br>\
	DIVERT COURSE TO KONYANG WHERE AEROSPACE FORCES WILL SEARCH YOUR VESSEL FOR SIGNS OF CONTAMINATION."

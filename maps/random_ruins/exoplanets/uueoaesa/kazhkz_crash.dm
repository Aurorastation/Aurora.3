/datum/map_template/ruin/exoplanet/kazhkz_crash
	name = "Crashed Kazhkz Shuttle"
	id = "kazhkz_crash"
	description = "A crashed shuttle from the days of the Contact War."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "uueoaesa/"
	suffix = "kazhkz_crash.dmm"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/kazhkz_crash)

	unit_test_groups = list(3)

/area/shuttle/kazhkz_crash
	name = "Crashed Shuttle"
	requires_power = TRUE

/obj/effect/overmap/visitable/ship/landable/kazhkz_crash
	name = "Crashed Kazhkz Shuttle"
	desc = "The NanoTrasen Bounty-class shuttle was one of the megacorporation's first spacecraft designs, intended for long-term scouting and prospecting missions in the Romanovich Cloud. Though superceded by more modern designs, the Bounty-class remained in common use until the late 2450s. This one appears to be showing signs of heavy damage."
	class = "NTCV" //NanoTrasen Corporate Vessel
	designation = "Victory"
	designer = "NanoTrasen"
	sizeclass = "Bounty-class prospecting shuttle"
	shiptype = "Long-term, short-range prospecting and scouting operations"
	shuttle = "Crashed Kazhkz Shuttle"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#d65e1e", "#1f731f") //Kazhkz and Han'san colors
	max_speed = 1/(3 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 3000 //Hard to move
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/kazhkz_crash
	name = "shuttle control console"
	shuttle_tag = "Crashed Kazhkz Shuttle"

/datum/shuttle/autodock/overmap/kazhkz_crash
	name = "Crashed Kazhkz Shuttle"
	move_time = 90
	shuttle_area = list(/area/shuttle/kazhkz_crash)
	current_location = "nav_start_kazhkz_crash"
	landmark_transition = "nav_transit_kazhkz_crash"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_start_kazhkz_crash"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/kazhkz_crash
	name = "Shuttle Crash Site"
	landmark_tag = "nav_start_kazhkz_crash"
	docking_controller = "airlock_kazhkz_crash"
	landmark_flags = SLANDMARK_FLAG_AUTOSET //Can spawn on multiple planet types
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/kazhkz_crash/transit
	name = "In transit"
	landmark_tag = "nav_transit_kazhkz_crash"
	base_turf = /turf/space/transit/north

/obj/effect/landmark/corpse/kazhkz_crash
	name = "Dead Kazhkz Warrior"
	corpseuniform = /obj/item/clothing/under/unathi/hiskyn
	corpseshoes = /obj/item/clothing/shoes/magboots
	corpsesuit = /obj/item/clothing/suit/space/unathi_ruin
	corpsehelmet = /obj/item/clothing/head/helmet/space/unathi_ruin
	corpseback = /obj/item/tank/oxygen/brown
	corpsebelt = /obj/item/gun/projectile/pistol/spitter
	corpseid = FALSE
	species = SPECIES_UNATHI

/obj/effect/landmark/corpse/kazhkz_crash/do_extra_customization(mob/living/carbon/human/M)
	M.ChangeToHusk()
	M.adjustBruteLoss(rand(200,400))
	M.dir = pick(GLOB.cardinals)

/obj/effect/landmark/corpse/kazhkz_crash/captain
	corpsesuit = /obj/item/clothing/suit/space/void/mining
	corpsehelmet = /obj/item/clothing/head/helmet/space/void/mining

/obj/effect/landmark/corpse/kazhkz_crash/captain/do_extra_customization(mob/living/carbon/human/M)
	. = ..()
	if(M.wear_suit && isclothing(M.wear_suit))
		var/obj/item/clothing/suit = M.wear_suit
		suit.refit_contained(BODYTYPE_UNATHI)
	if(M.head && isclothing(M.head))
		var/obj/item/clothing/head = M.head
		head.refit_contained(BODYTYPE_UNATHI)

/obj/item/paper/fluff/kazhkz_crash_note
	name = "scrawled message"
	info = "The plan has failed. Izweski defences have shot down King Seryo's vessel, and the survivors of the assault have fled. I was able to distract the Hegemony's fighters with our own vessel for a time, but our engines are too damaged. I tried to bring us down on the surface here, in the hopes that the others would find us, but I fear it is too late. Most of my warriors perished, either in the battle or from the crash, and the others do not have long. Lord Kasz has guided the others in a retreat, and I pray to whatever spirits know this cursed place that they are safe and far from here. I will not join my ancestors in the earth of our homeland, and my bones may never be honored - but should my spirit rest here, may I guide my clan and that of my King to safety, and may I visit a terrible curse upon the tyrant S'kresti Izweski.<br><i>R'tiza Han'san<br>09/06/2438</i>"
	language = LANGUAGE_AZAZIBA

/obj/item/paper/fluff/kazhkz_crash_plans
	name = "assault plans"
	info = "\
		To R'tiza of the Clan Han'san, my faithful battle-leader,<br>\
		The assault on the Izweski stronghold is prepared. Every warrior sworn to the Kazhkz Kingdom is mobilized, and the last of our shuttles are prepared for launch.<br>\
		Tomorrow, as the Burning Mother rises, our vessels will depart. I weep for our land and people as the Izweski conquerors approach, but it has become clear that the free nations of Moghes have waited too long to strike against the tyrants of Skalamar.<br>\
		You will command a shuttle of your own - smaller than most of those we possess, but nimbler, wth seven of your best warriors. It has been renamed the Victory, in honor of what we hope to find this day. When we reach Skalamar, your men will be tasked with securing a landing position near the Izweski keep, where the Hegemon's personal shuttle is reportedly docked.<br>\
		Once you have secured the position, the remainder of our forces will move in and seize the Izweski stronghold. This war will end in one stroke, as the Hegemony will either capitulate or crumble into infighting. It is a deadly mission I entrust you with, yet your clan's lord tells me that there is no officer of his blood who would be better-suited.<br>\
		Strike fear into their hearts and glory into your own, Uezsla Han'san.<br>\
		<i>By the hand and will of King Seryo Kazhkz.</i>"
	language = LANGUAGE_AZAZIBA

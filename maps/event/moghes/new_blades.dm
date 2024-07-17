/area/new_blades
	name = "The Wasteland"
	icon_state = "green"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/desert
	ambience = AMBIENCE_DESERT
	area_blurb = "Heat, sand, and dust surround you. The air smells of burning rubber as the wind stirs spirals of dust about your feet. The heat is overpowering."
	is_outside = OUTSIDE_YES
	var/lighting = TRUE

/area/new_blades/Initialize()
	. = ..()
	if(lighting)
		for(var/turf/T in src)
			T.set_light(4, 5, COLOR_WHITE)

/area/landing_pad
	name = "Landing Pad"
	icon_state = "blue"
	ambience = AMBIENCE_DESERT
	is_outside = OUTSIDE_YES

/area/new_blades/underground
	name = "Zazalai Caverns"
	icon_state = "bluenew"
	lighting = FALSE
	base_turf = /turf/simulated/floor/exoplanet/barren/warm
	ambience = AMBIENCE_RUINS
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_HIDE_FROM_HOLOMAP
	area_blurb = "The caverns are dark and quiet, a merciful reprise from the Wasteland outside."
	is_outside = OUTSIDE_NO

// EVENT FIVE AREAS (Mudki)
/area/new_blades/mudki
	name = "Mudki"
	icon_state = "blue"

/area/new_blades/mudki/road
	name = "Mudki Streets"
	icon_state = "green"
	holomap_color = HOLOMAP_PATH

/area/new_blades/mudki/interiors
	name = "Mudki Interiors"
	lighting = FALSE
	area_flags = AREA_FLAG_RAD_SHIELDED
	area_blurb = "Interiors Placeholder"
	is_outside = OUTSIDE_NO

/area/new_blades/mudki/interiors/alley
	name = "Mudki Alleys"
	icon_state = "green"
	area_blurb = "Alleys Placeholder"

/area/new_blades/mudki/interiors/spaceport
	name = "Mudki Spaceport"
	area_blurb "Spaceport Interiors Placeholder"

/area/new_blades/mudki/interiors/north_housing
	name = "Northern Mudki Housing"
	area_blurb = "Housing Placeholder"
	requires_power = TRUE
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/new_blades/mudki/interiors/south_housing
	name = "Southern Mudki Housing"
	area_blurb = "Housing Placeholder"
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/new_blades/mudki/interiors/restaurant
	name = "Restaurant"
	area_blurb = "Restaurant Placeholder"
	// requires_power = TRUE
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

/area/new_blades/mudki/interiors/hospital
	name = "Hospital"
	area_blurb = "Hospital Placeholder"
	requires_power = TRUE
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL

/area/new_blades/mudki/interiors/guildhouse
	name = "Merchant's Guildhouse"
	area_blurb = "Guildhouse Placeholder"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

/area/new_blades/mudki/interiors/temple
	name = "Temple of Sk'akh"
	area_blurb = "Temple Placeholder"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

/area/new_blades/mudki/interiors/inn
	name = "Inn"
	area_blurb = "Inn Placeholder"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

/area/new_blades/mudki/interiors/bar
	name = "Bar"
	area_blurb = "Bar Placeholder"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

/area/new_blades/mudki/interiors/library
	name = "Library"
	area_blurb = "Library Placeholder"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

/area/new_blades/mudki/interiors/pawn
	name = "Pawn Shop"
	area_blurb = "Pawn Shop Placeholder"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

/area/new_blades/mudki/interiors/convenience
	name = "Convenience Store"
	area_blurb = "Convenience Store Placeholder"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

/area/new_blades/mudki/interiors/charging_station
	name = "Vehicle Charging Station"
	area_blurb = "Vehicle Charging Station Placeholder"
	holomap_color = HOLOMAP_AREACOLOR_OPERATIONS

/area/new_blades/mudki/interiors/abandoned_shop
	name = "Abandoned Shop"
	area_blurb = "Abandoned Shop Placeholder"
	holomap_color = HOLOMAP_AREACOLOR_CIVILIAN

/area/new_blades/mudki/interiors/abandoned_shop/clothing
	name = "Abandoned Clothing Store"

/area/new_blades/mudki/interiors/abandoned_shop/electronic
	name = "Abandoned Electronics Store"

/area/new_blades/mudki/interiors/abandoned_shop/appliance
	name = "Abandoned Appliance Shop"

/area/new_blades/mudki/interiors/abandoned_shop/vehicle
	name = "Abandoned Mechanic's Shop"

/area/new_blades/mudki/interiors/abandoned_shop/convenience
	name = "Abandoned Convenience Store"

/area/new_blades/mudki/interiors/power_station
	name = "Power Station"
	area_blurb = "Power Station Placeholder"
	requires_power = TRUE
	holomap_color = HOLOMAP_AREACOLOR_OPERATIONS

/area/new_blades/mudki/interiors/water_treatment
	name = "Water Treatment Plant"
	area_blurb = "Water Treatment Plant Placeholder"
	requires_power = TRUE
	holomap_color = HOLOMAP_AREACOLOR_OPERATIONS

/area/new_blades/mudki/interiors/water_treatment/UV_room
	name = "Water Treatment Plant - Disinfection"
	area_blurb = "Placeholder"

/area/turbolift/mudki_hospital_lift
	name = "Mudki Hospital Lift"
	requires_power = TRUE
	station_area = FALSE

/area/turbolift/guildhouse_lift
	name = "Abandoned Guildhouse Lift"
	requires_power = TRUE
	station_area = FALSE

// Hospital Lift
/datum/shuttle/autodock/multi/lift/mudki_hospital
	name = "Mudki Hospital Lift"
	current_location = "nav_mudki_hospital_upper"
	shuttle_area = /area/turbolift/mudki_hospital_lift
	destination_tags = list(
		"nav_mudki_hospital_lower",
		"nav_mudki_hospital_upper",
		)

/obj/effect/shuttle_landmark/lift/mudki_hospital_upper
	name = "Mudki Hospital Lift - Upper"
	landmark_tag = "nav_mudki_hospital_upper"
	base_area = /area/new_blades/mudki/interiors/hospital
	base_turf = /turf/simulated/open

/obj/effect/shuttle_landmark/lift/mudki_hospital_lower
	name = "Mudki Hospital Lift - Lower"
	landmark_tag = "nav_mudki_hospital_lower"
	base_area = /area/new_blades/mudki/interiors/hospital
	base_turf = /turf/simulated/floor/plating

/obj/machinery/computer/shuttle_control/multi/lift/mudki_hospital
	shuttle_tag = "Mudki Hospital Lift"

/obj/machinery/computer/shuttle_control/multi/lift/wall/mudki_hospital
	shuttle_tag = "Mudki Hospital Lift"

// Abandoned Guildhouse Lift
/datum/shuttle/autodock/multi/lift/guildhouse
	name = "Abandoned Guildhouse Lift"
	current_location = "nav_guildhouse_upper"
	shuttle_area = /area/turbolift/guildhouse_lift
	destination_tags = list(
		"nav_guildhouse_lower",
		"nav_guildhouse_upper",
		)

/obj/effect/shuttle_landmark/lift/guildhouse_upper
	name = "Abandoned Guildhouse Lift - Upper"
	landmark_tag = "nav_guildhouse_upper"
	base_area = /area/new_blades/mudki/interiors/guildhouse
	base_turf = /turf/simulated/open

/obj/effect/shuttle_landmark/lift/guildhouse_lower
	name = "Abandoned Guildhouse Lift - Lower"
	landmark_tag = "nav_guildhouse_lower"
	base_area = /area/new_blades/mudki/interiors/guildhouse
	base_turf = /turf/simulated/floor/plating

/obj/machinery/computer/shuttle_control/multi/lift/guildhouse
	shuttle_tag = "Abandoned Guildhouse Lift"

/obj/machinery/computer/shuttle_control/multi/lift/wall/guildhouse
	shuttle_tag = "Abandoned Guildhouse Lift"

// EVENT THREE AREAS
/area/new_blades/underground/aquifer
	name = "Aquifer"
	area_blurb = "Cool, dark water laps around your feet. You have stepped into an underground lake - one that seems shallow enough to wade in, at least for now. You feel that you ought to tread carefully."
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_HIDE_FROM_HOLOMAP

/area/new_blades/underground/deadskrellstorage
	name = "Mass Grave"
	area_blurb = "The stench of rotting meat hits you like a tidal wave."
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_HIDE_FROM_HOLOMAP

/area/new_blades/interiors
	name = "Wasteland Interiors"
	icon_state = "blue"
	lighting = FALSE
	area_flags = AREA_FLAG_RAD_SHIELDED
	area_blurb = "This building appears better preserved than most in the Wasteland - it could make for a useful shelter if needed."
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING
	is_outside = OUTSIDE_NO

/area/new_blades/interiors/skrell_base
	name = "Skrell Base"
	area_blurb = "The vibrant colors and curves of skrell construction contrast sharply with the surrounding dusty wasteland, but that's not the only thing wrong with this picture."
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/new_blades/interiors/ruins
	name = "Wasteland Ruins"
	requires_power = TRUE
	area_blurb = "Though a ruined shell, this building appears somewhat intact. A potential shelter, should the weather turn."

/area/new_blades/interiors/ruins/hegemony_spaceport
	name = "Abandoned Spaceport"

/area/new_blades/interiors/ruins/hegemony_base
	name = "Abandoned Base"
	area_blurb = "The buildings here are ancient and rusting - a monument to the war that left this world sundered and bleeding."

/area/new_blades/interiors/ruins/bunker
	name = "Abandoned Bunker"
	area_blurb = "The quiet of the bunker is omnipresent - the drip of water and your footsteps on rusted concrete do nothing to quell it."
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_HIDE_FROM_HOLOMAP

/area/new_blades/interiors/ruins/bunker/brig
	name = "Abandoned Prison"
	area_blurb = "A stale copper smell in the air. "

/area/shuttle/scc_evac
	name = "SCC Transport Shuttle"
	area_flags = AREA_FLAG_RAD_SHIELDED
	holomap_color = HOLOMAP_AREACOLOR_COMMAND
	is_outside = OUTSIDE_NO

/area/turbolift/hegemony_bunker_A
	name = "Bunker Lift A"
	requires_power = TRUE
	station_area = FALSE

/area/turbolift/hegemony_bunker_B
	name = "Bunker Lift B"
	requires_power = TRUE
	station_area = FALSE

/datum/shuttle/autodock/ferry/scc_evac
	name = "SCCV Apollo"
	location = 1
	warmup_time = 10
	shuttle_area = /area/shuttle/scc_evac
	move_time = 20
	dock_target = "scc_evac"
	waypoint_station = "nav_scc_evac_dock"
	landmark_transition = "nav_scc_evac_interim"
	waypoint_offsite = "nav_scc_evac_start"
	knockdown = FALSE

/obj/effect/shuttle_landmark/scc_evac/start
	name = "Izilukh Landing Zone"
	landmark_tag = "nav_scc_evac_start"
	docking_controller = "scc_evac_station"
	base_turf = /turf/simulated/floor/exoplanet/desert
	base_area = /area/new_blades

/obj/effect/shuttle_landmark/scc_evac/interim
	name = "In transit"
	landmark_tag = "nav_scc_evac_interim"
	base_turf = /turf/space/transit/bluespace/west

/obj/effect/shuttle_landmark/scc_evac/dock
	name = "SCCV Horizon Docking Port"
	landmark_tag = "nav_scc_evac_dock"
	docking_controller = "scc_evac_shuttle_dock"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/machinery/computer/shuttle_control/scc_evac
	name = "SCCV Apollo control console"
	req_access = list(ACCESS_HEADS)
	shuttle_tag = "SCCV Apollo"
	var/locked = FALSE

/obj/machinery/computer/shuttle_control/scc_evac/attack_hand(mob/user)
	if(locked)
		return
	..()

/datum/shuttle/autodock/ferry/supply/moghes
	name = "OX Supply Shuttle"
	location = 1
	shuttle_area = /area/supply/dock
	dock_target = "cargo_shuttle"
	waypoint_station = "nav_cargo_shuttle_dock"
	waypoint_offsite = "nav_cargo_shuttle_start"

/obj/effect/shuttle_landmark/supply/moghes/start
	name = "SCCV Horizon Cargo Dock"
	landmark_tag = "nav_cargo_shuttle_start"
	base_turf = /turf/unsimulated/floor/plating
	base_area = /area/centcom

/obj/effect/shuttle_landmark/supply/moghes/dock
	name = "Planetary Docking Site"
	landmark_tag = "nav_cargo_shuttle_dock"
	docking_controller = "cargo_shuttle_dock"
	base_turf = /turf/simulated/floor/asphalt
	base_area = /area/landing_pad


// Bunker Lift A
/datum/shuttle/autodock/multi/lift/bunker_A
	name = "Bunker Lift A"
	current_location = "nav_bunker_A_lift_upper"
	shuttle_area = /area/turbolift/hegemony_bunker_A
	destination_tags = list(
		"nav_bunker_A_lift_lower",
		"nav_bunker_A_lift_upper",
		)

/obj/effect/shuttle_landmark/lift/bunker_A_upper
	name = "Bunker Lift A - Upper"
	landmark_tag = "nav_bunker_A_lift_upper"
	base_area = /area/new_blades/interiors/ruins/hegemony_base
	base_turf = /turf/simulated/open

/obj/effect/shuttle_landmark/lift/bunker_A_lower
	name = "Bunker Lift A - Lower"
	landmark_tag = "nav_bunker_A_lift_lower"
	base_area = /area/new_blades/interiors/ruins/bunker
	base_turf = /turf/simulated/floor/plating

/obj/machinery/computer/shuttle_control/multi/lift/bunker_A
	shuttle_tag = "Bunker Lift A"

/obj/machinery/computer/shuttle_control/multi/lift/wall/bunker_A
	shuttle_tag = "Bunker Lift A"

// Bunker Lift B
/datum/shuttle/autodock/multi/lift/bunker_B
	name = "Bunker Lift B"
	current_location = "nav_bunker_B_lift_upper"
	shuttle_area = /area/turbolift/hegemony_bunker_B
	destination_tags = list(
		"nav_bunker_B_lift_lower",
		"nav_bunker_B_lift_upper",
		)

/obj/effect/shuttle_landmark/lift/bunker_B_upper
	name = "Bunker Lift B - Upper"
	landmark_tag = "nav_bunker_B_lift_upper"
	base_area = /area/new_blades/interiors/ruins/hegemony_base
	base_turf = /turf/simulated/open

/obj/effect/shuttle_landmark/lift/bunker_B_lower
	name = "Bunker Lift B - Lower"
	landmark_tag = "nav_bunker_B_lift_lower"
	base_area = /area/new_blades/interiors/ruins/bunker
	base_turf = /turf/simulated/floor/plating

/obj/machinery/computer/shuttle_control/multi/lift/bunker_B
	shuttle_tag = "Bunker Lift B"

/obj/machinery/computer/shuttle_control/multi/lift/wall/bunker_B
	shuttle_tag = "Bunker Lift B"


//Corpses

/obj/effect/landmark/corpse/nralakk
	name = "Federation Humanitarian Worker"
	corpseuniform = /obj/item/clothing/under/skrell/nralakk/oqi/med
	corpsesuit = /obj/item/clothing/accessory/poncho/shouldercape/cloak/oqi
	corpseshoes = /obj/item/clothing/shoes/jackboots/kala
	corpseid = FALSE
	species = SPECIES_SKRELL

/obj/effect/landmark/corpse/nralakk/security
	name = "Federation Security Worker"
	corpseuniform = /obj/item/clothing/under/skrell/nralakk/oqi/security
	corpsesuit = /obj/item/clothing/suit/storage/vest/kala
	corpsehelmet = /obj/item/clothing/head/helmet/security/skrell
	corpsebelt = /obj/item/gun/energy/fedpistol

/obj/effect/landmark/corpse/nralakk/do_extra_customization(mob/living/carbon/human/M)
	. = ..()
	var/cadaver_color = pick("blue", "green", "yellow")
	switch(cadaver_color)
		if("blue")
			M.change_hair_color(50, 151, 168)
			M.change_skin_color(50, 151, 168)
		if("green")
			M.change_skin_color(31, 143, 56)
			M.change_hair_color(31, 143, 56)
		if("yellow")
			M.change_skin_color(209, 203, 25)
			M.change_hair_color(209, 203, 25)
	M.change_facial_hair("Shaved")
	M.adjustBruteLoss(rand(200,400))
	M.dir = pick(GLOB.cardinal)

/obj/effect/landmark/corpse/villager
	name = "Unathi Villager"
	corpseuniform = /obj/item/clothing/under/unathi/himation
	corpseshoes = /obj/item/clothing/shoes/sandals/caligae
	corpseid = FALSE
	species = SPECIES_UNATHI

/obj/effect/landmark/corpse/villager/do_extra_customization(mob/living/carbon/human/M)
	. = ..()
	if(M.w_uniform)
		M.w_uniform.color = "#c3b6b6"
		M.w_uniform.accent_color = "#c3b6b6"
	var/obj/item/organ/internal/stomach/stomach = M.internal_organs_by_name[BP_STOMACH]
	if(stomach)
		stomach.ingested.add_reagent(/singleton/reagent/toxin/phoron, rand(1,5))
		stomach.ingested.add_reagent(/singleton/reagent/water, rand(15,30))
	M.apply_damage(rand(10,30), DAMAGE_RADIATION, damage_flags = DAMAGE_FLAG_DISPERSED)
	M.faction = "deadguy"
	var/cadaver_color = pick("Brown", "Black", "Grey")
	switch(cadaver_color)
		if("Brown")
			M.change_skin_color(92,66,32)
		if("Black")
			M.change_skin_color(61,47,47)
		if("Grey")
			M.change_skin_color(98,84,65)
	M.change_hair_color(133, 115, 88)
	M.change_hair("Unathi Horns")
	M.change_facial_hair("Shaved")

/obj/effect/landmark/corpse/vaurca
	name = "C'thur Worker"
	mobname = "Ka'Akaix'Krez C'thur"
	corpseuniform = /obj/item/clothing/under/skrell/nralakk/oqi/service
	corpsesuit = /obj/item/clothing/accessory/poncho/shouldercape/cloak/oqi
	corpseshoes = /obj/item/clothing/shoes/vaurca
	corpsemask = /obj/item/clothing/mask/gas/vaurca/filter
	corpseid = FALSE
	species = SPECIES_VAURCA_WORKER

/obj/effect/landmark/corpse/vaurca/do_extra_customization(mob/living/carbon/human/M)
	. = ..()
	M.name = mobname
	M.real_name = mobname
	M.change_skin_color(20,20,55) //Vytel
	M.change_hair_color(20,20,55)
	M.adjustBruteLoss(rand(200,400))
	M.dir = pick(GLOB.cardinal)

/obj/item/paper/fluff/new_blades_1
	name = "To SCCV Horizon"
	info = "SCCV Horizon crew. We have established a base camp to the east of this shuttle port and begun to administer aid to the locals. Sandstorms have been inhibiting radio communication, so we have chosen to leave this note for you to ensure smooth operations. We look forward to seeing you soon. -NFV Qrrixu"

/obj/item/paper/fluff/skrell_report
	name = "Preliminary Survey Results"
	info = "Analysis of the region indicates severe degradation, yet I do not believe it is without hope. The aquifer is a vital resource for Izilukh, and if the Hegemony's plans for this area come to fruition it will be of immense importance in resettling the surrounding area. In addition, the eastern region was already an arid environment prior to the nuclear exchange, and there are several promising flora specimens which could be transplanted or crossbred with local species to restore the biosphere. My full analysis data has been copied to a disk, which I will send to headquarters at earliest convenience."
	language = LANGUAGE_SKRELLIAN

/obj/item/disk/mcguffin1
	name = "\improper Nralakk survey data disk"
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk2"
	item_state = "card-id"
	w_class = ITEMSIZE_SMALL
	desc = "An encrypted data disk, labeled in Nral'malic."
	desc_info = "This data disk can be used at the Zeng-Hu Environmental Analysis Terminal for a large one-time boost to survey progress."

/obj/item/disk/mcguffin1/get_examine_text(mob/user)
	. = ..()
	if(GLOB.all_languages[LANGUAGE_SKRELLIAN] in user.languages)
		. += SPAN_NOTICE("The label reads 'Izilukh Region Research Data'.")

/obj/item/disk/mcguffin2
	name = "purifier operations data disk"
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk2"
	item_state = "card-id"
	w_class = ITEMSIZE_SMALL
	desc = "An encrypted data disk."
	desc_info = "This data disk can be used at the Zeng-Hu Environmental Analysis Terminal for a large one-time boost to survey progress."

/obj/item/paper/fluff/decryption
	name = "decryption notes"
	info = "I thought that I'd cracked the encryption, but everything in here is just more of what we've been told. Analysis, medical aid, food supplies - exactly what the prisoner told us. I'll bring the disk back to Mudki with me when we're through here, see if someone else can't have a go at it."
	language = LANGUAGE_UNATHI

/obj/item/paper/fluff/syslog
	name = "operations log"
	info = "Izilukh Silo 3 System Commands Log:<br>\
	11/01/2451: All remaining payloads disarmed and removed.<br>\
	24/02/2451: Base closure ordered. Personnel relieved of duty.<br>\
	19/04/2451: Base power levels below operational. System shutdown engaged.<br>\
	25/06/2466: Base power reactivated. User command received: Unknown Command.<br>\
	30/06/2466: Base power deactivated. System shutdown engaged.<br>\
	30/06/2466: Base power reactivated. User command received: Print Logs."
	language = LANGUAGE_UNATHI

/obj/machinery/computer/terminal/silo
	name = "system log terminal"
	icon_screen = "command"
	icon_keyboard = "id_key"

/obj/machinery/computer/terminal/silo/attack_hand(mob/user)
	. = ..()
	var/choice = tgui_alert(user, "System logs available. Display driver corrupted. Print system logs?", "System Logs", list("Print", "Cancel"))
	if(choice == "Print")
		var/obj/item/paper/P = new /obj/item/paper/fluff/syslog(get_turf(user))
		user.put_in_hands(P)

/obj/machinery/computer/terminal/purifier
	name = "water purifier terminal"
	icon_screen = "turbinecomp"
	icon_keyboard = "id_key"
	var/has_disk = TRUE

/obj/machinery/computer/terminal/purifier/attack_hand(mob/user)
	. = ..()
	if(has_disk)
		var/choice = tgui_alert(user, "Latest data backup saved to external storage device. Select user action:", "Water Purifier Monitoring", list("Eject Disk", "Cancel"))
		if(choice == "Eject Disk")
			to_chat(user, SPAN_NOTICE("\The [src] ejects a disk."))
			has_disk = FALSE
			var/obj/item/disk/D = new /obj/item/disk/mcguffin2(get_turf(user))
			user.put_in_hands(D)

// custom mudki sewage thing
/turf/simulated/floor/exoplanet/water/shallow/partial_sewage
	name = "partially-filtered water"
	desc = "This water is somewhere between clean and sewage. Don't fall in it."
	icon_state = "unsmooth"
	base_icon_state = "unsmooth"
	icon = 'icons/turf/flooring/exoplanet/konyang/konyang_deep_water.dmi'
	smoothing_flags = SMOOTH_FALSE

// custom mudki water treatment thing

// RENAME AND REWRITE
/obj/item/paper/fluff/water_treatment_log
	name = "systems log"
	info = "Mudki Wastewater Treatment Plant 4 System Log:<br>\
	13/05/2458: Aeration tank oxygen line breaks detected. Initiating automatic pump shutoff.<br>\
	26/05/2458: Irregular flow rate detected in sewage lines. Advise personnel investigate.<br>\
	03/06/2458: Pressure buildup detected in sewage lines.<br>\
	05/06/2458: Multiple sewage line breaks detected. Initiating automatic sewage pump shutoff.<br>\
	19/06/2458: Treatment plant levels below operational. System shutdown engaged.<br>\
	20/07/2466: Treatment plant power reactivated. User command received: Print Logs."
	language = LANGUAGE_UNATHI

/obj/machinery/computer/terminal/water_treatment
	name = "system log terminal"
	icon_screen = "turbinecomp"
	icon_keyboard = "id_key"

/obj/machinery/computer/terminal/water_treatment/attack_hand(mob/user)
	. = ..()
	var/choice = tgui_alert(user, "System logs available. Display driver corrupted. Print system logs?", "System Logs", list("Print", "Cancel"))
	if(choice == "Print")
		var/obj/item/paper/P = new /obj/item/paper/fluff/water_treatment_log(get_turf(user))
		user.put_in_hands(P)

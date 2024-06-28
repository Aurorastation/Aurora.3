/area/new_blades
	name = "The Wasteland"
	icon_state = "green"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/desert
	ambience = AMBIENCE_DESERT
	area_blurb = "Heat, sand, and dust surround you. The air smells of burning rubber as the wind stirs spirals of dust about your feet. The heat is overpowering."
	var/lighting = TRUE

/area/new_blades/Initialize()
	. = ..()
	if(lighting)
		for(var/turf/T in src)
			T.set_light(4, 5, COLOR_WHITE)

/area/new_blades/underground
	name = "Zazalai Caverns"
	icon_state = "bluenew"
	lighting = FALSE
	base_turf = /turf/simulated/floor/exoplanet/barren/warm
	ambience = AMBIENCE_RUINS
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_HIDE_FROM_HOLOMAP
	area_blurb = "The caverns are dark and quiet, a merciful reprise from the Wasteland outside."

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

/area/new_blades/interiors/skrell_base
	name = "Skrell Base"
	area_blurb = "The vibrant colors and curves of skrell construction contrast sharply with the surrounding dusty wasteland, but that's not the only thing wrong with this picture."

/area/new_blades/interiors/ruins
	name = "Wasteland Ruins"
	requires_power = TRUE
	area_blurb = "Though a ruined shell, this building appears somewhat intact. A potential shelter, should the weather turn."

/area/new_blades/interiors/ruins/hegemony_spaceport
	name = "Abandoned Spaceport"
	area_blurb = "The buildings here are ancient and rusting - a monument to the war that left this world sundered and bleeding."

/area/new_blades/interiors/ruins/hegemony_base
	name = "Abandoned Base"
	area_blurb = "The buildings here are ancient and rusting - a monument to the war that left this world sundered and bleeding."

/area/new_blades/interiors/ruins/bunker
	name = "Abandoned Bunker"
	area_blurb = "The quiet of the bunker is omnipresent - the drip of water and your footsteps on rusted concrete do nothing to quell it."
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_HIDE_FROM_HOLOMAP

/area/shuttle/scc_evac
	name = "SCC Transport Shuttle"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/turbolift/hegemony_bunker_A
	name = "Bunker Lift A"
	station_area = FALSE

/area/turbolift/hegemony_bunker_B
	name = "Bunker Lift B"
	station_area = FALSE

/datum/shuttle/autodock/ferry/scc_evac
	name = "SCC Evac Shuttle"
	location = 1
	warmup_time = 10
	shuttle_area = /area/shuttle/scc_evac
	move_time = 20
	dock_target = "scc_evac"
	waypoint_station = "nav_scc_evac_dock"
	landmark_transition = "nav_scc_evac_interim"
	waypoint_offsite = "nav_scc_evac_start"

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
	shuttle_tag = "SCC Evac Shuttle"
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
	base_turf = /turf/simulated/floor/exoplanet/desert
	base_area = /area/new_blades


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
	var/obj/item/organ/internal/stomach/stomach = M.internal_organs_by_name[BP_STOMACH]
	if(stomach)
		stomach.ingested.add_reagent(/singleton/reagent/toxin/phoron, rand(1,10))
		stomach.ingested.add_reagent(/singleton/reagent/water, rand(15,30))
	M.apply_damage(rand(10,30), DAMAGE_RADIATION, damage_flags = DAMAGE_FLAG_DISPERSED)

/obj/effect/landmark/corpse/vaurca
	name = "C'thur Worker"
	mobname = "Ka'Akaix'Krez C'thur"
	corpseuniform = /obj/item/clothing/under/skrell/nralakk/oqi/service
	corpsesuit = /obj/item/clothing/accessory/poncho/shouldercape/cloak/oqi
	corpseshoes = /obj/item/clothing/shoes/vaurca
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

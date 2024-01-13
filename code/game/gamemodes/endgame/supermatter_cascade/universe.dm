var/global/universe_has_ended = 0


/datum/universal_state/supermatter_cascade
	name = "Supermatter Cascade"
	desc = "Unknown harmonance affecting universal substructure, converting nearby matter to supermatter."

	decay_rate = 5 // 5% chance of a turf decaying on lighting update/airflow (there's no actual tick for turfs)

/datum/universal_state/supermatter_cascade/OnShuttleCall(var/mob/user)
	if(user)
		to_chat(user, "<span class='danger'>All you hear on the frequency is static and panicked screaming. There will be no shuttle call today.</span>")
	return 0

/datum/universal_state/supermatter_cascade/OnTurfChange(var/turf/T)
	if(T.name == "space")
		T.add_overlay("end01")
		T.underlays -= "end01"
	else
		T.cut_overlay("end01")

/datum/universal_state/supermatter_cascade/DecayTurf(var/turf/T)
	if(istype(T,/turf/simulated/wall))
		var/turf/simulated/wall/W=T
		W.melt()
		return
	if(istype(T,/turf/simulated/floor))
		var/turf/simulated/floor/F=T
		// Burnt?
		if(!F.burnt)
			F.burn_tile()
		else
			if(!istype(F,/turf/simulated/floor/plating))
				F.break_tile_to_plating()
		return

// Apply changes when entering state
/datum/universal_state/supermatter_cascade/OnEnter()
	SSgarbage.can_fire = FALSE

	to_world("<span class='danger' style='font-size:22pt'>You are blinded by a brilliant flash of energy.</span>")

	sound_to(world, ('sound/effects/cascade.ogg'))

	for(var/mob/M in GLOB.player_list)
		M.flash_act()

	if(evacuation_controller.cancel_evacuation())
		priority_announcement.Announce("The evacuation has been aborted due to bluespace distortion.")

	SSskybox.change_skybox("cascade", new_use_stars = FALSE, new_use_overmap_details = FALSE)

	AreaSet()
	MiscSet()
	APCSet()
	OverlayAndAmbientSet()

	// Disable Nar-Sie.
	cult.allow_narsie = 0

	PlayerSet()

	new /obj/singularity/narsie/large/exit(pick(GLOB.endgame_exits))
	var/time = rand(30, 60)
	LOG_DEBUG("universal_state/cascade: Announcing to world in [time] seconds.")
	LOG_DEBUG("universal_state/cascade: Ending universe in [(time SECONDS + 5 MINUTES)/10] seconds.")
	addtimer(CALLBACK(src, PROC_REF(announce_to_world)), time SECONDS)
	addtimer(CALLBACK(src, PROC_REF(end_universe)), time SECONDS + 5 MINUTES)

/datum/universal_state/supermatter_cascade/proc/announce_to_world()
	var/txt = {"
There's been a galaxy-wide electromagnetic pulse.  All of our systems are heavily damaged and many personnel are dead or dying. We are seeing increasing indications of the universe itself beginning to unravel.

[station_name()], you are the only facility nearby a bluespace rift, which is near your research outpost. You are hereby directed to enter the rift using all means necessary, quite possibly as the last of your species alive.

You have five minutes before the universe collapses. Good l\[\[###!!!-

AUTOMATED ALERT: Link to [current_map.boss_name] lost.

The access requirements on the Asteroid Shuttles' consoles have now been revoked.
	"}
	priority_announcement.Announce(txt,"SUPERMATTER CASCADE DETECTED")

	for(var/obj/machinery/computer/shuttle_control/C in SSmachinery.machinery)
		if(istype(C, /obj/machinery/computer/shuttle_control/multi/research) || istype(C, /obj/machinery/computer/shuttle_control/mining))
			C.req_access = list()
			C.req_one_access = list()

/datum/universal_state/supermatter_cascade/proc/end_universe()
	SSticker.station_explosion_cinematic(0, null, current_map.player_levels) // TODO: Custom cinematic
	universe_has_ended = 1

/datum/universal_state/supermatter_cascade/proc/AreaSet()
	for(var/area/A in GLOB.all_areas)
		if(!istype(A,/area) || istype(A, /area/space))
			continue

		A.queue_icon_update()
		CHECK_TICK

/datum/universal_state/supermatter_cascade/OverlayAndAmbientSet()
	set waitfor = FALSE
	for(var/turf/T in world)
		if(istype(T, /turf/space))
			T.add_overlay("end01")
		else
			if (isNotAdminLevel(T.z))
				T.underlays += "end01"
		CHECK_TICK

	for(var/datum/lighting_corner/C in SSlighting.lighting_corners)
		if (!C.active)
			continue

		if (isNotAdminLevel(C.z))
			C.update_lumcount(0.15, 0.15, 0.5)
		CHECK_TICK

/datum/universal_state/supermatter_cascade/proc/MiscSet()
	for (var/obj/machinery/firealarm/alm in SSmachinery.processing)
		if (!(alm.stat & BROKEN))
			alm.ex_act(2)
		CHECK_TICK

/datum/universal_state/supermatter_cascade/proc/APCSet()
	for (var/obj/machinery/power/apc/APC in SSmachinery.processing)
		if (!(APC.stat & BROKEN) && !APC.is_critical)
			APC.chargemode = 0
			if(APC.cell)
				APC.cell.charge = 0
			APC.emagged = 1
			APC.queue_icon_update()
		CHECK_TICK

/datum/universal_state/supermatter_cascade/proc/PlayerSet()
	for(var/datum/mind/M in GLOB.player_list)
		if(!istype(M.current,/mob/living))
			continue
		if(M.current.stat!=2)
			if(M.current.flash_act())
				M.current.Weaken(10)

		clear_antag_roles(M)
		CHECK_TICK

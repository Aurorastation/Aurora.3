/turf/simulated
	name = "station"
	var/wet_type = 0
	var/wet_amount = 0
	var/image/wet_overlay = null

	var/thermite = 0
	initial_gas = list("oxygen" = MOLES_O2STANDARD, "nitrogen" = MOLES_N2STANDARD)
	var/dirt = 0

	var/unwet_timer	// Used to keep track of the unwet timer & delete it on turf change so we don't runtime if the new turf is not simulated.

	roof_type = /turf/simulated/floor/airless/ceiling

	baseturf = /turf/space

/turf/simulated/Initialize(mapload)
	if (mapload)
		if(istype(loc, /area/horizon/service/chapel))
			holy = 1

	. = ..()
	levelupdate(mapload)
	if (!mapload)
		updateVisibility(src)

/turf/simulated/proc/update_dirt()
	dirt = min(dirt+1, 101)
	var/obj/effect/decal/cleanable/dirt/dirtoverlay = locate(/obj/effect/decal/cleanable/dirt, src)
	if (dirt > 50)
		if (!dirtoverlay)
			dirtoverlay = new/obj/effect/decal/cleanable/dirt(src)
		dirtoverlay.alpha = min((dirt - 50) * 5, 255)

/turf/simulated/Entered(atom/movable/arrived, atom/old_loc)
	if(movement_disabled && usr.ckey != movement_disabled_exception)
		to_chat(usr, SPAN_WARNING("Movement is admin-disabled.")) //This is to identify lag problems)
		return

	if(istype(arrived, /mob/living))
		var/mob/living/M = arrived
		//if the turf is wet, the mob is not buckled, and either it's not wet with water or the mob is running, slip it
		if(src.wet_type && src.wet_amount && !M.buckled_to && (src.wet_type != WET_TYPE_WATER || M.m_intent != M_WALK))

			//Defaults to a water slip
			var/slip_dist = 1
			var/slip_stun = 6
			var/floor_type = "wet"

			switch(src.wet_type)
				if(WET_TYPE_LUBE) // Lube
					floor_type = "slippery"
					slip_dist = 4
					slip_stun = 10
				if(WET_TYPE_ICE) // Ice
					floor_type = "icy"
					slip_stun = 4

			if(M.slip("the [floor_type] floor",slip_stun) && slip_dist)
				INVOKE_ASYNC(src, PROC_REF(slip_mob), M, slip_dist)

		if(M.lying)
			return ..()

		// Ugly hack :c Should never have multiple plants in the same tile.
		var/obj/effect/plant/plant = locate() in contents
		if(plant)
			plant.trodden_on(M)

		// Dirt overlays.
		update_dirt()

		M.inertia_dir = 0

	..()

/**
 * Slips a mob, moving it for N tiles
 *
 * Should be called asyncronously, as this process sleep
 *
 * * mob_to_slip - The mob that should be slipped
 * * slip_distance - How many tiles to slip the mob for
 */
/turf/simulated/proc/slip_mob(var/mob/mob_to_slip, var/slip_distance)
	for (var/i in 1 to slip_distance)
		sleep(1)
		step(mob_to_slip, mob_to_slip.dir)

//returns TRUE if made bloody, returns FALSE otherwise
/turf/simulated/add_blood(mob/living/carbon/human/M as mob)
	if (!..())
		return FALSE

	if(istype(M))
		for(var/obj/effect/decal/cleanable/blood/B in contents)
			if(!B.blood_DNA)
				B.blood_DNA = list()
			if(!B.blood_DNA[M.dna.unique_enzymes])
				B.blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
			return TRUE //we bloodied the floor
		blood_splatter(src,M,TRUE)
		return TRUE //we bloodied the floor
	return FALSE

// Only adds blood on the floor -- Skie
/turf/simulated/proc/add_blood_floor(mob/living/carbon/M as mob)
	if( istype(M, /mob/living/carbon/alien ))
		var/obj/effect/decal/cleanable/blood/xeno/this = new /obj/effect/decal/cleanable/blood/xeno(src)
		this.blood_DNA["UNKNOWN BLOOD"] = "X*"
	else if( istype(M, /mob/living/silicon/robot ))
		new /obj/effect/decal/cleanable/blood/oil(src)

/turf/simulated/Destroy()
	if (zone && !zone.invalid)
		// Try to remove it gracefully first.
		if (can_safely_remove_from_zone())
			c_copy_air()
			zone.remove(src)
		else	// Can't remove it safely, just rebuild the entire thing.
			zone.rebuild()

	// Letting this timer continue to exist can cause runtimes, so we delete it.
	if (unwet_timer)
		// deltimer will no-op if the timer is already deleted, so we don't need to check the timer still exists.
		deltimer(unwet_timer)

	return ..()

/turf/simulated/proc/wet_floor(var/apply_type = WET_TYPE_WATER, var/amount = 1)

	//Wet type:
	//WET_TYPE_WATER = water
	//WET_TYPE_LUBE = lube
	//WET_TYPE_ICE = ice

	if(!wet_type)
		wet_type = apply_type
	else if(apply_type != wet_type)
		if(apply_type == WET_TYPE_WATER && wet_type == WET_TYPE_LUBE)
			wet_type = WET_TYPE_WATER
		else if(apply_type == WET_TYPE_ICE && (wet_type == WET_TYPE_WATER || wet_type == WET_TYPE_LUBE))
			wet_type = apply_type

	if(wet_amount <= 0)
		wet_amount = 0 //Just in case

	if(!wet_overlay)
		wet_overlay = image('icons/effects/water.dmi',src,"wet_floor")
		AddOverlays(wet_overlay, ATOM_ICON_CACHE_PROTECTED)

	wet_amount += amount

	unwet_timer = addtimer(CALLBACK(src, PROC_REF(unwet_floor)), 120 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_STOPPABLE)

/turf/simulated/proc/unwet_floor()
	wet_amount = 0
	wet_type = 0
	if(wet_overlay)
		CutOverlays(wet_overlay, ATOM_ICON_CACHE_PROTECTED)
		wet_overlay = null

/turf/simulated/clean_blood()
	for(var/obj/effect/decal/cleanable/blood/B in contents)
		B.clean_blood()
	..()

/turf/simulated/clean(atom/source, mob/user)
	. = ..()
	dirt = 0
	reset_color()

/turf/simulated/proc/reset_color()
	color = null

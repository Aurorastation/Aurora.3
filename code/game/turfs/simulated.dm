/turf/simulated
	name = "station"
	var/wet = 0
	var/wetness_duration
	var/wet_descriptor = null
	var/slip_dist_power = 0
	var/slip_stun = 0
	var/image/wet_overlay = null

	var/thermite = 0
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	var/to_be_destroyed = 0 //Used for fire, if a melting temperature was reached, it will be destroyed
	var/max_fire_temperature_sustained = 0 //The max temperature of the fire which it was subjected to
	var/dirt = 0

// possible fix for the perma wet floor bug
/turf/simulated/proc/wet_floor(var/wet_val = 1, var/duration)
	if (wet_val > wet)
		switch(wet_val)
			if (1)
				slip_dist_power = 75
				slip_stun = 4
				wet_descriptor = "wet"
			if (2)
				slip_dist_power = 92
				slip_stun = 8
				wet_descriptor = "slippery"
			if (3)
				slip_dist_power = 85
				slip_stun = 6
				wet_descriptor = "icy"
			else
				return //some invalid value was passed
		wet = wet_val

	wetness_duration += duration

	if (wet_overlay)
		overlays -= wet_overlay
		wet_overlay = null
	processing_objects |= src
	wet_overlay = image('icons/effects/water.dmi',src,"wet_floor")
	overlays += wet_overlay



/turf/simulated/proc/dry_floor(var/drying = 0)
	//If drying value is passed, it reduces the duration by this amount. Otherwise, it instantly dries the floor
	if (drying)
		wetness_duration -= drying

	if (wetness_duration <= 0 || !drying)
		overlays -= wet_overlay
		wet_overlay = null
		processing_objects -= src
		wet = 0
		slip_dist_power = 0
		slip_stun = 0
		wet_descriptor = null

/turf/simulated/process()
	dry_floor(1)


/turf/simulated/clean_blood()
	for(var/obj/effect/decal/cleanable/blood/B in contents)
		B.clean_blood()
	..()

/turf/simulated/New()
	..()
	if(istype(loc, /area/chapel))
		holy = 1
	levelupdate()

/turf/simulated/proc/AddTracks(var/typepath,var/bloodDNA,var/comingdir,var/goingdir,var/bloodcolor="#A10808")
	var/obj/effect/decal/cleanable/blood/tracks/tracks = locate(typepath) in src
	if(!tracks)
		tracks = new typepath(src)
	tracks.AddTracks(bloodDNA,comingdir,goingdir,bloodcolor)

/turf/simulated/Entered(atom/A, atom/OL)
	if(movement_disabled && usr.ckey != movement_disabled_exception)
		usr << "\red Movement is admin-disabled." //This is to identify lag problems
		return

	if (istype(A,/mob/living))
		var/mob/living/M = A
		if(M.lying)
			..()
			return

		// Ugly hack :( Should never have multiple plants in the same tile.
		var/obj/effect/plant/plant = locate() in contents
		if(plant) plant.trodden_on(M)

		// Dirt overlays.
		dirt++
		var/obj/effect/decal/cleanable/dirt/dirtoverlay = locate(/obj/effect/decal/cleanable/dirt, src)
		if (dirt >= 50)
			if (!dirtoverlay)
				dirtoverlay = new/obj/effect/decal/cleanable/dirt(src)
				dirtoverlay.alpha = 15
			else if (dirt > 50)
				dirtoverlay.alpha = min(dirtoverlay.alpha+5, 255)

		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			// Tracking blood
			var/list/bloodDNA = null
			var/bloodcolor=""
			if(H.shoes)
				var/obj/item/clothing/shoes/S = H.shoes
				if(istype(S))
					S.handle_movement(src,(H.m_intent == "run" ? 1 : 0))
					if(S.track_blood && S.is_bloodied)
						bloodDNA = S.blood_DNA
						bloodcolor=S.blood_color
						S.track_blood--
			else
				if(H.track_blood && H.feet_blood_DNA)
					bloodDNA = H.feet_blood_DNA
					bloodcolor = H.feet_blood_color
					H.track_blood--

			if (bloodDNA)
				src.AddTracks(/obj/effect/decal/cleanable/blood/tracks/footprints,bloodDNA,H.dir,0,bloodcolor) // Coming
				var/turf/simulated/from = get_step(H,reverse_direction(H.dir))
				if(istype(from) && from)
					from.AddTracks(/obj/effect/decal/cleanable/blood/tracks/footprints,bloodDNA,0,H.dir,bloodcolor) // Going

				bloodDNA = null

		if(src.wet)
			if(M.buckled || (src.wet == 1 && M.m_intent == "walk"))
				return

			if(M.slip("the [wet_descriptor] floor",slip_stun))
				if (prob(slip_dist_power))
					sleep(2)
					step(M, M.dir)
					sleep(2)
					var/sliding = 1
					var/counts = 0
					while(sliding)

						var/turf/simulated/TS = get_turf(M)
						if (!istype(TS))
							sliding = 0
							break

						if (!TS.wet)
							sliding = 0
							break

						if (prob(TS.slip_dist_power))
							step(M, M.dir)
							sleep(2+(0.3*counts))//go slower as you lose inertia over time
							if (get_turf(M) == TS)//If we're still on the same tile after sliding, then we've hit something solid.
								sliding = 0
								break
						else
							sliding = 0
						counts++
			else
				M.inertia_dir = 0
		else
			M.inertia_dir = 0

	..()

//returns 1 if made bloody, returns 0 otherwise
/turf/simulated/add_blood(mob/living/carbon/human/M as mob)
	if (!..())
		return 0

	if(istype(M))
		for(var/obj/effect/decal/cleanable/blood/B in contents)
			if(!B.blood_DNA)
				B.blood_DNA = list()
			if(!B.blood_DNA[M.dna.unique_enzymes])
				B.blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
				B.virus2 = virus_copylist(M.virus2)
			return 1 //we bloodied the floor
		blood_splatter(src,M.get_blood(M.vessel),1)
		return 1 //we bloodied the floor
	return 0

// Only adds blood on the floor -- Skie
/turf/simulated/proc/add_blood_floor(mob/living/carbon/M as mob)
	if( istype(M, /mob/living/carbon/alien ))
		var/obj/effect/decal/cleanable/blood/xeno/this = new /obj/effect/decal/cleanable/blood/xeno(src)
		this.blood_DNA["UNKNOWN BLOOD"] = "X*"
	else if( istype(M, /mob/living/silicon/robot ))
		new /obj/effect/decal/cleanable/blood/oil(src)

#define ZERO_WIDTH_SPACE "&#8203;" //prevents the UI elements from popping out of place when viewport gets too small

var/global/datum/repository/crew/crew_repository = new()

/datum/repository/crew
	var/list/cache_data

/datum/repository/crew/New()
	cache_data = list()
	..()

/datum/repository/crew/proc/calcDamage_Inaccurate(var/DMGValue) //overrides global proc: this displays healthy even when damaged up to 10 points
	switch(DMGValue)
		if (0 to 10)
			return ZERO_WIDTH_SPACE + "Healthy"
		if (10 to 25)
			return ZERO_WIDTH_SPACE + "Minor"
		if (25 to 50)
			return ZERO_WIDTH_SPACE + "Moderate"
		if (50 to 75)
			return ZERO_WIDTH_SPACE + "Major"
		if (75 to 200)
			return ZERO_WIDTH_SPACE + "Critical"
		if (200 to INFINITY)
			return ZERO_WIDTH_SPACE + "Fatal"
			
/datum/repository/crew/proc/health_data(var/z_level)
	var/list/crewmembers = list()
	if(!z_level)
		return crewmembers

	var/datum/cache_entry/cache_entry = cache_data[num2text(z_level)]
	if(!cache_entry)
		cache_entry = new/datum/cache_entry
		cache_data[num2text(z_level)] = cache_entry

	if(world.time < cache_entry.timestamp)
		return cache_entry.data

	var/tracked = scan()
	for(var/obj/item/clothing/under/C in tracked)
		var/turf/pos = get_turf(C)
		if((C) && (C.has_sensor) && (pos) && (pos.z == z_level) && (C.sensor_mode != SUIT_SENSOR_OFF) && !within_jamming_range(C))
			if(istype(C.loc, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = C.loc
				if(H.w_uniform != C)
					continue

				var/list/crewmemberData = list("dead"=0, "oxy"=ZERO_WIDTH_SPACE+"Healthy", "tox"=ZERO_WIDTH_SPACE+"Healthy", "fire"=ZERO_WIDTH_SPACE+"Healthy", "brute"=ZERO_WIDTH_SPACE+"Healthy", "area"="", "x"=-1, "y"=-1, "z"=-1, "level"="", "ref" = "\ref[H]")

				crewmemberData["sensor_type"] = C.sensor_mode
				crewmemberData["name"] = H.get_authentification_name(if_no_id="Unknown")
				crewmemberData["rank"] = H.get_authentification_rank(if_no_id="Unknown", if_no_job="No Job")
				crewmemberData["assignment"] = H.get_assignment(if_no_id="Unknown", if_no_job="No Job")
				
				if(C.sensor_mode >= SUIT_SENSOR_BINARY)
					crewmemberData["dead"] = H.stat > UNCONSCIOUS

				if(C.sensor_mode >= SUIT_SENSOR_VITAL)
					crewmemberData["oxy"] = calcDamage_Inaccurate(H.getOxyLoss())
					crewmemberData["tox"] = calcDamage_Inaccurate(H.getToxLoss())
					crewmemberData["fire"] = calcDamage_Inaccurate(H.getFireLoss())
					crewmemberData["brute"] = calcDamage_Inaccurate(H.getBruteLoss())

				if(C.sensor_mode >= SUIT_SENSOR_TRACKING)
					var/area/A = get_area(H)
					crewmemberData["area"] = sanitize(A.name)
					crewmemberData["x"] = pos.x
					crewmemberData["y"] = pos.y
					crewmemberData["z"] = pos.z

				crewmembers[++crewmembers.len] = crewmemberData

	crewmembers = sortByKey(crewmembers, "name")
	cache_entry.timestamp = world.time + 5 SECONDS
	cache_entry.data = crewmembers

	return crewmembers

/datum/repository/crew/proc/scan()
	var/list/tracked = list()
	for(var/mob/living/carbon/human/H in mob_list)
		if(istype(H.w_uniform, /obj/item/clothing/under))
			var/obj/item/clothing/under/C = H.w_uniform
			if (C.has_sensor)
				tracked |= C
	return tracked
	
#undef ZERO_WIDTH_SPACE
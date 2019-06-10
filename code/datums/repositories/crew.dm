var/global/datum/repository/crew/crew_repository = new()

/datum/repository/crew
	var/list/cache_data

/datum/repository/crew/New()
	cache_data = list()
	..()

/datum/repository/crew/proc/calcDamage(var/DMGValue)
	switch(DMGValue)
		if (0 to 10)
			return "&#8203;Healthy"
		if (10 to 25)
			return "&#8203;Minor"
		if (25 to 50)
			return "&#8203;Moderate"
		if (50 to 75)
			return "&#8203;Major"
		if (75 to 200)
			return "&#8203;Critical"
		if (200 to INFINITY)
			return "&#8203;Fatal"
			
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
		if((C) && (C.has_sensor) && (pos) && (pos.z == z_level) && (C.sensor_mode != SUIT_SENSOR_OFF))
			if(istype(C.loc, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = C.loc
				if(H.w_uniform != C)
					continue

				var/list/crewmemberData = list("dead"=0, "oxy"="&#8203;Healthy", "tox"="&#8203;Healthy", "fire"="&#8203;Healthy", "brute"="&#8203;Healthy", "area"="", "x"=-1, "y"=-1, "z"=-1, "level"="", "ref" = "\ref[H]")

				crewmemberData["sensor_type"] = C.sensor_mode
				crewmemberData["name"] = H.get_authentification_name(if_no_id="Unknown")
				crewmemberData["rank"] = H.get_authentification_rank(if_no_id="Unknown", if_no_job="No Job")
				crewmemberData["assignment"] = H.get_assignment(if_no_id="Unknown", if_no_job="No Job")

				if(C.sensor_mode >= SUIT_SENSOR_BINARY)
					crewmemberData["dead"] = H.stat > UNCONSCIOUS

				if(C.sensor_mode >= SUIT_SENSOR_VITAL)
					crewmemberData["oxy"] = calcDamage(H.getOxyLoss())
					crewmemberData["tox"] = calcDamage(H.getToxLoss())
					crewmemberData["fire"] = calcDamage(H.getFireLoss())
					crewmemberData["brute"] = calcDamage(H.getBruteLoss())

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

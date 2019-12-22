#define ZERO_WIDTH_SPACE "&#8203;" //prevents the UI elements from popping out of place when viewport gets too small

var/global/datum/repository/crew/crew_repository = new()

/datum/repository/crew
	var/list/cache_data

/datum/repository/crew/New()
	cache_data = list()
	..()

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

				var/list/crewmemberData = list("dead"=0, "area"="", "x"=-1, "y"=-1, "z"=-1, "level"="", "ref" = "\ref[H]")

				crewmemberData["sensor_type"] = C.sensor_mode
				crewmemberData["name"] = H.get_authentification_name(if_no_id="Unknown")
				crewmemberData["rank"] = H.get_authentification_rank(if_no_id="Unknown", if_no_job="No Job")
				crewmemberData["assignment"] = H.get_assignment(if_no_id="Unknown", if_no_job="No Job")

				if(C.sensor_mode >= SUIT_SENSOR_BINARY)
					crewmemberData["dead"] = H.stat > UNCONSCIOUS

				if(C.sensor_mode >= SUIT_SENSOR_VITAL)
					crewmemberData["pulse"] = "N/A"
					crewmemberData["pulse_span"] = "neutral"
					crewmemberData["true_pulse"] = -1
					if(!H.isSynthetic() && H.should_have_organ(BP_HEART))
						var/obj/item/organ/internal/heart/O = H.internal_organs_by_name[BP_HEART]
						if (!O || !BP_IS_ROBOTIC(O)) // Don't make medical freak out over prosthetic hearts
							crewmemberData["true_pulse"] = H.pulse()
							crewmemberData["pulse"] = H.get_pulse(GETPULSE_TOOL)
							switch(crewmemberData["true_pulse"])
								if(PULSE_NONE)
									crewmemberData["pulse_span"] = "bad"
								if(PULSE_SLOW)
									crewmemberData["pulse_span"] = "average"
								if(PULSE_NORM)
									crewmemberData["pulse_span"] = "good"
								if(PULSE_FAST)
									crewmemberData["pulse_span"] = "highlight"
								if(PULSE_2FAST)
									crewmemberData["pulse_span"] = "average"
								if(PULSE_THREADY)
									crewmemberData["pulse_span"] = "bad"

					crewmemberData["pressure"] = "N/A"
					crewmemberData["true_oxygenation"] = -1
					crewmemberData["oxygenation"] = ""
					crewmemberData["oxygenation_span"] = ""
					if(!H.isSynthetic() && H.should_have_organ(BP_HEART))
						crewmemberData["pressure"] = H.get_blood_pressure()
						crewmemberData["true_oxygenation"] = H.get_blood_oxygenation()
						switch (crewmemberData["true_oxygenation"])
							if(105 to INFINITY)
								crewmemberData["oxygenation"] = "increased"
								crewmemberData["oxygenation_span"] = "highlight"
							if(BLOOD_VOLUME_SAFE to 105)
								crewmemberData["oxygenation"] = "normal"
								crewmemberData["oxygenation_span"] = "good"
							if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
								crewmemberData["oxygenation"] = "low"
								crewmemberData["oxygenation_span"] = "average"
							if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
								crewmemberData["oxygenation"] = "very low"
								crewmemberData["oxygenation_span"] = "bad"
							if(-(INFINITY) to BLOOD_VOLUME_BAD)
								crewmemberData["oxygenation"] = "extremely low"
								crewmemberData["oxygenation_span"] = "bad"

					crewmemberData["bodytemp"] = H.bodytemperature - T0C

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
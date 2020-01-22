#define ZERO_WIDTH_SPACE "&#8203;" //prevents the UI elements from popping out of place when viewport gets too small

// Oxyginetion states
#define OXYGENATION_STATE_HIGH 5
#define OXYGENATION_STATE_NORMAL 4
#define OXYGENATION_STATE_LOW 3
#define OXYGENATION_STATE_VERY_LOW 2
#define OXYGENATION_STATE_NONE 1
#define OXYGENATION_STATE_UNDEFINED 0

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
	for(var/t in tracked)
		var/obj/item/clothing/under/C = t
		var/turf/pos = get_turf(C)
		if((C) && (C.has_sensor) && (pos) && (pos.z == z_level) && (C.sensor_mode != SUIT_SENSOR_OFF) && !within_jamming_range(C))
			if(istype(C.loc, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = C.loc
				if(H.w_uniform != C)
					continue

				var/list/crewmemberData = list("area"=null, "x"=null, "y"=null, "z"=null, "level"=null, "ref" = "\ref[H]")

				crewmemberData["stype"] = C.sensor_mode
				crewmemberData["name"] = H.get_authentification_name(if_no_id="Unknown")
				crewmemberData["ass"] = H.get_assignment(if_no_id="Unknown", if_no_job="No Job")

				if(C.sensor_mode >= SUIT_SENSOR_BINARY)
					crewmemberData["pulse"] = "N/A"
					crewmemberData["tpulse"] = -1
					crewmemberData["cellCharge"] = -1
					if(!H.isSynthetic())
						if(H.should_have_organ(BP_HEART))
							var/obj/item/organ/internal/heart/O = H.internal_organs_by_name[BP_HEART]
							if (!O || !BP_IS_ROBOTIC(O)) // Don't make medical freak out over prosthetic hearts
								crewmemberData["tpulse"] = H.pulse()
								crewmemberData["pulse"] = H.get_pulse(GETPULSE_TOOL)
					else
						if(isipc(H) && H.internal_organs_by_name[BP_IPCTAG]) // Don't make untagged IPCs obvious
							var/obj/item/organ/internal/cell/cell = H.internal_organs_by_name[BP_CELL]
							if(cell)
								crewmemberData["cellCharge"] = Floor(100*H.nutrition / H.max_nutrition)

				if(C.sensor_mode >= SUIT_SENSOR_VITAL)
					crewmemberData["pressure"] = "N/A"
					crewmemberData["toxyg"] = -1
					crewmemberData["oxyg"] = OXYGENATION_STATE_UNDEFINED
					if(!H.isSynthetic() && H.should_have_organ(BP_HEART))
						crewmemberData["tpressure"] = H.get_blood_pressure_alert()
						crewmemberData["pressure"] = H.get_blood_pressure()
						crewmemberData["toxyg"] = H.get_blood_oxygenation()
						switch (crewmemberData["toxyg"])
							if(105 to INFINITY)
								crewmemberData["oxyg"] = OXYGENATION_STATE_HIGH
							if(BLOOD_VOLUME_SAFE to 105)
								crewmemberData["oxyg"] = OXYGENATION_STATE_NORMAL
							if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
								crewmemberData["oxyg"] = OXYGENATION_STATE_LOW
							if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
								crewmemberData["oxyg"] = OXYGENATION_STATE_VERY_LOW
							if(-(INFINITY) to BLOOD_VOLUME_BAD)
								crewmemberData["oxyg"] = OXYGENATION_STATE_NONE

					crewmemberData["bodytemp"] = H.bodytemperature - T0C

				if(C.sensor_mode >= SUIT_SENSOR_TRACKING)
					var/area/A = get_area(H)
					crewmemberData["area"] = A.name
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
#undef OXYGENATION_STATE_HIGH
#undef OXYGENATION_STATE_NORMAL
#undef OXYGENATION_STATE_LOW
#undef OXYGENATION_STATE_VERY_LOW
#undef OXYGENATION_STATE_NONE
#undef OXYGENATION_STATE_UNDEFINED
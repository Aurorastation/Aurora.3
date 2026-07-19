/// Lightweight log filename token
/proc/logging_session_token()
	return "[time2text(world.realtime, "YYYYMMDD-hhmmss")]-[world.timeofday]-[rand(100000, 999999)]"

/// Aurora compatibility helper for tg-style log timestamps.
/proc/server_timestamp(format = "hh:mm:ss", show_ds = FALSE, ic_time = FALSE, twelve_hour_clock = FALSE)
	var/time_source = ic_time ? world.time : world.timeofday

	if(twelve_hour_clock && format == "hh:mm:ss")
		var/hour = text2num(time2text(time_source, "hh"))
		var/suffix = hour >= 12 ? "PM" : "AM"
		hour %= 12
		if(!hour)
			hour = 12
		. = "[hour]:[time2text(time_source, "mm:ss")] [suffix]"
	else
		. = time2text(time_source, format)

	if(show_ds)
		. += ".[time_source % 10]"

/// Human-readable timestamp... tgstation uses fancy rustg shit even for this, but we dont have that, so you'll take this and like it.
/proc/logging_human_readable_timestamp()
	return "[time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")].[world.timeofday % 10]"

/// Converts a version string into a three-item numeric list, or null if invalid
/proc/semver_to_list(semver_string)
	if(!istext(semver_string))
		return null

	var/list/parts = splittext(semver_string, ".")
	if(length(parts) != 3)
		return null

	var/list/output = list()
	for(var/part in parts)
		var/version_component = text2num(part)
		if(!isnum(version_component))
			return null
		output += version_component

	return output

/// Minimal stable world state attached to each structured log line
/world/proc/get_world_state_for_logging()
	return list(
		"time" = world.time,
		"timeofday" = world.timeofday,
		"realtime" = world.realtime,
		"tick_lag" = world.tick_lag,
		"tick_usage" = TICK_USAGE,
	)

/// Default log serialization, specific datums can override this as later phases need richer data
/datum/proc/serialize_list(list/options, list/semvers)
	if(semvers)
		semvers[type] = options?[SCHEMA_VERSION] || LOG_CATEGORY_SCHEMA_VERSION_NOT_SET

	return list(
		"type" = "[type]",
		"ref" = REF(src),
	)

/atom/serialize_list(list/options, list/semvers)
	. = ..()
	.["name"] = name

	var/turf/location = get_turf(src)
	if(location)
		.["loc"] = list(
			"type" = "[location.type]",
			"ref" = REF(location),
			"x" = location.x,
			"y" = location.y,
			"z" = location.z,
		)

/mob/serialize_list(list/options, list/semvers)
	. = ..()
	.["ckey"] = ckey
	.["key"] = key

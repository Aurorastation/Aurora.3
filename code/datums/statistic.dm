/datum/statistic
	var/name
	var/key
	var/write_to_db = FALSE
	var/broadcast_at_roundend = TRUE

/datum/statistic/proc/set_value()
	WARNING("Statistic [type] does not have set_value implemented.")

/datum/statistic/proc/get_value()
	WARNING("Statistic [type] does not have get_value implemented.")

/datum/statistic/proc/increment_value()
	WARNING("Statistic [type] does not have increment_value implemented.")

/datum/statistic/proc/write_to_database()

/datum/statistic/proc/get_roundend_lines()	// Must be a string or something stringifiable.

/datum/statistic/proc/has_value()

// key-num pairs.
/datum/statistic/grouped
	var/list/values = list()

/datum/statistic/grouped/set_value(key, value)
	LAZYINITLIST(values[key])
	values[key] = value

/datum/statistic/grouped/get_value(key)
	return LAZYACCESS(values, key)

/datum/statistic/grouped/increment_value(key)
	set_value(key, get_value(key) + 1)

// Just a num.
/datum/statistic/numeric
	var/value = 0

/datum/statistic/numeric/set_value(val)
	value = val

/datum/statistic/numeric/get_value()
	return value

/datum/statistic/numeric/increment_value()
	value++

/datum/statistic/numeric/write_to_database()
	feedback_set(key, value)

/datum/statistic/numeric/get_roundend_lines()
	. = "[value]"

/datum/statistic/numeric/has_value()
	return value > 1

/datum/statistic/numeric/openturf_falls
	name = "Human Open Space Falls"
	key = "openturf_human_falls"
	write_to_db = TRUE

/datum/statistic/numeric/openturf_deaths
	name = "Human Open Space Fatalities"
	key = "openturf_human_deaths"
	write_to_db = TRUE

/datum/statistic/numeric/gibbings
	name = "Gibbings"
	key = "gibs"
	write_to_db = TRUE

/datum/statistic/numeric/clonings
	name = "Clones Produced"
	key = "clones"
	write_to_db = TRUE

/datum/statistic/numeric/people_hung
	name = "People Hung"
	key = "hangings"
	write_to_db = TRUE

/datum/statistic/numeric/self_slaps
	name = "Total Self-slaps"
	key = "selfslap"
	write_to_db = TRUE

/datum/statistic/numeric/ai_doors
	name = "Doors Opened by AI"
	key = "AI_DOOR"
	write_to_db = TRUE

/datum/statistic/numeric/messes
	name = "Total Janitor Tears"
	key = "messes_made"
	write_to_db = TRUE

/datum/statistic/numeric/swirlies
	name = "Swirlies Given"
	key = "swirlies"
	write_to_db = TRUE

/datum/statistic/numeric/mule_victims
	name = "MULE Victims"
	key = "mule_victims"
	write_to_db = TRUE

/datum/statistic/grouped/most_deaths
	name = "Most Overall Deaths (by ckey)"
	key = "ckey_deaths"

/datum/statistic/grouped/most_deaths/has_value()
	if (!values.len)
		return FALSE

	var/sum
	for (var/value in values)
		sum += values[value]

	if (sum != values.len)
		return TRUE

	return FALSE

/datum/statistic/grouped/most_deaths/get_roundend_lines()
	sortTim(values, /proc/cmp_numeric_dsc, TRUE)
	var/ckey = values[1]
	. = "[ckey], with [values[ckey]] deaths."

/hook/death/proc/increment_statistics(mob/living/carbon/human/H, gibbed)
	. = TRUE
	if (!H.ckey)
		return

	SSfeedback.IncrementGroupedStat("ckey_deaths", H.ckey)
	if (gibbed)
		SSfeedback.IncrementSimpleStat("gibs")

/hook/clone/proc/increment_statistics(mob/living/carbon/human/H)
	. = TRUE
	if (!H.ckey)
		return

	SSfeedback.IncrementSimpleStat("clones")

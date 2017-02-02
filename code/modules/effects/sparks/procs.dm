// -- Spark Procs --
/proc/spark(var/turf/loc, var/amount = 1, var/spread_dirs = null)
	if (!spread_dirs)
		spread_dirs = cardinal
	new /datum/effect_system/sparks(loc, TRUE, amount, spread_dirs)

/proc/get_spark(var/amount = 1, var/spread_dirs = alldirs)
	return new /datum/effect_system/sparks(src, FALSE, amount, spread_dirs)


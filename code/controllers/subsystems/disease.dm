var/datum/subsystem/diseases/SSdisease

/datum/subsystem/diseases
	name = "Diseases"
	flags = SS_KEEP_TIMING | SS_NO_INIT
	priority = SS_PRIORITY_DISEASE

	var/list/currentrun = list()

/datum/subsystem/diseases/New()
	NEW_SS_GLOBAL(SSdisease)

/datum/subsystem/diseases/stat_entry(msg)
	..("P:[active_diseases.len]")

/datum/subsystem/diseases/fire(resumed = 0)
	if (!resumed)
		src.currentrun = active_diseases.Copy()

	var/list/currentrun = src.currentrun

	while (currentrun.len)
		var/datum/disease/D = currentrun[currentrun.len]
		currentrun.len--

		D.process()

		if (MC_TICK_CHECK)
			return

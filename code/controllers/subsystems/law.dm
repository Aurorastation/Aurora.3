/var/global/datum/controller/subsystem/law/SSlaw

/datum/controller/subsystem/law
	name = "Law"
	flags = SS_NO_FIRE

	var/list/laws = list() // All laws
	var/list/low_severity = list()
	var/list/med_severity = list()
	var/list/high_severity = list()

/datum/controller/subsystem/law/New()
	NEW_SS_GLOBAL(SSlaw)

/datum/controller/subsystem/law/Initialize(timeofday)
	for (var/L in subtypesof(/datum/law/low_severity))
		low_severity += new L

	for (var/L in subtypesof(/datum/law/med_severity))
		med_severity += new L

	for (var/L in subtypesof(/datum/law/high_severity))
		high_severity += new L

	laws = low_severity + med_severity + high_severity

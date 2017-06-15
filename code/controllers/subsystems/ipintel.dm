var/datum/controller/subsystem/ipintel/SSipintel

/datum/controller/subsystem/ipintel
	name = "XKeyScore"
	init_order = SS_INIT_MISC_FIRST
	flags = SS_NO_FIRE
	var/enabled = 0 //disable at round start to avoid checking reconnects
	var/throttle = 0
	var/errors = 0

	var/list/cache = list()

/datum/controller/subsystem/ipintel/New()
	NEW_SS_GLOBAL(SSipintel)

/datum/controller/subsystem/ipintel/Initialize()
	enabled = 1
	. = ..()

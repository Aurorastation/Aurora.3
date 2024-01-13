SUBSYSTEM_DEF(ipintel)
	name = "XKeyScore"
	init_order = SS_INIT_MISC_FIRST
	flags = SS_NO_FIRE
	var/enabled = FALSE //disable at round start to avoid checking reconnects
	var/throttle = 0
	var/errors = 0

	var/list/cache = list()

/datum/controller/subsystem/ipintel/Initialize()
	enabled = TRUE

	return SS_INIT_SUCCESS

var/datum/controller/subsystem/nanoui/SSnanoui

/datum/controller/subsystem/nanoui
	name = "NanoUI"
	flags = SS_NO_INIT
	priority = SS_PRIORITY_NANOUI

	var/list/queued_uis = list()

/datum/controller/subsystem/nanoui/New()
	NEW_SS_GLOBAL(SSnanoui)

/datum/controller/subsystem/nanoui/stat_entry()
	..("P:[nanomanager.processing_uis.len]")

/datum/controller/subsystem/nanoui/fire(resumed = 0)
	if (!resumed)
		queued_uis = nanomanager.processing_uis.Copy()

	while (queued_uis.len)
		var/datum/nanoui/UI = queued_uis[queued_uis.len]
		queued_uis.len--

		if (QDELETED(UI))
			nanomanager.processing_uis -= UI
			continue

		UI.process()

		if (MC_TICK_CHECK)
			return

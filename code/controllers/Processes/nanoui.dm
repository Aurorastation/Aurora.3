/datum/controller/process/nanoui
	var/is_idle = TRUE
	var/list/queued_uis = list()

/datum/controller/process/nanoui/setup()
	name = "nanoui"
	schedule_interval = 2 SECONDS

/datum/controller/process/nanoui/statProcess()
	..()
	stat(null, "[nanomanager.processing_uis.len] UIs, [queued_uis.len] processing")

/datum/controller/process/nanoui/doWork()
	if (is_idle)
		queued_uis = nanomanager.processing_uis.Copy()
		is_idle = FALSE

	while (queued_uis.len)
		var/datum/nanoui/UI = queued_uis[queued_uis.len]
		queued_uis.len--
		
		if (!UI || UI.gcDestroyed)
			catchBadType(UI)
			nanomanager.processing_uis -= UI
			continue

		UI.process()
		SCHECK

	is_idle = TRUE

/*datum/controller/process/nanoui/doWork()
	for(last_object in nanomanager.processing_uis)
		var/datum/nanoui/NUI = last_object
		if(istype(NUI) && isnull(NUI.gcDestroyed))
			try
				NUI.process()
			catch(var/exception/e)
				catchException(e, NUI)
		else
			catchBadType(NUI)
			nanomanager.processing_uis -= NUI
*/

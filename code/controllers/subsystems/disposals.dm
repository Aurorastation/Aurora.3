/var/datum/subsystem/disposals/SSdisposals

/datum/subsystem/disposals
	name = "Disposals"
	wait = 1	// ticks
	flags = SS_NO_INIT | SS_TICKER
	var/list/obj/structure/disposalholder/holders
	var/tmp/list/obj/structure/disposalholder/processing_holders

/datum/subsystem/disposals/New()
	holders = list()
	NEW_SS_GLOBAL(SSdisposals)

/datum/subsystem/disposals/fire(resumed = FALSE)
	if (!resumed)
		processing_holders = holders.Copy()

	var/list/currentrun = processing_holders
	while (currentrun.len)
		var/obj/structure/disposalholder/holder = currentrun[currentrun.len]
		currentrun.len--

		if (QDELETED(holder) || !holder.tick() || !holder.active)
			holders -= holder

		if (MC_TICK_CHECK)
			return

/datum/subsystem/disposals/stat_entry()
	..("P:[holders.len]")

/datum/subsystem/disposals/proc/add_holder(obj/structure/disposalholder/holder)
	if (!QDELETED(holder))
		holders += holder
	else
		log_debug("SSdisposals: add_holder recieved QDELETED argument.")

/datum/subsystem/disposals/proc/remove_holder(obj/structure/disposalholder/holder)
	holders -= holder


/var/datum/controller/subsystem/assets/SSassets

/datum/controller/subsystem/assets
	name = "Assets"
	init_order = SS_INIT_MISC_FIRST
	flags = SS_NO_FIRE
	var/list/cache = list()

/datum/controller/subsystem/assets/New()
	NEW_SS_GLOBAL(SSassets)

/datum/controller/subsystem/assets/Initialize(timeofday)
	for(var/type in typesof(/datum/asset) - list(/datum/asset, /datum/asset/simple))
		var/datum/asset/A = new type()
		A.register()

	for(var/client/C in global.clients)
		addtimer(CALLBACK(GLOBAL_PROC, .proc/getFilesSlow, C, cache, FALSE), 10)
	..()

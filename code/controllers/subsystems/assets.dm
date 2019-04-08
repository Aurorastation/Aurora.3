/var/datum/controller/subsystem/assets/SSassets

/datum/controller/subsystem/assets
	name = "Assets"
	init_order = SS_INIT_MISC_FIRST
	flags = SS_BACKGROUND | SS_FIRE_IN_LOBBY
	wait = 1
	var/list/cache = list()
	var/list/target_clients = list()
	var/list/currentrun

/datum/controller/subsystem/assets/New()
	NEW_SS_GLOBAL(SSassets)

/datum/controller/subsystem/assets/stat_entry()
	..("C:[target_clients.len]")

/datum/controller/subsystem/assets/Initialize(timeofday)
	for(var/type in typesof(/datum/asset) - list(/datum/asset, /datum/asset/simple))
		var/datum/asset/A = new type()
		A.register()
		CHECK_TICK

	for (var/client/C in global.clients)
		handle_connect(C)
	..()

/datum/controller/subsystem/assets/proc/handle_disconnect(client/C)
	target_clients -= C
	if (currentrun)
		currentrun -= C

/datum/controller/subsystem/assets/proc/handle_connect(client/C)
	if (!C)
		CRASH("Client is missing.")

	target_clients[C] = cache.Copy()
	if (suspended)
		wake()

/datum/controller/subsystem/assets/fire(resumed = 0)
	if (!resumed)
		currentrun = target_clients.Copy()

	if (!target_clients.len)
		suspend()

	while (currentrun.len)
		var/client/C = currentrun[currentrun.len]
		currentrun.len--

		if (!C)
			continue

		var/list/c_files = target_clients[C]

		if (!c_files.len)
			target_clients -= C
		else
			send_asset(C, c_files[1], FALSE)
			c_files.Cut(1, 2)

		if (MC_TICK_CHECK)
			return

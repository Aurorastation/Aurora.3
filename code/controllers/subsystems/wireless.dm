var/datum/controller/subsystem/wireless/SSwireless

/datum/controller/subsystem/wireless
	name = "Wireless"
	flags = SS_BACKGROUND
	priority = SS_PRIORITY_WIRELESS
	init_order = SS_INIT_WIRELESS

	var/list/receiver_list = list()
	var/list/pending_connections = list()
	var/list/retry_connections = list()
	var/list/failed_connections = list()

	var/total_processed_connections = 0

/datum/controller/subsystem/wireless/New()
	NEW_SS_GLOBAL(SSwireless)

/datum/controller/subsystem/wireless/Recover()
	receiver_list = SSwireless.receiver_list

/datum/controller/subsystem/wireless/stat_entry()
	..("RL:[receiver_list.len] PC:[pending_connections.len] RC:[retry_connections.len] FC:[failed_connections.len] TC:[total_processed_connections]")

/datum/controller/subsystem/wireless/proc/add_device(datum/wifi/receiver/R)
	LAZYINITLIST(receiver_list)
	receiver_list |= R

	wake()

/datum/controller/subsystem/wireless/proc/remove_device(datum/wifi/receiver/R)
	if (receiver_list)
		receiver_list -= R

/datum/controller/subsystem/wireless/proc/add_request(datum/connection_request/C)
	LAZYADD(pending_connections, C)

/datum/controller/subsystem/wireless/proc/process_connection(datum/connection_request/connection, list/fail_queue)
	var/target_found = 0
	for (var/datum/wifi/receiver/R in receiver_list)
		if (R.id == connection.id)
			var/datum/wifi/sender/S = connection.source
			S.connect_device(R)
			R.connect_device(S)
			target_found = 1
	if (!target_found)
		fail_queue += connection

	total_processed_connections += 1

/datum/controller/subsystem/wireless/Initialize()
	fire(0, 1)
	fire(0, 1)	// So we suspend.
	..()

/datum/controller/subsystem/wireless/fire(resumed = 0, no_mc_check = 0)
	if (!resumed && !LAZYLEN(pending_connections) && !LAZYLEN(retry_connections))
		suspend()
		return

	var/list/pending = pending_connections
	var/list/retry = retry_connections

	while (retry.len)
		var/datum/connection_request/C = retry[retry.len]
		retry.len--

		process_connection(C, failed_connections)

		if (no_mc_check)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			return

	while (pending.len)
		var/datum/connection_request/C = pending[pending.len]
		pending.len--

		process_connection(C, retry_connections)

		if (no_mc_check)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			return

var/datum/controller/subsystem/wireless/SSwireless

/datum/controller/subsystem/wireless
	name = "Wireless"
	flags = SS_NO_INIT | SS_BACKGROUND
	priority = SS_PRIORITY_WIRELESS

	var/list/receiver_list = list()
	var/list/pending_connections = list()
	var/list/retry_connections = list()
	var/list/failed_connections = list()

	var/tmp/list/retry_queue = list()
	var/tmp/list/pending_queue = list()

	var/total_processed_connections = 0

/datum/controller/subsystem/wireless/New()
	NEW_SS_GLOBAL(SSwireless)

/datum/controller/subsystem/wireless/Recover()
	receiver_list = SSwireless.receiver_list

/datum/controller/subsystem/wireless/stat_entry()
	..("RL:[receiver_list.len] PC:[pending_connections.len] RC:[retry_connections.len] FC:[failed_connections.len] TC:[total_processed_connections]")

/datum/controller/subsystem/wireless/proc/add_device(datum/wifi/receiver/R)
	if(receiver_list)
		receiver_list |= R
	else
		receiver_list = new()
		receiver_list |= R

	wake()

/datum/controller/subsystem/wireless/proc/remove_device(datum/wifi/receiver/R)
	if (receiver_list)
		receiver_list -= R

/datum/controller/subsystem/wireless/proc/add_request(datum/connection_request/C)
	if (pending_connections)
		pending_connections += C

	else
		pending_connections = new()
		pending_connections += C

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

/datum/controller/subsystem/wireless/fire(resumed = 0)
	if (!resumed)
		retry_queue = retry_connections.Copy()
		pending_queue = pending_connections.Copy()
		retry_connections = list()
		pending_connections = list()

		if (!retry_queue.len && !pending_queue.len)
			suspend()
			return

	while (retry_queue.len)
		var/datum/connection_request/C = retry_queue[retry_queue.len]
		retry_queue.len--

		process_connection(C, failed_connections)

		if (MC_TICK_CHECK)
			return

	while (pending_queue.len)
		var/datum/connection_request/C = pending_queue[pending_queue.len]
		pending_queue.len--

		process_connection(C, retry_connections)

		if (MC_TICK_CHECK)
			return

var/datum/subsystem/wireless/SSwireless

/datum/subsystem/wireless
	name = "Wireless"
	//init_order = SS_INIT_WIRELESS

	var/list/receiver_list = list()
	var/list/pending_connections = list()
	var/list/retry_connections = list()
	var/list/failed_connections = list()

	var/tmp/list/retry_queue = list()
	var/tmp/list/pending_queue = list()

/datum/subsystem/wireless/New()
	NEW_SS_GLOBAL(SSwireless)

/datum/subsystem/wireless/stat_entry()
	..("")

/datum/subsystem/wireless/proc/add_device(var/datum/wifi/reciever/R)
	if(receiver_list)
		receiver_list |= R
	else
		receiver_list = new()
		receiver_list |= R

/datum/subsystem/wireless/proc/remove_device(var/datum/wifi/reciever/R)
	if (receiver_list)
		receiver_list -= R

/datum/subsystem/wireless/proc/add_request(var/datum/connection_request/C)
	if (pending_connections)
		pending_connections += C

	else
		pending_connections = new()
		pending_connections += C

#define PROCESS_CONNECTION(CONNECTION, FAILURE_QUEUE)	 \
	var/target_found = 0;                                \
	for (var/datum/wifi/reciever/R in reciever_list) {   \
		if (R.id = CONNECTION.id) {                      \
			var/datum/wifi/sender/S = CONNECTION.source; \
			S.connect_device(R);                         \
			R.connect_device(S);                         \
			target_found = 1;                            \
		}                                                \ 
	}                                                    \
	if (!target_found) {                                 \
		FAILURE_QUEUE += CONNECTION;                     \
	}                                                    \

/datum/subsystem/wireless/fire(resumed = 0)
	if (!resumed)
		retry_queue = retry_connections.Copy()
		pending_queue = pending_connections.Copy()

	while (retry_queue.len)
		var/datum/connection_request/C = retry_queue[retry_queue.len]
		retry_queue.len--

		PROCESS_CONNECTION(C, failed_connections)

		if (MC_TICK_CHECK)
			return

	while (pending_queue.len)
		var/datum/connection_request/C = pending_queue[pending_queue.len]
		pending_queue.len--

		PROCESS_CONNECTION(C, retry_connections)

		if (MC_TICK_CHECK)
			return

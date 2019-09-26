/var/datum/controller/subsystem/chat/SSchat

/datum/controller/subsystem/chat
	name = "VuChat"
	init_order = SS_INIT_MISC_FIRST
	flags = SS_TICKER | SS_NO_INIT
	priority = SS_PRIORITY_CHAT
	wait = 1

	var/list/queue = list()

/datum/controller/subsystem/chat/fire(resumed)
	for(var/i in queue)
		var/datum/chat/C = i
		C.ProcessQueue()
		queue -= C

		if(MC_TICK_CHECK)
			return
	
/datum/controller/subsystem/chat/proc/Queue(var/list/chats)
	queue += chats
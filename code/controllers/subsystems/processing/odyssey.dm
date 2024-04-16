PROCESSING_SUBSYSTEM_DEF(odyssey)
	name = "Odyssey"
	init_order = INIT_ORDER_ODYSSEY
	flags = SS_BACKGROUND|SS_NO_FIRE
	wait = 8

	var/singleton/situation/situation

/datum/controller/subsystem/processing/odyssey/Initialize()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/processing/odyssey/Recover()
	situation = SSodyssey.situation

/datum/controller/subsystem/processing/odyssey/proc/pick_situation()
	var/list/all_situations = GET_SINGLETON_SUBTYPE_LIST(/singleton/situation)
	var/list/possible_situations = list()
	for(var/singleton/situation/S in all_situations)
		if(SSatlas.current_sector.name in S.sector_whitelist)
			possible_situations[S] = S.weight

	if(!length(possible_situations))
		log_and_message_admins(SPAN_DANGER(FONT_HUGE("CRITICAL ERROR: NO MISSIONS WERE AVAILABLE FOR THIS SECTOR! CHANGE THE GAMEMODE MANUALLY!")))
		return

	situation = pickweight(possible_situations)
	flags &= ~SS_NO_FIRE

var/datum/controller/subsystem/away/SSaway

/datum/controller/subsystem/away
	name = "Away Mission"
	priority = SS_PRIORITY_CHEMISTRY
	init_order = SS_INIT_MISC_FIRST

	var/list/good_maps = list("iceland")

/datum/controller/subsystem/away/New()
	NEW_SS_GLOBAL(SSaway)
		
/datum/controller/subsystem/away/Initialize()
	if(config.awaymissions && prob(config.awaymissionsprob))
		find_away_mission()
	. = ..()

/datum/controller/subsystem/away/proc/find_away_mission()
	if(!good_maps.len)
		return 0
	var/A = pick(good_maps)
	var/dmm_suite/loader = new
	loader.load_map("maps/away/[A].dmm")
	qdel(loader)
	return 1
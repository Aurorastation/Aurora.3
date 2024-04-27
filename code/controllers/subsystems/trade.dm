SUBSYSTEM_DEF(trade)
	name = "Trade"
	wait = 1 MINUTE
	runlevels = RUNLEVELS_PLAYING
	var/list/traders = list() //List of all nearby traders

/datum/controller/subsystem/trade/Initialize()
	for(var/i in 1 to rand(1,3))
		generateTrader(1)

	return SS_INIT_SUCCESS

/datum/controller/subsystem/trade/Recover()
	traders = SStrade.traders

/datum/controller/subsystem/trade/fire()
	for(var/a in traders)
		var/datum/trader/T = a
		if(!T.tick())
			traders -= T
			qdel(T)

		if(!T.system_allowed())
			traders -= T
			qdel(T)
			generateTrader()

	if(prob(100-traders.len*10))
		generateTrader()

/datum/controller/subsystem/trade/proc/generateTrader(var/stations = 0)
	var/list/possible = list()
	if(stations)
		possible += subtypesof(/datum/trader) - typesof(/datum/trader/ship)
	else
		if(prob(5))
			possible += subtypesof(/datum/trader/ship/unique)
		else
			possible += subtypesof(/datum/trader/ship) - typesof(/datum/trader/ship/unique)

	for(var/i in 1 to 10)
		var/type = pick(possible)
		var/bad = 0
		for(var/trader in traders)
			if(istype(trader,type))
				bad = 1
				break
		if(bad)
			continue
		traders += new type
		return

/var/global/datum/controller/subsystem/trade/SStrade

/datum/controller/subsystem/trade
	name = "Trade"
	wait = 1 MINUTE

	var/list/traders = list() //List of all nearby traders
	var/list/currentrun = list()

	var/list/trade_stations_only	// A list of only trade station types.
	var/list/trade_ships	// A list of non-unique, non-station trader types.
	var/list/trade_unique	// A list of unique trader types.

	var/list/item_list_cache = list()

/datum/controller/subsystem/trade/New()
	NEW_SS_GLOBAL(SStrade)

/datum/controller/subsystem/trade/Initialize()
	// Build our type lists.
	trade_stations_only = subtypesof(/datum/trader) - typesof(/datum/trader/ship)
	trade_ships = subtypesof(/datum/trader/ship) - typesof(/datum/trader/ship/unique)
	trade_unique = subtypesof(/datum/trader/ship/unique)

	for(var/i in 1 to rand(1,3))
		generateTrader(1)

	..()

/datum/controller/subsystem/trade/Recover()
	traders = SStrade.traders
	trade_stations_only = SStrade.trade_stations_only
	trade_ships = SStrade.trade_ships
	trade_unique = SStrade.trade_unique

/datum/controller/subsystem/trade/fire(resumed = FALSE)
	if (!resumed)
		currentrun = traders.Copy()

	while (currentrun.len)
		var/datum/trader/T = currentrun[currentrun.len]
		currentrun.len -= 1

		if (T.tick())
			T.readjust_pool()
		else
			qdel(T)

		if (MC_TICK_CHECK)
			return

	if(prob(100-traders.len*10))
		generateTrader()

/datum/controller/subsystem/trade/proc/generateTrader(var/stations = 0)
	var/list/possible
	if(stations)
		possible = trade_stations_only
	else
		if(prob(5))
			possible = trade_unique
		else
			possible = trade_ships

		for(var/i in 1 to 10)
			var/type = pick(possible)
			if (locate(type) in traders)
				continue
				new type
			return

/datum/controller/subsystem/trade/proc/FlattenItemList(list/tradelist, key)
	if (item_list_cache[key])
		return item_list_cache[key]

	. = list()
	for (var/t in tradelist)
		var/status = tradelist[t]
		if(status & TRADER_THIS_TYPE)
			. += t
		if(status & TRADER_SUBTYPES_ONLY)
			. += subtypesof(t)
		if(status & TRADER_BLACKLIST)
			. -= t
		if(status & TRADER_BLACKLIST_SUB)
			. -= subtypesof(t)

	// Scan through the list quickly and make sure no funky types made it into the list.
	//  We're checking name instead of types to hopefully catch bad subtypes too.
	for (var/t in .)
		var/atom/A = t
		switch (initial(A.name))
			if ("object", "item","weapon", "structure", "machinery", "Mecha", "organ", "snack")
				. -= t

	log_ss("trade", "[key] => [length(.)]")
	item_list_cache[key] = .

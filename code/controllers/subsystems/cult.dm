#define DEFAULT_MAX_RUNES   25
/var/datum/controller/subsystem/cult/SScult

/datum/controller/subsystem/cult
	name = "Cult"
	flags = SS_NO_FIRE

	var/list/runes          = list()
	var/list/runes_by_name  = list()
	var/list/rune_list      = list()
	var/rune_limit          = DEFAULT_MAX_RUNES //in the SS so admins can easily modify it if needed
	var/rune_boost          = 0

/datum/controller/subsystem/cult/New()
	NEW_SS_GLOBAL(SScult)

/datum/controller/subsystem/cult/Initialize()
	. = ..()
	for(var/rune in subtypesof(/datum/rune))
		var/datum/rune/R = new rune
		runes += rune
		runes_by_name[R.name] = rune

/datum/controller/subsystem/cult/proc/add_rune(var/datum/rune/R)
	if(((length(rune_list) + rune_boost + length(cult.current_antagonists)) >= rune_limit) && R.special_checks())
		return FALSE
	else
		rune_list += R
		return TRUE

/datum/controller/subsystem/cult/proc/remove_rune(var/datum/rune/R)
	if(R in rune_list)
		rune_list -= R
		return TRUE
	else
		return FALSE

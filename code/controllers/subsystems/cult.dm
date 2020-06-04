#define DEFAULT_MAX_RUNES   25
/var/datum/controller/subsystem/cult/SScult

/datum/controller/subsystem/cult
	name = "Cult"
	flags = SS_NO_FIRE

	var/list/runes_by_name  = list()
	var/list/rune_list      = list()

	var/list/teleport_runes = list()
	var/list/static/teleport_network = list("Vernuth", "Koglan", "Irgros", "Akon")

	var/rune_limit          = DEFAULT_MAX_RUNES //in the SS so admins can easily modify it if needed
	var/rune_boost          = 0
	var/tome_data           = ""

/datum/controller/subsystem/cult/New()
	NEW_SS_GLOBAL(SScult)

/datum/controller/subsystem/cult/Initialize()
	. = ..()
	for(var/rune in subtypesof(/datum/rune))
		var/datum/rune/R = new rune
		runes_by_name[R.name] = rune
		tome_data += "<b>[R.name]</b>: <i>[R.desc]</i>"
		tome_data += "This rune [R.can_be_talisman() ? "<b><i>can</i></b>" : "<b><i>cannot</i></b>"] be turned into a talisman.<br>"

/datum/controller/subsystem/cult/proc/add_rune(var/datum/rune/R)
	if(check_rune_limit())
		return FALSE
	else
		rune_list += R
		return TRUE

/datum/controller/subsystem/cult/proc/check_rune_limit()
	return ((length(rune_list) + rune_boost + length(cult.current_antagonists)) >= rune_limit)

/datum/controller/subsystem/cult/proc/remove_rune(var/datum/rune/R)
	if(R in rune_list)
		rune_list -= R
		return TRUE
	else
		return FALSE

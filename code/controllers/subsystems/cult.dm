#define DEFAULT_MAX_RUNES   40
SUBSYSTEM_DEF(cult)
	name = "Cult"
	flags = SS_NO_FIRE

	var/list/runes_by_name  = list()
	var/list/rune_list      = list()
	var/list/limited_runes  = list()

	var/list/teleport_runes = list()
	var/list/static/teleport_network = list("Vernuth", "Koglan", "Irgros", "Akon")

	var/rune_limit          = DEFAULT_MAX_RUNES //in the SS so admins can easily modify it if needed
	var/rune_boost          = 0
	var/tome_data           = ""

/datum/controller/subsystem/cult/Initialize()
	for(var/rune in subtypesof(/datum/rune))
		var/datum/rune/R = new rune
		runes_by_name[R.name] = rune
		tome_data += "<div class='rune-block'>"
		tome_data += "<b>[capitalize_first_letters(R.name)]</b>: <i>[R.desc]</i><br>"
		tome_data += "This rune <b><i>[R.can_be_talisman() ? "can" : "cannot"]</i></b> be turned into a talisman.<br>"
		tome_data += "This rune <b><i>[R.can_memorize() ? "can" : "cannot"]</i></b> be memorized to be scribed without a tome.<br>"
		if(R.max_number_allowed)
			tome_data += "This rune has a special limit of <b><i>[R.max_number_allowed]</b></i> runes.<br><hr>"
			limited_runes[R.type] = R.max_number_allowed //The runes created will tick the counter down to zero.
		tome_data += "</div>"

	return SS_INIT_SUCCESS

/datum/controller/subsystem/cult/proc/add_rune(var/datum/rune/R)
	if(check_rune_limit(R))
		return FALSE
	else
		rune_list += R
		return TRUE

/datum/controller/subsystem/cult/proc/check_rune_limit(var/rune_type)
	if(rune_type && (rune_type in limited_runes))
		var/current_runes = limited_runes[rune_type]
		if(current_runes > 0)
			limited_runes[rune_type]--
			return FALSE
		else
			return TRUE
	else
		return ((length(rune_list) + rune_boost + length(cult.current_antagonists)) >= rune_limit)

/datum/controller/subsystem/cult/proc/remove_rune(var/datum/rune/R)
	if(R in rune_list)
		rune_list -= R
		if(R.type in limited_runes)
			limited_runes[R.type]++
		return TRUE
	else
		return FALSE

#undef DEFAULT_MAX_RUNES

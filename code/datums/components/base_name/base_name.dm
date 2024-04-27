/datum/component/base_name
	var/base_name

/datum/component/base_name/Initialize(var/name)
	base_name = name
	RegisterSignal(parent, COMSIG_BASENAME_RENAME, PROC_REF(rename))
	RegisterSignal(parent, COMSIG_BASENAME_SETNAME, PROC_REF(change_base_name))

/datum/component/base_name/proc/rename(var/name)
	base_name = name

/datum/component/base_name/proc/change_base_name(var/name, list/arguments)
	arguments[1] = base_name

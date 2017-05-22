//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/datum/data
	var/name = "data"
	var/size = 1.0


/datum/data/function
	name = "function"
	size = 2.0


/datum/data/function/data_control
	name = "data control"


/datum/data/function/id_changer
	name = "id changer"


/datum/data/record
	name = "record"
	size = 5.0
	var/list/fields = list()
	var/inDataCore = 0

/datum/data/record/Destroy()
	// Just remove us from everywhere. So we don't have to keep track of which list
	// we're in specifically.
	if (inDataCore && data_core)
		data_core.general	-= src
		data_core.medical	-= src
		data_core.security	-= src
		data_core.locked	-= src

	return ..()

/datum/data/text
	name = "text"
	var/data = null



/datum/debug
	var/list/debuglist

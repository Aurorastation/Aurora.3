/*
Datum representing program state on deamon and exposing apropriate procs to DM. 
*/
/datum/ntsl2_program/
	var/id = -1
	var/name = "Base NTSL2++ program"


/datum/ntsl2_program/New(var/id)
	src.id = id

	..()

/datum/ntsl2_program/proc/kill()
	SSntsl2.send("remove", list(id = id))
	SSntsl2.handle_termination(src)
	qdel(src)
	
/datum/ntsl2_program/proc/execute(var/script)
	return SSntsl2.send("execute", list(id = id, code = script))
/*
Datum representing program state on deamon and exposing apropriate procs to DM.
*/
/datum/ntsl2_program/
	var/id = 0
	var/name = "Base NTSL2++ program"

/datum/ntsl2_program/New()
	..()

/datum/ntsl2_program/proc/is_ready()
	return !!id

/datum/ntsl2_program/proc/kill()
	set waitfor = FALSE
	if(is_ready())
		SSntsl2.send("remove", list(id = id))
	SSntsl2.handle_termination(src)
	qdel(src)

/datum/ntsl2_program/proc/execute(var/script, var/scriptName = "unknown.nts", var/mob/user)
	set waitfor = FALSE
	UNTIL(is_ready())
	log_ntsl("[user.name]/[user.key] uploaded script to [src] : [script]", SEVERITY_NOTICE, user.ckey)
	SSntsl2.send("execute", list(id = id, scriptName = scriptName), RUSTG_HTTP_METHOD_POST, script)

/*
Datum representing program state on deamon and exposing apropriate procs to DM. 
*/
/datum/ntsl2_program/
	var/id = 0
	var/name = "Base NTSL2++ program"
	var/list/ready_tasks = list()


/datum/ntsl2_program/New()
	..()

/datum/ntsl2_program/proc/is_ready()
	return !!id

/datum/ntsl2_program/proc/kill()
	if(is_ready())
		SSntsl2.send_task("remove", list(id = id))
	SSntsl2.handle_termination(src)
	qdel(src)
	
/datum/ntsl2_program/proc/execute(var/script, var/mob/user)
	if(!is_ready())
		ready_tasks += CALLBACK(src, .proc/execute, script, user)
		return FALSE // We are not ready to run code
	log_ntsl("[user.name]/[user.key] uploaded script to [src] : [script]", SEVERITY_NOTICE, user.ckey)
	return SSntsl2.send_task("execute", list(id = id, code = script), program = src)
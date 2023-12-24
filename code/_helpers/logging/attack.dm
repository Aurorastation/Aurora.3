/// Generic attack logging
/proc/_log_attack(text)
	if (GLOB.config.logsettings["log_attack"])
		WRITE_LOG(GLOB.config.logfiles["world_attack_log"], "ATTACK: [text]")

/**
 * Log a combat message in the attack log
 *
 * Arguments:
 * * atom/user - argument is the actor performing the action
 * * atom/target - argument is the target of the action
 * * what_done - is a verb describing the action (e.g. punched, throwed, kicked, etc.)
 * * atom/object - is a tool with which the action was made (usually an item)
 * * addition - is any additional text, which will be appended to the rest of the log line
 */
/proc/log_combat(atom/user, atom/target, what_done, atom/object=null, addition=null)
	var/ssource = key_name(user)
	var/starget = key_name(target)

	var/mob/living/living_target = target
	var/hp = istype(living_target) ? " (NEWHP: [living_target.health]) " : ""

	var/sobject = ""
	if(object)
		sobject = " with [object]"
	var/saddition = ""
	if(addition)
		saddition = " [addition]"

	var/postfix = "[sobject][saddition][hp]"

	var/message = "[ssource] [what_done] [starget][postfix]"

	WRITE_LOG(GLOB.config.logfiles["combat_log"], message)
	SEND_TEXT(world.log, message)

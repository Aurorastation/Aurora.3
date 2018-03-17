/datum/research_concepts
	var/name = "Breathing"
	var/id = "breath"
	var/desc = "The fundamentals of breathing, how it works, and why it matters."
	var/level = 1
	var/maxlevel = 1
	var/progress = 1
	var/max_progress = 1
	var/relatedtechs = list(
					  TECH_BIO  = 2
					)
/datum/research_concepts/proc/update_progress(var/amt)
	progress += amt
	if(progress > max_progress)
		if(progress_level() == 0)
			//SSresearch.adjustpoints(amt/2)
			return 2
		else
			return 1
/datum/research_concepts/proc/progress_level()
	if(level == maxlevel)
		return 0
	level++
	//for(var/A in SSresearch.rdconsoles)
	//	var/obj/machinery/computer/rdconsole = A
		//rdconsole.updatetechs()
	return 1

/datum/research_concepts/proc/get_tech_desc(var/level = 1)
	if(level > maxlevel)
		return 0

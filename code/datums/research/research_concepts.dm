/datum/research_concepts
	var/name = "Breathing"
	var/id = "breath"
	var/short_desc = "The fundamentals of breathing, how it works, and why it matters."
	var/long_desc = "Research into this topic cover the intricacies of one of the core components of human life: Breathing. From exploring the composition of the air around us to the cell respiration that occurs in the lungs. Researching this concept can be a difficult task, but can prove quite rewarding to further devloping safe EVA techniques."
	var/level = 1
	var/maxlevel = 1
	var/progress = 1
	var/pre_req = list() // concepts that have to be researched first in order to get this.
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

/datum/research_concepts/proc/get_tech_desc(var/long = 0, var/level = 1)
	if(level > maxlevel)
		return 0

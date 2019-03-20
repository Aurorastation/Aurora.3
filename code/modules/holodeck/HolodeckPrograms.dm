/datum/holodeck_program
	var/target
	var/list/ambience = null
	var/loop_ambience = TRUE

/datum/holodeck_program/New(var/target, var/list/ambience = null, var/loop_ambience = TRUE)
	src.target = target
	src.ambience = ambience
	src.loop_ambience = loop_ambience

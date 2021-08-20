/datum/skill
	var/name = "Placeholder" // name of the skill
	var/desc = "Placeholder Skill" // detailed description of the skill
	var/field = "Misc" // the field under which the skill will be listed
	var/secondary = FALSE // secondary skills only have two levels and cost significantly less

/datum/skill/proc/skill_duration_multiplier(var/skill_level)
	switch(skill_level)
		if(SKILL_NONE)
			return 2
		if(SKILL_BASIC)
			return 1
		if(SKILL_ADEPT)
			return 0.8
		if(SKILL_EXPERT)
			return 0.6

/datum/skill/proc/skill_point_cost(var/skill_level)
	switch(skill_level)
		if(SKILL_NONE)
			return 0
		if(SKILL_BASIC)
			return 1
		if(SKILL_ADEPT)
			// secondary skills cost less
			if(secondary)
				return 1
			else
				return 3
		if(SKILL_EXPERT)
			// secondary skills cost less
			if(secondary)
				return 3
			else
				return 6

/datum/skill/management
	name = SKILL_LEADERSHIP
	desc = "Your ability to manage and commandeer other crew members."
	field = SKILL_FIELD_COMMAND

/datum/skill/athletics
	name = SKILL_ATHLETICS
	desc = "This skill describes your ability to move rapidly and nimbly, vaulting objects and obstacles that come in your way. In the modern era, fewer people have a need for this particular skill."
	field = SKILL_FIELD_SECURITY

/datum/skill/combat
	name = SKILL_CLOSE_COMBAT
	desc = "This skill describes your training in hand-to-hand combat or melee weapon usage. While expertise in this area is rare in the era of firearms, experts still exist among athletes."
	field = SKILL_FIELD_SECURITY

/datum/skill/weapons
	name = SKILL_WEAPONS_EXPERTISE
	desc = "This skill describes your expertise with and knowledge of weapons. A low level in this skill implies knowledge of simple weapons, for example tazers and flashes. A high level in this skill implies knowledge of complex weapons, such as grenades, riot shields, pulse rifles or bombs. A low level in this skill is typical for security officers, a high level of this skill is typical for special agents and soldiers."
	field = SKILL_FIELD_SECURITY

/datum/skill/forensics
	name = SKILL_FORENSICS
	desc = "Describes your skill at performing forensic examinations and identifying vital evidence. Does not cover analytical abilities, and as such isn't the only indicator for your investigation skill. Note that in order to perform autopsy, the surgery skill is also required."
	field = SKILL_FIELD_SECURITY

/datum/skill/eva
	name = "Extra-Vehicular Activity"
	desc = "This skill describes your skill and knowledge of space-suits and working in vacuum."
	field = SKILL_FIELD_ENGINEERING
	secondary = TRUE

/datum/skill/construction
	name = SKILL_CONSTRUCTION
	desc = "Your ability to construct various buildings, such as walls, floors, tables and so on. Note that constructing devices such as APCs additionally requires the Electronics skill. A low level of this skill is typical for janitors, a high level of this skill is typical for engineers."
	field = SKILL_FIELD_ENGINEERING

/datum/skill/electrical
	name = SKILL_ELECTRICAL
	desc = "This skill describes your knowledge of electronics and the underlying physics. A low level of this skill implies you know how to lay out wiring and configure powernets, a high level of this skill is required for working complex electronic devices such as circuits or bots."
	field = SKILL_FIELD_ENGINEERING

/datum/skill/atmos
	name = SKILL_ATMOSPHERICS
	desc = "Describes your knowledge of piping, air distribution and gas dynamics."
	field = SKILL_FIELD_ENGINEERING

/datum/skill/engines
	name = SKILL_ENGINES
	desc = "Describes your knowledge of the various engine types common on space stations, such as the singularity or anti-matter engine."
	field = SKILL_FIELD_ENGINEERING
	secondary = TRUE

/datum/skill/pilot
	name = SKILL_HEAVY_MACHINERY
	desc = "Describes your experience and understanding of operating heavy machinery, which includes mechs and other large exosuits. Used in piloting mechs."
	field = SKILL_FIELD_ENGINEERING

/datum/skill/devices
	name = SKILL_COMPLEX_DEVICES
	desc = "Describes the ability to assemble complex devices, such as computers, circuits, printers, robots or gas tank assemblies(bombs). Note that if a device requires electronics or programming, those skills are also required in addition to this skill."
	field = SKILL_FIELD_SCIENCE

/datum/skill/computer
	name = SKILL_COMPUTERS
	desc = "Describes your understanding of computers, software and communication. Not a requirement for using computers, but definitely helps. Used in telecommunications and programming of computers and AIs."
	field = SKILL_FIELD_SCIENCE

/datum/skill/chemistry
	name = SKILL_CHEMISTRY
	desc = "Experience with mixing chemicals, and an understanding of what the effect will be. This doesn't cover an understanding of the effect of chemicals on the human body, as such the medical skill is also required for medical chemists."
	field = SKILL_FIELD_SCIENCE

/datum/skill/medical
	name = SKILL_MEDICINE
	desc = "Covers an understanding of the human body and medicine. At a low level, this skill gives a basic understanding of applying common types of medicine, and a rough understanding of medical devices like the health analyzer. At a high level, this skill grants exact knowledge of all the medicine available on the station, as well as the ability to use complex medical devices like the body scanner or mass spectrometer."
	field = SKILL_FIELD_MEDICAL

/datum/skill/anatomy
	name = SKILL_ANATOMY
	desc = "Gives you a detailed insight of the human body. A high skill in this is required to perform surgery. This skill may also help in examining alien biology."
	field = SKILL_FIELD_MEDICAL

/datum/skill/botany
	name = SKILL_BOTANY
	desc = "Describes how good a character is at growing and maintaining plants."
	field = SKILL_FIELD_CIVILIAN

/datum/skill/cooking
	name = SKILL_COOKING
	desc = "Describes a character's skill at preparing meals and other consumable goods. This includes mixing alcoholic beverages."
	field = SKILL_FIELD_CIVILIAN

/mob/living/carbon/human/proc/GetSkillClass(points)
	return CalculateSkillClass(points, age)

var/global/list/all_skills = list()
var/global/list/skill_list = list()

/proc/setup_skills()
	for(var/T in subtypesof(/datum/skill))
		var/datum/skill/S = new T
		all_skills[S.name] = S
		LAZYADD(skill_list[S.field], S)

/proc/show_skill_window(var/mob/user, var/mob/living/carbon/human/M)
	if(!istype(M))
		return

	if(!length(skill_list))
		setup_skills()

	if(!length(M.skills))
		to_chat(user, "There are no skills to display.")
		return

	var/HTML = "<body>"
	HTML += "<b>Select your Skills</b><br>"
	HTML += "Current skill level: <b>[M.GetSkillClass(M.used_skillpoints)]</b> ([M.used_skillpoints])<br>"
	HTML += "<table>"
	for(var/V in skill_list)
		HTML += "<tr><th colspan = 5><b>[V]</b>"
		HTML += "</th></tr>"
		for(var/datum/skill/S in skill_list[V])
			var/level = M.skills[S.name]
			HTML += "<tr style='text-align:left;'>"
			HTML += "<th>[S.name]</th>"
			HTML += "<th><font color=[(level == SKILL_NONE) ? "red" : "black"]>\[Untrained\]</font></th>"
			// secondary skills don't have an amateur level
			if(S.secondary)
				HTML += "<th></th>"
			else
				HTML += "<th><font color=[(level == SKILL_BASIC) ? "red" : "black"]>\[Amateur\]</font></th>"
			HTML += "<th><font color=[(level == SKILL_ADEPT) ? "red" : "black"]>\[Trained\]</font></th>"
			HTML += "<th><font color=[(level == SKILL_EXPERT) ? "red" : "black"]>\[Professional\]</font></th>"
			HTML += "</tr>"
	HTML += "</table>"

	user << browse(null, "window=preferences")
	user << browse(HTML, "window=show_skills;size=600x800")
	return

/mob/living/carbon/human/verb/show_skills()
	set category = "IC"
	set name = "Show Own Skills"

	show_skill_window(src, src)

/mob/proc/has_required_skill(var/skill_name, var/skill_level)
	return FALSE

/mob/living/carbon/human/has_required_skill(var/skill_name, var/skill_level)
	if(skills[skill_name] && skills[skill_name] >= skill_level)
		return TRUE
	return FALSE

/mob/proc/get_skill_duration_multiplier(var/skill_name)
	return 1

/mob/living/carbon/human/get_skill_duration_multiplier(var/skill_name)
	if(skills[skill_name])
		var/datum/skill/S = all_skills[skill_name]
		return S.skill_duration_multiplier(skills[skill_name])
	return 2
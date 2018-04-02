#define	SKILL_NONE  0
#define	SKILL_BASIC  1
#define	SKILL_ADEPT  2
#define	SKILL_EXPERT  3
var/global/list/SKILLS = null
var/list/SKILL_ENGINEER = list("field" = "Engineering", "EVA" = SKILL_BASIC, "construction" = SKILL_ADEPT, "electrical" = SKILL_BASIC, "engines" = SKILL_ADEPT)
var/list/SKILL_ORGAN_ROBOTICIST = list("field" = "Science", "devices" = SKILL_ADEPT, "electrical" = SKILL_BASIC, "computer" = SKILL_ADEPT, "anatomy" = SKILL_BASIC)
var/list/SKILL_SECURITY_OFFICER = list("field" = "Security", "combat" = SKILL_BASIC, "weapons" = SKILL_ADEPT, "law" = SKILL_ADEPT, "forensics" = SKILL_BASIC)
var/list/SKILL_CHEMIST = list("field" = "Science", "chemistry" = SKILL_ADEPT, "science" = SKILL_ADEPT, "medical" = SKILL_BASIC, "devices" = SKILL_BASIC)
var/list/SKILL_JANITOR = list("field" = "Engineering", "electrical" = SKILL_BASIC, "devices" = SKILL_BASIC, "construction" = SKILL_BASIC)
var/global/list/SKILL_PRE = list("Janitor" = SKILL_JANITOR, "Engineer" = SKILL_ENGINEER, "Roboticist" = SKILL_ORGAN_ROBOTICIST, "Security Officer" = SKILL_SECURITY_OFFICER, "Chemist" = SKILL_CHEMIST)

/datum/skillsystem/


/datum/skillsystem/skill/
    var/ID = "none" // ID of the skill, used in code
    var/name = "None" // name of the skill
    var/desc = "Placeholder skill" // detailed description of the skill
    var/field = "Misc" // the field under which the skill will be listed
    var/secondary = 0 // secondary skills only have two levels and cost significantly less

/datum/attribute/var
	ID = "none"
	name = "None"
	desc = "This is a placeholder"

/datum/skillsystem/proc/CalculateSkillClass(points, age)
	if(points <= 0) return "Unconfigured"
	// skill classes describe how your character compares in total points
	points -= min(round((age - 20) / 2.5), 4) // every 2.5 years after 20, one extra skillpoint
	if(age > 30)
		points -= round((age - 30) / 5) // every 5 years after 30, one extra skillpoint
	switch(points)
		if(-1000 to 3)
			return "Terrifying"
		if(4 to 6)
			return "Below Average"
		if(7 to 10)
			return "Average"
		if(11 to 14)
			return "Above Average"
		if(15 to 18)
			return "Exceptional"
		if(19 to 24)
			return "Genius"
		if(24 to 1000)
			return "God"

/datum/skillsystem/proc/setup_skills()
	if(SKILLS == null)
		SKILLS = list()
		for(var/T in (typesof(/datum/skillsystem/skill/)-/datum/skillsystem/skill))
			var/datum/skillsystem/skill/S = new T
			if(S.ID != "none")
				if(!SKILLS.Find(S.field))
					SKILLS[S.field] = list()
				var/list/L = SKILLS[S.field]
				L += S


/mob/living/carbon/human/proc/GetSkillClass(points)
	return gskillsystem.CalculateSkillClass(points, age)

/proc/show_skill_window(var/mob/user, var/mob/living/carbon/human/M)
	if(!istype(M)) return
	if(SKILLS == null)
		gskillsystem.setup_skills()

	if(!M.skills || M.skills.len == 0)
		user << "There are no skills to display."
		return

	var/HTML = "<body>"
	HTML += "<b>Select your Skills</b><br>"
	HTML += "Current skill level: <b>[M.GetSkillClass(M.used_skillpoints)]</b> ([M.used_skillpoints])<br>"
	HTML += "<table>"
	for(var/V in SKILLS)
		HTML += "<tr><th colspan = 5><b>[V]</b>"
		HTML += "</th></tr>"
		for(var/datum/skillsystem/skill/S in SKILLS[V])
			var/level = M.skills[S.ID]
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

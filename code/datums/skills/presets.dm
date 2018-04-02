var/list/SKILL_ENGINEER = list("field" = "Engineering", "EVA" = SKILL_BASIC, "construction" = SKILL_ADEPT, "electrical" = SKILL_BASIC, "engines" = SKILL_ADEPT)
var/list/SKILL_ORGAN_ROBOTICIST = list("field" = "Science", "devices" = SKILL_ADEPT, "electrical" = SKILL_BASIC, "computer" = SKILL_ADEPT, "anatomy" = SKILL_BASIC)
var/list/SKILL_SECURITY_OFFICER = list("field" = "Security", "combat" = SKILL_BASIC, "weapons" = SKILL_ADEPT, "law" = SKILL_ADEPT, "forensics" = SKILL_BASIC)
var/list/SKILL_CHEMIST = list("field" = "Science", "chemistry" = SKILL_ADEPT, "science" = SKILL_ADEPT, "medical" = SKILL_BASIC, "devices" = SKILL_BASIC)
var/list/SKILL_JANITOR = list("field" = "Engineering", "electrical" = SKILL_BASIC, "devices" = SKILL_BASIC, "construction" = SKILL_BASIC)
var/list/SKILL_PRE = list()

/datum/skillsystem/preset
	var/name
	var/id
	var/field
	var/list/skills

/datum/skillsystem/preset/proc/populate()
	var/setup[0]
	for(var/datum/skillsystem/preset/preset in subtypesof(/datum/skillsystem/preset))
		setup[++setup.len] = list("name" = preset.name, "id" = preset.id,  "field" = preset.field, "skills" = preset.skills)
	SKILL_PRE = setup
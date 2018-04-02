var/list/SKILL_PRE = list()

/datum/skillsystem/preset
	var/name
	var/field
	var/list/skills

/datum/skillsystem/preset/proc/populate()
	var/list/setup = list()
	var/list/T = list()
	init_subtypes(/datum/skillsystem/preset, T)
	for(var/A in T)
		var/datum/skillsystem/preset/preset = A
		setup[preset.name] = list("name" = preset.name, "field" = preset.field, "skills" = preset.skills)
	SKILL_PRE = setup

/datum/skillsystem/preset/engineer
	name = "Engineer"
	field = "Engineering"
	skills = list(
	"EVA" = SKILL_BASIC,
	"construction" = SKILL_ADEPT,
	"electrical" = SKILL_ADEPT,
	"engines" = SKILL_ADEPT
	)

/datum/skillsystem/preset/robot
	name = "Roboticist"
	field = "Science"
	skills = list(
	"devices" = SKILL_ADEPT,
	"computer" = SKILL_ADEPT,
	"electrical" = SKILL_BASIC,
	"anatomy" = SKILL_BASIC
	)

/datum/skillsystem/preset/janitor
	name = "Janitor"
	field = "Engineering"
	skills = list(
	"electrical" = SKILL_BASIC,
	"devices" = SKILL_BASIC,
	"construction" = SKILL_BASIC
	)

/datum/skillsystem/preset/securityofficer
	name = "Security Officer"
	field = "Security"
	skills = list(
	"combat" = SKILL_BASIC,
	"weapons" = SKILL_ADEPT,
	"law" = SKILL_ADEPT,
	"forensics" = SKILL_BASIC
	)

/datum/skillsystem/preset/medchemist
	name = "Medical Chemist"
	field = "Medical"
	skills = list(
	"chemistry" = SKILL_ADEPT,
	"science" = SKILL_BASIC,
	"medical" = SKILL_ADEPT,
	"devices" = SKILL_BASIC
	)
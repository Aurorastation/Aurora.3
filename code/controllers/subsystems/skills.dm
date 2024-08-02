SUBSYSTEM_DEF(skills)
	name = "Skills"
	flags = SS_NO_FIRE

	/// This is essentially the list we use to read skills in the character setup.
	var/list/skill_tree = list()
	/// A map of all the skill levels to their definition.
	var/list/skill_level_map = list(
		"Unfamiliar" = "You don't know anything about this subject.",
		"Familiar" = "You're familiar with this subject, either by reading into it or by doing some courses.",
		"Trained" = "You've been formally trained in this subject. Typically, this is the minimum level for a job.",
		"Professional" = "You have a lot of training and a good amount of experience in this subject."
	)

/datum/controller/subsystem/skills/Initialize()
	. = ..()
	for(var/singleton/skill/skill in GET_SINGLETON_SUBTYPE_LIST(/singleton/skill))
		skill_tree[skill.category] = skill.subcategory
		if(!islist(skill_tree[skill.category][skill.subcategory]))
			skill_tree[skill.category][skill.subcategory] = list()
		skill_tree[skill.category][skill.subcategory] |= skill

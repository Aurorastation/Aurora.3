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
	/// The set of all skills that are "forced" in order to guarantee necessary components are applied.
	var/list/required_skills = list()

/datum/controller/subsystem/skills/Initialize()
	// Initialize the skill category lists first.
	// This creates linked lists as follows: "Science" -> empty list
	for(var/singleton/skill_category/skill_category in GET_SINGLETON_SUBTYPE_LIST(/singleton/skill_category))
		skill_tree[skill_category] = list()

	// Now, initialize all the skills.
	// What actually goes on here: we want a tree that we can traverse programmatically.
	// To do that, we first of all make empty lists above with all the categories (they're singletons so we can easily iterate over them).
	// Next, we add the empty subcategory lists if they're not present. At this point, the tree would look like "Combat" -> "Melee" -> empty list
	// After that's done, if our skill is not present, add it to the empty list of the subcategory.
	for(var/singleton/skill/skill in GET_SINGLETON_SUBTYPE_LIST(/singleton/skill))
		if (skill.required)
			required_skills += skill.type
		var/singleton/skill_category/skill_category = GET_SINGLETON(skill.category)
		if(!(skill.subcategory in skill_tree[skill_category]))
			skill_tree[skill_category] |= skill.subcategory
			skill_tree[skill_category][skill.subcategory] = list()

		if(!(skill in skill_tree[skill_category][skill.subcategory]))
			skill_tree[skill_category][skill.subcategory] |= skill
	return SS_INIT_SUCCESS

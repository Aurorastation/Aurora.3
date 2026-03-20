SUBSYSTEM_DEF(skills)
	name = "Skills"
	flags = SS_NO_FIRE

	/// This is essentially the list we use to read skills in the character setup.
	var/list/skill_tree = list()

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

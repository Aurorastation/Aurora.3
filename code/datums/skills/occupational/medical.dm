/singleton/skill/medicine
	name = "Medicine"
	description = "how to use health analyzers, ATKs, syringes"
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_FAMILIAR
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_MEDICAL
	required = TRUE

/singleton/skill/medicine/on_spawn(mob/owner, skill_level)
	if (!owner)
		return

	owner.AddComponent(MEDICINE_SKILL_COMPONENT, skill_level)

/singleton/skill/surgery
	name = "Surgery"
	description = "the one everyone wants to do in medical to be the protag"
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_UNFAMILIAR
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_MEDICAL

/singleton/skill/pharmacology
	name = "Pharmacology"
	description = "why are you playing pharma LOL"
	uneducated_skill_cap = SKILL_LEVEL_UNFAMILIAR
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_MEDICAL

/singleton/skill/anatomy
	name = "Anatomy"
	description = "this one lets you know what's wrong with people"
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_FAMILIAR
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_MEDICAL

/singleton/skill/forensics
	name = "Forensics"
	description = "forensics shit i guess"
	uneducated_skill_cap = SKILL_LEVEL_UNFAMILIAR
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_MEDICAL

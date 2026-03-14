/singleton/skill/electrical_engineering
	name = "Electrical Engineering"
	description = "Not currently implemented"
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_FAMILIAR
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_ENGINEERING
	required = TRUE
	component_type = ELECTRICAL_ENGINEERING_SKILL_COMPONENT

/singleton/skill/mechanical_engineering
	name = "Mechanical Engineering"
	description = "Mechanical engineering has to do with general construction of objects, walls, windows, and so on. It is also necessary for the usage of heavy machinery \
				such as emitters. This skill is also commonly used for crafting items out of raw materials, and heavily governs the quality of said objects."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_FAMILIAR
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_ENGINEERING
	required = TRUE
	component_type = MECHANICAL_ENGINEERING_SKILL_COMPONENT
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have little to no experience working with physical machinery.<br>" \
			+ " - Items you craft will typically be of low quality.<br>" \
			+ " - You take twice as long to craft anything.<br>" \
			+ " - You cannot craft any object that requires this skill.<br>" \
			+ " - You cannot interact with most Engineering machinery.",
		SKILL_LEVEL_FAMILIAR = "You have some experience working with physical machinery, though are not formally trained.<br>" \
			+ " - Items you craft will be of slightly lower than average quality.<br>" \
			+ " - You take 50% longer to craft anything.<br>" \
			+ " - You can interact with some Engineering-related machinery.",
		SKILL_LEVEL_TRAINED = "You have formal training in general Engineering concepts, equivalent to a Bachelor's Degree. <br>" \
			+ " - You can craft items at the standard speed.<br>" \
			+ " - Items you craft are generally at average quality.<br>" \
			+ " - You can interact with most if not all Engineering equipment.",
		SKILL_LEVEL_PROFESSIONAL = "You have many years of training in general Engineering concepts, equivalent to a Master's Degree or better.<br>" \
			+ " - You can craft items significantly faster.<br>" \
			+ " - Items you craft are of much higher quality on average.<br>" \
	)

/singleton/skill/atmospherics_systems
	name = "Atmospherics Systems"
	description = "Not currently implemented."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_UNFAMILIAR
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_ENGINEERING
	required = TRUE
	component_type = ATMOSPHERICS_SYSTEMS_SKILL_COMPONENT

/singleton/skill/reactor_systems
	name = "Reactor Systems"
	description = "Reactor systems envelops anything used for reactors, such as the computers and gyrotrons for the INDRA. It is also necessary to correctly interpret information \
				from reactor monitoring programs."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_UNFAMILIAR
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_ENGINEERING
	required = TRUE
	component_type = REACTOR_SYSTEMS_SKILL_COMPONENT
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have little to no experience working with Reactor systems.<br>" \
			+ " - You cannot interact with Reactor computers such as the INDRA controllers.",
		SKILL_LEVEL_FAMILIAR = "You have some experience working with physical machinery, though are not formally trained.<br>" \
			+ " - You cannot interact with Reactor computers such as the INDRA controller.",
		SKILL_LEVEL_TRAINED = "You have formal training in general Engineering concepts, equivalent to a Bachelor's Degree. <br>" \
			+ " - This is the minimum skill level required to operate the INDRA.",
		SKILL_LEVEL_PROFESSIONAL = "You have many years of training in general Engineering concepts, equivalent to a Master's Degree or better.<br>" \
			+ " - Not currently implemented differently from Trained." \
	)

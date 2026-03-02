/singleton/skill/electrical_engineering
	name = "Electrical Engineering"
	description = "Electrical engineering has to do with anything that involves wires and electricity. This includes things such as hacking doors, machines, but also \
					laying down wires, or repairing wiring damage in prosthetics."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_FAMILIAR
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_ENGINEERING
	required = TRUE

/singleton/skill/electrical_engineering/on_spawn(mob/owner, skill_level)
	if (!owner)
		return

	owner.AddComponent(ELECTRICAL_ENGINEERING_SKILL_COMPONENT, skill_level)

/singleton/skill/mechanical_engineering
	name = "Mechanical Engineering"
	description = "Mechanical engineering has to do with general construction of objects, walls, windows, and so on. It is also necessary for the usage of heavy machinery \
				such as emitters."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_FAMILIAR
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_ENGINEERING
	required = TRUE

/singleton/skill/mechanical_engineering/on_spawn(mob/owner, skill_level)
	if (!owner)
		return

	owner.AddComponent(MECHANICAL_ENGINEERING_SKILL_COMPONENT, skill_level)

/singleton/skill/atmospherics_systems
	name = "Atmospherics Systems"
	description = "Atmospherics systems involves the usage of atmospherics tooling and machinery, such as powered pumps, certain settings on air alarms, pipe wrenches, \
				pipe layers, and pipe construction."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_UNFAMILIAR
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_ENGINEERING
	required = TRUE

/singleton/skill/atmospherics_systems/on_spawn(mob/owner, skill_level)
	if (!owner)
		return

	owner.AddComponent(ATMOSPHERICS_SYSTEMS_SKILL_COMPONENT, skill_level)

/singleton/skill/reactor_systems
	name = "Reactor Systems"
	description = "Reactor systems envelops anything used for reactors, such as the computers and gyrotrons for the INDRA. It is also necessary to correctly interpret information \
				from reactor monitoring programs."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_UNFAMILIAR
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_ENGINEERING
	required = TRUE

/singleton/skill/reactor_systems/on_spawn(mob/owner, skill_level)
	if (!owner)
		return

	owner.AddComponent(REACTOR_SYSTEMS_SKILL_COMPONENT, skill_level)

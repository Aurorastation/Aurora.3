/singleton/skill/electrical_engineering
	name = "Electrical Engineering"
	description = "Electrical engineering covers usage and maintenance of various electrical systems, such as wiring."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_FAMILIAR
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_ENGINEERING
	required = TRUE
	component_type = ELECTRICAL_ENGINEERING_SKILL_COMPONENT
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have little to no experience working with electrical systems.",
		SKILL_LEVEL_FAMILIAR = "You have some experience working with electrical systems, though are not formally trained.<br>" \
			+ " - You can use a power cell to attempt emergency power bypasses on piloting consoles when they're unpowered.<br>" \
			+ " - You can recognize what a few wires do in electrical devices by sight.<br>" \
			+ " - You are 2.5% more likely to succeed when performing surgeries on an IPC.<br>" \
			+ " - You can perform surgeries 5% faster on an IPC.",
		SKILL_LEVEL_TRAINED = "You have formal training in electrical engineering concepts, equivalent to a Bachelor's Degree.<br>" \
			+ " - You can use a power cell to attempt emergency power bypasses on piloting consoles when they're unpowered.<br>" \
			+ " - You can recognize what several wires do in electrical devices by sight.<br>" \
			+ " - You are 5% more likely to succeed when performing surgeries on an IPC.<br>" \
			+ " - You can perform surgeries 10% faster on an IPC.",
		SKILL_LEVEL_PROFESSIONAL = "You have many years of training in electrical related Engineering concepts, equivalent to a Master's Degree or better.<br>" \
			+ " - You can recognize what many wires do in electrical devices by sight.<br>" \
			+ " - You are 7.5% more likely to succeed when performing surgeries on an IPC.<br>" \
			+ " - You can perform surgeries 15% faster on an IPC." \
	)

/singleton/skill/mechanical_engineering
	name = "Mechanical Engineering"
	description = "Mechanical engineering has to do with general construction of objects, walls, windows, and so on. It is also necessary for the usage of heavy machinery \
			such as emitters. This skill is also commonly used for crafting items out of raw materials, and heavily governs the quality of said objects. \
			It also modifies the damage you deal when attacking structures such as airlocks and windows."
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
			+ " - You can interact with some Engineering-related machinery.<br>" \
			+ " - You deal 10% more damage when attacking structures such as airlocks, windows, and machinery.<br>" \
			+ " - You can repair exosuits 25% faster<br>" \
			+ " - Each use of a welder on an exosuit repairs 5 more damage.<br>" \
			+ " - You can recognize what a few wires do in mechanical devices by sight.<br>" \
			+ " - You are 2.5% more likely to succeed when performing surgeries on an IPC.<br>" \
			+ " - You can perform surgeries 5% faster on an IPC.",
		SKILL_LEVEL_TRAINED = "You have formal training in general Engineering concepts, equivalent to a Bachelor's Degree. <br>" \
			+ " - You can craft items at the standard speed.<br>" \
			+ " - Items you craft are generally at average quality.<br>" \
			+ " - You can interact with most if not all Engineering equipment.<br>" \
			+ " - You deal 15% more damage when attacking structures such as airlocks, windows, and machinery.<br>" \
			+ " - You can repair exosuits 50% faster<br>" \
			+ " - Each use of a welder on an exosuit repairs 10 more damage.<br>" \
			+ " - You can recognize what several wires do in mechanical devices by sight.<br>" \
			+ " - You are 5% more likely to succeed when performing surgeries on an IPC.<br>" \
			+ " - You can perform surgeries 10% faster on an IPC.",
		SKILL_LEVEL_PROFESSIONAL = "You have many years of training in general Engineering concepts, equivalent to a Master's Degree or better.<br>" \
			+ " - You can craft items 50% faster.<br>" \
			+ " - Items you craft are of much higher quality on average.<br>" \
			+ " - You deal 20% more damage when attacking structures such as airlocks, windows, and machinery.<br>" \
			+ " - You can repair exosuits 75% faster<br>" \
			+ " - Each use of a welder on an exosuit repairs 15 more damage.<br>" \
			+ " - You can recognize what many wires do in mechanical devices by sight.<br>" \
			+ " - You are 7.5% more likely to succeed when performing surgeries on an IPC.<br>" \
			+ " - You can perform surgeries 15% faster on an IPC.",
	)

/singleton/skill/atmospherics_systems
	name = "Atmospherics Systems"
	description = "Atmospherics Systems encompasses pipework and pressurized fitting maintenance, gas analysis and pressure diagnostics, canister and regulator handling, stationary atmospheric machinery configuration, and emergency breach/fire control."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_FAMILIAR
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_ENGINEERING
	required = TRUE
	component_type = ATMOSPHERICS_SYSTEMS_SKILL_COMPONENT
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have little to no experience working with atmospherics systems.<br>" \
			+ " - You fasten, unfasten, and convert pipes slowly, and cannot safely unfasten overpressurized (>200 kPa) fittings even with a pipe wrench.<br>" \
			+ " - Gas Analyzers you use only identify common everyday gases, grouping industrial or hazardous gases as unidentified.<br>" \
			+ " - You set pressure regulators with slight imprecision, take longer to configure complex atmospherics machinery, and forget to close canister release valves when pulling holding tanks.<br>" \
			+ " - You deploy/deflate inflatable barriers, weld vents, and operate fire extinguishers more slowly.",
		SKILL_LEVEL_FAMILIAR = "You have some experience working with atmospherics systems, though are not formally trained.<br>" \
			+ " - You can recognize what a few wires do in atmospherics devices by sight.<br>" \
			+ " - You can unfasten overpressurized pipes with a pipe wrench, and feel temperature and pressure vibrations when examining pipes, canisters, and tanks.<br>" \
			+ " - Gas Analyzers you use display standard molar and percentage breakdowns for all gases.<br>" \
			+ " - You set pressure regulators accurately and automatically close canister release valves when removing holding tanks.<br>" \
			+ " - You deploy/deflate inflatable barriers and weld vents faster, and use fire extinguishers with a shorter cooldown and 15% better reagent conservation.<br>" \
			+ " - You have a 25% chance to reflexively exhale and negate lung ruptures when exposed to low pressure or vacuum.",
		SKILL_LEVEL_TRAINED = "You have formal training in general Engineering concepts, equivalent to a Bachelor's Degree.<br>" \
			+ " - You can recognize what some wires do in atmospherics devices by sight.<br>" \
			+ " - You fasten, unfasten, and bleed pressurized pipes faster, and can directly select pipe layers in a single step with a pipe wrench.<br>" \
			+ " - Examining pipes, canisters, and tanks estimates their pressure and temperature brackets, and Gas Analyzers display partial pressures (kPa) and hazard tags.<br>" \
			+ " - You configure complex atmospherics machinery without delay, connect portables faster, and can assemble atmospherics machinery and consoles from flatpaks.<br>" \
			+ " - You deploy/deflate inflatable barriers and weld vents faster, and use fire extinguishers with a shorter cooldown and 30% better reagent conservation.<br>" \
			+ " - You have a 50% chance to reflexively exhale and negate lung ruptures when exposed to low pressure or vacuum.",
		SKILL_LEVEL_PROFESSIONAL = "You have many years of specialized training in Atmospherics Systems, equivalent to a Master's Degree or better.<br>" \
			+ " - You can recognize what many wires do in atmospherics devices by sight.<br>" \
			+ " - You fasten and convert pipes and connect portable canisters/pumps instantaneously with a pipe wrench, and unfasten pressurized lines rapidly.<br>" \
			+ " - Examining pipes, canisters, and tanks reveals near-exact pressures, temperatures, and structural fatigue warnings.<br>" \
			+ " - Gas Analyzers you use display full molar breakdowns, heat capacity (J/K), and fuel/oxidizer combustion and auto-ignition assessments.<br>" \
			+ " - You deploy/deflate inflatable barriers and weld vents at maximum speed, and use fire extinguishers with minimal cooldown and 45% better reagent conservation.<br>" \
			+ " - You have a 100% chance to reflexively exhale and negate lung ruptures when exposed to low pressure or vacuum."
	)

/singleton/skill/reactor_systems
	name = "Reactor Systems"
	description = "Reactor systems envelops anything used for reactors, such as the computers and gyrotrons for the INDRA. It is also necessary to correctly interpret information \
				from reactor monitoring programs."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_FAMILIAR
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_ENGINEERING
	required = TRUE
	component_type = REACTOR_SYSTEMS_SKILL_COMPONENT
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have little to no experience working with reactor systems.<br>" \
			+ " - You cannot interact with Reactor computers such as the INDRA controllers.",
		SKILL_LEVEL_FAMILIAR = "You have some experience working with reactor systems, though are not formally trained.<br>" \
			+ " - You cannot interact with Reactor computers such as the INDRA controller.",
		SKILL_LEVEL_TRAINED = "You have formal training in general Engineering concepts, equivalent to a Bachelor's Degree. <br>" \
			+ " - This is the minimum skill level required to operate the INDRA.",
		SKILL_LEVEL_PROFESSIONAL = "You have many years of training in general Engineering concepts, equivalent to a Master's Degree or better.<br>" \
			+ " - Not currently implemented differently from Trained." \
	)

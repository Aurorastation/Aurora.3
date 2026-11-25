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
			+ " - You can Alt-Click electrical machinery to tune it: SMES/battery racks (capacity or I/O), rechargers/cell chargers (efficiency or power draw), exosuit docks (charge or repair speed), shield capacitors/generators, tesla coils (+20% absorption), and gravity generators (-20% active power draw).<br>" \
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
			+ " - You can Alt-Click fabricators, protolathes, synthetic fabricators, circuit imprinters, and biogenerators to tune one of two efficiency/speed modes, or crusher pistons for 25% faster cycling.<br>" \
			+ " - You deal 20% more damage when attacking structures such as airlocks, windows, and machinery.<br>" \
			+ " - You can repair exosuits 75% faster<br>" \
			+ " - Each use of a welder on an exosuit repairs 15 more damage.<br>" \
			+ " - You can recognize what many wires do in mechanical devices by sight.<br>" \
			+ " - You are 7.5% more likely to succeed when performing surgeries on an IPC.<br>" \
			+ " - You can perform surgeries 15% faster on an IPC.",
	)

/singleton/skill/atmospherics_systems
	name = "Atmospherics Systems"
	description = "Not currently implemented."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_FAMILIAR
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_ENGINEERING
	required = TRUE
	component_type = ATMOSPHERICS_SYSTEMS_SKILL_COMPONENT
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have little to no experience working with atmospherics systems.<br>" \
			+ " - No mechanical changes implemented at this skill level.",
		SKILL_LEVEL_FAMILIAR = "You have some experience working with atmospherics systems, though are not formally trained.<br>" \
			+ " - You can recognize what a few wires do in atmospherics devices by sight.",
		SKILL_LEVEL_TRAINED = "You have formal training in general Engineering concepts, equivalent to a Bachelor's Degree. <br>" \
			+ " - You can recognize what some wires do in atmospherics devices by sight.",
		SKILL_LEVEL_PROFESSIONAL = "You have many years of training in general Engineering concepts, equivalent to a Master's Degree or better.<br>" \
			+ " - You can recognize what many wires do in atmospherics devices by sight.<br>" \
			+ " - You can Alt-Click unary and portable atmospherics machinery to tune it: coolers/heaters (+20% capacity), portable scrubbers/pumps (+20% rate/power, -15% power loss), and room vents/scrubbers (+25% throughput).<br>" \
			+ " - You can Ctrl-Shift-Click binary atmospherics machinery to tune it: gas pumps (+20% capacity) and oxygen regenerators (+15% carbon efficiency, -15% intake power draw)." \
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
			+ " - You cannot interact with Reactor or Gas Turbine computers.<br>" \
			+ " - You cannot discern technical diagnostics when examining a Supermatter crystal.",
		SKILL_LEVEL_FAMILIAR = "You have some experience working with reactor systems, though are not formally trained.<br>" \
			+ " - You can view INDRA core telemetry in read-only mode, but cannot control cores, gyrotrons, injectors, or kinetic harvesters.<br>" \
			+ " - You can operate Gas Turbine control computers and inspect Portable Generator output.<br>" \
			+ " - You can assess general stability when examining a Supermatter crystal, and tell inert glowing goo apart from radioactive puddles.<br>" \
			+ " - You can use a power cell to attempt emergency power bypasses on unpowered ship consoles.<br>" \
			+ " - You are 5% more likely to succeed and 10% faster when performing power/reactor surgeries on an IPC.",
		SKILL_LEVEL_TRAINED = "You have formal training in general Engineering concepts, equivalent to a Bachelor's Degree.<br>" \
			+ " - You can fully operate INDRA reactor computers, gyrotrons, injectors, and kinetic harvesters.<br>" \
			+ " - You can read exact integrity, power, and temperature thresholds on Supermatter crystals, plus diagnostics on ship thrusters, fuel rods, and RTGs.<br>" \
			+ " - You can spot wiring or safety tampering when examining emitters and particle accelerator control boxes.<br>" \
			+ " - You are 10% more likely to succeed and 20% faster when performing power/reactor surgeries on an IPC.",
		SKILL_LEVEL_PROFESSIONAL = "You have many years of training in general Engineering concepts, equivalent to a Master's Degree or better.<br>" \
			+ " - You can compress INDRA fuel rods using 20% fewer materials (4 sheets or 80u reagent).<br>" \
			+ " - You can Alt-Click reactor machinery to tune it: portable generators (+20% output, 15% less fuel), gyrotrons/emitters (-15% power draw), kinetic harvesters (1.25x sheet extraction), gas turbines (+15% productivity), ship thrusters (-15% burn draw), and RTGs (+20% output).<br>" \
			+ " - You can read integrity trends and gas reaction efficiency when examining a Supermatter crystal.<br>" \
			+ " - You can view efficiency, productivity, and overheat cooldown diagnostics on Gas Turbine computers.<br>" \
			+ " - You are 15% more likely to succeed and 30% faster when performing power/reactor surgeries on an IPC." \
	)

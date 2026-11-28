// Automatically structured tech tree nodes defining branches, prerequisites, costs, and manufacturable design unlocks.

/datum/tech_node
	var/id = ""
	var/name = ""
	var/desc = ""
	var/branch = ""
	var/corporation = "NanoTrasen"
	var/tier = 1
	var/cost = 500
	var/list/prereq_ids = list()
	var/list/unlocked_designs = list()
	var/icon = "flask"
	var/starts_unlocked = FALSE
	var/antag_tech = FALSE

/datum/tech_node/industrial
	corporation = "Hephaestus Industries"

/datum/tech_node/power
	corporation = "NanoTrasen"

/datum/tech_node/mining
	corporation = "Orion Express"

/datum/tech_node/robotics
	corporation = "Zeng-Hu Pharmaceuticals"

/datum/tech_node/medical
	corporation = "Zeng-Hu Pharmaceuticals"

/datum/tech_node/computing
	corporation = "NanoTrasen"

/datum/tech_node/security
	corporation = "Zavodskoi Interstellar"

/datum/tech_node/restricted
	corporation = "Classified / Unaffiliated"

/proc/init_tech_nodes()
	var/list/nodes = list()
	for(var/node_path in subtypesof(/datum/tech_node))
		var/datum/tech_node/node = new node_path
		if(node.id)
			nodes[node.id] = node
	return nodes

GLOBAL_LIST_INIT(tech_nodes, init_tech_nodes())

/datum/tech_node/industrial/basics
	id = "ind_basics"
	name = "Basic Industrial Fabrication"
	desc = "Foundational stock parts, utility machinery boards, and basic station hardware."
	branch = "Industrial & Engineering"
	tier = 1
	cost = 0
	icon = "wrench"
	starts_unlocked = TRUE
	unlocked_designs = list(
		/datum/design/item/stock_part/basic_capacitor,
		/datum/design/item/stock_part/micro_mani,
		/datum/design/item/stock_part/basic_matter_bin,
		/datum/design/item/stock_part/basic_micro_laser,
		/datum/design/item/stock_part/basic_sensor,
		/datum/design/circuit/machine/autolathe,
		/datum/design/circuit/machine/protolathe,
		/datum/design/circuit/machine/circuit_imprinter,
		/datum/design/circuit/machine/destructive_analyzer,
		/datum/design/circuit/machine/material_silo,
		/datum/design/circuit/machine/floodlight,
		/datum/design/circuit/machine/cargo_trolley,
		/datum/design/circuit/power_outlet,
		/datum/design/circuit/machine/arcademachine,
		/datum/design/circuit/machine/oriontrail,
		/datum/design/circuit/machine/slot_machine
	)

/datum/tech_node/industrial/parts_adv
	id = "ind_parts_adv"
	name = "High-Rating Components"
	desc = "Precision-machined Tier 2 stock parts and rapid part replacement tooling."
	branch = "Industrial & Engineering"
	tier = 2
	cost = 2500
	prereq_ids = list("ind_basics")
	icon = "cogs"
	unlocked_designs = list(
		/datum/design/item/stock_part/adv_capacitor,
		/datum/design/item/stock_part/nano_mani,
		/datum/design/item/stock_part/adv_matter_bin,
		/datum/design/item/stock_part/high_micro_laser,
		/datum/design/item/stock_part/adv_sensor,
		/datum/design/item/stock_part/rped
	)

/datum/tech_node/industrial/parts_super
	id = "ind_parts_super"
	name = "Super-Grade Components"
	desc = "Cutting-edge Tier 3 capacitors, femto-manipulators, and phasic sensors."
	branch = "Industrial & Engineering"
	tier = 3
	cost = 5800
	prereq_ids = list("ind_parts_adv")
	icon = "microchip"
	unlocked_designs = list(
		/datum/design/item/stock_part/super_capacitor,
		/datum/design/item/stock_part/pico_mani,
		/datum/design/item/stock_part/super_matter_bin,
		/datum/design/item/stock_part/ultra_micro_laser,
		/datum/design/item/stock_part/phasic_sensor
	)

/datum/tech_node/industrial/machinery_rd
	id = "ind_machinery_rd"
	name = "Research & Logistics Machinery"
	desc = "R&D servers, tech processors, exosuit fabricators, and industrial compactors."
	branch = "Industrial & Engineering"
	tier = 3
	cost = 4500
	prereq_ids = list("ind_parts_adv")
	icon = "industry"
	unlocked_designs = list(
		/datum/design/circuit/machine/rdservercontrol,
		/datum/design/circuit/machine/rdserver,
		/datum/design/circuit/machine/rdtechprocessor,
		/datum/design/circuit/machine/mechfab,
		/datum/design/circuit/machine/crusher_base,
		/datum/design/circuit/machine/weapons_analyzer
	)

/datum/tech_node/industrial/tools_power
	id = "ind_tools_power"
	name = "Powered Engineering Tools"
	desc = "Motorized drills, atmospheric analyzers, light replacers, and inductive chargers."
	branch = "Industrial & Engineering"
	tier = 2
	cost = 2300
	prereq_ids = list("ind_basics")
	icon = "tools"
	unlocked_designs = list(
		/datum/design/item/tool/powerdrill,
		/datum/design/item/tool/advanced_light_replacer,
		/datum/design/item/tool/analyzer,
		/datum/design/item/tool/tag_scanner,
		/datum/design/item/tool/inductive_charger,
		/datum/design/item/tool/inductive_charger/engineering,
		/datum/design/circuit/machine/radial_floodlight
	)

/datum/tech_node/industrial/tools_rfd
	id = "ind_tools_rfd"
	name = "Rapid Fabrication Devices"
	desc = "Matter-synthesizing construction, service, and piping RFDs."
	branch = "Industrial & Engineering"
	tier = 3
	cost = 5100
	prereq_ids = list("ind_tools_power")
	icon = "hammer"
	unlocked_designs = list(
		/datum/design/item/tool/rfd,
		/datum/design/item/tool/rfd_ammo,
		/datum/design/item/tool/rfd_service,
		/datum/design/item/tool/rfd_pipe
	)

/datum/tech_node/industrial/tools_welders
	id = "ind_tools_welders"
	name = "Experimental Welding & Safety"
	desc = "High-energy experimental welders, radiation dosimeters, and protective optics."
	branch = "Industrial & Engineering"
	tier = 3
	cost = 4500
	prereq_ids = list("ind_tools_power")
	icon = "fire-extinguisher"
	unlocked_designs = list(
		/datum/design/item/tool/experimental_welder,
		/datum/design/item/tool/experimental_welder/eyeshield,
		/datum/design/item/tool/experimental_welder/overcap,
		/datum/design/item/tool/dosimeter
	)

/datum/tech_node/industrial/atmos_utility
	id = "ind_atmos_utility"
	name = "Atmospherics & Station Utility"
	desc = "Gas heating/cooling systems, oxygen regenerators, and crew service appliances."
	branch = "Industrial & Engineering"
	tier = 2
	cost = 2100
	prereq_ids = list("ind_basics")
	icon = "wind"
	unlocked_designs = list(
		/datum/design/circuit/machine/gas_heater,
		/datum/design/circuit/machine/gas_cooler,
		/datum/design/circuit/oxyregenerator,
		/datum/design/circuit/computer/atmosalerts,
		/datum/design/circuit/computer/air_management,
		/datum/design/circuit/machine/smartfridge,
		/datum/design/circuit/machine/requestconsole,
		/datum/design/circuit/machine/stove,
		/datum/design/circuit/machine/oven,
		/datum/design/circuit/machine/fryer,
		/datum/design/circuit/machine/cerealmaker,
		/datum/design/circuit/machine/grill,
		/datum/design/circuit/machine/candymaker,
		/datum/design/circuit/electronics/secure_airlock
	)

/datum/tech_node/industrial/ship_nav
	id = "ind_ship_nav"
	name = "Helm & Ship Propulsion"
	desc = "Bridge helm consoles, thruster circuitry, and low-power sensor suites."
	branch = "Industrial & Engineering"
	tier = 2
	cost = 2800
	prereq_ids = list("ind_basics")
	icon = "rocket"
	unlocked_designs = list(
		/datum/design/circuit/computer/helm,
		/datum/design/circuit/computer/sensors,
		/datum/design/circuit/computer/engines,
		/datum/design/circuit/ship/engine,
		/datum/design/circuit/ship/sensors_weak
	)

/datum/tech_node/industrial/ship_adv
	id = "ind_ship_adv"
	name = "Deep-Space Sensors & Ion Drives"
	desc = "High-power ship sensor suites, IFF transponders, and ion propulsion."
	branch = "Industrial & Engineering"
	tier = 3
	cost = 6100
	prereq_ids = list("ind_ship_nav")
	icon = "satellite"
	unlocked_designs = list(
		/datum/design/circuit/ship/sensors,
		/datum/design/circuit/ship/sensors_strong,
		/datum/design/circuit/ship/iff,
		/datum/design/circuit/ship/engine/ion
	)

/datum/tech_node/industrial/ship_shields
	id = "ind_ship_shields"
	name = "Hull & Bubble Shielding"
	desc = "Defensive ship shield generators and high-voltage shield capacitors."
	branch = "Industrial & Engineering"
	tier = 3
	cost = 5400
	prereq_ids = list("ind_ship_nav")
	icon = "shield-alt"
	unlocked_designs = list(
		/datum/design/circuit/shield/bubble,
		/datum/design/circuit/shield/hull,
		/datum/design/circuit/shield/capacitor
	)

/datum/tech_node/power/basics
	id = "pow_basics"
	name = "Basic Power Distribution"
	desc = "Standard power cells, rechargers, and solar control hardware."
	branch = "Power & Bluespace"
	tier = 1
	cost = 0
	icon = "bolt"
	starts_unlocked = TRUE
	unlocked_designs = list(
		/datum/design/item/powercell/basic,
		/datum/design/item/powercell/apc,
		/datum/design/item/powercell/device,
		/datum/design/circuit/machine/recharger,
		/datum/design/circuit/machine/recharger/wallcharger,
		/datum/design/circuit/machine/recharger/cell_charger,
		/datum/design/circuit/computer/solarcontrol
	)

/datum/tech_node/power/cells_high
	id = "pow_cells_high"
	name = "High-Capacity Energy Storage"
	desc = "High and super-capacity power cells, mecha cores, and charging racks."
	branch = "Power & Bluespace"
	tier = 2
	cost = 2500
	prereq_ids = list("pow_basics")
	icon = "battery-three-quarters"
	unlocked_designs = list(
		/datum/design/item/powercell/high,
		/datum/design/item/powercell/super,
		/datum/design/item/powercell/device/high,
		/datum/design/item/powercell/mecha,
		/datum/design/circuit/machine/recharger/cell_charger/rack,
		/datum/design/circuit/machine/batteryrack
	)

/datum/tech_node/power/cells_hyper
	id = "pow_cells_hyper"
	name = "Hyper-Density & Nuclear Cells"
	desc = "Hyper-capacity cells, nuclear/phoron mecha cores, and portable cell packs."
	branch = "Power & Bluespace"
	tier = 3
	cost = 5800
	prereq_ids = list("pow_cells_high")
	icon = "battery-full"
	unlocked_designs = list(
		/datum/design/item/powercell/hyper,
		/datum/design/item/powercell/mecha/nuclear,
		/datum/design/item/powercell/mecha/phoron,
		/datum/design/item/tool/power_cell_backpack,
		/datum/design/item/tool/recharger_backpack,
		/datum/design/circuit/machine/smes_cell
	)

/datum/tech_node/power/generators
	id = "pow_generators"
	name = "Portable & Radioisotope Generators"
	desc = "Phoron PACMAN generators and radioisotope thermoelectric power units."
	branch = "Power & Bluespace"
	tier = 2
	cost = 2800
	prereq_ids = list("pow_basics")
	icon = "plug"
	unlocked_designs = list(
		/datum/design/circuit/machine/portgen,
		/datum/design/circuit/machine/advancedportgen,
		/datum/design/circuit/machine/rtg
	)

/datum/tech_node/power/fusion
	id = "pow_fusion"
	name = "Fusion & High-Yield Reactors"
	desc = "Super-PACMANs, miniature fusion reactors, and advanced RTGs."
	branch = "Power & Bluespace"
	tier = 3
	cost = 6400
	prereq_ids = list("pow_generators")
	icon = "sun"
	unlocked_designs = list(
		/datum/design/circuit/machine/superportgen,
		/datum/design/circuit/machine/fusionportgen,
		/datum/design/circuit/machine/advanced_rtg
	)

/datum/tech_node/power/bluespace_beacons
	id = "blue_beacons"
	name = "Subspace Telemetry & Beacons"
	desc = "Navigation beacons, telepad consoles, and fundamental subspace components."
	branch = "Power & Bluespace"
	tier = 2
	cost = 2600
	prereq_ids = list("pow_basics")
	icon = "satellite-dish"
	unlocked_designs = list(
		/datum/design/item/tool/beacon,
		/datum/design/item/tool/navbeacon,
		/datum/design/circuit/computer/telesci_console,
		/datum/design/item/stock_part/hyperwave_filter,
		/datum/design/item/tool/idris_backpack
	)

/datum/tech_node/power/subspace_parts
	id = "blue_subspace"
	name = "Subspace Field Components"
	desc = "Subspace ansibles, amplifiers, crystals, and transmitters for long-range relays."
	branch = "Power & Bluespace"
	tier = 3
	cost = 5100
	prereq_ids = list("blue_beacons")
	icon = "wave-square"
	unlocked_designs = list(
		/datum/design/item/stock_part/subspace_ansible,
		/datum/design/item/stock_part/subspace_amplifier,
		/datum/design/item/stock_part/subspace_treatment,
		/datum/design/item/stock_part/subspace_analyzer,
		/datum/design/item/stock_part/subspace_crystal,
		/datum/design/item/stock_part/subspace_transmitter
	)

/datum/tech_node/power/bluespace_teleport
	id = "blue_teleport"
	name = "Bluespace Translocation"
	desc = "Artificial bluespace crystals, hand teleporters, telepads, and spatial neutralizers."
	branch = "Power & Bluespace"
	tier = 3
	cost = 7000
	prereq_ids = list("blue_beacons")
	icon = "door-open"
	unlocked_designs = list(
		/datum/design/item/tool/bluespace_crystal,
		/datum/design/item/tool/hand_tele,
		/datum/design/item/tool/bluespace_neutralizer,
		/datum/design/item/tool/spaceflare,
		/datum/design/circuit/machine/telepad
	)

/datum/tech_node/mining/basics
	id = "min_basics"
	name = "Basic Excavation & EVA"
	desc = "Excavation kits, kinetic analyzers, mining RFDs, and baseline EVA hardsuit boards."
	branch = "Mining & Exploration"
	tier = 1
	cost = 0
	icon = "gem"
	starts_unlocked = TRUE
	unlocked_designs = list(
		/datum/design/item/mining/mining_rfd,
		/datum/design/item/mining/kinetic_analyzer,
		/datum/design/item/mining/pick_set,
		/datum/design/circuit/machine/mining/miningdrill,
		/datum/design/circuit/machine/mining/miningdrillbrace,
		/datum/design/circuit/machine/mining/ore_processor,
		/datum/design/circuit/machine/mining/redemption_console,
		/datum/design/circuit/machine/mining/unloading_machine,
		/datum/design/circuit/machine/mining/stacking_machine,
		/datum/design/circuit/machine/mining/stacking_machine_console
	)

/datum/tech_node/mining/drills
	id = "min_drills"
	name = "Powered Mining Drills"
	desc = "Pneumatic jackhammers, rotary mining drills, and plasma cutters."
	branch = "Mining & Exploration"
	tier = 2
	cost = 2300
	prereq_ids = list("min_basics")
	icon = "hammer"
	unlocked_designs = list(
		/datum/design/item/mining/jackhammer,
		/datum/design/item/mining/drill,
		/datum/design/item/mining/plasmacutter
	)

/datum/tech_node/mining/diamond
	id = "min_diamond"
	name = "Diamond-Tipped Extraction"
	desc = "Ultra-hard diamond pickaxes and high-torque diamond mining drills."
	branch = "Mining & Exploration"
	tier = 3
	cost = 5100
	prereq_ids = list("min_drills")
	icon = "gem"
	unlocked_designs = list(
		/datum/design/item/mining/pick_diamond,
		/datum/design/item/mining/drill_diamond
	)

/datum/tech_node/mining/ka_basics
	id = "min_ka_basics"
	name = "Modular Kinetic Accelerators"
	desc = "Standard KA frames, starter cells, and baseline accelerator barrels."
	branch = "Mining & Exploration"
	tier = 2
	cost = 2500
	prereq_ids = list("min_basics")
	icon = "crosshairs"
	unlocked_designs = list(
		/datum/design/item/mining/ka_frame01,
		/datum/design/item/mining/ka_frame02,
		/datum/design/item/mining/ka_frame03,
		/datum/design/item/mining/ka_frameA,
		/datum/design/item/mining/ka_frameF,
		/datum/design/item/mining/ka_cell01,
		/datum/design/item/mining/ka_cell02,
		/datum/design/item/mining/ka_cell03,
		/datum/design/item/mining/ka_barrel01,
		/datum/design/item/mining/ka_barrel02,
		/datum/design/item/mining/ka_barrel02_alt,
		/datum/design/item/mining/ka_barrel03
	)

/datum/tech_node/mining/ka_heavy
	id = "min_ka_heavy"
	name = "Heavy Kinetic Frames & Barrels"
	desc = "High-output KA frames, phoron barrels, and inertia/loader power cells."
	branch = "Mining & Exploration"
	tier = 3
	cost = 5400
	prereq_ids = list("min_ka_basics")
	icon = "bolt"
	unlocked_designs = list(
		/datum/design/item/mining/ka_frame04,
		/datum/design/item/mining/ka_frame05,
		/datum/design/item/mining/ka_frameB,
		/datum/design/item/mining/ka_frameC,
		/datum/design/item/mining/ka_frameD,
		/datum/design/item/mining/ka_frameE,
		/datum/design/item/mining/ka_cell04,
		/datum/design/item/mining/ka_cell05,
		/datum/design/item/mining/ka_cellinertia,
		/datum/design/item/mining/ka_cellphoron,
		/datum/design/item/mining/ka_celluranium,
		/datum/design/item/mining/ka_cellhydrogen,
		/datum/design/item/mining/ka_barrel04,
		/datum/design/item/mining/ka_barrel05,
		/datum/design/item/mining/ka_barrelphoron
	)

/datum/tech_node/mining/ka_chips
	id = "min_ka_chips"
	name = "Kinetic Accelerator Upgrade Chips"
	desc = "Programmable KA enhancement chips for damage, fire rate, efficiency, and explosive payloads."
	branch = "Mining & Exploration"
	tier = 3
	cost = 4800
	prereq_ids = list("min_ka_basics")
	icon = "microchip"
	unlocked_designs = list(
		/datum/design/item/mining/ka_upgrade01,
		/datum/design/item/mining/ka_upgrade02,
		/datum/design/item/mining/ka_upgrade03,
		/datum/design/item/mining/ka_upgrade04,
		/datum/design/item/mining/ka_upgrade05,
		/datum/design/item/mining/ka_upgrade06,
		/datum/design/item/mining/ka_upgrade07
	)

/datum/tech_node/mining/rig_civilian
	id = "rig_civilian"
	name = "EVA & Industrial Hardsuits"
	desc = "Standard EVA, pilot, industrial, hazmat, and medical rescue hardsuit assemblies."
	branch = "Mining & Exploration"
	tier = 2
	cost = 2600
	prereq_ids = list("min_basics")
	icon = "user-astronaut"
	unlocked_designs = list(
		/datum/design/rig/eva,
		/datum/design/rig/eva/pilot,
		/datum/design/rig/industrial,
		/datum/design/rig/hazmat,
		/datum/design/rig/medical,
		/datum/design/circuit/hardsuit/eva,
		/datum/design/circuit/hardsuit/eva/pilot,
		/datum/design/circuit/hardsuit/industrial,
		/datum/design/circuit/hardsuit/hazmat,
		/datum/design/circuit/hardsuit/medical
	)

/datum/tech_node/mining/rig_utility
	id = "rig_utility"
	name = "Advanced Voidsuits & Suit Modules"
	desc = "CE advanced voidsuits, maneuvering jets, leg actuators, and mounted utility modules."
	branch = "Mining & Exploration"
	tier = 3
	cost = 5100
	prereq_ids = list("rig_civilian")
	icon = "space-shuttle"
	unlocked_designs = list(
		/datum/design/rig/ce,
		/datum/design/circuit/hardsuit/ce,
		/datum/design/hardsuitmodules/storage,
		/datum/design/hardsuitmodules/iss_module,
		/datum/design/hardsuitmodules/jet_module,
		/datum/design/hardsuitmodules/actuators_module,
		/datum/design/hardsuitmodules/cooling_module,
		/datum/design/hardsuitmodules/foam_sprayer,
		/datum/design/hardsuitmodules/plasmacutter_module,
		/datum/design/hardsuitmodules/drill_module,
		/datum/design/hardsuitmodules/rfd_c_module
	)

/datum/tech_node/mining/rig_sensors
	id = "rig_sensors"
	name = "Hardsuit Optics & Bio-Modules"
	desc = "Integrated HUD visors, nightvision, health scanners, and chemical injectors."
	branch = "Mining & Exploration"
	tier = 3
	cost = 4500
	prereq_ids = list("rig_civilian")
	icon = "eye"
	unlocked_designs = list(
		/datum/design/hardsuitmodules/sechud_module,
		/datum/design/hardsuitmodules/medhud_module,
		/datum/design/hardsuitmodules/nvg_module,
		/datum/design/hardsuitmodules/healthscanner_module,
		/datum/design/hardsuitmodules/chem_module
	)

/datum/tech_node/robotics/basics
	id = "rob_basics"
	name = "Machinist & Robotics Baseline"
	desc = "Standard cyborg frames, external & internal prosthetics, synthetic organs, basic Ripley/Odysseus exosuits, and utility mech equipment."
	branch = "Robotics & Exosuits"
	tier = 1
	cost = 0
	icon = "robot"
	starts_unlocked = TRUE
	unlocked_designs = list(
		/datum/design/item/mechfab/robot/exoskeleton,
		/datum/design/item/mechfab/robot/torso,
		/datum/design/item/mechfab/robot/head,
		/datum/design/item/mechfab/robot/l_arm,
		/datum/design/item/mechfab/robot/r_arm,
		/datum/design/item/mechfab/robot/l_leg,
		/datum/design/item/mechfab/robot/r_leg,
		/datum/design/item/mechfab/robot/component/binary_communication_device,
		/datum/design/item/mechfab/robot/component/radio,
		/datum/design/item/mechfab/robot/component/actuator,
		/datum/design/item/mechfab/robot/component/diagnosis_unit,
		/datum/design/item/mechfab/robot/component/camera,
		/datum/design/item/mechfab/robot/component/armor,
		/datum/design/item/robot_upgrade/rename,
		/datum/design/item/robot_upgrade/reset,
		/datum/design/item/robot_upgrade/floodlight,
		/datum/design/item/robot_upgrade/restart,
		/datum/design/item/robot_upgrade/vtec,
		/datum/design/item/robot_upgrade/jetpack,
		/datum/design/item/mechfab/prosthetic/l_arm,
		/datum/design/item/mechfab/prosthetic/r_arm,
		/datum/design/item/mechfab/prosthetic/l_leg,
		/datum/design/item/mechfab/prosthetic/r_leg,
		/datum/design/item/mechfab/prosthetic/l_hand,
		/datum/design/item/mechfab/prosthetic/r_hand,
		/datum/design/item/mechfab/prosthetic/l_foot,
		/datum/design/item/mechfab/prosthetic/r_foot,
		/datum/design/item/mechfab/prosthetic/groin_cap,
		/datum/design/item/mechfab/prosthetic/internal/heart,
		/datum/design/item/mechfab/prosthetic/internal/lungs,
		/datum/design/item/mechfab/prosthetic/internal/kidneys,
		/datum/design/item/mechfab/prosthetic/internal/eyes,
		/datum/design/item/mechfab/prosthetic/internal/liver,
		/datum/design/item/mechfab/prosthetic/internal/stomach,
		/datum/design/item/synthetic/air_cooling_unit,
		/datum/design/item/synthetic/zenghu_air_cooling_unit,
		/datum/design/item/synthetic/xion_air_cooling_unit,
		/datum/design/item/synthetic/liquid_cooling_unit,
		/datum/design/item/synthetic/passive_cooling_unit,
		/datum/design/item/synthetic/zenghu_passive_cooling_unit,
		/datum/design/item/synthetic/diagnostics_unit,
		/datum/design/item/synthetic/actuator,
		/datum/design/item/synthetic/actuator/right,
		/datum/design/item/synthetic/hydraulics,
		/datum/design/item/synthetic/voice_synthesizer,
		/datum/design/item/synthetic/ipc_tag,
		/datum/design/item/synthetic/optical_sensor,
		/datum/design/item/synthetic/power_core,
		/datum/design/item/synthetic/reactor,
		/datum/design/item/synthetic/access_port,
		/datum/design/item/mechfab/exosuit,
		/datum/design/item/mechfab/exosuit/basic_armor,
		/datum/design/item/mechfab/exosuit/actuator,
		/datum/design/item/mechfab/exosuit/diagnosis_unit,
		/datum/design/item/mechfab/exosuit/camera,
		/datum/design/item/mechfab/exosuit/radio,
		/datum/design/item/mechfab/exosuit/control_module,
		/datum/design/item/mechfab/exosuit/ripley_head,
		/datum/design/item/mechfab/exosuit/ripley_torso,
		/datum/design/item/mechfab/exosuit/ripley_arms,
		/datum/design/item/mechfab/exosuit/ripley_legs,
		/datum/design/item/mechfab/exosuit/light_head,
		/datum/design/item/mechfab/exosuit/light_torso,
		/datum/design/item/mechfab/exosuit/light_arms,
		/datum/design/item/mechfab/exosuit/light_legs,
		/datum/design/item/mechfab/exosuit/spider,
		/datum/design/item/mechfab/exosuit/spider/heavy,
		/datum/design/item/mechfab/exosuit/hover_legs,
		/datum/design/item/mechfab/exosuit/hover_legs/light,
		/datum/design/item/mechfab/exosuit/track,
		/datum/design/circuit/exosuit/engineering,
		/datum/design/circuit/exosuit/utility,
		/datum/design/item/mechfab/exosuit_equipment,
		/datum/design/item/mechfab/exosuit_equipment/gravity_catapult,
		/datum/design/item/mechfab/exosuit_equipment/drill,
		/datum/design/item/mechfab/exosuit_equipment/taser,
		/datum/design/item/mechfab/exosuit_equipment/floodlight,
		/datum/design/item/mechfab/exosuit_equipment/sleeper,
		/datum/design/item/mechfab/exosuit_equipment/extinguisher,
		/datum/design/item/mechfab/exosuit_equipment/flaregun,
		/datum/design/item/mechfab/exosuit_equipment/passenger_compartment,
		/datum/design/item/mechfab/exosuit_equipment/autolathe,
		/datum/design/item/mechfab/exosuit_equipment/toolset,
		/datum/design/item/mechfab/exosuit_equipment/quick_enter,
		/datum/design/item/mechfab/exosuit_equipment/drill_mover,
		/datum/design/circuit/machine/recharge_station,
		/datum/design/circuit/machine/mech_recharger
	)

/datum/tech_node/robotics/cyborg_upgrades
	id = "rob_upgrades"
	name = "Robotics Control & Surge Protection"
	desc = "Cyborg synthetic flashes, heavy surge prevention, and robotics control/drone consoles."
	branch = "Robotics & Exosuits"
	tier = 2
	cost = 2500
	prereq_ids = list("rob_basics")
	icon = "microchip"
	unlocked_designs = list(
		/datum/design/item/mechfab/robot/component/synthetic_flash,
		/datum/design/item/mechfab/robot/component/surge,
		/datum/design/circuit/computer/robocontrol,
		/datum/design/circuit/computer/robotics_console,
		/datum/design/circuit/computer/dronecontrol
	)

/datum/tech_node/robotics/synthetic_cooling
	id = "pros_synthetic"
	name = "Advanced Synthetic Cryo-Cooling"
	desc = "High-efficiency Zeng-Hu lamellar and Xion cryo-cooling systems for synthetic frames."
	branch = "Robotics & Exosuits"
	tier = 2
	cost = 2800
	prereq_ids = list("rob_basics")
	icon = "snowflake"
	unlocked_designs = list(
		/datum/design/item/synthetic/zenghu_liquid_cooling_unit,
		/datum/design/item/synthetic/xion_liquid_cooling_unit
	)

/datum/tech_node/robotics/mech_utility
	id = "mech_utility"
	name = "Specialized Exosuit Armor & Medical Systems"
	desc = "Radiation-proof and EM-shielded exosuit armor, medical mech circuits, and Hephaestus rechargers."
	branch = "Robotics & Exosuits"
	tier = 2
	cost = 2600
	prereq_ids = list("rob_basics")
	icon = "truck-monster"
	unlocked_designs = list(
		/datum/design/item/mechfab/exosuit/radproof_armor,
		/datum/design/item/mechfab/exosuit/em_armor,
		/datum/design/circuit/exosuit/medical,
		/datum/design/circuit/machine/heph_mech_recharger
	)

/datum/tech_node/robotics/mech_equip_util
	id = "mech_equip_util"
	name = "Advanced Exosuit Utility Equipment"
	desc = "Mounted plasma cutters, RFD-C, cleaner/crisis drones, kinetic accelerators, and ore summoners."
	branch = "Robotics & Exosuits"
	tier = 3
	cost = 4800
	prereq_ids = list("mech_utility")
	icon = "tools"
	unlocked_designs = list(
		/datum/design/item/mechfab/exosuit_equipment/plasma,
		/datum/design/item/mechfab/exosuit_equipment/rcd,
		/datum/design/item/mechfab/exosuit_equipment/cleaner,
		/datum/design/item/mechfab/exosuit_equipment/crisisdrone,
		/datum/design/item/mechfab/exosuit_equipment/analyzer,
		/datum/design/item/mechfab/exosuit_equipment/kinetic_accelerator,
		/datum/design/item/mechfab/exosuit_equipment/kinetic_accelerator_heavy,
		/datum/design/item/mechfab/exosuit_equipment/ore_summoner
	)

/datum/tech_node/robotics/mech_combat
	id = "mech_combat"
	name = "Combat Exosuit Chassis"
	desc = "Reinforced combat & heavy exosuit hulls, combat armor, and remote mech control."
	branch = "Robotics & Exosuits"
	tier = 3
	cost = 6400
	prereq_ids = list("mech_utility")
	icon = "shield-alt"
	unlocked_designs = list(
		/datum/design/item/mechfab/exosuit/combat_armor,
		/datum/design/item/mechfab/exosuit/combat_head,
		/datum/design/item/mechfab/exosuit/combat_torso,
		/datum/design/item/mechfab/exosuit/combat_arms,
		/datum/design/item/mechfab/exosuit/combat_legs,
		/datum/design/item/mechfab/exosuit/heavy_head,
		/datum/design/item/mechfab/exosuit/heavy_torso,
		/datum/design/item/mechfab/exosuit/heavy_arms,
		/datum/design/item/mechfab/exosuit/heavy_legs,
		/datum/design/circuit/exosuit/weapons,
		/datum/design/circuit/exosuit_upgrade/remote,
		/datum/design/circuit/exosuit_upgrade/remote/penal,
		/datum/design/circuit/exosuit_upgrade/remote/ai,
		/datum/design/item/deployable_kit/mech_chair,
		/datum/design/item/deployable_kit/mech_chair/brig
	)

/datum/tech_node/robotics/mech_weapons
	id = "mech_weapons"
	name = "Exosuit Heavy Weaponry & Shields"
	desc = "Mounted lasers, ion cannons, shield drones, grenade launchers, and Phazon systems."
	branch = "Robotics & Exosuits"
	tier = 4
	cost = 10600
	prereq_ids = list("mech_combat")
	icon = "crosshairs"
	unlocked_designs = list(
		/datum/design/item/mechfab/exosuit_equipment/uac,
		/datum/design/item/mechfab/exosuit_equipment/uac_ltl,
		/datum/design/item/mechfab/exosuit_equipment/ion,
		/datum/design/item/mechfab/exosuit_equipment/laser,
		/datum/design/item/mechfab/exosuit_equipment/flashbang,
		/datum/design/item/mechfab/exosuit_equipment/stinger,
		/datum/design/item/mechfab/exosuit_equipment/tear,
		/datum/design/item/mechfab/exosuit_equipment/smoke,
		/datum/design/item/mechfab/exosuit_equipment/mechshields,
		/datum/design/item/mechfab/exosuit_equipment/phazon
	)

/datum/tech_node/medical/basics
	id = "med_basics"
	name = "Basic Medical & Lab Systems"
	desc = "Operating monitors, sleepers, body scanners, chemistry heaters, and standard beakers."
	branch = "Medicine & Biotech"
	tier = 1
	cost = 0
	icon = "medkit"
	starts_unlocked = TRUE
	unlocked_designs = list(
		/datum/design/circuit/computer/operating,
		/datum/design/circuit/machine/sleeper,
		/datum/design/circuit/machine/bodyscannerm,
		/datum/design/circuit/machine/bodyscannerc,
		/datum/design/circuit/machine/optable,
		/datum/design/circuit/machine/chem_heater,
		/datum/design/circuit/machine/iv_drip,
		/datum/design/item/beaker/noreact,
		/datum/design/item/tool/advmop
	)

/datum/tech_node/medical/diagnostics
	id = "med_diagnostics"
	name = "Medical Diagnostics & HUDs"
	desc = "Health/robot/autopsy scanners, medical HUD glasses, and mass spectrometers."
	branch = "Medicine & Biotech"
	tier = 2
	cost = 2100
	prereq_ids = list("med_basics")
	icon = "stethoscope"
	unlocked_designs = list(
		/datum/design/item/medical/health_analyzer,
		/datum/design/item/medical/robot_scanner,
		/datum/design/item/medical/autopsy_scanner,
		/datum/design/item/medical/mass_spectrometer,
		/datum/design/item/medical/reagent_scanner,
		/datum/design/item/hud/health
	)

/datum/tech_node/medical/surgery_adv
	id = "med_surgery_adv"
	name = "Precision Surgery & Spectrometry"
	desc = "Laser scalpels, incision management systems, nanopaste, and advanced spectrometers."
	branch = "Medicine & Biotech"
	tier = 3
	cost = 5100
	prereq_ids = list("med_diagnostics")
	icon = "user-md"
	unlocked_designs = list(
		/datum/design/item/medical/adv_mass_spectrometer,
		/datum/design/item/medical/adv_reagent_scanner,
		/datum/design/item/medical/nanopaste,
		/datum/design/item/medical/scalpel_laser,
		/datum/design/item/medical/scalpel_manager
	)

/datum/tech_node/medical/cryo_inhalers
	id = "med_cryo"
	name = "Cryogenics & Inhaler Therapy"
	desc = "Cryo cells, medical inhalers, and lifeform stasis units."
	branch = "Medicine & Biotech"
	tier = 2
	cost = 2500
	prereq_ids = list("med_basics")
	icon = "snowflake"
	unlocked_designs = list(
		/datum/design/circuit/machine/cryopod,
		/datum/design/circuit/machine/stasis_bed,
		/datum/design/item/medical/inhaler,
		/datum/design/item/medical/inhaler_cartridge_small
	)

/datum/tech_node/medical/pharma_adv
	id = "med_pharma_adv"
	name = "Bluespace Pharmacology"
	desc = "Combat inhalers, high-volume cartridges, and bluespace beakers."
	branch = "Medicine & Biotech"
	tier = 3
	cost = 5400
	prereq_ids = list("med_cryo")
	icon = "flask"
	unlocked_designs = list(
		/datum/design/item/medical/inhaler_combat,
		/datum/design/item/medical/inhaler_cartridge_large,
		/datum/design/item/medical/inhaler_cartridge_bluespace,
		/datum/design/item/beaker/bluespace
	)

/datum/tech_node/medical/implants
	id = "med_implants"
	name = "Biomedical Implants & MMIs"
	desc = "Implanters, chemical/death-alarm implants, and Man-Machine Interfaces."
	branch = "Medicine & Biotech"
	tier = 2
	cost = 2800
	prereq_ids = list("med_basics")
	icon = "syringe"
	unlocked_designs = list(
		/datum/design/item/tool/implanter,
		/datum/design/item/implant/chemical,
		/datum/design/item/implant/death_alarm,
		/datum/design/item/tool/mmi,
		/datum/design/item/tool/mmi_radio
	)

/datum/tech_node/medical/botany
	id = "med_botany"
	name = "Xenobiology & Botanical Synthesis"
	desc = "Biogenerators, slime extractors, plant analyzers, and flora mutation guns."
	branch = "Medicine & Biotech"
	tier = 2
	cost = 2300
	prereq_ids = list("med_basics")
	icon = "seedling"
	unlocked_designs = list(
		/datum/design/circuit/machine/biogenerator,
		/datum/design/circuit/machine/slime_extractor,
		/datum/design/item/tool/plant_analyzer,
		/datum/design/item/weapon/flora_gun,
		/datum/design/item/disk/flora_disk
	)

/datum/tech_node/computing/basics
	id = "comp_basics"
	name = "Basic Computing & Custom Circuits"
	desc = "Data disks, pAI cards, holopads, core AI law boards, and roundstart integrated circuit printers & assemblies."
	branch = "Computing & Comms"
	tier = 1
	cost = 0
	icon = "laptop"
	starts_unlocked = TRUE
	unlocked_designs = list(
		/datum/design/item/disk/design_disk,
		/datum/design/item/disk/tech_disk,
		/datum/design/item/tool/paicard,
		/datum/design/circuit/machine/holopadboard,
		/datum/design/circuit/aimodule/core/asimov,
		/datum/design/circuit/aimodule/core/paladin,
		/datum/design/circuit/aimodule/core/freeformcore,
		/datum/design/item/integrated_electronics/wirer,
		/datum/design/item/integrated_electronics/debugger,
		/datum/design/item/integrated_electronics/custom_circuit_assembly,
		/datum/design/item/integrated_electronics/custom_circuit_assembly/device,
		/datum/design/item/integrated_electronics/custom_circuit_printer
	)

/datum/tech_node/computing/modular_basic
	id = "comp_mod_basic"
	name = "Modular Computer Hardware"
	desc = "Hard drives, portable drives, battery modules, network cards, and nanoprinters."
	branch = "Computing & Comms"
	tier = 2
	cost = 2100
	prereq_ids = list("comp_basics")
	icon = "hdd"
	unlocked_designs = list(
		/datum/design/item/modularcomponent/disk/normal,
		/datum/design/item/modularcomponent/disk/small,
		/datum/design/item/modularcomponent/disk/micro,
		/datum/design/item/modularcomponent/portabledrive/basic,
		/datum/design/item/modularcomponent/netcard/basic,
		/datum/design/item/modularcomponent/cardslot,
		/datum/design/item/modularcomponent/nanoprinter,
		/datum/design/item/modularcomponent/teslalink/charging_cable,
		/datum/design/item/modularcomponent/battery/normal,
		/datum/design/item/modularcomponent/battery/hotswap,
		/datum/design/item/modularcomponent/battery/nano,
		/datum/design/item/modularcomponent/battery/micro,
		/datum/design/item/modularcomponent/cpu/small,
		/datum/design/item/modularcomponent/flashlight
	)

/datum/tech_node/computing/modular_adv
	id = "comp_mod_adv"
	name = "Photonic & Cluster Computing"
	desc = "Cluster drives, photonic processors, ultra-capacity batteries, and AI slots."
	branch = "Computing & Comms"
	tier = 3
	cost = 5100
	prereq_ids = list("comp_mod_basic")
	icon = "server"
	unlocked_designs = list(
		/datum/design/item/modularcomponent/disk/advanced,
		/datum/design/item/modularcomponent/disk/super,
		/datum/design/item/modularcomponent/disk/cluster,
		/datum/design/item/modularcomponent/portabledrive/advanced,
		/datum/design/item/modularcomponent/portabledrive/super,
		/datum/design/item/modularcomponent/netcard/signaler,
		/datum/design/item/modularcomponent/netcard/advanced,
		/datum/design/item/modularcomponent/netcard/wired,
		/datum/design/item/modularcomponent/teslalink,
		/datum/design/item/modularcomponent/battery/advanced,
		/datum/design/item/modularcomponent/battery/super,
		/datum/design/item/modularcomponent/battery/ultra,
		/datum/design/item/modularcomponent/cpu,
		/datum/design/item/modularcomponent/cpu/photonic,
		/datum/design/item/modularcomponent/cpu/photonic/small,
		/datum/design/item/modularcomponent/aislot
	)

/datum/tech_node/computing/integrated_electronics
	id = "comp_integrated"
	name = "Expanded Circuit Assemblies"
	desc = "Medium, drone, large, and implant custom electronic assemblies."
	branch = "Computing & Comms"
	tier = 2
	cost = 2400
	prereq_ids = list("comp_basics")
	icon = "microchip"
	unlocked_designs = list(
		/datum/design/item/integrated_electronics/custom_circuit_assembly/medium,
		/datum/design/item/integrated_electronics/custom_circuit_assembly/drone,
		/datum/design/item/integrated_electronics/custom_circuit_assembly/large,
		/datum/design/item/integrated_electronics/custom_circuit_assembly/implant
	)

/datum/tech_node/computing/integrated_adv
	id = "comp_integrated_adv"
	name = "Circuit Printer Upgrades & Cloning"
	desc = "Advanced integrated circuit printer design upgrades and circuit cloner disks."
	branch = "Computing & Comms"
	tier = 3
	cost = 5100
	prereq_ids = list("comp_integrated")
	icon = "project-diagram"
	unlocked_designs = list(
		/datum/design/item/integrated_electronics/custom_circuit_printer_upgrade,
		/datum/design/item/integrated_electronics/custom_circuit_printer_upgrade/clone
	)

/datum/tech_node/computing/tcom
	id = "comp_tcom"
	name = "Telecommunications & NTNet"
	desc = "TCom servers, hubs, relays, subspace receivers/broadcasters, and monitoring consoles."
	branch = "Computing & Comms"
	tier = 2
	cost = 2600
	prereq_ids = list("comp_basics")
	icon = "broadcast-tower"
	unlocked_designs = list(
		/datum/design/circuit/tcom/server,
		/datum/design/circuit/tcom/processor,
		/datum/design/circuit/tcom/bus,
		/datum/design/circuit/tcom/hub,
		/datum/design/circuit/tcom/broadcaster,
		/datum/design/circuit/tcom/receiver,
		/datum/design/circuit/tcom/ntnet_relay,
		/datum/design/circuit/machine/ntnet_relay/field,
		/datum/design/circuit/computer/comm_monitor,
		/datum/design/circuit/computer/comm_server,
		/datum/design/circuit/computer/message_monitor,
		/datum/design/circuit/computer/rdconsole
	)

/datum/tech_node/computing/ai_core
	id = "comp_ai_core"
	name = "AI Core & Upload Architecture"
	desc = "AI cores, upload consoles, intellicards, and AI shell control modules."
	branch = "Computing & Comms"
	tier = 2
	cost = 3000
	prereq_ids = list("comp_basics")
	icon = "brain"
	unlocked_designs = list(
		/datum/design/circuit/machine/aicore,
		/datum/design/circuit/computer/aiupload,
		/datum/design/circuit/computer/borgupload,
		/datum/design/item/tool/intellicard,
		/datum/design/item/tool/mmi_shell
	)

/datum/tech_node/computing/ai_laws_safety
	id = "comp_ai_laws_safety"
	name = "AI Station Safety Modules"
	desc = "Safeguard, ProtectStation, Quarantine, OxygenIsToxic, and TeleporterOffline law boards."
	branch = "Computing & Comms"
	tier = 3
	cost = 4800
	prereq_ids = list("comp_ai_core")
	icon = "shield-alt"
	unlocked_designs = list(
		/datum/design/circuit/aimodule/safeguard,
		/datum/design/circuit/aimodule/protectstation,
		/datum/design/circuit/aimodule/quarantine,
		/datum/design/circuit/aimodule/oxygen,
		/datum/design/circuit/aimodule/notele
	)

/datum/tech_node/computing/ai_laws_exec
	id = "comp_ai_laws_exec"
	name = "Executive AI Law Modules"
	desc = "Freeform, OneCrewMember, Reset, and Purge AI law upload modules."
	branch = "Computing & Comms"
	tier = 3
	cost = 5800
	prereq_ids = list("comp_ai_core")
	icon = "gavel"
	unlocked_designs = list(
		/datum/design/circuit/aimodule/onehuman,
		/datum/design/circuit/aimodule/freeform,
		/datum/design/circuit/aimodule/reset,
		/datum/design/circuit/aimodule/purge
	)

/datum/tech_node/security/basics
	id = "sec_basics"
	name = "Security & Prototype Weaponry Baseline"
	desc = "Security consoles, HUDs, firing pins, and baseline modular energy weapon frames, lenses, capacitors, modulators, and furniture."
	branch = "Weapons & Security"
	tier = 1
	cost = 0
	icon = "shield-alt"
	starts_unlocked = TRUE
	unlocked_designs = list(
		/datum/design/circuit/computer/seccamera,
		/datum/design/circuit/computer/sentencing,
		/datum/design/item/hud/security,
		/datum/design/item/modular_weapon/firing_pin,
		/datum/design/item/modular_weapon/firing_pin/away,
		/datum/design/item/modular_weapon/modular_small,
		/datum/design/item/modular_weapon/modular_medium,
		/datum/design/item/modular_weapon/modular_large,
		/datum/design/item/modular_weapon/modular_cap,
		/datum/design/item/modular_weapon/modular_starch,
		/datum/design/item/modular_weapon/modular_lens,
		/datum/design/item/modular_weapon/modular_splitter,
		/datum/design/item/modular_weapon/modular_reinforced,
		/datum/design/item/modular_weapon/modular_laser,
		/datum/design/item/modular_weapon/modular_taser,
		/datum/design/item/modular_weapon/modular_barrel,
		/datum/design/item/modular_weapon/modular_stock,
		/datum/design/item/modular_weapon/modular_grip,
		/datum/design/item/modular_weapon/modular_vents,
		/datum/design/item/modular_weapon/modular_scope
	)

/datum/tech_node/security/nonlethal
	id = "sec_nonlethal"
	name = "Non-Lethal & Chemical Launchers"
	desc = "Stun/tracking shotgun shells, chemsprayers, rapid syringe guns, and access firing pins."
	branch = "Weapons & Security"
	tier = 2
	cost = 2600
	prereq_ids = list("sec_basics")
	icon = "bullseye"
	unlocked_designs = list(
		/datum/design/item/weapon/stunshell,
		/datum/design/item/weapon/stunshell/tracking,
		/datum/design/item/weapon/chemsprayer,
		/datum/design/item/weapon/rapidsyringe,
		/datum/design/item/modular_weapon/firing_pin/access
	)

/datum/tech_node/security/exotic_weapons
	id = "sec_exotic"
	name = "Experimental Tactical Weapons"
	desc = "Temperature guns, kinetic force gloves, and gravity-manipulating weaponry."
	branch = "Weapons & Security"
	tier = 3
	cost = 7000
	prereq_ids = list("sec_nonlethal")
	icon = "atom"
	unlocked_designs = list(
		/datum/design/item/weapon/temp_gun,
		/datum/design/item/weapon/forcegloves,
		/datum/design/item/weapon/gravity_gun
	)

/datum/tech_node/security/mod_frames
	id = "sec_mod_frames"
	name = "Precision Optics & Suppressors"
	desc = "Long-range sniper focusing lenses, silencers, and tactical weapon modifiers."
	branch = "Weapons & Security"
	tier = 2
	cost = 2800
	prereq_ids = list("sec_basics")
	icon = "crosshairs"
	unlocked_designs = list(
		/datum/design/item/modular_weapon/modular_sniper,
		/datum/design/item/modular_weapon/modular_silent
	)

/datum/tech_node/security/mod_furniture
	id = "sec_mod_furniture"
	name = "Tactical Barrels, Stocks & Bayonets"
	desc = "Nano-barrels, gyro stocks, improved grips, and combat/energy bayonets."
	branch = "Weapons & Security"
	tier = 3
	cost = 4800
	prereq_ids = list("sec_mod_frames")
	icon = "sliders-h"
	unlocked_designs = list(
		/datum/design/item/modular_weapon/modular_barrel/nano,
		/datum/design/item/modular_weapon/modular_stock/gyro,
		/datum/design/item/modular_weapon/modular_bayonet,
		/datum/design/item/modular_weapon/modular_ebayonet,
		/datum/design/item/modular_weapon/modular_grip_mk2
	)

/datum/tech_node/security/mod_modulators
	id = "sec_mod_modulators"
	name = "Directed-Energy Modulators"
	desc = "Ion, blaster, toxin, freeze, and pest/flora specialized beam modulators."
	branch = "Weapons & Security"
	tier = 3
	cost = 5800
	prereq_ids = list("sec_mod_frames")
	icon = "bolt"
	unlocked_designs = list(
		/datum/design/item/modular_weapon/modular_ion,
		/datum/design/item/modular_weapon/modular_blaster,
		/datum/design/item/modular_weapon/modular_tox,
		/datum/design/item/modular_weapon/freezing_ray,
		/datum/design/item/modular_weapon/modular_soma,
		/datum/design/item/modular_weapon/modular_beta,
		/datum/design/item/modular_weapon/modular_pest
	)

/datum/tech_node/security/mod_overcharge
	id = "sec_mod_overcharge"
	name = "High-Output Weapon Capacitors & Gatling"
	desc = "Nuclear/phoron/bluespace weapon capacitors, AEG/surge modifiers, tesla & decloner beams."
	branch = "Weapons & Security"
	tier = 4
	cost = 11200
	prereq_ids = list("sec_mod_modulators")
	icon = "radiation"
	unlocked_designs = list(
		/datum/design/item/modular_weapon/modular_capacitor_reinforced,
		/datum/design/item/modular_weapon/modular_capacitor_highcap,
		/datum/design/item/modular_weapon/modular_capacitor_highpower,
		/datum/design/item/modular_weapon/modular_nuke,
		/datum/design/item/modular_weapon/modular_teranium,
		/datum/design/item/modular_weapon/modular_phoron,
		/datum/design/item/modular_weapon/modular_bs,
		/datum/design/item/modular_weapon/modular_aeg,
		/datum/design/item/modular_weapon/modular_surge,
		/datum/design/item/modular_weapon/modular_repeater,
		/datum/design/item/modular_weapon/modular_aux,
		/datum/design/item/modular_weapon/modular_overcharge,
		/datum/design/item/modular_weapon/modular_gatling,
		/datum/design/item/modular_weapon/modular_tesla,
		/datum/design/item/modular_weapon/modular_decloner
	)

/datum/tech_node/security/hardsuit_hazard
	id = "sec_hardsuit_hazard"
	name = "Hazard & Tactical Hardsuits"
	desc = "Hazard hardsuit control modules, Falcata exoskeletons, and mounted tasers."
	branch = "Weapons & Security"
	tier = 2
	cost = 3200
	prereq_ids = list("sec_basics")
	icon = "user-shield"
	unlocked_designs = list(
		/datum/design/rig/hazard,
		/datum/design/circuit/hardsuit/hazard,
		/datum/design/circuit/hardsuit/hazard_target,
		/datum/design/rig/falcata,
		/datum/design/circuit/hardsuit/falcata,
		/datum/design/circuit/hardsuit/falcata_target,
		/datum/design/hardsuitmodules/taser_module
	)

/datum/tech_node/security/hardsuit_combat
	id = "sec_hardsuit_combat"
	name = "Heavy Combat Hardsuits"
	desc = "Combat hardsuit assemblies, targeting boards, mounted energy guns, and weapon rechargers."
	branch = "Weapons & Security"
	tier = 3
	cost = 7700
	prereq_ids = list("sec_hardsuit_hazard")
	icon = "shield-virus"
	unlocked_designs = list(
		/datum/design/rig/combat,
		/datum/design/circuit/hardsuit/combat,
		/datum/design/circuit/hardsuit/combat_target,
		/datum/design/hardsuitmodules/egun_module,
		/datum/design/hardsuitmodules/recharge_module
	)

/datum/tech_node/restricted/subversion
	id = "rest_subversion"
	name = "Covert Subversion & Infiltration"
	desc = "Binary encryption keys, pin extractors, and covert biometric implants."
	branch = "Restricted"
	tier = 1
	cost = 3500
	icon = "user-secret"
	antag_tech = TRUE
	unlocked_designs = list(
		/datum/design/item/tool/binaryencrypt,
		/datum/design/item/tool/pin_extractor,
		/datum/design/item/implant/adrenaline,
		/datum/design/item/implant/freedom
	)

/datum/tech_node/restricted/cybersuit
	id = "rest_cybersuit"
	name = "Cybersuit & Sabotage Hardware"
	desc = "Hacker cybersuit assemblies, hardsuit powersinks, and non-standard cyborg upgrades."
	branch = "Restricted"
	tier = 2
	cost = 6300
	prereq_ids = list("rest_subversion")
	icon = "mask"
	antag_tech = TRUE
	unlocked_designs = list(
		/datum/design/rig/hacker,
		/datum/design/circuit/hardsuit/hacker,
		/datum/design/circuit/hardsuit/hacker_target,
		/datum/design/hardsuitmodules/sink_module,
		/datum/design/item/robot_upgrade/syndicate,
		/datum/design/circuit/aimodule/core/tyrant
	)

/datum/tech_node/restricted/armaments
	id = "rest_armaments"
	name = "Clandestine Armaments"
	desc = "Energy shields, energy glaives, X-ray mech cannons, energy crossbows, and capture nets."
	branch = "Restricted"
	tier = 2
	cost = 7700
	prereq_ids = list("rest_subversion")
	icon = "skull"
	antag_tech = TRUE
	unlocked_designs = list(
		/datum/design/item/weapon/eshield,
		/datum/design/item/weapon/eglaive,
		/datum/design/item/mechfab/exosuit_equipment/xray,
		/datum/design/item/modular_weapon/modular_ebow,
		/datum/design/item/modular_weapon/modular_net
	)

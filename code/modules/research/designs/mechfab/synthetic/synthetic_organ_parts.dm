/datum/design/item/synthetic
	build_type = MECHFAB
	time = 12 SECONDS
	materials = list(DEFAULT_WALL_MATERIAL = 10000, MATERIAL_GLASS = 5000)
	category = "Synthetic Parts"

/datum/design/item/synthetic/air_cooling_unit
	name = "Standard Air Cooling Unit"
	desc = "Parts to assemble a retail air cooling unit."
	build_path = /obj/item/organ/internal/machine/cooling_unit/air
	materials = list(DEFAULT_WALL_MATERIAL = 10000, MATERIAL_GLASS = 5000)

/datum/design/item/synthetic/liquid_cooling_unit
	name = "Standard Liquid Cooling Unit"
	desc = "Parts to assemble a retail liquid cooling unit."
	build_path = /obj/item/organ/internal/machine/cooling_unit/liquid
	materials = list(MATERIAL_PLASTEEL = 5000, MATERIAL_GLASS = 5000, MATERIAL_ALUMINIUM = 5000)


/datum/design/item/synthetic/passive_cooling_unit
	name = "Standard Passive Cooling Unit"
	desc = "Parts to assemble a retail passive cooling unit."
	build_path = /obj/item/organ/internal/machine/cooling_unit/passive
	materials = list(MATERIAL_STEEL = 10000)

/datum/design/item/synthetic/diagnostics_unit
	name = "Diagnostics Unit"
	desc = "Parts to assemble a retail diagnostics unit."
	build_path = /obj/item/organ/internal/machine/internal_diagnostics
	materials = list(MATERIAL_PLASTEEL = 7500, MATERIAL_STEEL = 5000, MATERIAL_GLASS = 2500)

/datum/design/item/synthetic/actuator
	name = "Left Arm Actuator"
	desc = "Parts to assemble retail actuators for the left arm."
	build_path = /obj/item/organ/internal/machine/actuators/left
	materials = list(MATERIAL_PLASTEEL = 1500, MATERIAL_STEEL = 5000, MATERIAL_GLASS = 1500)

/datum/design/item/synthetic/actuator/right
	name = "Right Arm Actuator"
	desc = "Parts to assemble retail actuators for the right arm."
	build_path = /obj/item/organ/internal/machine/actuators/right
	materials = list(MATERIAL_PLASTEEL = 1500, MATERIAL_STEEL = 5000, MATERIAL_GLASS = 1500)

/datum/design/item/synthetic/hydraulics
	name = "Hydraulics"
	desc = "Parts to assemble retail hydraulics."
	build_path = /obj/item/organ/internal/machine/hydraulics
	materials = list(MATERIAL_PLASTEEL = 3000, MATERIAL_ALUMINIUM = 1500, MATERIAL_GLASS = 1500)

/datum/design/item/synthetic/voice_synthesizer
	name = "Voice Synthesizer"
	desc = "Parts to assemble a retail voice synthesizer."
	build_path = /obj/item/organ/internal/machine/voice_synthesizer
	materials = list(MATERIAL_STEEL = 5000, MATERIAL_PLASTEEL = 1000, MATERIAL_ALUMINIUM = 1500, MATERIAL_GLASS = 1500)

/datum/design/item/synthetic/ipc_tag
	name = "IPC Tag"
	desc = "Parts to assemble a proprietary and specialized tag for IPCs."
	build_path = /obj/item/organ/internal/machine/ipc_tag
	materials = list(MATERIAL_PLASTEEL = 2000, MATERIAL_ALUMINIUM = 2000, MATERIAL_GLASS = 5000, MATERIAL_DIAMOND = 1500)

/datum/design/item/synthetic/optical_sensor
	name = "Optical Sensor"
	desc = "Parts to assemble retail optical sensors."
	build_path = /obj/item/organ/internal/eyes/optical_sensor
	materials = list(MATERIAL_PLASTEEL = 1000, MATERIAL_ALUMINIUM = 3000, MATERIAL_GLASS = 10000, MATERIAL_DIAMOND = 1000)

/datum/design/item/synthetic/power_core
	name = "Power Core"
	desc = "Parts to assemble a retail power core."
	build_path = /obj/item/organ/internal/machine/power_core
	materials = list(MATERIAL_PLASTEEL = 5000, MATERIAL_ALUMINIUM = 1000, MATERIAL_GLASS = 2500, MATERIAL_URANIUM = 1500)

/datum/design/item/synthetic/reactor
	name = "Electric Reactor"
	desc = "Parts to assemble a retail electric reactor for IPCs."
	build_path = /obj/item/organ/internal/machine/reactor
	materials = list(MATERIAL_PLASTEEL = 7500, MATERIAL_ALUMINIUM = 5000, MATERIAL_GLASS = 1000)

/datum/design/item/synthetic/access_port
	name = "Access Port"
	desc = "Parts to assemble a retail access port."
	build_path = /obj/item/organ/internal/machine/access_port
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_ALUMINIUM = 2000, MATERIAL_GLASS = 1000)

/datum/design/item/synthetic/access_port
	name = "Internal Synthetic Plating"
	desc = "Specially lathed steel plates to replace destroyed plating around a synthetic's internal components."
	build_path = /obj/item/synth_plating
	materials = list(MATERIAL_STEEL = 40000)

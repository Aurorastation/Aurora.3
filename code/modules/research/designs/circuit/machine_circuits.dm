/datum/design/circuit/machine
	design_order = 3

/datum/design/circuit/machine/AssembleDesignName()
	..()
	name = "Machine Circuit Design ([item_name])"

/datum/design/circuit/machine/arcademachine
	name = "Battle Arcade Machine"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/circuitboard/arcade/battle

/datum/design/circuit/machine/oriontrail
	name = "Orion Trail Arcade Machine"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/circuitboard/arcade/orion_trail

/datum/design/circuit/machine/destructive_analyzer
	name = "Destructive Analyzer"
	req_tech = list(TECH_DATA = 2, TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/destructive_analyzer

/datum/design/circuit/machine/protolathe
	name = "Protolathe"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/protolathe

/datum/design/circuit/machine/circuit_imprinter
	name = "Circuit Imprinter"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/circuit_imprinter

/datum/design/circuit/machine/autolathe
	name = "Autolathe"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/autolathe

/datum/design/circuit/machine/chem_heater
	name = "Chemistry Heater"
	req_tech = list(TECH_BIO = 2)
	build_path = /obj/item/circuitboard/chem_heater

/datum/design/circuit/machine/rdservercontrol
	name = "R&D Server Control Console"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/rdservercontrol

/datum/design/circuit/machine/rdserver
	name = "R&D Server"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/rdserver

/datum/design/circuit/machine/mechfab
	name = "Exosuit Fabricator"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/mechfab

/datum/design/circuit/machine/mech_recharger
	name = "Mech Recharger"
	req_tech = list(TECH_DATA = 2, TECH_POWER = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/mech_recharger

/datum/design/circuit/machine/recharge_station
	name = "Cyborg Recharge Station"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/recharge_station

/datum/design/circuit/machine/holopadboard
	name = "Holopad"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/holopad

/datum/design/circuit/machine/sleeper
	name = "Sleeper"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/sleeper

/datum/design/circuit/machine/bodyscannerm
	name = "Body Scanner"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/bodyscanner

/datum/design/circuit/machine/bodyscannerc
	name = "Body Scanner Console"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/bodyscannerconsole

/datum/design/circuit/machine/optable
	name = "Operation Table Scanning"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/optable

/datum/design/circuit/machine/smartfridge
	name = "Smartfridge"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/smartfridge

/datum/design/circuit/machine/requestconsole
	name = "Request Console"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/requestconsole

/datum/design/circuit/machine/cryopod
	name = "Cryo Cell"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/cryotube

/datum/design/circuit/machine/crystelpod
	name = "Crystal Therapy Pod"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/crystelpod

/datum/design/circuit/machine/crystelpodconsole
	name = "Crystal Therapy Pod"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/crystelpodconsole

/datum/design/circuit/machine/microwave
	name = "Microwave"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/microwave

/datum/design/circuit/machine/oven
	name = "Oven"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/oven

/datum/design/circuit/machine/fryer
	name = "Deep Fryer"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/fryer

/datum/design/circuit/machine/cerealmaker
	name = "Cereal Maker"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/cerealmaker

/datum/design/circuit/machine/candymaker
	name = "Candy Machine"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/candymachine

/datum/design/circuit/machine/pacman
	name = "PACMAN-type Generator"
	req_tech = list(TECH_DATA = 3, TECH_PHORON = 3, TECH_POWER = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/pacman

/datum/design/circuit/machine/superpacman
	name = "SUPERPACMAN-type generator"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 4, TECH_ENGINEERING = 4)
	build_path = /obj/item/circuitboard/pacman/super

/datum/design/circuit/machine/mrspacman
	name = "MRSPACMAN-type generator"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 5, TECH_ENGINEERING = 5)
	build_path = /obj/item/circuitboard/pacman/mrs

/datum/design/circuit/machine/batteryrack
	name = "Cell Rack PSU"
	req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/batteryrack

/datum/design/circuit/machine/smes_cell
	name = "'SMES' Superconductive Magnetic Energy Storage"
	desc = "Allows for the construction of circuits used to build a SMES."
	req_tech = list(TECH_POWER = 7, TECH_ENGINEERING = 5)
	build_path = /obj/item/circuitboard/smes

/datum/design/circuit/machine/gas_heater
	name = "Gas Heating System"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 1)
	build_path = /obj/item/circuitboard/unary_atmos/heater

/datum/design/circuit/machine/gas_cooler
	name = "Gas Cooling System"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/unary_atmos/cooler

/datum/design/circuit/machine/biogenerator
	name = "Biogenerator"
	req_tech = list(TECH_DATA = 2)
	build_path = /obj/item/circuitboard/biogenerator

/datum/design/circuit/machine/crusher_base
	name = "Trash Compactor"
	req_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 1, TECH_MAGNET = 1, TECH_MATERIAL = 3)
	build_path = /obj/item/circuitboard/crusher

/datum/design/circuit/machine/aicore
	name = "AI Core"
	req_tech = list(TECH_DATA = 4, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/aicore

/datum/design/circuit/machine/rtg
	name = "Radioisotope Thermoelectric Generator"
	req_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 1, TECH_POWER = 3, TECH_MATERIAL = 2)
	build_path = /obj/item/circuitboard/rtg

/datum/design/circuit/machine/advanced_rtg
	name = "Advanced Radioisotope Thermoelectric Generator"
	req_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3, TECH_POWER = 3, TECH_MATERIAL = 4, TECH_PHORON = 2)
	build_path = /obj/item/circuitboard/rtg/advanced

/datum/design/circuit/machine/slot_machine
	name = "Slot Machine"
	req_tech = list(TECH_DATA = 2)
	build_path = /obj/item/circuitboard/slot_machine

/datum/design/circuit/machine/telepad
	name = "Telepad"
	req_tech = list(TECH_DATA = 4, TECH_BLUESPACE = 4, TECH_MATERIAL = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/telesci_pad

/datum/design/circuit/machine/miningdrill
	name = "Mining Drill Head"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/circuitboard/miningdrill

/datum/design/circuit/machine/miningdrillbrace
	name = "Mining Drill Brace"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/circuitboard/miningdrillbrace
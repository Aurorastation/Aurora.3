/datum/design/circuit/tcom
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	design_order = 6

/datum/design/circuit/tcom/AssembleDesignName()
	name = "Telecommunications Machinery Circuit Design ([name])"

/datum/design/circuit/tcom/AssembleDesignDesc()
	desc = "Allows for the construction of a telecommunications [name] circuit board."

/datum/design/circuit/tcom/server
	name = "Server Mainframe"
	build_path = /obj/item/circuitboard/telecomms/server

/datum/design/circuit/tcom/processor
	name = "Processor Unit"
	build_path = /obj/item/circuitboard/telecomms/processor

/datum/design/circuit/tcom/bus
	name = "Bus Mainframe"
	build_path = /obj/item/circuitboard/telecomms/bus

/datum/design/circuit/tcom/hub
	name = "Hub Mainframe"
	build_path = /obj/item/circuitboard/telecomms/hub

/datum/design/circuit/tcom/relay
	name = "Relay Mainframe"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 4, TECH_BLUESPACE = 3)
	build_path = /obj/item/circuitboard/telecomms/relay

/datum/design/circuit/tcom/broadcaster
	name = "Subspace Broadcaster"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_BLUESPACE = 2)
	build_path = /obj/item/circuitboard/telecomms/broadcaster

/datum/design/circuit/tcom/receiver
	name = "Subspace Receiver"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_BLUESPACE = 2)
	build_path = /obj/item/circuitboard/telecomms/receiver

/datum/design/circuit/tcom/ntnet_relay
	name = "NTNet Quantum Relay"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/ntnet_relay
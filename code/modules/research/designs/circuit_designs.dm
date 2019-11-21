////////////////////////////////////////////
///////////Circuit Designs/////////////////
////////////////////////////////////////////

/datum/design/circuit
	build_type = IMPRINTER
	req_tech = list(TECH_DATA = 2)
	materials = list("glass" = 2000)
	chemicals = list("sacid" = 20)

/datum/design/circuit/AssembleDesignName()
	..()
	if(build_path)
		var/obj/item/circuitboard/C = build_path
		if(initial(C.board_type) == "machine")
			name = "Machine circuit design ([item_name])"
		else if(initial(C.board_type) == "computer")
			name = "Computer circuit design ([item_name])"
		else
			name = "Circuit design ([item_name])"

/datum/design/circuit/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a [item_name] circuit board."

/datum/design/circuit/arcademachine
	name = "battle arcade machine"
	id = "arcademachine"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/circuitboard/arcade/battle
	sort_string = "MAAAA"

/datum/design/circuit/oriontrail
	name = "orion trail arcade machine"
	id = "oriontrail"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/circuitboard/arcade/orion_trail
	sort_string = "MABAA"

/datum/design/circuit/seccamera
	name = "security camera monitor"
	id = "seccamera"
	build_path = /obj/item/circuitboard/security
	sort_string = "DAAAA"

/datum/design/circuit/secdata
	name = "security records console"
	id = "sec_data"
	build_path = /obj/item/circuitboard/secure_data
	sort_string = "DABAA"

/datum/design/circuit/prisonmanage
	name = "prisoner management console"
	id = "prisonmanage"
	build_path = /obj/item/circuitboard/prisoner
	sort_string = "DACAA"

/datum/design/circuit/med_data
	name = "medical records console"
	id = "med_data"
	build_path = /obj/item/circuitboard/med_data
	sort_string = "FAAAA"

/datum/design/circuit/sentencing
	name = "criminal sentencing console"
	id = "sentencing"
	build_path = /obj/item/circuitboard/sentencing
	sort_string = "DADAA"

/datum/design/circuit/operating
	name = "patient monitoring console"
	id = "operating"
	build_path = /obj/item/circuitboard/operating
	sort_string = "FACAA"

/datum/design/circuit/operatingadv
	name = "life support console"
	id = "operatingadv"
	build_path = /obj/item/circuitboard/advoperating
	sort_string = "FACAB"

/datum/design/circuit/pandemic
	name = "PanD.E.M.I.C. 2200"
	id = "pandemic"
	build_path = /obj/item/circuitboard/pandemic
	sort_string = "FAEAA"

/datum/design/circuit/clonecontrol
	name = "cloning control console"
	id = "clonecontrol"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/cloning
	sort_string = "FAGAC"

/datum/design/circuit/clonepod
	name = "clone pod"
	id = "clonepod"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/clonepod
	sort_string = "FAGAE"

/datum/design/circuit/clonescanner
	name = "cloning scanner"
	id = "clonescanner"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/clonescanner
	sort_string = "FAGAG"

/datum/design/circuit/crewconsole
	name = "crew monitoring console"
	id = "crewconsole"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 2, TECH_BIO = 2)
	build_path = /obj/item/circuitboard/crew
	sort_string = "FAGAI"

/datum/design/circuit/teleconsole
	name = "teleporter control console"
	id = "teleconsole"
	req_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 2)
	build_path = /obj/item/circuitboard/teleporter
	sort_string = "HAAAA"

/datum/design/circuit/robocontrol
	name = "robotics control console"
	id = "robocontrol"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/robotics
	sort_string = "HAAAB"

/datum/design/circuit/mechacontrol
	name = "exosuit control console"
	id = "mechacontrol"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/mecha_control
	sort_string = "HAAAC"

/datum/design/circuit/rdconsole
	name = "R&D control console"
	id = "rdconsole"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/rdconsole
	sort_string = "HAAAE"

/datum/design/circuit/comm_monitor
	name = "telecommunications monitoring console"
	id = "comm_monitor"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/comm_monitor
	sort_string = "HAACA"

/datum/design/circuit/comm_server
	name = "telecommunications server monitoring console"
	id = "comm_server"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/comm_server
	sort_string = "HAACB"

/datum/design/circuit/message_monitor
	name = "messaging monitor console"
	id = "message_monitor"
	req_tech = list(TECH_DATA = 5)
	build_path = /obj/item/circuitboard/message_monitor
	sort_string = "HAACC"

/datum/design/circuit/aiupload
	name = "AI upload console"
	id = "aiupload"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/aiupload
	sort_string = "HAABA"

/datum/design/circuit/borgupload
	name = "cyborg upload console"
	id = "borgupload"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/borgupload
	sort_string = "HAABB"

/datum/design/circuit/destructive_analyzer
	name = "destructive analyzer"
	id = "destructive_analyzer"
	req_tech = list(TECH_DATA = 2, TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/destructive_analyzer
	sort_string = "HABAA"

/datum/design/circuit/protolathe
	name = "protolathe"
	id = "protolathe"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/protolathe
	sort_string = "HABAB"

/datum/design/circuit/circuit_imprinter
	name = "circuit imprinter"
	id = "circuit_imprinter"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/circuit_imprinter
	sort_string = "HABAC"

/datum/design/circuit/autolathe
	name = "autolathe board"
	id = "autolathe"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/autolathe
	sort_string = "HABAD"

/datum/design/circuit/chem_heater
	name = "chemistry heater"
	id = "chem_heater"
	req_tech = list(TECH_BIO = 2)
	build_path = /obj/item/circuitboard/chem_heater
	sort_string = "HABAF"

/datum/design/circuit/rdservercontrol
	name = "R&D server control console"
	id = "rdservercontrol"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/rdservercontrol
	sort_string = "HABBA"

/datum/design/circuit/rdserver
	name = "R&D server"
	id = "rdserver"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/rdserver
	sort_string = "HABBB"

/datum/design/circuit/mechfab
	name = "exosuit fabricator"
	id = "mechfab"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/mechfab
	sort_string = "HABAE"

/datum/design/circuit/mech_recharger
	name = "mech recharger"
	id = "mech_recharger"
	req_tech = list(TECH_DATA = 2, TECH_POWER = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/mech_recharger
	sort_string = "HACAA"

/datum/design/circuit/recharge_station
	name = "cyborg recharge station"
	id = "recharge_station"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/recharge_station
	sort_string = "HACAC"

/datum/design/circuit/holopadboard
	name = "holopad board"
	id = "holo_board"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/holopad
	sort_string = "HACAD"

/datum/design/circuit/sleeper
	name = "sleeper board"
	id = "sleeper_board"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/sleeper
	sort_string = "HACAE"

/datum/design/circuit/bodyscannerm
	name = "body Scanner board"
	id = "bodyscanm_board"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/bodyscanner
	sort_string = "HACAF"

/datum/design/circuit/bodyscannerc
	name = "body Scanner console board"
	id = "bodyscanc_board"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/bodyscannerconsole
	sort_string = "HACAG"

/datum/design/circuit/optable
	name = "operation table scanning board"
	id = "optable_board"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/optable
	sort_string = "HACAH"


/datum/design/circuit/optable
	name = "advanced operation table scanning board"
	id = "advoptable_board"
	req_tech = list(TECH_BIO = 4, TECH_ENGINEERING = 5)
	build_path = /obj/item/circuitboard/optableadv
	sort_string = "HACAI"


/datum/design/circuit/smartfridge
	name = "smart fridge board"
	id = "fridge_board"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/smartfridge
	sort_string = "HACAJ"

/datum/design/circuit/requestconsole
	name = "request console board"
	id = "requestconsole_board"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/requestconsole
	sort_string = "HACAI"


/datum/design/circuit/cryopod
	name = "cryo cellboard"
	id = "cryocell_board"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/cryotube
	sort_string = "HACAJ"

/datum/design/circuit/crystelpod
	name = "crystel therapy pod"
	id = "therapypod"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/crystelpod
	sort_string = "HACAK"

/datum/design/circuit/crystelpodconsole
	name = "crystel therapy pod"
	id = "therapypodconsole"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/crystelpodconsole
	sort_string = "HACAL"

/datum/design/circuit/microwave
	name = "microwave board"
	id = "microwave_board"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/microwave
	sort_string = "HACAM"

/datum/design/circuit/oven
	name = "oven board"
	id = "oven_board"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/oven
	sort_string = "HACAN"

/datum/design/circuit/fryer
	name = "deep fryer board"
	id = "fryer_board"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/fryer
	sort_string = "HACAO"

/datum/design/circuit/cerealmaker
	name = "cereal maker board"
	id = "cerealmaker_board"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/cerealmaker
	sort_string = "HACAP"

/datum/design/circuit/candymaker
	name = "candy machine board"
	id = "candymachine_board"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/candymachine
	sort_string = "HACAQ"



/datum/design/circuit/atmosalerts
	name = "atmosphere alert console"
	id = "atmosalerts"
	build_path = /obj/item/circuitboard/atmos_alert
	sort_string = "JAAAA"

/datum/design/circuit/air_management
	name = "atmosphere monitoring console"
	id = "air_management"
	build_path = /obj/item/circuitboard/air_management
	sort_string = "JAAAB"

/datum/design/circuit/rcon_console
	name = "RCON remote control console"
	id = "rcon_console"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_POWER = 5)
	build_path = /obj/item/circuitboard/rcon_console
	sort_string = "JAAAC"

/datum/design/circuit/dronecontrol
	name = "drone control console"
	id = "dronecontrol"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/drone_control
	sort_string = "JAAAD"

/datum/design/circuit/powermonitor
	name = "power monitoring console"
	id = "powermonitor"
	build_path = /obj/item/circuitboard/powermonitor
	sort_string = "JAAAE"

/datum/design/circuit/solarcontrol
	name = "solar control console"
	id = "solarcontrol"
	build_path = /obj/item/circuitboard/solar_control
	sort_string = "JAAAF"

/datum/design/circuit/pacman
	name = "PACMAN-type generator"
	id = "pacman"
	req_tech = list(TECH_DATA = 3, TECH_PHORON = 3, TECH_POWER = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/pacman
	sort_string = "JBAAA"

/datum/design/circuit/superpacman
	name = "SUPERPACMAN-type generator"
	id = "superpacman"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 4, TECH_ENGINEERING = 4)
	build_path = /obj/item/circuitboard/pacman/super
	sort_string = "JBAAB"

/datum/design/circuit/mrspacman
	name = "MRSPACMAN-type generator"
	id = "mrspacman"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 5, TECH_ENGINEERING = 5)
	build_path = /obj/item/circuitboard/pacman/mrs
	sort_string = "JBAAC"

/datum/design/circuit/batteryrack
	name = "cell rack PSU"
	id = "batteryrack"
	req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/batteryrack
	sort_string = "JBABA"

/datum/design/circuit/smes_cell
	name = "'SMES' superconductive magnetic energy storage"
	desc = "Allows for the construction of circuit boards used to build a SMES."
	id = "smes_cell"
	req_tech = list(TECH_POWER = 7, TECH_ENGINEERING = 5)
	build_path = /obj/item/circuitboard/smes
	sort_string = "JBABB"

/datum/design/circuit/gas_heater
	name = "gas heating system"
	id = "gasheater"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 1)
	build_path = /obj/item/circuitboard/unary_atmos/heater
	sort_string = "JCAAA"

/datum/design/circuit/gas_cooler
	name = "gas cooling system"
	id = "gascooler"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/unary_atmos/cooler
	sort_string = "JCAAB"

/datum/design/circuit/secure_airlock
	name = "secure airlock electronics"
	desc =  "Allows for the construction of a tamper-resistant airlock electronics."
	id = "securedoor"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/airlock_electronics/secure
	sort_string = "JDAAA"

/datum/design/circuit/biogenerator
	name = "biogenerator"
	id = "biogenerator"
	req_tech = list(TECH_DATA = 2)
	build_path = /obj/item/circuitboard/biogenerator
	sort_string = "KBAAA"

/datum/design/circuit/emp_data
	name = "employment records console"
	id = "emp_data"
	build_path = /obj/item/circuitboard/skills
	sort_string = "LAAAC"

/datum/design/circuit/mecha
	req_tech = list(TECH_DATA = 3)

/datum/design/circuit/mecha/AssembleDesignName()
	name = "Exosuit module circuit design ([name])"
/datum/design/circuit/mecha/AssembleDesignDesc()
	desc = "Allows for the construction of \a [name] module."


/datum/design/circuit/mecha/hermes_main
	name = "Hermes central control"
	id = "hermes_main"
	build_path = /obj/item/circuitboard/mecha/hermes/main
	sort_string = "MAAAB"

/datum/design/circuit/mecha/hermes_peri
	name = "Hermes peripherals control"
	id = "hermes_peri"
	build_path = /obj/item/circuitboard/mecha/hermes/peripherals
	sort_string = "MAAAC"

/datum/design/circuit/mecha/ripley_main
	name = "APLU 'Ripley' central control"
	id = "ripley_main"
	build_path = /obj/item/circuitboard/mecha/ripley/main
	sort_string = "NAAAA"

/datum/design/circuit/mecha/ripley_peri
	name = "APLU 'Ripley' peripherals control"
	id = "ripley_peri"
	build_path = /obj/item/circuitboard/mecha/ripley/peripherals
	sort_string = "NAAAB"

/datum/design/circuit/mecha/odysseus_main
	name = "'Odysseus' central control"
	id = "odysseus_main"
	req_tech = list(TECH_DATA = 3,TECH_BIO = 2)
	build_path = /obj/item/circuitboard/mecha/odysseus/main
	sort_string = "NAABA"

/datum/design/circuit/mecha/odysseus_peri
	name = "'Odysseus' peripherals control"
	id = "odysseus_peri"
	req_tech = list(TECH_DATA = 3,TECH_BIO = 2)
	build_path = /obj/item/circuitboard/mecha/odysseus/peripherals
	sort_string = "NAABB"

/datum/design/circuit/mecha/gygax_main
	name = "'Gygax' central control"
	id = "gygax_main"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/gygax/main
	sort_string = "NAACA"

/datum/design/circuit/mecha/gygax_peri
	name = "'Gygax' peripherals control"
	id = "gygax_peri"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/gygax/peripherals
	sort_string = "NAACB"

/datum/design/circuit/mecha/gygax_targ
	name = "'Gygax' weapon control and targeting"
	id = "gygax_targ"
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)
	build_path = /obj/item/circuitboard/mecha/gygax/targeting
	sort_string = "NAACC"

/datum/design/circuit/mecha/durand_main
	name = "'Durand' central control"
	id = "durand_main"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/durand/main
	sort_string = "NAADA"

/datum/design/circuit/mecha/durand_peri
	name = "'Durand' peripherals control"
	id = "durand_peri"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/durand/peripherals
	sort_string = "NAADB"

/datum/design/circuit/mecha/durand_targ
	name = "'Durand' weapon control and targeting"
	id = "durand_targ"
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)
	build_path = /obj/item/circuitboard/mecha/durand/targeting
	sort_string = "NAADC"

/datum/design/circuit/mecha/phazon_main
	name = "'Phazon' central control"
	id = "phazon_main"
	req_tech = list(TECH_DATA = 6, TECH_BLUESPACE = 6)
	build_path = /obj/item/circuitboard/mecha/phazon/main
	sort_string = "NAAEA"

/datum/design/circuit/mecha/phazon_peri
	name = "'Phazon' peripherals control"
	id = "phazon_peri"
	req_tech = list(TECH_DATA = 6, TECH_BLUESPACE = 6)
	build_path = /obj/item/circuitboard/mecha/phazon/peripherals
	sort_string = "NAAEB"

/datum/design/circuit/mecha/phazon_targ
	name = "'Phazon' weapon control and targeting"
	id = "phazon_targ"
	req_tech = list(TECH_DATA = 6, TECH_COMBAT = 6, TECH_BLUESPACE = 6)
	build_path = /obj/item/circuitboard/mecha/phazon/targeting
	sort_string = "NAAEC"

/datum/design/circuit/shield
	req_tech = list(TECH_BLUESPACE = 4, TECH_PHORON = 3)
	materials = list("glass" = 2000, "gold" = 1000)

/datum/design/circuit/shield/AssembleDesignName()
	name = "Shield generator circuit design ([name])"
/datum/design/circuit/shield/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a [name] shield generator."

/datum/design/circuit/shield/bubble
	name = "bubble"
	id = "shield_gen"
	build_path = /obj/item/circuitboard/shield_gen
	sort_string = "VAAAA"

/datum/design/circuit/shield/hull
	name = "hull"
	id = "shield_gen_ex"
	build_path = /obj/item/circuitboard/shield_gen_ex
	sort_string = "VAAAB"

/datum/design/circuit/shield/capacitor
	name = "capacitor"
	desc = "Allows for the construction of a shield capacitor circuit board."
	id = "shield_cap"
	req_tech = list(TECH_MAGNET = 3, TECH_POWER = 4)
	build_path = /obj/item/circuitboard/shield_cap
	sort_string = "VAAAC"

/datum/design/circuit/ntnet_relay
	name = "NTNet Quantum Relay"
	id = "ntnet_relay"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/ntnet_relay
	sort_string = "WAAAA"

/datum/design/circuit/crusher_base
	name = "trash compactor"
	id = "crusher_base"
	req_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 1, TECH_MAGNET = 1, TECH_MATERIAL = 3)
	build_path = /obj/item/circuitboard/crusher
	sort_string = "WAAAB"

/datum/design/circuit/aicore
	name = "AI core"
	id = "aicore"
	req_tech = list(TECH_DATA = 4, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/aicore
	sort_string = "XAAAA"

/datum/design/circuit/rtg
	name = "radioisotope thermoelectric generator"
	id = "rtg"
	req_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 1, TECH_POWER = 3, TECH_MATERIAL = 2)
	build_path = /obj/item/circuitboard/rtg
	sort_string = "WAAAC"

/datum/design/circuit/advanced_rtg
	name = "advanced radioisotope thermoelectric generator"
	id = "advanced_rtg"
	req_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3, TECH_POWER = 3, TECH_MATERIAL = 4, TECH_PHORON = 2)
	build_path = /obj/item/circuitboard/rtg/advanced
	sort_string = "WAAAD"

/datum/design/circuit/slot_machine
	name = "slot machine"
	id = "slot_machine"
	req_tech = list(TECH_DATA = 2)
	build_path = /obj/item/circuitboard/slot_machine
	sort_string = "WAAAE"

/datum/design/circuit/industrial
	name = "industrial suit central circuit board"
	id = "industrial_rig"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/rig_assembly/civilian/industrial
	sort_string = "WAAAF"

/datum/design/circuit/eva
	name = "EVA suit central circuit board"
	id = "eva_rig"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/rig_assembly/civilian/eva
	sort_string = "WAAAG"

/datum/design/circuit/ce
	name = "advanced void suit central circuit board"
	id = "ce_rig"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/rig_assembly/civilian/ce
	sort_string = "WAAAH"

/datum/design/circuit/hazmat
	name = "AMI suit central circuit board"
	id = "hazmat_rig"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/rig_assembly/civilian/hazmat
	sort_string = "WAAAI"

/datum/design/circuit/medical
	name = "rescue suit central circuit board"
	id = "medical_rig"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/rig_assembly/civilian/medical
	sort_string = "WAAAJ"

/datum/design/circuit/hazard
	name = "hazard rig central circuit board"
	id = "hazard_rig"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/rig_assembly/combat/hazard
	sort_string = "WAAAK"

/datum/design/circuit/hazard_target
	name = "hazard rig control and targeting board"
	id = "hazard_rig_target"
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 3)
	build_path = /obj/item/circuitboard/rig_assembly/combat/targeting/hazard
	sort_string = "WAAAL"

/datum/design/circuit/combat
	name = "combat rig central circuit board"
	id = "combat_rig"
	req_tech = list(TECH_DATA = 6)
	build_path = /obj/item/circuitboard/rig_assembly/combat/combat
	sort_string = "WAAAM"

/datum/design/circuit/combat_target
	name = "combat rig control and targeting board"
	id = "combat_rig_target"
	req_tech = list(TECH_DATA = 6, TECH_COMBAT = 5)
	build_path = /obj/item/circuitboard/rig_assembly/combat/targeting/combat
	sort_string = "WAAAN"

/datum/design/circuit/hacker
	name = "cybersuit rig central circuit board"
	id = "hacker_rig"
	req_tech = list(TECH_DATA = 6, TECH_ILLEGAL = 3)
	build_path = /obj/item/circuitboard/rig_assembly/illegal/hacker
	sort_string = "WAAAO"

/datum/design/circuit/hacker_target
	name = "cybersuit rig control and targeting board"
	id = "hacker_rig_target"
	req_tech = list(TECH_DATA = 6, TECH_COMBAT = 3, TECH_ILLEGAL = 3)
	build_path = /obj/item/circuitboard/rig_assembly/illegal/targeting/hacker
	sort_string = "WAAAP"
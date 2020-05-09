/datum/design/circuit/aimodule
	materials = list(MATERIAL_GLASS = 2000, MATERIAL_GOLD = 100)
	design_order = 0

/datum/design/circuit/aimodule/AssembleDesignName()
	name = "AI Law Board Design ([name])"

/datum/design/circuit/aimodule/AssembleDesignDesc()
	desc = "Allows for the construction of \a '[name]' AI law boards."

/datum/design/circuit/aimodule/safeguard
	name = "Safeguard"
	req_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)
	build_path = /obj/item/aiModule/safeguard

/datum/design/circuit/aimodule/onehuman
	name = "OneCrewMember"
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 6)
	build_path = /obj/item/aiModule/oneHuman

/datum/design/circuit/aimodule/protectstation
	name = "ProtectStation"
	req_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6)
	build_path = /obj/item/aiModule/protectStation

/datum/design/circuit/aimodule/notele
	name = "TeleporterOffline"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/aiModule/teleporterOffline

/datum/design/circuit/aimodule/quarantine
	name = "Quarantine"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 2, TECH_MATERIAL = 4)
	build_path = /obj/item/aiModule/quarantine

/datum/design/circuit/aimodule/oxygen
	name = "OxygenIsToxicToHumans"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 2, TECH_MATERIAL = 4)
	build_path = /obj/item/aiModule/oxygen

/datum/design/circuit/aimodule/freeform
	name = "Freeform"
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 4)
	build_path = /obj/item/aiModule/freeform

/datum/design/circuit/aimodule/reset
	name = "Reset"
	req_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6)
	build_path = /obj/item/aiModule/reset

/datum/design/circuit/aimodule/purge
	name = "Purge"
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 6)
	build_path = /obj/item/aiModule/purge

// Core modules
/datum/design/circuit/aimodule/core
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 6)

/datum/design/circuit/aimodule/core/AssembleDesignName()
	name = "AI Standard Law Board Design ([name])"

/datum/design/circuit/aimodule/core/AssembleDesignDesc()
	desc = "Allows for the construction of \a '[name]' AI standard law board."

/datum/design/circuit/aimodule/core/freeformcore
	name = "Freeform"
	build_path = /obj/item/aiModule/freeformcore

/datum/design/circuit/aimodule/core/asimov
	name = "Asimov"
	build_path = /obj/item/aiModule/asimov

/datum/design/circuit/aimodule/core/paladin
	name = "P.A.L.A.D.I.N."
	build_path = /obj/item/aiModule/paladin

/datum/design/circuit/aimodule/core/tyrant
	name = "T.Y.R.A.N.T."
	req_tech = list(TECH_DATA = 4, TECH_ILLEGAL = 2, TECH_MATERIAL = 6)
	build_path = /obj/item/aiModule/tyrant
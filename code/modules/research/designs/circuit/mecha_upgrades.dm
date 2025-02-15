/datum/design/circuit/exosuit_upgrade
	p_category = "Exosuit Hardware Upgrades"

/datum/design/circuit/exosuit_upgrade/AssembleDesignDesc()
	desc = "Complex circuitry which unlock certain exosuit faculties."

/datum/design/circuit/exosuit_upgrade/remote
	name = "Standard Remote Control"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3, TECH_MATERIAL = 3)
	build_path = /obj/item/remote_mecha

/datum/design/circuit/exosuit_upgrade/remote/penal
	name = "Penal Remote Control"
	build_path = /obj/item/remote_mecha/penal

/datum/design/circuit/exosuit_upgrade/remote/ai
	name = "AI Remote Control"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3, TECH_MATERIAL = 3)
	build_path = /obj/item/remote_mecha/ai

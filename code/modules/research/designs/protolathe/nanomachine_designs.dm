/datum/design/item/nanomachine
	materials = list(DEFAULT_WALL_MATERIAL = 20000, MATERIAL_GLASS = 20000)
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 3, TECH_BIO = 3, TECH_ENGINEERING = 2)
	p_category = "Nanomachine Tech Designs"

/datum/design/item/nanomachine/capsule
	name = "Nanomachine Capsule"
	desc = "A simple enough device that allows nanomachines to live outside a host body, not growing, but not decaying either."
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 50000, MATERIAL_GLASS = 40000, MATERIAL_SILVER = 30000, MATERIAL_PHORON = 20000)
	build_path = /obj/item/nanomachine_capsule

/datum/design/item/nanomachine/disk
	var/loaded_program

/datum/design/item/nanomachine/disk/Fabricate(var/newloc, var/fabricator)
	return new build_path(newloc, name, loaded_program)

/datum/design/item/nanomachine/disk/stamina_booster
	name = "Disk: Acid Neutralizer"
	desc = "Effect: Configure the nanomachines to target lactic acid modules, lowering fatigue and granting increased stamina."
	req_tech = list(TECH_DATA = 4, TECH_MAGNET = 3, TECH_BIO = 5, TECH_ENGINEERING = 2)
	loaded_program = /decl/nanomachine_effect/stamina_booster
	build_path = /obj/item/nanomachine_disk

/datum/design/item/nanomachine/disk/pain_killer
	name = "Disk: Nerve Duller"
	desc = "Effect: By attaching themselves to various vital nerves in the body, nanomachines can block the path of pain signals to the brain."
	req_tech = list(TECH_DATA = 4, TECH_MAGNET = 3, TECH_BIO = 5, TECH_ENGINEERING = 2)
	loaded_program = /decl/nanomachine_effect/pain_killer
	build_path = /obj/item/nanomachine_disk
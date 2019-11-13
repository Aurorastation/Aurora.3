/datum/design/rig
	build_type = MECHFAB
	category = "Hardsuit (Assemblies)"
	materials = list(DEFAULT_WALL_MATERIAL = 30000, "glass" = 12500)
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 2, TECH_MAGNET = 3, TECH_POWER = 3)
	time = 20

/datum/design/rig/ce
	name = "advanced voidsuit control module assembly"
	desc = "An assembly frame for an advanced voidsuit that protects against hazardous, low pressure environments."
	id = "rig_ce"
	build_path = /obj/item/rig_assembly/ce
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3, TECH_MAGNET = 3, TECH_POWER = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 25000, "glass" = 12500, "silver" = 5500, "gold" = 5500, "phoron" = 7550)

/datum/design/rig/eva
	name = "EVA suit control module assembly"
	desc = "An assembly for light rig that is desiged for repairs and maintenance to the outside of habitats and vessels."
	id = "rig_eva"
	build_path = /obj/item/rig_assembly/eva

/datum/design/rig/industrial
	name = "industrial suit control module assembly"
	desc = "An assembly for a heavy, powerful rig used by construction crews and mining corporations."
	id = "rig_industrial"
	build_path = /obj/item/rig_assembly/industrial

/datum/design/rig/hazmat
	name = "AMI control module assembly"
	desc = "An assembly for Anomalous Material Interaction hardsuit that protects against the strangest energies the universe can throw at it."
	id = "rig_hazmat"
	build_path = /obj/item/rig_assembly/hazmat
	materials = list(DEFAULT_WALL_MATERIAL = 25000, "glass" = 25000, "silver" = 5500, "gold" = 5500, "phoron" = 7550)

/datum/design/rig/medical
	name = "rescue suit control module assembly"
	desc = "An assembly for a durable suit designed for medical rescue in high risk areas."
	id = "rig_medical"
	build_path = /obj/item/rig_assembly/medical
	materials = list(DEFAULT_WALL_MATERIAL = 25000, "glass" = 12500, "silver" = 5500, "gold" = 3500, "phoron" = 7550)

/datum/design/rig/hazard
	name = "hazard hardsuit control module"
	desc = "An assembly for a security hardsuit designed for prolonged EVA in dangerous environments."
	id = "rig_hazard"
	build_path = /obj/item/rig_assembly/combat/hazard
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3, TECH_MAGNET = 3, TECH_POWER = 3, TECH_COMBAT = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 30000, "glass" = 12500, "silver" = 3500, "gold" = 5500)

/datum/design/rig/combat
	name = "combat hardsuit control module assembly"
	desc = "An assembly frame for a sleek and dangerous hardsuit for active combat."
	id = "rig_combat"
	build_path = /obj/item/rig_assembly/combat/combat
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4, TECH_MAGNET = 3, TECH_POWER = 3, TECH_COMBAT = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 30000, "glass" = 12500, "silver" = 3500, "gold" = 3500, "uranium" = 5550, "diamond" = 7500)

/datum/design/rig/hacker
	name = "cybersuit control module assembly"
	desc = "An assembly for an advanced powered armour suit with many cyberwarfare enhancements. Comes with built-in insulated gloves for safely tampering with electronics."
	id = "rig_hacker"
	build_path = /obj/item/rig_assembly/combat/illegal/hacker
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3, TECH_MAGNET = 2, TECH_POWER = 3, TECH_COMBAT = 3, TECH_ILLEGAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 25000, "glass" = 12500, "gold" = 2500, "silver" = 3500, "uranium" = 5550)
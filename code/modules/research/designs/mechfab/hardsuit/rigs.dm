/datum/design/rig
	build_type = MECHFAB
	category = "Hardsuit (Assemblies)"
	materials = list(DEFAULT_WALL_MATERIAL = 30000, MATERIAL_GLASS = 12500)
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 2, TECH_MAGNET = 3, TECH_POWER = 3)
	time = 20

/datum/design/rig/ce
	name = "Advanced Voidsuit Control Module Assembly"
	desc = "An assembly frame for an advanced voidsuit that protects against hazardous, low pressure environments."
	build_path = /obj/item/rig_assembly/ce
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3, TECH_MAGNET = 3, TECH_POWER = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 25000, MATERIAL_GLASS = 12500, MATERIAL_SILVER = 5500, MATERIAL_GOLD = 5500, MATERIAL_PHORON = 7550)

/datum/design/rig/eva
	name = "EVA Suit Control Module Assembly"
	desc = "An assembly for light rig that is desiged for repairs and maintenance to the outside of habitats and vessels."
	build_path = /obj/item/rig_assembly/eva

/datum/design/rig/industrial
	name = "Industrial Suit Control Module Assembly"
	desc = "An assembly for a heavy, powerful rig used by construction crews and mining corporations."
	build_path = /obj/item/rig_assembly/industrial

/datum/design/rig/hazmat
	name = "AMI Control Module Assembly"
	desc = "An assembly for Anomalous Material Interaction hardsuit that protects against the strangest energies the universe can throw at it."
	build_path = /obj/item/rig_assembly/hazmat
	materials = list(DEFAULT_WALL_MATERIAL = 25000, MATERIAL_GLASS = 25000, MATERIAL_SILVER = 5500, MATERIAL_GOLD = 5500, MATERIAL_PHORON = 7550)

/datum/design/rig/medical
	name = "Rescue Suit Control Module Assembly"
	desc = "An assembly for a durable suit designed for medical rescue in high risk areas."
	build_path = /obj/item/rig_assembly/medical
	materials = list(DEFAULT_WALL_MATERIAL = 25000, MATERIAL_GLASS = 12500, MATERIAL_SILVER = 5500, MATERIAL_GOLD = 3500, MATERIAL_PHORON = 7550)

/datum/design/rig/hazard
	name = "Hazard Hardsuit Control Module"
	desc = "An assembly for a security hardsuit designed for prolonged EVA in dangerous environments."
	build_path = /obj/item/rig_assembly/combat/hazard
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3, TECH_MAGNET = 3, TECH_POWER = 3, TECH_COMBAT = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 30000, MATERIAL_GLASS = 12500, MATERIAL_SILVER = 3500, MATERIAL_GOLD = 5500)

/datum/design/rig/combat
	name = "Combat Hardsuit Control Module Assembly"
	desc = "An assembly frame for a sleek and dangerous hardsuit for active combat."
	build_path = /obj/item/rig_assembly/combat/combat
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4, TECH_MAGNET = 3, TECH_POWER = 3, TECH_COMBAT = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 30000, MATERIAL_GLASS = 12500, MATERIAL_SILVER = 3500, MATERIAL_GOLD = 3500, MATERIAL_URANIUM = 5550, MATERIAL_DIAMOND = 7500)

/datum/design/rig/hacker
	name = "Cybersuit Control Module Assembly"
	desc = "An assembly for an advanced powered armour suit with many cyberwarfare enhancements. Comes with built-in insulated gloves for safely tampering with electronics."
	build_path = /obj/item/rig_assembly/combat/illegal/hacker
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3, TECH_MAGNET = 2, TECH_POWER = 3, TECH_COMBAT = 3, TECH_ILLEGAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 25000, MATERIAL_GLASS = 12500, MATERIAL_GOLD = 2500, MATERIAL_SILVER = 3500, MATERIAL_URANIUM = 5550)
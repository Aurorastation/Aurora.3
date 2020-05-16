/datum/design/item/mining
	design_order = 3

/datum/design/item/mining/AssembleDesignName()
	..()
	name = "Mining Equipment Design ([item_name])"

/datum/design/item/mining/jackhammer
	name = "Jackhammer"
	req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, MATERIAL_GLASS = 500, MATERIAL_SILVER = 500)
	build_path = /obj/item/pickaxe/jackhammer

/datum/design/item/mining/drill
	name = "Drill"
	req_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 6000, MATERIAL_GLASS = 1000) //expensive, but no need for miners.
	build_path = /obj/item/pickaxe/drill

/datum/design/item/mining/plasmacutter
	name = "Plasma Cutter"
	req_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 3, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 1500, MATERIAL_GLASS = 500, MATERIAL_GOLD = 500, MATERIAL_PHORON = 500)
	build_path = /obj/item/gun/energy/plasmacutter

/datum/design/item/mining/pick_diamond
	name = "Diamond Pickaxe"
	req_tech = list(TECH_MATERIAL = 6)
	materials = list(MATERIAL_DIAMOND = 3000)
	build_path = /obj/item/pickaxe/diamond

/datum/design/item/mining/drill_diamond
	name = "Diamond Drill"
	req_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, MATERIAL_GLASS = 1000, MATERIAL_DIAMOND = 2000)
	build_path = /obj/item/pickaxe/diamonddrill

//Frames
/datum/design/item/mining/ka_frame01
	req_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 3000)
	build_path = /obj/item/gun/custom_ka/frame01

/datum/design/item/mining/ka_frame02
	req_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 4000)
	build_path = /obj/item/gun/custom_ka/frame02

/datum/design/item/mining/ka_frame03
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_SILVER = 2000)
	build_path = /obj/item/gun/custom_ka/frame03

/datum/design/item/mining/ka_frame04
	req_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_SILVER = 2000, MATERIAL_DIAMOND = 1000)
	build_path = /obj/item/gun/custom_ka/frame04

/datum/design/item/mining/ka_frame05
	req_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 6000, MATERIAL_SILVER = 4000, MATERIAL_DIAMOND = 2000)
	build_path = /obj/item/gun/custom_ka/frame05

//Cells
/datum/design/item/mining/ka_cell01
	req_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1, TECH_MAGNET = 1, TECH_POWER = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/custom_ka_upgrade/cells/cell01

/datum/design/item/mining/ka_cell02
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 1, TECH_MAGNET = 1, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, MATERIAL_GLASS = 1000, MATERIAL_SILVER = 1000)
	build_path = /obj/item/custom_ka_upgrade/cells/cell02

/datum/design/item/mining/ka_cell03
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3, TECH_MAGNET = 2, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, MATERIAL_GLASS = 3000, MATERIAL_SILVER = 3000, MATERIAL_GOLD = 1000)
	build_path = /obj/item/custom_ka_upgrade/cells/cell03

/datum/design/item/mining/ka_cell04
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4, TECH_MAGNET = 3, TECH_POWER = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, MATERIAL_GLASS = 3000, MATERIAL_SILVER = 3000, MATERIAL_GOLD = 1000, MATERIAL_URANIUM = 5000)
	build_path = /obj/item/custom_ka_upgrade/cells/cell04

/datum/design/item/mining/ka_cell05
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 6, TECH_MAGNET = 5, TECH_POWER = 5, TECH_PHORON = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 3000, MATERIAL_SILVER = 3000, MATERIAL_GOLD = 1000, MATERIAL_PHORON = 5000)
	build_path = /obj/item/custom_ka_upgrade/cells/cell05

//Barrels
/datum/design/item/mining/ka_barrel01
	req_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1, TECH_MAGNET = 1, TECH_PHORON = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, MATERIAL_GLASS = 2000, MATERIAL_PHORON = 500)
	build_path = /obj/item/custom_ka_upgrade/barrels/barrel01

/datum/design/item/mining/ka_barrel02
	req_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1, TECH_MAGNET = 3, TECH_PHORON = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, MATERIAL_GLASS = 2000, MATERIAL_PHORON = 500)
	build_path = /obj/item/custom_ka_upgrade/barrels/barrel02

/datum/design/item/mining/ka_barrel03
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3, TECH_MAGNET = 3, TECH_PHORON = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, MATERIAL_GLASS = 2000, MATERIAL_GOLD = 2000, MATERIAL_PHORON = 1000)
	build_path = /obj/item/custom_ka_upgrade/barrels/barrel03

/datum/design/item/mining/ka_barrel04
	req_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 3, TECH_MAGNET = 5, TECH_PHORON = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 3000, MATERIAL_GOLD = 3000, MATERIAL_PHORON = 3000, MATERIAL_DIAMOND = 1000)
	build_path = /obj/item/custom_ka_upgrade/barrels/barrel04

/datum/design/item/mining/ka_barrel05
	req_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 5, TECH_MAGNET = 6, TECH_PHORON = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 6000, MATERIAL_GLASS = 4000, MATERIAL_GOLD = 4000, MATERIAL_PHORON = 4000, MATERIAL_DIAMOND = 2000)
	build_path = /obj/item/custom_ka_upgrade/barrels/barrel05

//Upgrades
/datum/design/item/mining/ka_upgrade01
	req_tech = list(TECH_POWER = 4, TECH_MAGNET = 4, TECH_DATA = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MATERIAL_GLASS = 2000, MATERIAL_GOLD = 1000)
	build_path = /obj/item/custom_ka_upgrade/upgrade_chips/damage

/datum/design/item/mining/ka_upgrade02
	req_tech = list(TECH_POWER = 4, TECH_MAGNET = 4, TECH_DATA = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MATERIAL_GLASS = 2000, MATERIAL_GOLD = 1000)
	build_path = /obj/item/custom_ka_upgrade/upgrade_chips/firerate

/datum/design/item/mining/ka_upgrade03
	req_tech = list(TECH_POWER = 4, TECH_MAGNET = 4, TECH_DATA = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MATERIAL_GLASS = 2000, MATERIAL_GOLD = 1000)
	build_path = /obj/item/custom_ka_upgrade/upgrade_chips/effeciency

/datum/design/item/mining/ka_upgrade04
	req_tech = list(TECH_POWER = 4, TECH_MAGNET = 4, TECH_DATA = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MATERIAL_GLASS = 2000, MATERIAL_GOLD = 1000)
	build_path = /obj/item/custom_ka_upgrade/upgrade_chips/recoil

/datum/design/item/mining/ka_upgrade05
	req_tech = list(TECH_POWER = 4, TECH_MAGNET = 4, TECH_DATA = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MATERIAL_GLASS = 2000, MATERIAL_GOLD = 1000)
	build_path = /obj/item/custom_ka_upgrade/upgrade_chips/focusing

/datum/design/item/mining/ka_upgrade06
	req_tech = list(TECH_POWER = 4, TECH_MAGNET = 4, TECH_DATA = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MATERIAL_GLASS = 2000, MATERIAL_GOLD = 1000)
	build_path = /obj/item/custom_ka_upgrade/upgrade_chips/capacity

/datum/design/item/mining/ka_upgrade07
	req_tech = list(TECH_POWER = 4,TECH_MAGNET = 4, TECH_DATA = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MATERIAL_GLASS = 2000, MATERIAL_GOLD = 1000)
	build_path = /obj/item/custom_ka_upgrade/upgrade_chips/explosive
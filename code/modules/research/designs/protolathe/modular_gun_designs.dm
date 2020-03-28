/datum/design/item/modular_weapon
	design_order = 2.5

/datum/design/item/modular_weapon/AssembleDesignName()
	..()
	name = "Modular Weapon Design ([capitalize_first_letters(item_name)])"

/datum/design/item/modular_weapon/modular_small
	req_tech = list(TECH_MATERIAL = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 2000)
	build_path = /obj/item/device/laser_assembly

/datum/design/item/modular_weapon/modular_medium
	req_tech = list(TECH_MATERIAL = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 4000)
	build_path = /obj/item/device/laser_assembly/medium

/datum/design/item/modular_weapon/modular_large
	req_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 8000)
	build_path = /obj/item/device/laser_assembly/large

/datum/design/item/modular_weapon/modular_cap
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 1000)
	build_path = /obj/item/laser_components/capacitor

/datum/design/item/modular_weapon/modular_starch
	req_tech = list(TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 1000)
	build_path = /obj/item/laser_components/capacitor/potato

/datum/design/item/modular_weapon/modular_capacitor_reinforced
	req_tech = list(TECH_POWER = 5, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 4000)
	build_path = /obj/item/laser_components/capacitor/reinforced

/datum/design/item/modular_weapon/modular_nuke
	req_tech = list(TECH_POWER = 5, TECH_ENGINEERING = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, MATERIAL_URANIUM = 1000)
	build_path = /obj/item/laser_components/capacitor/nuclear

/datum/design/item/modular_weapon/modular_teranium
	req_tech = list(TECH_POWER = 6, TECH_ENGINEERING = 4, TECH_MAGNET = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, MATERIAL_GLASS = 1000, MATERIAL_URANIUM = 500)
	build_path = /obj/item/laser_components/capacitor/teranium

/datum/design/item/modular_weapon/modular_phoron
	req_tech = list(TECH_POWER = 7, TECH_ENGINEERING = 5, TECH_PHORON = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, MATERIAL_PHORON = 3000, MATERIAL_URANIUM = 500)
	build_path = /obj/item/laser_components/capacitor/phoron

/datum/design/item/modular_weapon/modular_bs
	req_tech = list(TECH_POWER = 7, TECH_ENGINEERING = 7, TECH_PHORON = 6, TECH_BLUESPACE = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, MATERIAL_PHORON = 3000, MATERIAL_URANIUM = 500, MATERIAL_DIAMOND = 1000)
	build_path = /obj/item/laser_components/capacitor/bluespace

/datum/design/item/modular_weapon/modular_lens
	req_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 500, MATERIAL_GLASS = 2000)
	build_path = /obj/item/laser_components/focusing_lens

/datum/design/item/modular_weapon/modular_splitter
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 750, MATERIAL_GLASS = 2000)
	build_path = /obj/item/laser_components/focusing_lens/shotgun

/datum/design/item/modular_weapon/modular_sniper
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 750, MATERIAL_GLASS = 2000)
	build_path = /obj/item/laser_components/focusing_lens/sniper

/datum/design/item/modular_weapon/modular_reinforced
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/laser_components/focusing_lens/strong

/datum/design/item/modular_weapon/modular_silent
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 2000)
	build_path = /obj/item/laser_components/modifier/silencer

/datum/design/item/modular_weapon/modular_aeg
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 1000, MATERIAL_URANIUM = 500)
	build_path = /obj/item/laser_components/modifier/aeg

/datum/design/item/modular_weapon/modular_surge
	req_tech = list(TECH_MATERIAL = 5, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/laser_components/modifier/surge

/datum/design/item/modular_weapon/modular_repeater
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/laser_components/modifier/repeater

/datum/design/item/modular_weapon/modular_aux
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 3, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/laser_components/modifier/auxiliarycap

/datum/design/item/modular_weapon/modular_overcharge
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 4, TECH_POWER = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/laser_components/modifier/overcharge

/datum/design/item/modular_weapon/modular_gatling
	req_tech = list(TECH_COMBAT = 6, TECH_PHORON = 5, TECH_MATERIAL = 6, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 750, MATERIAL_GLASS = 3000, MATERIAL_PHORON = 2000, MATERIAL_SILVER = 2000, MATERIAL_DIAMOND = 1000)
	build_path = /obj/item/laser_components/modifier/gatling

/datum/design/item/modular_weapon/modular_scope
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MATERIAL_GLASS = 500)
	build_path = /obj/item/laser_components/modifier/scope

/datum/design/item/modular_weapon/modular_barrel
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000)
	build_path = /obj/item/laser_components/modifier/barrel

/datum/design/item/modular_weapon/modular_vents
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000)
	build_path = /obj/item/laser_components/modifier/vents

/datum/design/item/modular_weapon/modular_stock
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000)
	build_path = /obj/item/laser_components/modifier/stock

/datum/design/item/modular_weapon/modular_bayonet
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000)
	build_path = /obj/item/laser_components/modifier/bayonet

/datum/design/item/modular_weapon/modular_ebayonet
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, MATERIAL_SILVER = 500, MATERIAL_PHORON = 500)
	build_path = /obj/item/laser_components/modifier/ebayonet

/datum/design/item/modular_weapon/modular_grip
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000)
	build_path = /obj/item/laser_components/modifier/grip

/datum/design/item/modular_weapon/modular_taser
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 4000)
	build_path = /obj/item/laser_components/modulator/taser

/datum/design/item/modular_weapon/modular_tesla
	req_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 6, TECH_POWER = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, MATERIAL_SILVER = 1000, MATERIAL_PHORON = 2000)
	build_path = /obj/item/laser_components/modulator/tesla

/datum/design/item/modular_weapon/modular_ion
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 750, MATERIAL_GLASS = 500, MATERIAL_PHORON = 2000)
	build_path = /obj/item/laser_components/modulator/ion

/datum/design/item/modular_weapon/modular_soma
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MATERIAL_GLASS = 250, MATERIAL_URANIUM = 250)
	build_path = /obj/item/laser_components/modulator/floramut

/datum/design/item/modular_weapon/modular_beta
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MATERIAL_GLASS = 250, MATERIAL_URANIUM = 250)
	build_path = /obj/item/laser_components/modulator/floramut2

/datum/design/item/modular_weapon/modular_pest
	req_tech = list(TECH_MATERIAL = 1, TECH_BIO = 4, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, MATERIAL_GLASS = 1000, MATERIAL_URANIUM = 500)
	build_path = /obj/item/laser_components/modulator/arodentia

/datum/design/item/modular_weapon/modular_tag1
	req_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 2000)
	build_path = /obj/item/laser_components/modulator/red

/datum/design/item/modular_weapon/modular_tag2
	req_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 2000)
	build_path = /obj/item/laser_components/modulator/blue

/datum/design/item/modular_weapon/modular_tag3
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 2000)
	build_path = /obj/item/laser_components/modulator/omni

/datum/design/item/modular_weapon/modular_practice
	req_tech = list(TECH_MATERIAL = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 2000)
	build_path = /obj/item/laser_components/modulator/practice

/datum/design/item/modular_weapon/modular_decloner
	req_tech = list(TECH_COMBAT = 5, TECH_PHORON = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 1000, MATERIAL_PHORON = 3000)
	build_path = /obj/item/laser_components/modulator/decloner

/datum/design/item/modular_weapon/modular_ebow
	req_tech = list(TECH_COMBAT = 5, TECH_PHORON = 4, TECH_ILLEGAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 1000, MATERIAL_PHORON = 3000)
	build_path = /obj/item/laser_components/modulator/ebow

/datum/design/item/modular_weapon/modular_blaster
	req_tech = list(TECH_COMBAT = 2, TECH_PHORON = 4, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 8000, MATERIAL_GLASS = 2000, MATERIAL_PHORON = 6000)
	build_path = /obj/item/laser_components/modulator/blaster

/datum/design/item/modular_weapon/modular_laser
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 3, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 750, MATERIAL_GLASS = 500, MATERIAL_PHORON = 1000)
	build_path = /obj/item/laser_components/modulator

/datum/design/item/modular_weapon/modular_tox
	req_tech = list(TECH_COMBAT = 4, TECH_PHORON = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 2500, MATERIAL_GLASS = 1000, MATERIAL_PHORON = 2000)
	build_path = /obj/item/laser_components/modulator/tox

/datum/design/item/modular_weapon/modular_net
	req_tech = list(TECH_COMBAT = 5, TECH_PHORON = 4, TECH_ILLEGAL = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 1000, MATERIAL_PHORON = 3000)
	build_path = /obj/item/laser_components/modulator/net
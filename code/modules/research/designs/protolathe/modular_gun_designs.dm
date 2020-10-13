/datum/design/item/modular_weapon
	p_category = "Modular Weapon Designs"

/datum/design/item/modular_weapon/firing_pin
	req_tech = "{'materials':1}"
	materials = list(DEFAULT_WALL_MATERIAL = 500)
	build_path = /obj/item/device/firing_pin/test_range

/datum/design/item/modular_weapon/firing_pin/away
	build_path = /obj/item/device/firing_pin/away_site

/datum/design/item/modular_weapon/modular_small
	req_tech = "{'materials':1}"
	materials = list(DEFAULT_WALL_MATERIAL = 2000)
	build_path = /obj/item/device/laser_assembly

/datum/design/item/modular_weapon/modular_medium
	req_tech = "{'materials':1}"
	materials = list(DEFAULT_WALL_MATERIAL = 4000)
	build_path = /obj/item/device/laser_assembly/medium

/datum/design/item/modular_weapon/modular_large
	req_tech = "{'materials':1,'engineering':2}"
	materials = list(DEFAULT_WALL_MATERIAL = 8000)
	build_path = /obj/item/device/laser_assembly/large

/datum/design/item/modular_weapon/modular_cap
	req_tech = "{'powerstorage':2,'engineering':2}"
	materials = list(DEFAULT_WALL_MATERIAL = 1000)
	build_path = /obj/item/laser_components/capacitor

/datum/design/item/modular_weapon/modular_starch
	req_tech = "{'engineering':2}"
	materials = list(DEFAULT_WALL_MATERIAL = 1000)
	build_path = /obj/item/laser_components/capacitor/potato

/datum/design/item/modular_weapon/modular_capacitor_reinforced
	req_tech = "{'powerstorage':5,'engineering':3}"
	materials = list(DEFAULT_WALL_MATERIAL = 4000)
	build_path = /obj/item/laser_components/capacitor/reinforced

/datum/design/item/modular_weapon/modular_nuke
	req_tech = "{'powerstorage':5,'engineering':5}"
	materials = list(DEFAULT_WALL_MATERIAL = 4000, MATERIAL_URANIUM = 1000)
	build_path = /obj/item/laser_components/capacitor/nuclear

/datum/design/item/modular_weapon/modular_teranium
	req_tech = "{'powerstorage':6,'engineering':4,'magnets':6}"
	materials = list(DEFAULT_WALL_MATERIAL = 4000, MATERIAL_GLASS = 1000, MATERIAL_URANIUM = 500)
	build_path = /obj/item/laser_components/capacitor/teranium

/datum/design/item/modular_weapon/modular_phoron
	req_tech = "{'powerstorage':7,'engineering':5,'phorontech':5}"
	materials = list(DEFAULT_WALL_MATERIAL = 4000, MATERIAL_PHORON = 3000, MATERIAL_URANIUM = 500)
	build_path = /obj/item/laser_components/capacitor/phoron

/datum/design/item/modular_weapon/modular_bs
	req_tech = "{'powerstorage':7,'engineering':7,'phorontech':6,'bluespace':5}"
	materials = list(DEFAULT_WALL_MATERIAL = 4000, MATERIAL_PHORON = 3000, MATERIAL_URANIUM = 500, MATERIAL_DIAMOND = 1000)
	build_path = /obj/item/laser_components/capacitor/bluespace

/datum/design/item/modular_weapon/modular_lens
	req_tech = "{'materials':1,'engineering':1}"
	materials = list(DEFAULT_WALL_MATERIAL = 500, MATERIAL_GLASS = 2000)
	build_path = /obj/item/laser_components/focusing_lens

/datum/design/item/modular_weapon/modular_splitter
	req_tech = "{'materials':2,'engineering':1}"
	materials = list(DEFAULT_WALL_MATERIAL = 750, MATERIAL_GLASS = 2000)
	build_path = /obj/item/laser_components/focusing_lens/shotgun

/datum/design/item/modular_weapon/modular_sniper
	req_tech = "{'materials':2,'engineering':1}"
	materials = list(DEFAULT_WALL_MATERIAL = 750, MATERIAL_GLASS = 2000)
	build_path = /obj/item/laser_components/focusing_lens/sniper

/datum/design/item/modular_weapon/modular_reinforced
	req_tech = "{'materials':2,'engineering':1}"
	materials = list(DEFAULT_WALL_MATERIAL = 2000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/laser_components/focusing_lens/strong

/datum/design/item/modular_weapon/modular_silent
	req_tech = "{'materials':2,'engineering':2}"
	materials = list(DEFAULT_WALL_MATERIAL = 2000)
	build_path = /obj/item/laser_components/modifier/silencer

/datum/design/item/modular_weapon/modular_aeg
	req_tech = "{'combat':3,'materials':5,'powerstorage':3}"
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 1000, MATERIAL_URANIUM = 500)
	build_path = /obj/item/laser_components/modifier/aeg

/datum/design/item/modular_weapon/modular_surge
	req_tech = "{'materials':5,'powerstorage':3}"
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/laser_components/modifier/surge

/datum/design/item/modular_weapon/modular_repeater
	req_tech = "{'materials':5,'combat':3}"
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/laser_components/modifier/repeater

/datum/design/item/modular_weapon/modular_aux
	req_tech = "{'materials':5,'combat':3,'powerstorage':3}"
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/laser_components/modifier/auxiliarycap

/datum/design/item/modular_weapon/modular_overcharge
	req_tech = "{'materials':5,'combat':4,'powerstorage':4}"
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/laser_components/modifier/overcharge

/datum/design/item/modular_weapon/modular_gatling
	req_tech = "{'combat':6,'phorontech':5,'materials':6,'powerstorage':3}"
	materials = list(DEFAULT_WALL_MATERIAL = 750, MATERIAL_GLASS = 3000, MATERIAL_PHORON = 2000, MATERIAL_SILVER = 2000, MATERIAL_DIAMOND = 1000)
	build_path = /obj/item/laser_components/modifier/gatling

/datum/design/item/modular_weapon/modular_scope
	req_tech = "{'combat':2,'materials':2}"
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MATERIAL_GLASS = 500)
	build_path = /obj/item/laser_components/modifier/scope

/datum/design/item/modular_weapon/modular_barrel
	req_tech = "{'combat':2,'materials':2}"
	materials = list(DEFAULT_WALL_MATERIAL = 3000)
	build_path = /obj/item/laser_components/modifier/barrel

/datum/design/item/modular_weapon/modular_barrel/nano
	req_tech = "{'combat':3,'materials':3}"
	materials = list(DEFAULT_WALL_MATERIAL = 5000)
	build_path = /obj/item/laser_components/modifier/barrel/nano

/datum/design/item/modular_weapon/modular_vents
	req_tech = "{'combat':2,'materials':2}"
	materials = list(DEFAULT_WALL_MATERIAL = 3000)
	build_path = /obj/item/laser_components/modifier/vents

/datum/design/item/modular_weapon/modular_stock
	req_tech = "{'combat':2,'materials':2}"
	materials = list(DEFAULT_WALL_MATERIAL = 3000)
	build_path = /obj/item/laser_components/modifier/stock

/datum/design/item/modular_weapon/modular_stock/gyro
	req_tech = "{'combat':3,'materials':3}"
	materials = list(DEFAULT_WALL_MATERIAL = 5000)
	build_path = /obj/item/laser_components/modifier/stock/gyro

/datum/design/item/modular_weapon/modular_bayonet
	req_tech = "{'combat':2,'materials':2}"
	materials = list(DEFAULT_WALL_MATERIAL = 3000)
	build_path = /obj/item/laser_components/modifier/bayonet

/datum/design/item/modular_weapon/modular_ebayonet
	req_tech = "{'combat':2,'materials':2,'powerstorage':2}"
	materials = list(DEFAULT_WALL_MATERIAL = 3000, MATERIAL_SILVER = 500, MATERIAL_PHORON = 500)
	build_path = /obj/item/laser_components/modifier/ebayonet

/datum/design/item/modular_weapon/modular_grip
	req_tech = "{'combat':2,'materials':2}"
	materials = list(DEFAULT_WALL_MATERIAL = 3000)
	build_path = /obj/item/laser_components/modifier/grip

/datum/design/item/modular_weapon/modular_grip_mk2
	req_tech = "{'combat':3,'materials':3}"
	materials = list(DEFAULT_WALL_MATERIAL = 5000)
	build_path = /obj/item/laser_components/modifier/grip/improved

/datum/design/item/modular_weapon/modular_taser
	req_tech = "{'combat':3,'materials':3,'powerstorage':2}"
	materials = list(DEFAULT_WALL_MATERIAL = 4000)
	build_path = /obj/item/laser_components/modulator/taser

/datum/design/item/modular_weapon/modular_tesla
	req_tech = "{'combat':6,'materials':6,'powerstorage':4}"
	materials = list(DEFAULT_WALL_MATERIAL = 4000, MATERIAL_SILVER = 1000, MATERIAL_PHORON = 2000)
	build_path = /obj/item/laser_components/modulator/tesla

/datum/design/item/modular_weapon/modular_ion
	req_tech = "{'combat':3,'materials':3,'powerstorage':5}"
	materials = list(DEFAULT_WALL_MATERIAL = 750, MATERIAL_GLASS = 500, MATERIAL_PHORON = 2000)
	build_path = /obj/item/laser_components/modulator/ion

/datum/design/item/modular_weapon/modular_soma
	req_tech = "{'materials':2,'biotech':3,'powerstorage':3}"
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MATERIAL_GLASS = 250, MATERIAL_URANIUM = 250)
	build_path = /obj/item/laser_components/modulator/floramut

/datum/design/item/modular_weapon/modular_beta
	req_tech = "{'materials':2,'biotech':3,'powerstorage':3}"
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MATERIAL_GLASS = 250, MATERIAL_URANIUM = 250)
	build_path = /obj/item/laser_components/modulator/floramut2

/datum/design/item/modular_weapon/modular_pest
	req_tech = "{'materials':1,'biotech':4,'powerstorage':3}"
	materials = list(DEFAULT_WALL_MATERIAL = 2000, MATERIAL_GLASS = 1000, MATERIAL_URANIUM = 500)
	build_path = /obj/item/laser_components/modulator/arodentia

/datum/design/item/modular_weapon/modular_tag1
	req_tech = "{'combat':1,'materials':1}"
	materials = list(DEFAULT_WALL_MATERIAL = 2000)
	build_path = /obj/item/laser_components/modulator/red

/datum/design/item/modular_weapon/modular_tag2
	req_tech = "{'combat':1,'materials':1}"
	materials = list(DEFAULT_WALL_MATERIAL = 2000)
	build_path = /obj/item/laser_components/modulator/blue

/datum/design/item/modular_weapon/modular_tag3
	req_tech = "{'combat':2,'materials':1}"
	materials = list(DEFAULT_WALL_MATERIAL = 2000)
	build_path = /obj/item/laser_components/modulator/omni

/datum/design/item/modular_weapon/modular_practice
	req_tech = "{'materials':1}"
	materials = list(DEFAULT_WALL_MATERIAL = 2000)
	build_path = /obj/item/laser_components/modulator/practice

/datum/design/item/modular_weapon/modular_decloner
	req_tech = "{'combat':5,'phorontech':4}"
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 1000, MATERIAL_PHORON = 3000)
	build_path = /obj/item/laser_components/modulator/decloner

/datum/design/item/modular_weapon/modular_ebow
	req_tech = "{'combat':5,'phorontech':4,'syndicate':3}"
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 1000, MATERIAL_PHORON = 3000)
	build_path = /obj/item/laser_components/modulator/ebow

/datum/design/item/modular_weapon/modular_blaster
	req_tech = "{'combat':2,'phorontech':4,'materials':2}"
	materials = list(DEFAULT_WALL_MATERIAL = 8000, MATERIAL_GLASS = 2000, MATERIAL_PHORON = 6000)
	build_path = /obj/item/laser_components/modulator/blaster

/datum/design/item/modular_weapon/modular_laser
	req_tech = "{'combat':2,'materials':3,'powerstorage':3}"
	materials = list(DEFAULT_WALL_MATERIAL = 750, MATERIAL_GLASS = 500, MATERIAL_PHORON = 1000)
	build_path = /obj/item/laser_components/modulator

/datum/design/item/modular_weapon/modular_tox
	req_tech = "{'combat':4,'phorontech':3}"
	materials = list(DEFAULT_WALL_MATERIAL = 2500, MATERIAL_GLASS = 1000, MATERIAL_PHORON = 2000)
	build_path = /obj/item/laser_components/modulator/tox

/datum/design/item/modular_weapon/modular_net
	req_tech = "{'combat':5,'phorontech':4,'syndicate':4}"
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 1000, MATERIAL_PHORON = 3000)
	build_path = /obj/item/laser_components/modulator/net
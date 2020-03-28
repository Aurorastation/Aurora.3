/datum/design/item/stock_part
	design_order = 0

/datum/design/item/stock_part/AssembleDesignName()
	..()
	name = "Machine Component Design ([capitalize_first_letters(item_name)])"

/datum/design/item/stock_part/AssembleDesignDesc()
	if(!desc)
		desc = "A stock part used in the construction of various devices."

/datum/design/item/stock_part/basic_capacitor
	req_tech = list(TECH_POWER = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/stock_parts/capacitor

/datum/design/item/stock_part/adv_capacitor
	req_tech = list(TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/stock_parts/capacitor/adv

/datum/design/item/stock_part/super_capacitor
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 50, MATERIAL_GLASS = 50, MATERIAL_GOLD = 20)
	build_path = /obj/item/stock_parts/capacitor/super

/datum/design/item/stock_part/micro_mani
	req_tech = list(TECH_MATERIAL = 1, TECH_DATA = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 30)
	build_path = /obj/item/stock_parts/manipulator

/datum/design/item/stock_part/nano_mani
	req_tech = list(TECH_MATERIAL = 3, TECH_DATA = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 30)
	build_path = /obj/item/stock_parts/manipulator/nano

/datum/design/item/stock_part/pico_mani
	req_tech = list(TECH_MATERIAL = 5, TECH_DATA = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 30)
	build_path = /obj/item/stock_parts/manipulator/pico

/datum/design/item/stock_part/basic_matter_bin
	req_tech = list(TECH_MATERIAL = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 80)
	build_path = /obj/item/stock_parts/matter_bin

/datum/design/item/stock_part/adv_matter_bin
	req_tech = list(TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 80)
	build_path = /obj/item/stock_parts/matter_bin/adv

/datum/design/item/stock_part/super_matter_bin
	req_tech = list(TECH_MATERIAL = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 80)
	build_path = /obj/item/stock_parts/matter_bin/super

/datum/design/item/stock_part/basic_micro_laser
	req_tech = list(TECH_MAGNET = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 10, MATERIAL_GLASS = 20)
	build_path = /obj/item/stock_parts/micro_laser

/datum/design/item/stock_part/high_micro_laser
	req_tech = list(TECH_MAGNET = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 10, MATERIAL_GLASS = 20)
	build_path = /obj/item/stock_parts/micro_laser/high

/datum/design/item/stock_part/ultra_micro_laser
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 10, MATERIAL_GLASS = 20, MATERIAL_URANIUM = 10)
	build_path = /obj/item/stock_parts/micro_laser/ultra

/datum/design/item/stock_part/basic_sensor
	req_tech = list(TECH_MAGNET = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 50, MATERIAL_GLASS = 20)
	build_path = /obj/item/stock_parts/scanning_module

/datum/design/item/stock_part/adv_sensor
	req_tech = list(TECH_MAGNET = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 50, MATERIAL_GLASS = 20)
	build_path = /obj/item/stock_parts/scanning_module/adv

/datum/design/item/stock_part/phasic_sensor
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 50, MATERIAL_GLASS = 20, MATERIAL_SILVER = 10)
	build_path = /obj/item/stock_parts/scanning_module/phasic

/datum/design/item/stock_part/RPED
	name = "Rapid Part Exchange Device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts."
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 15000, MATERIAL_GLASS = 5000)
	build_path = /obj/item/storage/part_replacer

/datum/design/item/stock_part/subspace_ansible
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 80, MATERIAL_SILVER = 20)
	build_path = /obj/item/stock_parts/subspace/ansible

/datum/design/item/stock_part/hyperwave_filter
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 40, MATERIAL_SILVER = 10)
	build_path = /obj/item/stock_parts/subspace/filter

/datum/design/item/stock_part/subspace_amplifier
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 10, MATERIAL_GOLD = 30, MATERIAL_URANIUM = 15)
	build_path = /obj/item/stock_parts/subspace/amplifier

/datum/design/item/stock_part/subspace_treatment
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 2, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 10, MATERIAL_SILVER = 20)
	build_path = /obj/item/stock_parts/subspace/treatment

/datum/design/item/stock_part/subspace_analyzer
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 10, MATERIAL_GOLD = 15)
	build_path = /obj/item/stock_parts/subspace/analyzer

/datum/design/item/stock_part/subspace_crystal
	req_tech = list(TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list(MATERIAL_GLASS = 1000, MATERIAL_SILVER = 20, MATERIAL_GOLD = 20)
	build_path = /obj/item/stock_parts/subspace/crystal

/datum/design/item/stock_part/subspace_transmitter
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 5, TECH_BLUESPACE = 3)
	materials = list(MATERIAL_GLASS = 100, MATERIAL_SILVER = 10, MATERIAL_URANIUM = 15)
	build_path = /obj/item/stock_parts/subspace/transmitter
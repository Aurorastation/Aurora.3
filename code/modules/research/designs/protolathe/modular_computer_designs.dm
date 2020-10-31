/datum/design/item/modularcomponent
	p_category = "Modular Computer Component Designs"

// Hard drives
/datum/design/item/modularcomponent/disk/normal
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 400, MATERIAL_GLASS = 100)
	build_path = /obj/item/computer_hardware/hard_drive

/datum/design/item/modularcomponent/disk/advanced
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 800, MATERIAL_GLASS = 200)
	build_path = /obj/item/computer_hardware/hard_drive/advanced

/datum/design/item/modularcomponent/disk/super
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 1600, MATERIAL_GLASS = 400)
	build_path = /obj/item/computer_hardware/hard_drive/super

/datum/design/item/modularcomponent/disk/cluster
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 3200, MATERIAL_GLASS = 800)
	build_path = /obj/item/computer_hardware/hard_drive/cluster

/datum/design/item/modularcomponent/disk/small
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 800, MATERIAL_GLASS = 200)
	build_path = /obj/item/computer_hardware/hard_drive/small

/datum/design/item/modularcomponent/disk/micro
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 400, MATERIAL_GLASS = 100)
	build_path = /obj/item/computer_hardware/hard_drive/micro

// Network cards
/datum/design/item/modularcomponent/netcard/basic
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 1)
	build_type = IMPRINTER
	materials = list(DEFAULT_WALL_MATERIAL = 250, MATERIAL_GLASS = 100)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/computer_hardware/network_card

/datum/design/item/modularcomponent/netcard/signaler
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 1)
	build_type = IMPRINTER
	materials = list(DEFAULT_WALL_MATERIAL = 300, MATERIAL_GLASS = 150)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/computer_hardware/network_card/signaler

/datum/design/item/modularcomponent/netcard/advanced
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 2)
	build_type = IMPRINTER
	materials = list(DEFAULT_WALL_MATERIAL = 500, MATERIAL_GLASS = 200)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/computer_hardware/network_card/advanced

/datum/design/item/modularcomponent/netcard/wired
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 3)
	build_type = IMPRINTER
	materials = list(DEFAULT_WALL_MATERIAL = 2500, MATERIAL_GLASS = 400)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/computer_hardware/network_card/wired

// Data crystals (USB flash drives)
/datum/design/item/modularcomponent/portabledrive/basic
	req_tech = list(TECH_DATA = 1)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 800)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/computer_hardware/hard_drive/portable

/datum/design/item/modularcomponent/portabledrive/advanced
	req_tech = list(TECH_DATA = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 1600)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/computer_hardware/hard_drive/portable/advanced

/datum/design/item/modularcomponent/portabledrive/super
	req_tech = list(TECH_DATA = 4)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 3200)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/computer_hardware/hard_drive/portable/super

// Card slot
/datum/design/item/modularcomponent/cardslot
	name = "RFID Card Slot"
	req_tech = list(TECH_DATA = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 600)
	build_path = /obj/item/computer_hardware/card_slot

// Nano printer
/datum/design/item/modularcomponent/nanoprinter
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 600)
	build_path = /obj/item/computer_hardware/nano_printer

// Tesla Link
/datum/design/item/modularcomponent/teslalink
	req_tech = list(TECH_DATA = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 2000)
	build_path = /obj/item/computer_hardware/tesla_link

/datum/design/item/modularcomponent/teslalink/charging_cable
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 200)
	build_path = /obj/item/computer_hardware/tesla_link/charging_cable

// Batteries
/datum/design/item/modularcomponent/battery/normal
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 400)
	build_path = /obj/item/computer_hardware/battery_module

/datum/design/item/modularcomponent/battery/hotswap
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 600)
	build_path = /obj/item/computer_hardware/battery_module/hotswap

/datum/design/item/modularcomponent/battery/advanced
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 800)
	build_path = /obj/item/computer_hardware/battery_module/advanced

/datum/design/item/modularcomponent/battery/super
	req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 1600)
	build_path = /obj/item/computer_hardware/battery_module/super

/datum/design/item/modularcomponent/battery/ultra
	req_tech = list(TECH_POWER = 5, TECH_ENGINEERING = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 3200)
	build_path = /obj/item/computer_hardware/battery_module/ultra

/datum/design/item/modularcomponent/battery/nano
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 200)
	build_path = /obj/item/computer_hardware/battery_module/nano

/datum/design/item/modularcomponent/battery/micro
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 400)
	build_path = /obj/item/computer_hardware/battery_module/micro

// Processor unit
/datum/design/item/modularcomponent/cpu
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	build_type = IMPRINTER
	materials = list(DEFAULT_WALL_MATERIAL = 1600)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/computer_hardware/processor_unit

/datum/design/item/modularcomponent/cpu/small
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_type = IMPRINTER
	materials = list(DEFAULT_WALL_MATERIAL = 800)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/computer_hardware/processor_unit/small

/datum/design/item/modularcomponent/cpu/photonic
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 4)
	build_type = IMPRINTER
	materials = list(DEFAULT_WALL_MATERIAL = 6400, MATERIAL_GLASS = 2000)
	chemicals = list(/datum/reagent/acid = 40)
	build_path = /obj/item/computer_hardware/processor_unit/photonic

/datum/design/item/modularcomponent/cpu/photonic/small
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3)
	build_type = IMPRINTER
	materials = list(DEFAULT_WALL_MATERIAL = 3200, MATERIAL_GLASS = 1000)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/computer_hardware/processor_unit/photonic/small

// AI Slot
/datum/design/item/modularcomponent/aislot
	req_tech = list(TECH_POWER = 2, TECH_DATA = 3)
	build_type = IMPRINTER
	materials = list(DEFAULT_WALL_MATERIAL = 2000)
	build_path = /obj/item/computer_hardware/ai_slot
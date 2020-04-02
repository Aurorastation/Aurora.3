/datum/design/item/modularcomponent
	design_order = 9

/datum/design/item/modularcomponent/AssembleDesignName()
	..()
	name = "Modular Computer Component Design ([item_name])"

// Hard drives
/datum/design/item/modularcomponent/disk/normal
	name = "Basic Hard Drive"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 400, MATERIAL_GLASS = 100)
	build_path = /obj/item/computer_hardware/hard_drive/

/datum/design/item/modularcomponent/disk/advanced
	name = "Advanced Hard Drive"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 800, MATERIAL_GLASS = 200)
	build_path = /obj/item/computer_hardware/hard_drive/advanced

/datum/design/item/modularcomponent/disk/super
	name = "Super Hard Drive"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 1600, MATERIAL_GLASS = 400)
	build_path = /obj/item/computer_hardware/hard_drive/super

/datum/design/item/modularcomponent/disk/cluster
	name = "Cluster Hard Drive"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 3200, MATERIAL_GLASS = 800)
	build_path = /obj/item/computer_hardware/hard_drive/cluster

/datum/design/item/modularcomponent/disk/small
	name = "Small Hard Drive"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 800, MATERIAL_GLASS = 200)
	build_path = /obj/item/computer_hardware/hard_drive/small

/datum/design/item/modularcomponent/disk/micro
	name = "Micro Hard Drive"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 400, MATERIAL_GLASS = 100)
	build_path = /obj/item/computer_hardware/hard_drive/micro

// Network cards
/datum/design/item/modularcomponent/netcard/basic
	name = "Basic Network Card"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 1)
	build_type = IMPRINTER
	materials = list(DEFAULT_WALL_MATERIAL = 250, MATERIAL_GLASS = 100)
	chemicals = list("sacid" = 20)
	build_path = /obj/item/computer_hardware/network_card

/datum/design/item/modularcomponent/netcard/advanced
	name = "Advanced Network Card"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 2)
	build_type = IMPRINTER
	materials = list(DEFAULT_WALL_MATERIAL = 500, MATERIAL_GLASS = 200)
	chemicals = list("sacid" = 20)
	build_path = /obj/item/computer_hardware/network_card/advanced

/datum/design/item/modularcomponent/netcard/wired
	name = "Wired Network Card"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 3)
	build_type = IMPRINTER
	materials = list(DEFAULT_WALL_MATERIAL = 2500, MATERIAL_GLASS = 400)
	chemicals = list("sacid" = 20)
	build_path = /obj/item/computer_hardware/network_card/wired

// Data crystals (USB flash drives)
/datum/design/item/modularcomponent/portabledrive/basic
	name = "Basic Data Crystal"
	req_tech = list(TECH_DATA = 1)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 800)
	chemicals = list("sacid" = 20)
	build_path = /obj/item/computer_hardware/hard_drive/portable

/datum/design/item/modularcomponent/portabledrive/advanced
	name = "Advanced Data Crystal"
	req_tech = list(TECH_DATA = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 1600)
	chemicals = list("sacid" = 20)
	build_path = /obj/item/computer_hardware/hard_drive/portable/advanced

/datum/design/item/modularcomponent/portabledrive/super
	name = "Super Data Crystal"
	req_tech = list(TECH_DATA = 4)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 3200)
	chemicals = list("sacid" = 20)
	build_path = /obj/item/computer_hardware/hard_drive/portable/super

// Card slot
/datum/design/item/modularcomponent/cardslot
	name = "RFID Card Slot"
	req_tech = list(TECH_DATA = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 600)
	build_path = /obj/item/computer_hardware/card_slot

// Nano printer
/datum/design/item/modularcomponent/nanoprinter
	name = "Nano Printer"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 600)
	build_path = /obj/item/computer_hardware/nano_printer

// Tesla Link
/datum/design/item/modularcomponent/teslalink
	name = "Tesla Link"
	req_tech = list(TECH_DATA = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 2000)
	build_path = /obj/item/computer_hardware/tesla_link

// Batteries
/datum/design/item/modularcomponent/battery/normal
	name = "Standard Battery Module"
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 400)
	build_path = /obj/item/computer_hardware/battery_module

/datum/design/item/modularcomponent/battery/advanced
	name = "Advanced Battery Module"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 800)
	build_path = /obj/item/computer_hardware/battery_module/advanced

/datum/design/item/modularcomponent/battery/super
	name = "Super Battery Module"
	req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 1600)
	build_path = /obj/item/computer_hardware/battery_module/super

/datum/design/item/modularcomponent/battery/ultra
	name = "Ultra Battery Module"
	req_tech = list(TECH_POWER = 5, TECH_ENGINEERING = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 3200)
	build_path = /obj/item/computer_hardware/battery_module/ultra

/datum/design/item/modularcomponent/battery/nano
	name = "Nano Battery Module"
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 200)
	build_path = /obj/item/computer_hardware/battery_module/nano

/datum/design/item/modularcomponent/battery/micro
	name = "Micro Battery Module"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 400)
	build_path = /obj/item/computer_hardware/battery_module/micro

// Processor unit
/datum/design/item/modularcomponent/cpu
	name = "Computer Processor Unit"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	build_type = IMPRINTER
	materials = list(DEFAULT_WALL_MATERIAL = 1600)
	chemicals = list("sacid" = 20)
	build_path = /obj/item/computer_hardware/processor_unit

/datum/design/item/modularcomponent/cpu/small
	name = "Computer Microprocessor Unit"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_type = IMPRINTER
	materials = list(DEFAULT_WALL_MATERIAL = 800)
	chemicals = list("sacid" = 20)
	build_path = /obj/item/computer_hardware/processor_unit/small

/datum/design/item/modularcomponent/cpu/photonic
	name = "Computer Photonic Processor Unit"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 4)
	build_type = IMPRINTER
	materials = list(DEFAULT_WALL_MATERIAL = 6400, MATERIAL_GLASS = 2000)
	chemicals = list("sacid" = 40)
	build_path = /obj/item/computer_hardware/processor_unit/photonic

/datum/design/item/modularcomponent/cpu/photonic/small
	name = "Computer Photonic Microprocessor Unit"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3)
	build_type = IMPRINTER
	materials = list(DEFAULT_WALL_MATERIAL = 3200, MATERIAL_GLASS = 1000)
	chemicals = list("sacid" = 20)
	build_path = /obj/item/computer_hardware/processor_unit/photonic/small

// AI Slot
/datum/design/item/modularcomponent/aislot
	name = "Intellicard Slot"
	req_tech = list(TECH_POWER = 2, TECH_DATA = 3)
	build_type = IMPRINTER
	materials = list(DEFAULT_WALL_MATERIAL = 2000)
	build_path = /obj/item/computer_hardware/ai_slot
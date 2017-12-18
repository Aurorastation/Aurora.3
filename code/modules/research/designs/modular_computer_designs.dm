////////////////////////////////////////////
///////////Modular Computer Parts///////////
////////////////////////////////////////////

// Hard drives
/datum/design/item/modularcomponent/disk/normal
	name = "basic hard drive"
	id = "hdd_basic"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 400, "glass" = 100)
	build_path = /obj/item/computer_hardware/hard_drive/
	sort_string = "VBAAA"

/datum/design/item/modularcomponent/disk/advanced
	name = "advanced hard drive"
	id = "hdd_advanced"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 800, "glass" = 200)
	build_path = /obj/item/computer_hardware/hard_drive/advanced
	sort_string = "VBAAB"

/datum/design/item/modularcomponent/disk/super
	name = "super hard drive"
	id = "hdd_super"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 1600, "glass" = 400)
	build_path = /obj/item/computer_hardware/hard_drive/super
	sort_string = "VBAAC"

/datum/design/item/modularcomponent/disk/cluster
	name = "cluster hard drive"
	id = "hdd_cluster"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 3200, "glass" = 800)
	build_path = /obj/item/computer_hardware/hard_drive/cluster
	sort_string = "VBAAD"

/datum/design/item/modularcomponent/disk/small
	name = "small hard drive"
	id = "hdd_small"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 800, "glass" = 200)
	build_path = /obj/item/computer_hardware/hard_drive/small
	sort_string = "VBAAE"

/datum/design/item/modularcomponent/disk/micro
	name = "micro hard drive"
	id = "hdd_micro"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 400, "glass" = 100)
	build_path = /obj/item/computer_hardware/hard_drive/micro
	sort_string = "VBAAF"

// Network cards
/datum/design/item/modularcomponent/netcard/basic
	name = "basic network card"
	id = "netcard_basic"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 1)
	build_type = IMPRINTER
	materials = list(DEFAULT_WALL_MATERIAL = 250, "glass" = 100)
	chemicals = list("sacid" = 20)
	build_path = /obj/item/computer_hardware/network_card
	sort_string = "VBAAG"

/datum/design/item/modularcomponent/netcard/advanced
	name = "advanced network card"
	id = "netcard_advanced"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 2)
	build_type = IMPRINTER
	materials = list(DEFAULT_WALL_MATERIAL = 500, "glass" = 200)
	chemicals = list("sacid" = 20)
	build_path = /obj/item/computer_hardware/network_card/advanced
	sort_string = "VBAAH"

/datum/design/item/modularcomponent/netcard/wired
	name = "wired network card"
	id = "netcard_wired"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 3)
	build_type = IMPRINTER
	materials = list(DEFAULT_WALL_MATERIAL = 2500, "glass" = 400)
	chemicals = list("sacid" = 20)
	build_path = /obj/item/computer_hardware/network_card/wired
	sort_string = "VBAAI"

// Data crystals (USB flash drives)
/datum/design/item/modularcomponent/portabledrive/basic
	name = "basic data crystal"
	id = "portadrive_basic"
	req_tech = list(TECH_DATA = 1)
	build_type = IMPRINTER
	materials = list("glass" = 800)
	chemicals = list("sacid" = 20)
	build_path = /obj/item/computer_hardware/hard_drive/portable
	sort_string = "VBAAJ"

/datum/design/item/modularcomponent/portabledrive/advanced
	name = "advanced data crystal"
	id = "portadrive_advanced"
	req_tech = list(TECH_DATA = 2)
	build_type = IMPRINTER
	materials = list("glass" = 1600)
	chemicals = list("sacid" = 20)
	build_path = /obj/item/computer_hardware/hard_drive/portable/advanced
	sort_string = "VBAAK"

/datum/design/item/modularcomponent/portabledrive/super
	name = "super data crystal"
	id = "portadrive_super"
	req_tech = list(TECH_DATA = 4)
	build_type = IMPRINTER
	materials = list("glass" = 3200)
	chemicals = list("sacid" = 20)
	build_path = /obj/item/computer_hardware/hard_drive/portable/super
	sort_string = "VBAAL"

// Card slot
/datum/design/item/modularcomponent/cardslot
	name = "RFID card slot"
	id = "cardslot"
	req_tech = list(TECH_DATA = 2)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 600)
	build_path = /obj/item/computer_hardware/card_slot
	sort_string = "VBAAM"

// Nano printer
/datum/design/item/modularcomponent/nanoprinter
	name = "nano printer"
	id = "nanoprinter"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 600)
	build_path = /obj/item/computer_hardware/nano_printer
	sort_string = "VBAAN"

// Tesla Link
/datum/design/item/modularcomponent/teslalink
	name = "tesla link"
	id = "teslalink"
	req_tech = list(TECH_DATA = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 2000)
	build_path = /obj/item/computer_hardware/tesla_link
	sort_string = "VBAAO"

// Batteries
/datum/design/item/modularcomponent/battery/normal
	name = "standard battery module"
	id = "bat_normal"
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 400)
	build_path = /obj/item/computer_hardware/battery_module
	sort_string = "VBAAP"

/datum/design/item/modularcomponent/battery/advanced
	name = "advanced battery module"
	id = "bat_advanced"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 800)
	build_path = /obj/item/computer_hardware/battery_module/advanced
	sort_string = "VBAAQ"

/datum/design/item/modularcomponent/battery/super
	name = "super battery module"
	id = "bat_super"
	req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 1600)
	build_path = /obj/item/computer_hardware/battery_module/super
	sort_string = "VBAAR"

/datum/design/item/modularcomponent/battery/ultra
	name = "ultra battery module"
	id = "bat_ultra"
	req_tech = list(TECH_POWER = 5, TECH_ENGINEERING = 4)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 3200)
	build_path = /obj/item/computer_hardware/battery_module/ultra
	sort_string = "VBAAS"

/datum/design/item/modularcomponent/battery/nano
	name = "nano battery module"
	id = "bat_nano"
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 200)
	build_path = /obj/item/computer_hardware/battery_module/nano
	sort_string = "VBAAT"

/datum/design/item/modularcomponent/battery/micro
	name = "micro battery module"
	id = "bat_micro"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 400)
	build_path = /obj/item/computer_hardware/battery_module/micro
	sort_string = "VBAAU"

// Processor unit
/datum/design/item/modularcomponent/cpu/
	name = "computer processor unit"
	id = "cpu_normal"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	build_type = IMPRINTER
	materials = list(DEFAULT_WALL_MATERIAL = 1600)
	chemicals = list("sacid" = 20)
	build_path = /obj/item/computer_hardware/processor_unit
	sort_string = "VBAAV"

/datum/design/item/modularcomponent/cpu/small
	name = "computer microprocessor unit"
	id = "cpu_small"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_type = IMPRINTER
	materials = list(DEFAULT_WALL_MATERIAL = 800)
	chemicals = list("sacid" = 20)
	build_path = /obj/item/computer_hardware/processor_unit/small
	sort_string = "VBAAW"

/datum/design/item/modularcomponent/cpu/photonic
	name = "computer photonic processor unit"
	id = "pcpu_normal"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 4)
	build_type = IMPRINTER
	materials = list(DEFAULT_WALL_MATERIAL = 6400, glass = 2000)
	chemicals = list("sacid" = 40)
	build_path = /obj/item/computer_hardware/processor_unit/photonic
	sort_string = "VBAAX"

/datum/design/item/modularcomponent/cpu/photonic/small
	name = "computer photonic microprocessor unit"
	id = "pcpu_small"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3)
	build_type = IMPRINTER
	materials = list(DEFAULT_WALL_MATERIAL = 3200, glass = 1000)
	chemicals = list("sacid" = 20)
	build_path = /obj/item/computer_hardware/processor_unit/photonic/small
	sort_string = "VBAAY"

// AI Slot
/datum/design/item/modularcomponent/aislot
	name = "intellicard slot"
	id = "aislot"
	req_tech = list(TECH_POWER = 2, TECH_DATA = 3)
	build_type = IMPRINTER
	materials = list(DEFAULT_WALL_MATERIAL = 2000)
	build_path = /obj/item/computer_hardware/ai_slot
	sort_string = "VBAAZ"
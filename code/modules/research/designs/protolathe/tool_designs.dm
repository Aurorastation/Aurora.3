/datum/design/item/tool
	p_category = "Advanced Tool Designs"

/datum/design/item/tool/powerdrill
	desc = "An advanced drill designed to be faster than other drills." // my sides - Geeves
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 60, MATERIAL_GLASS = 50)
	build_path = /obj/item/powerdrill

/datum/design/item/tool/experimental_welder
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 500)
	build_path = /obj/item/weldingtool/experimental

datum/design/item/tool/advanced_light_replacer
	desc = "A specialised light replacer which stores more lights, refills faster from boxes, and sucks up broken bulbs."
	req_tech = list(TECH_MAGNET = 3, TECH_MATERIAL = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 500)
	build_path = /obj/item/device/lightreplacer/advanced

/datum/design/item/tool/advmop
	materials = list(DEFAULT_WALL_MATERIAL = 2500, MATERIAL_GLASS = 200)
	build_path = /obj/item/mop/advanced

/datum/design/item/tool/blutrash
	name = "Trashbag of Holding"
	desc = "An advanced trash bag with bluespace properties; capable of holding a plethora of garbage."
	build_type = PROTOLATHE
	materials = list(MATERIAL_GOLD = 1500, MATERIAL_URANIUM = 250, MATERIAL_PHORON = 1500)
	build_path = /obj/item/storage/bag/trash/bluespace

/datum/design/item/tool/mmi
	name = "Man-Machine Interface"
	req_tech = list(TECH_DATA = 2, TECH_BIO = 3)
	build_type = PROTOLATHE | MECHFAB
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MATERIAL_GLASS = 500)
	build_path = /obj/item/device/mmi

/datum/design/item/tool/mmi_radio
	name = "Radio-enabled Man-Machine Interface"
	req_tech = list(TECH_DATA = 2, TECH_BIO = 4)
	build_type = PROTOLATHE | MECHFAB
	materials = list(DEFAULT_WALL_MATERIAL = 1200, MATERIAL_GLASS = 500)
	build_path = /obj/item/device/mmi/radio_enabled

/datum/design/item/tool/beacon
	req_tech = list(TECH_BLUESPACE = 1)
	materials = list (DEFAULT_WALL_MATERIAL = 20, MATERIAL_GLASS = 10)
	build_path = /obj/item/device/radio/beacon

/datum/design/item/tool/bag_holding
	desc = "Using localized pockets of bluespace, this bag prototype offers incredible storage capacity, while the contents apply no weight to the external user. It's a shame the bag itself is pretty heavy."
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	materials = list(MATERIAL_GOLD = 3000, MATERIAL_DIAMOND = 1500, MATERIAL_URANIUM = 250)
	build_path = /obj/item/storage/backpack/holding

/datum/design/item/tool/power_cell_backpack
	req_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 2, TECH_POWER = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 7500, MATERIAL_GLASS = 2500)
	build_path = /obj/item/storage/backpack/cell

/datum/design/item/tool/bluespace_crystal
	desc = "An artificially made bluespace crystal."
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	materials = list(MATERIAL_GOLD = 1500, MATERIAL_DIAMOND = 1500, MATERIAL_PHORON = 1500)
	build_path = /obj/item/bluespace_crystal/artificial

/datum/design/item/tool/binaryencrypt
	desc = "Allows for deciphering the stationbound binary channel on-the-fly."
	req_tech = list(TECH_ILLEGAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 300, MATERIAL_GLASS = 300)
	build_path = /obj/item/device/encryptionkey/binary

/datum/design/item/tool/pin_extractor
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_MAGNET = 4, TECH_ILLEGAL = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 2500)
	build_path = /obj/item/device/pin_extractor

/datum/design/item/tool/analyzer
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 30, MATERIAL_GLASS = 20)
	build_path = /obj/item/device/analyzer

/datum/design/item/tool/tag_scanner
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 2500)
	build_path = /obj/item/ipc_tag_scanner

/datum/design/item/tool/plant_analyzer
	desc = "A hand-held plant scanner for hydroponicists and xenobotanists."
	req_tech = list(TECH_MAGNET = 2, TECH_BIO = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 80, MATERIAL_GLASS = 20)
	build_path = /obj/item/device/analyzer/plant_analyzer

/datum/design/item/tool/implanter
	desc = "A specialized syringe for inserting implants to subjects."
	req_tech = list(TECH_BIO = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 320, MATERIAL_GLASS = 800)
	build_path = /obj/item/implanter

/datum/design/item/tool/paicard
	req_tech = list(TECH_DATA = 2)
	materials = list(MATERIAL_GLASS = 500, DEFAULT_WALL_MATERIAL = 500)
	build_path = /obj/item/device/paicard

/datum/design/item/tool/intellicard
	desc = "Allows for the construction of an intelliCard."
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 4)
	materials = list(MATERIAL_GLASS = 1000, MATERIAL_GOLD = 200)
	build_path = /obj/item/aicard
/***************************************************************
**						Design Datums						  **
**	All the data for building stuff and tracking reliability. **
***************************************************************/
/*
For the materials datum, it assumes you need reagents unless specified otherwise. To designate a material that isn't a reagent,
you use one of the material IDs below. These are NOT ids in the usual sense (they aren't defined in the object or part of a datum),
they are simply references used as part of a "has materials?" type proc. They all start with a  to denote that they aren't reagents.
The currently supporting non-reagent materials:

Don't add new keyword/IDs if they are made from an existing one (such as rods which are made from metal). Only add raw materials.

Design Guidlines
- When adding new designs, check rdreadme.dm to see what kind of things have already been made and where new stuff is needed.
- A single sheet of anything is 2000 units of material. Materials besides metal/glass require help from other jobs (mining for
other types of metals and chemistry for reagents).

*/
//Note: More then one of these can be added to a design.

// #TODO-MERGE: Go over this file and make sure everything's fine. We might have missing vars.

/datum/design						//Datum for object designs, used in construction
	var/name = null					//Name of the created object. If null it will be 'guessed' from build_path if possible.
	var/desc = null					//Description of the created object. If null it will use group_desc and name where applicable.
	var/item_name = null			//An item name before it is modified by various name-modifying procs
	var/id = "id"					//ID of the created object for easy refernece. Alphanumeric, lower-case, no symbols.
	var/list/req_tech = list()		//IDs of that techs the object originated from and the minimum level requirements.
	var/build_type = null			//Flag as to what kind machine the design is built in. See defines.
	var/list/materials = list()		//List of materials. Format: "id" = amount.
	var/list/chemicals = list()		//List of chemicals.
	var/build_path = null			//The path of the object that gets created.
	var/time = 10					//How many ticks it requires to build
	var/category = null 			//Primarily used for Mech Fabricators, but can be used for anything.
	var/sort_string = "ZZZZZ" 		// How things are sorted

/datum/design/New()
	..()
	item_name = name
	AssembleDesignInfo()

//These procs are used in subtypes for assigning names and descriptions dynamically
/datum/design/proc/AssembleDesignInfo()
	AssembleDesignName()
	AssembleDesignDesc()
	return

/datum/design/proc/AssembleDesignName()
	if(!name && build_path)					//Get name from build path if posible
		var/atom/movable/A = build_path
		name = initial(A.name)
		item_name = name
	return

/datum/design/proc/AssembleDesignDesc()
	if(!desc)								//Try to make up a nice description if we don't have one
		desc = "Allows for the construction of \a [item_name]."
	return

//Returns a new instance of the item for this design
//This is to allow additional initialization to be performed, including possibly additional contructor arguments.
/datum/design/proc/Fabricate(var/newloc, var/fabricator)
	return new build_path(newloc)

/datum/design/item
	build_type = PROTOLATHE

/datum/design/item/design_disk
	name = "Design Storage Disk"
	desc = "Produce additional disks for storing device designs."
	id = "design_disk"
	req_tech = list(TECH_DATA = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 30, "glass" = 10)
	build_path = /obj/item/disk/design_disk
	sort_string = "GAAAA"

/datum/design/item/tech_disk
	name = "Technology Data Storage Disk"
	desc = "Produce additional disks for storing technology data."
	id = "tech_disk"
	req_tech = list(TECH_DATA = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 30, "glass" = 10)
	build_path = /obj/item/disk/tech_disk
	sort_string = "GAAAB"

/datum/design/item/flora_disk
	name = "Flora Data Storage Disk"
	desc = "Produce additional disks for storing flora data."
	id = "flora_disk"
	req_tech = list(TECH_DATA = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 30, "glass" = 10)
	build_path = /obj/item/disk/botany
	sort_string = "GAAAC"

/datum/design/item/hud
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

/datum/design/item/hud/AssembleDesignName()
	..()
	name = "HUD glasses prototype ([item_name])"

/datum/design/item/hud/AssembleDesignDesc()
	desc = "Allows for the construction of \a [item_name] HUD glasses."

/datum/design/item/hud/health
	name = "health scanner"
	id = "health_hud"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 3)
	build_path = /obj/item/clothing/glasses/hud/health
	sort_string = "GAAAA"

/datum/design/item/hud/security
	name = "security records"
	id = "security_hud"
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2)
	build_path = /obj/item/clothing/glasses/hud/security
	sort_string = "GAAAB"

/datum/design/item/mesons
	name = "Optical meson scanners design"
	desc = "Using the meson-scanning technology those glasses allow you to see through walls, floor or anything else."
	id = "mesons"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	build_path = /obj/item/clothing/glasses/meson
	sort_string = "GAAAC"


/datum/design/item/powerdrill
	name = "power drill"
	desc = "An advanced drill designed to be faster than other drills."
	id = "powerdrill"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 60, "glass" = 50)
	build_path = /obj/item/powerdrill
	sort_string = "GAAAD"

///////////////////////////////////
/////////Shield Generators/////////
///////////////////////////////////
/datum/design/circuit/shield
	req_tech = list(TECH_BLUESPACE = 4, TECH_PHORON = 3)
	materials = list("glass" = 2000, "sacid" = 20, "phoron" = 10000, "diamond" = 5000, "gold" = 10000)

/datum/design/item/implant
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

/datum/design/item/implant/AssembleDesignName()
	..()
	name = "Implantable biocircuit design ([item_name])"

/datum/design/item/implant/chemical
	name = "chemical"
	id = "implant_chem"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3)
	build_path = /obj/item/implantcase/chem
	sort_string = "MFAAA"

/datum/design/item/implant/freedom
	name = "freedom"
	id = "implant_free"
	req_tech = list(TECH_ILLEGAL = 2, TECH_BIO = 3)
	build_path = /obj/item/implantcase/freedom
	sort_string = "MFAAB"

/datum/design/item/implant/loyalty
	name = "loyalty"
	id = "implant_loyal"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 7000, "glass" = 7000)
	build_path = /obj/item/implantcase/loyalty
	sort_string = "MFAAC"

/datum/design/item/advanced_light_replacer
	name = "Advanced Light Replacer"
	desc = "A specialised light replacer which stores more lights, refills faster from boxes, and sucks up broken bulbs."
	id = "advanced_light_replacer"
	req_tech = list(TECH_MAGNET = 3, TECH_MATERIAL = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 500)
	build_path =/obj/item/device/lightreplacer/advanced
	sort_string = "VAAAH"

/datum/design/advmop
	name = "Advanced Mop"
	desc = "The most advanced tool in a custodian's arsenal, complete with a condenser for self-wetting! Just think of all the viscera you will clean up with this!"
	id = "advmop"
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 2500, "glass" = 200)
	build_path = /obj/item/mop/advanced
	sort_string = "VAAAI"

/datum/design/blutrash
	name = "Trashbag of Holding"
	desc = "An advanced trash bag with bluespace properties; capable of holding a plethora of garbage."
	id = "blutrash"
	build_type = PROTOLATHE
	materials = list("gold" = 1500, "uranium" = 250, "phoron" = 1500)
	build_path = /obj/item/storage/bag/trash/bluespace
	sort_string = "VAAAJ"

/datum/design/item/experimental_welder
	name = "Experimental Welding Tool"
	desc = "A scientifically-enhanced welding tool that uses fuel-producing microbes to gradually replenish its fuel supply"
	id = "experimental_welder"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 500)
	build_path =/obj/item/weldingtool/experimental
	sort_string = "VABAJ"

/datum/design/item/mmi
	name = "Man-machine interface"
	id = "mmi"
	req_tech = list(TECH_DATA = 2, TECH_BIO = 3)
	build_type = PROTOLATHE | MECHFAB
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 500)
	build_path = /obj/item/device/mmi
	category = "Misc"
	sort_string = "VACBA"

/datum/design/item/mmi_radio
	name = "Radio-enabled man-machine interface"
	id = "mmi_radio"
	req_tech = list(TECH_DATA = 2, TECH_BIO = 4)
	build_type = PROTOLATHE | MECHFAB
	materials = list(DEFAULT_WALL_MATERIAL = 1200, "glass" = 500)
	build_path = /obj/item/device/mmi/radio_enabled
	category = "Misc"
	sort_string = "VACBB"

/datum/design/item/beacon
	name = "Bluespace tracking beacon design"
	id = "beacon"
	req_tech = list(TECH_BLUESPACE = 1)
	materials = list (DEFAULT_WALL_MATERIAL = 20, "glass" = 10)
	build_path = /obj/item/device/radio/beacon
	sort_string = "VADAA"

/datum/design/item/bag_holding
	name = "'Bag of Holding', an infinite capacity bag prototype"
	desc = "Using localized pockets of bluespace this bag prototype offers incredible storage capacity with the contents weighting nothing. It's a shame the bag itself is pretty heavy."
	id = "bag_holding"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	materials = list("gold" = 3000, "diamond" = 1500, "uranium" = 250)
	build_path = /obj/item/storage/backpack/holding
	sort_string = "VAEAA"

/datum/design/item/bluespace_crystal
	name = "Artificial Bluespace Crystal"
	desc = "An artificially made bluespace crystal."
	id = "bluespace_crystal"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	materials = list("gold" = 1500, "diamond" = 1500, "phoron" = 1500)
	build_path = /obj/item/bluespace_crystal/artificial
	sort_string = "VAFAA"

/datum/design/item/binaryencrypt
	name = "Binary encryption key"
	desc = "Allows for deciphering the binary channel on-the-fly."
	id = "binaryencrypt"
	req_tech = list(TECH_ILLEGAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 300, "glass" = 300)
	build_path = /obj/item/device/encryptionkey/binary
	sort_string = "VASAA"

/datum/design/item/pda
	name = "PDA design"
	desc = "Cheaper than whiny non-digital assistants."
	id = "pda"
	req_tech = list(TECH_ENGINEERING = 2, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	build_path = /obj/item/device/pda
	sort_string = "VAAAA"

// Cartridges
/datum/design/item/pda_cartridge
	req_tech = list(TECH_ENGINEERING = 2, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

/datum/design/item/pda_cartridge/AssembleDesignName()
	..()
	name = "PDA accessory ([item_name])"

/datum/design/item/pda_cartridge/cart_basic
	id = "cart_basic"
	build_path = /obj/item/cartridge
	sort_string = "VBAAA"

/datum/design/item/pda_cartridge/engineering
	id = "cart_engineering"
	build_path = /obj/item/cartridge/engineering
	sort_string = "VBAAB"

/datum/design/item/pda_cartridge/atmos
	id = "cart_atmos"
	build_path = /obj/item/cartridge/atmos
	sort_string = "VBAAC"

/datum/design/item/pda_cartridge/medical
	id = "cart_medical"
	build_path = /obj/item/cartridge/medical
	sort_string = "VBAAD"

/datum/design/item/pda_cartridge/chemistry
	id = "cart_chemistry"
	build_path = /obj/item/cartridge/chemistry
	sort_string = "VBAAE"

/datum/design/item/pda_cartridge/security
	id = "cart_security"
	build_path = /obj/item/cartridge/security
	sort_string = "VBAAF"

/datum/design/item/pda_cartridge/janitor
	id = "cart_janitor"
	build_path = /obj/item/cartridge/janitor
	sort_string = "VBAAG"

/datum/design/item/pda_cartridge/science
	id = "cart_science"
	build_path = /obj/item/cartridge/signal/science
	sort_string = "VBAAH"

/datum/design/item/pda_cartridge/quartermaster
	id = "cart_quartermaster"
	build_path = /obj/item/cartridge/quartermaster
	sort_string = "VBAAI"

/datum/design/item/pda_cartridge/hop
	id = "cart_hop"
	build_path = /obj/item/cartridge/hop
	sort_string = "VBAAJ"

/datum/design/item/pda_cartridge/hos
	id = "cart_hos"
	build_path = /obj/item/cartridge/hos
	sort_string = "VBAAK"

/datum/design/item/pda_cartridge/ce
	id = "cart_ce"
	build_path = /obj/item/cartridge/ce
	sort_string = "VBAAL"

/datum/design/item/pda_cartridge/cmo
	id = "cart_cmo"
	build_path = /obj/item/cartridge/cmo
	sort_string = "VBAAM"

/datum/design/item/pda_cartridge/rd
	id = "cart_rd"
	build_path = /obj/item/cartridge/rd
	sort_string = "VBAAN"

/datum/design/item/pda_cartridge/captain
	id = "cart_captain"
	build_path = /obj/item/cartridge/captain
	sort_string = "VBAAO"

// Integrated Electronics stuff.
/datum/design/item/wirer
	name = "Custom wirer tool"
	id = "wirer"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 2500)
	build_path = /obj/item/device/integrated_electronics/wirer
	sort_string = "VBVAA"

/datum/design/item/debugger
	name = "Custom circuit debugger tool"
	id = "debugger"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 2500)
	build_path = /obj/item/device/integrated_electronics/debugger
	sort_string = "VBVAB"

/datum/design/item/custom_circuit_assembly
	name = "Small custom assembly"
	desc = "A customizable assembly for simple, small devices."
	id = "assembly-small"
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 2, TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	build_path = /obj/item/device/electronic_assembly
	sort_string = "VCAAA"

/datum/design/item/custom_circuit_assembly/medium
	name = "Medium custom assembly"
	desc = "A customizable assembly suited for more ambitious mechanisms."
	id = "assembly-medium"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 20000)
	build_path = /obj/item/device/electronic_assembly/medium
	sort_string = "VCAAB"

/datum/design/item/custom_circuit_assembly/drone
	name = "Drone custom assembly"
	desc = "A customizable assembly optimized for autonomous devices."
	id = "assembly-drone"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 4, TECH_POWER = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 30000)
	build_path = /obj/item/device/electronic_assembly/drone
	sort_string = "VCAAC"

/datum/design/item/custom_circuit_assembly/large
	name = "Large custom assembly"
	desc = "A customizable assembly for large machines."
	id = "assembly-large"
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4, TECH_POWER = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 40000)
	build_path = /obj/item/device/electronic_assembly/large
	sort_string = "VCAAD"

/datum/design/item/custom_circuit_assembly/implant
	name = "Implant custom assembly"
	desc = "An customizable assembly for very small devices, implanted into living entities."
	id = "assembly-implant"
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4, TECH_POWER = 3, TECH_BIO = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 2000)
	build_path = /obj/item/implant/integrated_circuit
	sort_string = "VCAAE"

/datum/design/item/custom_circuit_assembly/device
	name = "Device custom assembly"
	desc = "An customizable assembly designed to interface with other devices."
	id = "assembly-device"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2, TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000)
	build_path = /obj/item/device/assembly/electronic_assembly
	sort_string = "VCAAF"

/datum/design/item/custom_circuit_printer
	name = "Portable integrated circuit printer"
	desc = "A portable(ish) printer for modular machines."
	id = "ic_printer"
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 4, TECH_DATA = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	build_path = /obj/item/device/integrated_circuit_printer
	sort_string = "VCAAG"

/datum/design/item/custom_circuit_printer_upgrade
	name = "Integrated circuit printer upgrade - advanced designs"
	desc = "Allows the integrated circuit printer to create advanced circuits"
	id = "ic_printer_upgrade_adv"
	req_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 2000)
	build_path = /obj/item/disk/integrated_circuit/upgrade/advanced
	sort_string = "VCAAH"

/datum/design/item/pin_extractor
	name = "Pin extraction device"
	id = "pin_extractor"
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_MAGNET = 4, TECH_ILLEGAL = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 2500)
	build_path = /obj/item/device/pin_extractor
	sort_string = "VCBAA"

/datum/design/item/plant_analyzer
	name = "plant analyzer"
	desc = "A hand-held plant scanner for hydroponicists and xenobotanists."
	id = "plant_analyzer"
	req_tech = list(TECH_MAGNET = 2, TECH_BIO = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 80,"glass" = 20)
	build_path = /obj/item/device/analyzer/plant_analyzer
	sort_string = "VCBAB"

/datum/design/item/implanter
	name = "implanter"
	desc = "A specialized syringe for inserting implants to subjects."
	req_tech = list(TECH_ILLEGAL = 2, TECH_BIO = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 320, "glass" = 800)
	build_path = /obj/item/implanter
	sort_string = "VCBAC"

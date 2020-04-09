/datum/design/item/pda
	req_tech = list(TECH_ENGINEERING = 2, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 50, MATERIAL_GLASS = 50)
	design_order = 10

/datum/design/item/pda/AssembleDesignName()
	..()
	name = "PDA Design ([item_name])"

/datum/design/item/pda/pda
	name = "PDA"
	desc = "Cheaper than whiny non-digital assistants."
	req_tech = list(TECH_ENGINEERING = 2, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 50, MATERIAL_GLASS = 50)
	build_path = /obj/item/device/pda

// Cartridges
/datum/design/item/pda/cart_basic
	build_path = /obj/item/cartridge

/datum/design/item/pda/engineering
	build_path = /obj/item/cartridge/engineering

/datum/design/item/pda/atmos
	build_path = /obj/item/cartridge/atmos

/datum/design/item/pda/medical
	build_path = /obj/item/cartridge/medical

/datum/design/item/pda/chemistry
	build_path = /obj/item/cartridge/chemistry

/datum/design/item/pda/security
	build_path = /obj/item/cartridge/security

/datum/design/item/pda/janitor
	build_path = /obj/item/cartridge/janitor

/datum/design/item/pda/science
	build_path = /obj/item/cartridge/signal/science

/datum/design/item/pda/quartermaster
	build_path = /obj/item/cartridge/quartermaster

/datum/design/item/pda/hop
	build_path = /obj/item/cartridge/hop

/datum/design/item/pda/hos
	build_path = /obj/item/cartridge/hos

/datum/design/item/pda/ce
	build_path = /obj/item/cartridge/ce

/datum/design/item/pda/cmo
	build_path = /obj/item/cartridge/cmo

/datum/design/item/pda/rd
	build_path = /obj/item/cartridge/rd

/datum/design/item/pda/captain
	build_path = /obj/item/cartridge/captain
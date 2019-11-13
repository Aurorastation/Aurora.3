////////////////////////////////////////
//////////////////Mining/////////////////
////////////////////////////////////////
/datum/design/item/weapon/mining/AssembleDesignName()
	..()
	name = "Mining equipment design ([item_name])"

/datum/design/item/analyzer
	desc = "A hand-held environmental scanner which reports current gas levels."
	id = "analyzer"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 30,"glass" = 20)
	build_path = /obj/item/device/analyzer
	sort_string = "KCAAC"

/datum/design/item/weapon/mining/jackhammer
	id = "jackhammer"
	req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 500, "silver" = 500)
	build_path = /obj/item/pickaxe/jackhammer
	sort_string = "KAAAA"

/datum/design/item/weapon/mining/drill
	id = "drill"
	req_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "glass" = 1000) //expensive, but no need for miners.
	build_path = /obj/item/pickaxe/drill
	sort_string = "KAAAB"

/datum/design/item/weapon/mining/plasmacutter
	id = "plasmacutter"
	req_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 3, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 1500, "glass" = 500, "gold" = 500, "phoron" = 500)
	build_path = /obj/item/gun/energy/plasmacutter
	sort_string = "KAAAC"

/datum/design/item/weapon/mining/pick_diamond
	id = "pick_diamond"
	req_tech = list(TECH_MATERIAL = 6)
	materials = list("diamond" = 3000)
	build_path = /obj/item/pickaxe/diamond
	sort_string = "KAAAD"

datum/design/circuit/telesci_console
	name = "telepad control console"
	id = "telesci_console"
	req_tech = list("programming" = 3, TECH_BLUESPACE = 2)
	build_path = /obj/item/circuitboard/telesci_console

datum/design/circuit/telepad
	name = "telepad board"
	id = "telepad"
	req_tech = list("programming" = 4, TECH_BLUESPACE = 4, TECH_MATERIAL = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/telesci_pad

/datum/design/item/weapon/mining/drill_diamond
	id = "drill_diamond"
	req_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, "glass" = 1000, "diamond" = 2000)
	build_path = /obj/item/pickaxe/diamonddrill
	sort_string = "KAAAE"

/datum/design/circuit/miningdrill
	name = "mining drill head"
	id = "mining drill head"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/circuitboard/miningdrill
	sort_string = "KCAAA"

/datum/design/circuit/miningdrillbrace
	name = "mining drill brace"
	id = "mining drill brace"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/circuitboard/miningdrillbrace
	sort_string = "KCAAB"
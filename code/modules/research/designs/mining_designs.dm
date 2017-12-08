////////////////////////////////////////
//////////////////Mining/////////////////
////////////////////////////////////////
	..()
	name = "Mining equipment design ([item_name])"

	id = "jackhammer"
	req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 500, "silver" = 500)
	sort_string = "KAAAA"

	id = "drill"
	req_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "glass" = 1000) //expensive, but no need for miners.
	sort_string = "KAAAB"

	id = "plasmacutter"
	req_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 3, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 1500, "glass" = 500, "gold" = 500, "phoron" = 500)
	sort_string = "KAAAC"

	id = "pick_diamond"
	req_tech = list(TECH_MATERIAL = 6)
	materials = list("diamond" = 3000)
	sort_string = "KAAAD"

datum/design/circuit/telesci_console
	name = "telepad control console"
	id = "telesci_console"
	req_tech = list("programming" = 3, TECH_BLUESPACE = 2)

datum/design/circuit/telepad
	name = "telepad board"
	id = "telepad"
	req_tech = list("programming" = 4, TECH_BLUESPACE = 4, TECH_MATERIAL = 3, TECH_ENGINEERING = 3)

	id = "drill_diamond"
	req_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, "glass" = 1000, "diamond" = 2000)
	sort_string = "KAAAE"

/datum/design/circuit/miningdrill
	name = "mining drill head"
	id = "mining drill head"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	sort_string = "KCAAA"

/datum/design/circuit/miningdrillbrace
	name = "mining drill brace"
	id = "mining drill brace"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	sort_string = "KCAAB"
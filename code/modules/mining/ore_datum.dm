GLOBAL_LIST_EMPTY(ore_data)

/ore
	var/name
	var/display_name
	var/alloy
	var/smelts_to
	var/compresses_to
	var/result_amount     // How much ore?
	var/spread = TRUE     // Does this type of deposit spread?
	var/spread_chance     // Chance of spreading in any direction
	var/ore	              // Path to the ore produced when tile is mined.
	var/scan_icon         // Overlay for ore scanners.
	// Xenoarch stuff. No idea what it's for, just refactored it to be less awful.
	var/list/xarch_ages = list(
		"thousand" = 999,
		"million" = 999
		)
	var/xarch_source_mineral = "iron"
	var/worth = 0			  // Arbitrary point value for the ore redemption console

/ore/New()
	. = ..()
	if(!display_name)
		display_name = name

/ore/uranium
	name = ORE_URANIUM
	display_name = "pitchblende"
	smelts_to = MATERIAL_URANIUM
	result_amount = 5
	spread_chance = 15
	ore = /obj/item/ore/uranium
	scan_icon = "mineral_uncommon"
	xarch_ages = list(
		"thousand" = 999,
		"million" = 704
		)
	xarch_source_mineral = "potassium"
	worth = 25

/ore/hematite
	name = ORE_IRON
	display_name = "hematite"
	smelts_to = MATERIAL_IRON
	alloy = 1
	result_amount = 5
	spread_chance = 30
	ore = /obj/item/ore/iron
	scan_icon = "mineral_common"
	worth = 4

/ore/coal
	name = ORE_COAL
	display_name = "raw carbon"
	smelts_to = MATERIAL_PLASTIC
	compresses_to = MATERIAL_GRAPHITE
	alloy = 1
	result_amount = 5
	spread_chance = 35
	ore = /obj/item/ore/coal
	scan_icon = "mineral_common"
	worth = 2

/ore/glass
	name = ORE_SAND
	display_name = MATERIAL_GLASS
	smelts_to = MATERIAL_GLASS
	compresses_to = MATERIAL_SANDSTONE
	worth = 1

/ore/phoron
	name = ORE_PHORON
	display_name = "phoron crystals"
	compresses_to = MATERIAL_PHORON
	result_amount = 5
	spread_chance = 5
	ore = /obj/item/ore/phoron
	scan_icon = "mineral_rare"
	xarch_ages = list(
		"thousand" = 999,
		"million" = 999,
		"billion" = 13,
		"billion_lower" = 10
		)
	xarch_source_mineral = "phoron"
	worth = 30

/ore/silver
	name = ORE_SILVER
	display_name = "native silver"
	smelts_to = MATERIAL_SILVER
	result_amount = 5
	spread_chance = 15
	ore = /obj/item/ore/silver
	scan_icon = "mineral_uncommon"
	worth = 20

/ore/gold
	name = "gold"
	smelts_to = MATERIAL_GOLD
	display_name = "native gold"
	result_amount = 5
	spread_chance = 10
	ore = /obj/item/ore/gold
	scan_icon = "mineral_uncommon"
	xarch_ages = list(
		"thousand" = 999,
		"million" = 999,
		"billion" = 4,
		"billion_lower" = 3
		)
	worth = 30

/ore/diamond
	name = "diamond"
	display_name = "diamond"
	compresses_to = MATERIAL_DIAMOND
	result_amount = 5
	spread_chance = 5
	ore = /obj/item/ore/diamond
	scan_icon = "mineral_rare"
	xarch_source_mineral = "nitrogen"
	worth = 50

/ore/platinum
	name = ORE_PLATINUM
	display_name = "raw platinum"
	smelts_to = MATERIAL_PLATINUM
	compresses_to = MATERIAL_OSMIUM
	alloy = TRUE
	result_amount = 5
	spread_chance = 15
	ore = /obj/item/ore/osmium
	scan_icon = "mineral_rare"
	worth = 15

/ore/hydrogen
	name = ORE_HYDROGEN
	display_name = "metallic hydrogen"
	smelts_to = MATERIAL_TRITIUM
	compresses_to = MATERIAL_HYDROGEN_METALLIC
	scan_icon = "mineral_rare"
	worth = 30

/ore/aluminium
	name = ORE_BAUXITE
	display_name = "bauxite"
	smelts_to = MATERIAL_ALUMINIUM
	ore = /obj/item/ore/aluminium
	scan_icon = "mineral_common"
	result_amount = 5
	spread_chance = 25
	worth = 5

/ore/lead
	name = ORE_GALENA
	display_name = "galena"
	smelts_to = MATERIAL_LEAD
	ore = /obj/item/ore/lead
	scan_icon = "mineral_uncommon"
	result_amount = 5
	spread_chance = 15
	worth = 10

var/global/list/ore_data = list()

/ore
	var/name
	var/display_name
	var/alloy
	var/smelts_to
	var/compresses_to
	var/result_amount     // How much ore?
	var/spread = 1	      // Does this type of deposit spread?
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
	smelts_to = "uranium"
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
	smelts_to = "iron"
	alloy = 1
	result_amount = 5
	spread_chance = 30
	ore = /obj/item/ore/iron
	scan_icon = "mineral_common"
	worth = 4

/ore/coal
	name = ORE_COAL
	display_name = "raw carbon"
	smelts_to = "plastic"
	alloy = 1
	result_amount = 5
	spread_chance = 35
	ore = /obj/item/ore/coal
	scan_icon = "mineral_common"
	worth = 2

/ore/glass
	name = ORE_SAND
	display_name = "sand"
	smelts_to = "glass"
	compresses_to = "sandstone"
	worth = 1

/ore/phoron
	name = ORE_PHORON
	display_name = "phoron crystals"
	compresses_to = "phoron"
	result_amount = 5
	spread_chance = 25
	ore = /obj/item/ore/phoron
	scan_icon = "mineral_uncommon"
	xarch_ages = list(
		"thousand" = 999,
		"million" = 999,
		"billion" = 13,
		"billion_lower" = 10
		)
	xarch_source_mineral = "phoron"
	worth = 8

/ore/silver
	name = ORE_SILVER
	display_name = "native silver"
	smelts_to = "silver"
	result_amount = 5
	spread_chance = 15
	ore = /obj/item/ore/silver
	scan_icon = "mineral_uncommon"
	worth = 20

/ore/gold
	smelts_to = ORE_GOLD
	name = "gold"
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
	name = ORE_DIAMOND
	display_name = "diamond"
	compresses_to = "diamond"
	result_amount = 5
	spread_chance = 5
	ore = /obj/item/ore/diamond
	scan_icon = "mineral_rare"
	xarch_source_mineral = "nitrogen"
	worth = 50

/ore/platinum
	name = ORE_PLATINUM
	display_name = "raw platinum"
	smelts_to = "platinum"
	compresses_to = "osmium"
	alloy = 1
	result_amount = 5
	spread_chance = 15
	ore = /obj/item/ore/osmium
	scan_icon = "mineral_rare"
	worth = 15

/ore/hydrogen
	name = ORE_HYDROGEN
	display_name = "metallic hydrogen"
	smelts_to = "tritium"
	compresses_to = "mhydrogen"
	scan_icon = "mineral_rare"
	worth = 30

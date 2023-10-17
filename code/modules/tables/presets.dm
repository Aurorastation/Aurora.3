/obj/structure/table
	icon = 'icons/obj/structure/tables/table.dmi'
	var/table_mat
	var/table_reinf
	var/no_cargo
	build_amt = 1
	// note : material_alteration does not work here because it is constructed piece by piece and not spawned in one shot like chairs

/obj/structure/table/Initialize()
	if(table_mat)
		material = SSmaterials.get_material_by_name(table_mat)
	if(table_reinf)
		reinforced = SSmaterials.get_material_by_name(table_reinf)
	if(reinforced)
		breakable = FALSE
	. = ..()

/obj/structure/table/standard
	icon_state = "solid_preview"
	table_mat = DEFAULT_TABLE_MATERIAL

/obj/structure/table/steel
	icon = 'icons/obj/structure/tables/steel_table.dmi'
	icon_state = "steel_preview"
	table_mat = DEFAULT_WALL_MATERIAL

/obj/structure/table/stone
	icon_state = "stone_preview"
	table_mat = MATERIAL_SANDSTONE

/obj/structure/table/stone/marble
	table_mat = MATERIAL_MARBLE

/obj/structure/table/reinforced
	icon_state = "reinf_preview"
	table_mat = DEFAULT_TABLE_MATERIAL
	table_reinf = DEFAULT_TABLE_REINF_MATERIAL

/obj/structure/table/reinforced/steel
	icon = 'icons/obj/structure/tables/steel_table.dmi'
	icon_state = "reinf_steel_preview"
	table_mat = DEFAULT_WALL_MATERIAL

/obj/structure/table/reinforced/wood
	icon_state = "reinf_wood_preview"
	table_mat = MATERIAL_WOOD
	table_reinf = MATERIAL_WOOD

/obj/structure/table/reinforced/glass
	icon = 'icons/obj/structure/tables/glass_table.dmi'
	icon_state = "reinf_glass_preview"
	table_mat = MATERIAL_GLASS
	table_reinf = DEFAULT_TABLE_REINF_MATERIAL

/obj/structure/table/wood
	icon_state = "wood_preview"
	table_mat = MATERIAL_WOOD

/obj/structure/table/wood/birch
	table_mat = MATERIAL_BIRCH

/obj/structure/table/wood/mahogany
	table_mat = MATERIAL_MAHOGANY

/obj/structure/table/wood/maple
	table_mat = MATERIAL_MAPLE

/obj/structure/table/wood/bamboo
	table_mat = MATERIAL_BAMBOO

/obj/structure/table/wood/ebony
	table_mat = MATERIAL_EBONY

/obj/structure/table/wood/walnut
	table_mat = MATERIAL_WALNUT

/obj/structure/table/wood/yew
	table_mat = MATERIAL_YEW

/obj/structure/table/wood/gamblingtable
	icon_state = "gamble_preview"
	carpeted = 1

/obj/structure/table/glass
	icon = 'icons/obj/structure/tables/glass_table.dmi'
	icon_state = "glass_preview"
	table_mat = MATERIAL_GLASS

/obj/structure/table/skrell
	icon = 'icons/obj/structure/tables/skrell_table.dmi'
	icon_state = "skrell_preview"
	table_mat = MATERIAL_SHUTTLE_SKRELL

/obj/structure/table/diona
	icon = 'icons/obj/structure/tables/diona_table.dmi'
	icon_state = "biomass_preview"
	table_mat = MATERIAL_DIONA

// holotables

/obj/structure/table/holotable
	icon_state = "solid_preview"
	table_mat = MATERIAL_PLASTIC_HOLO

/obj/structure/table/holotable/holowood
	icon_state = "wood_preview"
	table_mat = MATERIAL_WOOD_HOLO

// fancy tables

/obj/structure/table/fancy
	icon = 'icons/obj/structure/tables/fancy_table.dmi'
	icon_state = "carpet_preview"
	table_mat = MATERIAL_CARPET

/obj/structure/table/fancy/black
	icon = 'icons/obj/structure/tables/fancy_table_black.dmi'
	icon_state = "carpet_black_preview"
	table_mat = MATERIAL_CARPET_BLACK

/obj/structure/table/fancy/blue
	icon = 'icons/obj/structure/tables/fancy_table_blue.dmi'
	icon_state = "carpet_blue_preview"
	table_mat = MATERIAL_CARPET_BLUE

/obj/structure/table/fancy/cyan
	icon = 'icons/obj/structure/tables/fancy_table_cyan.dmi'
	icon_state = "carpet_cyan_preview"
	table_mat = MATERIAL_CARPET_CYAN

/obj/structure/table/fancy/green
	icon = 'icons/obj/structure/tables/fancy_table_green.dmi'
	icon_state = "carpet_green_preview"
	table_mat = MATERIAL_CARPET_GREEN

/obj/structure/table/fancy/orange
	icon = 'icons/obj/structure/tables/fancy_table_orange.dmi'
	icon_state = "carpet_orange_preview"
	table_mat = MATERIAL_CARPET_ORANGE

/obj/structure/table/fancy/purple
	icon = 'icons/obj/structure/tables/fancy_table_purple.dmi'
	icon_state = "carpet_purple_preview"
	table_mat = MATERIAL_CARPET_PURPLE

/obj/structure/table/fancy/red
	icon = 'icons/obj/structure/tables/fancy_table_red.dmi'
	icon_state = "carpet_red_preview"
	table_mat = MATERIAL_CARPET_RED

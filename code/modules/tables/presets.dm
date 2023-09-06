/obj/structure/table
	var/table_mat
	var/table_reinf
	var/no_cargo
	material_alteration = MATERIAL_ALTERATION_ALL
	build_amt = 1

/obj/structure/table/Initialize()
	if(table_mat)
		material = SSmaterials.get_material_by_name(table_mat)
	if(table_reinf)
		reinforced = SSmaterials.get_material_by_name(table_reinf)
	if(reinforced)
		breakable = FALSE
	. = ..()

/obj/structure/table/standard
	icon = 'icons/obj/structure/tables/steel_table.dmi'
	icon_state = "steel_preview"
	table_mat = DEFAULT_TABLE_MATERIAL

/obj/structure/table/steel
	icon = 'icons/obj/structure/tables/steel_table.dmi'
	icon_state = "steel_preview"
	table_mat = DEFAULT_WALL_MATERIAL

/obj/structure/table/stone
	icon = 'icons/obj/structure/tables/marble_table.dmi'
	icon_state = "stone_preview"
	table_mat = MATERIAL_SANDSTONE

/obj/structure/table/stone/marble
	table_mat = MATERIAL_MARBLE

/obj/structure/table/reinforced
	icon = 'icons/obj/structure/tables/reinforced_table.dmi'
	icon_state = "reinf_preview"
	table_mat = DEFAULT_TABLE_MATERIAL
	table_reinf = DEFAULT_WALL_MATERIAL

/obj/structure/table/reinforced/steel
	table_mat = DEFAULT_WALL_MATERIAL

/obj/structure/table/reinforced/wood
	icon = 'icons/obj/structure/tables/wood_table.dmi'
	icon_state = "wood_preview"
	table_mat = MATERIAL_WOOD
	table_reinf = MATERIAL_WOOD

/obj/structure/table/reinforced/glass
	icon = 'icons/obj/structure/tables/rglass_table.dmi'
	icon_state = "rglass_preview"
	table_mat = MATERIAL_GLASS_REINFORCED
	table_reinf = MATERIAL_GLASS_REINFORCED
	material_alteration = MATERIAL_ALTERATION_NAME || MATERIAL_ALTERATION_DESC

/obj/structure/table/wood
	icon = 'icons/obj/structure/tables/wood_table.dmi'
	icon_state = "wood_preview"
	table_mat = MATERIAL_WOOD
	material_alteration = MATERIAL_ALTERATION_ALL

/obj/structure/table/wood/gamblingtable
	icon_state = "gamble_preview"
	carpeted = 1

/obj/structure/table/glass
	icon = 'icons/obj/structure/tables/glass_table.dmi'
	icon_state = "glass_preview"
	table_mat = MATERIAL_GLASS
	material_alteration = MATERIAL_ALTERATION_NAME || MATERIAL_ALTERATION_DESC

/obj/structure/table/skrell
	icon = 'icons/obj/structure/tables/skrell_table.dmi'
	icon_state = "skrell_preview"
	table_mat = MATERIAL_SHUTTLE_SKRELL
	material_alteration = MATERIAL_ALTERATION_NAME || MATERIAL_ALTERATION_DESC

/obj/structure/table/diona
	icon = 'icons/obj/structure/tables/diona_table.dmi'
	icon_state = "biomass_preview"
	table_mat = MATERIAL_DIONA
	material_alteration = MATERIAL_ALTERATION_NAME || MATERIAL_ALTERATION_DESC

/obj/structure/table/holotable
	icon = 'icons/obj/structure/tables/steel_table.dmi'
	icon_state = "steel_preview"
	table_mat = MATERIAL_PLASTIC_HOLO

/obj/structure/table/holotable/holowood
	icon = 'icons/obj/structure/tables/wood_table.dmi'
	icon_state = "wood_preview"
	table_mat = MATERIAL_WOOD_HOLO

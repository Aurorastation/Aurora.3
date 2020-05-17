/obj/structure/table
	var/table_mat
	var/table_reinf

/obj/structure/table/Initialize()
	if(table_mat)
		material = SSmaterials.get_material_by_name(table_mat)
	if(table_reinf)
		reinforced = SSmaterials.get_material_by_name(table_reinf)
	. = ..()

/obj/structure/table/standard
	icon_state = "plain_preview"
	table_mat = DEFAULT_TABLE_MATERIAL

/obj/structure/table/steel
	icon_state = "plain_preview"
	table_mat = DEFAULT_WALL_MATERIAL

/obj/structure/table/stone
	icon_state = "stone_preview"
	table_mat = MATERIAL_SANDSTONE

/obj/structure/table/stone/marble
	table_mat = MATERIAL_MARBLE

/obj/structure/table/reinforced
	icon_state = "reinf_preview"
	table_mat = DEFAULT_TABLE_MATERIAL
	table_reinf = DEFAULT_WALL_MATERIAL

/obj/structure/table/reinforced/steel
	icon_state = "reinf_preview"
	table_mat = DEFAULT_WALL_MATERIAL

/obj/structure/table/reinforced/wood
	table_mat = MATERIAL_WOOD
	table_reinf = MATERIAL_WOOD

/obj/structure/table/wood
	icon_state = "plain_preview"
	table_mat = MATERIAL_WOOD

/obj/structure/table/wood/gamblingtable
	icon_state = "gamble_preview"
	carpeted = 1

/obj/structure/table/glass
	icon_state = "plain_preview"
	table_mat = MATERIAL_GLASS
	alpha = 77 // 0.3 * 255

/obj/structure/table/skrell
	icon_state = "skrell_preview"
	table_mat = MATERIAL_SHUTTLE_SKRELL

/obj/structure/table/holotable
	icon_state = "holo_preview"
	table_mat = MATERIAL_PLASTIC_HOLO

/obj/structure/table/holotable/holowood
	table_mat = MATERIAL_WOOD_HOLO
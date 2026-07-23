/datum/export/material
	cost = 5 // Cost per MINERAL_MATERIAL_AMOUNT, which is 2000cm3 as of April 2016.
	k_elasticity = 0
	message = "cm3 of developer's tears. Please, report this on github"
	/// Singleton material path to match against.
	var/material_id = null
	export_types = list(/obj/item/stack/material/)
// Yes, it's a base type containing export_types.
// But it has no material_id, so any applies_to check will return false, and these types reduce amount of copypasta a lot

/datum/export/material/get_amount(obj/O)
	if(!material_id)
		return 0
	var/obj/item/stack/material/M = O
	if(!M)
		return 0
	var/material_path = SSmaterials.material_to_path(material_id, FALSE)
	var/singleton/material/material = M.get_material()
	if(!material_path || material?.type != material_path)
		return 0

	return M.amount

// Materials. As of writing in 2024, this list was small, and most everything was effected by price elasticity. Now, it's been rebalanced. Price elasticity was removed,
// and more materials now have values. These materials are mainly concerend with mining.


/datum/export/material/diamond
	cost = 20
	material_id = MATERIAL_DIAMOND
	message = "diamond sheets"

/datum/export/material/phoron
	cost = 175
	material_id = MATERIAL_PHORON
	message = "phoron sheets"

/datum/export/material/uranium
	cost = 8
	material_id = MATERIAL_URANIUM
	message = "uranium sheets"

/datum/export/material/gold
	cost = 12
	material_id = MATERIAL_GOLD
	message = "gold sheets"

/datum/export/material/silver
	cost = 8
	material_id = MATERIAL_SILVER
	message = "silver sheets"

/datum/export/material/platinum
	cost = 12
	material_id = MATERIAL_PLATINUM
	message = "platinum sheets"

/datum/export/material/osmium
	cost = 24
	material_id = MATERIAL_OSMIUM
	message = "osmium bars"

/datum/export/material/metal
	cost = 2
	message = "metal sheets"

/datum/export/material/steel
	cost = 1
	material_id = MATERIAL_STEEL
	message = "steel sheets"

/datum/export/material/plasteel
	cost = 20
	material_id = MATERIAL_PLASTEEL
	message = "plasteel sheets"

/datum/export/material/iron
	cost = 1
	material_id = MATERIAL_IRON
	message = "iron ingots"

/datum/export/material/plastic
	cost = 1
	material_id = MATERIAL_PLASTIC
	message = "plastic sheets"

/datum/export/material/graphite
	cost = 2
	material_id = MATERIAL_GRAPHITE
	message = "graphite bars"

/datum/export/material/glass
	cost = 1
	material_id = MATERIAL_GLASS
	message = "glass sheets"

/datum/export/material/tritium
	cost = 5
	material_id = MATERIAL_TRITIUM
	message = "tritium ingots"

/datum/export/material/mhydrogen
	cost = 10
	material_id = MATERIAL_HYDROGEN_METALLIC
	message = "metallic hydrogen sheets"

/datum/export/material/aluminium
	cost = 3
	material_id = MATERIAL_ALUMINIUM
	message = "aluminium sheets"

/datum/export/material/lead
	cost = 3
	material_id = MATERIAL_LEAD
	message = "lead sheets"

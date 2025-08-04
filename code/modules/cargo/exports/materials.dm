/datum/export/material
	cost = 5 // Cost per MINERAL_MATERIAL_AMOUNT, which is 2000cm3 as of April 2016.
	k_elasticity = 0
	message = "cm3 of developer's tears. Please, report this on github"
	var/material_id = null
	export_types = list(/obj/item/stack/material/)
// Yes, it's a base type containing export_types.
// But it has no material_id, so any applies_to check will return false, and these types reduce amount of copypasta a lot

/datum/export/material/get_amount(obj/O)
	if(!material_id)
		return 0
	var/obj/item/stack/material/M = O
	if(!M || M.material.name != material_id)
		return 0

	return M.amount

// Materials. As of writing in 2024, this list was small, and most everything was effected by price elasticity. Now, it's been rebalanced. Price elasticity was removed,
// and more materials now have values. These materials are mainly concerend with mining.


/datum/export/material/diamond
	cost = 20
	material_id = "diamond"
	message = "diamond sheets"

/datum/export/material/phoron
	cost = 175
	material_id = "phoron"
	message = "phoron sheets"

/datum/export/material/uranium
	cost = 8
	material_id = "uranium"
	message = "uranium sheets"

/datum/export/material/gold
	cost = 12
	material_id = "gold"
	message = "gold sheets"

/datum/export/material/silver
	cost = 8
	material_id = "silver"
	message = "silver sheets"

/datum/export/material/platinum
	cost = 12
	material_id = "platinum"
	message = "platinum sheets"

/datum/export/material/osmium
	cost = 24
	material_id = "osmium"
	message = "osmium bars"

/datum/export/material/metal
	cost = 2
	material_id = "metal"
	message = "metal sheets"

/datum/export/material/steel
	cost = 1
	material_id = "steel"
	message = "steel sheets"

/datum/export/material/plasteel
	cost = 20
	material_id = "plasteel"
	message = "plasteel sheets"

/datum/export/material/iron
	cost = 1
	material_id = "iron"
	message = "iron ingots"

/datum/export/material/plastic
	cost = 1
	material_id = "plastic"
	message = "plastic sheets"

/datum/export/material/graphite
	cost = 2
	material_id = "graphite"
	message = "graphite bars"

/datum/export/material/glass
	cost = 1
	material_id = "glass"
	message = "glass sheets"

/datum/export/material/tritium
	cost = 5
	material_id = "tritium"
	message = "tritium ingots"

/datum/export/material/mhydrogen
	cost = 10
	material_id = "mhydrogen"
	message = "metallic hydrogen sheets"

/datum/export/material/aluminium
	cost = 3
	material_id = "aluminium"
	message = "aluminium sheets"

/datum/export/material/lead
	cost = 3
	material_id = "lead"
	message = "lead sheets"


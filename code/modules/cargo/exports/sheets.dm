/datum/export/stack
	unit_name = "sheet"

/datum/export/stack/get_amount(obj/O)
	var/obj/item/stack/S = O
	if(istype(S))
		return S.amount
	return 0

// Hides

/datum/export/stack/skin/monkey
	cost = 50
	unit_name = "monkey hide"
	export_types = list(/obj/item/stack/material/animalhide/monkey)

/datum/export/stack/skin/human
	cost = 100
	contraband = TRUE
	unit_name = "piece"
	message = "of human skin"
	export_types = list(/obj/item/stack/material/animalhide/human)

/datum/export/stack/skin/cat
	cost = 150
	contraband = TRUE
	unit_name = "cat hide"
	export_types = list(/obj/item/stack/material/animalhide/cat)

/datum/export/stack/skin/corgi
	cost = 200
	contraband = TRUE
	unit_name = "corgi hide"
	export_types = list(/obj/item/stack/material/animalhide/corgi)

/datum/export/stack/skin/lizard
	cost = 150
	unit_name = "lizard hide"
	export_types = list(/obj/item/stack/material/animalhide/lizard)

/datum/export/stack/skin/xeno
	cost = 500
	unit_name = "alien hide"
	export_types = list(/obj/item/stack/material/animalhide/xeno)

// Common materials.
// For base materials, see materials.dm

/datum/export/stack/plasteel
	cost = 155 // 2000u of plasma + 2000u of metal.
	message = "of plasteel"
	export_types = list(/obj/item/stack/material/plasteel)

// 1 glass + 0.5 metal, cost is rounded up.
/datum/export/stack/rglass
	cost = 8
	message = "of reinforced glass"
	export_types = list(/obj/item/stack/material/glass/reinforced)


/datum/export/stack/wood
	cost = 30
	unit_name = "wood plank"
	export_types = list(/obj/item/stack/material/wood)

/datum/export/stack/cardboard
	cost = 2
	message = "of cardboard"
	export_types = list(/obj/item/stack/material/cardboard)

/datum/export/stack/sandstone
	cost = 1
	unit_name = "block"
	message = "of sandstone"
	export_types = list(/obj/item/stack/material/sandstone)

/datum/export/stack/cable
	cost = 0.2
	unit_name = "cable piece"
	export_types = list(/obj/item/stack/cable_coil)

// Weird Stuff


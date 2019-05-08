/material/meteoric
	name = "meteoric iron"
	stack_type = /obj/item/stack/material/meteoric
	integrity = 400
	melting_point = 6000
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#424343"
	explosion_resistance = 40
	hardness = 100
	weight = 10
	protectiveness = 30 // 50%
	conductivity = 5
	stack_origin_tech = list(TECH_MATERIAL = 5)
	hitsound = 'sound/weapons/smash.ogg'

/obj/item/stack/material/meteoric
	name = "meteoric iron"
	icon = 'icons/adhomai/items.dmi'
	icon_state = "sheet-meteoric"
	item_state = "sheet-metal"
	default_type = "meteoric iron"
	icon_has_variants = TRUE

/material/sandbag
	name = "sandbag"
	stack_type = /obj/item/stack/material/sandbag
	flags = MATERIAL_PADDING
	icon_colour = "#c2b280"
	hitsound = 'sound/weapons/smash.ogg'

/obj/item/stack/material/sandbag
	name = "sandbag"
	icon = 'icons/adhomai/items.dmi'
	icon_state = "sandbags"
	default_type = "sandbag"

material/clay
	name = "clay"
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	stack_type = /obj/item/stack/material/clay
	icon_colour = "#996633"
	hardness = 10
	weight = 3

/obj/item/stack/material/clay
	name = "clay"
	icon = 'icons/obj/mining.dmi'
	icon_state = "ore1"
	default_type = "clay"
	singular_name = "glob"

/obj/item/stack/leather_strips
	name = "leather strips"
	icon = 'icons/obj/items.dmi'
	icon_state = "c_tube"
	max_amount = 50
	singular_name = "strip"
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


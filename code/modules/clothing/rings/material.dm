//Material Rings
/obj/item/clothing/ring/material
	icon = 'icons/obj/clothing/rings.dmi'
	icon_state = "material"

/obj/item/clothing/ring/material/Initialize(var/mapload, var/new_material)
	. = ..(mapload)
	if(!new_material)
		new_material = DEFAULT_WALL_MATERIAL
	material = get_material_by_name(new_material)
	if(!istype(material))
		qdel(src)
		return
	name = "[material.display_name] ring"
	desc = "A ring made from [material.display_name]."
	color = material.icon_colour

/obj/item/clothing/ring/material/get_material()
	return material

/obj/item/clothing/ring/material/wood/Initialize(var/mapload)
	. = ..(mapload, "wood")

/obj/item/clothing/ring/material/plastic/Initialize(var/mapload)
	. = ..(mapload, "plastic")

/obj/item/clothing/ring/material/iron/Initialize(var/mapload)
	. = ..(mapload, "iron")

/obj/item/clothing/ring/material/steel/Initialize(var/mapload)
	. = ..(mapload, "steel")

/obj/item/clothing/ring/material/silver/Initialize(var/mapload)
	. = ..(mapload, "silver")

/obj/item/clothing/ring/material/gold/Initialize(var/mapload)
	. = ..(mapload, "gold")

/obj/item/clothing/ring/material/platinum/Initialize(var/mapload)
	. = ..(mapload, "platinum")

/obj/item/clothing/ring/material/phoron/Initialize(var/mapload)
	. = ..(mapload, "phoron")

/obj/item/clothing/ring/material/bronze/Initialize(var/mapload)
	. = ..(mapload, "bronze")

/obj/item/clothing/ring/material/glass/Initialize(var/mapload)
	. = ..(mapload, "glass")

/obj/item/clothing/ring/material/uranium/Initialize(var/mapload)
	. = ..(mapload, "uranium")
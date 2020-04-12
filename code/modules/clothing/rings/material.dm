//Material Rings
/obj/item/clothing/ring/material
	icon = 'icons/obj/clothing/rings.dmi'
	icon_state = "material"

/obj/item/clothing/ring/material/Initialize(var/mapload, var/new_material)
	. = ..(mapload)
	if(!new_material)
		new_material = DEFAULT_WALL_MATERIAL
	material = SSmaterials.get_material_by_name(new_material)
	if(!istype(material))
		qdel(src)
		return
	name = "[material.display_name] ring"
	desc = "A ring made from [material.display_name]."
	color = material.icon_colour

/obj/item/clothing/ring/material/get_material()
	return material

/obj/item/clothing/ring/material/wood/Initialize(var/mapload)
	. = ..(mapload, MATERIAL_WOOD)

/obj/item/clothing/ring/material/plastic/Initialize(var/mapload)
	. = ..(mapload, MATERIAL_PLASTIC)

/obj/item/clothing/ring/material/iron/Initialize(var/mapload)
	. = ..(mapload, MATERIAL_IRON)

/obj/item/clothing/ring/material/steel/Initialize(var/mapload)
	. = ..(mapload, MATERIAL_STEEL)

/obj/item/clothing/ring/material/silver/Initialize(var/mapload)
	. = ..(mapload, MATERIAL_SILVER)

/obj/item/clothing/ring/material/gold/Initialize(var/mapload)
	. = ..(mapload, MATERIAL_GOLD)

/obj/item/clothing/ring/material/platinum/Initialize(var/mapload)
	. = ..(mapload, MATERIAL_PLATINUM)

/obj/item/clothing/ring/material/phoron/Initialize(var/mapload)
	. = ..(mapload, MATERIAL_PHORON)

/obj/item/clothing/ring/material/bronze/Initialize(var/mapload)
	. = ..(mapload, MATERIAL_BRONZE)

/obj/item/clothing/ring/material/glass/Initialize(var/mapload)
	. = ..(mapload, MATERIAL_GLASS)

/obj/item/clothing/ring/material/uranium/Initialize(var/mapload)
	. = ..(mapload, MATERIAL_URANIUM)
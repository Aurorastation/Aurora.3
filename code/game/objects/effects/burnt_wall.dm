/obj/effect/overlay/burnt_wall
	name = "burnt wall"
	desc = "A wall that had a hole burnt into it. Nasty."
	icon = 'icons/turf/flooring/plating.dmi'
	icon_state = "wall_thermite"
	var/material/material
	var/material/reinf_material

/obj/effect/overlay/burnt_wall/Initialize(mapload, new_name, new_mat, new_reinf_mat)
	. = ..()
	name = "burnt [new_name]"
	material = SSmaterials.get_material_by_name(new_mat)
	if(new_reinf_mat)
		reinf_material = SSmaterials.get_material_by_name(new_reinf_mat)
	color = material.icon_colour
	if(material.opacity < 0.5)
		alpha = 125

/obj/effect/overlay/burnt_wall/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.iswelder())
		var/obj/item/weldingtool/WT = attacking_item
		if(!WT.isOn())
			return TRUE
		if(WT.use(0,user))
			user.visible_message("<b>[user]</b> starts slicing \the [src] apart.", SPAN_NOTICE("You start slicing \the [src] apart."))
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			var/slice_time = reinf_material ? 100 : 30
			if(WT.use_tool(src, user, slice_time, volume = 50))
				user.visible_message("<b>[user]</b> slices \the [src] apart.", SPAN_NOTICE("You slice \the [src] apart."))
				material.place_sheet(get_turf(src))
				if(reinf_material)
					reinf_material.place_sheet(get_turf(src))
				qdel(src)
			return TRUE
	return ..()

/obj/effect/overlay/thermite
	name = "burning thermite"
	desc = "It's flaming ball of thermite!"
	icon = 'icons/effects/fire.dmi'
	icon_state = "2"
	anchored = TRUE

/obj/effect/overlay/burnt_wall/steel/Initialize(mapload)
	. = ..(mapload, "wall", MATERIAL_STEEL)

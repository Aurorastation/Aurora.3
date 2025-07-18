/turf/simulated/wall/proc/update_material()
	if(!material)
		return

	if(reinf_material)
		construction_stage = 6
	else
		construction_stage = null
	if(!material)
		material = SSmaterials.get_material_by_name(DEFAULT_WALL_MATERIAL)
	if(material)
		explosion_resistance = material.explosion_resistance
		if (material.wall_icon)
			icon = material.wall_icon

	if(reinf_material && reinf_material.explosion_resistance > explosion_resistance)
		explosion_resistance = reinf_material.explosion_resistance

	if(reinf_material)
		name = "reinforced [material.display_name] wall"
		if(material.display_name == reinf_material.display_name)
			desc = "It seems to be a section of hull reinforced and plated with [material.display_name]."
		else
			desc = "It seems to be a section of hull reinforced with [reinf_material.display_name] and plated with [material.display_name]."
	else
		name = "[material.display_name] wall"
		desc = "It seems to be a section of hull plated with [material.display_name]."

	if(material.opacity < 0.5)
		opacity = FALSE
		alpha = 125

	if(!opacity)
		var/turf/under_floor = under_turf
		var/image/under_image = image(initial(under_floor.icon), icon_state = initial(under_floor.icon_state))
		under_image.alpha = 255
		underlays += under_image

	update_icon()

/turf/simulated/wall/proc/set_material(var/material/newmaterial, var/material/newrmaterial)
	material = newmaterial
	reinf_material = newrmaterial
	update_material()

/turf/simulated/wall/update_icon()
	if(!material)
		return

	if(!damage_overlays[1]) //list hasn't been populated
		generate_overlays()

	if (LAZYLEN(reinforcement_images))
		CutOverlays(reinforcement_images, ATOM_ICON_CACHE_PROTECTED)
	if (damage_image)
		CutOverlays(damage_image, ATOM_ICON_CACHE_PROTECTED)

	LAZYCLEARLIST(reinforcement_images)
	damage_image = null

	var/list/overlays_to_add = list()

	if (!density)	// We're a fake and we're open.
		clear_smooth_overlays()
		fake_wall_image = image('icons/turf/wall_masks.dmi', "[material.icon_base]fwall_open")
		fake_wall_image.color = material.icon_colour
		AddOverlays(fake_wall_image)
		smoothing_flags = SMOOTH_FALSE
		return
	else if (fake_wall_image)
		CutOverlays(fake_wall_image)
		fake_wall_image = null
		smoothing_flags = initial(smoothing_flags)

	calculate_adjacencies()	// Update cached_adjacency

	if(reinf_material)
		var/image/I
		if(construction_stage != null && construction_stage < 6)
			I = image('icons/turf/wall_masks.dmi', "reinf_construct-[construction_stage]")
			I.color = reinf_material.icon_colour
			LAZYADD(reinforcement_images, I)
		else
			if (reinf_material.multipart_reinf_icon)
				LAZYADD(reinforcement_images, cardinal_smooth_fromicon(reinf_material.multipart_reinf_icon, cached_adjacency))
			else
				I = image('icons/turf/wall_masks.dmi', reinf_material.reinf_icon)
				I.color = reinf_material.icon_colour
				LAZYADD(reinforcement_images, I)

		if (reinforcement_images)
			overlays_to_add += reinforcement_images

	if(damage != 0)
		var/integrity = material.integrity
		if(reinf_material)
			integrity += reinf_material.integrity

		var/overlay = round(damage / integrity * damage_overlays.len) + 1
		if(overlay > damage_overlays.len)
			overlay = damage_overlays.len

		damage_image = damage_overlays[overlay]
		overlays_to_add += damage_image

	// Remove the existing damage overlay entirely and replace it with the newly-calculated one.
	CutOverlays(damage_overlays)

	AddOverlays(overlays_to_add)
	UNSETEMPTY(reinforcement_images)
	QUEUE_SMOOTH(src)
	if(smoothing_flags & SMOOTH_UNDERLAYS)
		get_underlays(cached_adjacency)

/turf/simulated/wall/proc/generate_overlays()
	for(var/damage_level = 1; damage_level <= damage_overlays.len; damage_level++) // Generate damage overlay for each placeholder (16 in array)
		var/image/damage_overlay = image(icon = 'icons/turf/walls.dmi', icon_state = "overlay_damage")
		damage_overlay.blend_mode = BLEND_MULTIPLY

		// The actual difference in each damage overlay is represented with a different alpha value, higher alpha = higher visible damage
		damage_overlay.alpha = damage_level * 18 + 32; // Linear scale with inital offset

		damage_overlays[damage_level] = damage_overlay

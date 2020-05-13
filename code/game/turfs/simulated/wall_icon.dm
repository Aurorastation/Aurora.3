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
		desc = "It seems to be a section of hull reinforced with [reinf_material.display_name] and plated with [material.display_name]."
	else
		name = "[material.display_name] wall"
		desc = "It seems to be a section of hull plated with [material.display_name]."

	if(material.opacity > 0.5 && !opacity)
		set_light(1)
	else if(material.opacity < 0.5 && opacity)
		set_light(0)

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
		cut_overlay(reinforcement_images, TRUE)
	if (damage_image)
		cut_overlay(damage_image, TRUE)

	LAZYCLEARLIST(reinforcement_images)
	damage_image = null

	var/list/overlays_to_add = list()

	if (!density)	// We're a fake and we're open.
		clear_smooth_overlays()
		fake_wall_image = image('icons/turf/wall_masks.dmi', "[material.icon_base]fwall_open")
		fake_wall_image.color = material.icon_colour
		add_overlay(fake_wall_image)
		smooth = SMOOTH_FALSE
		return
	else if (fake_wall_image)
		cut_overlay(fake_wall_image)
		fake_wall_image = null
		smooth = initial(smooth)

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
				I = image('icons/turf/wall_masks.dmi', reinf_material.icon_reinf)
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

	add_overlay(overlays_to_add, TRUE)
	UNSETEMPTY(reinforcement_images)
	queue_smooth(src)

/turf/simulated/wall/proc/generate_overlays()
	var/alpha_inc = 256 / damage_overlays.len

	for(var/i = 1; i <= damage_overlays.len; i++)
		var/image/img = image(icon = 'icons/turf/walls.dmi', icon_state = "overlay_damage")
		img.blend_mode = BLEND_MULTIPLY
		img.alpha = (i * alpha_inc) - 1
		damage_overlays[i] = img

/turf/simulated/wall/calculate_adjacencies()
	if(use_standard_smoothing)
		return ..()
	. = 0
	if (!loc || !material)
		return

	var/turf/simulated/wall/W
	var/our_icon_base = material.icon_base

	CALCULATE_NEIGHBORS(src, ., W, istype(W) && (W.smooth || !W.density) && W.material && W.material.icon_base == our_icon_base)

	cached_adjacency = .

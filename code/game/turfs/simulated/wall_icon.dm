/turf/simulated/wall/proc/update_material()

	if(!material)
		return

	if(reinf_material)
		construction_stage = 6
	else
		construction_stage = null
	if(!material)
		material = get_material_by_name(DEFAULT_WALL_MATERIAL)
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

/turf/simulated/wall
	var/list/image/reinforcement_images
	var/image/damage_image
	var/image/fake_wall_image

/turf/simulated/wall/update_icon()
	if(!material)
		return

	if(!damage_overlays[1]) //list hasn't been populated
		generate_overlays()

	LAZYINITLIST(reinforcement_images)

	var/list/cutlist = reinforcement_images + damage_image
	cut_overlay(cutlist, TRUE)
	reinforcement_images.Cut()
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
		queue_smooth(src)

	if(reinf_material)
		var/image/I
		if(construction_stage != null && construction_stage < 6)
			I = image('icons/turf/wall_masks.dmi', "reinf_construct-[construction_stage]")
			I.color = reinf_material.icon_colour
			reinforcement_images += I
		else
			if (material.has_multipart_reinf_icon)
				// Directional icon
				/*for(var/i = 1 to 4)
					I = image('icons/turf/wall_masks.dmi', "[reinf_material.icon_reinf][wall_connections[i]]", dir = 1<<(i-1))
					I.color = reinf_material.icon_colour
					reinforcement_images += I*/	// Not sure how to handle this.
			else
				I = image('icons/turf/wall_masks.dmi', reinf_material.icon_reinf)
				I.color = reinf_material.icon_colour
				reinforcement_images += I

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

/turf/simulated/wall/proc/generate_overlays()
	var/alpha_inc = 256 / damage_overlays.len

	for(var/i = 1; i <= damage_overlays.len; i++)
		var/image/img = image(icon = 'icons/turf/walls.dmi', icon_state = "overlay_damage")
		img.blend_mode = BLEND_MULTIPLY
		img.alpha = (i * alpha_inc) - 1
		damage_overlays[i] = img

/turf/simulated/wall/calculate_adjacencies()
	. = 0
	if (!loc || !material)
		return

	var/turf/simulated/wall/W
	var/material/M
	var/our_icon_base = material.icon_base

	for (var/dir in cardinal)
		W = get_step(src, dir)
		if (istype(W) && (W.smooth || !W.density))
			M = W.material
			if (M && M.icon_base == our_icon_base)
				. |= 1 << dir

	if (. & N_NORTH)
		if (. & N_WEST)
			W = get_step(src, NORTHWEST)
			if (istype(W) && (W.smooth || !W.density))
				M = W.material
				if (M && M.icon_base == our_icon_base)
					. |= N_NORTHWEST

		if (. & N_EAST)
			W = get_step(src, NORTHEAST)
			if (istype(W) && (W.smooth || !W.density))
				M = W.material
				if (M && M.icon_base == our_icon_base)
					. |= N_NORTHEAST

	if (. & N_SOUTH)
		if (. & N_WEST)
			W = get_step(src, SOUTHWEST)
			if (istype(W) && (W.smooth || !W.density))
				M = W.material
				if (M && M.icon_base == our_icon_base)
					. |= N_SOUTHWEST

		if (. & N_EAST)
			W = get_step(src, SOUTHEAST)
			if (istype(W) && (W.smooth || !W.density))
				M = W.material
				if (M && M.icon_base == our_icon_base)
					. |= N_SOUTHEAST

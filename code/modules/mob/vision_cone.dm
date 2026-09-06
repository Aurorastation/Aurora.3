/**
 * Directional vision ported from Azure-Peak (AGPL-3.0).
 * Source: https://github.com/Azure-Peak/Azure-Peak/blob/b7d8cb76191362d44fdc87e261cdd2257f1682ee/code/modules/mob/vision_cone.dm
 * Terrain remains visible beneath a shaded cone; living mobs are alpha masked.
 */
/mob/living
	plane = GAME_PLANE_FOV_HIDDEN

/mob/proc/update_vision_cone()
	return

/// A small circular opening covering the centers of cardinally adjacent tiles.
/// Applied to the planes after the cone sprites are scaled, so viewport size cannot
/// change the peripheral vision radius. The circle also clears the terrain shading.
/proc/get_vision_cone_peripheral_mask()
	var/static/icon/peripheral_mask
	if(peripheral_mask)
		return peripheral_mask
	var/radius = ceil(world.icon_size * 1.25)
	var/feather_width = world.icon_size * 0.1875 // Six pixels at the normal tile size.
	var/diameter = radius * 2
	peripheral_mask = icon('icons/blanks/32x32.dmi', "nothing")
	peripheral_mask.Scale(diameter, diameter)
	var/center = radius + 0.5
	for(var/row in 1 to diameter)
		for(var/column in 1 to diameter)
			var/distance = sqrt((column - center) ** 2 + (row - center) ** 2)
			if(distance >= radius)
				continue
			var/opacity = clamp((radius - distance) / feather_width, 0, 1)
			// Smoothstep keeps the center clear and gently blends into the cone.
			opacity = opacity * opacity * (3 - 2 * opacity)
			peripheral_mask.DrawBox(rgb(255, 255, 255, round(255 * opacity)), column, row, column, row)
	return peripheral_mask

/obj/item/clothing/proc/get_vision_cone_restrictions()
	return vision_cone_restrictions

/// Use live armor values, including armor added by materials or suit modules.
/// Environmental protection alone does not make a helmet armored.
/obj/item/clothing/head/helmet/get_vision_cone_restrictions()
	. = ..()
	var/datum/component/armor/helmet_armor = GetComponent(/datum/component/armor)
	if(!length(helmet_armor?.armor_values))
		return
	for(var/armor_type in list(MELEE, BULLET, LASER, ENERGY, BOMB))
		if(helmet_armor.armor_values[armor_type] > 0)
			return . | FOV_RESTRICT_BEHIND

/// Match Azure-Peak's combined head/mask restrictions to its paired sprite states.
/mob/living/carbon/human/proc/get_vision_cone_state()
	var/restrictions = 0
	for(var/obj/item/clothing/equipment in list(head, wear_mask))
		restrictions |= equipment.get_vision_cone_restrictions()
	if(restrictions & FOV_RESTRICT_LEFT)
		if(restrictions & FOV_RESTRICT_RIGHT)
			return "both"
		return (restrictions & FOV_RESTRICT_BEHIND) ? "behind_l" : "left"
	if(restrictions & FOV_RESTRICT_RIGHT)
		return (restrictions & FOV_RESTRICT_BEHIND) ? "behind_r" : "right"
	return (restrictions & FOV_RESTRICT_BEHIND) ? "behind" : "combat"

/// Remote eyes, unconscious/dead characters and prone characters have no cone.
/mob/living/carbon/human/proc/should_show_vision_cone()
	return client && client.eye == src && client.perspective == MOB_PERSPECTIVE && !client.pixel_x && !client.pixel_y && !stat && !lying && isturf(loc)

/mob/living/carbon/human/update_vision_cone()
	if(!client || !hud_used)
		return
	if(!hud_used.fov)
		hud_used.fov = new
		hud_used.fov_blocker = new
	client.screen |= hud_used.fov
	client.screen |= hud_used.fov_blocker
	var/cone_state = get_vision_cone_state()
	hud_used.fov.icon_state = cone_state
	hud_used.fov_blocker.icon_state = "[cone_state]_v"

	var/show_cone = should_show_vision_cone()
	hud_used.fov.alpha = show_cone ? 255 : 0
	hud_used.fov_blocker.alpha = show_cone ? 255 : 0
	if(!show_cone)
		client.images -= hud_used.fov_visible_images
		QDEL_LIST(hud_used.fov_visible_images)
		return

	// The source sprites are 15 tiles square. Scale about their center for wider views.
	var/list/view_size = getviewsize(client.view)
	var/cone_scale = max(1, max(view_size[1], view_size[2]) / 15)
	var/matrix/cone_transform = matrix()
	cone_transform.Scale(cone_scale)
	hud_used.fov.transform = cone_transform
	hud_used.fov_blocker.transform = cone_transform
	hud_used.fov.dir = dir
	hud_used.fov_blocker.dir = dir

	// These client-only copies retain the normal world lighting and mouse targets.
	var/list/visible_mobs = list(src)
	if(isliving(pulling))
		visible_mobs |= pulling
	for(var/image/old_image as anything in hud_used.fov_visible_images.Copy())
		if(!(old_image.loc in visible_mobs))
			client.images -= old_image
			hud_used.fov_visible_images -= old_image
			qdel(old_image)
	for(var/mob/living/visible_mob as anything in visible_mobs)
		var/image/visible_image
		for(var/image/existing_image as anything in hud_used.fov_visible_images)
			if(existing_image.loc == visible_mob)
				visible_image = existing_image
				break
		if(!visible_image)
			visible_image = image(loc = visible_mob)
			hud_used.fov_visible_images += visible_image
		visible_image.appearance = visible_mob.appearance
		// Images retain their own direction when copying an atom's appearance.
		visible_image.dir = visible_mob.dir
		visible_image.override = TRUE
		visible_image.appearance_flags = RESET_TRANSFORM | KEEP_TOGETHER | PIXEL_SCALE
		visible_image.plane = ABOVE_GAME_PLANE
		visible_image.layer = visible_mob.layer
		visible_image.pixel_x = 0
		visible_image.pixel_y = 0
		client.images |= visible_image

/atom/movable/screen/fov
	name = " "
	icon = 'icons/mob/vision_cone.dmi'
	icon_state = "combat"
	screen_loc = "CENTER-7,CENTER-7"
	plane = FOV_OVERLAY_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	alpha = 0

/atom/movable/screen/fov_blocker
	icon = 'icons/mob/vision_cone.dmi'
	icon_state = "combat_v"
	screen_loc = "CENTER-7,CENTER-7"
	plane = FIELD_OF_VISION_BLOCKER_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	alpha = 0

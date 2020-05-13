var/global/list/mecha_image_cache = list()
var/global/list/mecha_icon_cache = list()

proc/get_mech_image(var/cache_key, var/cache_icon, var/image_colour, var/overlay_layer = FLOAT_LAYER)
	var/use_key = "[cache_key]-[cache_icon]-[image_colour ? image_colour : "none"]"
	if(image_colour) use_key += "-[image_colour]"
	if(!mecha_image_cache[use_key])
		var/image/I = image(icon = cache_icon, icon_state = cache_key)
		if(image_colour)
			I.color = image_colour
		I.layer = overlay_layer
		I.plane = FLOAT_PLANE
		global.mecha_image_cache[use_key] = I
	return global.mecha_image_cache[use_key]

proc/get_mech_icon(var/list/components = list(), var/overlay_layer = FLOAT_LAYER)
	var/list/all_images = list()
	for(var/obj/item/mech_component/comp in components)
		all_images += get_mech_image(comp.icon_state, comp.on_mech_icon, comp.color, overlay_layer)
	return all_images

/mob/living/heavy_vehicle/update_icon()
	var/list/new_overlays = get_mech_icon(list(body, head), MECH_BASE_LAYER)
	if(body && !hatch_closed)
		new_overlays += get_mech_image("[body.icon_state]_cockpit", body.on_mech_icon, MECH_BASE_LAYER)
	update_pilot_overlay(FALSE)
	if(LAZYLEN(pilot_overlays))
		new_overlays += pilot_overlays
	if(head)
		new_overlays += get_mech_image("[head.icon_state]_eyes", head.on_mech_icon, null, MECH_INTERMEDIATE_LAYER)
	if(body)
		new_overlays += get_mech_image("[body.icon_state]_overlay[hatch_closed ? "" : "_open"]", body.on_mech_icon, body.color, MECH_COCKPIT_LAYER)
	if(arms)
		new_overlays += get_mech_image(arms.icon_state, arms.on_mech_icon, arms.color, MECH_ARM_LAYER)
	if(legs)
		new_overlays += get_mech_image(legs.icon_state, legs.on_mech_icon, legs.color, MECH_LEG_LAYER)

	var/list/mecha_decal_overlays = list()
	mecha_decal_overlays = icon_states('icons/mecha/mecha_decals.dmi')
	if(decal)
		if(decal in mecha_decal_overlays)
			new_overlays += get_mech_image(decal, 'icons/mecha/mecha_decals.dmi', null, MECH_DECAL_LAYER)

	var/list/mecha_weapon_overlays = list()
	mecha_weapon_overlays = icon_states('icons/mecha/mecha_weapon_overlays.dmi')
	for(var/hardpoint in hardpoints)
		var/obj/item/mecha_equipment/hardpoint_object = hardpoints[hardpoint]
		if(hardpoint_object)
			var/use_icon_state = "[hardpoint_object.icon_state]_[hardpoint]"
			if(use_icon_state in mecha_weapon_overlays)
				new_overlays += get_mech_image(use_icon_state, 'icons/mecha/mecha_weapon_overlays.dmi', null, hardpoint_object.mech_layer)

	overlays = new_overlays

/mob/living/heavy_vehicle/proc/update_pilot_overlay(var/update_overlays = TRUE)
	if(update_overlays && LAZYLEN(pilot_overlays))
		overlays -= pilot_overlays
	pilot_overlays = null
	if(!body || ((body.pilot_coverage < 100 || body.transparent_cabin) && !body.hide_pilot))
		for(var/i = 1 to LAZYLEN(pilots))
			var/mob/pilot = pilots[i]
			var/image/draw_pilot = new
			draw_pilot.appearance = pilot
			draw_pilot.layer = MECH_PILOT_LAYER + (body ? ((LAZYLEN(body.pilot_positions)-i)*0.001) : 0)
			draw_pilot.plane = FLOAT_PLANE
			if(body && i <= LAZYLEN(body.pilot_positions))
				var/list/offset_values = body.pilot_positions[i]
				var/list/directional_offset_values = offset_values["[dir]"]
				draw_pilot.pixel_x = directional_offset_values["x"]
				draw_pilot.pixel_y = directional_offset_values["y"]
				draw_pilot.pixel_z = 0
				draw_pilot.transform = null
			LAZYADD(pilot_overlays, draw_pilot)
		if(update_overlays && LAZYLEN(pilot_overlays))
			overlays += pilot_overlays

/mob/living/heavy_vehicle/regenerate_icons()
	return
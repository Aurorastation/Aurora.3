/proc/holographic_overlay(obj/target, icon, icon_state)
	target.overlays += make_holographic_overlay(icon, icon_state)

/proc/make_holographic_overlay(icon, icon_state)
	var/image/overlay = make_screen_overlay(icon, icon_state)
	overlay.blend_mode = BLEND_ADD
	overlay.color = list(
		HOLOSCREEN_BRIGHTNESS_FACTOR, 0, 0, 0,
		0, HOLOSCREEN_BRIGHTNESS_FACTOR, 0, 0,
		0, 0, HOLOSCREEN_BRIGHTNESS_FACTOR, 0,
		0, 0, 0, HOLOSCREEN_OPACITY_FACTOR
	)
	return overlay

/proc/make_screen_overlay(icon, icon_state, brightness_factor = null)
	var/image/overlay = image(icon, icon_state)
	overlay.layer = LIGHTING_LAYER + 0.1
	if (brightness_factor)
		overlay.color = list(
			brightness_factor, 0, 0, 0,
			0, brightness_factor, 0, 0,
			0, 0, brightness_factor, 0,
			0, 0, 0, 1
		)
	return overlay

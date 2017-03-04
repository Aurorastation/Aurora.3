// Factor/Opacity values are defined in __defines\lighting.dm

/proc/holographic_overlay(obj/target, icon, icon_state)
	var/image/multiply = make_screen_overlay(icon, icon_state)
	multiply.blend_mode = BLEND_MULTIPLY
	multiply.color = list(
		0, 0, 0, 0,
		0, 0, 0, 0,
		0, 0, 0, 0,
		HOLOSCREEN_MULTIPLICATION_FACTOR, HOLOSCREEN_MULTIPLICATION_FACTOR, HOLOSCREEN_MULTIPLICATION_FACTOR, HOLOSCREEN_MULTIPLICATION_OPACITY
	)
	target.overlays += multiply
	var/image/overlay = make_screen_overlay(icon, icon_state)
	overlay.blend_mode = BLEND_ADD
	overlay.color = list(
		HOLOSCREEN_ADDITION_FACTOR, 0, 0, 0,
		0, HOLOSCREEN_ADDITION_FACTOR, 0, 0,
		0, 0, HOLOSCREEN_ADDITION_FACTOR, 0,
		0, 0, 0, HOLOSCREEN_ADDITION_OPACITY
	)
	target.overlays += overlay

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

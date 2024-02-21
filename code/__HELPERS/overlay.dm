// Factor/Opacity values are defined in __defines\lighting.dm

/proc/holographic_overlay(obj/target, icon, icon_state)
	if (!icon || !icon_state)
		CRASH("Invalid parameters.")

	var/list/m_cache = SSicon_cache.holo_multiplier_cache
	var/list/m_cache_icon
	var/image/multiply
	if (m_cache[icon])
		m_cache_icon = m_cache[icon]
		multiply = m_cache_icon[icon_state]
	else
		m_cache_icon = list()
		m_cache[icon] = m_cache_icon

	if (!multiply)
		multiply = make_screen_overlay(icon, icon_state)
		multiply.blend_mode = BLEND_MULTIPLY
		multiply.color = list(
			0, 0, 0, 0,
			0, 0, 0, 0,
			0, 0, 0, 0,
			HOLOSCREEN_MULTIPLICATION_FACTOR, HOLOSCREEN_MULTIPLICATION_FACTOR, HOLOSCREEN_MULTIPLICATION_FACTOR, HOLOSCREEN_MULTIPLICATION_OPACITY
		)
		m_cache_icon[icon_state] = multiply

	var/list/a_cache = SSicon_cache.holo_adder_cache
	var/list/a_cache_icon = a_cache[icon]
	var/image/overlay
	if (!a_cache_icon)
		a_cache_icon = list()
		a_cache[icon] = a_cache_icon
	else
		overlay = a_cache_icon[icon_state]

	if (!overlay)
		overlay = make_screen_overlay(icon, icon_state, HOLOSCREEN_ADDITION_OPACITY)
		overlay.blend_mode = BLEND_ADD
		a_cache_icon[icon_state] = overlay

	target.add_overlay(list(multiply, overlay))

/proc/make_screen_overlay(icon, icon_state, brightness_factor = null, glow_radius = 1)
	var/image/overlay = image(icon, icon_state)
	overlay.layer = EFFECTS_ABOVE_LIGHTING_LAYER
	var/image/underlay = image(overlay)
	underlay.alpha = 128
	underlay.filters = filter(type="bloom", offset=glow_radius, size=glow_radius*2, threshold="#000")
	overlay.underlays += underlay
	if (brightness_factor)
		overlay.color = list(
			brightness_factor, 0, 0, 0,
			0, brightness_factor, 0, 0,
			0, 0, brightness_factor, 0,
			0, 0, 0, 1
		)
	return overlay

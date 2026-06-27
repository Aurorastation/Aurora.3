/// Makes this atom look like a hologram.
/// Transparent, blue-tinted, scanlined, and copied to the emissive plane for glow.
/// Returns the glow mutable_appearance so callers can remove the overlay later.
/atom/proc/makeHologram(opacity = 0.5, color_override)
	var/color_value
	if(islist(color_override))
		color_value = color_override
	else
		var/r = 125
		var/g = 180
		var/b = 225
		if(color_override)
			var/list/rgb_list = rgb2num(color_override)
			r = rgb_list[1]
			g = rgb_list[2]
			b = rgb_list[3]
		color_value = rgb(r, g, b, opacity * 255)
	add_filter("HOLO: Color and Transparent", 1, color_matrix_filter(color_value))

	var/atom/movable/scanline = new(null)
	scanline.icon = 'icons/effects/effects.dmi'
	scanline.icon_state = "scanline"
	scanline.appearance_flags |= RESET_TRANSFORM
	var/static/uid_scan = 0
	scanline.render_target = "*HoloScanline [uid_scan]"
	uid_scan++

	add_filter("HOLO: Scanline", 2, alpha_mask_filter(render_source = scanline.render_target))
	AddOverlays(scanline)
	qdel(scanline)
	if(!render_target)
		var/static/uid = 0
		render_target = "HOLOGRAM [uid]"
		uid++

	var/static/atom/movable/render_step/emissive/glow
	if(!glow)
		glow = new(null)
	glow.render_source = render_target
	SET_PLANE_EXPLICIT(glow, initial(glow.plane), src)

	var/mutable_appearance/glow_appearance = new(glow)
	AddOverlays(glow_appearance)
	LAZYADD(update_overlays_on_z, glow_appearance)
	return glow_appearance

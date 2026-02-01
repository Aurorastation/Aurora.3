/// Produces a mutable appearance glued to the [EMISSIVE_PLANE] dyed to be the [EMISSIVE_COLOR].
/// Produces a mutable appearance glued to the [EMISSIVE_PLANE] dyed to be the [EMISSIVE_COLOR].
/proc/emissive_appearance(icon, icon_state = "", layer = FLOAT_LAYER, alpha = 255, appearance_flags = NONE)
	var/mutable_appearance/appearance = mutable_appearance(icon, icon_state, layer, EMISSIVE_PLANE, alpha, appearance_flags | EMISSIVE_APPEARANCE_FLAGS)
	if(alpha == 255)
		appearance.color = GLOB.emissive_color
	else
		var/alpha_ratio = alpha/255
		appearance.color = _EMISSIVE_COLOR(alpha_ratio)
	return appearance

/// Produces a mutable appearance glued to the [EMISSIVE_PLANE] dyed to be the [EM_BLOCK_COLOR].
/proc/emissive_blocker(icon, icon_state = "", layer = FLOAT_LAYER, alpha = 255, appearance_flags = EMPTY_BITFIELD, source = null)
	var/mutable_appearance/appearance = mutable_appearance(icon, icon_state, layer, EMISSIVE_PLANE, alpha, appearance_flags | EMISSIVE_APPEARANCE_FLAGS)
	if(alpha == 255)
		appearance.color = GLOB.em_block_color
	else
		var/alpha_ratio = alpha/255
		appearance.color = _EM_BLOCK_COLOR(alpha_ratio)
	return appearance


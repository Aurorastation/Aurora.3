/// Produces a mutable appearance glued to the [EMISSIVE_PLANE] dyed to the requested emissive channel.
/proc/emissive_appearance(icon, icon_state = "", offset_spokesman, layer, alpha = 255, appearance_flags = NONE, offset_const, effect_type = EMISSIVE_BLOOM)
	var/atom/spokesman = isatom(offset_spokesman) ? offset_spokesman : null
	if(spokesman)
		if((isnull(layer) || layer == FLOAT_LAYER) && IS_TOPDOWN_PLANE(spokesman.plane))
			layer = TOPDOWN_TO_EMISSIVE_LAYER(spokesman.layer)
		else if(isnull(layer))
			layer = FLOAT_LAYER
	else
		if(!isnull(offset_spokesman))
			stack_trace("Invalid emissive appearance offset spokesman [offset_spokesman] for [icon] / [icon_state]. Pass an atom as the third argument and layer as the fourth.")
		if(isnull(layer))
			layer = FLOAT_LAYER

	var/mutable_appearance/appearance = mutable_appearance(icon, icon_state, layer, spokesman, EMISSIVE_PLANE, 255, appearance_flags | EMISSIVE_APPEARANCE_FLAGS, offset_const)
	if(alpha == 255)
		switch(effect_type)
			if(EMISSIVE_NO_BLOOM)
				appearance.color = GLOB.emissive_color_no_bloom
			if(EMISSIVE_BLOOM)
				appearance.color = GLOB.emissive_color
			if(EMISSIVE_SPECULAR)
				appearance.color = GLOB.specular_color
	else
		var/alpha_ratio = alpha / 255
		switch(effect_type)
			if(EMISSIVE_NO_BLOOM)
				appearance.color = _EMISSIVE_COLOR_NO_BLOOM(alpha_ratio)
			if(EMISSIVE_BLOOM)
				appearance.color = _EMISSIVE_COLOR(alpha_ratio)
			if(EMISSIVE_SPECULAR)
				appearance.color = _SPECULAR_COLOR(alpha_ratio)

	return appearance

// This is a semi-hot proc. It mirrors tg's fast path for common emissive blockers
/proc/fast_emissive_blocker(atom/make_blocker)
	var/mutable_appearance/blocker = new()
	blocker.icon = make_blocker.icon
	blocker.icon_state = make_blocker.icon_state
	if(IS_TOPDOWN_PLANE(make_blocker.plane))
		blocker.layer = TOPDOWN_TO_EMISSIVE_LAYER(make_blocker.layer)
	else
		blocker.layer = make_blocker.layer
	blocker.appearance_flags |= make_blocker.appearance_flags | EMISSIVE_APPEARANCE_FLAGS
	blocker.dir = make_blocker.dir
	if(make_blocker.alpha == 255)
		blocker.color = GLOB.em_block_color
	else
		var/alpha_ratio = make_blocker.alpha / 255
		blocker.color = _EM_BLOCK_COLOR(alpha_ratio)

	SET_PLANE_EXPLICIT(blocker, EMISSIVE_PLANE, make_blocker)
	return blocker

/// Produces a mutable appearance glued to the [EMISSIVE_PLANE] dyed to be the [EM_BLOCK_COLOR].
/proc/emissive_blocker(icon, icon_state = "", offset_spokesman, layer, alpha = 255, appearance_flags = NONE, offset_const)
	var/atom/spokesman = isatom(offset_spokesman) ? offset_spokesman : null
	if(spokesman)
		if(isnull(layer))
			if(IS_TOPDOWN_PLANE(spokesman.plane))
				layer = TOPDOWN_TO_EMISSIVE_LAYER(spokesman.layer)
			else
				layer = FLOAT_LAYER
	else
		if(!isnull(offset_spokesman))
			stack_trace("Invalid emissive blocker offset spokesman [offset_spokesman] for [icon] / [icon_state]. Pass an atom as the third argument and layer as the fourth.")
		if(isnull(layer))
			layer = FLOAT_LAYER

	var/mutable_appearance/appearance = mutable_appearance(icon, icon_state, layer, spokesman, EMISSIVE_PLANE, alpha, appearance_flags | EMISSIVE_APPEARANCE_FLAGS, offset_const)
	if(alpha == 255)
		appearance.color = GLOB.em_block_color
	else
		var/alpha_ratio = alpha / 255
		appearance.color = _EM_BLOCK_COLOR(alpha_ratio)
	return appearance

/// Produces an emissive blocker from an existing appearance, preserving its icon shape, offsets, etc.
/proc/emissive_blocker_from_appearance(make_blocker, atom/offset_spokesman)
	if(!make_blocker || !offset_spokesman)
		return

	var/mutable_appearance/blocker = new(make_blocker)
	var/blocker_layer = blocker.layer
	if(IS_TOPDOWN_PLANE(offset_spokesman.plane))
		if(blocker_layer == FLOAT_LAYER)
			blocker_layer = offset_spokesman.layer
		blocker.layer = TOPDOWN_TO_EMISSIVE_LAYER(blocker_layer)
	else if(blocker_layer == FLOAT_LAYER)
		blocker.layer = offset_spokesman.layer

	blocker.appearance_flags |= EMISSIVE_APPEARANCE_FLAGS
	blocker.blend_mode = BLEND_DEFAULT
	blocker.filters = null
	if(blocker.alpha == 255)
		blocker.color = GLOB.em_block_color
	else
		var/alpha_ratio = blocker.alpha / 255
		blocker.color = _EM_BLOCK_COLOR(alpha_ratio)

	SET_PLANE_EXPLICIT(blocker, EMISSIVE_PLANE, offset_spokesman)
	return blocker

/// Adds overlays and matching emissive blockers for atoms which are assembled of overlays, like tables etc. This is SO FUCKING SHITTY!!!
/atom/movable/proc/AddOverlaysWithEmissiveBlocker(sources, cache_target = ATOM_ICON_CACHE_NORMAL)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!sources)
		return

	var/list/source_appearances = SSoverlays.GetAppearanceList(src, sources)
	if(!length(source_appearances))
		return

	AddOverlays(sources, cache_target)

	if(blocks_emissive == EMISSIVE_BLOCK_NONE)
		return

	var/list/blockers = list()
	for(var/source_appearance in source_appearances)
		var/mutable_appearance/blocker = emissive_blocker_from_appearance(source_appearance, src)
		if(blocker)
			blockers += blocker

	if(length(blockers))
		AddOverlays(blockers, cache_target)

/// Makes a non-area atom block emissives with pixels above a given alpha threshold.
/proc/partially_block_emissives(atom/make_blocker, alpha_to_leave)
	var/static/uid = 0
	uid++
	if(!make_blocker.render_target)
		make_blocker.render_target = "partial_emissive_block_[uid]"

	var/cut_away = (alpha_to_leave - 1) / 255
	var/atom/movable/render_step/color/alpha_threshold_down = new(null, make_blocker, list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, 0,0,0,-cut_away))
	alpha_threshold_down.render_target = "*emissive_block_alpha_down_[uid]"

	var/atom/movable/render_step/color/alpha_threshold_up = new(null, alpha_threshold_down, list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,alpha_to_leave, 0,0,0,0))
	alpha_threshold_up.render_target = "*emissive_block_alpha_up_[uid]"

	var/atom/movable/render_step/emissive_blocker/em_block = new(null, alpha_threshold_up)
	var/list/hand_back = list(alpha_threshold_down, alpha_threshold_up, em_block)

	var/atom/movable/vis_cast = make_blocker
	vis_cast.vis_contents += hand_back
	return hand_back

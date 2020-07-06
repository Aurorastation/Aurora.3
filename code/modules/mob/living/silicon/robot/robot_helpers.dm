/mob/living/silicon/robot/set_intent(var/set_intent)
	a_intent = set_intent
	cut_overlay(eye_overlay)
	if(!stat)
		eye_overlay = cached_eye_overlays[a_intent]
		add_overlay(eye_overlay)

/mob/living/silicon/robot/proc/handle_panel_overlay()
	cut_overlay(panel_overlay)
	if(opened)
		if(wires_exposed)
			panel_overlay = cached_panel_overlays[ROBOT_PANEL_EXPOSED]
			add_overlay(panel_overlay)
		else if(cell)
			panel_overlay = cached_panel_overlays[ROBOT_PANEL_CELL]
			add_overlay(panel_overlay)
		else
			panel_overlay = cached_panel_overlays[ROBOT_PANEL_NO_CELL]
			add_overlay(panel_overlay)

/mob/living/silicon/robot/proc/setup_icon_cache()
	cached_eye_overlays = list(
		"help" = image(icon, "eyes-[module_sprites[icontype]]-help", layer = EFFECTS_ABOVE_LIGHTING_LAYER),
		"harm" = image(icon, "eyes-[module_sprites[icontype]]-harm", layer = EFFECTS_ABOVE_LIGHTING_LAYER)
	)
	if(eye_overlay)
		cut_overlay(eye_overlay)
	eye_overlay = cached_eye_overlays[a_intent]
	if(!stat)
		add_overlay(eye_overlay)
	var/panelprefix = custom_sprite ? src.ckey : "ov"
	cached_panel_overlays = list(
		ROBOT_PANEL_EXPOSED = image(icon, "[panelprefix]-openpanel +w"),
		ROBOT_PANEL_CELL = image(icon, "[panelprefix]-openpanel +c"),
		ROBOT_PANEL_NO_CELL = image(icon, "[panelprefix]-openpanel -c")
	)
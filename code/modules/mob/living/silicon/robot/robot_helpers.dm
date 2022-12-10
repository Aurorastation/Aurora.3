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
		else if(cell)
			panel_overlay = cached_panel_overlays[ROBOT_PANEL_CELL]
		else
			panel_overlay = cached_panel_overlays[ROBOT_PANEL_NO_CELL]
		add_overlay(panel_overlay)

/mob/living/silicon/robot/proc/setup_icon_cache()
	if(!module_sprites[icontype])
		return
	setup_eye_cache()
	setup_panel_cache()

/mob/living/silicon/robot/proc/setup_eye_cache()
	if(!module_sprites[icontype][ROBOT_EYES])
		return
	var/eye_layer = src.layer
	if(lights_on && layer == MOB_LAYER) // in case you're hiding. so eyes don't go through tables.
		eye_layer = EFFECTS_ABOVE_LIGHTING_LAYER //make them glow in the dark if the lamp is on
	var/eyeprefix = module_sprites[icontype][ROBOT_EYES]
	if(speed == -2) // For combat drones with the mobility module.
		cached_eye_overlays = list(
			I_HELP = image(icon, "[eyeprefix]-roll-eyes_help", layer = eye_layer),
			I_HURT = image(icon, "[eyeprefix]-roll-eyes_harm", layer = eye_layer)
		)
	else
		cached_eye_overlays = list(
			I_HELP = image(icon, "[eyeprefix]-eyes_help", layer = eye_layer), //Changed so icontype goes in front. Helps with parsing in this godforsaken engine known as BYOND.
			I_HURT = image(icon, "[eyeprefix]-eyes_harm", layer = eye_layer)
		)
	if(eye_overlay)
		cut_overlay(eye_overlay)
	eye_overlay = cached_eye_overlays[a_intent]
	add_overlay(eye_overlay)

/mob/living/silicon/robot/proc/setup_panel_cache()
	if(!module_sprites[icontype][ROBOT_PANEL])
		return
	var/panelprefix = custom_sprite ? src.ckey : module_sprites[icontype][ROBOT_PANEL] // Shoutout to Geeves.
	cached_panel_overlays = list(
		ROBOT_PANEL_EXPOSED = image(icon, "[panelprefix]-openpanel+w"),
		ROBOT_PANEL_CELL = image(icon, "[panelprefix]-openpanel+c"),
		ROBOT_PANEL_NO_CELL = image(icon, "[panelprefix]-openpanel-c")
	)

/mob/living/silicon/robot/proc/set_module_active(var/obj/item/given_module)
	if(module_active)
		module_active.on_module_deactivate(src)
	module_active = given_module
	if(given_module)
		given_module.on_module_activate(src)

/mob/living/silicon/robot/proc/store_module(var/obj/item/stored_module)
	stored_module.on_module_store(src)
	stored_module.loc = module
	if(client)
		client.screen -= stored_module
	contents -= stored_module

/mob/living/silicon/robot/get_cell()
	return cell

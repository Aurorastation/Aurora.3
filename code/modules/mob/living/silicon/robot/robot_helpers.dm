/**
 * Sets our eyes to match our a_intent if we have that set up, and builds the eye cache if we haven't gotten that built yet
 */
/mob/living/silicon/robot/set_intent(var/set_intent)
	a_intent = set_intent
	CutOverlays(list(eye_overlay, eye_emissive))
	if(!length(module_sprites))
		return
	if(!length(cached_eye_overlays))
		setup_eye_cache()
	if(!stat)
		eye_overlay = cached_eye_overlays[a_intent]
		AddOverlays(list(eye_overlay, eye_emissive))

/**
 * Handles updating the panel's sprite on the robot.
 * panel_overlay is scoped to the robot.
 */
/mob/living/silicon/robot/proc/handle_panel_overlay()
	CutOverlays(panel_overlay)
	if(!length(cached_panel_overlays))
		setup_panel_cache()
	if(opened)
		if(wires_exposed)
			panel_overlay = cached_panel_overlays[ROBOT_PANEL_EXPOSED]
		else if(cell)
			panel_overlay = cached_panel_overlays[ROBOT_PANEL_CELL]
		else
			panel_overlay = cached_panel_overlays[ROBOT_PANEL_NO_CELL]
		AddOverlays(panel_overlay)

/mob/living/silicon/robot/proc/setup_icon_cache()
	if(!module_sprites[icontype])
		return
	setup_eye_cache()
	setup_panel_cache()

/**
 * Creates a list of mutable_appearances and emissive_appearances for our robot indexed by intent.
 * eye_overlay is scoped to the robot.
 */
/mob/living/silicon/robot/proc/setup_eye_cache()
	if(!module_sprites?[icontype]?[ROBOT_EYES])
		return
	var/eyeprefix = module_sprites[icontype][ROBOT_EYES]
	var/cached_eye_emissive
	if(speed == -2) // For combat drones with the mobility module.
		cached_eye_overlays = list(
			I_HELP = mutable_appearance(icon, "[eyeprefix]-roll-eyes_help"),
			I_HURT = mutable_appearance(icon, "[eyeprefix]-roll-eyes_harm")
		)
		cached_eye_emissive = emissive_appearance(icon, "[eyeprefix]-roll-eyes_help", src)
	else
		cached_eye_overlays = list(
			I_HELP = mutable_appearance(icon, "[eyeprefix]-eyes_help"),
			I_HURT = mutable_appearance(icon, "[eyeprefix]-eyes_harm")
		)
		cached_eye_emissive = emissive_appearance(icon, "[eyeprefix]-eyes_help", src)
	if(eye_overlay) // We should always have both an eye_overlay and an eye_emissive.
		CutOverlays(list(eye_overlay, eye_emissive))
	eye_overlay = cached_eye_overlays[a_intent]
	eye_emissive = cached_eye_emissive
	AddOverlays(list(eye_overlay, eye_emissive))

/**
 * Creates a list of panel appearances for our robot based on the current state of the robot's panel.
 * If the robot doesn't have a panel, we don't create the cache.
 */

/mob/living/silicon/robot/proc/setup_panel_cache()
	if(!length(module_sprites))
		return
	if(!module_sprites?[icontype]?[ROBOT_PANEL])
		return
	var/panelprefix = custom_sprite ? src.ckey : module_sprites[icontype][ROBOT_PANEL]
	cached_panel_overlays = list(
		ROBOT_PANEL_EXPOSED = mutable_appearance(icon, "[panelprefix]-openpanel+w"),
		ROBOT_PANEL_CELL = mutable_appearance(icon, "[panelprefix]-openpanel+c"),
		ROBOT_PANEL_NO_CELL = mutable_appearance(icon, "[panelprefix]-openpanel-c")
	)

/**
 * Handles module activation/deactivation effects.
 */
/mob/living/silicon/robot/proc/set_module_active(var/obj/item/given_module)
	if(module_active)
		module_active.on_module_deactivate(src)
	module_active = given_module
	if(given_module)
		given_module.on_module_activate(src)

/**
 * Handles module storing effects and clears up the module's icon.
 */
/mob/living/silicon/robot/proc/store_module(var/obj/item/stored_module)
	stored_module.on_module_store(src)
	stored_module.loc = module
	if(client)
		client.screen -= stored_module
	contents -= stored_module

/mob/living/silicon/robot/get_cell()
	return cell

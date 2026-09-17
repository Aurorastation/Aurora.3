/// Contextual controls for the gun in the active hand, above the inventory hotbar.
/datum/hud/proc/update_gun_actions()
	if(!mymob?.client)
		return
	mymob.client.screen -= gun_actions
	if(!ishuman(mymob))
		for(var/atom/movable/screen/gun_action/button in gun_actions)
			button.master = null
		return

	var/obj/item/gun/gun = mymob.get_active_hand()
	if(!istype(gun) || QDELETED(gun))
		for(var/atom/movable/screen/gun_action/button in gun_actions)
			button.master = null
		return

	// Scoping hides the inventory HUD; keep these controls available to unzoom.
	if(hud_shown != 1 && !gun.zoom)
		for(var/atom/movable/screen/gun_action/button in gun_actions)
			button.master = null
		return

	if(!length(gun_actions))
		for(var/action_type in list("safety", "unique action", "fire mode", "scope"))
			var/atom/movable/screen/gun_action/button = new
			button.action_type = action_type
			gun_actions += button

	var/next_button_x = 0
	for(var/atom/movable/screen/gun_action/button in gun_actions)
		button.master = null
		switch(button.action_type)
			if("safety")
				if(!gun.has_safety)
					continue
			if("fire mode")
				if(length(gun.firemodes) < 2)
					continue
			if("scope")
				if(!gun.get_scope_action())
					continue
			if("unique action")
				if(!gun.has_unique_gun_action)
					continue
		button.master = gun
		button.update_icon()
		// Place the visible edge after the previous button.
		var/list/bounds = button.get_sprite_bounds()
		var/screen_x_offset = 16 + next_button_x - bounds[1]
		button.screen_loc = "CENTER-1:[screen_x_offset],SOUTH+1:14"
		button.pixel_x = 0
		next_button_x += bounds[3]
		mymob.client.screen |= button

/atom/movable/screen/gun_action
	icon = 'icons/hud/action_buttons/gun_actions.dmi'
	layer = HUD_ABOVE_ITEM_LAYER
	var/action_type

/atom/movable/screen/gun_action/Click(location, control, params)
	var/mob/living/user = usr
	var/obj/item/gun/gun = master
	if(!istype(user) || !istype(gun) || QDELETED(gun) || user.get_active_hand() != gun)
		return
	if(user.next_move >= world.time || gun.use_check(user, USE_FORCE_SRC_IN_USER))
		return
	switch(action_type)
		if("safety")
			if(gun.has_safety)
				gun.toggle_safety(user)
		if("fire mode")
			gun.toggle_firing_mode(user)
		if("scope")
			var/scope_action = gun.get_scope_action()
			if(scope_action)
				call(gun, scope_action)()
		if("unique action")
			gun.unique_action(user)
	user.hud_used?.update_gun_actions()

/atom/movable/screen/gun_action/update_icon()
	var/obj/item/gun/gun = master
	if(!istype(gun))
		return
	ClearOverlays()
	switch(action_type)
		if("safety")
			icon_state = "safety[gun.safety() ? 1 : 0]"
			name = "Toggle Gun Safety ([gun.safety() ? "on" : "off"])"
		if("fire mode")
			var/datum/firemode/mode = gun.firemodes[gun.sel_mode]
			icon_state = gun.get_firemode_action_icon(mode)
			name = "Toggle Firing Mode ([mode.name])"
		if("scope")
			icon_state = "scope[gun.zoom ? 1 : 0]"
			name = "Use Scope ([gun.zoom ? "on" : "off"])"
		if("unique action")
			icon_state = "unique_action"
			name = "Unique Action"

/// Cached visible bounds: left padding, bottom padding, width, height (in pixels).
/// Include every frame of the supplied animations so their widest frame also fits.
/atom/movable/screen/gun_action/proc/get_sprite_bounds()
	var/static/list/bounds_cache = list()
	var/cache_key = "[icon]:[icon_state]"
	if(bounds_cache[cache_key])
		return bounds_cache[cache_key]

	var/min_x = 32
	var/min_y = 32
	var/max_x = 0
	var/max_y = 0
	var/frame_count = 1
	switch(icon_state)
		if("fire mode")
			frame_count = 7
		if("scope")
			frame_count = 6
		if("safety")
			frame_count = 9
	for(var/frame_number in 1 to frame_count)
		var/icon/sprite = icon(icon, icon_state, frame = frame_number)
		for(var/x in 1 to sprite.Width())
			for(var/y in 1 to sprite.Height())
				if(!sprite.GetPixel(x, y))
					continue
				min_x = min(min_x, x)
				min_y = min(min_y, y)
				max_x = max(max_x, x)
				max_y = max(max_y, y)

	var/list/bounds
	if(max_x)
		bounds = list(min_x - 1, min_y - 1, max_x - min_x + 1, max_y - min_y + 1)
	else
		bounds = list(0, 0, 32, 32)
	bounds_cache[cache_key] = bounds
	return bounds

/// Find the existing scope verb rather than bypassing individual guns' checks.
/obj/item/gun/proc/get_scope_action()
	if(!zoomdevicename)
		return
	if(("has_scope" in vars) && !vars["has_scope"])
		return
	for(var/verb_path in verbs)
		if(copytext("[verb_path]", -6) == "/scope")
			return verb_path

/obj/item/gun/proc/get_firemode_action_icon(datum/firemode/mode)
	if(mode.button_icon_state)
		return mode.button_icon_state
	var/mode_name = lowertext(mode.name)
	if(findtext(mode_name, "stun"))
		return "mode_stun"
	if(findtext(mode_name, "destroy"))
		return "mode_destroy"
	if(findtext(mode_name, "lethal") || mode_name == "kill")
		return "mode_kill"
	if(mode.settings["use_launcher"])
		return "mode_grenade"
	if(can_autofire)
		return "mode_auto"
	if(burst > 1)
		return "mode_burst"
	if(!istype(src, /obj/item/gun/energy))
		return "mode_semi"
	return "fire mode"

/// Refresh state changes made through verbs, shortcuts, or automatic mode switches.
/obj/item/gun/proc/update_gun_actions()
	if(ismob(loc))
		var/mob/user = loc
		if(user.get_active_hand() == src)
			user.hud_used?.update_gun_actions()

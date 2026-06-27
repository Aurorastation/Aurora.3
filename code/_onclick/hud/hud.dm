/*
	The global hud:
	Uses the same visual objects for all players.
*/
GLOBAL_DATUM_INIT(global_hud, /datum/global_hud, new)
GLOBAL_LIST(global_huds)

/datum/global_hud
	var/atom/movable/screen/vr_control
	var/atom/movable/screen/druggy
	var/atom/movable/screen/blurry
	var/list/vimpaired
	var/atom/movable/screen/nvg
	var/atom/movable/screen/thermal
	var/atom/movable/screen/meson
	var/atom/movable/screen/science

/datum/global_hud/proc/setup_overlay(var/icon_state, var/color)
	var/atom/movable/screen/screen = new /atom/movable/screen()
	screen.alpha = 25 // Adjust this if you want goggle overlays to be thinner or thicker.
	screen.screen_loc = "SOUTHWEST to NORTHEAST" // Will tile up to the whole screen, scaling beyond 15x15 if needed.
	screen.icon = 'icons/obj/hud_tiled.dmi'
	screen.icon_state = icon_state
	screen.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	screen.color = color

	return screen

/datum/global_hud/New()
	//420erryday psychedellic colours screen overlay for when you are high
	druggy = new /atom/movable/screen()
	druggy.screen_loc = ui_entire_screen
	druggy.icon_state = "druggy"
	druggy.layer = IMPAIRED_LAYER
	druggy.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	druggy.alpha = 127
	druggy.blend_mode = BLEND_MULTIPLY

	//that white blurry effect you get when you eyes are damaged
	blurry = new /atom/movable/screen()
	blurry.screen_loc = ui_entire_screen
	blurry.icon_state = "blurry"
	blurry.layer = IMPAIRED_LAYER
	blurry.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	blurry.alpha = 100

	vr_control = new /atom/movable/screen()
	vr_control.icon = 'icons/hud/mob/full.dmi'
	vr_control.icon_state = "vr_control"
	vr_control.screen_loc = "1,1"
	vr_control.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	vr_control.alpha = 120

	nvg = setup_overlay("scanline", "#06ff00")
	thermal = setup_overlay("scanline", "#ff0000")
	meson = setup_overlay("scanline", "#9fd800")
	science = setup_overlay("scanline", "#d600d6")

	var/atom/movable/screen/O
	var/i
	//that nasty looking dither you  get when you're short-sighted
	vimpaired = newlist(/atom/movable/screen,/atom/movable/screen,/atom/movable/screen,/atom/movable/screen)
	O = vimpaired[1]
	O.screen_loc = "1,1 to 5,15"
	O = vimpaired[2]
	O.screen_loc = "5,1 to 10,5"
	O = vimpaired[3]
	O.screen_loc = "6,11 to 10,15"
	O = vimpaired[4]
	O.screen_loc = "11,1 to 15,15"

	for(i = 1, i <= 4, i++)
		O = vimpaired[i]
		O.icon_state = "dither50"
		O.layer = IMPAIRED_LAYER
		O.mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/**
 *	The hud datum
 *	Used to show and hide huds for all the different mob types,
 *	including inventories and item quick actions.
 */
/datum/hud
	///The mob that possesses the HUD
	var/mob/mymob

	///Boolean, if the HUD is shown, used for the HUD toggle (F12)
	var/hud_shown = TRUE

	///Boolean, if the inventory is shows
	var/inventory_shown = TRUE

	///Boolean, if the intent icons are shown
	var/show_intent_icons = FALSE

	///Boolean, this is to hide the buttons that can be used via hotkeys. (hotkeybuttons list of buttons)
	var/hotkey_ui_hidden = FALSE

	///Boolean, if the action buttons are hidden
	var/action_buttons_hidden = FALSE

	/*
		STOP ADDING SNOWFLAKE HUD ELEMENTS LIKE /datum/hud/var/atom/movable/screen/help_intent
		IN DIFFERENT FILES ENTIRELY. IF YOU ARE ADDING A NEW HUD ELEMENT TO THIS, PUT IT IN THIS FILE UNDER THIS LIST,
		AND INCLUDE A QDEL_NULL() FOR IT IN THE DESTROY PROC.
																														*/
	var/atom/movable/screen/blobpwrdisplay
	var/atom/movable/screen/blobhealthdisplay
	var/atom/movable/screen/r_hand_hud_object
	var/atom/movable/screen/l_hand_hud_object
	var/atom/movable/screen/action_intent
	var/atom/movable/screen/movement_intent/move_intent
	var/atom/movable/screen/grab_intent
	var/atom/movable/screen/hurt_intent
	var/atom/movable/screen/disarm_intent
	var/atom/movable/screen/help_intent

	var/list/adding
	var/list/other
	var/list/atom/movable/screen/hotkeybuttons

	/// Assoc list of key => plane master group.
	var/list/datum/plane_master_group/master_groups = list()
	/// The client eye currently registered for z-level changes.
	var/atom/tracked_eye
	/// Current tg plane-cube visual offset.
	var/current_plane_offset = 0
	///Assoc list of controller groups, associated with key string group name with value of the plane master controller ref
	var/list/atom/movable/plane_master_controller/plane_master_controllers = list()

	var/atom/movable/screen/movable/action_button/hide_toggle/hide_actions_toggle

/datum/hud/New(mob/owner)
	mymob = owner

	var/datum/plane_master_group/main/main_group = new(PLANE_GROUP_MAIN)
	main_group.attach_to(src)

	for(var/mytype in subtypesof(/atom/movable/plane_master_controller))
		var/atom/movable/plane_master_controller/controller_instance = new mytype(null,src)
		plane_master_controllers[controller_instance.name] = controller_instance

	RegisterSignal(SSmapping, COMSIG_PLANE_OFFSET_INCREASE, PROC_REF(on_plane_increase))
	RegisterSignal(mymob, COMSIG_MOB_LOGIN, PROC_REF(client_refresh))
	RegisterSignal(mymob, COMSIG_MOB_LOGOUT, PROC_REF(clear_client))
	RegisterSignal(mymob, COMSIG_MOB_SIGHT_CHANGE, PROC_REF(update_sightflags))
	if(mymob.canon_client)
		client_refresh()
	update_sightflags(mymob, mymob.sight, NONE)

	instantiate()
	..()

/datum/hud/Destroy()
	clear_client()
	UnregisterSignal(SSmapping, COMSIG_PLANE_OFFSET_INCREASE)
	if(mymob)
		UnregisterSignal(mymob, list(COMSIG_MOB_LOGIN, COMSIG_MOB_LOGOUT, COMSIG_MOB_SIGHT_CHANGE))
	mymob = null
	QDEL_NULL(blobpwrdisplay)
	QDEL_NULL(blobhealthdisplay)
	QDEL_NULL(r_hand_hud_object)
	QDEL_NULL(l_hand_hud_object)
	QDEL_NULL(action_intent)
	QDEL_NULL(move_intent)
	QDEL_NULL(grab_intent)
	QDEL_NULL(hurt_intent)
	QDEL_NULL(disarm_intent)
	QDEL_NULL(help_intent)

	adding?.Cut()
	other?.Cut()
	QDEL_LIST(hotkeybuttons)

	QDEL_LIST_ASSOC_VAL(master_groups)
	QDEL_LIST_ASSOC_VAL(plane_master_controllers)
	QDEL_NULL(hide_actions_toggle)

	return ..()

/datum/hud/proc/hidden_inventory_update()
	if(!mymob)
		return

	if(ishuman(mymob))
		var/mob/living/carbon/human/H = mymob
		for(var/gear_slot in H.species.hud.gear)
			var/list/hud_data = H.species.hud.gear[gear_slot]
			if(inventory_shown && hud_shown)
				switch(hud_data["slot"])
					if(slot_head)
						if(H.head)
							H.head.screen_loc =	hud_data["loc"]
					if(slot_shoes)
						if(H.shoes)
							H.shoes.screen_loc = hud_data["loc"]
					if(slot_l_ear)
						if(H.l_ear)
							H.l_ear.screen_loc = hud_data["loc"]
					if(slot_r_ear)
						if(H.r_ear)
							H.r_ear.screen_loc = hud_data["loc"]
					if(slot_gloves)
						if(H.gloves)
							H.gloves.screen_loc = hud_data["loc"]
					if(slot_glasses)
						if(H.glasses)
							H.glasses.screen_loc = hud_data["loc"]
					if(slot_w_uniform)
						if(H.w_uniform)
							H.w_uniform.screen_loc = hud_data["loc"]
					if(slot_wear_suit)
						if(H.wear_suit)
							H.wear_suit.screen_loc = hud_data["loc"]
					if(slot_wear_mask)
						if(H.wear_mask)
							H.wear_mask.screen_loc = hud_data["loc"]
					if(slot_wrists)
						if(H.wrists)
							H.wrists.screen_loc = hud_data["loc"]
					if(slot_pants)
						if(H.pants)
							H.pants.screen_loc = hud_data["loc"]
			else
				switch(hud_data["slot"])
					if(slot_head)
						if(H.head)
							H.head.screen_loc =	null
					if(slot_shoes)
						if(H.shoes)
							H.shoes.screen_loc = null
					if(slot_l_ear)
						if(H.l_ear)
							H.l_ear.screen_loc = null
					if(slot_r_ear)
						if(H.r_ear)
							H.r_ear.screen_loc = null
					if(slot_gloves)
						if(H.gloves)
							H.gloves.screen_loc = null
					if(slot_glasses)
						if(H.glasses)
							H.glasses.screen_loc = null
					if(slot_w_uniform)
						if(H.w_uniform)
							H.w_uniform.screen_loc = null
					if(slot_wear_suit)
						if(H.wear_suit)
							H.wear_suit.screen_loc = null
					if(slot_wear_mask)
						if(H.wear_mask)
							H.wear_mask.screen_loc = null
					if(slot_wrists)
						if(H.wrists)
							H.wrists.screen_loc = null
					if(slot_pants)
						if(H.pants)
							H.pants.screen_loc = null


/datum/hud/proc/persistant_inventory_update()
	if(!mymob)
		return

	if(ishuman(mymob))
		var/mob/living/carbon/human/H = mymob
		for(var/gear_slot in H.species.hud.gear)
			var/list/hud_data = H.species.hud.gear[gear_slot]
			if(hud_shown)
				switch(hud_data["slot"])
					if(slot_s_store)
						if(H.s_store)
							H.s_store.screen_loc = hud_data["loc"]
					if(slot_wear_id)
						if(H.wear_id)
							H.wear_id.screen_loc = hud_data["loc"]
					if(slot_belt)
						if(H.belt)
							H.belt.screen_loc = hud_data["loc"]
					if(slot_back)
						if(H.back)
							H.back.screen_loc = hud_data["loc"]
					if(slot_l_store)
						if(H.l_store)
							H.l_store.screen_loc = hud_data["loc"]
					if(slot_r_store)
						if(H.r_store)
							H.r_store.screen_loc = hud_data["loc"]
			else
				switch(hud_data["slot"])
					if(slot_s_store)
						if(H.s_store)
							H.s_store.screen_loc = null
					if(slot_wear_id)
						if(H.wear_id)
							H.wear_id.screen_loc = null
					if(slot_belt)
						if(H.belt)
							H.belt.screen_loc =    null
					if(slot_back)
						if(H.back)
							H.back.screen_loc =    null
					if(slot_l_store)
						if(H.l_store)
							H.l_store.screen_loc = null
					if(slot_r_store)
						if(H.r_store)
							H.r_store.screen_loc = null


/**
 * Instantiate an HUD to the current mob that own is
 */
/datum/hud/proc/instantiate()
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(FALSE)

	if(!ismob(mymob))
		stack_trace("HUD instantiation called on an HUD without a mob!")
		return FALSE

	if(!(mymob.client))
		return FALSE

	var/ui_style = ui_style2icon(mymob.client.prefs.UI_style)
	var/ui_color = mymob.client.prefs.UI_style_color
	var/ui_alpha = mymob.client.prefs.UI_style_alpha

	mymob.instantiate_hud(src, ui_style, ui_color, ui_alpha)

	plane_masters_update()

/datum/hud/proc/plane_masters_update()
	for(var/group_key in master_groups)
		var/datum/plane_master_group/group = master_groups[group_key]
		group.refresh_hud()
	SEND_SIGNAL(mymob, COMSIG_MOB_HUD_REFRESHED)

// what the fuck am i doing in this terrible place???

/datum/hud/proc/client_refresh(datum/source)
	SIGNAL_HANDLER
	var/client/our_client = mymob?.canon_client
	if(!our_client)
		return
	UnregisterSignal(our_client, COMSIG_CLIENT_SET_EYE)
	RegisterSignal(our_client, COMSIG_CLIENT_SET_EYE, PROC_REF(on_eye_change))
	on_eye_change(our_client, tracked_eye, our_client.eye)

/datum/hud/proc/clear_client(datum/source)
	SIGNAL_HANDLER
	var/client/our_client = mymob?.canon_client
	if(our_client)
		UnregisterSignal(our_client, COMSIG_CLIENT_SET_EYE)
	if(tracked_eye)
		UnregisterSignal(tracked_eye, COMSIG_MOVABLE_Z_CHANGED)
		tracked_eye = null

/datum/hud/proc/on_eye_change(datum/source, atom/old_eye, atom/new_eye)
	SIGNAL_HANDLER
	var/atom/previous_eye = tracked_eye || old_eye
	if(previous_eye && previous_eye != new_eye)
		UnregisterSignal(previous_eye, COMSIG_MOVABLE_Z_CHANGED)
	tracked_eye = new_eye
	if(new_eye)
		RegisterSignal(new_eye, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(eye_z_changed), override = TRUE)

	SEND_SIGNAL(src, COMSIG_HUD_EYE_CHANGED, old_eye, new_eye)
	eye_z_changed(new_eye)

/datum/hud/proc/update_sightflags(datum/source, new_sight, old_sight)
	SIGNAL_HANDLER
	if(should_sight_scale(new_sight) == should_sight_scale(old_sight))
		return

	for(var/group_key in master_groups)
		var/datum/plane_master_group/group = master_groups[group_key]
		group.build_planes_offset(src, current_plane_offset)

/datum/hud/proc/should_sight_scale(sight_flags)
	return (sight_flags & (SEE_TURFS | SEE_OBJS)) != SEE_TURFS

/datum/hud/proc/eye_z_changed(atom/eye)
	SIGNAL_HANDLER
	update_parallax_pref()
	var/turf/eye_turf = get_turf(eye)
	if(!eye_turf)
		return

	SEND_SIGNAL(src, COMSIG_HUD_Z_CHANGED, eye_turf.z)
	var/new_offset = GET_TURF_PLANE_OFFSET(eye_turf)
	if(current_plane_offset == new_offset)
		return

	var/old_offset = current_plane_offset
	current_plane_offset = new_offset

	SEND_SIGNAL(src, COMSIG_HUD_OFFSET_CHANGED, old_offset, new_offset)
	for(var/group_key in master_groups)
		var/datum/plane_master_group/group = master_groups[group_key]
		group.build_planes_offset(src, new_offset, animate_transform = FALSE)

/datum/hud/proc/on_plane_increase(datum/source, old_max_offset, new_max_offset)
	SIGNAL_HANDLER
	build_plane_groups(old_max_offset + 1, new_max_offset)

/datum/hud/proc/build_plane_groups(starting_offset, ending_offset)
	for(var/group_key in master_groups)
		var/datum/plane_master_group/group = master_groups[group_key]
		group.build_plane_masters(starting_offset, ending_offset)
		group.refresh_hud()
		group.build_planes_offset(src, current_plane_offset)

/datum/hud/proc/get_plane_group(group_key)
	return master_groups[group_key]

/datum/hud/proc/get_plane_master(plane, group_key = PLANE_GROUP_MAIN)
	var/datum/plane_master_group/group = master_groups[group_key]
	return group?.plane_masters["[plane]"]

/datum/hud/proc/get_true_plane_masters(true_plane, group_key = PLANE_GROUP_MAIN)
	var/list/atom/movable/screen/plane_master/masters = list()
	for(var/plane in TRUE_PLANE_TO_OFFSETS(true_plane))
		var/atom/movable/screen/plane_master/master = get_plane_master(plane, group_key)
		if(master)
			masters += master
	return masters

/datum/hud/proc/get_plane_masters(group_key = PLANE_GROUP_MAIN)
	var/datum/plane_master_group/group = master_groups[group_key]
	return group?.plane_masters

/datum/hud/proc/get_planes_from(group_key = PLANE_GROUP_MAIN)
	return get_plane_masters(group_key)

/datum/hud/proc/should_use_scale()
	return should_sight_scale(mymob.sight)

/datum/hud/proc/get_multiz_performance_boundary()
	return MULTIZ_PERFORMANCE_DISABLE

/mob/proc/instantiate_hud(datum/hud/HUD, ui_style, ui_color, ui_alpha)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(FALSE)

	return

//Triggered when F12 is pressed (Unless someone changed something in the DMF)
/mob/verb/button_pressed_F12(var/full = 0 as null)
	set name = "F12"
	set hidden = 1

	if(!hud_used)
		to_chat(usr, SPAN_WARNING("This mob type does not use a HUD."))
		return

	if(!ishuman(src))
		to_chat(usr, SPAN_WARNING("Inventory hiding is currently only supported for human mobs."))
		return

	if(!client)
		return

	if(client.view != world.view)
		return

	if(hud_used.hud_shown)
		hud_used.hud_shown = 0
		if(src.hud_used.adding)
			src.client.screen -= src.hud_used.adding
		if(src.hud_used.other)
			src.client.screen -= src.hud_used.other
		if(src.hud_used.hotkeybuttons)
			src.client.screen -= src.hud_used.hotkeybuttons

		//Due to some poor coding some things need special treatment:
		//These ones are a part of 'adding', 'other' or 'hotkeybuttons' but we want them to stay
		if(!full)
			src.client.screen += src.hud_used.l_hand_hud_object	//we want the hands to be visible
			src.client.screen += src.hud_used.r_hand_hud_object	//we want the hands to be visible
			src.client.screen += src.hud_used.action_intent		//we want the intent swticher visible
			src.hud_used.action_intent.screen_loc = ui_acti_alt	//move this to the alternative position, where zone_select usually is.
		else
			src.client.screen -= src.healths
			src.client.screen -= src.internals
			src.client.screen -= src.gun_setting_icon

		//These ones are not a part of 'adding', 'other' or 'hotkeybuttons' but we want them gone.
		src.client.screen -= src.zone_sel	//zone_sel is a mob variable for some reason.

	else
		hud_used.hud_shown = 1
		if(src.hud_used.adding)
			src.client.screen += src.hud_used.adding
		if(src.hud_used.other && src.hud_used.inventory_shown)
			src.client.screen += src.hud_used.other
		if(src.hud_used.hotkeybuttons && !src.hud_used.hotkey_ui_hidden)
			src.client.screen += src.hud_used.hotkeybuttons
		if(src.healths)
			src.client.screen |= src.healths
		if(src.internals)
			src.client.screen |= src.internals
		if(src.gun_setting_icon)
			src.client.screen |= src.gun_setting_icon

		src.hud_used.action_intent.screen_loc = ui_acti //Restore intent selection to the original position
		src.client.screen += src.zone_sel				//This one is a special snowflake

	hud_used.hidden_inventory_update()
	hud_used.persistant_inventory_update()
	hud_used.reorganize_alerts()
	update_action_buttons()

//Similar to button_pressed_F12() but keeps zone_sel, gun_setting_icon, and healths.
/mob/proc/toggle_zoom_hud()
	if(!hud_used)
		return
	if(!ishuman(src))
		return
	if(!client)
		return
	if(client.view != world.view)
		return

	if(hud_used.hud_shown)
		hud_used.hud_shown = 0
		if(src.hud_used.adding)
			src.client.screen -= src.hud_used.adding
		if(src.hud_used.other)
			src.client.screen -= src.hud_used.other
		if(src.hud_used.hotkeybuttons)
			src.client.screen -= src.hud_used.hotkeybuttons
		src.client.screen -= src.internals
		src.client.screen += src.hud_used.action_intent		//we want the intent swticher visible
	else
		hud_used.hud_shown = 1
		if(src.hud_used.adding)
			src.client.screen += src.hud_used.adding
		if(src.hud_used.other && src.hud_used.inventory_shown)
			src.client.screen += src.hud_used.other
		if(src.hud_used.hotkeybuttons && !src.hud_used.hotkey_ui_hidden)
			src.client.screen += src.hud_used.hotkeybuttons
		if(src.internals)
			src.client.screen |= src.internals
		src.hud_used.action_intent.screen_loc = ui_acti //Restore intent selection to the original position

	hud_used.hidden_inventory_update()
	hud_used.persistant_inventory_update()
	update_action_buttons()

/mob/proc/add_click_catcher()
	client.screen |= GLOB.click_catchers

/mob/abstract/new_player/add_click_catcher()
	return

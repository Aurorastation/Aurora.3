/*
	The global hud:
	Uses the same visual objects for all players.
*/
var/datum/global_hud/global_hud	// Initialized in SSatoms.
var/list/global_huds

/datum/hud/var/obj/screen/grab_intent
/datum/hud/var/obj/screen/hurt_intent
/datum/hud/var/obj/screen/disarm_intent
/datum/hud/var/obj/screen/help_intent

/datum/global_hud
	var/obj/screen/vr_control
	var/obj/screen/druggy
	var/obj/screen/blurry
	var/list/vimpaired
	var/list/darkMask
	var/obj/screen/nvg
	var/obj/screen/thermal
	var/obj/screen/meson
	var/obj/screen/science

/datum/global_hud/proc/setup_overlay(var/icon_state, var/color)
	var/obj/screen/screen = new /obj/screen()
	screen.alpha = 25 // Adjust this if you want goggle overlays to be thinner or thicker.
	screen.screen_loc = "SOUTHWEST to NORTHEAST" // Will tile up to the whole screen, scaling beyond 15x15 if needed.
	screen.icon = 'icons/obj/hud_tiled.dmi'
	screen.icon_state = icon_state
	screen.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	screen.color = color

	return screen

/datum/global_hud/New()
	//420erryday psychedellic colours screen overlay for when you are high
	druggy = new /obj/screen()
	druggy.screen_loc = ui_entire_screen
	druggy.icon_state = "druggy"
	druggy.layer = IMPAIRED_LAYER
	druggy.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	druggy.alpha = 127
	druggy.blend_mode = BLEND_MULTIPLY

	//that white blurry effect you get when you eyes are damaged
	blurry = new /obj/screen()
	blurry.screen_loc = ui_entire_screen
	blurry.icon_state = "blurry"
	blurry.layer = IMPAIRED_LAYER
	blurry.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	blurry.alpha = 100

	vr_control = new /obj/screen()
	vr_control.icon = 'icons/mob/screen/full.dmi'
	vr_control.icon_state = "vr_control"
	vr_control.screen_loc = "1,1"
	vr_control.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	vr_control.alpha = 120

	nvg = setup_overlay("scanline", "#06ff00")
	thermal = setup_overlay("scanline", "#ff0000")
	meson = setup_overlay("scanline", "#9fd800")
	science = setup_overlay("scanline", "#d600d6")

	var/obj/screen/O
	var/i
	//that nasty looking dither you  get when you're short-sighted
	vimpaired = newlist(/obj/screen,/obj/screen,/obj/screen,/obj/screen)
	O = vimpaired[1]
	O.screen_loc = "1,1 to 5,15"
	O = vimpaired[2]
	O.screen_loc = "5,1 to 10,5"
	O = vimpaired[3]
	O.screen_loc = "6,11 to 10,15"
	O = vimpaired[4]
	O.screen_loc = "11,1 to 15,15"

	//welding mask overlay black/dither
	darkMask = newlist(/obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen)
	O = darkMask[1]
	O.screen_loc = "WEST+2,SOUTH+2 to WEST+4,NORTH-2"
	O = darkMask[2]
	O.screen_loc = "WEST+4,SOUTH+2 to EAST-5,SOUTH+4"
	O = darkMask[3]
	O.screen_loc = "WEST+5,NORTH-4 to EAST-5,NORTH-2"
	O = darkMask[4]
	O.screen_loc = "EAST-4,SOUTH+2 to EAST-2,NORTH-2"
	O = darkMask[5]
	O.screen_loc = "WEST,SOUTH to EAST,SOUTH+1"
	O = darkMask[6]
	O.screen_loc = "WEST,SOUTH+2 to WEST+1,NORTH"
	O = darkMask[7]
	O.screen_loc = "EAST-1,SOUTH+2 to EAST,NORTH"
	O = darkMask[8]
	O.screen_loc = "WEST+2,NORTH-1 to EAST-2,NORTH"

	for(i = 1, i <= 4, i++)
		O = vimpaired[i]
		O.icon_state = "dither50"
		O.layer = IMPAIRED_LAYER
		O.mouse_opacity = MOUSE_OPACITY_TRANSPARENT

		O = darkMask[i]
		O.icon_state = "dither50"
		O.layer = IMPAIRED_LAYER
		O.mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	for(i = 5, i <= 8, i++)
		O = darkMask[i]
		O.icon_state = "black"
		O.layer = IMPAIRED_LAYER
		O.mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/*
	The hud datum
	Used to show and hide huds for all the different mob types,
	including inventories and item quick actions.
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

	var/obj/screen/button_palette/toggle_palette
	var/obj/screen/palette_scroll/down/palette_down
	var/obj/screen/palette_scroll/up/palette_up

	var/datum/action_group/palette/palette_actions
	var/datum/action_group/listed/listed_actions
	var/list/floating_actions

	var/obj/screen/blobpwrdisplay
	var/obj/screen/blobhealthdisplay
	var/obj/screen/r_hand_hud_object
	var/obj/screen/l_hand_hud_object
	var/obj/screen/action_intent
	var/obj/screen/movement_intent/move_intent

	var/list/adding
	var/list/other
	var/list/obj/screen/hotkeybuttons

/datum/hud/New(mob/owner)
	mymob = owner
	toggle_palette = new()
	toggle_palette.our_hud = src
	palette_down = new()
	palette_down.our_hud = src
	palette_up = new()
	palette_up.our_hud = src
	instantiate()
	..()

/datum/hud/Destroy()
	grab_intent = null
	hurt_intent = null
	disarm_intent = null
	help_intent = null
	blobpwrdisplay = null
	blobhealthdisplay = null
	r_hand_hud_object = null
	l_hand_hud_object = null
	action_intent = null
	move_intent = null
	adding = null
	other = null
	hotkeybuttons = null
//	item_action_list = null // ?
	QDEL_NULL(toggle_palette)
	QDEL_NULL(palette_down)
	QDEL_NULL(palette_up)
	QDEL_NULL(palette_actions)
	QDEL_NULL(listed_actions)
	QDEL_LIST(floating_actions)
	mymob = null

	. = ..()

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
							H.wear_suit.screen_loc =hud_data["loc"]
					if(slot_wear_mask)
						if(H.wear_mask)
							H.wear_mask.screen_loc =hud_data["loc"]
					if(slot_wrists)
						if(H.wrists)
							H.wrists.screen_loc =	hud_data["loc"]
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
							H.w_uniform.screen_loc =null
					if(slot_wear_suit)
						if(H.wear_suit)
							H.wear_suit.screen_loc = null
					if(slot_wear_mask)
						if(H.wear_mask)
							H.wear_mask.screen_loc =null
					if(slot_wrists)
						if(H.wrists)
							H.wrists.screen_loc =	null

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
	update_action_buttons(TRUE)

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
	update_action_buttons(TRUE)

/mob/proc/add_click_catcher()
	client.screen |= click_catchers

/mob/abstract/new_player/add_click_catcher()
	return

/datum/hud/proc/position_action(obj/screen/movable/action_button/button, position)
	if(button.location != SCRN_OBJ_DEFAULT)
		hide_action(button)
	switch(position)
		if(SCRN_OBJ_DEFAULT) // Reset to the default
			position_action(button, button.linked_action.default_button_position)
			return
		if(SCRN_OBJ_IN_LIST)
			listed_actions.insert_action(button)
		if(SCRN_OBJ_IN_PALETTE)
			palette_actions.insert_action(button)
		else // If we don't have it as a define, this is a screen_loc, and we should be floating
			floating_actions += button
			button.screen_loc = position
			position = SCRN_OBJ_FLOATING

	button.location = position

/datum/hud/proc/position_action_relative(obj/screen/movable/action_button/button, obj/screen/movable/action_button/relative_to)
	if(button.location != SCRN_OBJ_DEFAULT)
		hide_action(button)
	switch(relative_to.location)
		if(SCRN_OBJ_IN_LIST)
			listed_actions.insert_action(button, listed_actions.index_of(relative_to))
		if(SCRN_OBJ_IN_PALETTE)
			palette_actions.insert_action(button, palette_actions.index_of(relative_to))
		if(SCRN_OBJ_FLOATING) // If we don't have it as a define, this is a screen_loc, and we should be floating
			floating_actions += button
			var/client/our_client = mymob.client
			if(!our_client)
				position_action(button, button.linked_action.default_button_position)
				return
			button.screen_loc = get_valid_screen_location(relative_to.screen_loc, world.icon_size, our_client.view_size.getView()) // Asks for a location adjacent to our button that won't overflow the map

	button.location = relative_to.location

/// Removes the passed in action from its current position on the screen
/datum/hud/proc/hide_action(obj/screen/movable/action_button/button)
	switch(button.location)
		if(SCRN_OBJ_DEFAULT) // Invalid
			CRASH("We just tried to hide an action buttion that somehow has the default position as its location, you done fucked up")
		if(SCRN_OBJ_FLOATING)
			floating_actions -= button
		if(SCRN_OBJ_IN_LIST)
			listed_actions.remove_action(button)
		if(SCRN_OBJ_IN_PALETTE)
			palette_actions.remove_action(button)
	button.screen_loc = null

/// Generates visual landings for all groups that the button is not a memeber of
/datum/hud/proc/generate_landings(obj/screen/movable/action_button/button)
	listed_actions.generate_landing()
	palette_actions.generate_landing()

/// Clears all currently visible landings
/datum/hud/proc/hide_landings()
	listed_actions.clear_landing()
	palette_actions.clear_landing()

// Updates any existing landing visuals
/datum/hud/proc/refresh_landings()
	listed_actions.update_landing()
	palette_actions.update_landing()

/// Generates and fills new action groups with our mob's current actions
/datum/hud/proc/build_action_groups()
	listed_actions = new(src)
	palette_actions = new(src)
	floating_actions = list()
	for(var/datum/action/action as anything in mymob.actions)
		var/obj/screen/movable/action_button/button = action.viewers[src]
		if(!button)
			action.ShowTo(mymob)
			button = action.viewers[src]
		position_action(button, button.location)

/datum/action_group
	/// The hud we're owned by
	var/datum/hud/owner
	/// The actions we're managing
	var/list/obj/screen/movable/action_button/actions
	/// The initial vertical offset of our action buttons
	var/north_offset = 0
	/// The pixel vertical offset of our action buttons
	var/pixel_north_offset = 0
	/// Max amount of buttons we can have per row, indexes at 1
	var/column_max = 0
	/// How far "ahead" of the first row we start. Lets us "scroll" our rows Indexes at 1
	var/row_offset = 0
	/// How many rows of actions we can have at max before we just stop hiding
	/// Indexes at 1
	var/max_rows = INFINITY
	/// The screen location we go by
	var/location
	/// Our landing screen object
	var/obj/screen/action_landing/landing

/datum/action_group/New(datum/hud/owner)
	..()
	actions = list()
	src.owner = owner

/datum/action_group/Destroy()
	owner = null
	QDEL_NULL(landing)
	QDEL_LIST(actions)
	return ..()

/datum/action_group/proc/insert_action(obj/screen/action, index)
	if(action in actions)
		if(actions[index] == action)
			return
		actions -= action // Don't dupe, come on
	if(!index)
		index = length(actions) + 1
	index = min(length(actions) + 1, index)
	actions.Insert(index, action)
	refresh_actions()

/datum/action_group/proc/remove_action(obj/screen/action)
	actions -= action
	refresh_actions()

/datum/action_group/proc/refresh_actions()

	// We don't use size() here because landings are not canon
	var/total_rows = ROUND_UP(length(actions) / column_max)
	total_rows -= max_rows // Lets get the amount of rows we're off from our max
	row_offset = clamp(row_offset, 0, total_rows) // You're not allowed to offset so far that we have a row of blank space

	var/visible_buttons = 0
	for(var/button_number in 1 to length(actions))
		var/obj/screen/button = actions[button_number]
		var/postion = ButtonNumberToScreenCoords(button_number - 1)
		button.screen_loc = postion
		if(postion)
			visible_buttons++

	if(landing)
		var/postion = ButtonNumberToScreenCoords(visible_buttons, landing = TRUE) // Need a good way to count buttons off screen, but allow this to display in the right place if it's being placed with no concern for dropdown
		landing.screen_loc = postion
		visible_buttons++

/// Accepts a number represeting our position in the group, indexes at 0 to make the math nicer
/datum/action_group/proc/ButtonNumberToScreenCoords(number, landing = FALSE)
	var/row = round(number / column_max)
	row -= row_offset // If you're less then 0, you don't get to render, this lets us "scroll" rows ya feel?
	if(row > max_rows - 1 || row < 0)
		return null

	row += north_offset
	var/column = number % column_max

	var/coord_col = "+[column]"
	var/coord_col_offset = 4 + 2 * (column + 1)

	var/coord_row = row ? "-[row]" : "+0"

	return "WEST[coord_col]:[coord_col_offset],NORTH[coord_row]:-[pixel_north_offset]"

/datum/action_group/proc/check_against_view()
	var/owner_view = owner?.mymob?.client?.view
	if(!owner_view)
		return
	// Unlikey as it is, we may have been changed. Want to start from our target position and fail down
	column_max = initial(column_max)
	// Convert our viewer's view var into a workable offset
	var/list/view_size = view_to_pixels(owner_view)

	// We're primarially concerned about width here, if someone makes us 1x2000 I wish them a swift and watery death
	var/furthest_screen_loc = ButtonNumberToScreenCoords(column_max - 1)
	var/list/offsets = screen_loc_to_offset(furthest_screen_loc, owner_view)
	if(offsets[1] > world.icon_size && offsets[1] < view_size[1] && offsets[2] > world.icon_size && offsets[2] < view_size[2]) // We're all good
		return

	for(column_max in column_max - 1 to 1 step -1) // Yes I could do this by unwrapping ButtonNumberToScreenCoords, but I don't feel like it
		var/tested_screen_loc = ButtonNumberToScreenCoords(column_max)
		offsets = screen_loc_to_offset(tested_screen_loc, owner_view)
		// We've found a valid max length, pack it in
		if(offsets[1] > world.icon_size && offsets[1] < view_size[1] && offsets[2] > world.icon_size && offsets[2] < view_size[2])
			break
	// Use our newly resized column max
	refresh_actions()

/// Returns the amount of objects we're storing at the moment
/datum/action_group/proc/size()
	var/amount = length(actions)
	if(landing)
		amount += 1
	return amount

/datum/action_group/proc/index_of(obj/screen/get_location)
	return actions.Find(get_location)

/// Generates a landing object that can be dropped on to join this group
/datum/action_group/proc/generate_landing()
	if(landing)
		return
	landing = new()
	landing.set_owner(src)
	refresh_actions()

/// Clears any landing objects we may currently have
/datum/action_group/proc/clear_landing()
	QDEL_NULL(landing)

/datum/action_group/proc/update_landing()
	if(!landing)
		return
	landing.update_style()

/datum/action_group/proc/scroll(amount)
	row_offset += amount
	refresh_actions()

/datum/action_group/palette
	north_offset = 2
	pixel_north_offset = 20
	column_max = 3
	max_rows = 3
	location = SCRN_OBJ_IN_PALETTE

/datum/action_group/palette/refresh_actions()
	var/obj/screen/button_palette/palette = owner.toggle_palette
	var/obj/screen/palette_scroll/scroll_down = owner.palette_down
	var/obj/screen/palette_scroll/scroll_up = owner.palette_up

	var/actions_above = round((owner.listed_actions.size() - 1) / owner.listed_actions.column_max)
	north_offset = initial(north_offset) + actions_above

	palette.screen_loc = ui_action_palette_offset(actions_above)
	var/action_count = length(owner?.mymob?.actions)
	var/our_row_count = round((length(actions) - 1) / column_max)
	if(!action_count)
		palette.screen_loc = null

	if(palette.expanded && action_count && our_row_count >= max_rows)
		scroll_down.screen_loc = ui_palette_scroll_offset(actions_above)
		scroll_up.screen_loc = ui_palette_scroll_offset(actions_above)
	else
		scroll_down.screen_loc = null
		scroll_up.screen_loc = null

	return ..()

/datum/action_group/palette/ButtonNumberToScreenCoords(number, landing)
	var/obj/screen/button_palette/palette = owner.toggle_palette
	if(!palette.expanded && !landing)
		return null
	return ..()

/datum/action_group/listed
	pixel_north_offset = 6
	column_max = 10
	location = SCRN_OBJ_IN_LIST

/datum/action_group/listed/refresh_actions()
	. = ..()
	owner.palette_actions.refresh_actions() // We effect them, so we gotta refresh em

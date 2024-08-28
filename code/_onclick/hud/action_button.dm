/obj/screen/movable/action_button
	var/datum/action/linked_action
	var/datum/hud/our_hud
	var/actiontooltipstyle = ""
	screen_loc = null

	var/button_icon_state
	var/appearance_cache

	/// Where we are currently placed on the hud. SCRN_OBJ_DEFAULT asks the linked action what it thinks
	var/location = SCRN_OBJ_DEFAULT
	/// A unique bitflag, combined with the name of our linked action this lets us persistently remember any user changes to our position
	var/id

	/// A weakref of the last thing we hovered over
	/// God I hate how dragging works
	var/datum/weakref/last_hovered_ref

/obj/screen/movable/action_button/Destroy()
	var/mob/viewer = our_hud.mymob
	our_hud.hide_action(src)
	viewer?.client?.screen -= src
	linked_action.viewers -= our_hud
	viewer.update_action_buttons()
	return ..()

/obj/screen/movable/action_button/proc/can_use(mob/user)
	if(linked_action)
		if(linked_action.viewers[user.hud_used])
			return TRUE
		return FALSE
	else if (isobserver(user))
		var/mob/dead/observer/O = user
		return !O.observetarget
	else
		return TRUE

/obj/screen/movable/action_button/Click(location,control,params)
	if(!can_use(usr))
		return

	var/list/modifiers = params2list(params)
	if(modifiers["shift"])
		var/datum/hud/our_hud = usr.hud_used
		our_hud.position_action(src, SCRN_OBJ_DEFAULT)
		return TRUE
	if(usr.next_click >= world.time)
		return
	linked_action.Trigger()
	return TRUE

// Entered and Exited won't fire while you're dragging something, because you're still "holding" it
// Very much byond logic, but I want nice behavior, so we fake it with drag
/obj/screen/movable/action_button/MouseDrag(atom/over_object, src_location, over_location, src_control, over_control, params)
	. = ..()
	if(!can_use(usr))
		return
	if(IS_WEAKREF_OF(over_object, last_hovered_ref))
		return
	var/atom/old_object
	if(last_hovered_ref)
		old_object = last_hovered_ref?.resolve()
	else // If there's no current ref, we assume it was us. We also treat this as our "first go" location
		old_object = src
		var/datum/hud/our_hud = usr.hud_used
		our_hud?.generate_landings(src)

	if(old_object)
		old_object.MouseExited(over_location, over_control, params)

	last_hovered_ref = WEAKREF(over_object)
	over_object.MouseEntered(over_location, over_control, params)

/obj/screen/movable/action_button/MouseEntered(location,control,params)
	if(!QDELETED(src))
		openToolTip(usr,src,params,title = name,content = desc)

/obj/screen/movable/action_button/MouseExited()
	closeToolTip(usr)

/obj/screen/movable/action_button/MouseDrop(over_object)
	last_hovored_ref = null
	if(!can_use(usr))
		return
	var/datum/hud/our_hud = usr.hud_used
	if(over_object == src)
		our_hud.hide_landings()
		return
	if(istype(over_object, /obj/screen/action_landing))
		var/obj/screen/action_landing/reserve = over_object
		reserve.hit_by(src)
		our_hud.hide_landings()
		save_position()
		return

	our_hud.hide_landings()
	if(istype(over_object, /obj/screen/button_palette))
		our_hud.position_action(src, SCRN_OBJ_IN_PALETTE)
		save_position()
		return
	if(istype(over_object, /obj/screen/movable/action_button))
		var/obj/screen/movable/action_button/button = over_object
		our_hud.position_action_relative(src, button)
		save_position()
		return
	. = ..()
	our_hud.position_action(src, screen_loc)
	save_position()

/obj/screen/movable/action_button/proc/save_position()
	var/mob/user = our_hud.mymob
	if(!user?.client)
		return
	var/position_info = ""
	switch(location)
		if(SCRN_OBJ_FLOATING)
			position_info = screen_loc
		if(SCRN_OBJ_IN_LIST)
			position_info = SCRN_OBJ_IN_LIST
		if(SCRN_OBJ_IN_PALETTE)
			position_info = SCRN_OBJ_IN_PALETTE

	user.client.prefs.action_buttons_screen_locs["[name]_[id]"] = position_info

/obj/screen/movable/action_button/proc/load_position()
	var/mob/user = our_hud.mymob
	if(!user)
		return
	var/position_info = user.client?.prefs?.action_buttons_screen_locs["[name]_[id]"] || SCRN_OBJ_DEFAULT
	user.hud_used.position_action(src, position_info)

/obj/screen/movable/action_button/proc/dump_save()
	var/mob/user = our_hud.mymob
	if(!user?.client)
		return
	user.client.prefs.action_buttons_screen_locs -= "[name]_[id]"

/**
 * This is a silly proc used in hud code code to determine what icon and icon state we should be using
 * for hud elements (such as action buttons) that don't have their own icon and icon state set.
 *
 * It returns a list, which is pretty much just a struct of info
 */
/datum/hud/proc/get_action_buttons_icons()
	. = list()
	.["bg_icon"] = ui_style2icon(mymob.client?.prefs.UI_style)
	.["bg_state"] = "template"
	.["bg_state_active"] = "template_active"

/**
 * Updates all action buttons this mob has.
 *
 * Arguments:
 * * update_flags - Which flags of the action should we update
 * * force - Force buttons update even if the given button icon state has not changed
 */
/mob/proc/update_action_buttons_icon(status_only = FALSE)
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtons(status_only)

//This is the proc used to update all the action buttons.
/mob/proc/update_action_buttons(reload_screen = FALSE)
	if(!hud_used || !client)
		return

	for(var/datum/action/action as anything in actions)
		var/obj/screen/movable/action_button/button = action.viewers[hud_used]
		action.UpdateButtons()
		if(reload_screen)
			client.screen += button

	hud_used.palette_actions.refresh_actions()

	if(reload_screen)
		client.screen += hud_used.toggle_palette
		client.screen += hud_used.palette_down
		client.screen += hud_used.palette_up

/obj/screen/button_palette
	name = "Show Palette"
	desc = "<b>Drag</b> buttons to move them<br><b>Shift-click</b> any button to reset it<br><b>Alt-click</b> this to reset all buttons"
	icon = 'icons/mob/screen/64x16_actions.dmi'
	icon_state = "expand"
	screen_loc = ui_action_palette
	var/datum/hud/our_hud
	var/expanded = FALSE

/obj/screen/button_palette/Destroy()
	if(our_hud)
		our_hud.mymob?.client?.screen -= src
		our_hud.toggle_palette = null
		our_hud = null
	return ..()

/obj/screen/button_palette/MouseEntered(location, control, params)
	. = ..()
	if(QDELETED(src))
		return
	show_tooltip(params)

/obj/screen/button_palette/MouseExited()
	closeToolTip(usr)
	return ..()

/obj/screen/button_palette/proc/show_tooltip(params)
	openToolTip(usr, src, params, title = name, content = desc)

/obj/screen/button_palette/proc/can_use(mob/user)
	if (isobserver(user))
		var/mob/dead/observer/O = user
		return !O.observetarget
	return TRUE

/obj/screen/button_palette/Click(location, control, params)
	if(!can_use(usr))
		return

	var/list/modifiers = params2list(params)

	if(LAZYACCESS(modifiers, ALT_CLICK))
		for(var/datum/action/action as anything in usr.actions) // Reset action positions to default
			for(var/datum/hud/hud as anything in action.viewers)
				var/obj/screen/movable/action_button/button = action.viewers[hud]
				hud.position_action(button, SCRN_OBJ_DEFAULT)
		to_chat(usr, SPAN_NOTICE("Action button positions have been reset."))
		return TRUE

	set_expanded(!expanded)

	if(!usr.client)
		return

	if(expanded)
		RegisterSignal(usr.client, COMSIG_CLIENT_CLICK, .proc/clicked_while_open)
	else
		UnregisterSignal(usr.client, COMSIG_CLIENT_CLICK)

/obj/screen/button_palette/proc/clicked_while_open(datum/source, atom/target, atom/location, control, params, mob/user)
	if(istype(target, /obj/screen/movable/action_button) || istype(target, /obj/screen/palette_scroll) || target == src) // If you're clicking on an action button, or us, you can live
		return
	set_expanded(FALSE)
	if(source)
		UnregisterSignal(source, COMSIG_CLIENT_CLICK)

/obj/screen/button_palette/proc/set_expanded(new_expanded)
	expanded = new_expanded
	our_hud.palette_actions.refresh_actions()
	closeToolTip(usr) //Our tooltips are now invalid, can't seem to update them in one frame, so here, just close them

/obj/screen/palette_scroll
	icon = 	icon = 'icons/mob/screen/64x16_actions.dmi'
	screen_loc = ui_palette_scroll
	/// How should we move the palette's actions?
	/// Positive scrolls down the list, negative scrolls back
	var/scroll_direction = 0
	var/datum/hud/our_hud

/obj/screen/palette_scroll/proc/can_use(mob/user)
	if (isobserver(user))
		var/mob/dead/observer/O = user
		return !O.observetarget
	return TRUE

/obj/screen/palette_scroll/Click(location, control, params)
	if(!can_use(usr))
		return
	our_hud.palette_actions.scroll(scroll_direction)

/obj/screen/palette_scroll/MouseEntered(location, control, params)
	. = ..()
	if(QDELETED(src))
		return
	openToolTip(usr, src, params, title = name, content = desc)

/obj/screen/palette_scroll/MouseExited()
	closeToolTip(usr)
	return ..()

/obj/screen/palette_scroll/down
	name = "Scroll Down"
	desc = "<b>Click</b> on this to scroll the actions above down"
	icon_state = "down"
	scroll_direction = 1

/obj/screen/button_palette/down/Destroy()
	if(our_hud)
		our_hud.mymob?.client?.screen -= src
		our_hud.palette_down = null
		our_hud = null
	return ..()

/obj/screen/palette_scroll/up
	name = "Scroll Up"
	desc = "<b>Click</b> on this to scroll the actions above up"
	icon_state = "up"
	scroll_direction = -1

/obj/screen/button_palette/up/Destroy()
	if(our_hud)
		our_hud.mymob?.client?.screen -= src
		our_hud.palette_up = null
		our_hud = null
	return ..()

/// Exists so you have a place to put your buttons when you move them around
/obj/screen/action_landing
	name = "Button Space"
	desc = "<b>Drag and drop</b> a button into this spot<br>to add it to the group"
	icon = 'icons/mob/screen/screen_gen.dmi'
	icon_state = "reserved"
	// We want our whole 32x32 space to be clickable, so dropping's forgiving
	mouse_opacity = MOUSE_OPACITY_OPAQUE
	var/datum/action_group/owner

/obj/screen/action_landing/Destroy()
	owner.landing = null
	owner?.owner?.mymob?.client?.screen -= src
	owner.refresh_actions()
	owner = null
	return ..()

/obj/screen/action_landing/proc/set_owner(datum/action_group/owner)
	var/datum/hud/our_hud = owner.owner
	var/mob/viewer = our_hud.mymob

	if(viewer.client)
		viewer.client.screen += src
	src.owner = owner
	update_style()

/obj/screen/action_landing/proc/update_style()
	var/datum/hud/our_hud = owner.owner
	var/list/settings = our_hud.get_action_buttons_icons()
	icon = settings["bg_icon"]

/// Reacts to having a button dropped on it
/obj/screen/action_landing/proc/hit_by(obj/screen/movable/action_button/button)
	var/datum/hud/our_hud = owner.owner
	our_hud.position_action(button, owner.location)

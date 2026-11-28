/// Owns client cursor selection. State changes are delivered as signals, never polled.
SUBSYSTEM_DEF(cursor)
	name = "Cursor States"
	flags = SS_NO_INIT | SS_NO_FIRE

/datum/controller/subsystem/cursor/Recover()
	for(var/client/player in GLOB.clients)
		SScursor.unregister_client(player)
		register_client(player)

/// Called before the first LateLogin, including the external authentication path.
/datum/controller/subsystem/cursor/proc/register_client(client/player)
	RegisterSignal(player, COMSIG_CLIENT_CURSOR_UPDATE, PROC_REF(on_cursor_update))
	RegisterSignal(player, COMSIG_CLIENT_MOUSEDOWN, PROC_REF(on_mouse_down))
	RegisterSignal(player, COMSIG_CLIENT_MOUSEUP, PROC_REF(on_mouse_up))
	RegisterSignal(player, COMSIG_CLIENT_CURSOR_SHIFT, PROC_REF(on_shift))
	RegisterSignal(player, COMSIG_CLIENT_CURSOR_DRAG, PROC_REF(on_drag))
	update_cursor(player)

/datum/controller/subsystem/cursor/proc/unregister_client(client/player)
	UnregisterSignal(player, list(COMSIG_CLIENT_CURSOR_UPDATE, COMSIG_CLIENT_MOUSEDOWN, COMSIG_CLIENT_MOUSEUP, COMSIG_CLIENT_CURSOR_SHIFT, COMSIG_CLIENT_CURSOR_DRAG))

/datum/controller/subsystem/cursor/proc/on_cursor_update(client/source)
	SIGNAL_HANDLER
	update_cursor(source)

/datum/controller/subsystem/cursor/proc/on_mouse_down(client/source)
	SIGNAL_HANDLER
	source.cursor_mouse_held = TRUE
	update_cursor(source)

/datum/controller/subsystem/cursor/proc/on_mouse_up(client/source)
	SIGNAL_HANDLER
	source.cursor_mouse_held = FALSE
	source.cursor_dragging = FALSE
	update_cursor(source)

/datum/controller/subsystem/cursor/proc/on_drag(client/source, dragging)
	SIGNAL_HANDLER
	source.cursor_dragging = dragging
	if(!dragging)
		source.cursor_mouse_held = FALSE
	update_cursor(source)

/datum/controller/subsystem/cursor/proc/on_shift(client/source, held)
	SIGNAL_HANDLER
	source.cursor_shift_held = held
	update_cursor(source)

/// Shift takes precedence over the cursor for the current mob and mouse state.
/datum/controller/subsystem/cursor/proc/get_cursor_icon(client/player)
	if(player.cursor_shift_held)
		return 'icons/hud/cursor/examine.dmi'
	if(player.cursor_dragging)
		return 'icons/hud/cursor/drag.dmi'
	var/mob/user = player.mob
	if(user && !user.in_throw_mode && istype(user.get_active_hand(), /obj/item/gun))
		return 'icons/hud/cursor/crosshair.dmi'
	if(player.cursor_mouse_held)
		return 'icons/hud/cursor/click.dmi'
	if(user?.in_throw_mode)
		return 'icons/hud/cursor/throw.dmi'
	return 'icons/hud/cursor/default.dmi'

/datum/controller/subsystem/cursor/proc/update_cursor(client/player)
	var/cursor_icon = get_cursor_icon(player)
	if(player.mouse_pointer_icon != cursor_icon)
		player.mouse_pointer_icon = cursor_icon

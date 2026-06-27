/**
 * A screen object, which acts as a container for turfs and other things
 * you want to show on the map, which you usually attach to "vis_contents".
 * Additionally manages the plane masters required to display said container contents.
 */
INITIALIZE_IMMEDIATE(/atom/movable/screen/map_view)
/atom/movable/screen/map_view
	name = "screen"
	// Map view has to be on the lowest plane to enable proper lighting.
	layer = GAME_PLANE
	plane = GAME_PLANE
	del_on_map_removal = FALSE

	// Weakrefs of all our client viewers -> a weakref to the HUD datum they last used.
	var/list/datum/weakref/viewers_to_huds = list()

/atom/movable/screen/map_view/Destroy()
	for(var/datum/weakref/client_ref as anything in viewers_to_huds.Copy())
		hide_from_client(client_ref.resolve())

	return ..()

/atom/movable/screen/map_view/proc/generate_view(map_key)
	// Map keys have to start and end with an A-Z character,
	// and definitely not with a square bracket or number.
	assigned_map = map_key
	set_position(1, 1)

/**
 * Generates and displays the map view to a client.
 *
 * If you need the view in TGUI, pass the tgui window so display waits until
 * the BYOND map control is visible.
 */
/atom/movable/screen/map_view/proc/display_to(mob/show_to, datum/tgui_window/window)
	if(window && !window.visible)
		RegisterSignal(window, COMSIG_TGUI_WINDOW_VISIBLE, PROC_REF(display_on_ui_visible))
	else
		display_to_client(show_to?.client)

/atom/movable/screen/map_view/proc/display_on_ui_visible(datum/tgui_window/window, client/show_to)
	SIGNAL_HANDLER
	display_to_client(show_to)
	UnregisterSignal(window, COMSIG_TGUI_WINDOW_VISIBLE)

/atom/movable/screen/map_view/proc/display_to_client(client/show_to)
	if(!show_to?.mob?.hud_used)
		return

	show_to.register_map_obj(src)
	// Plane masters on the main screen do not apply to popup map controls.
	// Allocate a popup group lazily so blending, render targets, and relays are local to this submap.
	var/datum/weakref/client_ref = WEAKREF(show_to)
	var/datum/weakref/hud_ref = viewers_to_huds[client_ref]
	var/datum/hud/our_hud = hud_ref?.resolve()
	if(our_hud)
		return our_hud.get_plane_group(PLANE_GROUP_POPUP_WINDOW(src))

	var/datum/plane_master_group/popup/pop_planes = new(PLANE_GROUP_POPUP_WINDOW(src), assigned_map)
	viewers_to_huds[client_ref] = WEAKREF(show_to.mob.hud_used)
	pop_planes.attach_to(show_to.mob.hud_used)

	return pop_planes

/atom/movable/screen/map_view/proc/hide_from(mob/hide_from)
	hide_from_client(hide_from?.canon_client)

/atom/movable/screen/map_view/proc/hide_from_client(client/hide_from)
	if(!hide_from)
		return

	hide_from.clear_map(assigned_map)

	var/datum/weakref/client_ref = WEAKREF(hide_from)
	var/datum/weakref/hud_ref = viewers_to_huds[client_ref]
	viewers_to_huds -= client_ref

	var/datum/hud/clear_from = hud_ref?.resolve()
	if(!clear_from)
		return

	var/datum/plane_master_group/popup/pop_planes = clear_from.get_plane_group(PLANE_GROUP_POPUP_WINDOW(src))
	qdel(pop_planes)

// Each occupied mob layer has one off-screen pass shared by all mobs on that layer.
// The masked output returns to GAME_PLANE as a world image at the original layer.
// Screen relays cannot be used here: HUD subplanes sort above world objects.
GLOBAL_LIST_INIT(vision_cone_layers, list())
GLOBAL_LIST_INIT(vision_cone_planes, list())

/datum/vision_cone_layer
	var/source_plane
	var/target_layer
	var/users = 0

/datum/vision_cone_layer/New(new_plane, new_layer)
	..()
	source_plane = new_plane
	target_layer = new_layer

/proc/get_vision_cone_layer(target_layer)
	var/datum/vision_cone_layer/existing = GLOB.vision_cone_layers["[target_layer]"]
	if(existing)
		return existing
	for(var/source_plane in FOV_MOB_PLANE_START to FOV_MOB_PLANE_END)
		if(GLOB.vision_cone_planes["[source_plane]"])
			continue
		var/datum/vision_cone_layer/created = new(source_plane, target_layer)
		GLOB.vision_cone_layers["[target_layer]"] = created
		GLOB.vision_cone_planes["[source_plane]"] = created
		for(var/client/viewer in GLOB.clients)
			viewer.mob?.hud_used?.add_vision_cone_layer(created)
		return created
	CRASH("Ran out of vision-cone planes for mob layer [target_layer].")

/datum/vision_cone_layer/proc/release()
	if(--users)
		return
	for(var/client/viewer in GLOB.clients)
		viewer.mob?.hud_used?.remove_vision_cone_layer(src)
	GLOB.vision_cone_layers -= "[target_layer]"
	GLOB.vision_cone_planes -= "[source_plane]"
	qdel(src)

/mob/living
	// Keep body and equipment together when relaying them at the mob's layer.
	appearance_flags = DEFAULT_APPEARANCE_FLAGS | TILE_BOUND | LONG_GLIDE | KEEP_TOGETHER
	var/datum/vision_cone_layer/vision_cone_layer

/// The visible plane, after any off-screen mob pass has been composited.
/atom/proc/get_render_plane()
	return plane

/mob/living/get_render_plane()
	return vision_cone_layer && plane == vision_cone_layer.source_plane ? GAME_PLANE : plane

/// Disguises must copy the visible plane without borrowing another mob's pass or render target.
/mob/living/proc/copy_visual_appearance(atom/source)
	var/own_render_target = render_target
	appearance = source.appearance
	render_target = own_render_target
	plane = source.get_render_plane()
	appearance_flags |= KEEP_TOGETHER
	update_vision_cone_plane()

/// Use this setter for runtime layer changes, including grabs, buckling and hiding.
/atom/proc/set_layer(new_layer)
	layer = new_layer

/mob/living/set_layer(new_layer)
	. = ..()
	update_vision_cone_plane()

/mob/living/proc/update_vision_cone_plane()
	if(QDELETED(src))
		return
	if(vision_cone_layer && plane == vision_cone_layer.source_plane && layer == vision_cone_layer.target_layer)
		return
	// Explicit non-game planes (e.g. inventory/preview appearances) remain independent.
	var/on_game_plane = plane == GAME_PLANE || (vision_cone_layer && plane == vision_cone_layer.source_plane)
	if(vision_cone_layer)
		vision_cone_layer.release()
		vision_cone_layer = null
	if(!on_game_plane)
		return
	if(layer < 0)
		plane = GAME_PLANE
		return
	vision_cone_layer = get_vision_cone_layer(layer)
	vision_cone_layer.users++
	plane = vision_cone_layer.source_plane
	UPDATE_OO_IF_PRESENT

/atom/movable/screen/plane_master/vision_cone_mobs
	name = "vision cone mob layer"
	appearance_flags = PLANE_MASTER | NO_CLIENT_COLOR
	render_relay_plane = null
	var/image/world_relay

/atom/movable/screen/plane_master/vision_cone_mobs/Initialize(mapload, datum/vision_cone_layer/group)
	. = ..()
	plane = group.source_plane
	render_target = "*fov_mobs_[plane]"
	add_filter("vision_cone", 1, alpha_mask_filter(render_source = FIELD_OF_VISION_BLOCKER_RENDER_TARGET, flags = MASK_INVERSE))
	world_relay = new
	world_relay.plane = GAME_PLANE
	world_relay.layer = group.target_layer
	world_relay.render_source = render_target
	world_relay.appearance_flags = DEFAULT_APPEARANCE_FLAGS | PASS_MOUSE | KEEP_TOGETHER | RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM

/atom/movable/screen/plane_master/vision_cone_mobs/Destroy()
	QDEL_NULL(world_relay)
	return ..()

/datum/hud/proc/add_vision_cone_layer(datum/vision_cone_layer/group)
	if(fov_planes["[group.source_plane]"])
		return
	var/atom/movable/screen/plane_master/vision_cone_mobs/pass = new(null, group)
	fov_planes["[group.source_plane]"] = pass
	update_vision_cone_relays()

/datum/hud/proc/remove_vision_cone_layer(datum/vision_cone_layer/group)
	var/atom/movable/screen/plane_master/vision_cone_mobs/pass = fov_planes["[group.source_plane]"]
	if(!pass)
		return
	mymob?.client?.screen -= pass
	mymob?.client?.images -= pass.world_relay
	fov_planes -= "[group.source_plane]"
	qdel(pass)

/// Keep a separate world anchor so leaning, floating and attack animations on the eye
/// cannot displace the entire mob pass. Only the eye and its containers are followed.
/atom/movable/vision_cone_relay_anchor
	name = "vision cone relay anchor"
	anchored = TRUE
	simulated = FALSE
	z_flags = ZMM_IGNORE
	invisibility = INVISIBILITY_ABSTRACT
	// Images inherit mouse suppression from their anchor, even with PASS_MOUSE.
	mouse_opacity = MOUSE_OPACITY_ICON
	animate_movement = 2

/client/proc/set_eye(atom/new_eye, new_perspective)
	eye = new_eye
	if(!isnull(new_perspective))
		perspective = new_perspective
	mob?.update_vision_cone()

/client/proc/set_view_size(new_view)
	view = new_view
	mob?.update_vision_cone()

/client/proc/set_view_offset(new_x, new_y)
	pixel_x = new_x
	pixel_y = new_y
	mob?.update_vision_cone()

/datum/hud/proc/update_vision_cone_relays()
	var/client/viewer = mymob?.client
	if(!viewer)
		return
	if(!fov_anchor)
		fov_anchor = new
	var/atom/eye = viewer.eye || mymob
	var/list/eye_containers = list()
	var/atom/container = eye
	var/atom/movable/moving_eye
	while(ismovable(container) && !QDELETED(container))
		eye_containers += container
		moving_eye = container
		container = container.loc
	for(var/atom/old_container as anything in fov_eye_containers)
		if(!(old_container in eye_containers))
			UnregisterSignal(old_container, list(COMSIG_MOVABLE_MOVED, COMSIG_QDELETING))
	for(var/atom/new_container as anything in eye_containers)
		if(!(new_container in fov_eye_containers))
			RegisterSignal(new_container, COMSIG_MOVABLE_MOVED, PROC_REF(on_vision_cone_eye_moved))
			RegisterSignal(new_container, COMSIG_QDELETING, PROC_REF(on_vision_cone_eye_deleted))
	fov_eye_containers = eye_containers
	fov_anchor.glide_size = viewer.glide_size || moving_eye?.glide_size || 0
	var/turf/eye_turf = get_turf(eye)
	if(fov_anchor.loc != eye_turf)
		if(eye_turf)
			fov_anchor.forceMove(eye_turf)
		else
			fov_anchor.moveToNullspace()
	var/list/view_size = getviewsize(viewer.view)
	var/offset_x = -round((view_size[1] - 1) / 2) * world.icon_size + viewer.pixel_x
	var/offset_y = -round((view_size[2] - 1) / 2) * world.icon_size + viewer.pixel_y
	for(var/key in fov_planes)
		var/atom/movable/screen/plane_master/vision_cone_mobs/pass = fov_planes[key]
		pass.world_relay.loc = fov_anchor
		pass.world_relay.pixel_x = offset_x
		pass.world_relay.pixel_y = offset_y
		viewer.screen |= pass
		viewer.images |= pass.world_relay

/datum/hud/proc/on_vision_cone_eye_moved()
	SIGNAL_HANDLER
	update_vision_cone_relays()

/datum/hud/proc/on_vision_cone_eye_deleted(atom/source)
	SIGNAL_HANDLER
	UnregisterSignal(source, list(COMSIG_MOVABLE_MOVED, COMSIG_QDELETING))
	fov_eye_containers -= source
	if(!QDELETED(mymob) && mymob.client?.eye == source && source != mymob)
		mymob.client.set_eye(mymob, MOB_PERSPECTIVE)

/datum/hud/proc/clear_vision_cone_rendering()
	for(var/atom/container as anything in fov_eye_containers)
		UnregisterSignal(container, list(COMSIG_MOVABLE_MOVED, COMSIG_QDELETING))
	fov_eye_containers.Cut()
	QDEL_NULL(fov_anchor)
	clear_vision_cone_exemptions()
	for(var/key in fov_planes)
		var/atom/movable/screen/plane_master/vision_cone_mobs/pass = fov_planes[key]
		mymob?.client?.screen -= pass
		mymob?.client?.images -= pass.world_relay
	QDEL_LIST_ASSOC_VAL(fov_planes)

/// Live silhouettes clear the blocker over ourselves and the mob we are pulling.
/// Their render targets include equipment and animations; no appearance copies are kept.
/datum/hud/proc/update_vision_cone_exemptions(list/exempt_mobs)
	for(var/mob/living/old_mob as anything in fov_exemptions)
		if(!(old_mob in exempt_mobs))
			remove_vision_cone_exemption(old_mob)
	for(var/mob/living/exempt_mob as anything in exempt_mobs)
		var/image/exemption = fov_exemptions[exempt_mob]
		if(!exemption)
			exemption = image(loc = exempt_mob)
			exemption.plane = FOV_EXEMPT_PLANE
			exemption.appearance_flags = DEFAULT_APPEARANCE_FLAGS | KEEP_APART | RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM
			fov_exemptions[exempt_mob] = exemption
			RegisterSignal(exempt_mob, COMSIG_QDELETING, PROC_REF(remove_vision_cone_exemption))
		if(!exempt_mob.render_target)
			exempt_mob.render_target = REF(exempt_mob)
		exemption.render_source = exempt_mob.render_target
		mymob.client.images |= exemption

/datum/hud/proc/remove_vision_cone_exemption(mob/living/exempt_mob)
	var/image/exemption = fov_exemptions[exempt_mob]
	if(!exemption)
		return
	UnregisterSignal(exempt_mob, COMSIG_QDELETING)
	mymob?.client?.images -= exemption
	fov_exemptions -= exempt_mob
	qdel(exemption)

/datum/hud/proc/clear_vision_cone_exemptions()
	for(var/mob/living/exempt_mob as anything in fov_exemptions)
		remove_vision_cone_exemption(exempt_mob)

/// List of z pillars that control turf transparency in blocks of space.
GLOBAL_LIST_EMPTY(pillars_by_z)

#define Z_PILLAR_RADIUS 20
#define Z_PILLAR_TRANSFORM(pos) (ROUND_UP(pos / Z_PILLAR_RADIUS))
#define Z_KEY_TO_POSITION(key) (((key - 1) * Z_PILLAR_RADIUS) + 1)

/// Returns a z pillar to insert transparent turfs into.
/proc/request_z_pillar(x, y, z)
	var/list/pillars_by_z = GLOB.pillars_by_z
	if(length(pillars_by_z) < z)
		pillars_by_z.len = z
	var/list/our_z = pillars_by_z[z]
	if(!our_z)
		our_z = list()
		pillars_by_z[z] = our_z

	var/x_key = Z_PILLAR_TRANSFORM(x)
	if(length(our_z) < x_key)
		our_z.len = x_key
	var/list/our_x = our_z[x_key]
	if(!our_x)
		our_x = list()
		our_z[x_key] = our_x

	var/y_key = Z_PILLAR_TRANSFORM(y)
	if(length(our_x) < y_key)
		our_x.len = y_key
	var/datum/z_pillar/our_pillar = our_x[y_key]
	if(!our_pillar)
		our_pillar = new(x_key, y_key, z)
		our_x[y_key] = our_pillar
	return our_pillar

/// Holds a lower turf's vis_contents under a nontransparent turf above it.
/obj/effect/abstract/z_holder
	appearance_flags = PIXEL_SCALE
	plane = HUD_PLANE
	anchored = TRUE
	simulated = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/datum/z_pillar/pillar
	var/turf/show_for

/obj/effect/abstract/z_holder/Destroy()
	if(pillar)
		pillar.drawing_object -= show_for
		pillar = null
	show_for = null
	return ..()

/obj/effect/abstract/z_holder/proc/display(turf/display, datum/z_pillar/behalf_of)
	if(pillar)
		CRASH("Attempted to reuse an occupied z holder.")

	pillar = behalf_of
	show_for = display
	vis_contents += display
	behalf_of.drawing_object[display] = src

/// Grouping datum that manages transparency for a block of space.
/datum/z_pillar
	var/x_pos
	var/y_pos
	var/z_pos
	/// Assoc list in the form displayed turf -> list of transparent turf sources.
	var/list/turf_sources = list()
	/// Assoc list in the form displayed turf -> z holder.
	var/list/drawing_object = list()

/datum/z_pillar/New(x_pos, y_pos, z_pos)
	. = ..()
	src.x_pos = x_pos
	src.y_pos = y_pos
	src.z_pos = z_pos

/datum/z_pillar/Destroy()
	GLOB.pillars_by_z[z_pos][x_pos][y_pos] = null
	for(var/turf/displaying as anything in turf_sources)
		for(var/turf/displaying_for as anything in turf_sources[displaying])
			hide_turf(displaying, displaying_for)
	return ..()

/// Displays a turf from the z level below us on our level.
/datum/z_pillar/proc/display_turf(turf/to_display, turf/source)
	var/list/sources = turf_sources[to_display]

	if(sources)
		sources |= source
		var/obj/effect/abstract/z_holder/holding = drawing_object[to_display]
		if(!holding)
			return

		var/turf/visual_target = GET_TURF_ABOVE(to_display)
		if(!istransparentturf(visual_target))
			return

		holding.vis_contents -= to_display
		qdel(holding)
		drawing_object -= to_display
		visual_target.vis_contents += to_display
		return

	sources = list()
	turf_sources[to_display] = sources
	sources |= source

	var/turf/visual_target = GET_TURF_ABOVE(to_display)
	if(istransparentturf(visual_target) || isopenturf(visual_target))
		visual_target.vis_contents += to_display
	else
		var/obj/effect/abstract/z_holder/hold_this = new(visual_target)
		hold_this.display(to_display, src)

/// Hides an existing turf from vis_contents, or from the holder if applicable.
/datum/z_pillar/proc/hide_turf(turf/to_hide, turf/source)
	var/list/sources = turf_sources[to_hide]
	if(!sources)
		return
	sources -= source
	if(length(sources))
		return

	turf_sources -= to_hide
	var/obj/effect/abstract/z_holder/holding = drawing_object[to_hide]
	if(holding)
		qdel(holding)
	else
		var/turf/visual_target = GET_TURF_ABOVE(to_hide)
		visual_target.vis_contents -= to_hide

	if(!length(turf_sources) && !QDELETED(src))
		qdel(src)

/// Called when a transparent turf is cleared.
/datum/z_pillar/proc/parent_cleared(turf/visual, turf/current_holder)
	addtimer(CALLBACK(src, PROC_REF(refresh_orphan), visual, current_holder))

/// Refreshes a formerly orphaned turf after vis_loc deletion.
/datum/z_pillar/proc/refresh_orphan(turf/orphan, turf/parent)
	var/list/sources = turf_sources[orphan]
	if(!length(sources))
		return

	var/obj/effect/abstract/z_holder/holding = drawing_object[orphan]
	if(holding)
		return

	if(istransparentturf(parent) || isopenturf(parent))
		parent.vis_contents += orphan
	else
		var/obj/effect/abstract/z_holder/hold_this = new(parent)
		hold_this.display(orphan, src)

/datum/element/turf_z_transparency
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY

/// Sets up signals to update vis_contents when turfs above or below change.
/datum/element/turf_z_transparency/Attach(datum/target, mapload)
	. = ..()
	if(!isturf(target))
		return ELEMENT_INCOMPATIBLE

	var/turf/our_turf = target
	RegisterSignal(our_turf, COMSIG_TURF_MULTIZ_DEL, PROC_REF(on_multiz_turf_del))
	RegisterSignal(our_turf, COMSIG_TURF_MULTIZ_NEW, PROC_REF(on_multiz_turf_new))

	if(!mapload)
		update_multi_z(our_turf)

/datum/element/turf_z_transparency/Detach(datum/source)
	. = ..()
	var/turf/our_turf = source
	clear_multiz(our_turf)
	UnregisterSignal(our_turf, list(COMSIG_TURF_MULTIZ_NEW, COMSIG_TURF_MULTIZ_DEL))

/// Updates the vis_contents or underlays below this turf.
/datum/element/turf_z_transparency/proc/update_multi_z(turf/our_turf)
	var/turf/below_turf = GET_TURF_BELOW(our_turf)
	if(below_turf)
		for(var/turf/partner as anything in RANGE_TURFS(1, below_turf))
			var/datum/z_pillar/z_boss = request_z_pillar(partner.x, partner.y, our_turf.z)
			z_boss.display_turf(partner, our_turf)
	else
		our_turf.underlays += get_baseturf_underlay(our_turf)

	if(our_turf.density)
		for(var/mutable_appearance/underlay as anything in get_closed_turf_underlays(our_turf))
			our_turf.underlays += underlay
	return TRUE

/datum/element/turf_z_transparency/proc/clear_multiz(turf/our_turf)
	var/turf/below_turf = GET_TURF_BELOW(our_turf)
	if(below_turf)
		for(var/turf/partner as anything in RANGE_TURFS(1, below_turf))
			var/datum/z_pillar/z_boss = request_z_pillar(partner.x, partner.y, our_turf.z)
			z_boss.hide_turf(partner, our_turf)
			if(partner == below_turf)
				z_boss.parent_cleared(below_turf, our_turf)
	else
		our_turf.underlays -= get_baseturf_underlay(our_turf)

	if(our_turf.density)
		for(var/mutable_appearance/underlay as anything in get_closed_turf_underlays(our_turf))
			our_turf.underlays -= underlay

/datum/element/turf_z_transparency/proc/on_multiz_turf_del(turf/our_turf, turf/below_turf, direction)
	SIGNAL_HANDLER

	if(direction != DOWN)
		return

	update_multi_z(our_turf)

/datum/element/turf_z_transparency/proc/on_multiz_turf_new(turf/our_turf, turf/below_turf, direction)
	SIGNAL_HANDLER

	if(direction != DOWN)
		return

	update_multi_z(our_turf)

/// Called when there is no real turf below this turf.
/datum/element/turf_z_transparency/proc/get_baseturf_underlay(turf/our_turf)
	var/turf/baseturf_path = our_turf.baseturf || SSatlas.current_map.base_turf_by_z["[our_turf.z]"] || /turf/space
	if(!ispath(baseturf_path))
		baseturf_path = /turf/space

	var/mutable_appearance/underlay_appearance = mutable_appearance(initial(baseturf_path.icon), initial(baseturf_path.icon_state), layer = SPACE_LAYER + 0.1, offset_spokesman = our_turf, plane = PLANE_SPACE)
	underlay_appearance.appearance_flags = RESET_ALPHA | RESET_COLOR
	return underlay_appearance

/datum/element/turf_z_transparency/proc/get_closed_turf_underlays(turf/our_turf)
	var/mutable_appearance/girder_underlay = mutable_appearance('icons/obj/structures.dmi', "girder", layer = LATTICE_LAYER, offset_spokesman = our_turf, plane = FLOOR_PLANE)
	girder_underlay.appearance_flags = RESET_ALPHA | RESET_COLOR
	var/mutable_appearance/plating_underlay = mutable_appearance('icons/turf/flooring/plating.dmi', "plating", layer = LOW_FLOOR_LAYER, offset_spokesman = our_turf, plane = FLOOR_PLANE)
	plating_underlay.appearance_flags = RESET_ALPHA | RESET_COLOR
	return list(girder_underlay, plating_underlay)

#undef Z_PILLAR_RADIUS
#undef Z_PILLAR_TRANSFORM
#undef Z_KEY_TO_POSITION

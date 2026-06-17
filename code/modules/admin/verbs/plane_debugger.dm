/// Used for testing/debugger plane masters and their associated rendering plates
/datum/plane_master_debug
	var/datum/admins/owner
	/// Assoc list of plane master group key -> its depth stack
	var/list/depth_stack = list()
	/// The current plane master group we're viewing
	var/current_group = PLANE_GROUP_MAIN
	/// Weakref to the mob to edit
	var/datum/weakref/mob_ref
	/// Has the target been set explicitly (via VV) or implicitly (via orbit)
	/// Orbit targets will get unset whenever you stop orbiting them
	var/explicit_mirror = FALSE

	var/datum/visual_data/tracking/stored
	var/datum/visual_data/mirroring/mirror
	/// If we are actively mirroring the target of our current ui
	var/mirror_target = FALSE

/datum/plane_master_debug/New(datum/admins/owner)
	src.owner = owner

/datum/plane_master_debug/Destroy()
	if(owner)
		owner.plane_debug = null
		owner = null
	return ..()

/datum/plane_master_debug/proc/set_target(mob/new_mob, explicit = TRUE)
	QDEL_NULL(mirror)
	QDEL_NULL(stored)

	depth_stack = list()
	if(!new_mob?.hud_used)
		new_mob = owner.owner?.mob

	mob_ref = WEAKREF(new_mob)

	if(!mirror_target)
		UnregisterSignal(owner.owner.mob, COMSIG_MOB_LOGOUT)
		return

	RegisterSignal(owner.owner.mob, COMSIG_MOB_LOGOUT, PROC_REF(on_our_logout), override = TRUE)
	mirror = new()
	mirror.shadow(new_mob)
	SStgui.update_uis(owner.owner.mob)

	if(new_mob == owner.owner.mob)
		explicit_mirror = FALSE
		return

	explicit_mirror = explicit
	create_store()

/datum/plane_master_debug/proc/on_our_logout(mob/source)
	SIGNAL_HANDLER
	// Recreate our stored view, since we've changed mobs now
	create_store()
	UnregisterSignal(source, COMSIG_MOB_LOGOUT)
	RegisterSignal(owner.owner.mob, COMSIG_MOB_LOGOUT, PROC_REF(on_our_logout), override = TRUE)

/// Create or refresh our stored visual data, represeting the viewing mob
/datum/plane_master_debug/proc/create_store()
	if(stored)
		QDEL_NULL(stored)
	stored = new()
	stored.shadow(owner.owner.mob)
	stored.set_truth(mirror)
	mirror.set_mirror_target(owner.owner.mob)

/datum/plane_master_debug/proc/get_target()
	var/mob/cur_target = mob_ref?.resolve()
	var/mob/target = cur_target
	if(!target?.hud_used || !explicit_mirror)
		target = owner.owner.mob
		if (ismob(target.orbit_target)) // If we're orbiting someone, swap to them if possible
			var/mob/as_mob = target.orbit_target
			if (as_mob.hud_used)
				target = target.orbit_target
		if (cur_target != target)
			set_target(target, FALSE)
	return target

/// Setter for mirror_target, basically allows for enabling/disabiling viewing through mob's sight
/datum/plane_master_debug/proc/set_mirroring(value)
	if(value == mirror_target)
		return
	mirror_target = value
	// Refresh our target and mirrors and such, but keep explicit/implicit mirroring
	set_target(get_target(), explicit_mirror)

/datum/plane_master_debug/ui_state(mob/user)
	return GLOB.debug_state

/datum/plane_master_debug/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PlaneMasterDebug")
		ui.open()

/datum/plane_master_debug/ui_assets(mob/user)
	return list(get_asset_datum(/datum/asset/simple/plane_background))

/datum/plane_master_debug/ui_data()
	var/list/data = list()

	var/mob/reference_frame = get_target()
	data["mob_name"] = reference_frame.name
	data["mob_ref"] = ref(reference_frame)
	data["our_ref"] = ref(owner.owner.mob)
	data["tracking_active"] = mirror_target

	var/datum/hud/our_hud = reference_frame.hud_used
	var/list/our_groups = our_hud.master_groups
	if (!our_groups[current_group])
		// We assume we'll always have at least one group
		current_group = our_groups[length(our_hud.master_groups)]

	var/list/groups = list()
	for (var/key in our_groups)
		groups += key

	data["enable_group_view"] = length(groups) > 1
	data["our_group"] = current_group
	data["present_groups"] = groups

	var/list/plane_info = list()

	var/list/our_planes = our_hud?.get_planes_from(current_group)
	for (var/plane_string in our_planes)
		var/list/this_plane = list()
		var/atom/movable/screen/plane_master/plane = our_planes[plane_string]
		this_plane["name"] = plane.name
		this_plane["documentation"] = plane.documentation
		this_plane["plane"] = plane.plane
		this_plane["offset"] = plane.offset
		this_plane["real_plane"] = plane.real_plane
		this_plane["renders_onto"] = plane.render_relay_planes
		this_plane["blend_mode"] = GLOB.blend_names["[plane.blend_mode_override || initial(plane.blend_mode)]"]
		this_plane["color"] = plane.color
		this_plane["alpha"] = plane.alpha
		this_plane["render_target"] = plane.render_target
		this_plane["force_hidden"] = plane.force_hidden

		var/list/relays = list()
		var/list/filters = list()

		for (var/atom/movable/render_plane_relay/relay as anything in plane.relays)
			var/list/this_relay = list()
			this_relay["name"] = relay.name
			this_relay["source"] = plane.plane
			this_relay["target"] = relay.plane
			this_relay["layer"] = relay.layer
			this_relay["our_ref"] = "[plane.plane]-[relay.plane]"
			this_relay["blend_mode"] = GLOB.blend_names["[relay.blend_mode]"]
			relays += list(this_relay)

		for (var/filter_name in plane.filter_data)
			var/list/filter = plane.filter_data[filter_name]
			if(!islist(filter) || !filter["render_source"])
				continue

			var/list/filter_info = filter.Copy()
			filter_info["name"] = filter_name
			filter_info["our_ref"] = "[plane.plane]-[filter_name]"
			filters += list(filter_info)

		this_plane["relays"] = relays
		this_plane["filters"] = filters

		plane_info += list(this_plane)

	data["planes"] = plane_info
	return data

/datum/plane_master_debug/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/reference_frame = get_target()
	var/datum/hud/our_hud = reference_frame.hud_used
	var/datum/plane_master_group/group = our_hud?.master_groups[current_group]
	if(!group) // Nothing to act on
		return
	var/list/our_planes = group.plane_masters

	switch(action)
		if("rebuild")
			group.rebuild_hud()

		if("reset_mob")
			set_target(null)

		if("toggle_mirroring")
			set_mirroring(!mirror_target)

		if("vv_mob")
			owner.owner.debug_variables(reference_frame)

		if("set_group")
			current_group = params["target_group"]

		if("connect_relay")
			var/source_plane = params["source"]
			var/target_plane = params["target"]
			var/blend_mode = text2num(params["mode"])
			var/atom/movable/screen/plane_master/source = our_planes["[source_plane]"]
			if(source.get_relay_to(target_plane)) // Fuck off
				return
			source.add_relay_to(target_plane, blend_mode != BLEND_DEFAULT ? blend_mode : null)
			return TRUE

		if("disconnect_relay")
			var/source_plane = params["source"]
			var/target_plane = params["target"]
			var/atom/movable/screen/plane_master/source = our_planes["[source_plane]"]
			source.remove_relay_from(text2num(target_plane))
			return TRUE

		if("disconnect_filter")
			var/target_plane = params["target"]
			var/atom/movable/screen/plane_master/filtered_plane = our_planes["[target_plane]"]
			filtered_plane.remove_filter(params["name"])
			return TRUE

		if("vv_plane")
			var/plane_edit = params["edit"]
			var/atom/movable/screen/plane_master/edit = our_planes["[plane_edit]"]
			var/mob/user = ui.user
			user?.client?.debug_variables(edit)
			return TRUE

		if("set_alpha")
			var/plane_edit = params["edit"]
			var/atom/movable/screen/plane_master/edit = our_planes["[plane_edit]"]
			var/newalpha = params["alpha"]
			animate(edit, 0.4 SECONDS, alpha = newalpha)
			return TRUE

		if("edit_color_matrix")
			var/plane_edit = params["edit"]
			var/atom/movable/screen/plane_master/edit = our_planes["[plane_edit]"]
			var/mob/user = ui.user
			user?.client?.debug_variables(edit)
			return TRUE

		if("edit_filters")
			var/plane_edit = params["edit"]
			var/atom/movable/screen/plane_master/edit = our_planes["[plane_edit]"]
			var/mob/user = ui.user
			user?.client?.debug_variables(edit)
			return TRUE

/datum/plane_master_debug/ui_close(mob/user)
	. = ..()
	set_mirroring(FALSE)

/client/proc/debug_plane_masters()
	set name = "Edit/Debug Planes"
	set category = "Debug"
	set desc = "Edit and visualize plane masters and their connections (relays)."

	if(!check_rights(R_DEBUG))
		return
	edit_plane_masters()

/client/proc/edit_plane_masters(mob/debug_on)
	if(!holder)
		return
	if(!holder.plane_debug)
		holder.plane_debug = new(holder)
	if(debug_on)
		holder.plane_debug.set_mirroring(TRUE)
		holder.plane_debug.set_target(debug_on)
	else
		holder.plane_debug.set_mirroring(FALSE)
	holder.plane_debug.ui_interact(mob)

/client/proc/toggle_flat_multiz_plane_scaling()
	set category = "Debug"
	set name = "Toggle Flat Multiz Plane Scaling"
	set desc = "Toggle the temporary flat multiz plane transform mode used while validating plane offsets."

	if(!check_rights(R_DEBUG))
		return

	GLOB.multiz_plane_scaling_neutralized = !GLOB.multiz_plane_scaling_neutralized
	for(var/client/viewer as anything in GLOB.clients)
		var/datum/hud/viewer_hud = viewer.mob?.hud_used
		if(!viewer_hud)
			continue
		for(var/group_key in viewer_hud.master_groups)
			var/datum/plane_master_group/group = viewer_hud.master_groups[group_key]
			group.build_planes_offset(viewer_hud, viewer_hud.current_plane_offset)

	var/state = GLOB.multiz_plane_scaling_neutralized ? "neutralized/flat" : "normal animated scaling"
	to_chat(src, SPAN_NOTICE("Multiz plane scaling is now [state]."))
	message_admins("[key_name_admin(src)] toggled multiz plane scaling to [state].")
	log_admin("[key_name(src)] toggled multiz plane scaling to [state].")
	feedback_add_details("admin_verb", "TFMPS")

/client/proc/probe_plane_atom(atom/target as obj|mob|turf in range(world.view))
	set category = "Debug"
	set name = "Probe Plane Atom/Turf"
	set desc = "Dump plane, overlay, and lighting debug data for a clicked atom or turf."

	if(!check_rights(R_DEBUG))
		return
	if(!target)
		return

	var/list/lines = list()
	lines += "Plane atom/turf probe"
	lines += "viewer=[mob] eye=[eye || mob] flat_multiz_scaling=[GLOB.multiz_plane_scaling_neutralized]"
	lines += ""
	lines += plane_probe_atom_lines(target, "Target")

	var/turf/target_turf = get_turf(target)
	if(target_turf && target_turf != target)
		lines += ""
		lines += plane_probe_atom_lines(target_turf, "Target Turf")

	lines += ""
	lines += "Lighting object plane checks:"
	var/found_lighting_object = FALSE
	if(istype(target, /atom/movable/lighting_object))
		found_lighting_object = TRUE
		var/atom/movable/lighting_object/target_lighting_object = target
		lines += plane_probe_lighting_object_lines(target_lighting_object, target_turf, "clicked lighting object")

	if(target_turf?.lighting_object)
		found_lighting_object = TRUE
		lines += plane_probe_lighting_object_lines(target_turf.lighting_object, target_turf, "target turf lighting_object")

	for(var/atom/movable/lighting_object/lighting_object as anything in plane_probe_vis_contents(target))
		if(lighting_object == target_turf?.lighting_object)
			continue
		found_lighting_object = TRUE
		lines += plane_probe_lighting_object_lines(lighting_object, target_turf, "target vis_contents lighting object")

	if(target_turf && target_turf != target)
		for(var/atom/movable/lighting_object/lighting_object as anything in target_turf.vis_contents)
			if(lighting_object == target_turf.lighting_object)
				continue
			found_lighting_object = TRUE
			lines += plane_probe_lighting_object_lines(lighting_object, target_turf, "turf vis_contents lighting object")

	if(!found_lighting_object)
		lines += "  none found on the clicked atom/turf context"

	var/output = "<b>Plane Atom/Turf Probe</b><hr><pre>[html_encode(jointext(lines, "\n"))]</pre>"
	src << browse(HTML_SKELETON(output), "window=plane_atom_probe;size=1000x800")
	feedback_add_details("admin_verb", "PAPRB")

/client/proc/dump_plane_cube_chain()
	set category = "Debug"
	set name = "Dump Plane Cube Chain"
	set desc = "Dump the current HUD's core tg plane cube chain and render relays."

	if(!check_rights(R_DEBUG))
		return

	var/mob/reference_frame = mob
	var/datum/hud/our_hud = reference_frame?.hud_used
	if(!our_hud)
		to_chat(src, SPAN_WARNING("No HUD is available to inspect."))
		return

	var/datum/plane_master_group/group = our_hud.get_plane_group(PLANE_GROUP_MAIN)
	if(!group)
		to_chat(src, SPAN_WARNING("The main plane master group is missing."))
		return

	var/atom/eye_atom = eye || reference_frame
	var/turf/eye_turf = get_turf(eye_atom)
	var/eye_turf_text = eye_turf ? "[eye_turf.x],[eye_turf.y],[eye_turf.z]" : "null"
	var/list/lines = list()
	lines += "Plane cube chain dump"
	lines += "mob=[reference_frame] eye=[eye_atom] turf=[eye_turf_text]"
	lines += "hud_current_plane_offset=[our_hud.current_plane_offset] group_active_offset=[group.active_offset] max_plane_offset=[SSmapping.max_plane_offset]"
	lines += ""
	lines += "z/offset tables:"
	for(var/z_level in 1 to length(SSmapping.z_level_to_plane_offset))
		lines += "  z=[z_level] offset=[SSmapping.z_level_to_plane_offset[z_level]] lowest=[SSmapping.z_level_to_lowest_plane_offset[z_level]] stack=[SSmapping.z_level_to_stack[z_level]]"

	var/list/plane_labels = list(
		"[FLOOR_PLANE]" = "FLOOR_PLANE",
		"[WALL_PLANE]" = "WALL_PLANE",
		"[GAME_PLANE]" = "GAME_PLANE",
		"[LIGHTING_PLANE]" = "LIGHTING_PLANE",
		"[RENDER_PLANE_GAME_WORLD]" = "RENDER_PLANE_GAME_WORLD",
		"[RENDER_PLANE_UNLIT_GAME]" = "RENDER_PLANE_UNLIT_GAME",
		"[RENDER_PLANE_TURF_LIGHTING]" = "RENDER_PLANE_TURF_LIGHTING",
		"[RENDER_PLANE_LIGHTING]" = "RENDER_PLANE_LIGHTING",
		"[RENDER_PLANE_LIGHT_MASK]" = "RENDER_PLANE_LIGHT_MASK",
		"[RENDER_PLANE_GAME]" = "RENDER_PLANE_GAME",
		"[RENDER_PLANE_MASTER]" = "RENDER_PLANE_MASTER",
		"[RENDER_PLANE_TRANSPARENT]" = "RENDER_PLANE_TRANSPARENT",
	)
	var/list/relevant_true_planes = list(
		FLOOR_PLANE,
		WALL_PLANE,
		GAME_PLANE,
		LIGHTING_PLANE,
		RENDER_PLANE_GAME_WORLD,
		RENDER_PLANE_UNLIT_GAME,
		RENDER_PLANE_TURF_LIGHTING,
		RENDER_PLANE_LIGHTING,
		RENDER_PLANE_LIGHT_MASK,
		RENDER_PLANE_GAME,
		RENDER_PLANE_MASTER,
		RENDER_PLANE_TRANSPARENT,
	)

	for(var/true_plane as anything in relevant_true_planes)
		var/label = plane_labels["[true_plane]"] || "[true_plane]"
		lines += ""
		lines += "== [label] true_plane=[true_plane] =="
		var/list/concrete_planes = TRUE_PLANE_TO_OFFSETS(true_plane)
		if(!length(concrete_planes))
			concrete_planes = list(GET_NEW_PLANE(true_plane, our_hud.current_plane_offset))

		for(var/concrete_plane as anything in concrete_planes)
			var/atom/movable/screen/plane_master/plane = group.get_plane(concrete_plane)
			if(!plane)
				lines += "  concrete=[concrete_plane] MISSING plane master; offset=[PLANE_TO_OFFSET(concrete_plane)] screen=FALSE"
				continue

			lines += "  plane=[plane.plane] true=[PLANE_TO_TRUE(plane.plane)] offset=[PLANE_TO_OFFSET(plane.plane)] real=[plane.real_plane] name=[plane.name]"
			lines += "    render_target=[plane.render_target] render_source=[plane.render_source] blend=[blend_mode_to_text(plane.blend_mode_override || plane.blend_mode)] alpha=[plane.alpha] force_hidden=[plane.force_hidden] outside_bounds=[plane.is_outside_bounds] screen=[plane_debug_in_client_screen(src, plane)]"
			lines += "    renders_onto=[json_encode(plane.render_relay_planes)]"
			if(!length(plane.relays))
				lines += "    relays: none"
				continue

			lines += "    relays:"
			for(var/atom/movable/render_plane_relay/relay as anything in plane.relays)
				lines += "      target=[relay.plane] target_true=[PLANE_TO_TRUE(relay.plane)] target_offset=[PLANE_TO_OFFSET(relay.plane)] layer=[relay.layer] render_source=[relay.render_source] blend=[blend_mode_to_text(relay.blend_mode)] alpha=[relay.alpha] critical=[relay.critical_target] screen=[plane_debug_in_client_screen(src, relay)]"

	var/output = "<b>Plane Cube Chain Dump</b><hr><pre>[html_encode(jointext(lines, "\n"))]</pre>"
	src << browse(HTML_SKELETON(output), "window=plane_cube_chain;size=1000x800")

/proc/plane_debug_in_client_screen(client/viewer, atom/movable/screen_object)
	if(!viewer || !screen_object)
		return FALSE
	return viewer.screen.Find(screen_object) ? TRUE : FALSE

/proc/blend_mode_to_text(blend_mode)
	switch(blend_mode)
		if(BLEND_DEFAULT)
			return "BLEND_DEFAULT"
		if(BLEND_OVERLAY)
			return "BLEND_OVERLAY"
		if(BLEND_ADD)
			return "BLEND_ADD"
		if(BLEND_SUBTRACT)
			return "BLEND_SUBTRACT"
		if(BLEND_MULTIPLY)
			return "BLEND_MULTIPLY"
		if(BLEND_INSET_OVERLAY)
			return "BLEND_INSET_OVERLAY"
	return "[blend_mode]"

/proc/plane_probe_atom_lines(atom/target, label)
	var/list/lines = list()
	if(!target)
		lines += "[label]: null"
		return lines

	var/turf/target_turf = get_turf(target)
	var/turf_offset = plane_probe_turf_offset(target_turf)
	var/true_plane = PLANE_TO_TRUE(target.plane)
	var/expected_turf_plane = GET_NEW_PLANE(true_plane, turf_offset)
	lines += "[label]: [target] ([target.type], ref=[REF(target)])"
	lines += "  loc=[target.loc] loc_type=[target.loc?.type] coords=[plane_probe_atom_coords(target)] turf=[plane_probe_atom_coords(target_turf)]"
	lines += "  plane=[target.plane] true=[true_plane] offset=[PLANE_TO_OFFSET(target.plane)] expected_for_turf=[expected_turf_plane] matches_expected_for_turf=[target.plane == expected_turf_plane]"
	lines += "  layer=[target.layer] alpha=[target.alpha] color=[plane_probe_value_to_text(target.color)]"
	lines += "  light=[plane_probe_light_source_summary(target.light)]"
	lines += "  light_sources:"
	lines += plane_probe_light_sources_summary(target.light_sources, 6, "    ")
	if(isturf(target))
		var/turf/probed_turf = target
		lines += "  lighting_object=[plane_probe_visual_entry(probed_turf.lighting_object)]"
	else if(target_turf)
		lines += "  turf_lighting_object=[plane_probe_visual_entry(target_turf.lighting_object)]"
	else
		lines += "  turf_lighting_object=null"
	lines += "  overlays:"
	lines += plane_probe_visual_list_summary(target.overlays, 10, "    ")
	lines += "  underlays:"
	lines += plane_probe_visual_list_summary(target.underlays, 10, "    ")
	lines += "  update_on_z:"
	lines += plane_probe_visual_list_summary(target.update_on_z, 10, "    ")
	lines += "  update_overlays_on_z:"
	lines += plane_probe_visual_list_summary(target.update_overlays_on_z, 10, "    ")
	lines += "  vis_contents:"
	lines += plane_probe_visual_list_summary(plane_probe_vis_contents(target), 12, "    ")
	return lines

/proc/plane_probe_lighting_object_lines(atom/movable/lighting_object/lighting_object, turf/reference_turf, label)
	var/list/lines = list()
	if(!lighting_object)
		lines += "  [label]: null"
		return lines

	var/turf/affected_turf = lighting_object.affected_turf
	if(!affected_turf)
		affected_turf = reference_turf
	var/expected_plane = plane_probe_expected_lighting_plane(affected_turf)
	var/matches_expected = isnull(expected_plane) ? "unknown" : (lighting_object.plane == expected_plane ? "TRUE" : "FALSE")
	var/in_affected_vis_contents = affected_turf && affected_turf.vis_contents.Find(lighting_object)
	lines += "  [label]: [plane_probe_visual_entry(lighting_object)]"
	lines += "    affected_turf=[plane_probe_atom_coords(affected_turf)] expected_lighting_plane=[expected_plane] matches_expected=[matches_expected] in_affected_vis_contents=[in_affected_vis_contents ? TRUE : FALSE] needs_update=[lighting_object.needs_update]"
	return lines

/proc/plane_probe_visual_list_summary(list/things, max_entries = 10, prefix = "")
	var/list/lines = list()
	var/count = length(things)
	lines += "[prefix]len=[count]"
	if(!count)
		return lines

	var/index = 1
	for(var/entry in things)
		if(index > max_entries)
			break
		lines += "[prefix][index]. [plane_probe_visual_entry(entry)]"
		index++
	if(count > max_entries)
		lines += "[prefix]... [count - max_entries] more"
	return lines

/proc/plane_probe_light_sources_summary(list/light_sources, max_entries = 6, prefix = "")
	var/list/lines = list()
	var/count = length(light_sources)
	lines += "[prefix]len=[count]"
	if(!count)
		return lines

	var/index = 1
	for(var/source in light_sources)
		if(index > max_entries)
			break
		lines += "[prefix][index]. [plane_probe_light_source_summary(source)]"
		index++
	if(count > max_entries)
		lines += "[prefix]... [count - max_entries] more"
	return lines

/proc/plane_probe_visual_entry(entry)
	if(isnull(entry))
		return "null"
	if(isatom(entry))
		var/atom/atom_entry = entry
		return "[atom_entry] ([atom_entry.type], ref=[REF(atom_entry)]) loc=[atom_entry.loc] coords=[plane_probe_atom_coords(atom_entry)] plane=[atom_entry.plane] true=[PLANE_TO_TRUE(atom_entry.plane)] offset=[PLANE_TO_OFFSET(atom_entry.plane)] layer=[atom_entry.layer] alpha=[atom_entry.alpha] color=[plane_probe_value_to_text(atom_entry.color)]"
	if(istype(entry, /image))
		var/image/image_entry = entry
		return "[image_entry] ([image_entry.type], ref=[REF(image_entry)]) plane=[image_entry.plane] true=[PLANE_TO_TRUE(image_entry.plane)] offset=[PLANE_TO_OFFSET(image_entry.plane)] layer=[image_entry.layer] alpha=[image_entry.alpha] color=[plane_probe_value_to_text(image_entry.color)] icon=[image_entry.icon] icon_state=[image_entry.icon_state]"
	if(isdatum(entry))
		var/datum/datum_entry = entry
		return "[datum_entry] ([datum_entry.type], ref=[REF(datum_entry)])"
	return "[entry]"

/proc/plane_probe_light_source_summary(datum/light_source/light_source)
	if(!light_source)
		return "null"
	return "[light_source] ([light_source.type], ref=[REF(light_source)]) source=[plane_probe_visual_entry(light_source.source_atom)] top=[plane_probe_visual_entry(light_source.top_atom)] source_turf=[plane_probe_atom_coords(light_source.source_turf)] range=[light_source.light_range] power=[light_source.light_power] color=[light_source.light_color] height=[light_source.light_height] dir=[light_source.light_dir] angle=[light_source.light_angle] applied=[light_source.applied] needs_update=[light_source.needs_update]"

/proc/plane_probe_value_to_text(value)
	if(isnull(value))
		return "null"
	if(islist(value))
		return json_encode(value)
	if(isdatum(value))
		var/datum/datum_value = value
		return "[datum_value] ([datum_value.type], ref=[REF(datum_value)])"
	return "[value]"

/proc/plane_probe_atom_coords(atom/target)
	if(!target)
		return "null"
	return "[target.x],[target.y],[target.z]"

/proc/plane_probe_vis_contents(atom/target)
	if(isturf(target))
		var/turf/turf_target = target
		return turf_target.vis_contents
	if(ismovable(target))
		var/atom/movable/movable_target = target
		return movable_target.vis_contents
	return null

/proc/plane_probe_turf_offset(turf/target)
	if(!target || !SSmapping.max_plane_offset || length(SSmapping.z_level_to_plane_offset) < target.z)
		return 0
	return GET_Z_PLANE_OFFSET(target.z)

/proc/plane_probe_expected_lighting_plane(turf/target)
	if(!target)
		return null
	if(!SSmapping.max_plane_offset || length(SSmapping.z_level_to_plane_offset) < target.z)
		return LIGHTING_PLANE
	return GET_NEW_PLANE(LIGHTING_PLANE, GET_Z_PLANE_OFFSET(target.z))

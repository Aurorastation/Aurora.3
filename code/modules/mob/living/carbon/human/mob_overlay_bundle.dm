/// Stages visible on-mob overlays with their emissive-plane siblings.
/// This is a bridge between tgstation update_appearance() pipeline and Aurora's.. bullshit whatever we want to call it.
/datum/mob_overlay_bundle
	var/source
	var/base
	var/list/overlays
	var/list/blockers
	var/list/emissives
	var/list/above

/datum/mob_overlay_bundle/proc/SetSource(new_source)
	source = new_source
	return src

/datum/mob_overlay_bundle/proc/SetBase(new_base)
	base = new_base
	return src

/datum/mob_overlay_bundle/proc/AddOverlay(new_overlay)
	if(new_overlay)
		LAZYADD(overlays, new_overlay)
	return src

/datum/mob_overlay_bundle/proc/AddBlocker(new_blocker)
	if(new_blocker)
		LAZYADD(blockers, new_blocker)
	return src

/datum/mob_overlay_bundle/proc/AddEmissive(new_emissive)
	if(new_emissive)
		LAZYADD(emissives, new_emissive)
	return src

/datum/mob_overlay_bundle/proc/AddAbove(new_overlay)
	if(new_overlay)
		LAZYADD(above, new_overlay)
	return src

/image/var/list/plane_overlay_siblings
/image/var/list/plane_overlay_sibling_categories
/// Generate a current-shape emissive blocker when this image is flattened into a human mob overlay list.
/image/var/generate_mob_emissive_blocker = FALSE

/image/proc/AddPlaneOverlaySibling(source, category)
	if(!source)
		return
	LAZYADD(plane_overlay_siblings, source)
	if(category)
		LAZYINITLIST(plane_overlay_sibling_categories)
		plane_overlay_sibling_categories["REF[source]"] = category

/image/proc/CutPlaneOverlaySiblingsByCategory(category)
	if(!category || !LAZYLEN(plane_overlay_siblings))
		return
	for(var/sibling in plane_overlay_siblings.Copy())
		if(plane_overlay_sibling_categories?["REF[sibling]"] != category)
			continue
		LAZYREMOVE(plane_overlay_siblings, sibling)
		plane_overlay_sibling_categories -= "REF[sibling]"

/image/proc/ReplacePlaneOverlayBlocker(atom/offset_spokesman)
	if(!offset_spokesman)
		return
	CutPlaneOverlaySiblingsByCategory("blocker")
	var/mutable_appearance/blocker = emissive_blocker_from_appearance(src, offset_spokesman)
	if(blocker)
		AddPlaneOverlaySibling(blocker, "blocker")

/// Converts a mob_overlay_bundle into a list suitable to directly insert into overlays.
/proc/finalize_mob_overlay_bundle(var/datum/mob_overlay_bundle/bundle, var/mob/living/carbon/human/H)
	if(!bundle || !H)
		return list()

	var/list/result = list()
	var/image/base_image = overlay_bundle_first_image(bundle.base)
	var/base_pixel_x = base_image ? base_image.pixel_x : 0
	var/base_pixel_y = base_image ? base_image.pixel_y : 0

	overlay_bundle_append_category(result, bundle.base, "base", H, base_pixel_x, base_pixel_y, TRUE)
	overlay_bundle_append_category(result, bundle.overlays, "overlay", H, base_pixel_x, base_pixel_y, TRUE)
	overlay_bundle_append_category(result, bundle.blockers, "blocker", H, base_pixel_x, base_pixel_y, FALSE)
	overlay_bundle_append_category(result, bundle.emissives, "emissive", H, base_pixel_x, base_pixel_y, FALSE)
	overlay_bundle_append_category(result, bundle.above, "above", H, base_pixel_x, base_pixel_y, TRUE)

	return result

/// Compatibility for legacy get_mob_overlay() callers that still expect one image.
/proc/finalize_mob_overlay_bundle_as_image(var/datum/mob_overlay_bundle/bundle, var/mob/living/carbon/human/H)
	RETURN_TYPE(/image)
	if(!bundle || !H)
		return null

	var/image/base_image = overlay_bundle_first_image(bundle.base)
	if(!base_image)
		return null

	var/base_pixel_x = base_image.pixel_x
	var/base_pixel_y = base_image.pixel_y
	var/list/base_result = list()
	overlay_bundle_append_category(base_result, bundle.base, "base", H, base_pixel_x, base_pixel_y, TRUE)
	overlay_bundle_attach_category(base_image, bundle.overlays, "overlay", H, base_pixel_x, base_pixel_y, TRUE)
	overlay_bundle_attach_category(base_image, bundle.blockers, "blocker", H, base_pixel_x, base_pixel_y, FALSE)
	overlay_bundle_attach_category(base_image, bundle.emissives, "emissive", H, base_pixel_x, base_pixel_y, FALSE)
	overlay_bundle_attach_category(base_image, bundle.above, "above", H, base_pixel_x, base_pixel_y, TRUE)

	return base_image

/proc/overlay_bundle_attach_category(var/image/base_image, sources, category, var/mob/living/carbon/human/H, base_pixel_x, base_pixel_y, default_game_plane)
	if(!base_image || !sources)
		return
	var/list/prepared = list()
	overlay_bundle_append_category(prepared, sources, category, H, base_pixel_x, base_pixel_y, default_game_plane)
	for(var/source in prepared)
		if(source && source != base_image)
			base_image.AddPlaneOverlaySibling(source, category)

/proc/overlay_bundle_append_category(var/list/result, sources, category, var/mob/living/carbon/human/H, base_pixel_x, base_pixel_y, default_game_plane)
	if(!result || !sources)
		return
	if(islist(sources))
		for(var/source in sources)
			overlay_bundle_append_category(result, source, category, H, base_pixel_x, base_pixel_y, default_game_plane)
		return

	overlay_bundle_prepare_source(sources, category, H, base_pixel_x, base_pixel_y, default_game_plane)
	result += sources

/proc/overlay_bundle_prepare_source(source, category, var/mob/living/carbon/human/H, base_pixel_x, base_pixel_y, default_game_plane)
	if(!istype(source, /mutable_appearance))
		return
	var/mutable_appearance/appearance = source
	switch(category)
		if("blocker")
			SET_PLANE_EXPLICIT(appearance, EMISSIVE_PLANE, H)
			if(appearance.layer == FLOAT_LAYER)
				appearance.layer = MOB_SHADOW_LAYER
		if("emissive")
			SET_PLANE_EXPLICIT(appearance, EMISSIVE_PLANE, H)
			if(appearance.layer == FLOAT_LAYER)
				appearance.layer = MOB_EMISSIVE_LAYER
		else
			if(appearance.plane != FLOAT_PLANE && !PLANE_IS_CRITICAL(PLANE_TO_TRUE(appearance.plane)))
				SET_PLANE_EXPLICIT(appearance, PLANE_TO_TRUE(appearance.plane), H)

	if(category != "base")
		appearance.pixel_x = base_pixel_x
		appearance.pixel_y = base_pixel_y

/proc/reoffset_mob_overlay_for_z(source, var/mob/living/carbon/human/H)
	if(!source || !H)
		return
	if(islist(source))
		for(var/entry in source)
			reoffset_mob_overlay_for_z(entry, H)
		return

	if(istype(source, /mutable_appearance))
		var/mutable_appearance/appearance = source
		if(appearance.plane != FLOAT_PLANE && !PLANE_IS_CRITICAL(PLANE_TO_TRUE(appearance.plane)))
			SET_PLANE_EXPLICIT(appearance, PLANE_TO_TRUE(appearance.plane), H)

	if(istype(source, /image))
		var/image/I = source
		if(LAZYLEN(I.plane_overlay_siblings))
			for(var/sibling in I.plane_overlay_siblings)
				reoffset_mob_overlay_for_z(sibling, H)

/proc/overlay_bundle_first_image(sources)
	RETURN_TYPE(/image)
	if(istype(sources, /image))
		return sources
	if(islist(sources))
		for(var/source in sources)
			var/image/found = overlay_bundle_first_image(source)
			if(found)
				return found
	return null

/// Assigns an ordered layer range to bundle siblings as the final human overlay list is flattened. This is my life now
/proc/overlay_bundle_order_plane_siblings(var/image/parent, var/list/layer_state)
	if(!parent || !LAZYLEN(parent.plane_overlay_siblings) || !layer_state)
		return

	var/has_emissive_siblings = FALSE
	for(var/sibling in parent.plane_overlay_siblings)
		var/category = parent.plane_overlay_sibling_categories?["REF[sibling]"]
		if(category == "blocker" || category == "emissive")
			has_emissive_siblings = TRUE
			break

	if(!has_emissive_siblings)
		return

	var/order = layer_state["order"] || 0
	layer_state["order"] = order + 1
	var/base_layer = MOB_SHADOW_UPPER_LAYER + (order * 0.00002)

	for(var/sibling in parent.plane_overlay_siblings)
		if(!istype(sibling, /mutable_appearance))
			continue
		var/mutable_appearance/sibling_appearance = sibling
		switch(parent.plane_overlay_sibling_categories?["REF[sibling]"])
			if("blocker")
				sibling_appearance.layer = base_layer
			if("emissive")
				sibling_appearance.layer = base_layer + 0.00001

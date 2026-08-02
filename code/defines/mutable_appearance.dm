// Mutable appearances are an inbuilt byond datastructure. Read the documentation on them by hitting F1 in DM.
// Basically use them instead of images for overlays/underlays and when changing an object's appearance if you're doing so with any regularity.
// Unless you need the overlay/underlay to have a different direction than the base object. Then you have to use an image due to a bug.

// Mutable appearances are children of images, just so you know.

/mutable_appearance
	appearance_flags = DEFAULT_APPEARANCE_FLAGS //Bay shit

/mutable_appearance/New(mutable_appearance/to_copy)
	..()
	if(!to_copy)
		plane = FLOAT_PLANE

// Helper similar to image(). Non-FLOAT planes need either an atom offset spokesman or an explicit offset constant.
/proc/mutable_appearance(icon, icon_state = "", layer = FLOAT_LAYER, atom/offset_spokesman, plane = FLOAT_PLANE, alpha = 255, appearance_flags = NONE, offset_const)
	RETURN_TYPE(/mutable_appearance)
	var/mutable_appearance/MA = new()
	MA.icon = icon
	MA.icon_state = icon_state
	MA.layer = layer
	MA.alpha = alpha
	MA.appearance_flags |= appearance_flags
	if(plane != FLOAT_PLANE)
		if(isatom(offset_spokesman))
			SET_PLANE_EXPLICIT(MA, plane, offset_spokesman)
		else if(!isnull(offset_const))
			SET_PLANE_W_SCALAR(MA, plane, offset_const)
		else
			stack_trace("No plane offset context supplied for non-FLOAT mutable appearance [icon] / [icon_state].")
	else if(!isnull(offset_spokesman) && !isatom(offset_spokesman))
		stack_trace("Invalid mutable appearance offset spokesman [offset_spokesman] for [icon] / [icon_state].")
	return MA

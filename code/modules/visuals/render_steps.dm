/**
 * Internal atom that uses render relays to apply "appearance things" to a render source.
 */
/atom/movable/render_step
	name = "render step"
	plane = DEFAULT_PLANE
	layer = FLOAT_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	appearance_flags = KEEP_APART|KEEP_TOGETHER|RESET_TRANSFORM

/atom/movable/render_step/Initialize(mapload, atom/source)
	. = ..()
	verbs.Cut()

	if(!source)
		return

	render_source = source.render_target
	SET_PLANE_EXPLICIT(src, initial(plane), source)
	RegisterSignal(source, COMSIG_QDELETING, PROC_REF(on_source_deleting))

/atom/movable/render_step/ex_act(severity)
	return FALSE

/atom/movable/render_step/singularity_act()
	return

/atom/movable/render_step/singularity_pull(atom/singularity, current_size)
	return

/atom/movable/render_step/proc/blob_act()
	return

/atom/movable/render_step/forceMove(atom/destination, no_tp = FALSE, harderforce = FALSE)
	if(harderforce)
		return ..()

/atom/movable/render_step/proc/on_source_deleting(atom/source)
	SIGNAL_HANDLER

	if(!QDELING(src))
		qdel(src)

/**
 * Render step that modifies an atom's color.
 */
/atom/movable/render_step/color
	name = "color step"
	appearance_flags = KEEP_APART|KEEP_TOGETHER|RESET_COLOR|RESET_TRANSFORM

/atom/movable/render_step/color/Initialize(mapload, atom/source, color)
	. = ..()
	src.color = color

/**
 * Render step that makes the passed-in render source block emissives.
 */
/atom/movable/render_step/emissive_blocker
	name = "emissive blocker"
	plane = EMISSIVE_PLANE
	appearance_flags = EMISSIVE_APPEARANCE_FLAGS|RESET_TRANSFORM

/atom/movable/render_step/emissive_blocker/Initialize(mapload, atom/source)
	. = ..()
	src.color = GLOB.em_block_color

/**
 * Render step that makes the passed-in render source glow.
 */
/atom/movable/render_step/emissive
	name = "emissive"
	plane = EMISSIVE_PLANE
	appearance_flags = EMISSIVE_APPEARANCE_FLAGS|RESET_TRANSFORM

/atom/movable/render_step/emissive/Initialize(mapload, source)
	. = ..()
	src.color = GLOB.emissive_color

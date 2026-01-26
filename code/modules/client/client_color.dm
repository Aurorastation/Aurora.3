/datum/client_color
	/// Color given to the client, can be a hex color, color matrix or a filter
	var/client_color = "" //Any client.color-valid value
	/// The mob that owns this client_colour
	var/mob/owner
	/// Priority of this color, higher values are rendered above lower ones
	var/priority = 1
	/// Will this client_colour prevent ones of lower priority from being applied?
	var/override = FALSE
	var/disability = FALSE
	/// If non-zero, 'update_client_color(fade_in)' will be called instead of 'update_client_color' when added.
	var/fade_in = 0
	/// If non-zero, 'update_client_color(fade_out)' will be called instead of 'update_client_color' when removed.
	var/fade_out = 0

/datum/client_color/New(mob/owner)
	src.owner = owner

/datum/client_color/Destroy()
	if(!QDELETED(owner))
		owner.client_colors -= src
		owner.update_client_color(fade_out)
	owner = null
	return ..()

/mob
	var/list/client_colors = list()


/**
 * Add a color filter to the client
 * new_color - client_color datum or typepath to be added
 * source - associated source for the client color
 * force - if TRUE, colors of the same source will be replaced even if it is of the same type
 */
/mob/proc/add_client_color(datum/client_color/new_color, source, force = FALSE)
	if (QDELING(src))
		return

	if (ispath(new_color))
		new_color = new new_color(src)

	if (!istype(new_color))
		CRASH("Invalid color type or datum for add_client_color: [new_color ? "[new_color] ([new_color.type])" : "null"]")

	// Ensure that if a color with this source is already present, we either abort or get rid of it
	var/datum/client_color/existing_color = get_client_color(source)
	if (existing_color)
		if (existing_color.type == new_color.type && !force)
			return existing_color
		qdel(existing_color)
	client_colors[new_color] = source
	update_client_color(new_color.fade_in)
	return new_color


/mob/proc/get_client_color(source)
	for(var/datum/client_color/color as anything in client_colors)
		if (client_colors[color] == source)
			return color


/*
	Removes an instance of color_type from the mob's client_colors list
	color_type - a typepath (subtyped from /datum/client_color)
	returns true if instance was found, false otherwise
*/
/mob/proc/remove_client_color(source)
	var/datum/client_color/existing_color = get_client_color(source)
	if (!existing_color)
		return FALSE
	qdel(existing_color)
	return TRUE

/mob/proc/update_client_color(anim_time = 1 SECONDS, anim_easing = LINEAR_EASING)
	if (isnull(client))
		return

	if(!length(client_colors))
		animate(client, color = null, time = anim_time, easing = anim_easing)
		UNSETEMPTY(client_colors)
		return

	//Sort the matrix packages by priority.
	client_colors = sortTim(client_colors, GLOBAL_PROC_REF(cmp_filter_data_priority), TRUE)

	var/list/final_matrix

	for(var/package in client_colors)
		var/list/current_matrix = client_colors[package]["color_matrix"]
		if(!final_matrix)
			final_matrix = current_matrix
		else
			final_matrix = color_matrix_multiply(final_matrix, current_matrix)

	animate(client, color = final_matrix, time = anim_time, easing = anim_easing)

/datum/client_color/monochrome
	client_color = COLOR_MATRIX_GRAYSCALE
	priority = 100
	fade_in = 2 SECONDS
	fade_out = 2 SECONDS

//Similar to monochrome but shouldn't look as flat, same priority
/datum/client_color/noir
	client_color = COLOR_MATRIX_NOIR
	priority = 200

/datum/client_color/thirdeye
	client_color = list(0.1, 0.1, 0.1, 0.2, 0.2, 0.2, 0.05, 0.05, 0.05)
	priority = 300

/datum/client_color/vaurca
	client_color = list(0.793, 0.297, 0, 0.297, 0.539, 0, 0, 0, 0)
	priority = 100

/datum/client_color/deuteranopia
	client_color = list(0.47, 0.38, 0.15, 0.54, 0.31, 0.15, 0, 0.3, 0.7)
	priority = 100

/datum/client_color/protanopia
	client_color = list(0.51, 0.4, 0.12, 0.49, 0.41, 0.12, 0, 0.2, 0.76)
	priority = 100

/datum/client_color/tritanopia
	client_color = list(0.95, 0.07, 0, 0, 0.44, 0.52, 0.05, 0.49, 0.48)
	priority = 100

/datum/client_color/berserk
	client_color = list(0.793, 0.4, 0.4, 0.793, 0.4, 0.4, 0, 0, 0)
	priority = INFINITY //This effect sort of exists on its own you /have/ to be seeing RED
	override = TRUE //Because multiplying this will inevitably fail

/datum/client_color/oversaturated/New()
	client_color = color_saturation(40)

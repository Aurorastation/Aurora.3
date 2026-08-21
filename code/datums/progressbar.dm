/datum/progressbar
	/// The icon file containing the backdrop, mask, and fill states for this theme.
	var/icon = 'icons/effects/progress_bar/default.dmi'
	/// The total height in pixels of the themed progress bar.
	var/height = 7
	/// The width in pixels of the theme's fill sprite.
	var/fill_width = 22
	/// The time taken for the progress bar to appear.
	var/animation_time_appear = 0.5 SECONDS
	/// The time taken for the progress bar to fade away.
	var/animation_time_fade = 0.5 SECONDS
	/// The time taken for stacked progress bars to shift down.
	var/animation_time_shift = 0.5 SECONDS

	/// The visual element containing the backdrop and fill.
	var/image/bar
	/// The backdrop visual element.
	var/image/backdrop
	/// The fill visual element.
	var/image/fill
	/// The target where this progress bar is applied and where it is shown.
	var/atom/bar_loc
	/// The mob whose client sees the progress bar.
	var/mob/user
	/// The client seeing the progress bar.
	var/client/user_client
	/// The number of steps the progress bar needs to reach completion.
	var/goal = 1
	/// The most recently displayed progress value.
	var/last_progress = 0
	/// The progress bar's position in the stack over its target.
	var/listindex = 0
	/// The type of our last value for bar_loc, for debugging.
	var/location_type
	/// Horizontal offset needed to centre the bar over oversized icons.
	var/offset_x
	/// Vertical offset needed to place the bar over oversized icons.
	var/offset_y
	/// Whether the bar has started its ending animation.
	var/stopping = FALSE
	/// Whether this bar has already been removed from the user's stack.
	var/removed_from_stack = FALSE

/datum/progressbar/New(mob/User, goal_number, atom/target)
	. = ..()
	if (!istype(target))
		stack_trace("Invalid target [target] passed in")
		qdel(src)
		return
	if (QDELETED(User) || !istype(User))
		stack_trace("/datum/progressbar created with [isnull(User) ? "null" : "invalid"] user")
		qdel(src)
		return
	if (!isnum(goal_number))
		stack_trace("/datum/progressbar created with [isnull(User) ? "null" : "invalid"] goal_number")
		qdel(src)
		return

	goal = goal_number
	bar_loc = target
	location_type = bar_loc.type
	user = User

	var/list/icon_offsets = target.get_oversized_icon_offsets()
	offset_x = icon_offsets["x"]
	offset_y = icon_offsets["y"]
	init_images()

	LAZYADDASSOCLIST(user.progressbars, bar_loc, src)
	var/list/bars = user.progressbars[bar_loc]
	listindex = length(bars)

	if (user.client)
		user_client = user.client
		add_prog_bar_image_to_client()

	RegisterSignal(user, COMSIG_QDELETING, PROC_REF(on_user_delete))
	RegisterSignal(user, COMSIG_MOB_LOGOUT, PROC_REF(clean_user_client))
	RegisterSignal(user, COMSIG_MOB_LOGIN, PROC_REF(on_user_login))
	RegisterSignal(bar_loc, COMSIG_QDELETING, PROC_REF(on_bar_loc_delete))

/datum/progressbar/Destroy()
	if (user)
		UnregisterSignal(user, list(COMSIG_QDELETING, COMSIG_MOB_LOGOUT, COMSIG_MOB_LOGIN))
		if (isliving(user))
			var/mob/living/living_user = user
			if (living_user.stamina_bar == src)
				living_user.stamina_bar = null

		remove_from_stack()
		user = null

	if (user_client)
		clean_user_client()

	if (bar_loc)
		UnregisterSignal(bar_loc, COMSIG_QDELETING)
		bar_loc = null

	bar = null
	backdrop = null
	fill = null

	return ..()

/// Initializes the holder, backdrop, and masked fill images used by the theme.
/datum/progressbar/proc/init_images()
	bar = image('icons/effects/effects.dmi', bar_loc, "nothing", HUD_ABOVE_ITEM_LAYER, pixel_x = offset_x)
	bar.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	bar.alpha = 0
	bar.plane = HUD_PLANE
	bar.appearance_flags = KEEP_TOGETHER | APPEARANCE_UI_IGNORE_ALPHA

	backdrop = image(icon, bar_loc, "backdrop")
	fill = image(icon, bar_loc, "fill")
	fill.filters = filter(type = "alpha", icon = icon(icon, "mask"), x = -fill_width)
	bar.overlays += list(backdrop, fill)

/// Removes this bar from its stack and smoothly shifts any bars above it down.
/datum/progressbar/proc/remove_from_stack()
	if (removed_from_stack || !user || !bar_loc)
		return

	var/list/bars = user.progressbars?[bar_loc]
	if (bars)
		for (var/pb in bars)
			var/datum/progressbar/progress_bar = pb
			if (progress_bar == src || progress_bar.listindex <= listindex)
				continue
			progress_bar.listindex--
			progress_bar.shift_down()
		LAZYREMOVEASSOC(user.progressbars, bar_loc, src)

	removed_from_stack = TRUE

/// Shifts this progress bar down one position in its stack.
/datum/progressbar/proc/shift_down()
	animate(bar,
		pixel_y = world.icon_size + offset_y + (height * (listindex - 1)),
		time = animation_time_shift,
		easing = SINE_EASING | EASE_OUT,
		flags = ANIMATION_PARALLEL
	)

/// Called right before the user's Destroy().
/datum/progressbar/proc/on_user_delete(datum/source)
	SIGNAL_HANDLER

	user.progressbars = null
	removed_from_stack = TRUE
	user = null
	qdel(src)

/// Called right before the bar_loc's Destroy().
/datum/progressbar/proc/on_bar_loc_delete(datum/source)
	SIGNAL_HANDLER

	qdel(src)

/// Removes the progress bar image from the current client.
/datum/progressbar/proc/clean_user_client(datum/source)
	SIGNAL_HANDLER

	if (!user_client)
		return
	user_client.images -= bar
	user_client = null

/// Transfers the progress bar image to the user's new client after login.
/datum/progressbar/proc/on_user_login(datum/source)
	SIGNAL_HANDLER

	if (user_client)
		if (user_client == user.client)
			return
		clean_user_client()
	if (!user.client)
		return
	user_client = user.client
	add_prog_bar_image_to_client()

/// Adds a smoothly appearing progress bar image to the player's client.
/datum/progressbar/proc/add_prog_bar_image_to_client()
	bar.pixel_y = 0
	bar.alpha = 0
	user_client.images += bar
	animate(bar,
		pixel_y = world.icon_size + offset_y + (height * (listindex - 1)),
		alpha = 255,
		time = animation_time_appear,
		easing = SINE_EASING | EASE_OUT
	)

/// Updates the progress bar's masked fill.
/datum/progressbar/proc/update(progress)
	if (QDELETED(bar_loc))
		qdel(src)
		return

	progress = clamp(progress, 0, goal)
	if (progress == last_progress)
		return
	last_progress = progress
	refresh_fill()

/// Removes and re-adds the fill so its filtered appearance updates immediately.
/datum/progressbar/proc/refresh_fill()
	if (!fill || !bar)
		return
	bar.overlays -= fill
	update_fill(clamp(last_progress / goal, 0, 1))
	bar.overlays += fill

/// Updates the fill image for the current theme.
/datum/progressbar/proc/update_fill(fraction)
	UNLINT(fill?.filters[1]?.x = -fill_width * (1 - fraction))
	if (!stopping)
		fill.color = rgb_gradient(fraction, 0, "#cc0033", 0.25, "#cc6633", 0.5, "#d1cc33", 0.75, "#00cc33")
	else if (last_progress == goal)
		fill.color = COLOR_YELLOW

/// Ends the progress bar and schedules its deletion after the fade animation.
/datum/progressbar/proc/end_progress()
	if (stopping)
		return
	stopping = TRUE
	refresh_fill()
	remove_from_stack()
	animate(bar, alpha = 0, time = animation_time_fade, flags = ANIMATION_PARALLEL)
	QDEL_IN(src, animation_time_fade)

/// Progress bars are generic, so record the target type to make harddel debugging easier.
/datum/progressbar/dump_harddel_info()
	if (harddel_deets_dumped)
		return
	harddel_deets_dumped = TRUE
	return "Owner's type: [location_type]"

/datum/progressbar/default

/datum/progressbar/default/slim
	icon = 'icons/effects/progress_bar/default_slim.dmi'
	height = 5

/// A warning theme that pulses between yellow and red after its halfway point.
/datum/progressbar/warning
	icon = 'icons/effects/progress_bar/warning.dmi'

/datum/progressbar/warning/update_fill(fraction)
	. = ..()
	if (fraction <= 0.5)
		fill.color = COLOR_YELLOW
	else
		fill.color = rgb_gradient(fraction * 10, 0.5, COLOR_YELLOW, 0.5, COLOR_RED, "loop")

/datum/progressbar/warning/slim
	icon = 'icons/effects/progress_bar/warning_slim.dmi'
	height = 5

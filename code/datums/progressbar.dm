#define PROGRESSBAR_HEIGHT 6
#define PROGRESSBAR_ANIMATION_TIME 5

/datum/progressbar
	///The progress bar visual element
	var/image/bar
	///The target where this target bar is applied and where it is shown
	var/atom/bar_loc
	///The mob whose client sees the progress bar
	var/mob/user
	///The client seeing the progress bar
	var/client/user_client
	///Effectively the number of steps the progress bar will need before reaching completion
	var/goal = 1
	///Control check to see if the progress was interrupted before reaching its goal
	var/last_progress = 0
	///Variable to ensure smooth visual stacking on multiple progress bars
	var/listindex = 0
	///The type of our last value for bar_loc, for debugging
	var/location_type
	///Whether to immediately destroy a progress bar when full, rather than wait for an animation
	var/destroy_on_full = FALSE

/datum/progressbar/New(mob/User, goal_number, atom/target)
	. = ..()
	if (!istype(target))
		stack_trace("Invalid target [target] passed in /datum/progressbar")
		qdel(src)
		return
	if (QDELETED(User) || !istype(User))
		stack_trace("[isnull(User) ? "Null" : "Invalid"] user passed in /datum/progressbar")
		qdel(src)
		return
	if (goal_number)
		goal = goal_number
	bar_loc = target
	location_type = bar_loc.type
	bar = image('icons/effects/progressbar.dmi', bar_loc, "prog_bar_0")
	bar.layer = 21 //TODO: Move this to a proper plane and layer when that PR is finished
	bar.appearance_flags = RESET_COLOR|RESET_TRANSFORM|NO_CLIENT_COLOR|RESET_ALPHA|PIXEL_SCALE
	user = User

	LAZYADDASSOCLIST(user.progressbars, bar_loc, src)
	var/list/bars = user.progressbars[bar_loc]
	listindex = bars.len

	if(user)
		user_client = user.client
		addProgBarImageToClient()

	RegisterSignal(user, COMSIG_QDELETING, PROC_REF(onUserDelete))
	RegisterSignal(user, COMSIG_MOB_LOGOUT, PROC_REF(cleanUserClient))
	RegisterSignal(user, COMSIG_MOB_LOGIN, PROC_REF(onUserLogin))

///Updates the progress bar image visually.
/datum/progressbar/proc/update(progress)
	progress = clamp(progress, 0, goal)
	if (progress == last_progress)
		return
	last_progress = progress
	bar.icon_state = "prog_bar_[round(((progress / goal) * 100), 5)]"
	if(destroy_on_full && progress == goal)
		QDEL_IN(src, 5)

///Called on progress end, be it successful or a failure. Wraps up things to delete the datum and bar.
/datum/progressbar/proc/endProgress()
	if(last_progress != goal)
		bar.icon_state = "[bar.icon_state]_fail"

	animate(bar, alpha = 0, time = PROGRESSBAR_ANIMATION_TIME)

	QDEL_IN(src, PROGRESSBAR_ANIMATION_TIME)


/datum/progressbar/Destroy()
	if(user)
		for(var/pb in user.progressbars[bar_loc])
			var/datum/progressbar/progress_bar = pb
			if(progress_bar == src || progress_bar.listindex <= listindex)
				continue
			--listindex
			bar.pixel_y = 32 + (PROGRESSBAR_HEIGHT * (listindex - 1))
			var/dist_to_travel = 32 + (PROGRESSBAR_HEIGHT * (listindex - 1)) - PROGRESSBAR_HEIGHT
			animate(bar, pixel_y = dist_to_travel, time = PROGRESSBAR_ANIMATION_TIME, easing = SINE_EASING)

		LAZYREMOVEASSOC(user.progressbars, bar_loc, src)
		user = null
	if(user_client)
		cleanUserClient()

	bar_loc = null

	if(bar)
		QDEL_NULL(bar)

	return ..()

///Adds a smoothly-appearing progress bar image to the player's screen.
/datum/progressbar/proc/addProgBarImageToClient()
	bar.pixel_y = 0
	bar.alpha = 0
	user_client.images += bar
	animate(bar, pixel_y = 32 + (PROGRESSBAR_HEIGHT * (listindex - 1)), alpha = 255, time = PROGRESSBAR_ANIMATION_TIME, easing = SINE_EASING)

///Called right before the user's Destroy()
/datum/progressbar/proc/onUserDelete(datum/source)
	SIGNAL_HANDLER

	user.progressbars = null //We can simply nuke the list and stop worrying about updating other prog bars if the user itself is gone.
	user = null
	qdel(src)

///Removes the progress bar from the user_client and nulls the variables if it exists
/datum/progressbar/proc/cleanUserClient(datum/source)
	SIGNAL_HANDLER

	if(!user_client) //Disconnected, already gone
		return
	user_client.images -= bar
	user_client = null

///Called by user's Login(), it transfers the progress bar image to the new client.
/datum/progressbar/proc/onUserLogin(datum/source)
	SIGNAL_HANDLER

	// Sanity checking to ensure client is mob and that the client did not log off again
	if(user_client)
		if(user_client == user.client)
			return
		cleanUserClient()
	if(!user.client)
		return

	user_client = user.client
	addProgBarImageToClient()

/datum/progressbar/autocomplete
	destroy_on_full = TRUE

#undef PROGRESSBAR_ANIMATION_TIME
#undef PROGRESSBAR_HEIGHT

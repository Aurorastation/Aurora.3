/** Creates a thinking indicator over the mob. */
/mob/proc/create_thinking_indicator()
	return

/** Removes the thinking indicator over the mob. */
/mob/proc/remove_thinking_indicator()
	return

/** Creates a typing indicator over the mob. */
/mob/proc/create_typing_indicator()
	return

/** Removes the typing indicator over the mob. */
/mob/proc/remove_typing_indicator()
	return

/** Removes any indicators and marks the mob as not speaking IC. */
/mob/proc/remove_all_indicators()
	return

/mob/set_stat(new_stat)
	. = ..()
	if(.)
		remove_all_indicators()

/mob/Logout()
	remove_all_indicators()
	return ..()

/** Sets the mob as "thinking" - with indicator and variable thinking_IC */
/datum/tgui_say/proc/start_thinking()
	if(!window_open || !(client.prefs.toggles & SHOW_TYPING))
		return FALSE
	if(!client.mob.typing_indicator)
		client.mob.typing_indicator = new(null, client.mob)
	client.mob.thinking_IC = TRUE
	client.mob.create_thinking_indicator()

/** Removes typing/thinking indicators and flags the mob as not thinking */
/datum/tgui_say/proc/stop_thinking()
	client.mob?.remove_all_indicators()

/**
 * Handles the user typing. After a brief period of inactivity,
 * signals the client mob to revert to the "thinking" icon.
 */
/datum/tgui_say/proc/start_typing()
	client.mob.remove_thinking_indicator()
	if(!window_open || !client.mob.thinking_IC || !(client.prefs.toggles & SHOW_TYPING))
		return FALSE
	client.mob.create_typing_indicator()
	addtimer(CALLBACK(src, PROC_REF(stop_typing)), 5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_STOPPABLE)

/**
 * Callback to remove the typing indicator after a brief period of inactivity.
 * If the user was typing IC, the thinking indicator is shown.
 */
/datum/tgui_say/proc/stop_typing()
	if(!client?.mob)
		return FALSE
	client.mob.remove_typing_indicator()
	if(!window_open || !client.mob.thinking_IC)
		return FALSE
	client.mob.create_thinking_indicator()

/// Overrides for overlay creation
/mob/living/create_thinking_indicator()
	if((typing_indicator.invisibility != INVISIBILITY_MAXIMUM) || !thinking_IC || stat != CONSCIOUS || !(client.prefs.toggles & SHOW_TYPING))
		return FALSE
	typing_indicator.show_typing_indicator()

/mob/living/remove_thinking_indicator()
	if(!typing_indicator)
		return FALSE
	typing_indicator.hide_typing_indicator()

/*/mob/living/create_typing_indicator()
	if((typing_indicator.invisibility != INVISIBILITY_MAXIMUM) || !thinking_IC || stat != CONSCIOUS || !(client.prefs.toggles & SHOW_TYPING))
		return FALSE
	typing_indicator.show_typing_indicator()

/mob/living/remove_typing_indicator()
	if(!typing_indicator)
		return FALSE
	typing_indicator.hide_typing_indicator()*/

/mob/living/remove_all_indicators()
	thinking_IC = FALSE
	remove_thinking_indicator()
	remove_typing_indicator()


/*
Typing indicators, when a mob uses the F3/F4 keys to bring the say/emote input boxes up this little buddy is
made and follows them around until they are done (or something bad happens), helps tell nearby people that 'hey!
I IS TYPIN'!'
*/

/atom/movable/typing_indicator
	icon = 'icons/mob/talk.dmi'
	icon_state = "typing"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	vis_flags = VIS_INHERIT_ID
	var/atom/movable/master

/atom/movable/typing_indicator/Initialize(ml, _master)
	. = ..()
	master = _master
	if(!ismovable(master))
		stack_trace("Typing indicator initialized with [isnull(master) ? "null" : master] as master.")
		return INITIALIZE_HINT_QDEL
	if(ismob(master))
		var/mob/mob = master
		mob.adjust_typing_indicator_offsets(src)

/atom/movable/typing_indicator/Destroy()
	if(master)
		master.vis_contents -= src
		if(ismob(master))
			var/mob/owner = master
			if(owner.typing_indicator == src)
				owner.typing_indicator = null
	return ..()

/atom/movable/typing_indicator/proc/hide_typing_indicator()
	set waitfor = FALSE
	if(ismob(master))
		var/mob/owner = master
		if(owner.is_typing)
			return
	animate(src, alpha = 0, time = 0.5 SECONDS, easing = EASE_IN)
	sleep(0.5 SECONDS)
	set_invisibility(INVISIBILITY_MAXIMUM)
	if(ismovable(master))
		var/atom/movable/owner = master
		owner.vis_contents -= src

/atom/movable/typing_indicator/proc/show_typing_indicator()

	// Make it visible after being hidden.
	set_invisibility(master.invisibility)

	// Update the appearance.
	if(ismob(master))
		var/mob/owner = master
		var/speech_state_modifier = owner.get_speech_bubble_state_modifier()
		if(speech_state_modifier)
			icon_state = "[speech_state_modifier]_typing"
		else
			icon_state = initial(icon_state)

	if(ismovable(master))
		var/atom/movable/owner = master
		owner.vis_contents += src

	// Animate it popping up from nowhere.
	var/matrix/M = matrix()
	M.Scale(0, 0)
	transform = M
	alpha = 0
	animate(src, transform = 0, alpha = 255, time = 0.2 SECONDS, easing = EASE_IN)

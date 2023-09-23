var/datum/controller/subsystem/typing/SStyping

/datum/controller/subsystem/typing
	name = "Typing"
	flags = SS_BACKGROUND
	wait = 0.5 SECONDS

	/// The skin control to poll for TYPING_STATE_INPUT status.
	var/const/INPUT_HANDLE = "mainwindow.input"
	var/const/INFLIGHT_TIMEOUT = 5 SECONDS
	/// The status entry index of the related client's typing indicator visibility preference.
	var/const/INDEX_PREFERENCE = 1
	/// The status entry index of the inflight state.
	var/const/INDEX_INFLIGHT = 2
	/// The status entry index of the timeout threshold.
	var/const/INDEX_TIMEOUT = 3
	/// The status entry index of the input bar typing state.
	var/const/INDEX_INPUT_STATE = 4
	/// The status entry index of the verb input typing state.
	var/const/INDEX_VERB_STATE = 5
	/// The highest index in a status entry.
	var/const/MAX_INDEX = 5
	/// Matches input bar verbs that should set TYPING_STATE_INPUT.
	var/static/regex/match_verbs
	/// A list of clients waiting to be polled for input state.
	var/list/client/queue = list()
	/// A list of ckey to list, containing current state data. See .proc/get_entry for details.
	var/list/status = list()
	/* example of an entry:
		(ckey = list(
			preference = 0|1,
			inflight = 0|1,
			timeout = num,
			istyping_input = 0|1,
			istyping_hotkey = 0|1
		), ...)
	*/

/datum/controller/subsystem/typing/Initialize(start_timeofday)
	NEW_SS_GLOBAL(SStyping)
	match_verbs = regex("^(Me|Say|Whisper) +\"?\\w+")
	. = ..()

/datum/controller/subsystem/typing/Recover()
	status = list()
	queue = list()

/datum/controller/subsystem/typing/fire(resumed, no_mc_tick)
	if(!resumed)
		queue = global.clients.Copy()
		if(!length(queue))
			return
	var/cut_until = 1
	var/list/entry
	for (var/client/client as anything in queue)
		++cut_until
		if(QDELETED(client))
			continue
		entry = get_client_record(client)
		if(!islist(entry) || !entry[INDEX_PREFERENCE])
			continue
		if(!entry[INDEX_INFLIGHT])
			update_indicator_state_from_winget(client, entry)
		else if(world.time < entry[INDEX_TIMEOUT])
			entry[INDEX_INFLIGHT] = FALSE
		if(no_mc_tick)
			CHECK_TICK
		else if(MC_TICK_CHECK)
			queue.Cut(1, cut_until)
			return
	queue.Cut()

/// Return, generating if necessary, a ckey-indexed list holding typing status.
/datum/controller/subsystem/typing/proc/get_client_record(client/client)
	PRIVATE_PROC(TRUE)
	var/ckey
	if(istext(client))
		ckey = client
	else if(istype(client))
		ckey = client.ckey
	else
		return
	var/list/entry = status[ckey]
	if(!entry)
		entry = new (MAX_INDEX)
		entry[INDEX_PREFERENCE] = !(client.prefs.toggles & SHOW_TYPING)
		entry[INDEX_INFLIGHT] = FALSE
		entry[INDEX_TIMEOUT] = world.time
		entry[INDEX_INPUT_STATE] = FALSE
		entry[INDEX_VERB_STATE] = FALSE
		status[ckey] = entry
	return entry

/// Updates client's preference bool for whether typing indicators should be shown.
/datum/controller/subsystem/typing/proc/update_preference(client/client, preference)
	var/list/entry = get_client_record(client)
	if(islist(entry))
		entry[INDEX_PREFERENCE] = preference
		update_indicator(client, entry)

/// Updates client|ckey's verb typing state to new_state.
/datum/controller/subsystem/typing/proc/set_indicator_state(client/client, state)
	var/list/entry = get_client_record(client)
	if(islist(entry))
		entry[INDEX_VERB_STATE] = state
		update_indicator(client, entry)

/// Request client's input bar state using winget and updating entry accordingly.
/datum/controller/subsystem/typing/proc/update_indicator_state_from_winget(client/client, list/entry)
	PRIVATE_PROC(TRUE)
	set waitfor = FALSE
	var/timeout = world.time + INFLIGHT_TIMEOUT
	entry[INDEX_INFLIGHT] = TRUE
	entry[INDEX_TIMEOUT] = timeout
	var/content = winget(client, INPUT_HANDLE, "text")
	if(timeout != entry[INDEX_TIMEOUT]) // We're stale. Touch nothing.
		return
	entry[INDEX_INFLIGHT] = FALSE
	if(!QDELETED(client))
		entry[INDEX_INPUT_STATE] = match_verbs.Find(content) != 0
		update_indicator(client, entry)

/// Attempt to update the mob's typing state and indicator according to new state.
/datum/controller/subsystem/typing/proc/update_indicator(client/client, list/entry)
	PRIVATE_PROC(TRUE)
	var/mob/target = client.mob
	var/display = (target.stat == CONSCIOUS || isobserver(target)) && entry[INDEX_PREFERENCE] && (entry[INDEX_INPUT_STATE] || entry[INDEX_VERB_STATE]) && isturf(target.loc)
	if(display == target.is_typing)
		return
	if(display)
		if(!target.typing_indicator)
			target.typing_indicator = new(null, target)
		target.is_typing = TRUE
		target.typing_indicator.show_typing_indicator()
	else if(target.typing_indicator)
		target.is_typing = FALSE
		target.typing_indicator.hide_typing_indicator()

/*
Typing indicators, when a mob uses the F3/F4 keys to bring the say/emote input boxes up this little buddy is
made and follows them around until they are done (or something bad happens), helps tell nearby people that 'hey!
I IS TYPIN'!'
Updated 09/10/2022 to include chatbar using Spookerton's SStyping system from Polaris.
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


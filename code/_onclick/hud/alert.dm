//A system to manage and display alerts on screen without needing you to do it yourself

//PUBLIC -  call these wherever you want

/**
 * Proc to create or update an alert. Returns the alert if the alert is new or updated, 0 if it was thrown already
 * category is a text string. Each mob may only have one alert per category; the previous one will be replaced
 * path is a type path of the actual alert type to throw
 * severity is an optional number that will be placed at the end of the icon_state for this alert
 * For example, high pressure's icon_state is "highpressure" and can be serverity 1 or 2 to get "highpressure1" or "highpressure2"
 * new_master is optional and sets the alert's icon state to "template" in the ui_style icons with the master as an overlay.
 * Clicks are forwarded to master
 * Override makes it so the alert is not replaced until cleared by a clear_alert with clear_override, and it's used for hallucinations.
 */
/mob/proc/throw_alert(category, type, severity, obj/new_master, override = FALSE)
	if(!category || QDELETED(src))
		return

	var/atom/movable/screen/alert/thealert
	if(alerts[category])
		thealert = alerts[category]
		if(thealert.override_alerts)
			return FALSE
		if(new_master && new_master != thealert.master)
			WARNING("[src] threw alert [category] with new_master [new_master] while already having that alert with master [thealert.master]")

			clear_alert(category)
			return .()
		else if(thealert.type != type)
			clear_alert(category)
			return .()
		else if(!severity || severity == thealert.severity)
			if(thealert.timeout)
				clear_alert(category)
				return .()
			else //no need to update
				return FALSE
	else
		thealert = new type()
		thealert.override_alerts = override
		if(override)
			thealert.timeout = null
	thealert.owner = src

	if(new_master)
		var/old_layer = new_master.layer
		var/old_plane = new_master.plane
		new_master.layer = FLOAT_LAYER
		new_master.plane = FLOAT_PLANE
		thealert.overlays += new_master
		new_master.layer = old_layer
		new_master.plane = old_plane
		thealert.icon_state = "template" // We'll set the icon to the client's ui pref in reorganize_alerts()
		thealert.master = new_master
	else
		thealert.icon_state = "[initial(thealert.icon_state)][severity]"
		thealert.severity = severity

	alerts[category] = thealert
	if(client && hud_used)
		hud_used.reorganize_alerts()
	thealert.transform = matrix(32, 6, MATRIX_TRANSLATE)
	animate(thealert, transform = matrix(), time = 2.5, easing = CUBIC_EASING)

	if(thealert.timeout)
		addtimer(CALLBACK(src, PROC_REF(alert_timeout), thealert, category), thealert.timeout)
		thealert.timeout = world.time + thealert.timeout - world.tick_lag
	thealert.alert_post_setup(src)
	return thealert

/mob/proc/alert_timeout(atom/movable/screen/alert/alert, category)
	if(alert.timeout && alerts[category] == alert && world.time >= alert.timeout)
		clear_alert(category)

// Proc to clear an existing alert.
/mob/proc/clear_alert(category, clear_override = FALSE)
	var/atom/movable/screen/alert/alert = alerts[category]
	if(!alert)
		return FALSE
	if(alert.override_alerts && !clear_override)
		return FALSE

	alerts -= category
	if(client && hud_used)
		hud_used.reorganize_alerts()
		client.remove_from_screen(alert)
	qdel(alert)

/atom/movable/screen/alert
	icon = 'icons/mob/screen_alert.dmi'
	icon_state = "default"
	name = "Alert"
	desc = "Something seems to have gone wrong with this alert, so report this bug please."
	mouse_opacity = MOUSE_OPACITY_ICON
	/// If set to a number, this alert will clear itself after that many deciseconds
	var/timeout = 0
	var/severity = 0
	var/alerttooltipstyle = ""
	/// If it is overriding other alerts of the same type
	var/override_alerts = FALSE
	/// Alert owner
	var/mob/owner

/atom/movable/screen/alert/MouseEntered(location,control,params)
	. = ..()
	if(!QDELETED(src))
		openToolTip(usr, src, params, title = name, content = desc, theme = alerttooltipstyle)

/atom/movable/screen/alert/MouseExited(location, control, params)
	. = ..()
	closeToolTip(usr)

/// Called by throw_alert(), passes the mob throw_alert() is being called on as an arg. Parent proc, does nothing.
/atom/movable/screen/alert/proc/alert_post_setup(mob/user)
	SIGNAL_HANDLER
	return

/atom/movable/screen/alert/notify_action
	name = "Notification"
	desc = "A new notification."
	icon_state = "template"
	timeout = 15 SECONDS
	var/datum/weakref/target_ref
	var/action = NOTIFY_JUMP

/atom/movable/screen/alert/notify_action/Click()
	. = ..()
	if(!usr || !usr.client || usr != owner)
		return
	var/atom/target = target_ref?.resolve()
	if(!target)
		return
	var/mob/abstract/ghost/ghost_user = usr
	if(!istype(ghost_user))
		return
	switch(action)
		if(NOTIFY_ATTACK)
			target.attack_ghost(ghost_user)
		if(NOTIFY_JUMP)
			var/turf/gotten_turf = get_turf(target)
			if(gotten_turf && isturf(gotten_turf))
				ghost_user.abstract_move(gotten_turf)
		//if(NOTIFY_ORBIT)
		//	ghost_user.do_observe(target)

/atom/movable/screen/alert/buckled
	name = "Buckled"
	desc = "You've been buckled to something. Click the alert to unbuckle unless you're handcuffed."
	icon_state = ALERT_BUCKLED

/atom/movable/screen/alert/buckled/Click(location, control, params)
	. = ..()
	var/mob/living/living_mob = usr
	if(!istype(living_mob) || living_mob != owner)
		return
	living_mob.execute_resist()

/atom/movable/screen/alert/restrained/handcuffed
	name = "Handcuffed"
	desc = "You're handcuffed and can't act. If anyone drags you, you won't be able to move. Click the alert to free yourself."

/atom/movable/screen/alert/restrained/legcuffed
	name = "Legcuffed"
	desc = "You're legcuffed, which slows you down considerably. Click the alert to free yourself."

/atom/movable/screen/alert/restrained/Click(location, control, params)
	. = ..()
	var/mob/living/carbon/carbon_mob = usr
	if(!istype(carbon_mob) || carbon_mob != owner)
		return
	carbon_mob.execute_resist()

/// Gives the player the option to succumb while in critical condition (without relying on verbs)
/atom/movable/screen/alert/succumb
	name = "Succumb"
	desc = "Shuffle off this mortal coil."
	icon_state = "succumb"

/atom/movable/screen/alert/succumb/Click()
	if (isobserver(usr))
		return

	var/mob/living/living_owner = owner
	if(!istype(living_owner))
		return

	living_owner.succumb()

/atom/movable/screen/alert/fire
	name = "On Fire!"
	desc = "You are currently on fire! Click to Stop, drop and roll to put the fire out or move to a vacuum area."
	icon_state = "fire"

/atom/movable/screen/alert/fire/Click()
	if (isobserver(usr))
		return

	var/mob/living/living_owner = owner
	if(!istype(living_owner))
		return

	living_owner.execute_resist()

// PRIVATE = only edit, use, or override these if you're editing the system as a whole

// Re-render all alerts - also called in /mob/verb/button_pressed_F12() because it's needed there
/datum/hud/proc/reorganize_alerts()
	var/mob/screenmob = mymob
	if(!screenmob.client)
		return
	var/list/alerts = mymob.alerts
	if(!hud_shown)
		for(var/i = 1, i <= length(alerts), i++)
			screenmob.client.screen -= alerts[alerts[i]]
		return TRUE
	for(var/i = 1, i <= length(alerts), i++)
		var/atom/movable/screen/alert/alert = alerts[alerts[i]]
		if(alert.icon_state != "default" && alert.icon_state != "template")
			var/mutable_appearance/alert_underlay = mutable_appearance(ui_style2icon(mymob.client.prefs.UI_style), "template", FLOAT_LAYER, FLOAT_PLANE, alpha = mymob.client.prefs.UI_style_alpha)
			alert_underlay.color = mymob.client.prefs.UI_style_color
			alert.underlays += alert_underlay
			alert.alpha = mymob.client.prefs.UI_style_alpha
		else if (alert.icon_state == "default")
			alert.alpha = mymob.client.prefs.UI_style_alpha
		else if (alert.icon_state == "template")
			alert.icon = ui_style2icon(mymob.client.prefs.UI_style)
			alert.color = mymob.client.prefs.UI_style_color
			alert.alpha = mymob.client.prefs.UI_style_alpha
		switch(i)
			if(1)
				. = ui_alert1
			if(2)
				. = ui_alert2
			if(3)
				. = ui_alert3
			if(4)
				. = ui_alert4
			if(5)
				. = ui_alert5 // Right now there's 5 slots
			else
				. = ""
		alert.screen_loc = .
		screenmob.client.screen |= alert
	return TRUE

/atom/movable/screen/alert/Click(location, control, params)
	if(!usr || !usr.client)
		return FALSE
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, SHIFT_CLICK)) // screen objects don't do the normal Click() stuff so we'll cheat
		to_chat(usr, SPAN_BOLDNOTICE("[name]</span> - <span class='info'>[desc]"))
		return FALSE
	if(usr != owner)
		return
	if(master)
		return usr.client.Click(master, location, control, params)

	return TRUE

/atom/movable/screen/alert/Destroy()
	. = ..()
	severity = 0
	master = null
	owner = null
	screen_loc = ""

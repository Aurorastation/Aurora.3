/obj/aiming_overlay
	name = ""
	desc = "Stick 'em up!"
	icon = 'icons/effects/Targeted.dmi'
	icon_state = "locking"
	anchored = 1
	density = 0
	opacity = 0
	layer = FLY_LAYER
	appearance_flags = NO_CLIENT_COLOR
	simulated = 0
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	///The `/mob/living` we are currently targeting, if any
	var/mob/living/aiming_at

	///The `/obj/item` we are using to target with, if any
	var/obj/item/aiming_with

	///Who do we belong to?
	var/mob/living/owner

	///Boolean, if the target referred by `aiming_at` has been locked onto
	var/locked = FALSE

	///The time, relative to `world.time`, at which the target referred by `aiming_at` will be locked onto
	var/lock_time = 0

	///Boolean, if `TRUE` aiming is performed instead of shooting
	var/active = FALSE

	///A list of permissions granted to the target, see `code\__DEFINES\targeting.dm`
	var/target_permissions = TARGET_CAN_MOVE | TARGET_CAN_CLICK | TARGET_CAN_RADIO

	///The time, relative to `world.time`, after which we can re-aim
	var/aimcooldown

/obj/aiming_overlay/Initialize(mapload, ...)
	. = ..()

	if(!isliving(loc))
		stack_trace("Trying to create an aiming overlay with a location that is not /mob/living!")
		return INITIALIZE_HINT_QDEL

	owner = loc
	loc = null
	verbs.Cut()

/obj/aiming_overlay/Destroy()
	cancel_aiming(TRUE)

	toggle_active(FALSE)
	if(owner?.aiming == src)
		owner.aiming = null

	owner = null

	//Since cancel_aiming() might early return if aiming_at *OR* aiming_with are not set, we clear the refs here
	aiming_at = null
	aiming_with = null

	. = ..()

/obj/aiming_overlay/proc/toggle_permission(perm)

	if(target_permissions & perm)
		target_permissions &= ~perm
	else
		target_permissions |= perm

	// Update HUD icons.
	if(owner.gun_move_icon)
		if(!(target_permissions & TARGET_CAN_MOVE))
			owner.gun_move_icon.icon_state = "no_walk0"
			owner.gun_move_icon.name = "Allow Movement"
		else
			owner.gun_move_icon.icon_state = "no_walk1"
			owner.gun_move_icon.name = "Disallow Movement"

	if(owner.item_use_icon)
		if(!(target_permissions & TARGET_CAN_CLICK))
			owner.item_use_icon.icon_state = "no_item0"
			owner.item_use_icon.name = "Allow Item Use"
		else
			owner.item_use_icon.icon_state = "no_item1"
			owner.item_use_icon.name = "Disallow Item Use"

	if(owner.radio_use_icon)
		if(!(target_permissions & TARGET_CAN_RADIO))
			owner.radio_use_icon.icon_state = "no_radio0"
			owner.radio_use_icon.name = "Allow Radio Use"
		else
			owner.radio_use_icon.icon_state = "no_radio1"
			owner.radio_use_icon.name = "Disallow Radio Use"

	var/message = "no longer permitted to "
	var/use_span = "warning"
	if(target_permissions & perm)
		message = "now permitted to "
		use_span = "notice"

	switch(perm)
		if(TARGET_CAN_MOVE)
			message += "move"
		if(TARGET_CAN_CLICK)
			message += "use items"
		if(TARGET_CAN_RADIO)
			message += "use a radio"
		else
			return

	var/a_certain_scientific_railgun = (aiming_at ? "\The [aiming_at] is" : "Your targets are")
	to_chat(owner, "<span class='[use_span]'> [a_certain_scientific_railgun] [message].</span>")
	if(aiming_at)
		to_chat(aiming_at, "<span class='[use_span]'>You are [message].</span>")

/obj/aiming_overlay/process()
	if(QDELETED(owner) || QDELETED(aiming_at) || QDELETED(aiming_with))
		qdel(src)
		return
	..()
	update_aiming()

/obj/aiming_overlay/proc/update_aiming_deferred()
	set waitfor = 0
	sleep(0)
	update_aiming()

/obj/aiming_overlay/proc/update_aiming()

	if(QDELETED(owner))
		qdel(src)
		return

	if(QDELETED(aiming_at))
		cancel_aiming()
		return

	if(!locked && lock_time >= world.time)
		locked = TRUE
		update_icon()

	var/cancel_aim = TRUE

	if(!(aiming_with in owner) || (istype(owner, /mob/living/carbon/human) && (owner.l_hand != aiming_with && owner.r_hand != aiming_with)))
		FEEDBACK_FAILURE(owner, "You must keep hold of your weapon!")
	else if(owner.eye_blind)
		FEEDBACK_FAILURE(owner, "You are blind and cannot see your target!")
	else if(!aiming_at || !istype(aiming_at.loc, /turf))
		FEEDBACK_FAILURE(owner, "You have lost sight of your target!")
	else if(owner.incapacitated() || owner.lying || owner.restrained())
		FEEDBACK_FAILURE(owner, "You must be conscious and standing to keep track of your target!")
	else if(aiming_at.is_invisible_to(owner))
		FEEDBACK_FAILURE(owner, "Your target has become invisible!")
	else if(!(aiming_at in view(owner)))
		FEEDBACK_FAILURE(owner, "Your target is too far away to track!")
	else
		cancel_aim = FALSE

	forceMove(get_turf(aiming_at))

	if(cancel_aim)
		cancel_aiming()
		return

	if(!owner.incapacitated() && owner.client)
		spawn(0)
			owner.set_dir(get_dir(get_turf(owner), get_turf(src)))

/obj/aiming_overlay/proc/aim_at(mob/target, obj/thing)

	if(QDELETED(target))
		return

	if (aimcooldown > world.time)
		return

	if(!owner)
		return

	if(owner.incapacitated())
		FEEDBACK_FAILURE(owner, "You cannot aim a gun in your current state.")
		return
	if(owner.lying)
		FEEDBACK_FAILURE(owner, "You cannot aim a gun while lying down.")
		return
	if(owner.restrained())
		FEEDBACK_FAILURE(owner, "You cannot aim a gun while handcuffed.")
		return

	if(aiming_at)
		if(aiming_at == target)
			return
		cancel_aiming(TRUE)
		owner.visible_message(SPAN_DANGER("\The [owner] turns \the [thing] on \the [target]!"))
	else
		owner.visible_message(SPAN_DANGER("\The [owner] aims \the [thing] at \the [target]!"))

	if(owner.client)
		owner.client.add_gun_icons()
	to_chat(target, SPAN_DANGER("You now have a gun pointed at you. No sudden moves!"))
	aiming_with = thing
	aiming_at = target
	if(istype(aiming_with, /obj/item/gun))
		playsound(get_turf(owner), 'sound/weapons/TargetOn.ogg', 50,1)

	admin_attack_log(owner, aiming_at, "\The [owner] is aiming at \the [aiming_at] with \the [aiming_with].", "\The [owner] is aiming at \the [aiming_at] with \the [aiming_with].", "\The [owner] is aiming at \the [aiming_at] with \the [aiming_with].")

	forceMove(get_turf(target))
	START_PROCESSING(SSprocessing, src)

	LAZYDISTINCTADD(aiming_at.aimed_at_by, src)
	toggle_active(TRUE)
	locked = 0
	update_icon()
	lock_time = world.time + 35
	GLOB.moved_event.register(owner, src, PROC_REF(update_aiming))
	GLOB.moved_event.register(aiming_at, src, PROC_REF(target_moved))
	GLOB.destroyed_event.register(aiming_at, src, PROC_REF(cancel_aiming))

/obj/aiming_overlay/proc/aim_cooldown(seconds)
	aimcooldown = world.time + seconds SECONDS

/obj/aiming_overlay/update_icon()
	if(locked)
		icon_state = "locked"
	else
		icon_state = "locking"

/obj/aiming_overlay/proc/toggle_active(force_state = null)
	if(!isnull(force_state))
		if(active == force_state)
			return
		active = force_state
	else
		active = !active

	if(!active)
		cancel_aiming()

	if(owner.client)
		if(active)
			balloon_alert(owner, "now aiming")
			owner.client.add_gun_icons()
		else
			balloon_alert(owner, "now firing")
			owner.client.remove_gun_icons()
		owner.gun_setting_icon.icon_state = "gun[active]"

/obj/aiming_overlay/proc/cancel_aiming(no_message = FALSE)
	if(!aiming_with || !aiming_at)
		return
	admin_attack_log(owner, aiming_at, "\The [owner] is no longer aiming at \the [aiming_at] with \the [aiming_with].", "\The [owner] is no longer aiming at \the [aiming_at] with \the [aiming_with].", "\The [owner] is no longer aiming at \the [aiming_at] with \the [aiming_with].")
	if(istype(aiming_with, /obj/item/gun))
		playsound(get_turf(owner), 'sound/weapons/TargetOff.ogg', 50,1)
	if(!no_message)
		owner.visible_message(
			SPAN_NOTICE("\The [owner] lowers \the [aiming_with]."),
			SPAN_NOTICE("You lower \the [aiming_with].")
		)

	GLOB.moved_event.unregister(owner, src)
	if(aiming_at)
		GLOB.moved_event.unregister(aiming_at, src)
		GLOB.destroyed_event.unregister(aiming_at, src)
		LAZYREMOVE(aiming_at.aimed_at_by, src)
		aiming_at = null

	aiming_with = null
	loc = null
	STOP_PROCESSING(SSprocessing, src)

/obj/aiming_overlay/proc/target_moved()
	update_aiming()
	trigger(TARGET_CAN_MOVE)


// Optional continuous feeding. Does not load magazines or create ammunition.
/datum/component/weapon_feed_assist
	dupe_mode = COMPONENT_DUPE_UNIQUE
	VAR_PRIVATE/mob/living/assistant
	VAR_PRIVATE/feeding_active = FALSE
	VAR_PRIVATE/assistant_pixel_offset_x = 0
	VAR_PRIVATE/assistant_pixel_offset_y = 0
	/// Invalidates interrupted setup attempts, including a restart by the same assistant.
	VAR_PRIVATE/assistance_revision = 0
	VAR_FINAL/setup_time = 2 SECONDS
	VAR_FINAL/feed_reach_offset = 16
	VAR_FINAL/delay_multiplier = 0.75

/datum/component/weapon_feed_assist/Initialize(_delay_multiplier = 0.75)
	if(!istype(parent, /obj/item/gun) || !isnum(_delay_multiplier) || _delay_multiplier <= 0 || _delay_multiplier > 1)
		return COMPONENT_INCOMPATIBLE
	delay_multiplier = _delay_multiplier

/datum/component/weapon_feed_assist/RegisterWithParent()
	RegisterSignal(parent, COMSIG_GUN_ASSIST_INTERACT, PROC_REF(on_interact))
	RegisterSignal(parent, COMSIG_GUN_FIRE_DELAY, PROC_REF(adjust_fire_delay))
	RegisterSignals(parent, list(COMSIG_GUN_USER_CHANGED, COMSIG_MOVABLE_MOVED, COMSIG_GUN_RELOAD_STARTED), PROC_REF(stop_assisting))
	RegisterSignal(parent, COMSIG_QDELETING, PROC_REF(stop_assisting))

/datum/component/weapon_feed_assist/UnregisterFromParent()
	stop_assisting()
	UnregisterSignal(parent, list(COMSIG_GUN_ASSIST_INTERACT, COMSIG_GUN_FIRE_DELAY, COMSIG_GUN_USER_CHANGED, COMSIG_MOVABLE_MOVED, COMSIG_QDELETING, COMSIG_GUN_RELOAD_STARTED))
	return ..()

/datum/component/weapon_feed_assist/Destroy(force)
	stop_assisting()
	return ..()

/datum/component/weapon_feed_assist/proc/can_assist(mob/living/user)
	PRIVATE_PROC(TRUE)
	var/obj/item/gun/gun = parent
	var/mob/living/gunner = gun.get_gun_user()
	var/obj/support = gun.loc
	if(QDELETED(user) || !isobj(support) || QDELETED(gunner) || user == gunner || !gun.can_use_gun_action(gunner))
		return FALSE
	if(!user.client || user.lying || user.resting || support.use_check(user) || user.get_active_hand() || user.get_inactive_hand())
		return FALSE
	return user.loc == get_step(support, turn(support.dir, 90)) || user.loc == get_step(support, turn(support.dir, -90))

/datum/component/weapon_feed_assist/proc/on_interact(datum/source, mob/living/user)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	if(user == assistant)
		stop_assisting()
		return COMPONENT_GUN_ASSIST_HANDLED
	if(!can_assist(user))
		return NONE
	var/obj/item/gun/gun = parent
	if(assistant)
		gun.balloon_alert(user, "already being fed!")
		return COMPONENT_GUN_ASSIST_HANDLED
	assistant = user
	var/revision = ++assistance_revision
	RegisterSignals(user, list(COMSIG_MOVABLE_MOVED, COMSIG_MOB_RESTED, COMSIG_MOB_EQUIPPED_ITEM), PROC_REF(validate_assistant))
	RegisterSignals(user, list(COMSIG_MOB_RESISTED, COMSIG_MOB_LYING_DOWN, COMSIG_LIVING_DEATH, COMSIG_QDELETING, COMSIG_GUN_USER_SET), PROC_REF(stop_assisting))
	RegisterSignal(user, COMSIG_MOB_WEAPON_ASSIST_START, PROC_REF(on_other_assistance))
	SEND_SIGNAL(user, COMSIG_MOB_WEAPON_ASSIST_START, gun)
	if(QDELETED(src) || assistant != user || assistance_revision != revision)
		return COMPONENT_GUN_ASSIST_HANDLED
	START_PROCESSING(SSprocessing, src)
	INVOKE_ASYNC(src, PROC_REF(begin_assisting), user, revision)
	return COMPONENT_GUN_ASSIST_HANDLED

/datum/component/weapon_feed_assist/proc/begin_assisting(mob/living/user, revision)
	PRIVATE_PROC(TRUE)
	var/obj/item/gun/gun = parent
	gun.balloon_alert(user, "preparing to feed...")
	var/completed = do_after(user, setup_time, gun, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PLACE_PROGRESSBAR_ON_USER, extra_checks = CALLBACK(src, PROC_REF(is_current_assistant), user, revision))
	if(QDELETED(src) || assistant != user || assistance_revision != revision)
		return
	if(!completed || !can_assist(user))
		stop_assisting()
		return
	feeding_active = TRUE
	var/direction = get_dir(user, gun.loc)
	switch(direction)
		if(NORTH)
			assistant_pixel_offset_y = feed_reach_offset
		if(SOUTH)
			assistant_pixel_offset_y = -feed_reach_offset
		if(EAST)
			assistant_pixel_offset_x = feed_reach_offset
		if(WEST)
			assistant_pixel_offset_x = -feed_reach_offset
	user.pixel_x += assistant_pixel_offset_x
	user.pixel_y += assistant_pixel_offset_y
	user.set_dir(direction)
	if(QDELETED(src) || assistant != user || assistance_revision != revision)
		return
	gun.balloon_alert(user, "feeding belt")
	gun.balloon_alert(gun.get_gun_user(), "belt feeding assisted")

/datum/component/weapon_feed_assist/proc/is_current_assistant(mob/living/user, revision)
	PRIVATE_PROC(TRUE)
	return assistant == user && assistance_revision == revision && can_assist(user)

/datum/component/weapon_feed_assist/proc/stop_assisting(datum/source)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	STOP_PROCESSING(SSprocessing, src)
	var/mob/living/old_assistant = assistant
	var/was_feeding = feeding_active
	var/offset_x = assistant_pixel_offset_x
	var/offset_y = assistant_pixel_offset_y
	assistant = null
	feeding_active = FALSE
	assistant_pixel_offset_x = 0
	assistant_pixel_offset_y = 0
	assistance_revision++
	if(!old_assistant)
		return
	UnregisterSignal(old_assistant, list(COMSIG_MOVABLE_MOVED, COMSIG_MOB_RESTED, COMSIG_MOB_EQUIPPED_ITEM, COMSIG_MOB_RESISTED, COMSIG_MOB_LYING_DOWN, COMSIG_LIVING_DEATH, COMSIG_QDELETING, COMSIG_GUN_USER_SET, COMSIG_MOB_WEAPON_ASSIST_START))
	if(!QDELETED(old_assistant))
		old_assistant.pixel_x -= offset_x
		old_assistant.pixel_y -= offset_y
	if(!QDELETED(parent) && !QDELETED(old_assistant))
		var/obj/item/gun/gun = parent
		gun.balloon_alert(old_assistant, was_feeding ? "stopped feeding" : "feeding cancelled")

/datum/component/weapon_feed_assist/proc/validate_assistant(datum/source)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	if(assistant && !can_assist(assistant))
		stop_assisting()

/datum/component/weapon_feed_assist/proc/on_other_assistance(datum/source, obj/item/gun/gun)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	if(gun != parent)
		stop_assisting()

/datum/component/weapon_feed_assist/proc/adjust_fire_delay(datum/source, delay)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	if(feeding_active && assistant && can_assist(assistant))
		*delay = max(world.tick_lag, *delay * delay_multiplier)

/datum/component/weapon_feed_assist/process(seconds_per_tick)
	if(!assistant)
		return PROCESS_KILL
	validate_assistant()

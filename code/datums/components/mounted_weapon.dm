/// Operator control for a gun retained inside a support, independent of how it was installed.
/datum/component/mounted_weapon
	dupe_mode = COMPONENT_DUPE_UNIQUE
	VAR_PRIVATE/obj/item/gun/weapon
	VAR_PRIVATE/mob/living/operator
	/// Optional replacement for the default anchored stand and rear-tile position check.
	/// Called with (user, weapon, support); vehicles can validate their authorized rider here.
	VAR_PRIVATE/datum/callback/operator_check
	VAR_PRIVATE/require_free_hands = TRUE
	/// Fixed emplacements move the operator onto the support; vehicle seats can opt out.
	VAR_PRIVATE/reposition_operator = TRUE
	VAR_PRIVATE/operator_positioned = FALSE
	VAR_PRIVATE/operator_pixel_offset_x = 0
	VAR_PRIVATE/operator_pixel_offset_y = 0
	/// Detects synchronous signal listeners ending or replacing an operator session.
	VAR_PRIVATE/operation_revision = 0
	VAR_PRIVATE/client/input_client
	VAR_PRIVATE/trigger_held = FALSE
	VAR_PRIVATE/firing_request = FALSE
	VAR_PRIVATE/trigger_revision = 0
	VAR_PRIVATE/atom/fire_target
	VAR_PRIVATE/list/fire_modifiers
	/// Traverse allowed on either side of the support's facing, in degrees.
	VAR_FINAL/half_firing_arc = 45
	VAR_FINAL/operator_handle_offset = 16

/datum/component/mounted_weapon/Initialize(obj/item/gun/_weapon, datum/callback/_operator_check, _require_free_hands = TRUE, _reposition_operator = TRUE)
	if(!isobj(parent) || !istype(_weapon) || QDELETED(_weapon) || _weapon.loc != parent)
		return COMPONENT_INCOMPATIBLE
	weapon = _weapon
	operator_check = _operator_check
	require_free_hands = _require_free_hands
	reposition_operator = _reposition_operator

/datum/component/mounted_weapon/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOUNTED_WEAPON_INTERACT, PROC_REF(on_interact))
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(validate_operator))
	RegisterSignal(parent, COMSIG_ATOM_DIR_CHANGE, PROC_REF(on_support_turn))
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_QDELETING, PROC_REF(on_support_deleted))
	RegisterSignal(parent, COMSIG_ATOM_ITEM_INTERACTION, PROC_REF(on_reload_item))
	RegisterSignal(parent, COMSIG_MOUNTED_WEAPON_RELOAD, PROC_REF(on_reload_action))
	RegisterSignal(parent, COMSIG_MOUNTED_WEAPON_EJECT, PROC_REF(on_eject_action))
	RegisterSignal(weapon, COMSIG_MOVABLE_MOVED, PROC_REF(on_weapon_moved))
	RegisterSignal(weapon, COMSIG_GUN_USER_CHANGED, PROC_REF(on_gun_user_changed))
	RegisterSignal(weapon, COMSIG_QDELETING, PROC_REF(on_weapon_deleted))
	RegisterSignal(weapon, COMSIG_GUN_FIRE_CHECK, PROC_REF(check_fire))
	RegisterSignal(weapon, COMSIG_GUN_RELOAD_STARTED, PROC_REF(stop_firing))

/datum/component/mounted_weapon/UnregisterFromParent()
	release_operator()
	UnregisterSignal(parent, list(COMSIG_MOUNTED_WEAPON_INTERACT, COMSIG_MOVABLE_MOVED, COMSIG_ATOM_DIR_CHANGE, COMSIG_ATOM_EXAMINE, COMSIG_QDELETING, COMSIG_ATOM_ITEM_INTERACTION, COMSIG_MOUNTED_WEAPON_RELOAD, COMSIG_MOUNTED_WEAPON_EJECT))
	if(weapon)
		UnregisterSignal(weapon, list(COMSIG_MOVABLE_MOVED, COMSIG_GUN_USER_CHANGED, COMSIG_QDELETING, COMSIG_GUN_FIRE_CHECK, COMSIG_GUN_RELOAD_STARTED))
	weapon = null
	operator_check = null
	return ..()

/datum/component/mounted_weapon/Destroy(force)
	release_operator()
	return ..()

/datum/component/mounted_weapon/proc/get_operator()
	return operator

/datum/component/mounted_weapon/proc/toggle_operator(mob/living/user)
	if(operator == user)
		release_operator()
		return TRUE
	var/obj/support = parent
	if(operator && user != operator && (SEND_SIGNAL(weapon, COMSIG_GUN_ASSIST_INTERACT, user) & COMPONENT_GUN_ASSIST_HANDLED))
		return TRUE
	if(operator || weapon?.get_gun_user())
		support.balloon_alert(user, "gun already in use!")
		return FALSE
	if(!can_operate(user, TRUE))
		support.balloon_alert(user, "can't man the gun here!")
		return FALSE
	var/list/controlled = list()
	SEND_SIGNAL(user, COMSIG_MOB_GET_MOUNTED_GUN, controlled)
	if(controlled["gun"])
		support.balloon_alert(user, "release the other gun first!")
		return FALSE

	operator = user
	var/revision = ++operation_revision
	input_client = user.client
	if(reposition_operator && !position_operator(user))
		if(!QDELETED(src) && operation_revision == revision)
			release_operator()
		return FALSE
	if(QDELETED(src) || operation_revision != revision)
		return FALSE
	RegisterSignals(user, list(COMSIG_MOVABLE_MOVED, COMSIG_MOB_RESTED, COMSIG_MOB_EQUIPPED_ITEM), PROC_REF(validate_operator))
	RegisterSignals(user, list(COMSIG_MOB_RESISTED, COMSIG_MOB_LYING_DOWN, COMSIG_LIVING_DEATH, COMSIG_QDELETING), PROC_REF(on_operator_exit))
	RegisterSignal(user, COMSIG_GUN_USER_SET, PROC_REF(on_other_gun_used))
	RegisterSignal(user, COMSIG_MOB_GET_MOUNTED_GUN, PROC_REF(get_controlled_gun))
	RegisterSignal(user, COMSIG_MOB_CLICKON, PROC_REF(on_operator_click))
	RegisterSignal(input_client, COMSIG_CLIENT_MOUSEDOWN, PROC_REF(on_mouse_down))
	RegisterSignal(input_client, COMSIG_CLIENT_MOUSEUP, PROC_REF(on_mouse_up))
	RegisterSignal(input_client, COMSIG_CLIENT_MOUSEDRAG, PROC_REF(on_mouse_drag))
	var/bound = weapon.set_gun_user(user)
	if(QDELETED(src) || operation_revision != revision)
		return FALSE
	if(!bound || weapon.get_gun_user() != user || !can_operate(user))
		release_operator()
		return FALSE
	START_PROCESSING(SSprocessing, src)
	user.set_dir(support.dir)
	if(QDELETED(src) || operation_revision != revision)
		return FALSE
	support.balloon_alert(user, "manning gun")
	playsound(support, 'sound/weapons/thudswoosh.ogg', 25, TRUE, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)
	user.hud_used?.update_gun_actions()
	return TRUE

/datum/component/mounted_weapon/proc/release_operator()
	var/mob/living/old_operator = operator
	operator = null
	operation_revision++
	stop_firing()
	STOP_PROCESSING(SSprocessing, src)
	if(input_client)
		UnregisterSignal(input_client, list(COMSIG_CLIENT_MOUSEDOWN, COMSIG_CLIENT_MOUSEUP, COMSIG_CLIENT_MOUSEDRAG))
		input_client = null
	if(!old_operator)
		return
	UnregisterSignal(old_operator, list(COMSIG_MOVABLE_MOVED, COMSIG_MOB_RESTED, COMSIG_MOB_EQUIPPED_ITEM, COMSIG_MOB_RESISTED, COMSIG_MOB_LYING_DOWN, COMSIG_LIVING_DEATH, COMSIG_QDELETING, COMSIG_GUN_USER_SET, COMSIG_MOB_GET_MOUNTED_GUN, COMSIG_MOB_CLICKON))
	restore_operator_position(old_operator)
	// Clear only this session's binding; another listener may have reassigned the gun.
	if(!operator && !QDELETED(weapon) && weapon.get_gun_user() == old_operator)
		weapon.set_gun_user(null)
	if(!operator && !QDELETED(src) && !QDELETED(parent) && !QDELETED(old_operator))
		old_operator.hud_used?.update_gun_actions()
		var/obj/support = parent
		support.balloon_alert(old_operator, "released gun")

/datum/component/mounted_weapon/proc/can_operate(mob/living/user, entering = FALSE)
	PRIVATE_PROC(TRUE)
	var/obj/support = parent
	if(QDELETED(user) || QDELETED(support) || QDELETED(weapon) || weapon.loc != support)
		return FALSE
	if(!user.client || (operator == user && input_client != user.client) || user.lying || user.resting || support.use_check(user, USE_ALLOW_NON_ADJACENT))
		return FALSE
	if(require_free_hands && (user.get_active_hand() || user.get_inactive_hand()))
		if(!(SEND_SIGNAL(weapon, COMSIG_GUN_ALLOW_RELOAD_HANDS, user) & COMPONENT_ALLOW_RELOAD_HANDS))
			return FALSE
	if(operator_check)
		return operator_check.Invoke(user, weapon, support)
	var/turf/required_position = entering || !reposition_operator ? get_step(support, turn(support.dir, 180)) : support.loc
	return isturf(support.loc) && support.anchored && user.loc == required_position && support.Adjacent(user)

/datum/component/mounted_weapon/proc/position_operator(mob/living/user)
	PRIVATE_PROC(TRUE)
	var/obj/support = parent
	var/turf/destination = get_turf(support)
	var/previous_density = support.density
	operator_positioned = TRUE
	support.set_density(FALSE)
	var/moved = !QDELETED(src) && !QDELETED(user) && user.Move(destination)
	if(!QDELETED(support))
		support.set_density(previous_density)
	if(QDELETED(src) || QDELETED(user) || QDELETED(support) || operator != user || !moved || user.loc != destination)
		return FALSE
	switch(support.dir)
		if(NORTH)
			operator_pixel_offset_y = -operator_handle_offset
		if(SOUTH)
			operator_pixel_offset_y = operator_handle_offset
		if(EAST)
			operator_pixel_offset_x = -operator_handle_offset
		if(WEST)
			operator_pixel_offset_x = operator_handle_offset
	user.pixel_x += operator_pixel_offset_x
	user.pixel_y += operator_pixel_offset_y
	return TRUE

/datum/component/mounted_weapon/proc/restore_operator_position(mob/living/user)
	PRIVATE_PROC(TRUE)
	var/was_positioned = operator_positioned
	var/offset_x = operator_pixel_offset_x
	var/offset_y = operator_pixel_offset_y
	operator_positioned = FALSE
	operator_pixel_offset_x = 0
	operator_pixel_offset_y = 0
	if(!was_positioned || QDELETED(user))
		return
	user.pixel_x -= offset_x
	user.pixel_y -= offset_y
	var/obj/support = parent
	if(support && user.loc == support.loc && isturf(support.loc))
		user.Move(get_step(support, turn(support.dir, 180)))

/datum/component/mounted_weapon/process(seconds_per_tick)
	if(!operator)
		return PROCESS_KILL
	validate_operator()

/datum/component/mounted_weapon/proc/validate_operator(datum/source)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	if(operator && (!can_operate(operator) || weapon.get_gun_user() != operator))
		release_operator()

/datum/component/mounted_weapon/proc/on_interact(datum/source, mob/living/user)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	toggle_operator(user)
	return COMPONENT_MOUNTED_WEAPON_HANDLED

/datum/component/mounted_weapon/proc/on_operator_exit(datum/source)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	release_operator()

/datum/component/mounted_weapon/proc/on_other_gun_used(mob/living/source, obj/item/gun/other_weapon)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	if(other_weapon != weapon)
		release_operator()

/datum/component/mounted_weapon/proc/on_gun_user_changed(obj/item/gun/source, mob/living/old_user, mob/living/new_user)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	if(operator && new_user != operator)
		release_operator()

/datum/component/mounted_weapon/proc/on_support_turn(datum/source, old_dir, new_dir)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	if(old_dir != new_dir)
		release_operator()

/datum/component/mounted_weapon/proc/on_weapon_moved(obj/item/gun/source)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	if(source.loc != parent)
		qdel(src)

/datum/component/mounted_weapon/proc/on_weapon_deleted(datum/source)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	qdel(src)

/datum/component/mounted_weapon/proc/on_support_deleted(datum/source)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	release_operator()

/datum/component/mounted_weapon/proc/on_examine(obj/source, mob/user, list/examine_text)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	if(operator)
		examine_text += "[operator] is operating its weapon."
	else
		examine_text += "Its weapon is unmanned."
	if(weapon.get_reload_action_name())
		examine_text += SPAN_SUBTLE("Ctrl-click to operate its feed cover. Use a magazine on the support to reload; Ctrl-Shift-click to eject ammunition.")

/datum/component/mounted_weapon/proc/get_controlled_gun(datum/source, list/result)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	if(can_operate(operator) && weapon.get_gun_user() == operator)
		result["gun"] = weapon

/datum/component/mounted_weapon/proc/is_fire_target(atom/target)
	PRIVATE_PROC(TRUE)
	var/turf/origin = get_turf(parent)
	var/turf/destination = get_turf(target)
	if(QDELETED(target) || !origin || !destination || origin.z != destination.z || origin == destination || target == operator || istype(target, /atom/movable/screen))
		return FALSE
	var/obj/support = parent
	var/difference = abs(SIMPLIFY_DEGREES(get_angle(support, target)) - dir2angle(support.dir))
	return min(difference, 360 - difference) <= half_firing_arc

/datum/component/mounted_weapon/proc/check_fire(datum/source, mob/living/user, atom/target, atom/controller)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	if(!trigger_held || user != operator || controller != parent || !can_operate(operator) || weapon.get_gun_user() != operator || !is_fire_target(target))
		return COMPONENT_BLOCK_GUN_FIRE
	if(require_free_hands && (operator.get_active_hand() || operator.get_inactive_hand()))
		return COMPONENT_BLOCK_GUN_FIRE

/datum/component/mounted_weapon/proc/resolve_target(atom/target, list/modifiers)
	PRIVATE_PROC(TRUE)
	if(istype(target, /atom/movable/screen/click_catcher))
		return parse_caught_click_modifiers(modifiers, get_turf(input_client.eye), input_client)
	return target

/datum/component/mounted_weapon/proc/is_reload_pickup(atom/target)
	PRIVATE_PROC(TRUE)
	if(QDELETED(operator) || QDELETED(target) || !istype(target, /obj/item/ammo_magazine) || !isturf(target.loc) || operator.get_active_hand() || !target.Adjacent(operator))
		return FALSE
	return SEND_SIGNAL(weapon, COMSIG_GUN_ALLOW_RELOAD_HANDS, operator, target) & COMPONENT_ALLOW_RELOAD_HANDS

/datum/component/mounted_weapon/proc/on_mouse_down(client/source, atom/target, location, control, params)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	var/list/modifiers = params2list(params)
	if(!modifiers[LEFT_CLICK] || modifiers[SHIFT_CLICK] || modifiers[CTRL_CLICK] || modifiers[ALT_CLICK] || modifiers[MIDDLE_CLICK] || modifiers[RIGHT_CLICK])
		return
	if(firing_request || !can_operate(operator) || operator.in_throw_mode)
		return
	target = resolve_target(target, modifiers)
	if(is_reload_pickup(target))
		return
	if(!is_fire_target(target))
		return
	if(require_free_hands && (operator.get_active_hand() || operator.get_inactive_hand()))
		var/obj/support = parent
		support.balloon_alert(operator, "need both hands free!")
		return
	fire_target = target
	fire_modifiers = modifiers
	trigger_held = TRUE
	trigger_revision++
	INVOKE_ASYNC(src, PROC_REF(fire_loop), operation_revision, trigger_revision)

/datum/component/mounted_weapon/proc/on_mouse_drag(client/source, atom/src_object, atom/over_object, src_location, over_location, src_control, over_control, params)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	if(!trigger_held)
		return
	var/list/modifiers = params2list(params)
	fire_target = resolve_target(over_object, modifiers)
	fire_modifiers = modifiers
	if(!is_fire_target(fire_target))
		stop_firing()

/datum/component/mounted_weapon/proc/on_mouse_up(client/source, atom/target, location, control, params)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	var/list/modifiers = params2list(params)
	if(modifiers[LEFT_CLICK])
		stop_firing()

/datum/component/mounted_weapon/proc/on_operator_click(datum/source, atom/target, list/modifiers)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	if(modifiers[SHIFT_CLICK] || modifiers[CTRL_CLICK] || modifiers[ALT_CLICK] || modifiers[MIDDLE_CLICK] || modifiers[RIGHT_CLICK] || istype(target, /atom/movable/screen))
		return
	if(is_reload_pickup(target))
		return
	if(target == parent)
		var/obj/item/held_item = operator.get_active_hand()
		if(held_item)
			if(on_reload_item(parent, operator, held_item, modifiers))
				return COMSIG_MOB_CANCEL_CLICKON
			return
		release_operator()
		return COMSIG_MOB_CANCEL_CLICKON
	// MouseDown owns the trigger; suppress the ordinary empty-hand attack on release.
	return COMSIG_MOB_CANCEL_CLICKON

/datum/component/mounted_weapon/proc/stop_firing()
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	trigger_held = FALSE
	trigger_revision++
	fire_target = null
	fire_modifiers = null

/datum/component/mounted_weapon/proc/fire_loop(session, trigger)
	PRIVATE_PROC(TRUE)
	firing_request = TRUE
	while(trigger_held && operation_revision == session && trigger_revision == trigger)
		if(!can_operate(operator) || !is_fire_target(fire_target))
			break
		if(world.time < weapon.next_fire_time)
			sleep(max(1, weapon.next_fire_time - world.time))
			if(QDELETED(src))
				return
			continue
		var/mob/living/shooter = operator
		var/fired = weapon.fire_gun(fire_target, shooter, fire_modifiers, controller = parent)
		if(QDELETED(src))
			return
		if(!fired)
			break
		if(!weapon.can_autofire)
			break
		sleep(max(1, weapon.next_fire_time - world.time))
		if(QDELETED(src))
			return
	firing_request = FALSE
	stop_firing()

/datum/component/mounted_weapon/proc/on_reload_item(obj/source, mob/living/user, obj/item/tool, list/modifiers)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	if((user != operator && user.a_intent == I_HURT) || (!istype(tool, /obj/item/ammo_magazine) && !istype(tool, /obj/item/ammo_casing)))
		return
	if(source.use_check(user) || user.get_active_hand() != tool)
		return
	if(!operator && can_operate(user, TRUE))
		toggle_operator(user)
		return ITEM_INTERACT_SUCCESS
	if(istype(weapon, /obj/item/gun/projectile))
		INVOKE_ASYNC(weapon, TYPE_PROC_REF(/obj/item/gun/projectile, load_ammo), tool, user)
	else
		INVOKE_ASYNC(weapon, TYPE_PROC_REF(/atom, attackby), tool, user)
	return ITEM_INTERACT_SUCCESS

/datum/component/mounted_weapon/proc/on_reload_action(datum/source, mob/living/user)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	if(weapon.get_reload_action_name())
		INVOKE_ASYNC(weapon, TYPE_PROC_REF(/obj/item/gun, reload_action), user)
		return COMPONENT_MOUNTED_WEAPON_HANDLED

/datum/component/mounted_weapon/proc/on_eject_action(obj/source, mob/living/user)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)
	if(!source.use_check(user) && weapon.has_eject_action())
		INVOKE_ASYNC(weapon, TYPE_PROC_REF(/obj/item/gun, eject), user)
		return COMPONENT_MOUNTED_WEAPON_HANDLED

/obj/item/grab
	name = "grab"
	canremove = FALSE
	item_flags = ITEM_FLAG_NO_BLUDGEON
	pickup_sound = null
	drop_sound = null
	equip_sound = null
	w_class = INFINITY

	var/atom/movable/grabbed = null
	var/mob/grabber = null
	var/singleton/grab/current_grab
	var/last_action
	var/last_upgrade
	var/special_target_functional
	var/resolving_hit
	var/target_zone
	var/done_struggle

/obj/item/grab/Initialize(mapload, atom/movable/target, use_grab_state, defer_hand)
	. = ..(mapload)
	if (. == INITIALIZE_HINT_QDEL)
		return

	current_grab = GET_SINGLETON(use_grab_state)
	if(!istype(current_grab))
		return INITIALIZE_HINT_QDEL
	grabber = loc
	if(!ismob(grabber) || !grabber.add_grab(src, defer_hand = defer_hand))
		return INITIALIZE_HINT_QDEL
	grabbed = target
	if(!ismovable(grabbed))
		return INITIALIZE_HINT_QDEL
	target_zone = grabber.get_target_zone()

	var/mob/living/grabbed_mob = get_grabbed_mob()
	if(grabbed_mob)
		grabbed_mob.update_icon()
		var/mob/living/carbon/human/H = grabbed_mob
		if(istype(H))
			var/obj/item/uniform = H.get_equipped_item(slot_w_uniform_str)
			if(uniform)
				uniform.add_fingerprint(grabbed_mob)

	LAZYADD(grabbed.grabbed_by, src)
	adjust_position()
	action_used()
	INVOKE_ASYNC(grabber, TYPE_PROC_REF(/atom/movable, do_attack_animation), grabbed)
	playsound(grabbed.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
	update_icon()

	RegisterSignal(grabbed, COMSIG_MOVABLE_MOVED, PROC_REF(on_grabbed_move))
	var/atom/movable/screen/zone_sel/zone_sel = grabber.zone_sel
	if(istype(zone_sel))
		RegisterSignal(grabber, COMSIG_MOB_ZONE_SEL_CHANGE, PROC_REF(on_target_change))

	var/obj/item/organ/O = get_targeted_organ()
	if(grabbed_mob && O)
		name = "[name] (\the [grabbed_mob]'s [O.name])"
		RegisterSignal(grabbed_mob, COMSIG_ORGAN_DISMEMBERED, PROC_REF(on_organ_loss))
		if(grabbed_mob != grabber)
			visible_message(SPAN_DANGER("\The [grabber] has grabbed [grabbed_mob]'s [O.name]!"))
		else
			visible_message(SPAN_NOTICE("\The [grabber] has grabbed [grabber.get_pronoun("his")] [O.name]!"))
	else
		if(grabbed != grabber)
			visible_message(SPAN_DANGER("\The [grabber] has grabbed \the [grabbed]!"))
		else
			visible_message(SPAN_NOTICE("\The [grabber] has grabbed [grabber.get_pronoun("himself")]!"))

	if(grabbed_mob && grabber?.a_intent == I_HURT)
		upgrade(TRUE)

/obj/item/grab/mob_can_unequip(mob/M, slot, disable_warning = FALSE, dropping = FALSE)
	return dropping

/obj/item/grab/process()
	current_grab.do_process(src)

/obj/item/grab/attack_self()
	if(grabber?.a_intent == I_HELP)
		downgrade()
	else
		upgrade()

/obj/item/grab/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(QDELETED(src) || !current_grab || !grabber || proximity_flag) // Close-range is handled in resolve_attackby().
		return
	if(current_grab.hit_with_grab(src, target, proximity_flag))
		return
	. = ..()

/obj/item/grab/resolve_attackby(atom/A, mob/user, click_parameters)
	if(QDELETED(src) || !current_grab || !grabber)
		return TRUE
	if(A.grab_attack(src, user) || current_grab.hit_with_grab(src, A, get_dist(user, A) <= 1))
		return TRUE
	. = ..()

/obj/item/grab/dropped()
	. = ..()
	if(!QDELETED(src))
		qdel(src)

/obj/item/grab/Destroy()
	var/atom/old_grabbed = grabbed
	if(grabbed)
		UnregisterSignal(grabbed, COMSIG_ORGAN_DISMEMBERED)
		UnregisterSignal(grabbed, COMSIG_MOVABLE_MOVED)
		LAZYREMOVE(grabbed.grabbed_by, src)
		grabbed.reset_plane_and_layer()
		grabbed = null
	if(grabber)
		if(grabber.zone_sel)
			UnregisterSignal(grabber.zone_sel, COMSIG_MOB_ZONE_SEL_CHANGE)
		grabber = null
	. = ..()
	if(old_grabbed)
		old_grabbed.reset_offsets(5)
		old_grabbed.reset_plane_and_layer()

/obj/item/grab/proc/on_target_change(atom/movable/screen/zone_sel/zone, old_sel, new_sel)
	if(src != grabber.get_active_hand() || target_zone != new_sel)
		return
	var/old_zone = target_zone
	target_zone = check_zone(new_sel, grabbed)
	if(!istype(get_targeted_organ(), /obj/item/organ))
		current_grab.let_go(src)
		return
	current_grab.on_target_change(src, old_zone, new_sel)

/obj/item/grab/proc/on_organ_loss(mob/victim, obj/item/organ/lost)
	if(grabbed != victim)
		stack_trace("A grab switched affecting targets without re-registering properly.")
		return
	var/obj/item/organ/O = get_targeted_organ()
	if(!istype(O))
		current_grab.let_go(src)
		return
	if(lost != O)
		return
	current_grab.let_go(src)

/obj/item/grab/proc/on_grabbed_move()
	if(!grabbed || !isturf(grabbed.loc) || (get_dist_3d(grabber, grabbed) > 1 && grabbed.moving_diagonally != FIRST_DIAG_STEP))
		force_drop()

/obj/item/grab/proc/force_drop()
	grabber.drop_from_inventory(src)

/obj/item/grab/proc/get_grabbed_mob()
	if(isobj(grabbed))
		var/obj/O = grabbed
		return O.buckled
	if(isliving(grabbed))
		return grabbed

/obj/item/grab/proc/get_targeted_organ()
	var/mob/living/carbon/human/H = get_grabbed_mob()
	if(istype(H))
		. = GET_EXTERNAL_ORGAN(H, check_zone(target_zone, H))

/obj/item/grab/proc/resolve_item_attack(mob/living/M, obj/item/I, target_zone)
	if(M && ishuman(M) && I)
		return current_grab.resolve_item_attack(src, M, I, target_zone)
	return 0

/obj/item/grab/proc/action_used()
	last_action = world.time
	leave_forensic_traces()

/obj/item/grab/proc/check_action_cooldown()
	return (world.time >= last_action + current_grab.action_cooldown)

/obj/item/grab/proc/check_upgrade_cooldown()
	return (world.time >= last_upgrade + current_grab.upgrade_cooldown)

/obj/item/grab/proc/leave_forensic_traces()
	if(ishuman(grabbed))
		var/mob/living/carbon/human/grabbed_mob = grabbed
		var/obj/item/organ/O = GET_EXTERNAL_ORGAN(grabbed_mob, target_zone)
		if(istype(O))
			var/obj/item/I = grabbed_mob.get_covering_equipped_item(O.body_parts_covered)
			if(istype(I))
				I.add_fingerprint(grabber)

/obj/item/grab/proc/upgrade(bypass_cooldown = FALSE)
	if(!check_upgrade_cooldown() && !bypass_cooldown)
		return
	var/singleton/grab/upgrade = current_grab.upgrade(src)
	if(upgrade)
		current_grab = upgrade
		last_upgrade = world.time
		adjust_position()
		update_icon()
		leave_forensic_traces()
		current_grab.enter_as_up(src)

/obj/item/grab/proc/downgrade()
	var/singleton/grab/downgrade = current_grab.downgrade(src)
	if(downgrade)
		current_grab = downgrade
		adjust_position()
		update_icon()

/obj/item/grab/update_icon()
	. = ..()
	if(current_grab.grab_icon)
		icon = current_grab.grab_icon
	if(current_grab.grab_icon_state)
		icon_state = current_grab.grab_icon_state

/obj/item/grab/proc/throw_held()
	return current_grab.throw_held(src)

/obj/item/grab/proc/handle_resist()
	current_grab.handle_resist(src)

/obj/item/grab/proc/adjust_position(force = FALSE)
	if(!QDELETED(grabber) && force)
		grabbed.forceMove(grabber.loc)

	if(QDELETED(grabber) || QDELETED(grabbed) || !grabber.IsMultiZAdjacent(grabbed))
		qdel(src)
		return FALSE

	var/adir = get_dir(grabber, grabbed)
	if(grabber)
		grabber.set_dir(adir)
	if(current_grab.grab_flags & GRAB_SHARE_TILE)
		grabbed.forceMove(get_turf(grabber))
		grabbed.set_dir(grabber.dir)
	grabbed.reset_offsets(5)
	grabbed.reset_plane_and_layer()

/obj/item/grab/attackby(obj/item/attacking_item, mob/user, params)
	if(user == grabber)
		return current_grab.item_attack(src, attacking_item)
	return FALSE

/obj/item/grab/proc/point_blank_mult()
	return current_grab.point_blank_mult

/obj/item/grab/proc/damage_stage()
	return current_grab.damage_stage

/obj/item/grab/proc/grab_slowdown()
	. = ceil(grabbed?.get_object_size() * current_grab.grab_slowdown)
	. /= (grabbed?.movable_flags & MOVABLE_FLAG_WHEELED) ? 2 : 1
	. = max(., 1)

/obj/item/grab/proc/grabber_moved()
	grabbed.glide_size = grabber.glide_size
	current_grab.grabber_moved(src)

/obj/item/grab/proc/resolve_openhand_attack()
	return current_grab.resolve_openhand_attack(src)

/obj/item/grab/proc/has_grab_flags(var/flags)
	return (current_grab.grab_flags & flags)

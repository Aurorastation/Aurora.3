/singleton/grab/normal
	name = "grab"

	help_action = "inspect"
	disarm_action = "pin"
	grab_action = "jointlock"
	harm_action = "dislocate"

	var/drop_headbutt = TRUE

/singleton/grab/normal/on_hit_help(obj/item/grab/G, atom/A, proximity)
	if(!proximity || (A && A != G.get_grabbed_mob()))
		return FALSE
	var/obj/item/organ/external/limb = G.get_targeted_organ()
	if(!limb)
		return FALSE
	return limb.inspect(G.grabber)

/singleton/grab/normal/on_hit_disarm(obj/item/grab/G, atom/A, proximity)
	if(!proximity)
		return FALSE

	var/mob/living/grabbed = G.get_grabbed_mob()
	var/mob/living/grabber = G.grabber

	if(grabbed && A && A == grabbed && !grabbed.lying && istype(grabber))
		grabbed.visible_message(SPAN_DANGER("\The [grabber] is trying to pin \the [grabbed] to the ground!"))
		if(do_mob(grabber, grabbed, action_cooldown - 1))
			G.action_used()
			grabbed.Weaken(2)
			grabbed.visible_message(SPAN_DANGER("\The [grabber] pins \the [grabbed] to the ground!"))
			return TRUE
		grabbed.visible_message(SPAN_WARNING("\The [grabber] fails to pin \the [grabbed] to the ground."))

	return FALSE

/singleton/grab/normal/on_hit_grab(obj/item/grab/G, atom/A, proximity)
	if(!proximity)
		return FALSE

	var/mob/living/grabbed = G.get_grabbed_mob()

	if(!grabbed || (A && A != grabbed))
		return FALSE

	var/mob/living/grabber = G.grabber

	if(!istype(grabber))
		return FALSE

	var/obj/item/organ/external/limb = G.get_targeted_organ()
	if(!istype(limb))
		to_chat(grabber, SPAN_WARNING("\The [grabbed] is missing that body part!"))
		return FALSE

	grabber.visible_message(SPAN_DANGER("\The [grabber] begins to [pick("bend", "twist")] \the [grabbed]'s [limb.joint] into a jointlock!"))
	if(do_mob(grabber, grabbed, action_cooldown - 1))
		G.action_used()
		limb.jointlock(grabber)
		grabber.visible_message(SPAN_DANGER("\The [grabbed]'s [limb.joint] is twisted!"))
		playsound(grabber.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		return TRUE

	grabbed.visible_message(SPAN_WARNING("\The [grabber] fails to jointlock \the [grabbed]'s [limb.joint]."))
	return FALSE

/singleton/grab/normal/on_hit_harm(obj/item/grab/G, atom/A, proximity)
	if(!proximity)
		return FALSE

	var/mob/living/grabbed = G.get_grabbed_mob()
	if(!grabbed || (A && A != grabbed))
		return FALSE

	var/mob/living/grabber = G.grabber
	if(!istype(grabber))
		return FALSE

	var/obj/item/organ/external/limb = G.get_targeted_organ()
	if(!istype(limb))
		to_chat(grabber, SPAN_WARNING("\The [grabbed] is missing that body part!"))
		return FALSE

	if(!ORGAN_IS_DISLOCATED(limb) && limb.dislocated != -1) // mfw
		grabber.visible_message(SPAN_DANGER("\The [grabber] begins to dislocate \the [grabbed]'s [limb.joint]!"))
		if(do_mob(grabber, grabbed, action_cooldown - 1))
			G.action_used()
			limb.dislocate(TRUE)
			grabber.visible_message(SPAN_DANGER("\The [grabbed]'s [limb.joint] [pick("gives way", "caves in", "crumbles", "collapses")]!"))
			playsound(grabber.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			return TRUE
		grabbed.visible_message(SPAN_WARNING("\The [grabber] fails to dislocate \the [grabbed]'s [limb.joint]."))
		return FALSE

	if(ORGAN_IS_DISLOCATED(limb))
		to_chat(grabber, SPAN_WARNING("\The [grabbed]'s [limb.joint] is already dislocated!"))
	else
		to_chat(grabber, SPAN_WARNING("You can't dislocate \the [grabbed]'s [limb.joint]!"))
	return FALSE

/singleton/grab/normal/resolve_openhand_attack(obj/item/grab/G)
	if(G.grabber.a_intent != I_HELP && G.target_zone == BP_HEAD)
		if(G.grabber.get_target_zone() == BP_EYES && attack_eye(G))
			return TRUE
		else if(headbutt(G) && drop_headbutt)
			let_go(G)
		return TRUE
	return FALSE

/singleton/grab/normal/proc/attack_eye(obj/item/grab/G)
	var/mob/living/carbon/human/target = G.get_grabbed_mob()
	var/mob/living/carbon/human/attacker = G.grabber
	if(!istype(target) || !istype(attacker))
		return

	var/datum/unarmed_attack/attack = attacker.get_unarmed_attack(target, BP_EYES)
	if(!istype(attack))
		return

	for(var/slot in GLOB.standard_headgear_slots)
		var/obj/item/protection = target.get_equipped_item(slot)
		if(istype(protection) && (protection.body_parts_covered & SLOT_EYES))
			to_chat(attacker, SPAN_DANGER("You're going to need to remove the eye covering first!"))
			return
	if(!target.check_has_eyes())
		to_chat(attacker, SPAN_DANGER("[target] doesn't have eyes!"))
		return

	admin_attack_log(attacker, target, "Grab attacked the victim's eyes.", "Had their eyes grab attacked.", "attacked the eyes, using a grab action, of")

	attack.handle_eye_attack(attacker, target)
	return TRUE

/singleton/grab/normal/proc/headbutt(obj/item/grab/G)
	var/mob/living/carbon/human/target = G.get_grabbed_mob()
	var/mob/living/carbon/human/attacker = G.grabber
	if(!istype(target) || !istype(attacker) || target.lying)
		return

	var/damage = 20
	var/obj/item/clothing/hat = attacker.get_equipped_item(slot_head_str)
	var/damage_flags = 0

	if(istype(hat))
		damage += hat.w_class * 3
		damage_flags = hat.damage_flags()

	if(damage_flags & DAMAGE_FLAG_SHARP)
		if(istype(hat))
			attacker.visible_message(SPAN_DANGER("\The [attacker] gores \the [target] with \the [hat]!"))
		else
			attacker.visible_message(SPAN_DANGER("\The [attacker] gores \the [target]!"))
	else
		attacker.visible_message(SPAN_DANGER("\The [attacker] thrusts [attacker.get_pronoun("his")] head into \the [target]'s skull!"))

	var/armor = target.get_blocked_ratio(BP_HEAD, DAMAGE_BRUTE, damage = 10)
	target.apply_damage(damage, DAMAGE_BRUTE, BP_HEAD, damage_flags)
	attacker.apply_damage(10, DAMAGE_BRUTE, BP_HEAD)

	if(armor < 0.5 && target.headcheck(BP_HEAD) && prob(damage))
		target.apply_effect(20, PARALYZE)
		target.visible_message(SPAN_DANGER("\The [target] [target.species.knockout_message]"))

	playsound(attacker.loc, "swing_hit", 25, 1, -1)

	admin_attack_log(attacker, target, "Headbutted their victim.", "Was headbutted.", "headbutted")
	return TRUE


// Handles special targeting like eyes and mouth being covered.
/singleton/grab/normal/special_target_effect(var/obj/item/grab/G)
	var/mob/living/grabbed_mob = G.get_grabbed_mob()
	if(istype(grabbed_mob) && G.special_target_functional)
		switch(G.target_zone)
			if(BP_MOUTH)
				grabbed_mob.silent += (2 SECONDS)
			if(BP_EYES)
				grabbed_mob.blind += (2 SECONDS)

// Handles when they change targeted areas and something is supposed to happen.
/singleton/grab/normal/special_target_change(var/obj/item/grab/G, old_zone, new_zone)
	if((old_zone != BP_HEAD && old_zone != BP_CHEST) || !G.get_grabbed_mob())
		return
	switch(new_zone)
		if(BP_MOUTH)
			G.grabber.visible_message(SPAN_DANGER("\The [G.grabber] covers [G.grabbed]'s mouth!"))
		if(BP_EYES)
			G.grabber.visible_message(SPAN_DANGER("\The [G.grabber] covers [G.grabbed]'s eyes!"))

/singleton/grab/normal/check_special_target(var/obj/item/grab/G)
	var/mob/living/grabbed_mob = G.get_grabbed_mob()
	if(!istype(grabbed_mob))
		return FALSE
	switch(G.target_zone)
		if(BP_MOUTH)
			if(!grabbed_mob.check_has_mouth())
				to_chat(G.grabber, SPAN_WARNING("You cannot locate a mouth on [G.grabbed]!"))
				return FALSE
		if(BP_EYES)
			if(!grabbed_mob.check_has_eyes())
				to_chat(G.grabber, SPAN_WARNING("You cannot locate any eyes on [G.grabbed]!"))
				return FALSE
	return TRUE

/singleton/grab/normal/resolve_item_attack(var/obj/item/grab/G, var/mob/living/carbon/human/user, var/obj/item/I)
	switch(G.target_zone)
		if(BP_HEAD)
			return attack_throat(G, I, user)
		else
			return attack_tendons(G, I, user, G.target_zone)

/singleton/grab/normal/proc/attack_throat(var/obj/item/grab/G, var/obj/item/W, mob/user)
	var/mob/living/grabbed = G.get_grabbed_mob()
	if(!grabbed)
		return
	var/damage_flags = W.damage_flags()
	if(!(damage_flags & (DAMAGE_FLAG_SHARP|DAMAGE_FLAG_EDGE)) || W.damtype != DAMAGE_BRUTE)
		return FALSE //unsuitable weapon

	user.visible_message(SPAN_DANGER("\The [user] begins to slit [grabbed]'s throat with \the [W]!"))

	user.next_move = world.time + 20 //also should prevent user from triggering this repeatedly
	if(!W.use_tool(user, grabbed, 20, volume = 50))
		return 0
	if(!(G && G.grabber == user && G.grabbed == grabbed)) //check that we still have a grab
		return 0

	var/damage_mod = 1
	//presumably, if they are wearing a helmet that stops pressure effects, then it probably covers the throat as well
	var/obj/item/clothing/head/helmet = grabbed.get_equipped_item(slot_head_str)
	if(istype(helmet) && (helmet.body_parts_covered & HEAD) && (helmet.min_pressure_protection == 0))
		var/datum/component/armor/armor_component = helmet.GetComponent(/datum/component/armor)
		if(armor_component)
			damage_mod -= armor_component.get_blocked(DAMAGE_BRUTE, damage_flags, W.armor_penetration, W.force*1.5)

	var/total_damage = 0
	for(var/i in 1 to 3)
		var/damage = min(W.force*1.5, 20)*damage_mod
		grabbed.apply_damage(damage, W.damtype, BP_HEAD, 0, used_weapon = W, damage_flags = damage_flags)
		total_damage += damage

	var/oxyloss = total_damage
	if(total_damage >= 40) //threshold to make someone pass out
		oxyloss = 60 // Brain lacks oxygen immediately, pass out

	grabbed.adjustOxyLoss(min(oxyloss, 100 - grabbed.getOxyLoss())) //don't put them over 100 oxyloss

	if(total_damage)
		if(grabbed.getOxyLoss() >= 40)
			user.visible_message(SPAN_DANGER("\The [user] slices [grabbed]'s throat open with \the [W]!"))
		else
			user.visible_message(SPAN_DANGER("\The [user] cuts [grabbed]'s neck open with \the [W]!"))

		if(W.hitsound)
			playsound(user.loc, W.hitsound, W.get_clamped_volume(), 1, -1)

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/head = H.get_organ(BP_HEAD)
		if(head)
			head.sever_artery()

	G.last_action = world.time

	user.attack_log += "\[[time_stamp()]\]<span class='warning'> Knifed [grabbed.name] ([grabbed.ckey]) with [W.name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(W.damtype)])</span>"
	grabbed.attack_log += "\[[time_stamp()]\]<font color='orange'> Got knifed by [user.name] ([user.ckey]) with [W.name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(W.damtype)])</font>"
	msg_admin_attack("[key_name_admin(user)] knifed [key_name_admin(grabbed)] with [W.name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(W.damtype)])",ckey=key_name(user),ckey_target=key_name(grabbed))
	return 1

/singleton/grab/normal/proc/attack_tendons(var/obj/item/grab/G, var/obj/item/used_item, mob/user, var/target_zone)
	var/mob/living/grabbed = G.get_grabbed_mob()
	if(!grabbed)
		return
	if(user.a_intent != I_HURT)
		return 0 // Not trying to hurt them.
	var/damage_flags = used_item.damage_flags()
	if(!(damage_flags & (DAMAGE_FLAG_SHARP|DAMAGE_FLAG_EDGE)) || used_item.damtype != DAMAGE_BRUTE)
		return FALSE //unsuitable weapon
	var/obj/item/organ/external/O = G.get_targeted_organ()
	if(!O || !(O.limb_flags & ORGAN_HAS_TENDON) || (O.status & TENDON_CUT))
		return FALSE
	user.visible_message(SPAN_DANGER("\The [user] begins to cut \the [grabbed]'s [O.tendon_name] with \the [used_item]!"))
	user.next_move = world.time + 20
	if(!used_item.use_tool(user, grabbed, 20, volume = 50))
		return 0
	if(!(G && G.grabbed == grabbed)) //check that we still have a grab
		return 0
	if(!O || !O.tendon?.sever())
		return 0
	user.visible_message(SPAN_DANGER("\The [user] cut \the [grabbed]'s [O.tendon_name] with \the [used_item]!"))
	if(used_item.hitsound) playsound(grabbed.loc, used_item.hitsound, 50, 1, -1)
	G.last_action = world.time
	admin_attack_log(user, grabbed, "hamstrung their victim", "was hamstrung", "hamstrung")
	return 1

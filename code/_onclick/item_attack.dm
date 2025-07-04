/*
=== Item Click Call Sequences ===
These are the default click code call sequences used when clicking on stuff with an item.
Atoms:
mob/ClickOn() calls the item's resolve_attackby() proc.
item/resolve_attackby() calls the target atom's attackby() proc.
Mobs:
mob/living/attackby() after checking for surgery, calls the item's attack() proc.
item/attack() generates attack logs, sets click cooldown and calls the mob's attacked_with_item() proc. If you override this, consider whether you need to set a click cooldown, play attack animations, and generate logs yourself.
mob/attacked_with_item() should then do mob-type specific stuff (like determining hit/miss, handling shields, etc) and then possibly call the item's apply_hit_effect() proc to actually apply the effects of being hit.
Item Hit Effects:
item/apply_hit_effect() can be overriden to do whatever you want. However "standard" physical damage based weapons should make use of the target mob's hit_with_weapon() proc to
avoid code duplication. This includes items that may sometimes act as a standard weapon in addition to having other effects (e.g. stunbatons on harm intent).
*/

// Called when the item is in the active hand, and clicked; alternately, there is an 'activate held object' verb or you can hit pagedown.
/obj/item/proc/attack_self(mob/user, modifiers)
	if(SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_SELF, user) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE
	return

/// Called when the item is in the active hand, and right-clicked. Intended for alternate or opposite functions, such as lowering reagent transfer amount. At the moment, there is no verb or hotkey.
/obj/item/proc/attack_self_secondary(mob/user, modifiers)
	if(SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_SELF_SECONDARY, user) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE

// Called at the start of resolve_attackby(), before the actual attack.
/obj/item/proc/pre_attack(atom/a, mob/user)
	return

//I would prefer to rename this to attack(), but that would involve touching hundreds of files.
/obj/item/proc/resolve_attackby(atom/A, mob/user, var/click_parameters)
	pre_attack(A, user)
	add_fingerprint(user)
	log_attack("[A] at [A?.loc]/[A.x]-[A.y]-[A.z] got ITEM attacked by [usr]/[usr?.ckey] on INTENT [usr?.a_intent] with [src]")
	return A.attackby(src, user, click_parameters)

/**
 * Called on an object being hit by an item
 *
 * Returns `TRUE` if all desired actions are resolved from that attack
 *
 * Returning `TRUE` prevents `afterattack()` from being called
 *
 * * attacking_item - The item hitting the atom
 * * user - The wielder of this item
 * * params - Click params such as alt/shift etc
 */
/atom/proc/attackby(obj/item/attacking_item, mob/user, params)
	if(SEND_SIGNAL(src, COMSIG_ATOM_ATTACKBY, attacking_item, user, params) & COMPONENT_NO_AFTERATTACK)
		return TRUE
	return FALSE

/atom/movable/attackby(obj/item/attacking_item, mob/user, params)
	if(..())
		return TRUE

	if((user?.a_intent == I_HURT) && !(attacking_item.item_flags & ITEM_FLAG_NO_BLUDGEON))
		visible_message(SPAN_DANGER("[src] has been hit by [user] with [attacking_item]."))

/mob/living/attackby(obj/item/attacking_item, mob/user, params)
	if(..())
		return TRUE

	if(!ismob(user))
		return FALSE

	var/selected_zone = user.zone_sel ? user.zone_sel.selecting : BP_CHEST
	var/operating = can_operate(src)
	if(operating == SURGERY_SUCCESS)
		if(do_surgery(src, user, attacking_item))
			return TRUE
		else
			return attacking_item.attack(src, user, selected_zone) //This is necessary to make things like health analyzers work. -mattatlas
	if(operating == SURGERY_FAIL)
		if(do_surgery(src, user, attacking_item, TRUE))
			return TRUE
		else
			return attacking_item.attack(src, user, selected_zone)
	else
		return attacking_item.attack(src, user, selected_zone)

/mob/living/carbon/human/attackby(obj/item/attacking_item, mob/user, params)
	if(user == src && user.a_intent == I_GRAB && zone_sel?.selecting == BP_MOUTH && can_devour(attacking_item, silent = TRUE))
		var/obj/item/blocked = src.check_mouth_coverage()
		if(blocked)
			to_chat(user, SPAN_WARNING("\The [blocked] is in the way!"))
			return TRUE
		if(devour(attacking_item))
			return TRUE
	return ..()

// Proximity_flag is 1 if this afterattack was called on something adjacent, in your square, or on your person.
// Click parameters is the params string from byond Click() code, see that documentation.
/obj/item/proc/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	return

/obj/item/proc/get_clamped_volume()
	if(w_class)
		if(force)
			return clamp((force + w_class) * 4, 30, 100)// Add the item's force to its weight class and multiply by 4, then clamp the value between 30 and 100
		else
			return clamp(w_class * 6, 10, 100) // Multiply the item's weight class by 6, then clamp the value between 10 and 100

/**
 * Called from [/mob/living/proc/attackby] (usually)
 *
 * Arguments:
 * * mob/living/target_mob - The mob being hit by this item
 * * mob/living/user - The mob hitting with this item
 * * target_zone - The target zone aimed at, **THIS DIFFERS FROM TG WHERE IT TAKES THE CLICK PARAMS**
 */
/obj/item/proc/attack(mob/living/target_mob, mob/living/user, target_zone = BP_CHEST)
	var/signal_return = SEND_SIGNAL(src, COMSIG_ITEM_ATTACK, target_mob, user) || SEND_SIGNAL(user, COMSIG_MOB_ITEM_ATTACK, target_mob, user)
	if(signal_return & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE
	if(signal_return & COMPONENT_SKIP_ATTACK)
		return FALSE

	if(item_flags & ITEM_FLAG_NO_BLUDGEON)
		return 0

	if(target_mob == user && user.a_intent != I_HURT)
		return 0

	if(user.incapacitated(INCAPACITATION_STUNNED|INCAPACITATION_KNOCKOUT|INCAPACITATION_KNOCKDOWN|INCAPACITATION_FORCELYING))
		return

	if(force && user.is_pacified())
		to_chat(user, SPAN_WARNING("You don't want to harm other living beings!"))
		return 0

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(target_mob, src)
	if(!user.aura_check(AURA_TYPE_WEAPON, src, user))
		return FALSE

	var/mob/living/victim = target_mob.get_attack_victim(src, user, target_zone)
	var/hit_zone
	if(victim)
		hit_zone = victim.resolve_item_attack(src, user, target_zone)
		if(hit_zone)
			apply_hit_effect(victim, user, hit_zone)

	// Null hitzone means a miss.
	if(hit_zone)
		if(!force)
			playsound(src, 'sound/weapons/tap.ogg', get_clamped_volume(), TRUE, -1)
		else if(hitsound)
			playsound(src, hitsound, get_clamped_volume(), TRUE, -1, falloff_distance = 0)
	else
		playsound(src, 'sound/weapons/punchmiss2.ogg', get_clamped_volume(), TRUE, -1)

	/////////////////////////
	user.lastattacked = target_mob
	target_mob.lastattacker = user

	SEND_SIGNAL(src, COMSIG_ITEM_AFTERATTACK, target_mob, user)
	SEND_SIGNAL(target_mob, COMSIG_ATOM_AFTER_ATTACKEDBY, src, user)

	if(!no_attack_log)
		user.attack_log += "\[[time_stamp()]\]<span class='warning'> [hit_zone ? "Attacked" : "Missed"] [target_mob.name] ([target_mob.ckey]) with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damtype)])</span>"
		target_mob.attack_log += "\[[time_stamp()]\]<font color='orange'> [hit_zone ? "Attacked" : "Missed"] by [user.name] ([user.ckey]) with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damtype)])</font>"
		msg_admin_attack("[key_name(user, highlight_special = 1)] [hit_zone ? "attacked" : "missed"] [key_name(target_mob, highlight_special = 1)] with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damtype)]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(target_mob) )
	/////////////////////////

	return 1

//Called when a weapon is used to make a successful melee attack on a mob. Returns whether damage was dealt.
/obj/item/proc/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	var/power = force
	if((user.mutations & HULK))
		power *= 2
	if(user.is_berserk())
		power *= 1.5
	if(ishuman(user))
		var/mob/living/carbon/human/X = user
		if(ishuman(target))
			if(X.check_weapon_affinity(src))
				perform_technique(target, X, hit_zone)

	return target.hit_with_weapon(src, user, power, hit_zone)

/obj/item/proc/perform_technique(var/mob/living/carbon/human/target, var/mob/living/carbon/human/user, var/target_zone)	//used when weapons have special interactions with martial arts
	return

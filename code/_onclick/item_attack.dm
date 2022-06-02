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
/obj/item/proc/attack_self(mob/user)
	return

// Called at the start of resolve_attackby(), before the actual attack.
/obj/item/proc/pre_attack(atom/a, mob/user)
	return

//I would prefer to rename this to attack(), but that would involve touching hundreds of files.
/obj/item/proc/resolve_attackby(atom/A, mob/user, var/click_parameters)
	pre_attack(A, user)
	add_fingerprint(user)
	return A.attackby(src, user, click_parameters)

// attackby should return TRUE if all desired actions are resolved from that attack, within attackby. This prevents afterattack being called.
/atom/proc/attackby(obj/item/W, mob/user, var/click_parameters)
	return

/atom/movable/attackby(obj/item/W, mob/user)
	if(!(W.flags & NOBLUDGEON))
		visible_message("<span class='danger'>[src] has been hit by [user] with [W].</span>")

/mob/living/attackby(obj/item/I, mob/user)
	if(!ismob(user))
		return FALSE

	var/selected_zone = user.zone_sel ? user.zone_sel.selecting : BP_CHEST
	var/operating = can_operate(src)
	if(operating == SURGERY_SUCCESS)
		if(do_surgery(src, user, I))
			return TRUE
		else
			return I.attack(src, user, selected_zone) //This is necessary to make things like health analyzers work. -mattatlas
	if(operating == SURGERY_FAIL)
		if(do_surgery(src, user, I, TRUE))
			return TRUE
		else
			return I.attack(src, user, selected_zone)
	else
		return I.attack(src, user, selected_zone)

/mob/living/carbon/human/attackby(obj/item/I, mob/user)
	if(user == src && zone_sel?.selecting == BP_MOUTH && can_devour(I, silent = TRUE))
		var/obj/item/blocked = src.check_mouth_coverage()
		if(blocked)
			to_chat(user, SPAN_WARNING("\The [blocked] is in the way!"))
			return TRUE
		if(devour(I))
			return TRUE
	return ..()

/mob/living/simple_animal/attackby(obj/item/I, mob/living/user)
	if(I.damtype == PAIN)
		playsound(loc, 'sound/weapons/tap.ogg', I.get_clamped_volume(), 1, -1)
		return TRUE
	else
		return ..()

// Proximity_flag is 1 if this afterattack was called on something adjacent, in your square, or on your person.
// Click parameters is the params string from byond Click() code, see that documentation.
/obj/item/proc/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	return

/obj/item/proc/get_clamped_volume()
	if(w_class)
		if(force)
			return Clamp((force + w_class) * 4, 30, 100)// Add the item's force to its weight class and multiply by 4, then clamp the value between 30 and 100
		else
			return Clamp(w_class * 6, 10, 100) // Multiply the item's weight class by 6, then clamp the value between 10 and 100

//I would prefer to rename this attack_as_weapon(), but that would involve touching hundreds of files.
/obj/item/proc/attack(mob/living/M, mob/living/user, var/target_zone = BP_CHEST)
	if(flags & NOBLUDGEON)
		return 0

	if(M == user && user.a_intent != I_HURT)
		return 0

	if(user.incapacitated(INCAPACITATION_STUNNED|INCAPACITATION_KNOCKOUT|INCAPACITATION_KNOCKDOWN|INCAPACITATION_FORCELYING))
		return

	if(force && user.is_pacified())
		to_chat(user, "<span class='warning'>You don't want to harm other living beings!</span>")
		return 0

	if(!force)
		playsound(loc, 'sound/weapons/tap.ogg', get_clamped_volume(), 1, -1)
	else if(hitsound)
		playsound(loc, hitsound, get_clamped_volume(), 1, -1)

	/////////////////////////
	user.lastattacked = M
	M.lastattacker = user

	if(!no_attack_log)
		user.attack_log += "\[[time_stamp()]\]<span class='warning'> Attacked [M.name] ([M.ckey]) with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damtype)])</span>"
		M.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by [user.name] ([user.ckey]) with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damtype)])</font>"
		msg_admin_attack("[key_name(user, highlight_special = 1)] attacked [key_name(M, highlight_special = 1)] with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damtype)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(M) )
	/////////////////////////

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(M, src)
	if(!user.aura_check(AURA_TYPE_WEAPON, src, user))
		return FALSE

	var/mob/living/victim = M.get_attack_victim(src, user, target_zone)
	if(victim)
		var/hit_zone = victim.resolve_item_attack(src, user, target_zone)
		if(hit_zone)
			apply_hit_effect(victim, user, hit_zone)

	return 1

//Called when a weapon is used to make a successful melee attack on a mob. Returns whether damage was dealt.
/obj/item/proc/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	var/power = force
	if(HULK in user.mutations)
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


/obj/item/grab/proc/inspect_organ(mob/living/carbon/human/H, mob/user, var/target_zone)

	var/obj/item/organ/external/E = H.get_organ(target_zone)

	if(!E || E.is_stump())
		to_chat(user, "<span class='notice'>[H] is missing that bodypart.</span>")
		return

	user.visible_message("<span class='notice'>[user] starts inspecting [affecting]'s [E.name] carefully.</span>")
	if(!do_mob(user,H, 10))
		to_chat(user, "<span class='notice'>You must stand still to inspect [E] for wounds.</span>")
	else if(E.wounds.len)
		to_chat(user, "<span class='warning'>You find [E.get_wounds_desc()]</span>")
	else
		to_chat(user, "<span class='notice'>You find no visible wounds.</span>")

	to_chat(user, "<span class='notice'>Checking bones now...</span>")
	if(!do_mob(user, H, 20))
		to_chat(user, "<span class='notice'>You must stand still to feel [E] for fractures.</span>")
	else if(E.status & ORGAN_BROKEN)
		to_chat(user, "<span class='warning'>The [E.encased ? E.encased : "bone in the [E.name]"] moves slightly when you poke it!</span>")
		H.custom_pain("Your [E.name] hurts where it's poked.")
	else
		to_chat(user, "<span class='notice'>The [E.encased ? E.encased : "bones in the [E.name]"] seem to be fine.</span>")

	to_chat(user, "<span class='notice'>Checking skin now...</span>")
	if(!do_mob(user, H, 10))
		to_chat(user, "<span class='notice'>You must stand still to check [H]'s skin for abnormalities.</span>")
	else
		var/bad = 0
		if(H.getToxLoss() >= 40)
			to_chat(user, "<span class='warning'>[H] has an unhealthy skin discoloration.</span>")
			bad = 1
		if(H.getOxyLoss() >= 20)
			to_chat(user, "<span class='warning'>[H]'s skin is unusually pale.</span>")
			bad = 1
		if(E.status & ORGAN_DEAD)
			to_chat(user, "<span class='warning'>[E] is decaying!</span>")
			bad = 1
		if(!bad)
			to_chat(user, "<span class='notice'>[H]'s skin is normal.</span>")

/obj/item/grab/proc/jointlock(mob/living/carbon/human/target, mob/attacker, var/target_zone)
	if(state < GRAB_AGGRESSIVE)
		to_chat(attacker, "<span class='warning'>You require a better grab to do this.</span>")
		return

	var/obj/item/organ/external/organ = target.get_organ(check_zone(target_zone))
	if(!organ || organ.dislocated == -1)
		return

	attacker.visible_message("<span class='danger'>[attacker] [pick("bent", "twisted")] [target]'s [organ.name] into a jointlock!</span>")
	var/armor = target.run_armor_check(target, "melee")
	if(armor < 100)
		to_chat(target, "<span class='danger'>You feel extreme pain!</span>")
		affecting.adjustHalLoss(Clamp(0, 60-affecting.getHalLoss(), 30)) //up to 60 halloss

/obj/item/grab/proc/attack_eye(mob/living/carbon/human/target, mob/living/carbon/human/attacker)
	if(!istype(attacker))
		return

	var/datum/unarmed_attack/attack = attacker.get_unarmed_attack(target, BP_EYES)

	if(!attack)
		return
	if(state < GRAB_NECK)
		to_chat(attacker, "<span class='warning'>You require a better grab to do this.</span>")
		return
	for(var/obj/item/protection in list(target.head, target.wear_mask, target.glasses))
		if(protection && (protection.body_parts_covered & EYES))
			to_chat(attacker, "<span class='danger'>You're going to need to remove the eye covering first.</span>")
			return
	if(!target.has_eyes())
		to_chat(attacker, "<span class='danger'>You cannot locate any eyes on [target]!</span>")
		return
	if(isipc(target))
		to_chat(attacker, "<span class='danger'>You cannot damage [target]'s optics with your bare hands!</span>")
		return

	admin_attack_log(attacker, target, "attacked [target.name]'s eyes using a grab.", "had eyes attacked by [attacker.name]'s grab.", "used a grab to attack eyes of")

	attack.handle_eye_attack(attacker, target)

/obj/item/grab/proc/headbut(mob/living/carbon/human/target, mob/living/carbon/human/attacker)
	if(!istype(attacker))
		return
	if(target.lying)
		return
	attacker.visible_message("<span class='danger'>[attacker] thrusts \his head into [target]'s skull!</span>")

	var/damage = 20
	if(attacker.mob_size >= 10)
		damage += min(attacker.mob_size, 20)

	if(isunathi(attacker))
		damage += 5

	var/obj/item/clothing/hat = attacker.head
	if(istype(hat))
		damage += hat.force * 3

	var/armor = target.run_armor_check(BP_HEAD, "melee")
	target.apply_damage(damage, BRUTE, BP_HEAD, armor)
	attacker.apply_damage(10, BRUTE, BP_HEAD, attacker.run_armor_check(BP_HEAD, "melee"))

	if(armor < 25 && target.headcheck(BP_HEAD) && prob(damage))
		target.apply_effect(20, PARALYZE)
		target.visible_message("<span class='danger'>[target] [target.species.knockout_message]</span>")

	playsound(attacker.loc, "swing_hit", 25, 1, -1)
	attacker.attack_log += text("\[[time_stamp()]\] <font color='red'>Headbutted [target.name] ([target.ckey])</font>")
	target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Headbutted by [attacker.name] ([attacker.ckey])</font>")
	msg_admin_attack("[key_name(attacker)] has headbutted [key_name(target)]",ckey=key_name(attacker),ckey_target=key_name(target))

	qdel(src)
	return

/obj/item/grab/proc/dislocate(mob/living/carbon/human/target, mob/living/attacker, var/target_zone)
	if(state < GRAB_NECK)
		to_chat(attacker, "<span class='warning'>You require a better grab to do this.</span>")
		return
	if(target.grab_joint(attacker, target_zone))
		playsound(loc, 'sound/weapons/push_connect.ogg', 50, 1, -1)
		return

/obj/item/grab/proc/pin_down(mob/target, mob/attacker)
	if(state < GRAB_AGGRESSIVE)
		to_chat(attacker, "<span class='warning'>You require a better grab to do this.</span>")
		return
	if(force_down)
		to_chat(attacker, "<span class='warning'>You are already pinning [target] to the ground.</span>")

	attacker.visible_message("<span class='danger'>[attacker] starts forcing [target] to the ground!</span>")
	if(do_after(attacker, 20) && target)
		last_action = world.time
		attacker.visible_message("<span class='danger'>[attacker] forces [target] to the ground!</span>")
		apply_pinning(target, attacker)

/obj/item/grab/proc/apply_pinning(mob/target, mob/attacker)
	force_down = 1
	target.Weaken(3)
	target.lying = 1
	step_to(attacker, target)
	attacker.set_dir(EAST) //face the victim
	target.set_dir(SOUTH) //face up

/obj/item/grab/proc/devour(mob/target, mob/user)
	var/mob/living/carbon/human/H = user
	H.devour(target)


/obj/item/grab/proc/hair_pull(mob/living/carbon/human/target, mob/attacker, var/target_zone)


	var/datum/sprite_accessory/hair/hair_style = hair_styles_list[target.h_style]
	var/hairchatname = hair_style.chatname
	for(var/obj/item/protection in list(target.head, target.wear_mask))
		if(protection && (protection.body_parts_covered & HEAD))
			to_chat(assailant, "<span class='warning'>You can't tug their hair while something is covering it!.</span>")
			return
	switch(hair_style.length)
		if(0)
			visible_message("<span class='notice'>[assailant] tried to grab [target] but they have no hair!</span>")
		if(1)
			visible_message("<span class='danger'>[assailant] tugs [target]'s [hairchatname] before releasing their grip!</span>")
			target.apply_damage(5, PAIN)
		if(2)
			visible_message("<span class='danger'>[assailant] tugs [target]'s [hairchatname]!</span>")
			target.apply_damage(5, PAIN)
			src.state = GRAB_PASSIVE

		if(3)
			visible_message("<span class='danger'>[assailant] tugs [target]'s [hairchatname]!</span>")
			target.apply_damage(10, PAIN)
			src.state = GRAB_PASSIVE

		if(4)
			visible_message("<span class='danger'>[assailant] violently tugs [target]'s [hairchatname], ripping out a clump!</span>")
			target.apply_damage(15, PAIN)
			src.state = GRAB_PASSIVE

		if(5)
			if(prob(77))
				visible_message("<span class='danger'>[assailant] has [target] grasped by their [hairchatname], however suddenly it slips from  [assailant]'s hand!</span>")
				src.state = GRAB_PASSIVE
			else
				visible_message("<span class='danger'>[assailant] violently tugs [target]'s [hairchatname]!</span>")
				target.apply_damage(10, PAIN)
				src.state = GRAB_AGGRESSIVE

		if(6)
			if(prob(67))
				visible_message("<span class='danger'>[assailant] has [target] grasped by their [hairchatname], however suddenly it slips from  [assailant]'s hand!</span>")
				src.state = GRAB_PASSIVE
				playsound(target.loc, 'sound/misc/slip.ogg', 50, 1, -3)
			else
				visible_message("<span class='danger'>[assailant] violently tugs [target]'s [hairchatname]!</span>")
				target.apply_damage(15, PAIN)
				src.state = GRAB_AGGRESSIVE

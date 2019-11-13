 /* Weapons
 * Contains:
 *		Sword
 *		Classic Baton
 */


/*
 * Classic Baton
 */

/obj/item/melee/classic_baton
	name = "police baton"
	desc = "A wooden truncheon for beating criminal scum."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "baton"
	item_state = "classic_baton"
	slot_flags = SLOT_BELT
	force = 10

/obj/item/melee/classic_baton/attack(mob/M as mob, mob/living/user as mob, var/target_zone)
	if ((user.is_clumsy()) && prob(50))
		to_chat(user, "<span class='warning'>You club yourself over the head.</span>")
		user.Weaken(3 * force)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(2*force, BRUTE, "head")
		else
			user.take_organ_damage(2*force)
		return
	return ..()

//Telescopic baton
/obj/item/melee/telebaton
	name = "telescopic baton"
	desc = "A compact yet rebalanced personal defense weapon. Can be concealed when folded."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "telebaton_0"
	item_state = "telebaton_0"
	slot_flags = SLOT_BELT
	w_class = 2
	force = 3
	var/on = 0


/obj/item/melee/telebaton/attack_self(mob/user as mob)
	on = !on
	if(on)
		user.visible_message("<span class='warning'>With a flick of their wrist, [user] extends their telescopic baton.</span>",\
		"<span class='warning'>You extend the baton.</span>",\
		"You hear an ominous click.")
		icon_state = "telebaton_1"
		item_state = "nullrod"
		w_class = 3
		force = 15//quite robust
		attack_verb = list("smacked", "struck", "slapped")
	else
		user.visible_message("<span class='notice'>\The [user] collapses their telescopic baton.</span>",\
		"<span class='notice'>You collapse the baton.</span>",\
		"You hear a click.")
		icon_state = "telebaton_0"
		item_state = "telebaton_0"
		w_class = 2
		force = 3//not so robust now
		attack_verb = list("hit", "punched")

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)
	add_fingerprint(user)

	if(blood_overlay && blood_DNA && (blood_DNA.len >= 1)) //updates blood overlay, if any
		cut_overlay(blood_overlay, TRUE)
		var/icon/I = new /icon(src.icon, src.icon_state)
		I.Blend(new /icon('icons/effects/blood.dmi', rgb(255,255,255)),ICON_ADD)
		I.Blend(new /icon('icons/effects/blood.dmi', "itemblood"),ICON_MULTIPLY)
		blood_overlay = image(I)
		blood_overlay.color = blood_color
		add_overlay(blood_overlay, TRUE)
		update_icon()

	return

/obj/item/melee/telebaton/attack(mob/target as mob, mob/living/user as mob, var/target_zone)
	if(on)
		if ((user.is_clumsy()) && prob(50))
			to_chat(user, "<span class='warning'>You club yourself over the head.</span>")
			user.Weaken(3 * force)
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				H.apply_damage(2*force, BRUTE, "head")
			else
				user.take_organ_damage(2*force)
			return
		if(..() == 1)
			if(user.a_intent == I_DISARM)
				if(ishuman(target))
					var/mob/living/carbon/human/T = target
					var/armor = T.run_armor_check(target_zone,"melee")

					T.apply_damage(40, HALLOSS, target_zone, armor)
		return
	else
		return ..()
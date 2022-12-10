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
	drop_sound = 'sound/items/drop/crowbar.ogg'
	pickup_sound = 'sound/items/pickup/crowbar.ogg'

/obj/item/melee/classic_baton/attack(mob/M as mob, mob/living/user as mob, var/target_zone)
	if ((user.is_clumsy()) && prob(50))
		to_chat(user, "<span class='warning'>You club yourself over the head.</span>")
		user.Weaken(3 * force)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(2*force, BRUTE, BP_HEAD)
		else
			user.take_organ_damage(2*force)
		return
	return ..()

//Telescopic baton
/obj/item/melee/telebaton
	name = "telescopic baton"
	desc = "A compact yet rebalanced personal defense weapon. Can be concealed when folded."
	icon = 'icons/obj/contained_items/weapons/telebaton.dmi'
	icon_state = "telebaton_0"
	item_state = "telebaton_0"
	var/state_extended = "telebaton_1"
	contained_sprite = TRUE
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_SMALL
	force = 3
	drop_sound = 'sound/items/drop/crowbar.ogg'
	pickup_sound = 'sound/items/pickup/crowbar.ogg'
	var/on = FALSE

/obj/item/melee/telebaton/proc/do_special_effects(var/mob/living/carbon/human/H)
	return

/obj/item/melee/telebaton/attack_self(mob/user)
	on = !on
	if(on)
		user.visible_message(SPAN_WARNING("With a flick of their wrist, [user] extends their telescopic baton."), SPAN_WARNING("You extend the baton."), SPAN_WARNING("You hear an ominous click."))
		icon_state = state_extended
		item_state = state_extended
		w_class = ITEMSIZE_NORMAL
		force = 15 //quite robust
		attack_verb = list("smacked", "struck", "slapped")
	else
		user.visible_message(SPAN_NOTICE("\The [user] collapses their telescopic baton."), SPAN_NOTICE("You collapse the baton."), SPAN_NOTICE("You hear a click."))
		icon_state = initial(icon_state)
		item_state = initial(item_state)
		w_class = ITEMSIZE_SMALL
		force = 3 //not so robust now
		attack_verb = list("hit", "punched")

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	playsound(src.loc, 'sound/weapons/click.ogg', 50, 1)
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

/obj/item/melee/telebaton/attack(mob/target, mob/living/user, var/target_zone)
	if(on)
		do_special_effects(target)
		if(user.is_clumsy() && prob(50))
			to_chat(user, SPAN_WARNING("You club yourself over the head."))
			user.Weaken(3 * force)
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				H.apply_damage(2 * force, BRUTE, BP_HEAD)
			else
				user.take_organ_damage(2 * force)
			return
		if(..() && user.a_intent == I_DISARM)
			if(ishuman(target))
				var/mob/living/carbon/human/T = target
				T.apply_damage(40, PAIN, target_zone)
		return
	return ..()

/obj/item/melee/telebaton/nlom
	name = "nlomkala baton"
	icon = 'icons/obj/contained_items/skrell/skrell_weaponry.dmi'
	icon_state = "nlom_telebaton_0"
	item_state = "nlom_telebaton_0"
	state_extended = "nlom_telebaton_1"
	force = 5
	contained_sprite = TRUE

/obj/item/melee/telebaton/nlom/do_special_effects(var/mob/living/carbon/human/H)
	spark(H, 5)
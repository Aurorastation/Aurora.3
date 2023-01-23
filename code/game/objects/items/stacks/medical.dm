/*
Contains:
- Bruise Pack
- Ointment
- Advanced Trauma Kit
- Advanced Burn Kit
*/
/obj/item/stack/medical
	name = "medical pack"
	singular_name = "medical pack"
	icon = 'icons/obj/item/stacks/medical.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/stacks/lefthand_medical.dmi',
		slot_r_hand_str = 'icons/mob/items/stacks/righthand_medical.dmi',
		)
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'
	amount = 5
	max_amount = 5
	w_class = ITEMSIZE_SMALL
	throw_speed = 4
	throw_range = 20
	var/heal_brute = 0
	var/heal_burn = 0
	var/automatic_charge_overlays = FALSE	//Do we handle overlays with base update_icon()? | Stolen from TG egun code
	var/charge_sections = 5		// How many indicator blips are there?
	var/charge_x_offset = 2		//The spacing between each charge indicator. Should be 2 to leave a 1px gap between each blip.
	var/apply_sounds
	var/applied_sounds

/obj/item/stack/medical/attack(mob/living/M as mob, mob/user as mob)
	if (!istype(M) || istype(M, /mob/living/silicon) || istype(M, /mob/living/simple_animal/spiderbot))
		to_chat(user, SPAN_WARNING("\The [src] cannot be applied to [M]!"))
		return 1

	if ( ! (istype(user, /mob/living/carbon/human) || \
			istype(user, /mob/living/silicon)) )
		to_chat(user, SPAN_WARNING("You don't have the dexterity to do this!"))
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.name == BP_HEAD)
			if(H.head && istype(H.head,/obj/item/clothing/head/helmet/space))
				to_chat(user, SPAN_WARNING("You can't apply [src] through [H.head]!"))
				return 1
		else
			if(H.wear_suit && istype(H.wear_suit,/obj/item/clothing/suit/space))
				to_chat(user, SPAN_WARNING("You can't apply [src] through [H.wear_suit]!"))
				return 1

		if(affecting.status & ORGAN_LIFELIKE)
			if(!(affecting.brute_dam || affecting.burn_dam))
				to_chat(user, SPAN_NOTICE("[M] seems healthy, there are no wounds to treat! "))
				return 1

			user.visible_message( \
					SPAN_NOTICE("[user] starts applying \the [src] to [M]."), \
					SPAN_NOTICE("You start applying \the [src] to [M].")\
				)
			if (do_mob(user, M, 30))
				user.visible_message( \
					SPAN_NOTICE("[M] has been applied with [src] by [user]."), \
					SPAN_NOTICE("You apply \the [src] to [M].")\
				)
				use(1)
			return 1

		if(affecting.status & ORGAN_ASSISTED)
			to_chat(user, SPAN_WARNING("This isn't useful at all on a robotic limb."))
			return 1

		H.UpdateDamageIcon()

	else
		if (!M.getBruteLoss() && !M.getFireLoss())
			to_chat(user, SPAN_NOTICE("[M] seems healthy, there are no wounds to treat! "))
			return 1

		user.visible_message( \
				SPAN_NOTICE("[user] starts applying \the [src] to [M]."), \
				SPAN_NOTICE("You start applying \the [src] to [M].")\
			)
		if (do_mob(user, M, 30))
			M.heal_organ_damage((src.heal_brute/2), (src.heal_burn/2))
			user.visible_message( \
				SPAN_NOTICE("[M] has been applied with [src] by [user]."), \
				SPAN_NOTICE("You apply \the [src] to [M].")\
			)
			use(1)

	M.updatehealth()

/obj/item/stack/medical/use()
	. = ..()
	if(applied_sounds)
		playsound(src, applied_sounds, 25)

/obj/item/stack/medical/update_icon()
	if(QDELETED(src)) //Checks if the item has been deleted
		return	//If it has, do nothing
	..()
	if(!automatic_charge_overlays)	//Checks if the item has this feature enabled
		return	//If it does not, do nothing
	var/ratio = CEILING(clamp(amount / max_amount, 0, 1) * charge_sections, 1)
	cut_overlays()
	var/iconState = "[icon_state]_charge"
	if(!amount)	//Checks if there are still charges left in the item
		return //If it does not, do nothing, as the overlays have been cut before this already.
	else
		var/mutable_appearance/charge_overlay = mutable_appearance(icon, iconState)
		for(var/i = ratio, i >= 1, i--)
			charge_overlay.pixel_x = charge_x_offset * (i - 1)
			add_overlay(charge_overlay)

// Bruise Pack.
/obj/item/stack/medical/bruise_pack
	name = "roll of gauze"
	singular_name = "gauze length"
	desc = "Some sterile gauze to wrap around bloody stumps."
	icon_state = "brutepack"
	origin_tech = list(TECH_BIO = 1)
	heal_brute = 4
	icon_has_variants = TRUE
	apply_sounds = /singleton/sound_category/rip_sound
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'

/obj/item/stack/medical/bruise_pack/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/medical/bruise_pack/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (!can_use(1, user))
		return 0

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.open == 0)
			if(affecting.is_bandaged())
				to_chat(user, SPAN_WARNING("The wounds on [M]'s [affecting.name] have already been bandaged."))
				return 1
			else
				user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
				user.visible_message(SPAN_NOTICE("\The [user] starts treating [M]'s [affecting.name]."), \
						             SPAN_NOTICE("You start treating [M]'s [affecting.name]."))
				var/used = 0
				for (var/datum/wound/W in affecting.wounds)
					if(W.bandaged)
						continue
					if(used == amount)
						break
					if(!do_mob(user, M, W.damage/5))
						to_chat(user, SPAN_NOTICE("You must stand still to bandage wounds."))
						break
					if (W.current_stage <= W.max_bleeding_stage)
						user.visible_message(SPAN_NOTICE("\The [user] bandages \a [W.desc] on [M]'s [affecting.name]."), \
						                              SPAN_NOTICE("You bandage \a [W.desc] on [M]'s [affecting.name]."))
						//H.add_side_effect("Itch")
					else if (W.damage_type == BRUISE)
						user.visible_message(SPAN_NOTICE("\The [user] places a bruise patch over \a [W.desc] on [M]'s [affecting.name]."), \
						                              SPAN_NOTICE("You place a bruise patch over \a [W.desc] on [M]'s [affecting.name]."))
					else
						user.visible_message(SPAN_NOTICE("\The [user] places a bandaid over \a [W.desc] on [M]'s [affecting.name]."), \
						                              SPAN_NOTICE("You place a bandaid over \a [W.desc] on [M]'s [affecting.name]."))
					W.bandage()
					playsound(src, apply_sounds, 25)
					used++
				affecting.update_damages()
				if(used == amount)
					if(affecting.is_bandaged())
						to_chat(user, SPAN_WARNING("\The [src] is used up."))
					else
						to_chat(user, SPAN_WARNING("\The [src] is used up, but there are more wounds to treat on \the [affecting.name]."))
				use(used)
				H.update_bandages(TRUE)
		else
			if (can_operate(H))        //Checks if mob is lying down on table for surgery
				if (do_surgery(H,user,src))
					return
			else
				to_chat(user, SPAN_NOTICE("The [affecting.name] is cut open, you'll need more than a bandage!"))

// Ointment.
/obj/item/stack/medical/ointment
	name = "ointment"
	desc = "Used to treat those nasty burns."
	gender = PLURAL
	singular_name = "ointment"
	icon_state = "ointment"
	heal_burn = 4
	origin_tech = list(TECH_BIO = 1)
	icon_has_variants = TRUE
	apply_sounds = /singleton/sound_category/ointment_sound
	drop_sound = 'sound/items/drop/herb.ogg'
	pickup_sound = 'sound/items/pickup/herb.ogg'

/obj/item/stack/medical/ointment/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/medical/ointment/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (!can_use(1, user))
		return 0

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.open == 0)
			if(affecting.is_salved())
				to_chat(user, SPAN_WARNING("The wounds on [M]'s [affecting.name] have already been salved."))
				return 1
			else
				user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
				user.visible_message(SPAN_NOTICE("\The [user] starts salving wounds on [M]'s [affecting.name]."), \
						             SPAN_NOTICE("You start salving the wounds on [M]'s [affecting.name]."))
				playsound(src, pick(apply_sounds), 25)
				if(!do_mob(user, M, 10))
					to_chat(user, SPAN_NOTICE("You must stand still to salve wounds."))
					return 1
				user.visible_message(SPAN_NOTICE("[user] salved wounds on [M]'s [affecting.name]."), \
				                     SPAN_NOTICE("You salved wounds on [M]'s [affecting.name]."))
				use(1)
				affecting.salve()
		else
			if (can_operate(H))        //Checks if mob is lying down on table for surgery
				if (do_surgery(H,user,src))
					return
			else
				to_chat(user, SPAN_NOTICE("The [affecting.name] is cut open, you'll need more than a bandage!"))

// Advanced Trauma Kit.
/obj/item/stack/medical/advanced/bruise_pack
	name = "advanced trauma kit"
	singular_name = "advanced trauma kit"
	desc = "An advanced trauma kit for severe injuries."
	icon_state = "traumakit"
	heal_brute = 8
	origin_tech = list(TECH_BIO = 1)
	apply_sounds = /singleton/sound_category/rip_sound
	applied_sounds = 'sound/items/advkit.ogg'
	automatic_charge_overlays = TRUE

/obj/item/stack/medical/advanced/bruise_pack/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/medical/advanced/bruise_pack/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (!can_use(1, user))
		return 0

	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.open == 0)
			if(affecting.is_bandaged() && affecting.is_disinfected())
				to_chat(user, SPAN_WARNING("The wounds on [M]'s [affecting.name] have already been treated."))
				return 1
			else
				user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
				user.visible_message(SPAN_NOTICE("\The [user] starts treating [M]'s [affecting.name]."), \
						             SPAN_NOTICE("You start treating [M]'s [affecting.name]."))
				var/used = 0
				for (var/datum/wound/W in affecting.wounds)
					if (W.bandaged && W.disinfected)
						continue
					if(used == amount)
						break
					if(!do_mob(user, M, W.damage/5))
						to_chat(user, SPAN_NOTICE("You must stand still to bandage wounds."))
						break
					if (W.current_stage <= W.max_bleeding_stage)
						user.visible_message(SPAN_NOTICE("\The [user] cleans \a [W.desc] on [M]'s [affecting.name] and seals the edges with bioglue."), \
						                     SPAN_NOTICE("You clean and seal \a [W.desc] on [M]'s [affecting.name]."))
						//H.add_side_effect("Itch")
					else if (W.damage_type == BRUISE)
						user.visible_message(SPAN_NOTICE("\The [user] places a medical patch over \a [W.desc] on [M]'s [affecting.name]."), \
						                              SPAN_NOTICE("You place a medical patch over \a [W.desc] on [M]'s [affecting.name]."))
					else
						user.visible_message(SPAN_NOTICE("\The [user] smears some bioglue over \a [W.desc] on [M]'s [affecting.name]."), \
						                              SPAN_NOTICE("You smear some bioglue over \a [W.desc] on [M]'s [affecting.name]."))
					playsound(src, pick(apply_sounds), 25)
					W.bandage()
					W.disinfect()
					W.heal_damage(heal_brute)
					used++
				affecting.update_damages()
				if(used == amount)
					if(affecting.is_bandaged())
						to_chat(user, SPAN_WARNING("\The [src] is used up."))
					else
						to_chat(user, SPAN_WARNING("\The [src] is used up, but there are more wounds to treat on \the [affecting.name]."))
				use(used)
				H.update_bandages(TRUE)
		else
			if (can_operate(H))        //Checks if mob is lying down on table for surgery
				if (do_surgery(H,user,src))
					return
			else
				to_chat(user, SPAN_NOTICE("The [affecting.name] is cut open, you'll need more than a bandage!"))

// Advanced Burn Kit.
/obj/item/stack/medical/advanced/ointment
	name = "advanced burn kit"
	singular_name = "advanced burn kit"
	desc = "An advanced treatment kit for severe burns."
	icon_state = "burnkit"
	heal_burn = 8
	origin_tech = list(TECH_BIO = 1)
	apply_sounds = /singleton/sound_category/ointment_sound
	applied_sounds = 'sound/items/advkit.ogg'
	automatic_charge_overlays = TRUE

/obj/item/stack/medical/advanced/ointment/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/medical/advanced/ointment/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.open == 0)
			if(affecting.is_salved())
				to_chat(user, SPAN_WARNING("The wounds on [M]'s [affecting.name] have already been salved."))
				return 1
			else
				user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
				user.visible_message(SPAN_NOTICE("\The [user] starts salving wounds on [M]'s [affecting.name]."), \
						             SPAN_NOTICE("You start salving the wounds on [M]'s [affecting.name]."))
				playsound(src, pick(apply_sounds), 25)
				if(!do_mob(user, M, 10))
					to_chat(user, SPAN_NOTICE("You must stand still to salve wounds."))
					return 1
				user.visible_message(SPAN_NOTICE("[user] covers wounds on [M]'s [affecting.name] with regenerative membrane."), \
									 SPAN_NOTICE("You cover wounds on [M]'s [affecting.name] with regenerative membrane."))
				affecting.heal_damage(0,heal_burn)
				use(1)
				affecting.salve()
		else
			if (can_operate(H))        //Checks if mob is lying down on table for surgery
				if (do_surgery(H,user,src))
					return
			else
				to_chat(user, SPAN_NOTICE("The [affecting.name] is cut open, you'll need more than a bandage!"))

/obj/item/stack/medical/splint
	name = "medical splints"
	desc = "Modular splints capable of supporting and immobilizing bones in both limbs and appendages."
	singular_name = "medical splint"
	icon_state = "splint"
	amount = 5
	max_amount = 5
	drop_sound = 'sound/items/drop/hat.ogg'
	pickup_sound = 'sound/items/pickup/hat.ogg'
	var/list/splintable_organs = list(BP_L_ARM,BP_R_ARM,BP_L_LEG,BP_R_LEG, BP_L_HAND, BP_R_HAND, BP_R_FOOT, BP_L_FOOT)

/obj/item/stack/medical/splint/full/Initialize()
	. = ..()
	amount = max_amount
	update_icon()

/obj/item/stack/medical/splint/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (!can_use(1, user))
		return 0

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)
		var/limb = affecting.name
		if(!(affecting.limb_name in splintable_organs))
			to_chat(user, SPAN_DANGER("You can't apply a splint there!"))
			return
		if(affecting.status & ORGAN_SPLINTED)
			to_chat(user, SPAN_DANGER("[M]'s [limb] is already splinted!"))
			return
		if (M != user)
			user.visible_message(SPAN_DANGER("[user] starts to apply \the [src] to [M]'s [limb]."), SPAN_DANGER("You start to apply \the [src] to [M]'s [limb]."), SPAN_DANGER("You hear something being wrapped."))
		else
			if((!user.hand && affecting.limb_name == BP_R_ARM) || (user.hand && affecting.limb_name == BP_L_ARM))
				to_chat(user, SPAN_DANGER("You can't apply a splint to the arm you're using!"))
				return
			user.visible_message(SPAN_DANGER("[user] starts to apply \the [src] to their [limb]."), SPAN_DANGER("You start to apply \the [src] to your [limb]."), SPAN_DANGER("You hear something being wrapped."))
		if(do_after(user, 50))
			if (M != user)
				user.visible_message(SPAN_DANGER("[user] finishes applying \the [src] to [M]'s [limb]."), SPAN_DANGER("You finish applying \the [src] to [M]'s [limb]."), SPAN_DANGER("You hear something being wrapped."))
			else
				if(prob(25))
					user.visible_message(SPAN_DANGER("[user] successfully applies \the [src] to their [limb]."), SPAN_DANGER("You successfully apply \the [src] to your [limb]."), SPAN_DANGER("You hear something being wrapped."))
				else
					user.visible_message(SPAN_DANGER("[user] fumbles \the [src]."), SPAN_DANGER("You fumble \the [src]."), SPAN_DANGER("You hear something being wrapped."))
					return
			affecting.status |= ORGAN_SPLINTED
			use(1)
		return

/obj/item/stack/medical/splint/makeshift
	name = "makeshift splints"
	singular_name = "makeshift splint"
	desc = "For holding your limbs in place with duct tape and scrap metal."
	icon_state = "tape-splint"
	amount = 1
	splintable_organs = list(BP_L_ARM,BP_R_ARM,BP_L_LEG,BP_R_LEG)

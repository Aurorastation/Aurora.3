/*
Contains:
- Bruise Pack
- Ointment
- Advanced Trauma Kit
- Advanced Burn Kit
- Space Klot

*/
/obj/item/stack/medical
	name = "medical pack"
	singular_name = "medical pack"
	icon = 'icons/obj/stacks/medical.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/stacks/lefthand_medical.dmi',
		slot_r_hand_str = 'icons/mob/items/stacks/righthand_medical.dmi',
		)
	drop_sound = 'sound/items/drop/box.ogg'
	amount = 5
	max_amount = 5
	w_class = 2
	throw_speed = 4
	throw_range = 20
	var/heal_brute = 0
	var/heal_burn = 0
	var/apply_sounds

/obj/item/stack/medical/attack(mob/living/M as mob, mob/user as mob)
	if (!istype(M) || istype(M, /mob/living/silicon) || istype(M, /mob/living/simple_animal/spiderbot))
		to_chat(user, "<span class='warning'>\The [src] cannot be applied to [M]!</span>")
		return 1

	if ( ! (istype(user, /mob/living/carbon/human) || \
			istype(user, /mob/living/silicon)) )
		to_chat(user, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.name == BP_HEAD)
			if(H.head && istype(H.head,/obj/item/clothing/head/helmet/space))
				to_chat(user, "<span class='warning'>You can't apply [src] through [H.head]!</span>")
				return 1
		else
			if(H.wear_suit && istype(H.wear_suit,/obj/item/clothing/suit/space))
				to_chat(user, "<span class='warning'>You can't apply [src] through [H.wear_suit]!</span>")
				return 1

		if(affecting.status & ORGAN_ASSISTED)
			to_chat(user, "<span class='warning'>This isn't useful at all on a robotic limb.</span>")
			return 1

		H.UpdateDamageIcon()

	else
		if (!M.getBruteLoss() && !M.getFireLoss())
			to_chat(user, "<span class='notice'> [M] seems healthy, there are no wounds to treat! </span>")
			return 1

		user.visible_message( \
				"<span class = 'notice'> [user] starts applying \the [src] to [M].</span>", \
				"<span class = 'notice'> You start applying \the [src] to [M].</span>" \
			)
		if (do_mob(user, M, 30))
			M.heal_organ_damage((src.heal_brute/2), (src.heal_burn/2))
			user.visible_message( \
				"<span class = 'notice'> [M] has been applied with [src] by [user].</span>", \
				"<span class = 'notice'> You apply \the [src] to [M].</span>" \
			)
			use(1)

	M.updatehealth()

// Bruise Pack.
/obj/item/stack/medical/bruise_pack
	name = "roll of gauze"
	singular_name = "gauze length"
	desc = "Some sterile gauze to wrap around bloody stumps."
	icon_state = "brutepack"
	origin_tech = list(TECH_BIO = 1)
	heal_brute = 4
	icon_has_variants = TRUE
	apply_sounds = list('sound/items/rip1.ogg','sound/items/rip2.ogg')
	drop_sound = 'sound/items/drop/gloves.ogg'

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
				to_chat(user, "<span class='warning'>The wounds on [M]'s [affecting.name] have already been bandaged.</span>")
				return 1
			else
				user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
				user.visible_message("<span class='notice'>\The [user] starts treating [M]'s [affecting.name].</span>", \
						             "<span class='notice'>You start treating [M]'s [affecting.name].</span>" )
				var/used = 0
				for (var/datum/wound/W in affecting.wounds)
					if(W.bandaged)
						continue
					if(used == amount)
						break
					if(!do_mob(user, M, W.damage/5))
						to_chat(user, "<span class='notice'>You must stand still to bandage wounds.</span>")
						break
					if (W.current_stage <= W.max_bleeding_stage)
						user.visible_message("<span class='notice'>\The [user] bandages \a [W.desc] on [M]'s [affecting.name].</span>", \
						                              "<span class='notice'>You bandage \a [W.desc] on [M]'s [affecting.name].</span>" )
						//H.add_side_effect("Itch")
					else if (W.damage_type == BRUISE)
						user.visible_message("<span class='notice'>\The [user] places a bruise patch over \a [W.desc] on [M]'s [affecting.name].</span>", \
						                              "<span class='notice'>You place a bruise patch over \a [W.desc] on [M]'s [affecting.name].</span>" )
					else
						user.visible_message("<span class='notice'>\The [user] places a bandaid over \a [W.desc] on [M]'s [affecting.name].</span>", \
						                              "<span class='notice'>You place a bandaid over \a [W.desc] on [M]'s [affecting.name].</span>" )
					W.bandage()
					playsound(src, pick(apply_sounds), 25)
					used++
				affecting.update_damages()
				if(used == amount)
					if(affecting.is_bandaged())
						to_chat(user, "<span class='warning'>\The [src] is used up.</span>")
					else
						to_chat(user, "<span class='warning'>\The [src] is used up, but there are more wounds to treat on \the [affecting.name].</span>")
				use(used)
		else
			if (can_operate(H))        //Checks if mob is lying down on table for surgery
				if (do_surgery(H,user,src))
					return
			else
				to_chat(user, "<span class='notice'>The [affecting.name] is cut open, you'll need more than a bandage!</span>")

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
	apply_sounds = list('sound/items/ointment.ogg')
	drop_sound = 'sound/items/drop/herb.ogg'

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
				to_chat(user, "<span class='warning'>The wounds on [M]'s [affecting.name] have already been salved.</span>")
				return 1
			else
				user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
				user.visible_message("<span class='notice'>\The [user] starts salving wounds on [M]'s [affecting.name].</span>", \
						             "<span class='notice'>You start salving the wounds on [M]'s [affecting.name].</span>" )
				playsound(src, pick(apply_sounds), 25)
				if(!do_mob(user, M, 10))
					to_chat(user, "<span class='notice'>You must stand still to salve wounds.</span>")
					return 1
				user.visible_message("<span class='notice'>[user] salved wounds on [M]'s [affecting.name].</span>", \
				                         "<span class='notice'>You salved wounds on [M]'s [affecting.name].</span>" )
				use(1)
				affecting.salve()
		else
			if (can_operate(H))        //Checks if mob is lying down on table for surgery
				if (do_surgery(H,user,src))
					return
			else
				to_chat(user, "<span class='notice'>The [affecting.name] is cut open, you'll need more than a bandage!</span>")

// Advanced Trauma Kit.
/obj/item/stack/medical/advanced/bruise_pack
	name = "advanced trauma kit"
	singular_name = "advanced trauma kit"
	desc = "An advanced trauma kit for severe injuries."
	icon_state = "traumakit"
	heal_brute = 8
	origin_tech = list(TECH_BIO = 1)
	apply_sounds = list('sound/items/rip1.ogg','sound/items/rip2.ogg','sound/items/tape.ogg')

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
				to_chat(user, "<span class='warning'>The wounds on [M]'s [affecting.name] have already been treated.</span>")
				return 1
			else
				user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
				user.visible_message("<span class='notice'>\The [user] starts treating [M]'s [affecting.name].</span>", \
						             "<span class='notice'>You start treating [M]'s [affecting.name].</span>" )
				var/used = 0
				for (var/datum/wound/W in affecting.wounds)
					if (W.bandaged && W.disinfected)
						continue
					if(used == amount)
						break
					if(!do_mob(user, M, W.damage/5))
						to_chat(user, "<span class='notice'>You must stand still to bandage wounds.</span>")
						break
					if (W.current_stage <= W.max_bleeding_stage)
						user.visible_message("<span class='notice'>\The [user] cleans \a [W.desc] on [M]'s [affecting.name] and seals the edges with bioglue.</span>", \
						                     "<span class='notice'>You clean and seal \a [W.desc] on [M]'s [affecting.name].</span>" )
						//H.add_side_effect("Itch")
					else if (W.damage_type == BRUISE)
						user.visible_message("<span class='notice'>\The [user] places a medical patch over \a [W.desc] on [M]'s [affecting.name].</span>", \
						                              "<span class='notice'>You place a medical patch over \a [W.desc] on [M]'s [affecting.name].</span>" )
					else
						user.visible_message("<span class='notice'>\The [user] smears some bioglue over \a [W.desc] on [M]'s [affecting.name].</span>", \
						                              "<span class='notice'>You smear some bioglue over \a [W.desc] on [M]'s [affecting.name].</span>" )
					playsound(src, pick(apply_sounds), 25)
					W.bandage()
					W.disinfect()
					W.heal_damage(heal_brute)
					used++
				affecting.update_damages()
				if(used == amount)
					if(affecting.is_bandaged())
						to_chat(user, "<span class='warning'>\The [src] is used up.</span>")
					else
						to_chat(user, "<span class='warning'>\The [src] is used up, but there are more wounds to treat on \the [affecting.name].</span>")
				use(used)
		else
			if (can_operate(H))        //Checks if mob is lying down on table for surgery
				if (do_surgery(H,user,src))
					return
			else
				to_chat(user, "<span class='notice'>The [affecting.name] is cut open, you'll need more than a bandage!</span>")

// Advanced Burn Kit.
/obj/item/stack/medical/advanced/ointment
	name = "advanced burn kit"
	singular_name = "advanced burn kit"
	desc = "An advanced treatment kit for severe burns."
	icon_state = "burnkit"
	heal_burn = 8
	origin_tech = list(TECH_BIO = 1)
	apply_sounds = list('sound/items/ointment.ogg')

/obj/item/stack/medical/advanced/ointment/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.open == 0)
			if(affecting.is_salved())
				to_chat(user, "<span class='warning'>The wounds on [M]'s [affecting.name] have already been salved.</span>")
				return 1
			else
				user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
				user.visible_message("<span class='notice'>\The [user] starts salving wounds on [M]'s [affecting.name].</span>", \
						             "<span class='notice'>You start salving the wounds on [M]'s [affecting.name].</span>" )
				playsound(src, pick(apply_sounds), 25)
				if(!do_mob(user, M, 10))
					to_chat(user, "<span class='notice'>You must stand still to salve wounds.</span>")
					return 1
				user.visible_message( 	"<span class='notice'>[user] covers wounds on [M]'s [affecting.name] with regenerative membrane.</span>", \
										"<span class='notice'>You cover wounds on [M]'s [affecting.name] with regenerative membrane.</span>" )
				affecting.heal_damage(0,heal_burn)
				use(1)
				affecting.salve()
		else
			if (can_operate(H))        //Checks if mob is lying down on table for surgery
				if (do_surgery(H,user,src))
					return
			else
				to_chat(user, "<span class='notice'>The [affecting.name] is cut open, you'll need more than a bandage!</span>")

// Space Klot. This stops bleeding and has a small chance to stop some internal bleeding, but it will be locked behind a tech tree + does not disinfect like a normal bruise pack.
/obj/item/stack/medical/advanced/bruise_pack/spaceklot
	name = "space klot"
	singular_name = "space klot"
	desc = "A powder that, when poured on an open wound, quickly stops the bleeding. Combine with bandages for the best effect."
	icon_state = "powderbag"
	heal_brute = 15
	origin_tech = list(TECH_BIO = 4)
	var/open = 0
	var/used = 0

/obj/item/stack/medical/advanced/bruise_pack/spaceklot/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1
	if(used)
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.open == 0)
			if(affecting.is_bandaged())
				to_chat(user, "<span class='warning'>The wounds on [M]'s [affecting.name] have already been treated.</span>")
				return 1
			else
				user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
				user.visible_message("<span class='notice'>\The [user] starts treating [M]'s [affecting.name].</span>", \
						             "<span class='notice'>You start treating [M]'s [affecting.name].</span>" )
				if(!do_after(user, 100, act_target = M))
					return
				for (var/datum/wound/W in affecting.wounds)
					if (W.bandaged)
						continue
					if(used == amount)
						break
					if(!do_mob(user, M, W.damage/5))
						to_chat(user, "<span class='notice'>You must stand still to bandage wounds.</span>")
						break
					if (W.current_stage <= W.max_bleeding_stage)
						user.visible_message("<span class='notice'>\The [user] pours the powder \a [W.desc] on [M]'s [affecting.name].</span>", \
						                     "<span class='notice'>You pour the powder \a [W.desc] on [M]'s [affecting.name].</span>" )

					W.bandage()
					W.heal_damage(heal_brute, 0)
					used = 1
				affecting.update_damages()


/obj/item/stack/medical/splint
	name = "medical splints"
	desc = "Modular splints capable of supporting and immobilizing bones in both limbs and appendages."
	singular_name = "medical splint"
	icon_state = "splint"
	amount = 5
	max_amount = 5
	drop_sound = 'sound/items/drop/hat.ogg'
	var/list/splintable_organs = list(BP_L_ARM,BP_R_ARM,BP_L_LEG,BP_R_LEG, BP_L_HAND, BP_R_HAND, BP_R_FOOT, BP_L_FOOT)

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
			to_chat(user, "<span class='danger'>You can't apply a splint there!</span>")
			return
		if(affecting.status & ORGAN_SPLINTED)
			to_chat(user, "<span class='danger'>[M]'s [limb] is already splinted!</span>")
			return
		if (M != user)
			user.visible_message("<span class='danger'>[user] starts to apply \the [src] to [M]'s [limb].</span>", "<span class='danger'>You start to apply \the [src] to [M]'s [limb].</span>", "<span class='danger'>You hear something being wrapped.</span>")
		else
			if((!user.hand && affecting.limb_name == BP_R_ARM) || (user.hand && affecting.limb_name == BP_L_ARM))
				to_chat(user, "<span class='danger'>You can't apply a splint to the arm you're using!</span>")
				return
			user.visible_message("<span class='danger'>[user] starts to apply \the [src] to their [limb].</span>", "<span class='danger'>You start to apply \the [src] to your [limb].</span>", "<span class='danger'>You hear something being wrapped.</span>")
		if(do_after(user, 50))
			if (M != user)
				user.visible_message("<span class='danger'>[user] finishes applying \the [src] to [M]'s [limb].</span>", "<span class='danger'>You finish applying \the [src] to [M]'s [limb].</span>", "<span class='danger'>You hear something being wrapped.</span>")
			else
				if(prob(25))
					user.visible_message("<span class='danger'>[user] successfully applies \the [src] to their [limb].</span>", "<span class='danger'>You successfully apply \the [src] to your [limb].</span>", "<span class='danger'>You hear something being wrapped.</span>")
				else
					user.visible_message("<span class='danger'>[user] fumbles \the [src].</span>", "<span class='danger'>You fumble \the [src].</span>", "<span class='danger'>You hear something being wrapped.</span>")
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

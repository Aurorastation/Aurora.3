/obj/item/stack/nanopaste
	name = "nanopaste"
	singular_name = "nanite swarm"
	desc = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery."
	icon = 'icons/obj/item/stacks/nanopaste.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/stacks/lefthand_nanopaste.dmi',
		slot_r_hand_str = 'icons/mob/items/stacks/righthand_nanopaste.dmi',
		)
	icon_state = "tube"
	origin_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	amount = 10

	var/list/construction_cost = list(DEFAULT_WALL_MATERIAL = 7000, MATERIAL_GLASS = 7000)

/obj/item/stack/nanopaste/update_icon()
	var/amount = round(get_amount() / 2)
	if(amount >= 5)
		icon_state = "[initial(icon_state)]"
	else if(amount > 0)
		icon_state = "[initial(icon_state)]-[amount]"
	else
		icon_state = "[initial(icon_state)]-empty"
	check_maptext(SMALL_FONTS(7, amount))

/obj/item/stack/nanopaste/attack(atom/M, mob/user, var/target_zone)
	if(!ismob(M) || !istype(user))
		return 0
	if (!can_use(1, user))
		return 0

	if (isrobot(M))	//Repairing cyborgs
		var/mob/living/silicon/robot/R = M
		if (R.getBruteLoss() || R.getFireLoss() )
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			if(do_mob(user, M, 7))
				R.adjustBruteLoss(-15)
				R.adjustFireLoss(-15)
				R.updatehealth()
				use(1)
				user.visible_message(SPAN_NOTICE("\The [user] applied some [src] at [R]'s damaged areas."),\
									 SPAN_NOTICE("You apply some [src] at [R]'s damaged areas."))
		else
			to_chat(user, SPAN_NOTICE("All [R]'s systems are nominal."))

	else if(ishuman(M))		//Repairing robolimbs
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/S = H.get_organ(target_zone)

		if (S && (S.status & ORGAN_ASSISTED))
			if(S.get_damage())
				user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

				if(S.limb_name == BP_HEAD)
					if(H.head && istype(H.head,/obj/item/clothing/head/helmet/space))
						to_chat(user, SPAN_WARNING("You can't apply [src] through [H.head]!"))
						return
				else
					if(H.wear_suit && istype(H.wear_suit,/obj/item/clothing/suit/space))
						to_chat(user, SPAN_WARNING("You can't apply [src] through [H.wear_suit]!"))
						return

				if(do_mob(user, M, 7))
					S.heal_damage(15, 15, robo_repair = 1)
					H.updatehealth()
					use(1)
					user.visible_message(SPAN_NOTICE("\The [user] applies some nanite paste at[user != M ? " \the [M]'s" : " \the [user]"] [S.name] with \the [src]."),\
										 SPAN_NOTICE("You apply some nanite paste at [user == M ? "your" : "[M]'s"] [S.name]."))
			else
				to_chat(user, SPAN_NOTICE("Nothing to fix here."))
		else
			if (can_operate(H))
				if (do_surgery(H,user,src))
					return
			else
				to_chat(user, SPAN_NOTICE("Nothing to fix in here."))


/obj/item/stack/nanopaste/surge
	name = "modified nanopaste"
	singular_name = "nanite swarm"
	desc = "A tube of paste containing swarms of repair nanites. This one appears to contain different nanites."
	icon_state = "tube-surge"
	origin_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 4, TECH_MAGNET = 5, TECH_POWER = 5, TECH_COMBAT = 3, TECH_ILLEGAL = 4)
	amount = 20
	var/used = FALSE
	construction_cost = null

/obj/item/stack/nanopaste/surge/attack(mob/living/carbon/human/M as mob, mob/user as mob, var/target_zone)
	if (!istype(M) || !istype(user))
		return 0

	if(used)
		to_chat(user, SPAN_WARNING("[src] has depleted it's nanites."))
		return 0

	if (isipc(M))
		var/obj/item/organ/internal/surge/s = M.internal_organs_by_name["surge"]
		if(isnull(s))
			user.visible_message(
			SPAN_NOTICE("[user] is trying to apply [src] to [(M == user) ? ("itself") : (M)]!"),
			SPAN_NOTICE("You start applying [src] to [(M == user) ? ("yourself") : (M)]!")
			)

			if (!do_mob(user, M, 2))
				return 0

			s = new /obj/item/organ/internal/surge()
			M.internal_organs += s
			M.internal_organs_by_name["surge"] = s
			user.visible_message(
			SPAN_NOTICE("[user] applies some nanite paste to [(M == user) ? ("itself") : (M)]!"),
			SPAN_NOTICE("You apply [src] to [(M == user) ? ("youself") : (M)].")
			)
			to_chat(M, SPAN_NOTICE("You can feel nanites inside you creating something new. An internal OS voice states \"Warning: surge prevention module has been installed, it has [s.surge_left] preventions left!\""))
			amount = 0
			used = TRUE
			return 1
		else
			if(!s.surge_left)
				user.visible_message(
				SPAN_NOTICE("[user] is trying to apply [src] to [(M == user) ? ("itself") : (M)]!"),
				SPAN_NOTICE("You start applying [src] to [(M == user) ? ("yourself") : (M)]!")
				)

				if (!do_mob(user, M, 2))
					return 0

				s.surge_left = rand(2, 5)
				s.broken = 0
				s.icon_state = "surge_ipc"

				user.visible_message(
				SPAN_NOTICE("[user] applies some nanite paste to [(M == user) ? ("itself") : (M)]!"),
				SPAN_NOTICE("You apply [src] to [(M == user) ? ("yourself") : (M)].")
				)
				to_chat(M,  SPAN_NOTICE("You can feel nanites inside you regenerating your surge prevention module. An internal OS voice states \"Warning: surge prevention module repaired, it has [s.surge_left] preventions left!\""))
				amount = 0
				used = TRUE
				return 1

			to_chat(user, SPAN_WARNING("[(M == user) ? ("You already have") : ("[M] already has")] fully functional surge prevention module installed."))
			return 0
	else
		to_chat(user, SPAN_WARNING("[src]'s nanites refuse to work on [(M == user) ? ("you") : (M)]."))
		return 0

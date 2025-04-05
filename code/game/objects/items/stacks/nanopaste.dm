// Repairs robotic limbs and silicon mobs, with a limited number of uses.
/obj/item/stack/nanopaste
	name = "nanopaste"
	singular_name = "nanite swarm"
	desc = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery."
	icon = 'icons/obj/item/stacks/nanopaste.dmi'
	icon_state = "tube"
	item_state = "tube"
	contained_sprite = TRUE
	origin_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	amount = 10
	surgerysound = 'sound/items/surgery/bonegel.ogg'

	desc_extended = "It takes significantly longer to apply nanopaste to yourself than it does to apply it to others. Nanites are best enjoyed with a friend!"

	/// What materials does it take to fabricate nanopaste?
	var/list/construction_cost = list(DEFAULT_WALL_MATERIAL = 7000, MATERIAL_GLASS = 7000)
	/// How long does it take to apply nanopaste?
	var/time_to_apply = 2 SECONDS
	/// Multiplier applied to time_to_apply, if we want it to take longer in some situations.
	var/application_multiplier = 5
	/// Used to prevent applying nanopaste multiple times at once.
	var/application_in_progress = FALSE

/obj/item/stack/nanopaste/update_icon()
	var/amount = round(get_amount() / 2)
	if(amount >= 5)
		icon_state = "[initial(icon_state)]"
	else if(amount > 0)
		icon_state = "[initial(icon_state)]-[amount]"
	else
		icon_state = "[initial(icon_state)]-empty"
	check_maptext(SMALL_FONTS(7, amount))

/obj/item/stack/nanopaste/attack(mob/living/target_mob, mob/living/user, target_zone)
	var/application_time = time_to_apply // Local variant declared inside the proc so changes to it do not persist.

	if(!ismob(target_mob) || !istype(user))
		return 0
	if (!can_use(1, user))
		return 0

	if (isrobot(target_mob))	//Repairing cyborgs
		var/mob/living/silicon/robot/R = target_mob
		if (R.getBruteLoss() || R.getFireLoss() )

			if(target_mob == user)
				application_time *= application_multiplier // It takes longer to apply nanopaste to yourself than to someone else.

			if (application_in_progress == FALSE)
				application_in_progress = TRUE
				user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
				user.visible_message(SPAN_NOTICE("\The [user] begins to apply some [src] to \the [target_mob]."),\
										SPAN_NOTICE("You begin to apply some [src] to \the [target_mob]."))
				if(do_mob(user, target_mob, application_time))
					R.adjustBruteLoss(-15)
					R.adjustFireLoss(-15)
					R.updatehealth()
					use(1)
					user.visible_message(SPAN_NOTICE("\The [user] successfully applies some [src] at [R]'s damaged areas."),\
											SPAN_NOTICE("You successfully apply some [src] at [R]'s damaged areas."))
				application_in_progress = FALSE
			else
				to_chat(user, SPAN_WARNING("You are too focused applying \the [src] to do it multiple times simultaneously!"))

		else
			to_chat(user, SPAN_NOTICE("All [R]'s systems are nominal."))

	else if(ishuman(target_mob))		//Repairing robolimbs
		var/mob/living/carbon/human/H = target_mob
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
				if(target_mob == user)
					application_time *= application_multiplier // It takes longer to apply nanopaste to yourself than to someone else.

				if (application_in_progress == FALSE)
					application_in_progress = TRUE
					user.visible_message(SPAN_NOTICE("\The [user] begins to apply some nanite paste at[user != target_mob ? " \the [target_mob]'s" : " \the [user]"] [S.name] with \the [src]."),\
											SPAN_NOTICE("You begin to apply some nanite paste at[user != target_mob ? " \the [target_mob]'s" : " \the [user]"] [S.name] with \the [src]."))
					if(do_mob(user, target_mob, application_time))
						S.heal_damage(15, 15, robo_repair = 1)
						H.updatehealth()
						use(1)
						user.visible_message(SPAN_NOTICE("\The [user] successfully applies some nanite paste at[user != target_mob ? " \the [target_mob]'s" : " \the [user]"] [S.name] with \the [src]."),\
												SPAN_NOTICE("You successfully apply some nanite paste at [user == target_mob ? "your" : "[target_mob]'s"] [S.name]."))
					application_in_progress = FALSE
				else
					to_chat(user, SPAN_WARNING("You are too focused applying \the [src] to do it multiple times simultaneously!"))

			else
				to_chat(user, SPAN_NOTICE("Nothing to fix here."))
		else
			if (can_operate(H))
				if (do_surgery(H,user,src))
					return
			else
				to_chat(user, SPAN_NOTICE("Nothing to fix in here."))


// Antagonist-specific nanopaste. Functions similarly to usual nanopaste, except that it also applies a surge protection organ to the target.
// This organ protects the target from a specific number of EMPs. Intended to provide antagonist IPCs counterplay to ions.
/obj/item/stack/nanopaste/surge
	name = "modified nanopaste"
	singular_name = "nanite swarm"
	desc = "A tube of paste containing swarms of repair nanites. This one appears to contain different nanites."
	icon_state = "tube-surge"
	item_state = "tube-surge"
	origin_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 4, TECH_MAGNET = 5, TECH_POWER = 5, TECH_COMBAT = 3, TECH_ILLEGAL = 4)
	amount = 20
	var/used = FALSE
	construction_cost = null

/obj/item/stack/nanopaste/surge/attack(mob/living/target_mob, mob/living/user, target_zone)
	var/mob/living/carbon/human/M = target_mob
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

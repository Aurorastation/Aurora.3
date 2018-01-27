/obj/item/stack/nanopaste
	name = "nanopaste"
	singular_name = "nanite swarm"
	desc = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery."
	icon = 'icons/obj/nanopaste.dmi'
	icon_state = "tube"
	origin_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	amount = 10

	var/list/construction_cost = list(DEFAULT_WALL_MATERIAL = 7000, "glass" = 7000)


/obj/item/stack/nanopaste/attack(mob/living/M as mob, mob/user as mob, var/target_zone)
	if (!istype(M) || !istype(user))
		return 0
	if (istype(M,/mob/living/silicon/robot))	//Repairing cyborgs
		var/mob/living/silicon/robot/R = M
		if (R.getBruteLoss() || R.getFireLoss() )
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			if(do_mob(user, M, 7))
				R.adjustBruteLoss(-15)
				R.adjustFireLoss(-15)
				R.updatehealth()
				use(1)
				user.visible_message("<span class='notice'>\The [user] applied some [src] at [R]'s damaged areas.</span>",\
					"<span class='notice'>You apply some [src] at [R]'s damaged areas.</span>")
		else
			user << "<span class='notice'>All [R]'s systems are nominal.</span>"

	if (istype(M,/mob/living/carbon/human))		//Repairing robolimbs
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/S = H.get_organ(target_zone)

		if (S && (S.status & ORGAN_ROBOT))
			if(S.get_damage())
				user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

				if(S.limb_name == "head")
					if(H.head && istype(H.head,/obj/item/clothing/head/helmet/space))
						user << "<span class='warning'>You can't apply [src] through [H.head]!</span>"
						return
				else
					if(H.wear_suit && istype(H.wear_suit,/obj/item/clothing/suit/space))
						user << "<span class='warning'>You can't apply [src] through [H.wear_suit]!</span>"
						return

				if(do_mob(user, M, 7))
					S.heal_damage(15, 15, robo_repair = 1)
					H.updatehealth()
					use(1)
					user.visible_message("<span class='notice'>\The [user] applies some nanite paste at[user != M ? " \the [M]'s" : " \the [user]"] [S.name] with \the [src].</span>",\
					"<span class='notice'>You apply some nanite paste at [user == M ? "your" : "[M]'s"] [S.name].</span>")
			else
				user << "<span class='notice'>Nothing to fix here.</span>"
		else
			if (can_operate(H))
				if (do_surgery(H,user,src))
					return
			else
				user << "<span class='notice'>Nothing to fix in here.</span>"

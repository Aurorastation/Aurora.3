/datum/psionic_faculty/energistics
	id = PSI_ENERGISTICS
	name = "Energistics"
	associated_intent = I_HURT
	armor_types = list("bomb", "laser", "energy")

/datum/psionic_power/energistics
	faculty = PSI_ENERGISTICS

/datum/psionic_power/energistics/electropulse
	name =            "Electropulse"
	cost =            40
	cooldown =        100
	use_melee =       TRUE
	min_rank =        PSI_RANK_MASTER
	use_description = "Target the right hand while on harm intent and click an object to use a melee attack that causes a localized EMP. This activates the EMP function on things, but it takes a while and applies a long cooldown, in addition to being expensive."

/datum/psionic_power/energistics/electropulse/invoke(var/mob/living/user, var/mob/living/target)
	if(user.zone_sel.selecting != BP_R_HAND)
		return FALSE
	if(istype(target, /turf) || ismob(target))
		return FALSE
	. = ..()
	if(.)
		user.visible_message(SPAN_WARNING("\The [user] holds their hands over \the [target]..."))
		if(do_after(user, 100, TRUE, target))
			user.visible_message(SPAN_DANGER("\The [user] releases a gout of arcing lightning over \the [target]!"))
			playsound(target, 'sound/magic/LightningShock.ogg', 75)
			var/severity = 1 + user.psi.get_rank(PSI_ENERGISTICS)
			target.emp_act(severity)
			return TRUE

/datum/psionic_power/energistics/electrocute
	name =            "Electrocute"
	cost =            15
	cooldown =        25
	use_melee =       TRUE
	min_rank =        PSI_RANK_GRANDMASTER
	use_description = "Target the chest or groin while on harm intent to use a melee attack that electrocutes a victim."

/datum/psionic_power/energistics/electrocute/invoke(var/mob/living/user, var/mob/living/target)
	if(user.zone_sel.selecting != BP_CHEST && user.zone_sel.selecting != BP_GROIN)
		return FALSE
	if(istype(target, /turf))
		return FALSE
	. = ..()
	if(.)
		user.visible_message(SPAN_DANGER("\The [user] sends a jolt of electricity arcing into \the [target]!"))
		if(istype(target))
			target.electrocute_act(rand(15,45), user, 1, user.zone_sel.selecting)
			return TRUE
		else if(istype(target, /atom))
			var/obj/item/cell/charging_cell = target.get_cell()
			if(istype(charging_cell))
				charging_cell.give(rand(15,45))
			return TRUE

/datum/psionic_power/energistics/lightning
	name =             "Lightning"
	cost =             20
	cooldown =         20
	use_ranged =       TRUE
	min_rank =         PSI_RANK_MASTER
	use_description = "Use this ranged lightning attack while on harm intent. Your mastery of Energistics will determine how powerful the lightning is. Be wary of overuse, and try not to fry your own brain."

/datum/psionic_power/energistics/lightning/invoke(var/mob/living/user, var/mob/living/target)
	. = ..()
	if(.)
		user.visible_message(SPAN_DANGER("\The [user] suddenly holds their hand out!"))

		var/user_rank = user.psi.get_rank(faculty)
		var/obj/item/projectile/pew
		var/pew_sound = 'sound/magic/LightningShock.ogg'

		switch(user_rank)
			if(PSI_RANK_PARAMOUNT)
				pew = new /obj/item/projectile/energy/tesla/paramount(get_turf(user))
				pew.name = "thunderstrike"
				pew_sound = 'sound/effects/psi/thunderstrike.ogg'
			if(PSI_RANK_GRANDMASTER)
				pew = new /obj/item/projectile/energy/tesla/grandmaster(get_turf(user))
				pew.name = "lightning shock"
			if(PSI_RANK_MASTER)
				pew = new /obj/item/projectile/energy/tesla/master(get_turf(user))
				pew.name = "lightning beam"

		if(istype(pew))
			playsound(pew.loc, pew_sound, 25, 1)
			pew.original = target
			pew.starting = get_turf(user)
			pew.shot_from = user
			pew.launch_projectile(target)
			return TRUE

/datum/psionic_power/energistics/spark
	name =            "Spark"
	cost =            1
	cooldown =        1
	use_melee =       TRUE
	min_rank =        PSI_RANK_OPERANT
	use_description = "Target a non-living target in melee range on harm intent to cause some sparks to appear. This can light fires."

/datum/psionic_power/energistics/spark/invoke(var/mob/living/user, var/mob/living/target)
	if(isnull(target) || istype(target)) return FALSE
	. = ..()
	if(.)
		if(istype(target,/obj/item/clothing/mask/smokable/cigarette))
			var/obj/item/clothing/mask/smokable/cigarette/S = target
			S.light(SPAN_NOTICE("\The [user] snaps \his fingers and \the [S] lights up."))
			playsound(S.loc, "sparks", 50, 1)
		else
			var/datum/effect_system/sparks/spark_system
			spark_system = bind_spark(src, 3)
			spark_system.queue()
		return TRUE
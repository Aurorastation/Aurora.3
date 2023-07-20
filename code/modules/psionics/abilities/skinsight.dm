/singleton/psionic_power/skinsight
	name = "Skinsight"
	desc = "Get information on a creature's vitals. Activate in your hand to switch between a normal mode or a slower, more detailed mode. Note that the body scan mode \
			is not 100% accurate with the numbers given."
	icon_state = "wiz_blind"
	point_cost = 1
	ability_flags = PSI_FLAG_EVENT|PSI_FLAG_CANON
	spell_path = /obj/item/spell/skinsight

/obj/item/spell/skinsight
	name = "skinsight"
	desc = "A health analyzer, but cooler."
	icon_state = "blink"
	cast_methods = CAST_MELEE|CAST_USE
	aspect = ASPECT_PSIONIC
	cooldown = 10
	psi_cost = 10
	var/body_scan_mode = FALSE

/obj/item/spell/skinsight/on_use_cast(mob/user)
	. = ..()
	body_scan_mode = !body_scan_mode
	if(body_scan_mode)
		psi_cost = 30
		to_chat(user, SPAN_NOTICE("You will now use more psionic energy for a more detailed readout."))
	else
		psi_cost = 10
		to_chat(user, SPAN_NOTICE("You will now use less psionic energy for a more standard readout."))

/obj/item/spell/skinsight/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	. = ..()

	if(!ishuman(hit_atom))
		return

	if(!isliving(user))
		return

	var/mob/living/carbon/human/target = hit_atom

	var/psi_blocked = target.is_psi_blocked()
	if(psi_blocked)
		to_chat(user, psi_blocked)
		return

	if(target.stat == DEAD)
		to_chat(user, SPAN_WARNING("The total lack of psionic energy flowing through this person can only mean one thing: they are dead."))
		return

	if(!body_scan_mode)
		user.visible_message(SPAN_NOTICE("[user] passes [user.get_pronoun("his")] hand over [target]."), SPAN_NOTICE("You pass your hand over [target]."))
		health_scan_mob(target, user, TRUE, TRUE)
	else
		user.visible_message(SPAN_NOTICE("[user] slowly passes [user.get_pronoun("his")] hand over [target]..."),
							SPAN_NOTICE("You slowly pass your hand over [target]..."))
		if(do_mob(user, target, 10 SECONDS))
			for(var/obj/item/organ/internal/I in target.internal_organs)
				if(I.is_bruised())
					to_chat(user, SPAN_WARNING("You notice some irregularity in the psionic flow through their [I]."))
				if(I.is_broken())
					to_chat(user, SPAN_WARNING("Your psionic flow through their [I] is <b>highly irregular</b>."))
				if(I.damage)
					to_chat(user, SPAN_WARNING("You are sure there is some damage in their [I]."))
			var/pulse = target.get_pulse()
			to_chat(user, SPAN_NOTICE("Their pulse is [pulse]."))
			var/oxygenation = max(min(target.get_blood_oxygenation() + rand(-10, 10), 100), 0)
			to_chat(user, SPAN_NOTICE("Their oxygenation is more or less [oxygenation]%."))

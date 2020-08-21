/spell/targeted/mindcontrol
	name = "Mind Bend"
	desc = "Bend the mind and soul of a mortal to serve your purposes, making them your slave. You will need some way to hold them still during the process, however."
	feedback = "MB"
	school = "cleric"
	charge_max = 10000
	spell_flags = SELECTABLE | NEEDSCLOTHES
	invocation = "In'gs'oc"
	invocation_type = SpI_SHOUT
	range = 1
	max_targets = 1

	cast_sound = 'sound/magic/Charge.ogg'

	hud_state = "rend_mind"

	holder_var_type = "brainloss"
	holder_var_amount = 15

	compatible_mobs = list(/mob/living/carbon/human)

/spell/targeted/mindcontrol/cast(list/targets, mob/user)
	..()
	for(var/mob/living/target in targets)
		var/mob/living/carbon/human/H = target

		if(H.stat == DEAD || (H.status_flags & FAKEDEATH))
			to_chat(user, SPAN_WARNING("\The [H] is dead!"))
			return FALSE

		if(is_special_character(H))
			to_chat(user, SPAN_WARNING("\The [H]'s mind is too strong to be affected by this spell!"))
			return FALSE

		if(!H.mind || !H.key)
			to_chat(user, SPAN_WARNING("\The [H] is mindless!"))
			return FALSE

		var/obj/item/organ/internal/brain/F = H.internal_organs_by_name[BP_BRAIN]

		if(isnull(F))
			to_chat(user, SPAN_WARNING("\The [H] is brainless!"))
			return FALSE

		for (var/obj/item/implant/mindshield/I in H)
			if (I.implanted)
				to_chat(src, SPAN_WARNING("[H]'s mind is shielded against your powers!"))
				return FALSE

		user.visible_message(SPAN_DANGER("\The [user] seizes the head of \the [H] in both hands..."))
		to_chat(user, SPAN_WARNING("You invade the mind of \the [H]!"))
		to_chat(H, SPAN_DANGER("Your mind is invaded by the presence of \the [user]! You feel painful tendrils burrowing their way into your head!"))

		if (!do_mob(user, H, 80))
			to_chat(user, SPAN_WARNING("Your concentration is broken!"))
			return FALSE

		if(wizards.add_antagonist_mind(target.mind,1,"Wizard Slave","<b>You are a slave to \the [user], obey them at all costs!</b>"))
			to_chat(user, SPAN_DANGER("You sear through \the [H]'s mind, reshaping as you see fit and leaving them subservient to your will!"))
			H.mind.assigned_role = "Wizard Slave"
			to_chat(H, SPAN_DANGER("Your defenses have eroded away and \the [user] has made you their mindslave."))
			H.faction = "Space Wizard"
			wizards.add_antagonist_mind(H.mind,1)

			return TRUE

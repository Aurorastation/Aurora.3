/obj/item/material/caltrops
	name = "caltrops"
	desc = "A sharp antipersonnel weapon. Useful to delay advances."
	icon_state = "caltrop1"
	w_class = ITEMSIZE_TINY
	force_divisor = 0.1
	thrown_force_divisor = 0.3
	sharp = TRUE
	edge = TRUE
	attack_verb = list("attacked", "slashed", "sliced", "torn", "ripped", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	applies_material_colour = FALSE

/obj/item/material/caltrops/Initialize()
	. = ..()
	icon_state = "caltrop[pick(1,2,3)]"

/obj/item/material/caltrops/Crossed(AM as mob|obj)
	..()
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		var/damage_coef = 1
		if(H.buckled)
			return

		if(H.resting)
			return

		to_chat(H, SPAN_DANGER("You step on \the [src]!"))
		playsound(get_turf(src), 'sound/effects/glass_step.ogg', 50, TRUE)

		if(H.species.siemens_coefficient < 0.5 || (H.species.flags & (NO_EMBED)))
			damage_coef -= 0.2

		if(H.shoes || H.wear_suit?.body_parts_covered & FEET)
			damage_coef -= 0.1

		if (H.m_intent == "run")
			damage_coef += 0.4


		var/list/check = list(BP_L_FOOT, BP_R_FOOT)
		while(check.len)
			var/picked = pick(check)
			var/obj/item/organ/external/affecting = H.get_organ(picked)
			if(affecting)
				if(affecting.status & ORGAN_ROBOT)
					damage_coef -= 0.2
					return

				var/armor_block = H.run_armor_check(affecting, "melee")

				if(H.apply_damage(25 * damage_coef, BRUTE, affecting, armor_block))
					H.updatehealth()

					if(H.can_feel_pain())
						H.Weaken(4)

				return
			check -= picked
		return

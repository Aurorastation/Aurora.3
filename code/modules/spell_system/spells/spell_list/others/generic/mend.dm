/spell/targeted/mend
	name = "Mend Wounds"
	desc = "This spell heals internal wounds and broken bones."
	feedback = "MW"
	spell_flags = INCLUDEUSER | SELECTABLE
	invocation = "Ges'undh'eit"
	invocation_type = SpI_SHOUT

	school = "cleric"

	charge_max = 700

	cast_sound = 'sound/magic/Staff_Healing.ogg'

	hud_state = "wiz_revive"

	range = 1

	compatible_mobs = list(/mob/living/carbon/human)

/spell/targeted/mend/cast(list/targets, mob/user)
	..()
	for(var/mob/living/target in targets)
		if(isundead(target))
			to_chat(user, "This spell can't affect the undead.")
			return 0

		if(isipc(target))
			to_chat(user, "This spell can't affect non-organics.")
			return 0

		if(!ishuman(target))
			to_chat(user, SPAN_WARNING("\The [target]'s body is not complex enough to require healing of this kind."))
			return 0

		var/mob/living/carbon/human/H = target
		var/obj/item/organ/external/E = H.get_organ(user.zone_sel.selecting)

		if(!E || E.is_stump())
			to_chat(user, SPAN_WARNING("They are missing that limb."))
			return 0

		if(E.robotic >= ORGAN_ROBOT)
			to_chat(user, SPAN_WARNING("That limb is prosthetic."))
			return 0

		user.visible_message(SPAN_NOTICE("\The [user] rests a hand on \the [target]'s [E.name]."))
		to_chat(target, SPAN_NOTICE("A healing warmth suffuses you."))

		for(var/datum/wound/W in E.wounds)
			if(W.bleeding())
				to_chat(user, SPAN_NOTICE("You knit together severed veins and broken flesh, stemming the bleeding."))
				W.bleed_timer = 0
				E.status &= ~ORGAN_BLEEDING
				return 1

		if(E.status & ORGAN_ARTERY_CUT)
			to_chat(user, SPAN_NOTICE("You painstakingly start joining the two ends of \the [E.artery_name] in [target]'s [E.name]. This might take some time..."))
			if(do_mob(user, target, 75, TRUE))
				to_chat(user, SPAN_NOTICE("After a while, you mend the damaged [E.artery_name]."))
				E.status &= ~ORGAN_ARTERY_CUT
				return 1

		if(E.status & ORGAN_BROKEN)
			to_chat(user, SPAN_NOTICE("You coax shattered bones to come together and fuse, mending the break."))
			E.status &= ~ORGAN_BROKEN
			E.stage = 0
			return 1

		if((E.tendon_status() & TENDON_CUT) && E.tendon.can_recover())
			to_chat(user, SPAN_NOTICE("You place your hands over [target]'s [E.name], joining the two ends of their [E.tendon_name] in the process."))
			E.tendon.rejuvenate()
			return 1

		for(var/obj/item/organ/I in E.internal_organs)
			if(I.robotic < ORGAN_ROBOT && I.damage > 0)
				to_chat(user, SPAN_NOTICE("You encourage the damaged tissue of \the [I] to repair itself."))
				I.damage = max(0, I.damage - rand(3,5))
				return 1

		to_chat(user, SPAN_NOTICE("You can find nothing within \the [target]'s [E.name] to mend."))
		return 1

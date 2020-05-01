/spell/targeted/mend
	name = "Mend Wounds"
	desc = "This spell heals internal wounds and broken bones."
	feedback = "MW"
	spell_flags = INCLUDEUSER | SELECTABLE | NEEDSCLOTHES
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
			to_chat(user, "<span class='warning'>\The [target]'s body is not complex enough to require healing of this kind.</span>")
			return 0

		var/mob/living/carbon/human/H = target
		var/obj/item/organ/external/E = H.get_organ(user.zone_sel.selecting)

		if(!E || E.is_stump())
			to_chat(user, "<span class='warning'>They are missing that limb.</span>")
			return 0

		if(E.robotic >= ORGAN_ROBOT)
			to_chat(user, "<span class='warning'>That limb is prosthetic.</span>")
			return 0

		user.visible_message("<span class='notice'>\The [user] rests a hand on \the [target]'s [E.name].</span>")
		to_chat(target, "<span class='notice'>A healing warmth suffuses you.</span>")

		for(var/datum/wound/W in E.wounds)
			if(W.bleeding())
				to_chat(user, "<span class='notice'>You knit together severed veins and broken flesh, stemming the bleeding.</span>")
				W.bleed_timer = 0
				E.status &= ~ORGAN_BLEEDING
				return 1

		if(E.status & ORGAN_ARTERY_CUT)
			to_chat(user, "<span class='notice'>You painstakingly start joining the two ends of \the [E.artery_name] in [target]'s [E.name]. This might take some time...</span>")
			if(do_mob(user, target, 75, TRUE))
				to_chat(user, "<span class='notice'>After a while, you mend the damaged [E.artery_name].</span>")
				E.status &= ~ORGAN_ARTERY_CUT
				return 1

		if(E.status & ORGAN_BROKEN)
			to_chat(user, "<span class='notice'>You coax shattered bones to come together and fuse, mending the break.</span>")
			E.status &= ~ORGAN_BROKEN
			E.stage = 0
			return 1

		if(E.status & ORGAN_TENDON_CUT)
			to_chat(user, "<span class='notice'>You place your hands over [target]'s [E.name], joining the two ends of their [E.tendon_name] in the process.</span>")
			E.status &= ~ORGAN_TENDON_CUT
			return 1

		for(var/obj/item/organ/I in E.internal_organs)
			if(I.robotic < ORGAN_ROBOT && I.damage > 0)
				to_chat(user, "<span class='notice'>You encourage the damaged tissue of \the [I] to repair itself.</span>")
				I.damage = max(0, I.damage - rand(3,5))
				return 1

		to_chat(user, "<span class='notice'>You can find nothing within \the [target]'s [E.name] to mend.</span>")
		return 1
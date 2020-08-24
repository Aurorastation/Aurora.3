/spell/targeted/resurrection
	name = "Resurrection"
	desc = "This spell brings someone back from the gates of death."
	feedback = "RES"
	spell_flags = NEEDSCLOTHES | SELECTABLE
	invocation = "Se'id Rev' Oreh"
	invocation_type = SpI_SHOUT

	school = "cleric"

	charge_max = 5000

	cast_sound = 'sound/magic/Staff_Healing.ogg'

	hud_state = "wiz_revive"

	range = 1

	compatible_mobs = list(/mob/living/carbon/human)

/spell/targeted/resurrection/cast(list/targets, mob/user)
	..()

	for(var/mob/living/target in targets)
		if(target.stat != DEAD && !(target.status_flags & FAKEDEATH))
			to_chat(user, SPAN_WARNING("\The [target] is still alive!"))
			return 0

		if(isundead(target))
			to_chat(user, "This spell can't affect the undead.")
			return 0

		if(isipc(target))
			to_chat(user, "This spell can't affect non-organics.")
			return 0

		if((world.time - target.timeofdeath) > 30 MINUTES)
			to_chat(user, SPAN_WARNING("\The [target]'s soul is too far away from your grasp."))
			return 0

		user.visible_message("<b>[user]</b> waves their hands over \the [target]'s body...")

		if(!do_after(user, 30, target, 0, 1))
			to_chat(user, SPAN_WARNING("Your concentration is broken!"))
			return 0

		for(var/mob/abstract/observer/ghost in dead_mob_list)
			if(ghost.mind && ghost.mind.current == target && ghost.client)
				to_chat(ghost, SPAN_NOTICE("Your body has been revived, <b>Re-Enter Corpse</b> to return to it."))
				break

		to_chat(target, SPAN_WARNING("Eternal rest is stolen from you, you are cast back into the world of the living!"))
		target.visible_message("<b>[target]</b> shudders violently!")

		if(target.status_flags & FAKEDEATH)
			target.changeling_revive()

		else
			target.adjustOxyLoss(-rand(15,20))
			target.revive()

		return 1

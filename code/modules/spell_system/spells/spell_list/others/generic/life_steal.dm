/spell/targeted/life_steal
	name = "Siphon Life"
	desc = "This spell steals the life essence of a target, healing the caster."
	feedback = "SL"
	school = "necromancy"
	charge_max = 300
	spell_flags = SELECTABLE
	invocation = "UMATHAR UF'KAL THENAR!"
	invocation_type = SpI_SHOUT
	range = 5
	max_targets = 1

	compatible_mobs = list(/mob/living/carbon/human)

	hud_state = "wiz_vampire"
	cast_sound = 'sound/magic/enter_blood.ogg'
	message = "You feel a sickening feeling as your body weakens."

	amt_dam_brute = 15
	amt_dam_fire  = 15

/spell/targeted/life_steal/cast(list/targets, mob/living/user)
	for(var/mob/living/M in targets)
		if(M.stat == DEAD)
			to_chat(user, "There is no left life to steal.")
			return 0
		if(isipc(M))
			to_chat(user, "There is no life to steal.")
			return 0
		M.visible_message("<span class='danger'>Blood flows from \the [M] into \the [user]!</span>")
		gibs(M.loc)
		user.adjustBruteLoss(-15)
		user.adjustFireLoss(-15)
	..()
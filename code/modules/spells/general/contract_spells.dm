//These spells are given to the owner of a contract when a victim signs it.
//As such they are REALLY REALLY powerful (because the victim is rewarded for signing it, and signing contracts is completely voluntary)

/spell/contract
	name = "Contract Spell"
	desc = "A spell perfecting the techniques of keeping a servant happy and obedient."

	school = "transmutation"
	spell_flags = 0
	invocation = "none"
	invocation_type = SpI_NONE


	var/mob/subject

/spell/contract/New(var/mob/M)
	..()
	subject = M
	name += " ([M.real_name])"

/spell/contract/choose_targets()
	return list(subject)

/spell/contract/cast(mob/target,mob/user)
	if(!subject)
		to_chat(usr, "This spell was not properly given a target. Contact a coder.")
		return null

	if(istype(target,/list))
		target = target[1]
	return target

/spell/contract/reward
	name = "Extinguish Contractee"
	desc = "A spell that extinguishes your contractee from flames."

	charge_max = 300
	cooldown_min = 100

	hud_state = "wiz_jaunt_old"

/spell/contract/reward/cast(mob/living/target,mob/user)
	target = ..(target,user)
	if(!target)
		return

	if(target.on_fire && target.fire_stacks > 0)
		to_chat(target, "<span class='notice'>Magical energies surround you, putting out all your flames.</span>")
		target.ExtinguishMobCompletely()

/spell/contract/punish
	name = "Punish Contractee"
	desc = "A spell that sets your contracted victim ablaze."

	charge_max = 300
	cooldown_min = 100

	hud_state = "gen_immolate"

/spell/contract/punish/cast(mob/living/target,mob/user)
	target = ..(target,user)
	if(!target)
		return

	to_chat(target, "<span class='danger'>Magical energies surround you, immolating you in a furious fashion!</span>")
	target.IgniteMob(15)
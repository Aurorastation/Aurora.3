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
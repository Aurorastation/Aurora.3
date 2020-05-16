/*
Other mutation or disability spells can be found in
code\game\dna\genes\vg_powers.dm //hulk is in this file
code\game\dna\genes\goon_disabilities.dm
code\game\dna\genes\goon_powers.dm
*/
/spell/targeted/genetic
	name = "Genetic modifier"
	desc = "This spell inflicts a set of mutations and disabilities upon the target."

	var/disabilities = 0 //bits
	var/list/mutations = list() //mutation strings
	duration = 100 //deciseconds


/spell/targeted/genetic/cast(list/targets)
	..()
	for(var/mob/living/target in targets)
		for(var/x in mutations)
			target.mutations.Add(x)
		target.disabilities |= disabilities
		target.update_mutations()	//update target's mutation overlays
		spawn(duration)
			for(var/x in mutations)
				target.mutations.Remove(x)
			target.disabilities &= ~disabilities
			target.update_mutations()
	return
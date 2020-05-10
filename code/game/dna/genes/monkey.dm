/datum/dna/gene/monkey
	name = "Monkey"

/datum/dna/gene/monkey/New()
	block = MONKEYBLOCK

/datum/dna/gene/monkey/can_activate(var/mob/M,var/flags)
	return ishuman(M)

/datum/dna/gene/monkey/activate(var/mob/living/carbon/C)
	var/mob/living/carbon/human/H
	if(ishuman(C))
		H = C
	else
		return
	if(!islesserform(H))
		H = H.monkeyize(1)
		H.name = H.species.get_random_name() // keep the realname

/datum/dna/gene/monkey/deactivate(var/mob/living/carbon/C)
	var/mob/living/carbon/human/H
	if(ishuman(C))
		H = C
	else
		return

	if(islesserform(H))
		H = H.humanize(1) // woo transform procs!

		if(!H.dna.real_name)
			var/randomname = H.species.get_random_name()
			H.real_name = randomname
			H.dna.real_name = randomname
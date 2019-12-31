var/datum/antagonist/mutineer/mutineers

/datum/antagonist/mutineer
	role_type = BE_MUTINEER
	role_text = "Mutineer"
	role_text_plural = "Mutineers"
	id = MODE_MUTINEER
	antag_indicator = "mutineer"
	restricted_jobs = list("Captain")

/datum/antagonist/mutineer/New(var/no_reference)
	..()
	if(!no_reference)
		mutineers = src

/datum/antagonist/mutineer/proc/recruit()

/datum/antagonist/mutineer/can_become_antag(var/datum/mind/player)
	if(!..())
		return 0
	if(!istype(player.current, /mob/living/carbon/human))
		return 0
	if(M.special_role)
		return 0
	return 1

// Make a vampire, add initial powers.
/mob/proc/make_vampire()
	if (!mind)
		return

	if (!mind.vampire)
		mind.vampire = new /datum/vampire()

	for (var/datum/power/vampire/P in vampirepowers)
		if (!P.blood_cost)
			if (!(P in mind.vampire.purchased_powers))
				mind.vampire.add_power(mind, P, 0)

	for (var/datum/power/vampire/P in mind.vampire.purchased_powers)
		if (P.isVerb)
			if (!(P in verbs))
				verbs += P.verbpath

	return 1

// Checks the vampire's bloodlevel and unlocks new powers based on that.
/mob/proc/check_vampire_upgrade()
	if (!mind.vampire)
		return

	var/datum/vampire/vampire = mind.vampire

	for (var/datum/power/vampire/P in vampirepowers)
		if (P.blood_cost <= vampire.blood_total)
			if (!(P in vampire.purchased_powers))
				vampire.add_power(mind, P, 1)

// Runs the checks for whether or not we can use a power.
/mob/proc/vampire_power(var/required_blood = 0, var/max_stat = 0, var/ignore_holder = 0, var/disrupt_healing = 1, var/required_vampire_blood = 0)
	if (!mind)
		return

	if (!ishuman(src))
		return

	var/datum/vampire/vampire = mind.vampire
	if (!vampire)
		log_debug("[src] has a vampire power but is not a vampire.")
		return

	if (vampire.holder && !ignore_holder)
		src << "<span class='warning'>You cannot use this power while walking through the Veil.</span>"
		return

	if (stat > max_stat)
		src << "<span class='warning'>You are incapacitated.</span>"
		return

	if (required_blood > vampire.blood_usable)
		src << "<span class='warning'>You do not have enough usable blood. [required_blood] needed.</span>"
		return

	if ((vampire.status & VAMP_HEALING) && disrupt_healing)
		vampire.status &= ~VAMP_HEALING

	return vampire

// Checks whether or not the target can be affected by a vampire's abilities.
/mob/proc/vampire_can_affect_target(var/mob/living/carbon/human/T)
	if (!T || !istype(T))
		return 0

	// How did you even get here?
	if (!mind.vampire)
		return 0

	if ((mind.vampire.status & VAMP_FULLPOWER) && !(T.mind.vampire && (T.mind.vampire.status & VAMP_FULLPOWER)))
		return 1

	if (T.mind && (T.mind.assigned_role == "Chaplain" || T.mind.vampire))
		return 0

	if (T.get_species() == "Machine")
		return 0

	return 1

// Plays the vampire phase in animation.
/mob/proc/vampire_phase_in(var/turf/T = null)
	if (!T)
		return

	anim(T, src, 'icons/mob/mob.dmi', , "bloodify_in", , dir)

// Plays the vampire phase out animation.
/mob/proc/vampire_phase_out(var/turf/T = null)
	if (!T)
		return

	anim(T, src, 'icons/mob/mob.dmi', , "bloodify_out", , dir)

// Make a vampire thrall
/mob/proc/vampire_make_thrall()

	if (!mind)
		return

	var/datum/vampire/thrall/thrall = new()

	mind.vampire = thrall

// #TODO: Finish vampire_check_frenzy and implement frenzy.
/mob/proc/vampire_check_frenzy()
	return

// Removes all vampire powers.
/mob/proc/remove_vampire_powers()
	if (!mind || !mind.vampire)
		return

	for (var/datum/power/vampire/P in mind.vampire.purchased_powers)
		if (P.isVerb)
			verbs -= P.verbpath

/mob/proc/handle_vampire()
	// Apply frenzy while in the chapel.
	if (istype(get_area(loc), /area/chapel))
		mind.vampire.frenzy += 2
		vampire_check_frenzy()

	return

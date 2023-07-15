/datum/psi_complexus/proc/check_psionic_trigger(var/trigger_strength = 0, var/source, var/redactive = FALSE)

	if(!world.time < next_latency_trigger)
		return FALSE

	if(!prob(trigger_strength))
		next_latency_trigger = world.time + rand(100, 300)
		return FALSE

	var/new_rank = rand(2,5)
	owner.set_psi_rank(new_rank)
	to_chat(owner, SPAN_DANGER("You scream internally as your psionics are forced into operancy by [source]!"))
	next_latency_trigger = world.time + rand(600, 1800) * new_rank
	if(!redactive) owner.adjustBrainLoss(rand(trigger_strength * 2, trigger_strength * 4))
	return TRUE

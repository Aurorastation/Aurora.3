/decl/nanomachine_effect/reproductive_nullifier
	name = "Reproductive Nullifier"
	desc = "This program strips out some of the nanomachines' reproductive code, granting increased storage space for more programs, at the cost of slower nanomachine regeneration rate."

	program_capacity_usage = 0

	has_process_effect = FALSE

	var/rate_reduction = 0.2

/decl/nanomachine_effect/reproductive_nullifier/add_effect(var/datum/nanomachine/parent)
	parent.max_programs++
	parent.regen_rate -= rate_reduction

/decl/nanomachine_effect/reproductive_nullifier/remove_effect(var/datum/nanomachine/parent)
	parent.max_programs--
	parent.regen_rate += rate_reduction
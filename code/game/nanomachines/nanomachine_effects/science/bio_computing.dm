/decl/nanomachine_effect/bio_computing
	name = "Bio Computing"
	desc = "By hijacking less used nerves and neurons, nanomachines can turn the body into a powerful computing device, capable of passively increasing research in all fields."

	nanomachines_per_use = 0.6

	var/static/list/time_per_level = list(3 MINUTES, 5 MINUTES, 15 MINUTES)

/decl/nanomachine_effect/bio_computing/add_effect(var/datum/nanomachine/parent)
	parent.tech_points_researched = 1 // adding it sets the level to 1
	LAZYSET(parent.program_last_trigger, type, world.time)

/decl/nanomachine_effect/bio_computing/remove_effect(var/datum/nanomachine/parent)
	parent.tech_points_researched = 0 // removing it erases all researched tech points
	LAZYREMOVE(parent.program_last_trigger, type)

/decl/nanomachine_effect/bio_computing/do_nanomachine_effect(var/datum/nanomachine/parent, var/mob/living/carbon/human/H)
	if(LAZYACCESS(parent.program_last_trigger, type) < world.time - time_per_level[clamp(parent.tech_points_researched, 1, 3)])
		LAZYSET(parent.program_last_trigger, type, world.time)
		parent.tech_points_researched++
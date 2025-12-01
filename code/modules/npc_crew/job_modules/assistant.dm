/// Job module for Assistant role - the simplest NPC behavior
/datum/npc_job_module/assistant
	job_title = "Assistant"
	work_areas = list(/area/hallway)

/datum/npc_job_module/assistant/process()
	if(!owner || !owner.body)
		return

	var/mob/living/carbon/human/H = owner.body
	if(H.stat != CONSCIOUS)
		return

	// Simple behavior: occasionally wander or emote
	if(prob(5))
		do_idle_behavior()

/datum/npc_job_module/assistant/proc/do_idle_behavior()
	if(!owner || !owner.body)
		return

	var/mob/living/carbon/human/H = owner.body

	// Pick a random idle action
	switch(rand(1, 3))
		if(1)
			// Wander a bit
			var/turf/T = get_step(H, pick(NORTH, SOUTH, EAST, WEST))
			if(T && !T.density)
				H.Move(T)
		if(2)
			// Do an emote
			var/list/emotes = list("yawn", "scratch", "blink")
			H.emote(pick(emotes))
		if(3)
			// Just stand there
			return

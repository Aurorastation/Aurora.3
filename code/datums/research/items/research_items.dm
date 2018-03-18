/datum/research_items
	var/name = "Mcob"
	var/id = "mcbob"
	var/desc = "A special dohickey for that one thing."
	var/unlocked = 0
	var/rmpcost = 1000
	var/path = null
	var/required_concepts = list(
					  "breath"  = 2
					)

/datum/research_items/proc/unlock()
	if(canbuy())
		unlocked = 1
	return

/datum/research_items/proc/giveunlocked()
	return

/datum/research_items/proc/canbuy()
	var/requirednumber = 0
	var/numbermet = 0
	var/i
	for(var/A in required_concepts)
		i++
		for(var/datum/research_concepts/B in SSresearch.concepts)
			if(required_concepts[i] == B.id)
				requirednumber++
				var/C = required_concepts[i]
				if(B.level == required_concepts[C])
					numbermet++
	if(numbermet != 0 && numbermet == requirednumber && rmpcost <= SSresearch.points)
		return 1
	return 0
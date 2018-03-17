//XENOARCH UNLOCKS
//T1
//T2
//T3
//T4
/datum/research_items/science_items/xenogateway
	name = "Xenogateway"
	id = "xenogateway"
	desc = "A high tech, specially modified, gateway that sometimes opens up to distance lands where anomalous interferences are detected."
	unlocked = 0
	rmpcost = 1250
	path = /obj/machinery/xenogateway
	required_concepts = list(
					  "xenoarch"  = 4
					)

/datum/research_items/science_items/xenogateway/unlock()
	return

/datum/research_items/science_items/xenogateway/giveunlocked()
	//spawn me here
	return

//XENOARCH UNLOCKS
//T1
//T2
//T3
/datum/research_items/science_items/xenohardsuit
	name = "Hazardous Enviroment Suit"
	id = "hes"
	desc = "An anomalous materials suit modified to be almost completely immune to anomalous effects at the cost of being very vulrenable to physical damage."
	unlocked = 0
	rmpcost = 1250
	path = /obj/item/weapon/rig/hazardsuit
	required_concepts = list(
					  "xenoarch"  = 3
					)
//T4
/datum/research_items/science_items/xenogateway
	name = "Xenogateway"
	id = "xenogateway"
	desc = "A high tech, specially modified, gateway that sometimes opens up to distance lands where anomalous interferences are detected."
	unlocked = 0
	rmpcost = 2500
	path = /obj/machinery/xenogateway
	required_concepts = list(
					  "xenoarch"  = 4
					)

/datum/research_items/science_items/xenogateway/giveunlocked()
	//map stuff
	return

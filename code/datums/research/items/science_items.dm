//XENOARCH UNLOCKS
//T1
//T2
//T3
/datum/research_items/science_items/xenohardsuit
	name = "Hazardous Enviroment Suit"
	id = "hes"
	desc = "An anomalous materials suit modified to be almost completely immune to anomalous effects at the cost of being very vulrenable to physical damage."
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
	rmpcost = 2500
	path = /obj/machinery/xenogateway
	required_concepts = list(
					  "xenoarch"  = 4
					)

/datum/research_items/science_items/xenogateway/giveunlocked()
	//map stuff
	return

//WEAPONS TECH UNLOCKS
//T1
/datum/research_items/science_items/modularweaponspackone
	name = "Additional Modular Compoments"
	id = "weaponsmodpackone"
	desc = "Thanks to the standardization effort, it is much eaiser to achieve new designs of compoments for the modular weapons system."
	rmpcost = 350
	required_concepts = list(
					  "weaponstech"  = 1
					)
//T2
//T3
/datum/research_items/science_items/advancedprefabweapons
	name = "Advanced Weapon Fabrication"
	id = "advancedprefab"
	desc = "Due to advanced weapon manufacturing practices, prefabricated weapons with more advanced features can be produced."
	rmpcost = 1500
	required_concepts = list(
					  "weaponstech"  = 3
					)
//T4

//ROBOTICS UNLOCKS
//T1
/datum/research_items/science_items/mech_module_point
	name = "Mecha Module Attachment Point"
	id = "mechpoint"
	desc = "An attachment point for an additional module on a mecha."
	rmpcost = 450
	required_concepts = list(
					  "robotics"  = 1
					)
//T2
/datum/research_items/science_items/mech_jet_pack
	name = "Mech jetpack"
	id = "mechjetpack"
	desc = "A very heavy duty jetpack allowing for limited traversal in low-pressure zones."
	rmpcost = 1000
	required_concepts = list(
					  "robotics"  = 2
					)
//T3
//T4


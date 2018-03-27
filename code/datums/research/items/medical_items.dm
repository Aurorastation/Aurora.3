//MEDICAL UNLOCKS
//T1
/datum/research_items/medical_items/handheld_medical
	name = "Hand-held suit sensor"
	id = "handheldsuitsensor"
	desc = "A small, portable suit sensor able to transmit data of a patients health."
	rmpcost = 500
	path = /obj/item/device/handheld_medical
	required_concepts = list(
					  "medicine"  = 1
					)

/datum/research_items/medical_items/death_alarm_kit
	name = "Death Alarm Kit"
	id = "deathalarmkit"
	desc = "A small implant hooked to the implantees vitals with new medical detection technology. When life is no longer detected, a radio message is automaticaly broadcasted."
	rmpcost = 250
	path = /obj/item/weapon/storage/box/cdeathalarm_kit
	required_concepts = list(
					  "medicine"  = 1
					)

/datum/research_items/medical_items/alskit
	name = "ALS Kit"
	id = "alskit"
	desc = "A specially designed kit for trained emergency repsonders."
	rmpcost = 250
	path = /obj/item/weapon/storage/firstaid/alskit
	required_concepts = list(
					  "medicine"  = 1
					)

//T2
/datum/research_items/medical_items/medical_tools_pack
	name = "Medical Hardsuit kit"
	id = "medicalhardusitkitone"
	desc = "Due to expanding medical research, smaller and more portable versions of medical tools can be manufactured along with a specially designed medical rescue hardsuit."
	rmpcost = 650
	path = /obj/item/weapon/rig/medical
	required_concepts = list(
					  "medicine"  = 2
					)
//T3
/datum/research_items/medical_items/cloner_upgrade
	name = "Cloner Upgrade"
	id = "cloneupgrade"
	desc = "Thanks to "
	rmpcost = 750
	required_concepts = list(
					  "medicine"  = 3,
					  "engineering" = 2
					)

//T4
/datum/research_items/medical_items/incisionmang
	name = "Incision Management System"
	id = "incisionmang"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	rmpcost = 1500
	path = /obj/item/weapon/scalpel/manager
	required_concepts = list(
					  "medicine"  = 4
					)
/mob/living/carbon/
	gender = MALE
	var/datum/species/species //Contains icon generation and language information, set during New().
	//stomach contents redefined at mob/living level, removed from here
	var/list/datum/disease2/disease/virus2 = list()
	var/list/antibodies = list()
	var/last_eating = 0 	//Not sure what this does... I found it hidden in food.dm


	var/analgesic = 0 // when this is set, the mob isn't affected by shock or pain
					  // life should decrease this by 1 every tick
	// total amount of wounds on mob, used to spread out healing and the like over all wounds
	var/number_wounds = 0
	var/obj/item/handcuffed = null //Whether or not the mob is handcuffed
	var/obj/item/legcuffed = null  //Same as handcuffs but for legs. Bear traps use this.
	//Surgery info
	var/datum/surgery_status/op_stage = new/datum/surgery_status
	//Active emote/pose
	var/pose = null
	var/list/chem_effects = list()
	var/intoxication = 0//Units of alcohol in their system
	var/datum/reagents/metabolism/bloodstr = null
	var/datum/reagents/metabolism/touching = null

	var/pulse = PULSE_NORM	//current pulse level
	var/light_energy //Used by diona. Stored light energy

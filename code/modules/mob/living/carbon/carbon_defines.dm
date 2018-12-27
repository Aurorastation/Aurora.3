/mob/living/carbon/
	gender = MALE
	var/datum/species/species //Contains icon generation and language information, set during New().
	//stomach contents redefined at mob/living level, removed from here
	var/list/datum/disease2/disease/virus2 = list()
	var/list/antibodies = list()

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
	var/datum/reagents/metabolism/breathing = null

	var/pulse = PULSE_NORM	//current pulse level

	//these two help govern taste. The first is the last time a taste message was shown to the plaer.
	//the second is the message in question.
	var/last_taste_time = 0
	var/last_taste_text = ""

	var/last_smell_time = 0
	var/last_smell_text = ""

	var/coughedtime = null // should only be useful for carbons as the only thing using it has a carbon arg.

	var/willfully_sleeping = 0
	var/moisture = 3600
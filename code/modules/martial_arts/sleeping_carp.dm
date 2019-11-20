//Uses combos. Basic attacks bypass armor and never miss
#define WRIST_WRENCH_COMBO "DD"
#define BACK_KICK_COMBO "HG"
#define STOMACH_KNEE_COMBO "GH"
#define HEAD_KICK_COMBO "DHH"
#define ELBOW_DROP_COMBO "HDHDH"

/datum/martial_art/the_sleeping_carp
	name = "The Sleeping Carp"
	deflection_chance = 100
	help_verb = /datum/martial_art/the_sleeping_carp/proc/sleeping_carp_help
	no_guns = TRUE
	no_guns_message = "Use of ranged weaponry would bring dishonor to the clan."

/datum/martial_art/the_sleeping_carp/proc/check_streak(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(findtext(streak,WRIST_WRENCH_COMBO))
		streak = ""
		wristWrench(A,D)
		return 1
	if(findtext(streak,BACK_KICK_COMBO))
		streak = ""
		backKick(A,D)
		return 1
	if(findtext(streak,STOMACH_KNEE_COMBO))
		streak = ""
		kneeStomach(A,D)
		return 1
	if(findtext(streak,HEAD_KICK_COMBO))
		streak = ""
		headKick(A,D)
		return 1
	if(findtext(streak,ELBOW_DROP_COMBO))
		streak = ""
		elbowDrop(A,D)
		return 1
	return 0

/datum/martial_art/the_sleeping_carp/proc/wristWrench(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(!D.stat && !D.stunned && !D.weakened)
		A.do_attack_animation(D)
		D.visible_message("<span class='warning'>[A] grabs [D]'s wrist and wrenches it sideways!</span>")
		playsound(get_turf(A), 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		D.drop_item()
		D.apply_damage(5, BRUTE, pick("l_arm", "r_arm"))
		D.Stun(3)
		return 1
	return basic_hit(A,D)

/datum/martial_art/the_sleeping_carp/proc/backKick(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(A.dir == D.dir && !D.stat && !D.weakened)
		A.do_attack_animation(D)
		D.visible_message("<span class='warning'>[A] kicks [D] in the back!</span>")
		step_to(D,get_step(D,D.dir),1)
		D.Weaken(4)
		playsound(get_turf(D), 'sound/weapons/punch1.ogg', 50, 1, -1)

		return 1
	return basic_hit(A,D)

/datum/martial_art/the_sleeping_carp/proc/kneeStomach(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(!D.stat && !D.weakened)
		A.do_attack_animation(D)
		D.visible_message("<span class='warning'>[A] knees [D] in the stomach!</span>", \
						  "<span class='danger'>[A] winds you with a knee in the stomach!</span>")
		D.audible_message("<b>[D]</b> gags!")
		if (!(D.species.flags & NO_BREATHE))
			D.losebreath += 3
		D.Stun(2)
		playsound(get_turf(D), 'sound/weapons/punch1.ogg', 50, 1, -1)

		return 1
	return basic_hit(A,D)

/datum/martial_art/the_sleeping_carp/proc/headKick(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(!D.stat && !D.weakened)
		A.do_attack_animation(D)
		D.visible_message("<span class='warning'>[A] kicks [D] in the head!</span>", \
						  "<span class='danger'>[A] kicks you in the jaw!</span>")
		D.apply_damage(20, BRUTE, "head")
		D.drop_item()
		playsound(get_turf(D), 'sound/weapons/punch1.ogg', 50, 1, -1)

		D.Stun(4)
		return 1
	return basic_hit(A,D)

/datum/martial_art/the_sleeping_carp/proc/elbowDrop(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(D.weakened || D.resting || D.stat)
		A.do_attack_animation(D)
		D.visible_message("<span class='danger'>[A] elbow drops [D]!</span>")
		if(D.stat)
			D.death() //FINISH HIM!
		D.apply_damage(50, BRUTE, "chest")
		playsound(get_turf(D), 'sound/weapons/punch1.ogg', 75, 1, -1)
		return 1
	return basic_hit(A,D)

/datum/martial_art/the_sleeping_carp/grab_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	add_to_streak("G",D)
	if(check_streak(A,D))
		return 1
	D.grabbedby(A,1)
	var/obj/item/grab/G = A.get_active_hand()
	if(G)
		G.state = GRAB_AGGRESSIVE //Instant aggressive grab

/datum/martial_art/the_sleeping_carp/disarm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	add_to_streak("D",D)
	if(check_streak(A,D))
		return 1
	return ..()

/datum/martial_art/the_sleeping_carp/proc/sleeping_carp_help()
	set name = "Recall Teachings"
	set desc = "Remember the martial techniques of the Sleeping Carp clan."
	set category = "Sleeping Carp"

	to_chat(usr, "<b><i>You retreat inward and recall the teachings of the Sleeping Carp...</i></b>")

	to_chat(usr, "<span class='notice'>Wrist Wrench</span>: Disarm Disarm. Forces opponent to drop item in hand.")
	to_chat(usr, "<span class='notice'>Back Kick</span>: Harm Grab. Opponent must be facing away. Knocks down.")
	to_chat(usr, "<span class='notice'>Stomach Knee</span>: Grab Harm. Knocks the wind out of opponent and stuns.")
	to_chat(usr, "<span class='notice'>Head Kick</span>: Disarm Harm Harm. Decent damage, forces opponent to drop item in hand.")
	to_chat(usr, "<span class='notice'>Elbow Drop</span>: Harm Disarm Harm Disarm Harm. Opponent must be on the ground. Deals huge damage, instantly kills anyone in critical condition.")

/obj/item/martial_manual/sleeping_carp
	name = "mysterious scroll"
	desc = "A scroll filled with strange markings. It seems to be drawings of some sort of martial art."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "scroll2"
	martial_art = /datum/martial_art/the_sleeping_carp
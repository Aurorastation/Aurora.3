#define TORNADO_COMBO "HHD"
#define THROWBACK_COMBO "DHD"
#define PLASMA_COMBO "HDDDH"

/datum/martial_art/plasma_fist
	name = "Plasma Fist"
	help_verb = /datum/martial_art/plasma_fist/proc/plasma_fist_help


/datum/martial_art/plasma_fist/proc/check_streak(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(findtext(streak,TORNADO_COMBO))
		streak = ""
		Tornado(A,D)
		return 1
	if(findtext(streak,THROWBACK_COMBO))
		streak = ""
		Throwback(A,D)
		return 1
	if(findtext(streak,PLASMA_COMBO))
		streak = ""
		Plasma(A,D)
		return 1
	return 0

/datum/martial_art/plasma_fist/proc/Tornado(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	A.say("Tornado sweep!")
	TornadoAnimate(A)
	var/list/thrownatoms = list()
	var/atom/throwtarget
	var/distfromcaster

	for(var/turf/T in range(1,A))
		for(var/atom/movable/AM in T)
			thrownatoms += AM

	for(var/am in thrownatoms)
		var/atom/movable/AM = am
		if(AM == A || AM.anchored)
			continue

		throwtarget = get_edge_target_turf(A, get_dir(A, get_step_away(AM, A)))
		distfromcaster = get_dist(A, AM)
		if(distfromcaster == 0)
			if(istype(AM, /mob/living))
				var/mob/living/M = AM
				M.Weaken(5)
				M.adjustBruteLoss(5)
				to_chat(M, "<span class='danger'>You're slammed into the floor by a mystical force!</span>")
		else
			if(istype(AM, /mob/living))
				var/mob/living/M = AM
				M.Weaken(2)
				to_chat(M, "<span class='danger'>You're thrown back by a mystical force!</span>")
				AM.throw_at(throwtarget, ((Clamp((5 - (Clamp(distfromcaster - 2, 0, distfromcaster))), 3, 5))), 1)

	log_and_message_admins("used tornado sweep(Plasma Fist)", "[A]")
	return

/datum/martial_art/plasma_fist/proc/Throwback(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	D.visible_message("<span class='danger'>[A] has hit [D] with plasma punch!</span>", \
								"<span class='danger'>[A] has hit [D] with plasma punch!</span>")
	playsound(D.loc, 'sound/weapons/punch1.ogg', 50, 1, -1)
	var/atom/throw_target = get_edge_target_turf(D, get_dir(D, get_step_away(D, A)))
	D.throw_at(throw_target, 200, 4,A)
	A.say("Plasma punch!")
	log_and_message_admins("[A] used threw back (Plasma Fist) against [D]")
	return

/datum/martial_art/plasma_fist/proc/Plasma(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	A.do_attack_animation(D)
	playsound(D.loc, 'sound/magic/Disintegrate.ogg', 50, 1, -1)
	A.say("PLASMA FIST!")
	D.visible_message("<span class='danger'>[A] has hit [D] with the plasma fist technique!</span>", \
								"<span class='danger'>[A] has hit [D] with the plasma fist technique!</span>")
	D.gib()
	log_and_message_admins("[A] gibbed [D] with the plasma fist (Plasma Fist)")
	return

/datum/martial_art/plasma_fist/harm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	add_to_streak("H",D)
	if(check_streak(A,D))
		return 1
	basic_hit(A,D)
	return 1

/datum/martial_art/plasma_fist/disarm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	add_to_streak("D",D)
	if(check_streak(A,D))
		return 1
	basic_hit(A,D)
	return 1

/datum/martial_art/plasma_fist/grab_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	add_to_streak("G",D)
	if(check_streak(A,D))
		return 1
	basic_hit(A,D)
	return 1

/datum/martial_art/plasma_fist/proc/plasma_fist_help()
	set name = "Recall Teachings"
	set desc = "Remember the martial techniques of the Plasma Fist."
	set category = "Plasma Fist"

	to_chat(usr, "<b><i>You clench your fists and have a flashback of knowledge...</i></b>")
	to_chat(usr, "<span class='notice'>Tornado Sweep</span>: Harm Harm Disarm. Repulses target and everyone back.")
	to_chat(usr, "<span class='notice'>Throwback</span>: Disarm Harm Disarm. Throws the target and an item at them.")
	to_chat(usr, "<span class='notice'>The Plasma Fist</span>: Harm Disarm Disarm Disarm Harm. Knocks the brain out of the opponent and gibs their body.")

/obj/item/martial_manual/plasma_fist
	name = "frayed scroll"
	desc = "An aged and frayed scrap of paper written in shifting runes. There are hand-drawn illustrations of pugilism."
	icon_state = "scroll"
	item_state = "scroll"
	martial_art = /datum/martial_art/plasma_fist

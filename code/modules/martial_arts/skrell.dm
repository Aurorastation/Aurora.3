#define PAINFUL_PALM "DDH"
#define LEG_SWEEP "DHD"
#define DISLOCATING_STRIKE "HDDD"

/datum/martial_art/karak_virul
	name = "Karak Virul"
	help_verb = /datum/martial_art/karak_virul/proc/karak_virul_help

/datum/martial_art/karak_virul/proc/check_streak(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(findtext(streak,PAINFUL_PALM))
		streak = ""
		painful_palm(A,D)
		return 1
	if(findtext(streak,LEG_SWEEP))
		streak = ""
		leg_sweep(A,D)
		return 1
	if(findtext(streak,DISLOCATING_STRIKE))
		streak = ""
		dislocating_strike(A,D)
		return 1
	return 0

/datum/martial_art/karak_virul/proc/leg_sweep(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	A.do_attack_animation(D)
	if(D.stat || D.weakened)
		return 0
	D.visible_message("<span class='warning'>[A] leg sweeps [D]!</span>")
	playsound(get_turf(A), "swing_hit", 50, 1, -1)
	D.apply_damage(5, BRUTE)
	D.Weaken(2)
	return 1

/datum/martial_art/karak_virul/proc/painful_palm(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)//is actually lung punch
	A.do_attack_animation(D)
	A.visible_message("<span class='warning'>[A] strikes [D] with their open palm!</span>")
	playsound(get_turf(A), "punch", 50, 1, -1)
	var/obj/item/organ/external/affecting = D.get_organ(ran_zone(A.zone_sel.selecting))
	var/armor_block = D.run_armor_check(affecting, "melee")
	D.apply_damage(25, HALLOSS, affecting, armor_block)
	return 1

/datum/martial_art/karak_virul/proc/dislocating_strike(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	A.do_attack_animation(D)
	if(prob(30))
		var/obj/item/organ/external/organ = D.get_organ(A.zone_sel.selecting)
		if(!organ || organ.is_dislocated() || organ.dislocated == -1)
			return 0
		organ.dislocate(1)
		A.visible_message("<span class='warning'>[A] strikes [D]'s [organ.name] with their closed fist!</span>")
		D.visible_message("<span class='danger'>[D]'s [organ.joint] [pick("gives way","caves in","crumbles","collapses")]!</span>")
		admin_attack_log(A, D, "dislocated [organ.joint].", "had his [organ.joint] dislocated.", "dislocated [organ.joint] of")
		playsound(get_turf(A), "punch", 50, 1, -1)
		return 1
	else
		playsound(get_turf(A), "punch", 50, 1, -1)
		D.apply_damage(5, BRUTE)
		A.visible_message("<span class='warning'>[A] strikes [D] with their closed fist!</span>")
	return 1

datum/martial_art/karak_virul/grab_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(check_streak(A,D))
		return 1
	..()

/datum/martial_art/karak_virul/harm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	add_to_streak("H",D)
	if(check_streak(A,D))
		return 1
	basic_hit(A,D)
	return 1


/datum/martial_art/karak_virul/disarm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	add_to_streak("D",D)
	if(check_streak(A,D))
		return 1
	basic_hit(A,D)
	return 1


/obj/item/karak_virul_manual
	name = "karak virul manual"
	desc = "A manual designated to teach the user about the skrellian martial art of Karak Virul."
	icon = 'icons/obj/library.dmi'
	icon_state ="cqcmanual"

/obj/item/karak_virul_manual/attack_self(mob/user as mob)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/datum/martial_art/karak_virul/F = new/datum/martial_art/karak_virul(null)
	F.teach(H)
	to_chat(H, "<span class='notice'>You have learned the martial art of Karak Virul.</span>")
	qdel(src)

/datum/martial_art/karak_virul/proc/karak_virul_help()
	set name = "Recall Teachings"
	set desc = "Remember the martial techniques of the Karak Virul."
	set category = "Karak Virul"

	to_chat(usr, "<b><i>You warble deeply and recall the teachings...</i></b>")
	to_chat(usr, "<span class='notice'>Painful Palm</span>: Disarm Harm Harm. Strikes your target with a painful hit, causing some pain.")
	to_chat(usr, "<span class='notice'>Leg Sweep</span>: Disarm Harm Disarm.. Trips the victim, rendering them prone and unable to move for a short time.")
	to_chat(usr, "<span class='notice'>Dislocating Strike</span>: Harm Disarm Disarm Disarm. Delivers a strong punch that can dislocate your target's limb.")


#define EYE_RAKE "HDH"
#define CLAW_PUNCH "DHH"
#define RRAKNARR_STAB "HHDD"

/datum/martial_art/baghrar
	name = "Baghrar"
	help_verb = /datum/martial_art/baghrar/proc/baghrar_help

/datum/martial_art/baghrar/proc/check_streak(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(findtext(streak,EYE_RAKE))
		streak = ""
		eye_rake(A,D)
		return 1
	if(findtext(streak,CLAW_PUNCH))
		streak = ""
		claw_punch(A,D)
		return 1
	if(findtext(streak,RRAKNARR_STAB))
		streak = ""
		rraknar_stab(A,D)
		return 1
	return 0

/datum/martial_art/baghrar/proc/eye_rake(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(!istajara(A))
		return 0
	A.do_attack_animation(D)
	playsound(get_turf(A), 'sound/weapons/slice.ogg', 50, 1, -1)

	if(!D.species.has_limbs["head"])
		return 0

	var/obj/item/organ/external/affecting = D.get_organ("head")
	if(!istype(affecting) || affecting.is_stump())
		return 0

	D.visible_message("<span class='danger'>[A] rakes their claws against [D]'s [affecting.name]!</span>")

	for(var/obj/item/protection in list(D.head, D.wear_mask, D.glasses))
		if(protection && (protection.body_parts_covered & EYES))
			return 1

	if(!D.has_eyes())
		return 1

	if(isipc(D))
		return 1

	var/obj/item/organ/eyes/eyes = D.get_eyes()
	eyes.take_damage(rand(3,4), 1)
	var/armor = D.getarmor_organ(affecting,"melee")
	D.apply_damage(10,BRUTE, "head", armor, sharp=1, edge=1)

	return 1

/datum/martial_art/baghrar/proc/claw_punch(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)//is actually lung punch
	A.do_attack_animation(D)
	A.visible_message("<span class='danger'>[A] lunges forwards and strikes [D] with their claws!</span>")
	playsound(get_turf(A), 'sound/weapons/slice.ogg', 50, 1, -1)
	var/obj/item/organ/external/affecting = D.get_organ(ran_zone(A.zone_sel.selecting))
	var/armor_block = D.run_armor_check(affecting, "melee")
	D.apply_damage(20, BRUTE, affecting, armor_block, sharp = TRUE, edge = TRUE)
	if(prob(20))
		D.apply_effect(4, WEAKEN)
	return 1

/datum/martial_art/baghrar/proc/rraknar_stab(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(!istajara(A))
		return 0
	A.do_attack_animation(D)
	var/obj/item/organ/external/organ = D.get_organ(A.zone_sel.selecting)
	var/armor = D.getarmor_organ(organ,"melee")
	A.visible_message("<span class='danger'>[A] stabs [D]'s [organ.name] with their claws!</span>")
	D.apply_damage(organ.brute_dam, BRUTE, organ, armor, sharp= TRUE, edge= TRUE)
	return 1

/datum/martial_art/baghrar/harm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	add_to_streak("H",D)
	if(check_streak(A,D))
		return 1
	basic_hit(A,D)
	return 1

/datum/martial_art/baghrar/disarm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	add_to_streak("D",D)
	if(check_streak(A,D))
		return 1
	basic_hit(A,D)
	return 1

/datum/martial_art/baghrar/proc/baghrar_help()
	set name = "Recall Teachings"
	set desc = "Remember the martial techniques of the Baghrar."
	set category = "Baghrar"

	to_chat(usr, "<b><i>You twitch your ears and remember the techniques...</i></b>")
	to_chat(usr, "<span class='notice'>Eye Rake</span>: Harm Disarm Harm. Strikes your target's face, damaging their eyes.")
	to_chat(usr, "<span class='notice'>Claw Punch</span>: Disarm Harm Harm. Hits your target with your claws, dealing damage and causing bleeding.")
	to_chat(usr, "<span class='notice'>Rrak'narrr Stab</span>: Harm Harm Disarm Disarm. Stabs your target with your claws, dealing more damage based on how hurt they are.")

/obj/item/martial_manual/tajara
	name = "baghrar manual"
	desc = "A manual designated to teach the user about the tajaran martial art of Baghrar."
	martial_art = /datum/martial_art/baghrar


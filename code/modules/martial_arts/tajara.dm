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

	if(!D.species.has_limbs[BP_HEAD])
		return 0

	var/obj/item/organ/external/affecting = D.get_organ(BP_HEAD)
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

	var/obj/item/organ/internal/eyes/eyes = D.get_eyes()
	eyes.take_damage(rand(3,4), 1)
	D.apply_damage(10,BRUTE, BP_HEAD, damage_flags = DAM_SHARP|DAM_EDGE)

	return 1

/datum/martial_art/baghrar/proc/claw_punch(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)//is actually lung punch
	A.do_attack_animation(D)
	A.visible_message("<span class='danger'>[A] lunges forwards and strikes [D] with their claws!</span>")
	playsound(get_turf(A), 'sound/weapons/slice.ogg', 50, 1, -1)
	var/obj/item/organ/external/affecting = D.get_organ(ran_zone(A.zone_sel.selecting))
	D.apply_damage(20, BRUTE, affecting, damage_flags = DAM_SHARP|DAM_EDGE)
	if(prob(20))
		D.apply_effect(4, WEAKEN)
	return 1

/datum/martial_art/baghrar/proc/rraknar_stab(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(!istajara(A))
		return 0
	A.do_attack_animation(D)
	var/obj/item/organ/external/organ = D.get_organ(A.zone_sel.selecting)
	A.visible_message("<span class='danger'>[A] stabs [D]'s [organ.name] with their claws!</span>")
	D.apply_damage(organ.brute_dam, BRUTE, organ, damage_flags = DAM_SHARP|DAM_EDGE)
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
	set name = "Recall Baghrar"
	set desc = "Remember the martial techniques of the Baghrar."
	set category = "Abilities"

	to_chat(usr, "<b><i>You twitch your ears and remember the techniques...</i></b>")
	to_chat(usr, "<span class='notice'>Eye Rake</span>: Harm Disarm Harm. Strikes your target's face, damaging their eyes.")
	to_chat(usr, "<span class='notice'>Claw Punch</span>: Disarm Harm Harm. Hits your target with your claws, dealing damage and causing bleeding.")
	to_chat(usr, "<span class='notice'>Rrak'narrr Stab</span>: Harm Harm Disarm Disarm. Stabs your target with your claws, dealing more damage based on how hurt they are.")

/obj/item/martial_manual/tajara
	name = "baghrar manual"
	desc = "A manual designated to teach the user about the tajaran martial art of Baghrar."
	martial_art = /datum/martial_art/baghrar
	desc_fluff = "An ancient martial art from Adhomai primarily used for sport and contests of strength. The fighting style consists of attacks against the opponent from the waist \
	up. The form of the attacks are primarily swiping motions which take advantage of a Tajara's claws to rake an opponents torso or head. Other moves include punching for friendlier \
	matches or stabbing forward with the claws in typical matches. Modern Baghrariri, or people who fight in the Baghrar style for sport, usually fight with implements that cover and \
	support their claws to avoid serious bodily damage. Modern Baghrar matches are decided upon with a point scoring system over three 10 minute rounds of fighting, but historical \
	victories were secured by knocking opponents onto the ground."

#undef EYE_RAKE
#undef CLAW_PUNCH
#undef RRAKNARR_STAB
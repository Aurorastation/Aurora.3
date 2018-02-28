/datum/martial_art
	var/name = "Martial Art"
	var/streak = ""
	var/max_streak_length = 6
	var/current_target = null
	var/temporary = 0
	var/datum/martial_art/base = null // The permanent style
	var/deflection_chance = 0 //Chance to deflect projectiles
	var/help_verb = null
	var/no_guns = FALSE	//set to TRUE to prevent users of this style from using guns
	var/no_guns_message = ""	//message to tell the style user if they try and use a gun while no_guns = TRUE (DISHONORABRU!)

/datum/martial_art/proc/disarm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	return 0

/datum/martial_art/proc/harm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	return 0

/datum/martial_art/proc/grab_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	return 0

/datum/martial_art/proc/help_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	return 0

/datum/martial_art/proc/add_to_streak(var/element,var/mob/living/carbon/human/D)
	if(D != current_target)
		current_target = D
		streak = ""
	streak = streak+element
	if(length(streak) > max_streak_length)
		streak = copytext(streak,2)
	return

/datum/martial_art/proc/basic_hit(var/mob/living/carbon/human/A,var/mob/living/carbon/human/D)

	A.do_attack_animation(D)
	var/hit_zone = A.zone_sel.selecting
	var/datum/unarmed_attack/attack = A.get_unarmed_attack(src, hit_zone)
	var/damage = attack.damage

	var/atk_verb = "[pick(attack.attack_verb)]"
	if(D.lying)
		atk_verb = "kick"

	if(!damage)
		playsound(D.loc, attack.miss_sound, 25, 1, -1)
		D.visible_message("<span class='warning'>[A] has attempted to [atk_verb] [D]!</span>")
		return 0

	var/obj/item/organ/external/affecting = D.get_organ(ran_zone(A.zone_sel.selecting))
	var/armor_block = D.run_armor_check(affecting, "melee")

	playsound(D.loc, attack.attack_sound, 25, 1, -1)
	D.visible_message("<span class='danger'>[A] has [atk_verb]ed [D]!</span>", \
								"<span class='userdanger'>[A] has [atk_verb]ed [D]!</span>")

	D.apply_damage(damage, BRUTE, affecting, armor_block)

	add_logs(A, D, "punched")

	if(D.stat != DEAD)
		D.visible_message("<span class='danger'>[A] has weakened [D]!</span>", \
								"<span class='userdanger'>[A] has weakened [D]!</span>")
		D.apply_effect(4, WEAKEN, armor_block)
		D.forcesay(hit_appends)
	else if(D.lying)
		D.forcesay(hit_appends)
	return 1

/datum/martial_art/proc/teach(var/mob/living/carbon/human/H,var/make_temporary=0)
	if(help_verb)
		H.verbs += help_verb
	if(make_temporary)
		temporary = 1
	if(temporary)
		if(H.martial_art)
			base = H.martial_art.base
	else
		base = src
	H.martial_art = src

/datum/martial_art/proc/remove(var/mob/living/carbon/human/H)
	if(H.martial_art != src)
		return
	H.martial_art = base
	if(help_verb)
		H.verbs -= help_verb
/datum/martial_art
	var/name = "Martial Art"
	var/streak = ""
	var/max_streak_length = 6
	var/current_target = null
	var/datum/martial_art/base = null // The permanent style
	var/deflection_chance = 0 //Chance to deflect projectiles
	var/help_verb = null
	var/no_guns = FALSE	//set to TRUE to prevent users of this style from using guns
	var/no_guns_message = ""	//message to tell the style user if they try and use a gun while no_guns = TRUE (DISHONORABRU!)
	var/temporary = 0

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
	var/datum/unarmed_attack/attack = A.get_unarmed_attack(A)
	var/damage = attack.get_unarmed_damage(A)
	var/hit_dam_type = attack.damage_type
	var/hit_zone = A.zone_sel.selecting
	var/obj/item/organ/external/affecting = D.get_organ(hit_zone)

	var/atk_verb = "[pick(attack.attack_verb)]"
	if(D.lying)
		atk_verb = "kicked"

	if(!affecting || affecting.is_stump())
		A << "<span class='danger'>They are missing that limb!</span>"
		return 1

	var/armour = D.run_armor_check(hit_zone, "melee")

	playsound(A.loc, attack.attack_sound, 25, 1, -1)
	A.visible_message("<span class='danger'>[A] has [atk_verb] [D]!</span>", \
								"<span class='danger'>[A] has [atk_verb] [D]!</span>")

	D.apply_damage(damage, hit_dam_type, hit_zone, armour, sharp=attack.sharp, edge=attack.edge)

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

/datum/martial_art/proc/TornadoAnimate(mob/living/carbon/human/A)
	set waitfor = FALSE
	for(var/i in list(NORTH,SOUTH,EAST,WEST,EAST,SOUTH,NORTH,SOUTH,EAST,WEST,EAST,SOUTH))
		if(!A)
			break
		A.set_dir(i)
		playsound(A.loc, 'sound/weapons/punch1.ogg', 15, 1, -1)
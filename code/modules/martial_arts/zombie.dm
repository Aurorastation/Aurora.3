#define STRONG_BITE "HHH"

/datum/martial_art/zombie
	name = "Zombie"
	help_verb = /datum/martial_art/zombie/proc/zombie_help
	no_guns = TRUE
	no_guns_message = "A zombie cannot use a gun."

/datum/martial_art/zombie/proc/check_streak(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(findtext(streak, STRONG_BITE))
		streak = ""
		strong_bite(A, D)
		return TRUE
	return FALSE

/datum/martial_art/zombie/harm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	add_to_streak("H", D)
	if(check_streak(A, D))
		return TRUE
	basic_hit(A, D)
	return TRUE


/datum/martial_art/zombie/proc/strong_bite(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	A.do_attack_animation(D)
	var/atk_verb = pick("chomps", "bites")
	D.visible_message(SPAN_DANGER("[A] [atk_verb] down hard on [D]!"), SPAN_DANGER("[A] [atk_verb] down hard on you!"))
	D.apply_damage(rand(5, 10), BRUTE, damage_flags = DAM_SHARP, armor_pen = 100)
	playsound(get_turf(D), 'sound/weapons/bloodyslice.ogg', 25, 1, -1)
	return TRUE

/datum/martial_art/zombie/proc/zombie_help()
	set name = "Recall Zombie Combat"
	set desc = "Remember the martial techniques of the zombie horde."
	set category = "Abilities"

	to_chat(usr, "<b><i>You moan inside yourself, grasping knowledge unknown to the living...</i></b>")
	to_chat(usr, "<span class='notice'>Strong Bite</span>: Harm Harm Harm. Delivers a strong bite to your foe. This bite does 5 to 10 damage but pierces through all armour.")
	to_chat(usr, SPAN_NOTICE("Press the Check Attacks verb in the IC tab! Your bite infects, but it is less powerful than your claws."))

#undef STRONG_BITE
#define BASH_SLASH "HHH"

/datum/martial_art/revenant
	name = "Revenant"
	help_verb = /datum/martial_art/revenant/proc/revenant_help
	no_guns = TRUE
	no_guns_message = "Revenants cannot use guns."

/datum/martial_art/revenant/proc/check_streak(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	if(findtext(streak, BASH_SLASH))
		streak = ""
		bash_slash(A, D)
		return TRUE
	return FALSE

/datum/martial_art/revenant/harm_act(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	add_to_streak("H", D)
	if(check_streak(A, D))
		return TRUE
	basic_hit(A, D)
	return TRUE

/datum/martial_art/revenant/proc/bash_slash(var/mob/living/carbon/human/A, var/mob/living/carbon/human/D)
	A.do_attack_animation(D)
	D.visible_message(SPAN_DANGER("[A] bashes [D] away!"), SPAN_DANGER("[A] bashes you away!"))
	D.apply_damage(rand(5, 10), BRUTE, damage_flags = DAM_SHARP)
	var/throw_range = rand(1, 2)
	D.throw_at(get_step_away(D, A, throw_range), throw_range, THROWNOBJ_KNOCKBACK_SPEED / 3, A, FALSE)
	playsound(get_turf(D), 'sound/weapons/slash.ogg', 25, 1, -1)
	return TRUE

/datum/martial_art/revenant/proc/revenant_help()
	set name = "Recall Revenant Combat"
	set desc = "Remember the martial techniques of the bluespace masters."
	set category = "Abilities"

	to_chat(usr, "<b><i>You think of your former dimension...</i></b>")
	to_chat(usr, "<span class='notice'>Bash Slash</span>: Harm Harm Harm. Deliver a strong slashing strike against the enemy, pushing them away.")

#undef BASH_SLASH
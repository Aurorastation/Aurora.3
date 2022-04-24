/mob/living/simple_animal/hostile/faithless
	name = "Faithless"
	desc = "The Wish Granter's faith in humanity, incarnate."
	icon = 'icons/mob/npc/human.dmi'
	icon_state = "faithless"
	icon_living = "faithless"
	icon_dead = "faithless_dead"
	speak_chance = 0
	turns_per_move = 5
	organ_names = list("chest", "lower body", "left arm", "right arm", "left leg", "right leg", "head")
	response_help = "passes through"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = -1
	maxHealth = 80
	health = 80
	environment_smash = 2

	tameable = FALSE

	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "gripped"
	attack_sound = 'sound/hallucinations/growl1.ogg'

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	speed = 4

	faction = "faithless"

	flying = TRUE

	psi_pingable = FALSE

/mob/living/simple_animal/hostile/faithless/Allow_Spacemove(var/check_drift = 0)
	return 1

/mob/living/simple_animal/hostile/faithless/FindTarget()
	var/my_target = target_mob
	. = ..()
	if(. && (prob(30) || (. != my_target)))
		audible_emote("wails at [.]")

/mob/living/simple_animal/hostile/faithless/AttackingTarget()
	. =..()
	var/mob/living/L = .
	if(istype(L))
		if(prob(12))
			L.Weaken(3)
			L.visible_message(SPAN_DANGER("\the [src] knocks down \the [L]!"))

/mob/living/simple_animal/hostile/faithless/cult
	faction = "cult"
	appearance_flags = NO_CLIENT_COLOR

/mob/living/simple_animal/hostile/faithless/cult/cultify()
	return

/mob/living/simple_animal/hostile/faithless/cult/Life()
	..()
	check_horde()

/mob/living/simple_animal/hostile/faithless/do_animate_chat(var/message, var/datum/language/language, var/small, var/list/show_to, var/duration, var/list/message_override)
	INVOKE_ASYNC(src, /atom/movable/proc/animate_chat, message, language, small, show_to, duration)

/mob/living/simple_animal/hostile/faithless/can_fall()
	return FALSE

/mob/living/simple_animal/hostile/faithless/can_ztravel()
	return TRUE

/mob/living/simple_animal/hostile/faithless/CanAvoidGravity()
	return TRUE
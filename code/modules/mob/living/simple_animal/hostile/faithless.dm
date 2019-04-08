/mob/living/simple_animal/hostile/faithless
	name = "Faithless"
	desc = "The Wish Granter's faith in humanity, incarnate"
	icon_state = "faithless"
	icon_living = "faithless"
	icon_dead = "faithless_dead"
	speak_chance = 0
	turns_per_move = 5
	response_help = "passes through"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = -1
	maxHealth = 80
	health = 80
	environment_smash = 2

	tameable = FALSE

	harm_intent_damage = 10
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

/mob/living/simple_animal/hostile/faithless/Allow_Spacemove(var/check_drift = 0)
	return 1

/mob/living/simple_animal/hostile/faithless/FindTarget()
	. = ..()
	if(.)
		audible_emote("wails at [.]")

/mob/living/simple_animal/hostile/faithless/AttackingTarget()
	. =..()
	var/mob/living/L = .
	if(istype(L))
		if(prob(12))
			L.Weaken(3)
			L.visible_message("<span class='danger'>\the [src] knocks down \the [L]!</span>")

/mob/living/simple_animal/hostile/faithless/cult
	faction = "cult"
	appearance_flags = NO_CLIENT_COLOR

/mob/living/simple_animal/hostile/faithless/cult/cultify()
	return

/mob/living/simple_animal/hostile/faithless/cult/Life()
	..()
	check_horde()

/mob/living/simple_animal/hostile/faithless/wizard
	name = "lost soul"
	desc = "The result of a dark bargain."
	speed = -3
	maxHealth = 400
	health = 400
	universal_speak = 1
	universal_understand = 1

	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	harm_intent_damage = 0
	melee_damage_lower = 25
	melee_damage_upper = 25
	var/list/darkform_spells = list(/spell/aoe_turf/conjure/forcewall/lesser)

/mob/living/simple_animal/hostile/faithless/wizard/Initialize()
	. = ..()
	for(var/spell in darkform_spells)
		src.add_spell(new spell, "const_spell_ready")

/mob/living/simple_animal/hostile/faithless/can_fall()
	return FALSE

/mob/living/simple_animal/hostile/faithless/can_ztravel()
	return TRUE

/mob/living/simple_animal/hostile/faithless/CanAvoidGravity()
	return TRUE
/datum/ai_holder/simple_animal/hostile/scarybat

/datum/ai_holder/simple_animal/hostile/scarybat/on_target_acquired(atom/new_target, atom/old_target)
	holder.AIVisualEmote("flutters towards [new_target]")

/datum/ai_holder/simple_animal/hostile/scarybat/post_melee_attack(atom/the_target)
	. = ..()
	if(isliving(the_target) && prob(15))
		var/mob/living/living_target = the_target
		living_target.Stun(1)
		living_target.visible_message(SPAN_DANGER("\the [holder] scares \the [living_target]!"))

/mob/living/simple_animal/hostile/scarybat
	ai_holder_type = /datum/ai_holder/simple_animal/hostile/scarybat
	name = "space bats"
	desc = "A swarm of cute little blood sucking bats that looks pretty upset."
	icon = 'icons/mob/npc/bats.dmi'
	icon_state = "bat"
	icon_living = "bat"
	icon_dead = "bat_dead"
	icon_gib = "bat_dead"
	speak_chance = 0
	turns_per_move = 3
	meat_type = /obj/item/reagent_containers/food/snacks/meat/bat
	meat_amount = 6 //two wings per bat
	organ_names = list("upper bat", "mid bat", "lower bat")
	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	speed = 4
	maxhealth = 20
	health = 20
	mob_size = 2.5

	harm_intent_damage = 8
	melee_damage_lower = 10
	melee_damage_upper = 10
	resist_mod = 10 // can't grab a cloud of bats easily
	attacktext = "bites"
	attack_vis_effect = ATTACK_EFFECT_BITE
	attack_sound = 'sound/weapons/bite.ogg'

	//Space carp aren't affected by atmos.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	environment_smash = 1
	destroy_surroundings = FALSE

	faction = "scarybat"
	flying = TRUE
	butchering_products = list(/obj/item/stack/material/animalhide = 1)
	var/mob/living/owner
	emote_sounds = list('sound/effects/creatures/bat.ogg')

/mob/living/simple_animal/hostile/scarybat/Initialize(mapload, mob/living/L as mob)
	. = ..()
	if(istype(L))
		owner = L

/mob/living/simple_animal/hostile/scarybat/Allow_Spacemove(var/check_drift = 0)
	return ..()	//No drifting in space for space carp!	//original comments do not steal

/mob/living/simple_animal/hostile/scarybat/Destroy()
	owner = null
	return ..()

/mob/living/simple_animal/hostile/scarybat/cult
	faction = "cult"
	supernatural = 1
	tameable = FALSE
	appearance_flags = NO_CLIENT_COLOR

/mob/living/simple_animal/hostile/scarybat/cult/cultify()
	return

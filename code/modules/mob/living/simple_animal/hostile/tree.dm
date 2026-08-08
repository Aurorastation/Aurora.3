/datum/ai_holder/simple_animal/hostile/tree

/datum/ai_holder/simple_animal/hostile/tree/on_target_acquired(atom/new_target, atom/old_target)
	holder.AIAudibleEmote("growls at [new_target]")

/datum/ai_holder/simple_animal/hostile/tree/post_melee_attack(atom/the_target)
	. = ..()
	if(isliving(the_target) && prob(15))
		var/mob/living/living_target = the_target
		living_target.Weaken(3)
		living_target.visible_message(SPAN_DANGER("\the [holder] knocks down \the [living_target]!"))

/mob/living/simple_animal/hostile/tree
	ai_holder_type = /datum/ai_holder/simple_animal/hostile/tree
	name = "pine tree"
	desc = "A pissed off tree-like alien. It seems annoyed with the festivities..."
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_1"
	icon_living = "pine_1"
	icon_dead = "pine_1"
	icon_gib = "pine_1"
	speak_chance = 0
	turns_per_move = 5
	meat_type = /obj/item/reagent_containers/food/snacks/fish/carpmeat
	organ_names = list("trunk", "branches", "roots")
	response_help = "brushes"
	response_disarm = "pushes"
	response_harm = "hits"
	blood_overlay_icon = null
	speed = -1
	maxhealth = 250
	health = 250

	pixel_x = -16

	harm_intent_damage = 5
	melee_damage_lower = 8
	melee_damage_upper = 12
	attacktext = "bites"
	attack_vis_effect = ATTACK_EFFECT_BITE //what how
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

	faction = "carp"

	psi_pingable = FALSE

/mob/living/simple_animal/hostile/tree/death()
	..(null,"is hacked into pieces!")
	new /obj/item/stack/material/wood(loc)
	qdel(src)

/mob/living/simple_animal/lizard
	name = "lizard"
	desc = "It's a hissy little lizard. Is it related to Unathi?"
	icon_state = "lizard"
	icon_living = "lizard"
	icon_dead = "lizard-dead"
	speak_emote = list("hisses")
	health = 5
	maxHealth = 5
	attacktext = "bitten"
	melee_damage_lower = 1
	melee_damage_upper = 2
	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "stomps on"
	mob_size = MOB_MINISCULE
	possession_candidate = 1
	holder_type = /obj/item/holder/lizard
	density = 0
	seek_speed = 0.75
	canbrush = TRUE
	brush = /obj/item/reagent_containers/glass/rag

	butchering_products = list(/obj/item/stack/material/animalhide/lizard = 2)

	var/decompose_time = 18000

/mob/living/simple_animal/lizard/Initialize()
	. = ..()
	nutrition = rand(max_nutrition*0.25, max_nutrition*0.75)

/mob/living/simple_animal/lizard/Life()
	if (!..())
		if ((world.time - timeofdeath) > decompose_time)
			dust()


/mob/living/simple_animal/lizard/attack_hand(mob/living/carbon/human/M as mob)
	if (src.stat == DEAD)//If the creature is dead, we don't pet it, we just pickup the corpse on click
		get_scooped(M, usr)
		return
	else
		..()

/mob/living/simple_animal/lizard/death()
	. = ..()
	desc = "It doesn't hiss anymore."

/mob/living/simple_animal/lizard/dust()
	..(remains = /obj/effect/decal/remains/lizard)

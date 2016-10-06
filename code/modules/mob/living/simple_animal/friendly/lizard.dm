/mob/living/simple_animal/lizard
	name = "Lizard"
	desc = "It's a hissy little lizard. Is it related to Unathi?"
	icon = 'icons/mob/critter.dmi'
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
	holder_type = /obj/item/weapon/holder/lizard
	density = 0

/mob/living/simple_animal/lizard/attack_hand(mob/living/carbon/human/M as mob)
	if (src.stat == DEAD)//If the creature is dead, we don't pet it, we just pickup the corpse on click
		get_scooped(M)
		return
	else
		..()

/mob/living/simple_animal/lizard/death()
	.=..()
	desc = "It doesn't hiss anymore."

/mob/living/simple_animal/lizard
	name = "Lizard"
	desc = "It's a hissy little lizard. Is it related to Unathi?"
	icon = 'icons/mob/npc/critter.dmi'
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
	seek_speed = 0.75

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

/mob/living/simple_animal/lizard/wizard
	desc = "It's a little lizard. Where did it come from?"

/mob/living/simple_animal/lizard/wizard/verb/change_name()
	set name = "Name Lizard"
	set category = "IC"
	set src in view(1)

	var/mob/M = usr
	if(!M.mind)	return 0

	if(!name_changed)

		var/input = sanitizeSafe(input("What do you want to name the lizard?", ,""), MAX_NAME_LEN)

		if(src && input && !M.stat && in_range(M,src))
			name = input
			real_name = input
			name_changed = 1
			return 1

	else
		to_chat(usr, "<span class='notice'>[src] already has a name!</span>")
		return
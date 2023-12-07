/mob/living/simple_animal/hostile/retaliate/jewelercockatoo
	name = "jeweler cockatoo"
	desc = "An enormous and endangered bird native to Konyang, known for its habit of decorating its nest with pearls and gems of all sorts."
	icon = 'icons/mob/npc/jeweler_cockatoo.dmi'
	icon_state = "birb"
	icon_living = "birb"
	icon_dead = "birb_dead"
	turns_per_move = 5
	speak_emote = list("squawks", "chirps")
	emote_hear = list("squawks", "bawks")
	emote_see = list("flutters its wings", "digs in the dirt")
	a_intent = I_HURT
	stop_automated_movement_when_pulled = 0
	mob_size = 12
	organ_names = list("torso", "left wing", "right wing", "head")

	maxHealth = 150
	health = 150

	melee_damage_lower = 20
	melee_damage_upper = 30
	armor_penetration = 20
	attacktext = "clawed"
	attack_sound = 'sound/weapons/slice.ogg'

	meat_amount = 8
	faction = "Konyang"

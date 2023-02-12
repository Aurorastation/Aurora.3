/mob/living/simple_animal/thinbug
	name = "taki"
	desc = "It looks like a bunch of legs."
	icon_state = "thinbug"
	icon_living = "thinbug"
	icon_dead = "thinbug_dead"
	mob_size = MOB_MINISCULE
	density = FALSE

	emote_hear = list("scratches the ground", "rubs its legs together", "chitters")


/mob/living/simple_animal/hostile/retaliate/royalcrab
	name = "cragenoy"
	desc = "It looks like a crustacean with an exceedingly hard carapace. Watch the pinchers!"
	faction = "crab"
	icon_state = "royalcrab"
	icon_living = "royalcrab"
	icon_dead = "royalcrab_dead"
	move_to_delay = 3
	maxHealth = 150
	health = 150
	speed = 1
	melee_damage_lower = 10
	melee_damage_upper = 15
	natural_armor = list(
		melee = ARMOR_MELEE_RESISTANT
		)

	emote_see = list("skitters","oozes liquid from its mouth", "scratches at the ground", "clicks its claws")

/mob/living/simple_animal/hostile/retaliate/beast/charbaby
	name = "charbaby"
	desc = "A huge grubby creature."
	icon_state = "char"
	icon_living = "char"
	icon_dead = "char_dead"
	mob_size = MOB_LARGE
	health = 45
	maxHealth = 45
	speed = 2
	response_help = "pats briefly"
	response_disarm = "gently pushes"
	response_harm = "strikes"
	harm_intent_damage = 1
	melee_damage_lower = 5
	melee_damage_upper = 10
	blood_color = COLOR_RED
	natural_armor = list(
		laser = ARMOR_LASER_PISTOL
	)

/mob/living/simple_animal/hostile/retaliate/beast/charbaby/on_attack_mob(var/mob/hit_mob)	
	. = ..()
	if(isliving(hit_mob) && prob(25))
		var/mob/living/L = hit_mob
		if(prob(10))
			L.adjust_fire_stacks(1)
			L.IgniteMob()

/mob/living/simple_animal/hostile/retaliate/beast/charbaby/attack_hand(mob/living/carbon/human/H)
	. = ..()
	reflect_unarmed_damage(H, BURN, "amorphous mass")

/mob/living/simple_animal/hostile/retaliate/beast/shantak/lava
	desc = "A vaguely canine looking beast. It looks as though its fur is made of stone wool."
	icon_state = "lavadog"
	icon_living = "lavadog"
	icon_dead = "lavadog_dead"

	speak = list("Karuph!", "Karump!")
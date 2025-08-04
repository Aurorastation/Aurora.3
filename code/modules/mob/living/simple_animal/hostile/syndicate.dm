/mob/living/simple_animal/hostile/syndicate
	name = "\improper Syndicate operative"
	desc = "Death to the Company."
	icon = 'icons/mob/npc/human.dmi'
	icon_state = "syndicate"
	icon_living = "syndicate"
	icon_dead = "syndicate_dead"
	icon_gib = "syndicate_gib"
	speak_chance = 0
	turns_per_move = 5
	organ_names = list("chest", "lower body", "left arm", "right arm", "left leg", "right leg", "head")
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = 4
	stop_automated_movement_when_pulled = 0
	maxHealth = 100
	health = 100
	harm_intent_damage = 5
	melee_damage_lower = 10
	melee_damage_upper = 10
	attacktext = "punched"
	a_intent = I_HURT
	var/corpse = /obj/effect/landmark/mobcorpse/syndicatesoldier
	var/weapon1
	var/weapon2
	min_oxy = 5
	max_oxy = 0
	min_tox = 0
	max_tox = 1
	min_co2 = 0
	max_co2 = 5
	min_n2 = 0
	max_n2 = 0
	unsuitable_atoms_damage = 15
	environment_smash = 1
	faction = "syndicate"
	status_flags = CANPUSH

	tameable = FALSE

/mob/living/simple_animal/hostile/syndicate/death()
	..()
	if(corpse)
		new corpse (src.loc)
	if(weapon1)
		new weapon1 (src.loc)
	if(weapon2)
		new weapon2 (src.loc)
	qdel(src)
	return

///////////////Sword and shield////////////

/mob/living/simple_animal/hostile/syndicate/melee
	melee_damage_lower = 20
	melee_damage_upper = 25
	icon_state = "syndicatemelee"
	icon_living = "syndicatemelee"
	weapon1 = /obj/item/melee/energy/sword/red
	weapon2 = /obj/item/shield/energy
	attacktext = "slashed"
	status_flags = 0

/mob/living/simple_animal/hostile/syndicate/melee/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.force)
		if(prob(80))
			var/damage = attacking_item.force
			if (attacking_item.damtype == DAMAGE_PAIN)
				damage = 0
			health -= damage
			visible_message(SPAN_DANGER("[src] has been attacked with the [attacking_item] by [user]."))
		else
			visible_message(SPAN_DANGER("[src] blocks the [attacking_item] with its shield!"))
		//user.do_attack_animation(src)
	else
		to_chat(usr, SPAN_WARNING("This weapon is ineffective, it does no damage."))
		visible_message(SPAN_WARNING("[user] gently taps [src] with the [attacking_item]."))


/mob/living/simple_animal/hostile/syndicate/melee/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	if(prob(35))
		visible_message(SPAN_DANGER("[src] blocks [hitting_projectile] with its shield!"))
		return BULLET_ACT_BLOCK

	. = ..()
	if(. != BULLET_ACT_HIT)
		return .

	src.health -= hitting_projectile.damage


/mob/living/simple_animal/hostile/syndicate/melee/space
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	icon_state = "syndicatemeleespace"
	icon_living = "syndicatemeleespace"
	name = "Syndicate Commando"
	corpse = /obj/effect/landmark/mobcorpse/syndicatecommando
	speed = 0

/mob/living/simple_animal/hostile/syndicate/melee/space/Allow_Spacemove(var/check_drift = 0)
	return

/mob/living/simple_animal/hostile/syndicate/ranged
	ranged = 1
	rapid = 1
	smart_ranged = TRUE
	icon_state = "syndicateranged"
	icon_living = "syndicateranged"
	casingtype = /obj/item/ammo_casing/c10mm
	projectilesound = 'sound/weapons/gunshot/gunshot_light.ogg'
	projectiletype = /obj/projectile/bullet/pistol/medium

	weapon1 = /obj/item/gun/projectile/automatic/c20r

/mob/living/simple_animal/hostile/syndicate/ranged/space
	icon_state = "syndicaterangedpsace"
	icon_living = "syndicaterangedpsace"
	name = "Syndicate Commando"
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	corpse = /obj/effect/landmark/mobcorpse/syndicatecommando
	speed = 0

/mob/living/simple_animal/hostile/syndicate/ranged/space/Allow_Spacemove(var/check_drift = 0)
	return

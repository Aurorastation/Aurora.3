/mob/living/simple_animal/hostile/viscerator
	name = "viscerator"
	desc = "A small, twin-bladed machine capable of inflicting very deadly lacerations."
	icon = 'icons/mob/npc/aibots.dmi'
	icon_state = "viscerator_attack"
	icon_living = "viscerator_attack"
	pass_flags = PASSTABLE|PASSRAILING
	health = 15
	maxHealth = 15
	melee_damage_lower = 10
	melee_damage_upper = 15
	armor_penetration = 20
	density = 0
	attacktext = "cut"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	blood_overlay_icon = null
	faction = "syndicate"
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	tameable = FALSE
	smart_melee = FALSE

	flying = TRUE
	attack_emote = "buzzes at"

	psi_pingable = FALSE

/mob/living/simple_animal/hostile/viscerator/death()
	..(null,"is smashed into pieces!")
	var/T = get_turf(src)
	new /obj/effect/gibspawner/robot(T)
	spark(T, 3, alldirs)
	qdel(src)

/mob/living/simple_animal/hostile/viscerator/CanPass(atom/movable/mover, turf/target, height, air_group)
	. = ..()
	if(.)
		if(istype(mover, /mob/living/simple_animal/hostile/viscerator))
			return FALSE

/mob/living/simple_animal/hostile/viscerator/proc/wakeup()
	stance = HOSTILE_STANCE_IDLE

/mob/living/simple_animal/hostile/viscerator/emp_act(severity)
	LoseTarget()
	stance = HOSTILE_STANCE_TIRED
	addtimer(CALLBACK(src, PROC_REF(wakeup)), 150)
	if(severity == 1.0)
		apply_damage(5)

/mob/living/simple_animal/hostile/viscerator/lube
	reagents_to_add = list(/decl/reagent/lube = 30)

/mob/living/simple_animal/hostile/viscerator/lube/death()
	reagents.splash(get_turf(src), 30)
	..()

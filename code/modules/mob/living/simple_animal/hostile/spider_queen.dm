/mob/living/simple_animal/hostile/giant_spider/nurse/spider_queen
	name = "colossal greimorian"
	desc = "A monstrous six-legged Greimorian."
	desc_extended = "Greimorians are a species of arthropods whose evolutionary traits have made them an extremely dangerous invasive species.  \
	They originate from the Badlands planet Greima, once covered in crystalized phoron. A decaying orbit led to its combustion from proximity to its sun, and its dominant inhabitants \
	managed to survive in orbit. Countless years later, they prove to be a menace across the galaxy, having carried themselves within the hulls of Human vessels to spread wildly."
	icon = 'icons/mob/npc/spider_queen.dmi'
	icon_state = "spider_queen"
	icon_living = "spider_queen"
	icon_rest = "spider_queen_rest"
	icon_dead = "spider_queen_dead"
	speak_emote = list("chitters")
	emote_hear = list("chitters")
	speak_chance = 5
	turns_per_move = 5
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	meat_type = /obj/item/reagent_containers/food/snacks/xenomeat
	organ_names = list("thorax", "legs", "head")
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "pokes"
	blood_type = "#51C404"
	blood_overlay_icon = null
	stop_automated_movement_when_pulled = 0
	maxHealth = 1000
	health = 1000
	melee_damage_lower = 35
	melee_damage_upper = 40
	armor_penetration = 30
	resist_mod = 15 // LOL good luck pal
	heat_damage_per_tick = 20
	cold_damage_per_tick = 20
	faction = "spiders"
	fed = 3

	minbodytemp = 0
	maxbodytemp = 350
	min_oxy = 0
	max_co2 = 0
	max_tox = 0

	mob_swap_flags = HUMAN|SIMPLE_ANIMAL|SLIME|MONKEY
	mob_push_flags = ALLMOBS

	attacktext = "bit"
	attack_sound = 'sound/weapons/bite.ogg'

	pass_flags = PASSTABLE|PASSRAILING
	move_to_delay = 6
	speed = -1
	mob_size = 15
	environment_smash = 2

	pixel_x = -16

	attack_emote = "skitters toward"
	emote_sounds = list('sound/effects/creatures/spider_critter.ogg')

	tameable = FALSE
	density = FALSE

	var/hovering = FALSE

/mob/living/simple_animal/hostile/giant_spider/nurse/spider_queen/Initialize()
	. = ..()

	add_spell(new /spell/targeted/ceiling_climb, "const_spell_ready")

/mob/living/simple_animal/hostile/giant_spider/nurse/spider_queen/update_icon()
	..()

	if(hovering)
		icon_state = "spider_queen_shadow"
	else
		icon_state = initial(icon_state)
/mob/living/simple_animal/hostile/giant_spider/nurse/spider_queen/UnarmedAttack(var/atom/A, var/proximity)
	if(hovering)
		return
	..()

/spell/targeted/ceiling_climb
	name = "Ceiling Climbing"
	desc = "Allows the spider queen to walk on the ceiling, becoming untargetable."
	feedback = "CEIB"
	range = 0
	spell_flags = INCLUDEUSER
	charge_max = 1200 //2 minute
	max_targets = 1

	invocation_type = SpI_EMOTE
	invocation = "climbs on the ceiling."

	hud_state = "spider_climb"

/spell/targeted/ceiling_climb/cast(mob/target,var/mob/living/user as mob)
	..()
	if(istype(user, /mob/living/simple_animal/hostile/giant_spider/nurse/spider_queen))
		var/mob/living/simple_animal/hostile/giant_spider/nurse/spider_queen/M = user
		if(M.hovering)
			return FALSE
		M.hovering = TRUE
		M.mouse_opacity = FALSE
		M.speed = -1
		M.update_icon()
		M.pass_flags = PASSTABLE | PASSMOB
		M.layer = LYING_MOB_LAYER
		addtimer(CALLBACK(src, PROC_REF(do_landing), M), 1 MINUTE)
		return TRUE
	else
		return FALSE

/spell/targeted/ceiling_climb/proc/do_landing(var/mob/living/simple_animal/hostile/giant_spider/nurse/spider_queen/S)
	S.hovering = FALSE
	S.mouse_opacity = TRUE
	S.speed = initial(S.speed)
	S.update_icon()
	S.pass_flags = PASSTABLE
	S.layer = initial(S.layer)
	var/turf/target_turf = get_turf(S)
	if(target_turf)
		S.visible_message("<span class='danger'>\The [S] lands on the [target_turf]!</span>")
		for(var/mob/living/M in target_turf)
			if(M != src)
				M.apply_damage(50, DAMAGE_BRUTE)
				M.apply_effect(6, STUN)
	return TRUE

/mob/living/simple_animal/hostile/giant_spider/nurse/spider_queen/Life()
	..()
	adjustBruteLoss(-3)

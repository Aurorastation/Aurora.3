//animals from moghes
/mob/living/simple_animal/hostile/biglizard
	name = "plains tyrant"
	desc = "The Skrazi, or 'plains tyrant', is an apex predator from the world of Moghes. Reaching up to fifteen feet in height, these beasts have earned a near-mythical reputation among the Unathi, with hunting a tyrant having been historically considered an elaborate form of suicide. Since the Contact War, these mighty predators are increasingly endangered due to loss of their habitats."
	icon = 'icons/mob/biglizard.dmi'
	icon_state = "biglizard"
	icon_living = "biglizard"
	icon_dead = "biglizard_dead"
	speak_emote = list("hisses","roars")
	emote_hear = list("hisses","grumbles","growls")
	emote_see = list("hisses ferociously", "stomps")
	emote_sounds = list('sound/effects/creatures/monstergrowl.ogg')
	turns_per_move = 5
	speak_chance = 5
	meat_type = /obj/item/reagent_containers/food/snacks/meat
	meat_amount = 10
	organ_names = list("chest", "lower body", "left arm", "right arm", "left leg", "right leg", "head")
	response_help  = "pets"
	response_disarm = "shoves"
	response_harm   = "harmlessly punches"
	blood_overlay_icon = null
	maxHealth = 500
	health = 500
	harm_intent_damage = 0
	melee_damage_lower = 40
	melee_damage_upper = 40
	armor_penetration = 20
	resist_mod = 10
	mob_size = 30
	environment_smash = 2
	attacktext = "chomped"
	attack_sound = 'sound/weapons/bloodyslice.ogg'

	faction = "lizard"
	butchering_products = list(/obj/item/stack/material/animalhide/lizard = 20)
	var/is_devouring = FALSE

/mob/living/simple_animal/hostile/biglizard/AttackingTarget()
	. =..()
	var/mob/living/L = .
	if(istype(L))
		if(prob(25))
			L.Weaken(3)
			L.visible_message("<span class='danger'>\The [src] knocks down \the [L]!</span>")

/mob/living/simple_animal/hostile/biglizard/death(gibbed)
	..()
	anchored = TRUE

/mob/living/simple_animal/hostile/biglizard/Life()
	..()
	adjustBruteLoss(-5)

/mob/living/simple_animal/hostile/biglizard/verb/devour(mob/living/target as mob in oview())
	set category = "Plains Tyrant"
	set name = "Devour"
	set desc = "Devours a creature, destroying its body and regenerating health."

	if(!Adjacent(target))
		return

	if(target.isSynthetic())
		return

	if(is_devouring)
		to_chat(src, SPAN_WARNING("You are already feasting on something!"))
		return

	if(!health)
		to_chat(src, SPAN_NOTICE("You are dead, you cannot use any abilities!"))
		return

	if(last_special > world.time)
		to_chat(src, SPAN_WARNING("You must wait a little while before we can use this ability again!"))
		return

	visible_message(SPAN_WARNING("\The [src] begins ripping apart and feasting on [target]!"))
	is_devouring = TRUE

	target.adjustBruteLoss(35)

	if(!do_after(src,150))
		to_chat(src, SPAN_WARNING("You need to wait longer to devour \the [target]!"))
		src.is_devouring = FALSE
		return FALSE

	visible_message(SPAN_WARNING("[src] tears a chunk from \the [target]'s flesh!"))

	target.adjustBruteLoss(35)

	if(!do_after(src, 150))
		to_chat(src, SPAN_WARNING("You need to wait longer to devour \the [target]!"))
		is_devouring = FALSE
		return FALSE

	visible_message(SPAN_WARNING("[target] is completely devoured by [src]!"), \
						SPAN_WARNING("You completely devour \the [target]!"))
	target.gib()
	rejuvenate()
	updatehealth()
	last_special = world.time + 100
	is_devouring = FALSE
	return

/mob/living/simple_animal/hostile/shrieker
	name = "siro"
	desc = "A flying Moghesian mammal, the siro, or 'shrieker', is known for its loud screech, which it uses to stun its prey before diving at them and ramming them with its snout."
	icon = 'icons/mob/npc/moghes_48.dmi'
	icon_state = "siro"
	icon_living = "siro"
	icon_dead = "siro_dead"
	turns_per_move = 3

	organ_names = list("head", "chest", "right upper wing", "right lower wing", "left upper wing", "left lower wing", "right leg", "left leg")
	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	speed = -1
	maxHealth = 50
	health = 50
	mob_size = 10

	pass_flags = PASSTABLE

	melee_damage_lower = 5
	melee_damage_upper = 8
	attacktext = "rammed"
	attack_sound = 'sound/weapons/punch4_bass.ogg'

	environment_smash = 1

	flying = TRUE
	butchering_products = list(/obj/item/stack/material/animalhide/lizard = 1)
	meat_type = /obj/item/reagent_containers/food/snacks/meat
	meat_amount = 2
	var/shriek_time = 0

/mob/living/simple_animal/hostile/shrieker/proc/shriek(turf/T, mob/living/M)
	if(shriek_time > world.time)
		return
	else
		visible_message(SPAN_DANGER("\The [src] emits an ear-splitting shriek!"))
		playsound(get_turf(src), 'sound/effects/creatures/siro_shriek.ogg', 50, 1)
		var/shriek_intensity = 1 - (9 * get_dist(T, M) / 70)
		M.noise_act(intensity = EAR_PROTECTION_MAJOR, damage_pwr = 10 * shriek_intensity, deafen_pwr = 15 * (1 - shriek_intensity))
		if(M.get_hearing_sensitivity()) // we only stun if they've got sensitive ears
			// checking for protection is handled by noise_act
			M.noise_act(intensity = EAR_PROTECTION_MAJOR, stun_pwr = 2)
		shriek_time = world.time + 2 MINUTES //cant do it too often or it will get annoying as fuck

/mob/living/simple_animal/hostile/shrieker/FoundTarget()
	if(target_mob && shriek_time <= world.time)
		shriek(get_turf(src), target_mob)

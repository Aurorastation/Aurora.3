/mob/living/simple_animal/hostile/vannatusk_ghostrole
	name = "vannatusk"
	desc = "A monstrous interdimensional invader. Its body is protected by a chitin carapace."
	icon = 'icons/mob/npc/vannatusk.dmi'
	icon_state = "vannatusk"
	icon_living = "vannatusk"
	icon_dead = "vannatusk_dead"

	mob_swap_flags = HUMAN|SIMPLE_ANIMAL|SLIME|MONKEY
	mob_push_flags = ALLMOBS

	tameable = FALSE

	organ_names = list("chest", "lower body", "left arm", "right arm", "left leg", "right leg", "head")
	response_help  = "pets"
	response_disarm = "shoves"
	response_harm   = "harmlessly punches"
	maxHealth = 500
	health = 500
	harm_intent_damage = 5
	melee_damage_lower = 30
	melee_damage_upper = 30
	armor_penetration = 15
	resist_mod = 3
	mob_size = 15
	environment_smash = 2
	see_in_dark = 10
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	attacktext = "mangled"
	attack_emote = "charges toward"
	attack_sound = 'sound/effects/creatures/vannatusk_attack.ogg'
	emote_sounds = list('sound/effects/creatures/vannatusk_sound.ogg', 'sound/effects/creatures/vannatusk_sound_2.ogg')

	minbodytemp = 0
	maxbodytemp = 350
	min_oxy = 0
	max_co2 = 0
	max_tox = 0

	blood_type = "#001126"

	speed = 3

	meat_type = /obj/item/reagent_containers/food/snacks/meat/vannatusk

	var/crystal_harvested = FALSE

	psi_pingable = FALSE

/mob/living/simple_animal/hostile/vannatusk_ghostrole/Initialize()
	. = ..()
	set_light(1.2, 3, LIGHT_COLOR_BLUE)

/mob/living/simple_animal/hostile/vannatusk_ghostrole/death()
	..(null, "collapses!")
	flick("vannatusk_death_animation", src)

/mob/living/simple_animal/hostile/vannatusk_ghostrole/attackby(obj/item/O, mob/user)
	if(stat != DEAD)
		return ..()
	if(istype(O, /obj/item/surgery/scalpel))
		if(crystal_harvested)
			to_chat(user, SPAN_WARNING("\The [src]'s crystal has already been harvested!"))
			return

		visible_message(SPAN_NOTICE("[user] recovers a bluespace crystal from [src]'s remains!"))
		var/obj/item/bluespace_crystal/C = new(get_turf(src))
		user.put_in_any_hand_if_possible(C)
		crystal_harvested = TRUE
		return

	return..()

/mob/living/simple_animal/hostile/vannatusk_ghostrole/dead/Initialize()
	. = ..()
	death()

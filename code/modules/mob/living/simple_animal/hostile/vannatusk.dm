/mob/living/simple_animal/hostile/vannatusk
	name = "vannatusk"
	desc = "An interdimensional bluespace creature.."
	icon = 'icons/mob/npc/animal.dmi'
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
	maxHealth = 250
	health = 250
	harm_intent_damage = 5
	melee_damage_lower = 20
	melee_damage_upper = 20
	resist_mod = 3
	mob_size = 15
	environment_smash = 2
	attacktext = "mangled"
	attack_sound = 'sound/weapons/bloodyslice.ogg'

	minbodytemp = 0
	maxbodytemp = 350
	min_oxy = 0
	max_co2 = 0
	max_tox = 0
	var/crystal_harvested = FALSE

/mob/living/simple_animal/hostile/vannatusk/Initialize()
	. = ..()
	set_light(1.2, 3, LIGHT_COLOR_BLUE)
/*
/mob/living/simple_animal/hostile/vannatusk/death()
	..(null, "blows apart!")
	var/T = get_turf(src)
	new /obj/effect/gibspawner/robot(T)
	spark(T, 1, alldirs)
	qdel(src)
*/

/mob/living/simple_animal/hostile/vannatusk/FoundTarget()
	if(target_mob)
		custom_emote(VISIBLE_MESSAGE,"stares alertly at [target_mob]")
		if(!Adjacent(target_mob))
			fire_spike(target_mob)


/mob/living/simple_animal/hostile/vannatusk/proc/fire_spike(var/mob/living/target_mob)
	visible_message(SPAN_DANGER("\The [src] fires a spike at [target_mob]!"))
	playsound(get_turf(src), 'sound/weapons/bloodyslice.ogg', 50, 1)
	var/obj/item/bone_dart/A = new /obj/item/bone_dart/vannatusk(get_turf(src))
	A.throw_at(target_mob, 10, 20, src)

/obj/item/bone_dart/vannatusk
	name = "bone dart"
	desc = "A sharp piece of bone shapped as small dart."
	icon = 'icons/obj/changeling.dmi'
	icon_state = "bone_dart"
	item_state = "bolt"

/mob/living/simple_animal/hostile/vannatusk/attackby(obj/item/O, mob/user)
	if (stat == DEAD && !crystal_harvested)
		if(istype(O, /obj/item/surgery/scalpel))
			visible_message(SPAN_NOTICE("[user] recovers a bluespace crystal from [src]'s remains!"))
			var/obj/item/bluespace_crystal/C = new(get_turf(src))
			user.put_in_any_hand_if_possible(C)
			crystal_harvested = TRUE
			return

	..()


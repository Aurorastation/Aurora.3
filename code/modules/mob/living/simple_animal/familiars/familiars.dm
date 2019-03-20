/mob/living/simple_animal/familiar
	name = "familiar"
	desc = "No wizard is complete without a mystical sidekick."
	supernatural = 1

	response_help = "pets"
	response_disarm = "pushes"
	response_harm = "hits"

	universal_speak = 1
	universal_understand = 1

	min_oxy = 1 //still require a /bit/ of air.
	max_co2 = 0
	unsuitable_atoms_damage = 1

	hunger_enabled = 0
	supernatural = 1

	var/list/wizardy_spells = list()

/mob/living/simple_animal/familiar/Initialize()
	. = ..()
	add_language(LANGUAGE_TCB)
	for(var/spell in wizardy_spells)
		src.add_spell(new spell, "const_spell_ready")

/mob/living/simple_animal/familiar/carcinus
	name = "crab"
	desc = "A small crab said to be made of stone and starlight."
	icon = 'icons/mob/npc/animal.dmi'
	icon_state = "evilcrab"
	icon_living = "evilcrab"
	icon_dead = "evilcrab_dead"

	speak_emote = list("chitters","clicks")


	health = 200
	maxHealth = 200
	melee_damage_lower = 10
	melee_damage_upper = 15
	friendly = "pinches"
	attacktext = "pinched"
	resistance = 9


/mob/living/simple_animal/familiar/pike
	name = "space pike"
	desc = "A bigger, more magical cousin of the space carp."
	icon = 'icons/mob/npc/spaceshark.dmi'
	icon_state = "shark"
	icon_living = "shark"
	icon_dead = "shark_dead"
	icon_rest = "shark_rest"
	pixel_x = -16

	speak_emote = list("gnashes")
	attacktext = "bitten"
	attack_sound = 'sound/weapons/bite.ogg'

	environment_smash = 2
	health = 100
	maxHealth = 100
	melee_damage_lower = 15
	melee_damage_upper = 15

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/carpmeat

	min_oxy = 0

	wizardy_spells = list(/spell/aoe_turf/conjure/forcewall)

	flying = TRUE

/mob/living/simple_animal/familiar/pike/Allow_Spacemove(var/check_drift = 0)
	return 1

/mob/living/simple_animal/familiar/horror
	name = "horror"
	desc = "A sanity-destroying otherthing."
	icon = 'icons/mob/mob.dmi'
	icon_state = "horror"
	icon_living = "horror"
	icon_dead = "horror_dead"

/mob/living/simple_animal/familiar/horror/Initialize()
	. = ..()
	if(prob(25))
		icon_state = "horror_alt"
		icon_living = "horror_alt"
		icon_dead = "horror_alt_dead"
	else if(prob(25))
		icon_state = "abomination"
		icon_living = "abomination"
		icon_dead = "abomination_dead"

	speak_emote = list("moans", "groans")

	response_help = "thinks better of touching"

	environment_smash = 2
	health = 150
	maxHealth = 150
	melee_damage_lower = 10
	melee_damage_upper = 10
	attacktext = "clawed"

	wizardy_spells = list(/spell/targeted/torment)

/mob/living/simple_animal/familiar/horror/death()
	..(null,"rapidly deteriorates")

	ghostize()
	gibs(src.loc)
	qdel(src)


/mob/living/simple_animal/familiar/goat
	name = "goat"
	desc = "A sprightly looking goat."
	icon_state = "goat"
	icon_living = "goat"
	icon_dead = "goat_dead"
	speak_emote = list("brays")
	attacktext = "kicked"

	health = 80
	maxHealth = 80

	melee_damage_lower = 8
	melee_damage_upper = 12
	mob_size = 4.5 //weight based on Chanthangi goats
	density = 0
	wizardy_spells = list(/spell/aoe_turf/smoke)


/mob/living/simple_animal/familiar/pet //basically variants of normal animals with spells.
	icon = 'icons/mob/npc/animal.dmi'

/mob/living/simple_animal/familiar/pet/MouseDrop(atom/over_object)
	var/mob/living/carbon/H = over_object
	if(!istype(H) || !Adjacent(H)) return ..()

	if(H.a_intent == "help" && holder_type)
		get_scooped(H)
		return
	else
		return ..()

/mob/living/simple_animal/familiar/pet/cat
	name = "black cat"
	desc = "A pitch black cat. Said to be especially unlucky."
	icon_state = "cat3"
	icon_living = "cat3"
	icon_dead = "cat3_dead"
	icon_rest = "cat3_rest"
	can_nap = 1

	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_NOLIGHTING

	speak_emote = list("meows", "purrs")
	holder_type = /obj/item/weapon/holder/cat
	mob_size = MOB_SMALL

	health = 45
	maxHealth = 45
	melee_damage_lower = 3
	melee_damage_upper = 4
	attacktext = "clawed"
	density = 0

	wizardy_spells = list(/spell/targeted/subjugation)


/mob/living/simple_animal/mouse/familiar
	name = "ancient mouse"
	desc = "A small rodent. It looks very old."
	body_color = "gray"


	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_NOLIGHTING


	health = 25
	maxHealth = 25
	melee_damage_lower = 1
	melee_damage_upper = 1
	attacktext = "nibbled"
	universal_speak = 1
	universal_understand = 1

	min_oxy = 1 //still require a /bit/ of air.
	max_co2 = 0
	unsuitable_atoms_damage = 1

	supernatural = 1

/mob/living/simple_animal/mouse/familiar/Initialize()
	. = ..()
	add_spell(new /spell/targeted/heal_target, "const_spell_ready")
	add_spell(new /spell/targeted/heal_target/area, "const_spell_ready")
	add_language(LANGUAGE_TCB)
	name = initial(name)
	desc = initial(desc)

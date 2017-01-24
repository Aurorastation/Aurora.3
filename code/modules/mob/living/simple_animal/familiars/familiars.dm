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

	var/list/wizardy_spells = list()

/mob/living/simple_animal/familiar/New()
	..()
	add_language("Ceti Basic")
	for(var/spell in wizardy_spells)
		src.add_spell(new spell, "const_spell_ready")

/mob/living/simple_animal/familiar/carcinus
	name = "crab"
	desc = "An odd looking crab."
	icon = 'icons/mob/animal.dmi'
	icon_state = "evilcrab"
	icon_living = "evilcrab"
	icon_dead = "evilcrab_dead"

	speak_emote = list("chitters","clicks")


	health = 200
	maxHealth = 200
	melee_damage_lower = 10
	melee_damage_upper = 15
	attacktext = "pinches"
	resistance = 9


/mob/living/simple_animal/familiar/pike
	name = "space pike"
	desc = "A bigger, more magical cousin of the space carp."

	icon = 'icons/mob/spaceshark.dmi'
	icon_state = "shark"
	icon_living = "shark"
	icon_dead = "shark_dead"
	pixel_x = -16

	speak_emote = list("gnashes")

	health = 100
	maxHealth = 100
	melee_damage_lower = 10
	melee_damage_upper = 10

	min_oxy = 0

	wizardy_spells = list(/spell/aoe_turf/conjure/forcewall)

/mob/living/simple_animal/familiar/pike/Process_Spacemove(var/check_drift = 0)
	return 1

/mob/living/simple_animal/familiar/horror
	name = "horror"
	desc = "A sanity-destroying otherthing."
	icon = 'icons/mob/mob.dmi'
	icon_state = "horror"
	icon_living = "horror"

	speak_emote = list("moans", "groans")

	response_help = "thinks better of touching"

	health = 150
	maxHealth = 150
	melee_damage_lower = 5
	melee_damage_upper = 8
	attacktext = "touches"

	wizardy_spells = list(/spell/targeted/torment)

/mob/living/simple_animal/familiar/horror/death()
	..(null,"rapidly deteriorates")

	ghostize()
	gibs(src.loc)
	qdel(src)


/mob/living/simple_animal/familiar/goat
	name = "goat"
	desc = "An elder looking goat."
	icon_state = "goat"
	icon_living = "goat"
	icon_dead = "goat_dead"
	speak_emote = list("brays")

	mob_size = MOB_SMALL

	health = 50
	maxHealth = 50

	wizardy_spells = list(/spell/targeted/heal_target,
						/spell/targeted/heal_target/area)



/mob/living/simple_animal/familiar/pet //basically variants of normal animals with spells.
	icon = 'icons/mob/animal.dmi'
	var/icon_rest //so that we can have resting little guys.

/mob/living/simple_animal/familiar/pet/MouseDrop(atom/over_object)
	var/mob/living/carbon/H = over_object
	if(!istype(H) || !Adjacent(H)) return ..()

	if(H.a_intent == "help" && holder_type)
		get_scooped(H)
		return
	else
		return ..()

/mob/living/simple_animal/familiar/pet/Life()
	..()
	if(!icon_rest)
		return
	if(stat == UNCONSCIOUS || resting)
		icon_state = icon_rest

/mob/living/simple_animal/familiar/pet/mouse
	name = "mouse"
	desc = "A small rodent. It looks very old."
	icon_state = "mouse_gray"
	icon_living = "mouse_gray"
	icon_dead = "mouse_gray_dead"
	icon_rest = "mouse_gray_sleep"

	speak_emote = list("squeeks")
	holder_type = /obj/item/weapon/holder/mouse
	pass_flags = PASSTABLE
	mob_size = MOB_MINISCULE

	response_harm = "stamps on"

	health = 15
	maxHealth = 15
	melee_damage_lower = 1
	melee_damage_upper = 1
	attacktext = "nibbles"

	wizardy_spells = list(/spell/aoe_turf/smoke)

/mob/living/simple_animal/familiar/pet/mouse/New()
	..()

	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

/mob/living/simple_animal/familiar/pet/cat
	name = "black cat"
	desc = "A pitch black cat. Said to be especially unlucky."
	icon_state = "cat3"
	icon_living = "cat3"
	icon_dead = "cat3_dead"
	icon_rest = "cat3_rest"


	speak_emote = list("meows", "purrs")
	holder_type = /obj/item/weapon/holder/cat
	mob_size = MOB_SMALL

	health = 25
	maxHealth = 25
	melee_damage_lower = 3
	melee_damage_upper = 4
	attacktext = "claws"

	wizardy_spells = list(/spell/targeted/subjugation)

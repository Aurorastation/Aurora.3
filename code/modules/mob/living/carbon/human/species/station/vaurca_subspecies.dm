/datum/species/bug/type_b
	name = "Vaurca Warrior"
	short_name = "vaw"
	name_plural = "Type BA"
	language = LANGUAGE_VAURCA
	primitive_form = "Vaurca Worker"
	greater_form = "Vaurca Breeder"
	icobase = 'icons/mob/human_races/subspecies/r_vaurcab.dmi'
	slowdown = 0
	brute_mod = 0.7
	burn_mod = 1.2
	oxy_mod = 1
	radiation_mod = 0.5
	mob_size = 10 //fairly lighter than the worker type.
	taste_sensitivity = TASTE_DULL
	blurb = "Type BA, a sub-type of the generic Type B Warriors, are the second most prominent type of Vaurca society, taking the form of hive security and military grunts. \
	Type BA can range in size from 6ft tall to 9ft tall, and are bipedal. Unlike most other Type B's, Type BA are deprived of advanced augments, especially aboard \
	NanoTrasen stations. Warriors in general, unlike other types of Vaurca, are not typically passive. This means that they tend to be more suitable for combat \
	orientated positions, more passive unlike workers. Compared to workers, they are more physically intimidating and more resistant to heat, but have a thinner carapace \
	allowing for greater mobility at the cost of some trauma resistance. \
	<b>Type BA are most comfortable obviously in security positions, but can rarely be found in the lower hierarchies of other departments.</b>"

	heat_level_1 = 360 //Default 360
	heat_level_2 = 400 //Default 400
	heat_level_3 = 800 //Default 1000

	stamina = 115
	sprint_speed_factor = 1.0
	sprint_cost_factor = 0.40
	stamina_recovery = 3


	inherent_verbs = list(
		/mob/living/carbon/human/proc/bugbite //weaker version of gut.
		)

/datum/species/bug/type_c
	name = "Vaurca Breeder"
	short_name = "vab"
	name_plural = "Type CB"
	bodytype = "Vaurca Breeder"
	primitive_form = "Vaurca Warrior"
	icon_template = 'icons/mob/human_races/subspecies/r_vaurcac.dmi'
	icobase = 'icons/mob/human_races/subspecies/r_vaurcac.dmi'
	deform = 'icons/mob/human_races/subspecies/r_vaurcac.dmi'
	icon_x_offset = -8
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick,  /datum/unarmed_attack/claws/strong, /datum/unarmed_attack/bite/strong)
	rarity_value = 10
	slowdown = 2
	eyes = "blank_eyes" //makes it so that eye colour is not changed when skin colour is.
	brute_mod = 0.2 //note to self: remove is_synthetic checks for brmod and burnmod
	burn_mod = 0.8 //2x was a bit too much. we'll see how this goes.
	toxins_mod = 1 //they're not used to all our weird human bacteria.
	breakcuffs = list(MALE,FEMALE,NEUTER)
	mob_size = 30

	speech_sounds = list('sound/voice/hiss1.ogg','sound/voice/hiss2.ogg','sound/voice/hiss3.ogg','sound/voice/hiss4.ogg')
	speech_chance = 100

	death_sound = 'sound/voice/hiss6.ogg'
	damage_overlays = 'icons/mob/human_races/masks/dam_breeder.dmi'
	damage_mask = 'icons/mob/human_races/masks/dam_mask_breeder.dmi'
	blood_mask = 'icons/mob/human_races/masks/blood_breeder.dmi'

	stamina = 175
	sprint_speed_factor = 1
	sprint_cost_factor = 0.80
	stamina_recovery = 3

	spawn_flags = IS_RESTRICTED
	flags = NO_SCAN | NO_SLIP

	inherent_verbs = list(
		/mob/living/carbon/human/proc/bugbite,
		/mob/living/carbon/human/proc/devour_head,
		/mob/living/carbon/human/proc/hivenet
		)

/datum/species/bug/type_c/equip_survival_gear(var/mob/living/carbon/human/H)
	return

/datum/species/bug/type_c/handle_post_spawn(var/mob/living/carbon/human/H)
	H.gender = FEMALE
	return ..()

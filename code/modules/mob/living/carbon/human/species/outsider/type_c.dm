/datum/species/bug/type_c
	name = "Vaurca Breeder"
	short_name = "vab"
	name_plural = "Type C"
	primitive_form = "Vaurca"
	icon_template = 'icons/mob/human_races/r_vaurcac.dmi'
	icobase = 'icons/mob/human_races/r_vaurcac.dmi'
	deform = 'icons/mob/human_races/r_vaurcac.dmi'
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick,  /datum/unarmed_attack/claws/strong, /datum/unarmed_attack/bite/strong)
	rarity_value = 10
	eyes = "vaurca_eyes" //makes it so that eye colour is not changed when skin colour is.
	brute_mod = 0.2 //note to self: remove is_synthetic checks for brmod and burnmod
	burn_mod = 0.8 //2x was a bit too much. we'll see how this goes.
	tox_mod = 1 //they're not used to all our weird human bacteria.
	warning_low_pressure = 50
	hazard_low_pressure = 0
	ethanol_resistance = 2

	speech_sounds = list('sound/voice/hiss1.ogg','sound/voice/hiss2.ogg','sound/voice/hiss3.ogg','sound/voice/hiss4.ogg')
	speech_chance = 20

	death_sound = 'sound/voice/hiss6.ogg'
	death_message = "seizes up and falls limp, their eyes dead and lifeless..."

	vision_flags = SEE_INVISIBLE_OBSERVER_NOLIGHTING | SEE_SELF

	flags = IS_RESTRICTED | NO_SCAN | HAS_SKIN_COLOR | NO_SLIP

	inherent_verbs = list(
		/mob/living/carbon/human/proc/bugbite, //weaker version of gut.
		)


	has_organ = list(
		"neural socket" =  /obj/item/organ/vaurca/neuralsocket,
		"filtration bit" = /obj/item/organ/vaurca/filtrationbit,
		"lungs" =    /obj/item/organ/lungs,
		"phoron reserve tank" = /obj/item/organ/vaurca/preserve,
		"heart" =    /obj/item/organ/heart,
		"heart" =    /obj/item/organ/heart,
		"liver" =    /obj/item/organ/liver,
		"kidneys" =  /obj/item/organ/kidneys,
		"brain" =    /obj/item/organ/brain,
		"eyes" =     /obj/item/organ/eyes,
)

/datum/species/bug/type_c/equip_survival_gear(var/mob/living/carbon/human/H)
	H.gender = FEMALE

/datum/species/bug/type_c/handle_post_spawn(var/mob/living/carbon/human/H)
	H.gender = FEMALE
	return ..()
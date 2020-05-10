/datum/species/skrell
	name = "Skrell"
	short_name = "skr"
	name_plural = "Skrell"
	bodytype = "Skrell"
	age_max = 500
	economic_modifier = 12
	icobase = 'icons/mob/human_races/skrell/r_skrell.dmi'
	deform = 'icons/mob/human_races/skrell/r_def_skrell.dmi'
	preview_icon = 'icons/mob/human_races/skrell/skrell_preview.dmi'
	eyes = "skrell_eyes_s"
	primitive_form = "Neaera"
	unarmed_types = list(/datum/unarmed_attack/punch, /datum/unarmed_attack/stomp, /datum/unarmed_attack/kick)

	blurb = "An amphibious species, Skrell come from the star system known as Nralakk, coined 'Jargon' by \
	humanity.<br><br>Skrell are a highly advanced, ancient race who place knowledge as the highest ideal. \
	A dedicated meritocracy, the Skrell strive for ever-expanding knowledge of the galaxy and their place \
	in it. However, a cataclysmic AI rebellion by Glorsh and its associated atrocities in the far past has \
	forever scarred the species and left them with a deep rooted suspicion of artificial intelligence. As \
	such an ancient and venerable species, they often hold patronizing attitudes towards the younger races."

	num_alternate_languages = 3
	language = LANGUAGE_SKRELLIAN
	name_language = LANGUAGE_SKRELLIAN
	rarity_value = 3

	grab_mod = 2
	resist_mod = 0.5 // LIKE BABBY

	spawn_flags = CAN_JOIN | IS_WHITELISTED
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_SOCKS
	flags = NO_SLIP

	has_organ = list(
		BP_HEART =    /obj/item/organ/internal/heart/skrell,
		BP_LUNGS =    /obj/item/organ/internal/lungs/skrell,
		BP_LIVER =    /obj/item/organ/internal/liver/skrell,
		BP_KIDNEYS =  /obj/item/organ/internal/kidneys/skrell,
		BP_BRAIN =    /obj/item/organ/internal/brain/skrell,
		BP_STOMACH =  /obj/item/organ/internal/stomach,
		BP_APPENDIX = /obj/item/organ/internal/appendix,
		BP_EYES =     /obj/item/organ/internal/eyes/skrell
		)

	flesh_color = "#8CD7A3"
	blood_color = COLOR_SKRELL_BLOOD
	base_color = "#006666"

	reagent_tag = IS_SKRELL
	ethanol_resistance = 0.5//gets drunk faster
	taste_sensitivity = TASTE_SENSITIVE

	stamina = 90
	sprint_speed_factor = 1.25 //Evolved for rapid escapes from predators

	default_h_style = "Skrell Short Tentacles"

	allowed_citizenships = list(CITIZENSHIP_JARGON, CITIZENSHIP_BIESEL, CITIZENSHIP_SOL, CITIZENSHIP_COALITION, CITIZENSHIP_ELYRA, CITIZENSHIP_ERIDANI, CITIZENSHIP_DOMINIA)
	allowed_religions = list(RELIGION_QEBLAK, RELIGION_WEISHII, RELIGION_NONE, RELIGION_OTHER, RELIGION_CHRISTIANITY, RELIGION_ISLAM, RELIGION_MOROZ)
	default_citizenship = CITIZENSHIP_JARGON

	zombie_type = "Skrell Zombie"

/datum/species/skrell/handle_post_spawn(mob/living/carbon/human/H)
	H.set_psi_rank(PSI_COERCION, PSI_RANK_OPERANT)

/datum/species/skrell/can_breathe_water()
	return TRUE

/datum/species/skrell/can_commune()
	return TRUE

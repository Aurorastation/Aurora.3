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
	blood_color = "#1D2CBF"
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

/datum/species/skrell/handle_environment_special(var/mob/living/carbon/human/H)
	var/old_moisture = H.ST.moisture
	H.ST.moisture = max(0, H.ST.moisture - rand(-0.8, 1.3))			// Reduce moisture a little.
	if(H.fire_stacks && H.ST.moisture > 1800)						// Flaming moist skrell can reduce their flame
		H.fire_stacks--
		H.ST.moisture -= rand(150, 350)								// Lost a lot of moisture
	var/pain_limit = (1800-H.ST.moisture) * (40 / 1800)				// The max halloss damage to do based on current moisture. At 0, this is 30. At 1800 or higher, this is 0.
	
	// Add more pain damage if they need it.
	var setPain = max(H.getHalLoss(), pain_limit)
	H.adjustHalLoss(setPain - H.getHalLoss())
	
	// Skrell hydration is directly tied to their moisture.
	H.hydration = (H.ST.moisture / 3600) * H.max_hydration

	if(H.ST.moisture <= 1800 && old_moisture > 1800)
		H << "<span class='warning'>You are drying out. You should consider moisturizing.</span>"
	else if(H.ST.moisture <= 900 && old_moisture > 900)
		H << "<span class='warning'>You are really dry! Your skin feels uncomfortable and flakey!</span>"
	else if(H.ST.moisture == 0 && old_moisture > 0)
		H << "<span class='danger'>You are completely dry, this is really painful!</span>"

/datum/species/skrell/adjustBurnLoss(var/mob/living/carbon/C, var/amount)
	if(istype(C,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = C
		. = (1 - (H.ST.moisture / 3600))*0.6 + 0.7 // At 0 moisture, this is 1.3 At 3600 moisture, this is 0.7. Average of 1.0
		H.ST.moisture = max(0, H.ST.moisture - amount * 30) // Lose 30 * damage in moisture. 100 damage will almost instantly 0 the wettest of skrell
	else
		return 1

/datum/species/skrell/handle_post_spawn(mob/living/carbon/human/H)
	H.set_psi_rank(PSI_COERCION, PSI_RANK_OPERANT)
	H.ST = new()

/datum/species/skrell/can_breathe_water()
	return TRUE

/datum/species/skrell/can_commune()
	return TRUE

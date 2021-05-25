/datum/species/skrell
	name = SPECIES_SKRELL
	short_name = "skr"
	name_plural = "Skrell"
	category_name = "Skrell"
	bodytype = BODYTYPE_SKRELL
	age_min = 30
	age_max = 500
	default_genders = list(PLURAL)
	economic_modifier = 12
	icobase = 'icons/mob/human_races/skrell/r_skrell.dmi'
	deform = 'icons/mob/human_races/skrell/r_def_skrell.dmi'
	preview_icon = 'icons/mob/human_races/skrell/skrell_preview.dmi'
	bandages_icon = 'icons/mob/bandage.dmi'
	eyes = "skrell_eyes_s"
	primitive_form = SPECIES_MONKEY_SKRELL
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

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/skrell),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
		)

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
	bp_base_systolic = 100 // Default 120
	bp_base_disatolic = 60 // Default 80
	low_pulse = 30 // Default 40
	norm_pulse = 50 // Default 60
	fast_pulse = 70 // Default 90
	v_fast_pulse = 90 // Default 120
	max_pulse = 130 // Default 160
	body_temperature = T0C + 27

	default_h_style = "Skrell Short Tentacles"

	allowed_citizenships = list(CITIZENSHIP_JARGON, CITIZENSHIP_BIESEL, CITIZENSHIP_SOL, CITIZENSHIP_COALITION, CITIZENSHIP_ELYRA, CITIZENSHIP_ERIDANI, CITIZENSHIP_DOMINIA)
	allowed_religions = list(RELIGION_QEBLAK, RELIGION_WEISHII, RELIGION_NONE, RELIGION_OTHER, RELIGION_CHRISTIANITY, RELIGION_ISLAM, RELIGION_MOROZ)
	default_citizenship = CITIZENSHIP_JARGON

	default_accent = ACCENT_SKRELL
	allowed_accents = list(ACCENT_SKRELL, ACCENT_CETI, ACCENT_GIBSON, ACCENT_COC, ACCENT_ERIDANI, ACCENT_ERIDANIDREG, ACCENT_VENUS, ACCENT_JUPITER, ACCENT_MARTIAN, ACCENT_ELYRA,
							ACCENT_SILVERSUN_EXPATRIATE, ACCENT_KONYAN, ACCENT_EUROPA)

	zombie_type = SPECIES_ZOMBIE_SKRELL
	bodyfall_sound = /decl/sound_category/bodyfall_skrell_sound

/datum/species/skrell/handle_post_spawn(mob/living/carbon/human/H)
	..()
	H.set_psi_rank(PSI_COERCION, PSI_RANK_OPERANT)

/datum/species/skrell/handle_strip(var/mob/user, var/mob/living/carbon/human/H, var/action)
	switch(action)
		if("headtail")
			if(!H.organs_by_name[BP_HEAD] || istype(H.organs_by_name[BP_HEAD], /obj/item/organ/external/stump))
				to_chat(user, SPAN_WARNING("\The [H] doesn't have a head!"))
				return
			user.visible_message(SPAN_WARNING("\The [user] is trying to remove something from \the [H]'s headtails!"))
			if(do_after(user, HUMAN_STRIP_DELAY, act_target = H))
				var/obj/item/storage/internal/skrell/S = locate() in H.organs_by_name[BP_HEAD]
				var/obj/item/I = locate() in S
				if(!I)
					to_chat(user, SPAN_WARNING("\The [H] had nothing in their headtail storage."))
					return
				S.remove_from_storage(I, get_turf(H))
				return

/datum/species/skrell/get_strip_info(var/reference)
	return "<BR><A href='?src=[reference];species=headtail'>Empty Headtail Storage</A>"

/datum/species/skrell/can_breathe_water()
	return TRUE

/datum/species/skrell/can_commune()
	return TRUE

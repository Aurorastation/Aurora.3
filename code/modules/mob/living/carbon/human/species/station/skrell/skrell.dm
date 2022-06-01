/datum/species/skrell
	name = SPECIES_SKRELL
	short_name = "skr"
	name_plural = "Skrell"
	category_name = "Skrell"
	bodytype = BODYTYPE_SKRELL
	age_min = 50
	age_max = 500
	default_genders = list(PLURAL)
	economic_modifier = 12
	icobase = 'icons/mob/human_races/skrell/r_skrell.dmi'
	deform = 'icons/mob/human_races/skrell/r_def_skrell.dmi'
	preview_icon = 'icons/mob/human_races/skrell/skrell_preview.dmi'
	bandages_icon = 'icons/mob/bandage.dmi'
	eyes = "skrell_eyes_s"
	primitive_form = SPECIES_MONKEY_SKRELL
	unarmed_types = list(/datum/unarmed_attack/punch, /datum/unarmed_attack/palm, /datum/unarmed_attack/stomp, /datum/unarmed_attack/kick)

	blurb = "Xiialt can be approximately translated to \"coastals\" or \"land-dwellers\". These Skrell are the \
	biological cousins of the Axiori. They tend to be somewhat short, but the stout nature of the Xiialt \
	helped them traverse the rough nature of their biome with bipedal movement. Due to this, their feet are \
	somewhat bigger than those of an Axiori and their leg muscles are more defined. It is theorized that this \
	helped early Xiialt outrun predators on land. Xiialt also tend to be much leaner; this is due to their \
	slightly higher metabolic rate due to the abundant presence of food on the surface. While Xiialt are better \
	adapted to live on land they are still able to breathe and see underwater; however, their swimming is not as agile."

	num_alternate_languages = 3
	language = LANGUAGE_SKRELLIAN
	name_language = LANGUAGE_SKRELLIAN
	rarity_value = 3

	grab_mod = 2
	resist_mod = 0.5 // LIKE BABBY

	spawn_flags = CAN_JOIN | IS_WHITELISTED
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_SOCKS
	flags = NO_SLIP

	possible_external_organs_modifications = list("Normal","Amputated","Prosthesis", "Diona Nymph")

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
		BP_EYES =     /obj/item/organ/internal/eyes/skrell
		)

	pain_messages = list("I can't feel my headtails", "You really need some painkillers", "Stars above, the pain")

	flesh_color = "#8CD7A3"
	blood_color = COLOR_SKRELL_BLOOD
	base_color = "#006666"

	reagent_tag = IS_SKRELL
	ethanol_resistance = 0.5//gets drunk faster
	taste_sensitivity = TASTE_SENSITIVE

	stamina = 80
	sprint_cost_factor = 0.4
	sprint_speed_factor = 0.8
	bp_base_systolic = 100 // Default 120
	bp_base_disatolic = 60 // Default 80
	low_pulse = 30 // Default 40
	norm_pulse = 50 // Default 60
	fast_pulse = 70 // Default 90
	v_fast_pulse = 90 // Default 120
	max_pulse = 130 // Default 160
	body_temperature = T0C + 27

	default_h_style = "Headtails"

	possible_cultures = list(
		/decl/origin_item/culture/federation,
		/decl/origin_item/culture/non_federation
	)
	
	inherent_verbs = list(
		/mob/living/carbon/human/proc/adjust_headtails
	)

	zombie_type = SPECIES_ZOMBIE_SKRELL
	bodyfall_sound = /decl/sound_category/bodyfall_skrell_sound
	footsound = /decl/sound_category/footstep_skrell_sound

	alterable_internal_organs = list(BP_HEART, BP_EYES, BP_LUNGS, BP_LIVER, BP_KIDNEYS, BP_STOMACH)

/datum/species/skrell/handle_trail(var/mob/living/carbon/human/H, var/turf/T)
	var/list/trail_info = ..()
	if(!length(trail_info) && !H.shoes)
		var/list/blood_data = REAGENT_DATA(H.vessel, /decl/reagent/blood)
		trail_info["footprint_DNA"] = list(blood_data["blood_DNA"] = blood_data["blood_type"])
		trail_info["footprint_color"] = rgb(H.r_skin, H.g_skin, H.b_skin, 25)
		trail_info["footprint_type"] = /obj/effect/decal/cleanable/blood/tracks/footprints/barefoot/del_dry // makes skrellprints del on dry

	return trail_info

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

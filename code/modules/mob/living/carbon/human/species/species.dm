/*
	Datum-based species. Should make for much cleaner and easier to maintain race code.
*/

/datum/species

	// Descriptors and strings.
	var/name                                             // Species name.
	var/name_plural                                      // Pluralized name (since "[name]s" is not always valid)
	var/blurb = "A completely nondescript species."      // A brief lore summary for use in the chargen screen.

	// Icon/appearance vars.
	var/icobase = 'icons/mob/human_races/r_human.dmi'    // Normal icon set.
	var/deform = 'icons/mob/human_races/r_def_human.dmi' // Mutated icon set.

	// Damage overlay and masks.
	var/damage_overlays = 'icons/mob/human_races/masks/dam_human.dmi'
	var/damage_mask = 'icons/mob/human_races/masks/dam_mask_human.dmi'
	var/blood_mask = 'icons/mob/human_races/masks/blood_human.dmi'

	var/prone_icon                                       // If set, draws this from icobase when mob is prone.
	var/eyes = "eyes_s"                                  // Icon for eyes.
	var/blood_color = "#A10808"                          // Red.
	var/flesh_color = "#FFC896"                          // Pink.
	var/base_color                                       // Used by changelings. Should also be used for icon previes..
	var/tail                                             // Name of tail state in species effects icon file.
	var/tail_animation                                   // If set, the icon to obtain tail animation states from.
	var/race_key = 0       	                             // Used for mob icon cache string.
	var/icon/icon_template                               // Used for mob icon generation for non-32x32 species.
	var/is_small
	var/show_ssd = "fast asleep"

	// Language/culture vars.
	var/default_language = "Galactic Common" // Default language is used when 'say' is used without modifiers.
	var/language = "Galactic Common"         // Default racial language, if any.
	var/secondary_langs = list()             // The names of secondary languages that are available to this species.
	var/list/speech_sounds                   // A list of sounds to potentially play when speaking.
	var/list/speech_chance                   // The likelihood of a speech sound playing.

	// Combat vars.
	var/total_health = 100                   // Point at which the mob will enter crit.
	var/list/unarmed_types = list(           // Possible unarmed attacks that the mob will use in combat.
		/datum/unarmed_attack,
		/datum/unarmed_attack/bite
		)
	var/list/unarmed_attacks = null          // For empty hand harm-intent attack
	var/brute_mod = 1                        // Physical damage multiplier.
	var/burn_mod = 1                         // Burn damage multiplier.
	var/vision_flags = SEE_SELF              // Same flags as glasses.

	// Death vars.
	var/meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/human
	var/gibber_type = /obj/effect/gibspawner/human
	var/single_gib_type = /obj/effect/decal/cleanable/blood/gibs
	var/remains_type = /obj/effect/decal/remains/xeno
	var/gibbed_anim = "gibbed-h"
	var/dusted_anim = "dust-h"
	var/death_sound
	var/death_message = "seizes up and falls limp, their eyes dead and lifeless..."

	// Environment tolerance/life processes vars.
	var/reagent_tag                                   //Used for metabolizing reagents.
	var/breath_type = "oxygen"                        // Non-oxygen gas breathed, if any.
	var/poison_type = "phoron"                        // Poisonous air.
	var/exhale_type = "carbon_dioxide"                // Exhaled gas type.
	var/cold_level_1 = 260                            // Cold damage level 1 below this point.
	var/cold_level_2 = 200                            // Cold damage level 2 below this point.
	var/cold_level_3 = 120                            // Cold damage level 3 below this point.
	var/heat_level_1 = 360                            // Heat damage level 1 above this point.
	var/heat_level_2 = 400                            // Heat damage level 2 above this point.
	var/heat_level_3 = 1000                           // Heat damage level 3 above this point.
	var/synth_temp_gain = 0			                  // IS_SYNTHETIC species will gain this much temperature every second
	var/hazard_high_pressure = HAZARD_HIGH_PRESSURE   // Dangerously high pressure.
	var/warning_high_pressure = WARNING_HIGH_PRESSURE // High pressure warning.
	var/warning_low_pressure = WARNING_LOW_PRESSURE   // Low pressure warning.
	var/hazard_low_pressure = HAZARD_LOW_PRESSURE     // Dangerously low pressure.
	var/light_dam                                     // If set, mob will be damaged in light over this value and heal in light below its negative.
	var/body_temperature = 310.15	                  // Non-IS_SYNTHETIC species will try to stabilize at this temperature.
	                                                  // (also affects temperature processing)

	var/heat_discomfort_level = 315                   // Aesthetic messages about feeling warm.
	var/cold_discomfort_level = 285                   // Aesthetic messages about feeling chilly.
	var/list/heat_discomfort_strings = list(
		"You feel sweat drip down your neck.",
		"You feel uncomfortably warm.",
		"Your skin prickles in the heat."
		)
	var/list/cold_discomfort_strings = list(
		"You feel chilly.",
		"You shiver suddely.",
		"Your chilly flesh stands out in goosebumps."
		)

	// HUD data vars.
	var/datum/hud_data/hud
	var/hud_type

	// Body/form vars.
	var/list/inherent_verbs 	  // Species-specific verbs.
	var/has_fine_manipulation = 1 // Can use small items.
	var/siemens_coefficient = 1   // The lower, the thicker the skin and better the insulation.
	var/darksight = 2             // Native darksight distance.
	var/flags = 0                 // Various specific features.
	var/slowdown = 0              // Passive movement speed malus (or boost, if negative)
	var/primitive_form            // Lesser form, if any (ie. monkey for humans)
	var/greater_form              // Greater form, if any, ie. human for monkeys.
	var/holder_type
	var/gluttonous                // Can eat some mobs. 1 for mice, 2 for monkeys, 3 for people.
	var/rarity_value = 1          // Relative rarity/collector value for this species.
	                              // Determines the organs that the species spawns with and
	var/list/has_organ = list(    // which required-organ checks are conducted.
		"heart" =    /obj/item/organ/heart,
		"lungs" =    /obj/item/organ/lungs,
		"liver" =    /obj/item/organ/liver,
		"kidneys" =  /obj/item/organ/kidneys,
		"brain" =    /obj/item/organ/brain,
		"appendix" = /obj/item/organ/appendix,
		"eyes" =     /obj/item/organ/eyes
		)

	var/list/has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest),
		"groin" =  list("path" = /obj/item/organ/external/groin),
		"head" =   list("path" = /obj/item/organ/external/head),
		"l_arm" =  list("path" = /obj/item/organ/external/arm),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right),
		"l_leg" =  list("path" = /obj/item/organ/external/leg),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right),
		"l_hand" = list("path" = /obj/item/organ/external/hand),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right),
		"l_foot" = list("path" = /obj/item/organ/external/foot),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right)
		)

	// Bump vars
	var/bump_flag = HUMAN	// What are we considered to be when bumped?
	var/push_flags = ~HEAVY	// What can we push?
	var/swap_flags = ~HEAVY	// What can we swap place with?

/datum/species/New()
	if(hud_type)
		hud = new hud_type()
	else
		hud = new()

	unarmed_attacks = list()
	for(var/u_type in unarmed_types)
		unarmed_attacks += new u_type()

/datum/species/proc/get_station_variant()
	return name

/datum/species/proc/get_bodytype()
	return name

/datum/species/proc/get_environment_discomfort(var/mob/living/carbon/human/H, var/msg_type)

	if(!prob(5))
		return

	var/covered = 0 // Basic coverage can help.
	for(var/obj/item/clothing/clothes in H)
		if(H.l_hand == clothes|| H.r_hand == clothes)
			continue
		if((clothes.body_parts_covered & UPPER_TORSO) && (clothes.body_parts_covered & LOWER_TORSO))
			covered = 1
			break

	switch(msg_type)
		if("cold")
			if(!covered)
				H << "<span class='danger'>[pick(cold_discomfort_strings)]</span>"
		if("heat")
			if(covered)
				H << "<span class='danger'>[pick(heat_discomfort_strings)]</span>"

/datum/species/proc/get_random_name(var/gender)
	var/datum/language/species_language = all_languages[language]
	if(!species_language)
		species_language = all_languages[default_language]
	if(!species_language)
		return "unknown"
	return species_language.get_random_name(gender)

/datum/species/proc/equip_survival_gear(var/mob/living/carbon/human/H,var/extendedtank = 1)
	if(H.backbag == 1)
		if (extendedtank)	H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(H), slot_r_hand)
		else	H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
	else
		if (extendedtank)	H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(H.back), slot_in_backpack)
		else	H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)

/datum/species/proc/create_organs(var/mob/living/carbon/human/H) //Handles creation of mob organs.

	for(var/obj/item/organ/organ in H.contents)
		if((organ in H.organs) || (organ in H.internal_organs))
			qdel(organ)

	if(H.organs)                  H.organs.Cut()
	if(H.internal_organs)         H.internal_organs.Cut()
	if(H.organs_by_name)          H.organs_by_name.Cut()
	if(H.internal_organs_by_name) H.internal_organs_by_name.Cut()

	H.organs = list()
	H.internal_organs = list()
	H.organs_by_name = list()
	H.internal_organs_by_name = list()

	for(var/limb_type in has_limbs)
		var/list/organ_data = has_limbs[limb_type]
		var/limb_path = organ_data["path"]
		var/obj/item/organ/O = new limb_path(H)
		organ_data["descriptor"] = O.name

	for(var/organ in has_organ)
		var/organ_type = has_organ[organ]
		H.internal_organs_by_name[organ] = new organ_type(H,1)

	for(var/name in H.organs_by_name)
		H.organs |= H.organs_by_name[name]

	for(var/obj/item/organ/external/O in H.organs)
		O.owner = H

	if(flags & IS_SYNTHETIC)
		for(var/obj/item/organ/external/E in H.organs)
			if(E.status & ORGAN_CUT_AWAY || E.status & ORGAN_DESTROYED) continue
			E.robotize()
		for(var/obj/item/organ/I in H.internal_organs)
			I.robotize()

/datum/species/proc/hug(var/mob/living/carbon/human/H,var/mob/living/target)

	var/t_him = "them"
	switch(target.gender)
		if(MALE)
			t_him = "him"
		if(FEMALE)
			t_him = "her"

	H.visible_message("<span class='notice'>[H] hugs [target] to make [t_him] feel better!</span>", \
					"<span class='notice'>You hug [target] to make [t_him] feel better!</span>")

/datum/species/proc/remove_inherent_verbs(var/mob/living/carbon/human/H)
	if(inherent_verbs)
		for(var/verb_path in inherent_verbs)
			H.verbs -= verb_path
	return

/datum/species/proc/add_inherent_verbs(var/mob/living/carbon/human/H)
	if(inherent_verbs)
		for(var/verb_path in inherent_verbs)
			H.verbs |= verb_path
	return

/datum/species/proc/handle_post_spawn(var/mob/living/carbon/human/H) //Handles anything not already covered by basic species assignment.
	add_inherent_verbs(H)

/datum/species/proc/handle_death(var/mob/living/carbon/human/H) //Handles any species-specific death events (such as dionaea nymph spawns).
	return

// Only used for alien plasma weeds atm, but could be used for Dionaea later.
/datum/species/proc/handle_environment_special(var/mob/living/carbon/human/H)
	return

// Used to update alien icons for aliens.
/datum/species/proc/handle_login_special(var/mob/living/carbon/human/H)
	return

// As above.
/datum/species/proc/handle_logout_special(var/mob/living/carbon/human/H)
	return

// Builds the HUD using species-specific icons and usable slots.
/datum/species/proc/build_hud(var/mob/living/carbon/human/H)
	return

//Used by xenos understanding larvae and dionaea understanding nymphs.
/datum/species/proc/can_understand(var/mob/other)
	return


/datum/species/proc/blend_preview_icon(var/icon/main_icon,var/datum/preferences/preferences,var/paint_colour)
	if(paint_colour)
		main_icon.Blend(paint_colour, ICON_ADD)
		return
	if(flags & HAS_SKIN_COLOR)
		main_icon.Blend(rgb(preferences.r_skin, preferences.g_skin, preferences.b_skin), ICON_ADD)
		return
	if(flags & HAS_SKIN_TONE) // Skin tone
		if (preferences.s_tone >= 0)
			main_icon.Blend(rgb(preferences.s_tone, preferences.s_tone, preferences.s_tone), ICON_ADD)
		else
			main_icon.Blend(rgb(-preferences.s_tone, -preferences.s_tone, -preferences.s_tone), ICON_SUBTRACT)


/datum/species/proc/get_organ_preview_icon(var/name, var/robot, var/gendered, var/gender_string, var/datum/preferences/preferences, var/datum/synthetic_limb_cover/covering, var/paint_colour)
	var/icon_name = icobase
	if (robot)
		if(istype(covering))
			icon_name = covering.main_icon
		else
			icon_name = 'icons/mob/human_races/robotic.dmi'
			paint_colour = null // no paint for bare robots
	var/state_name = name
	if (gendered)
		state_name+="_[gender_string]"
	var/icon/result = new /icon(icon_name,state_name)
	blend_preview_icon(result,preferences,paint_colour)
	return result


/datum/species/proc/get_is_preview_organ_robotic(var/name,var/datum/preferences/preferences)
	if (flags & IS_SYNTHETIC)
		return TRUE
	if (name in preferences.organ_data)
		var/list/organ_robotic_info=preferences.organ_data[name]
		if (istype(organ_robotic_info))
			return TRUE


/datum/species/proc/get_preview_organ_covering(var/name,var/datum/preferences/preferences)
	if (name in preferences.organ_data)
		var/list/organ_robotic_info=preferences.organ_data[name]
		if (istype(organ_robotic_info))
			return organ_robotic_info
	if (preferences.species=="Machine")
		if (preferences.covering_type)
			return list(preferences.covering_type,rgb(preferences.r_skin,preferences.g_skin,preferences.b_skin))


/datum/species/proc/get_tail_preview_icon(var/list/preview_coverings,var/datum/preferences/preferences)
	var/tail_state=null
	if (!(isnull(preview_coverings["groin"])))
		var/datum/synthetic_limb_cover/covering=preview_coverings["groin"]
		if(covering.tail)
			tail_state="[covering.tail]_s"
	if(tail)
		tail_state="[tail]_s"
	if(tail_state)
		var/icon/result = new/icon("icon" = 'icons/effects/species.dmi', "icon_state" = tail_state)
		result.Blend(rgb(preferences.r_hair,preferences.g_hair,preferences.b_hair),ICON_ADD)
		return result


/datum/species/proc/get_eyes_preview_icon(var/list/preview_coverings,var/datum/preferences/preferences)
	var/eye_state=null
	if (!(isnull(preview_coverings["head"])))
		var/datum/synthetic_limb_cover/covering=preview_coverings["head"]
		eye_state=covering.eyes_state
	else
		eye_state=eyes
	var/icon/result = new/icon('icons/mob/human_face.dmi',eye_state)
	result.Blend(rgb(preferences.r_eyes,preferences.g_eyes,preferences.b_eyes),ICON_ADD)
	return result

/* This function takes a preferences object and generates a complete body and hair icon for that set of preferences. It's needlessly complicated
and duplicates a lot of what's going on in update_icons. The two systems should be combined somehow, possibly by using a 'visual identity' object
that could be created from either a living human or a preferences object and then passing that to a single render function, but I'll leave that
exercise for another day.

See code\modules\mob\new_player\preferences_setup.dm for where it's used.
																							- jack_fractal*/
/datum/species/proc/create_body_preview_icon(var/datum/preferences/preferences)
	var/gender_string = (preferences.gender==FEMALE) ? "f" : "m"
	var/icon/preview_icon = new/icon('icons/mob/human_face.dmi', "blank_eyes") // this is just an empty icon
	var/list/external_organs = list("torso","groin","head","r_arm","r_hand","r_leg","r_foot","l_leg","l_foot","l_arm","l_hand")
	var/list/coverings=list()
	var/list/gendered_organs = list("torso","groin","head")
	var/list/limb_coverings = get_limb_covering_references()
	var/list/limb_coverings_names = get_limb_covering_list()
	for (var/name in external_organs)
		if(preferences.organ_data[name] == "amputated") // amputated organs don't show up
			continue
		var/robotic = get_is_preview_organ_robotic(name,preferences)
		var/datum/synthetic_limb_cover/covering = null
		var/paint_colour=null
		if (robotic)
			var/list/covering_as_list=get_preview_organ_covering(name, preferences)
			if (istype(covering_as_list))
				covering=limb_coverings[limb_coverings_names[covering_as_list[1]]]
				paint_colour=covering_as_list[2]
		coverings[name]=covering
		var/icon/organ_icon = get_organ_preview_icon(name, robotic, (name in gendered_organs), gender_string, preferences, covering, paint_colour)
		preview_icon.Blend(organ_icon, ICON_OVERLAY)
		del(organ_icon)
	var/icon/tail_icon = get_tail_preview_icon(coverings,preferences) // Tail
	if(tail_icon)
		preview_icon.Blend(tail_icon, ICON_OVERLAY)
		del(tail_icon)
	var/icon/eye_icon = get_eyes_preview_icon(coverings,preferences)
	if(eye_icon)
		preview_icon.Blend(eye_icon, ICON_OVERLAY)
		del(eye_icon)
	var/datum/sprite_accessory/hair_style = hair_styles_list[preferences.h_style]
	if(hair_style)
		var/icon/hair_s = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
		hair_s.Blend(rgb(preferences.r_hair, preferences.g_hair, preferences.b_hair), ICON_ADD)
		preview_icon.Blend(hair_s, ICON_OVERLAY)
		del(hair_s)
	var/datum/sprite_accessory/facial_hair_style = facial_hair_styles_list[preferences.f_style]
	if(facial_hair_style)
		var/icon/facial_s = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
		facial_s.Blend(rgb(preferences.r_facial, preferences.g_facial, preferences.b_facial), ICON_ADD)
		preview_icon.Blend(facial_s, ICON_OVERLAY)
		del(facial_s)
	return preview_icon

// Called when using the shredding behavior.
/datum/species/proc/can_shred(var/mob/living/carbon/human/H, var/ignore_intent)

	if(!ignore_intent && H.a_intent != I_HURT)
		return 0

	for(var/datum/unarmed_attack/attack in unarmed_attacks)
		if(!attack.is_usable(H))
			continue
		if(attack.shredding)
			return 1

	return 0

// Called in life() when the mob has no client.
/datum/species/proc/handle_npc(var/mob/living/carbon/human/H)
	return

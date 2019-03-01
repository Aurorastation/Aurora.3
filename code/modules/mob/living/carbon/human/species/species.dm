/*
	Datum-based species. Should make for much cleaner and easier to maintain race code.
*/

/datum/species

	// Descriptors and strings.
	var/name                                             // Species name.
	var/name_plural                                      // Pluralized name (since "[name]s" is not always valid)
	var/hide_name = FALSE                                // If TRUE, the species' name won't be visible on examine.
	var/short_name                                       // Shortened form of the name, for code use. Must be exactly 3 letter long, and all lowercase
	var/blurb = "A completely nondescript species."      // A brief lore summary for use in the chargen screen.
	var/bodytype
	var/age_min = 17
	var/age_max = 85
	var/economic_modifier = 0

	// Icon/appearance vars.
	var/icobase = 'icons/mob/human_races/r_human.dmi'    // Normal icon set.
	var/deform = 'icons/mob/human_races/r_def_human.dmi' // Mutated icon set.

	// Damage overlay and masks.
	var/damage_overlays = 'icons/mob/human_races/masks/dam_human.dmi'
	var/damage_mask = 'icons/mob/human_races/masks/dam_mask_human.dmi'
	var/blood_mask = 'icons/mob/human_races/masks/blood_human.dmi'

	var/prone_icon                                       // If set, draws this from icobase when mob is prone.
	var/icon_x_offset = 0
	var/icon_y_offset = 0
	var/eyes = "eyes_s"                                  // Icon for eyes.
	var/eyes_icons = 'icons/mob/human_face/eyes.dmi'     // DMI file for eyes, mostly for none 32x32 species.
	var/has_floating_eyes                                // Eyes will overlay over darkness (glow)
	var/eyes_icon_blend = ICON_ADD                       // The icon blending mode to use for eyes.
	var/blood_color = "#A10808"                          // Red.
	var/flesh_color = "#FFC896"                          // Pink.
	var/examine_color                                    // The color of the species' name in the examine text. Defaults to flesh_color if unset.
	var/base_color                                       // Used by changelings. Should also be used for icon previes..
	var/tail                                             // Name of tail state in species effects icon file.
	var/tail_animation                                   // If set, the icon to obtain tail animation states from.
	var/tail_hair
	var/race_key = 0       	                             // Used for mob icon cache string.
	var/icon/icon_template                               // Used for mob icon generation for non-32x32 species.
	var/mob_size	= MOB_MEDIUM
	var/show_ssd = "fast asleep"
	var/virus_immune
	var/short_sighted
	var/bald = 0
	var/light_range
	var/light_power

	// Language/culture vars.
	var/default_language = "Ceti Basic"		 // Default language is used when 'say' is used without modifiers.
	var/language = "Ceti Basic"        		 // Default racial language, if any.
	var/list/secondary_langs = list()        // The names of secondary languages that are available to this species.
	var/list/speech_sounds                   // A list of sounds to potentially play when speaking.
	var/list/speech_chance                   // The likelihood of a speech sound playing.
	var/num_alternate_languages = 0          // How many secondary languages are available to select at character creation
	var/name_language = "Ceti Basic"	    // The language to use when determining names for this species, or null to use the first name/last name generator

	// Combat vars.
	var/total_health = 100                   // Point at which the mob will enter crit.
	var/list/unarmed_types = list(           // Possible unarmed attacks that the mob will use in combat,
		/datum/unarmed_attack,
		/datum/unarmed_attack/bite
		)
	var/list/unarmed_attacks = null          // For empty hand harm-intent attack
	var/brute_mod =     1                    // Physical damage multiplier.
	var/burn_mod =      1                    // Burn damage multiplier.
	var/oxy_mod =       1                    // Oxyloss modifier
	var/toxins_mod =    1                    // Toxloss modifier
	var/radiation_mod = 1                    // Radiation modifier
	var/flash_mod =     1                    // Stun from blindness modifier.
	var/fall_mod =      1                    // Fall damage modifier, further modified by brute damage modifier
	var/metabolism_mod = 1					 // Reagent metabolism modifier
	var/vision_flags = DEFAULT_SIGHT         // Same flags as glasses.
	var/inherent_eye_protection              // If set, this species has this level of inherent eye protection.
	var/eyes_are_impermeable = FALSE         // If TRUE, this species' eyes are not damaged by phoron.
	var/list/breakcuffs = list()             //used in resist.dm to check if they can break hand/leg cuffs
	var/natural_climbing = FALSE             //If true, the species always succeeds at climbing.
	var/climb_coeff = 1.25                   //The coefficient to the climbing speed of the individual = 60 SECONDS * climb_coeff
	// Death vars.
	var/meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/human
	var/gibber_type = /obj/effect/gibspawner/human
	var/single_gib_type = /obj/effect/decal/cleanable/blood/gibs
	var/remains_type = /obj/effect/decal/remains/xeno
	var/gibbed_anim = "gibbed-h"
	var/dusted_anim = "dust-h"
	var/death_sound
	var/death_message = "seizes up and falls limp, their eyes dead and lifeless..."
	var/knockout_message = "has been knocked unconscious!"
	var/halloss_message = "slumps to the ground, too weak to continue fighting."
	var/halloss_message_self = "You're in too much pain to keep going..."

	// Environment tolerance/life processes vars.
	var/reagent_tag                                   //Used for metabolizing reagents.
	var/breath_pressure = 16                          // Minimum partial pressure safe for breathing, kPa
	var/breath_type = "oxygen"                        // Non-oxygen gas breathed, if any.
	var/poison_type = "phoron"                        // Poisonous air.
	var/exhale_type = "carbon_dioxide"                // Exhaled gas type.
	var/cold_level_1 = 260                            // Cold damage level 1 below this point.
	var/cold_level_2 = 200                            // Cold damage level 2 below this point.
	var/cold_level_3 = 120                            // Cold damage level 3 below this point.
	var/heat_level_1 = 360                            // Heat damage level 1 above this point.
	var/heat_level_2 = 400                            // Heat damage level 2 above this point.
	var/heat_level_3 = 1000                           // Heat damage level 3 above this point.
	var/passive_temp_gain = 0		                  // Species will gain this much temperature every second
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
		"You shiver suddenly.",
		"Your chilly flesh stands out in goosebumps."
		)

	// HUD data vars.
	var/datum/hud_data/hud
	var/hud_type

	// Body/form vars.
	var/list/inherent_verbs 	  // Species-specific verbs.
	var/list/inherent_spells 	  // Species-specific spells.
	var/has_fine_manipulation = 1 // Can use small items.
	var/siemens_coefficient = 1   // The lower, the thicker the skin and better the insulation.
	var/darksight = 2             // Native darksight distance.
	var/flags = 0                 // Various specific features.
	var/appearance_flags = 0      // Appearance/display related features.
	var/spawn_flags = 0           // Flags that specify who can spawn as this species
	var/slowdown = 0              // Passive movement speed malus (or boost, if negative)
	var/primitive_form            // Lesser form, if any (ie. monkey for humans)
	var/greater_form              // Greater form, if any, ie. human for monkeys.
	var/holder_type
	var/rarity_value = 1          // Relative rarity/collector value for this species.
	var/ethanol_resistance = 1	  // How well the mob resists alcohol, lower values get drunk faster, higher values need to drink more
	var/taste_sensitivity = TASTE_NORMAL // How sensitive the species is to minute tastes. Higher values means less sensitive. Lower values means more sensitive.

	var/stamina	=	100			  	// The maximum stamina this species has. Determines how long it can sprint
	var/stamina_recovery = 3	  	// Flat amount of stamina species recovers per proc
	var/sprint_speed_factor = 0.7	// The percentage of bonus speed you get when sprinting. 0.4 = 40%
	var/sprint_cost_factor = 0.9  	// Multiplier on stamina cost for sprinting
	var/exhaust_threshold = 50	  	// When stamina runs out, the mob takes oxyloss up til this value. Then collapses and drops to walk

	var/gluttonous                // Can eat some mobs. Boolean.
	var/mouth_size                // How big the mob's mouth is. Limits how large a mob this species can swallow. Only relevant if gluttonous is TRUE.
	var/allowed_eat_types = TYPE_ORGANIC
	var/max_nutrition_factor = 1	//Multiplier on maximum nutrition
	var/nutrition_loss_factor = 1	//Multiplier on passive nutrition losses

	var/max_hydration_factor = 1	//Multiplier on maximum thirst
	var/hydration_loss_factor = 1	//Multiplier on passive thirst losses

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
	var/vision_organ              // If set, this organ is required for vision. Defaults to "eyes" if the species has them.
	var/breathing_organ           // If set, this organ is required to breathe. Defaults to "lungs" if the species has them.

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

	var/pass_flags = 0

	var/obj/effect/decal/cleanable/blood/tracks/move_trail = /obj/effect/decal/cleanable/blood/tracks/footprints // What marks are left when walking

	var/default_h_style = "Bald"
	var/default_f_style = "Shaved"

/datum/species/proc/get_eyes(var/mob/living/carbon/human/H)
	return

/datum/species/New()
	if(hud_type)
		hud = new hud_type()
	else
		hud = new()

	//If the species has eyes, they are the default vision organ
	if(!vision_organ && has_organ["eyes"])
		vision_organ = "eyes"

	// Same, but for lungs.
	if (!breathing_organ && has_organ["lungs"])
		breathing_organ = "lungs"

	unarmed_attacks = list()
	for(var/u_type in unarmed_types)
		unarmed_attacks += new u_type()

/datum/species/proc/get_station_variant()
	return name

/datum/species/proc/get_bodytype()
	if(!bodytype)
		bodytype = name
	return bodytype

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

/datum/species/proc/sanitize_name(var/name)
	return sanitizeName(name)

/datum/species/proc/get_random_name(var/gender)
	if(!name_language)
		if(gender == FEMALE)
			return capitalize(pick(first_names_female)) + " " + capitalize(pick(last_names))
		else
			return capitalize(pick(first_names_male)) + " " + capitalize(pick(last_names))

	var/datum/language/species_language = all_languages[name_language]
	if(!species_language)
		species_language = all_languages[default_language]
	if(!species_language)
		return "unknown"
	return species_language.get_random_name(gender)

/datum/species/proc/before_equip(mob/living/carbon/human/H, visualsOnly = FALSE, datum/job/J)
	return
 
/datum/species/proc/after_equip(mob/living/carbon/human/H, visualsOnly = FALSE, datum/job/J)
	return

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

	for(var/organ_tag in has_organ)
		var/organ_type = has_organ[organ_tag]
		var/obj/item/organ/O = new organ_type(H,1)
		if(organ_tag != O.organ_tag)
			warning("[O.type] has a default organ tag \"[O.organ_tag]\" that differs from the species' organ tag \"[organ_tag]\". Updating organ_tag to match.")
			O.organ_tag = organ_tag
		H.internal_organs_by_name[organ_tag] = O

	if(H.isSynthetic())
		for(var/obj/item/organ/external/E in H.organs)
			if(E.status & ORGAN_CUT_AWAY || E.is_stump()) continue
			E.robotize()
		for(var/obj/item/organ/I in H.internal_organs)
			I.robotize()

	if(isvaurca(H))
		for (var/obj/item/organ/external/E in H.organs)
			if ((E.status & ORGAN_CUT_AWAY) || (E.status & ORGAN_DESTROYED))
				continue
			E.status |= ORGAN_ADV_ROBOT
		for(var/obj/item/organ/I in H.internal_organs)
			I.status |= ORGAN_ADV_ROBOT

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

	if(inherent_spells)
		for(var/spell_path in inherent_spells)
			H.remove_spell(spell_path)
	return

/datum/species/proc/add_inherent_verbs(var/mob/living/carbon/human/H)
	if(inherent_verbs)
		for(var/verb_path in inherent_verbs)
			H.verbs |= verb_path

	if(inherent_spells)
		for(var/spell_path in inherent_spells)
			H.add_spell(new spell_path, "const_spell_ready")

	return

/datum/species/proc/handle_post_spawn(var/mob/living/carbon/human/H,var/kpg = 0) //Handles anything not already covered by basic species assignment. Keepgene value should only be used by genetics.
	add_inherent_verbs(H)
	H.mob_bump_flag = bump_flag
	H.mob_swap_flags = swap_flags
	H.mob_push_flags = push_flags
	H.pass_flags = pass_flags
	H.mob_size = mob_size
	H.mouth_size = mouth_size || 2
	H.eat_types = allowed_eat_types
	if(!kpg)
		if(islesserform(H))
			H.dna.SetSEState(MONKEYBLOCK,1)
		else
			H.dna.SetSEState(MONKEYBLOCK,0)

/datum/species/proc/handle_death(var/mob/living/carbon/human/H, var/gibbed = 0) //Handles any species-specific death events (such as dionaea nymph spawns).
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

/datum/species/proc/get_vision_flags(var/mob/living/carbon/human/H)
	return vision_flags

/datum/species/proc/handle_vision(var/mob/living/carbon/human/H)
	H.update_sight()
	H.sight |= get_vision_flags(H)
	H.sight |= H.equipment_vision_flags

	if(H.stat == DEAD)
		return 1

	if(!H.druggy)
		H.see_in_dark = (H.sight == (SEE_TURFS|SEE_MOBS|SEE_OBJS)) ? 8 : min(darksight + H.equipment_darkness_modifier, 8)
		if(H.seer)
			var/obj/effect/rune/R = locate() in H.loc
			if(R && R.word1 == cultwords["see"] && R.word2 == cultwords["hell"] && R.word3 == cultwords["join"])
				H.see_invisible = SEE_INVISIBLE_CULT
		if(H.see_invisible != SEE_INVISIBLE_CULT && H.equipment_see_invis)
			H.see_invisible = min(H.see_invisible, H.equipment_see_invis)

	if(H.equipment_tint_total >= TINT_BLIND)
		H.eye_blind = max(H.eye_blind, 1)

	if(H.blind)
		H.blind.invisibility = (H.eye_blind ? 0 : 101)

	if(!H.client)//no client, no screen to update
		return 1

	if(config.welder_vision)
		if(short_sighted || (H.equipment_tint_total >= TINT_HEAVY))
			H.client.screen += global_hud.darkMask
		else if((!H.equipment_prescription && (H.disabilities & NEARSIGHTED)) || H.equipment_tint_total == TINT_MODERATE)
			H.client.screen += global_hud.vimpaired
	if(H.eye_blurry)	H.client.screen += global_hud.blurry
	if(H.druggy)		H.client.screen += global_hud.druggy

	for(var/overlay in H.equipment_overlays)
		H.client.screen |= overlay

	return 1

/datum/species/proc/handle_sprint_cost(var/mob/living/carbon/human/H, var/cost)
	if (!H.exhaust_threshold)
		return 1 // Handled.

	cost *= H.sprint_cost_factor
	if (H.stamina == -1)
		log_debug("Error: Species with special sprint mechanics has not overridden cost function.")
		return 0

	var/remainder = 0
	if (H.stamina > cost)
		H.stamina -= cost
		H.hud_used.move_intent.update_move_icon(H)
		return 1
	else if (H.stamina > 0)
		remainder = cost - H.stamina
		H.stamina = 0
	else
		remainder = cost

	if(H.disabilities & ASTHMA)
		H.adjustOxyLoss(remainder*0.15)

	if(H.disabilities & COUGHING)
		H.adjustHalLoss(remainder*0.1)

	if (breathing_organ && has_organ[breathing_organ])
		var/obj/item/organ/O = H.internal_organs_by_name[breathing_organ]
		if(O.is_bruised())
			H.adjustOxyLoss(remainder*0.15)
			H.adjustHalLoss(remainder*0.25)

	H.adjustHalLoss(remainder*0.25)
	H.updatehealth()
	if((H.halloss >= 10) && prob(H.halloss*2))
		H.flash_pain()

	if ((H.halloss + H.oxyloss) >= (exhaust_threshold * 0.8))
		H.m_intent = "walk"
		H.hud_used.move_intent.update_move_icon(H)
		H << span("danger", "You're too exhausted to run anymore!")
		H.flash_pain()
		return 0

	H.hud_used.move_intent.update_move_icon(H)
	return 1

/datum/species/proc/get_light_color(mob/living/carbon/human/H)
	return

/datum/species/proc/can_breathe_water()
	return FALSE

/datum/species/proc/get_move_trail(var/mob/living/carbon/human/H)
	if( H.shoes || ( H.wear_suit && (H.wear_suit.body_parts_covered & FEET) ) )
		return /obj/effect/decal/cleanable/blood/tracks/footprints
	else
		return move_trail

/datum/species/proc/bullet_act(var/obj/item/projectile/P, var/def_zone, var/mob/living/carbon/human/H)
	return 0

/datum/species/proc/handle_speech_problems(mob/living/carbon/human/H, list/current_flags, message, message_verb, message_mode)
	return current_flags

/datum/species/proc/handle_speech_sound(mob/living/carbon/human/H, list/current_flags)
	if(speech_sounds && prob(speech_chance))
		current_flags[1] = sound(pick(speech_sounds))
		current_flags[2] = 50
	return current_flags

/datum/species/proc/get_vision_organ(mob/living/carbon/human/H)
	return H.internal_organs_by_name[vision_organ]

/datum/species/proc/set_default_hair(var/mob/living/carbon/human/H)
	H.h_style = H.species.default_h_style
	H.f_style = H.species.default_f_style
	H.update_hair()

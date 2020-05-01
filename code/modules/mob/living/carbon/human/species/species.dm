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
	var/list/default_genders = list(MALE, FEMALE)

	// Icon/appearance vars.
	var/icobase = 'icons/mob/human_races/human/r_human.dmi'    // Normal icon set.
	var/deform = 'icons/mob/human_races/human/r_def_human.dmi' // Mutated icon set.
	var/preview_icon = 'icons/mob/human_races/human/human_preview.dmi'

	// Damage overlay and masks.
	var/damage_overlays = 'icons/mob/human_races/masks/dam_human.dmi'
	var/damage_mask = 'icons/mob/human_races/masks/dam_mask_human.dmi'
	var/blood_mask = 'icons/mob/human_races/masks/blood_human.dmi'
	var/onfire_overlay = 'icons/mob/OnFire.dmi'

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
	var/total_health = 200                   // Point at which the mob will enter crit.
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
	var/grab_mod =      1                    // How easy it is to grab the species. Higher is harder to grab.
	var/resist_mod =    1                    // How easy it is for the species to resist out of a grab.
	var/metabolism_mod = 1					 // Reagent metabolism modifier
	var/bleed_mod = 1						 // How fast this species bleeds.
	var/blood_volume = DEFAULT_BLOOD_AMOUNT // Blood volume.

	var/vision_flags = DEFAULT_SIGHT         // Same flags as glasses.
	var/inherent_eye_protection              // If set, this species has this level of inherent eye protection.
	var/eyes_are_impermeable = FALSE         // If TRUE, this species' eyes are not damaged by phoron.
	var/list/breakcuffs = list()             //used in resist.dm to check if they can break hand/leg cuffs
	var/natural_climbing = FALSE             //If true, the species always succeeds at climbing.
	var/climb_coeff = 1.25                   //The coefficient to the climbing speed of the individual = 60 SECONDS * climb_coeff
	// Death vars.
	var/meat_type = /obj/item/reagent_containers/food/snacks/meat/human
	var/gibber_type = /obj/effect/gibspawner/human
	var/single_gib_type = /obj/effect/decal/cleanable/blood/gibs
	var/remains_type = /obj/effect/decal/remains/xeno
	var/gibbed_anim = "gibbed-h"
	var/dusted_anim = "dust-h"
	var/death_sound
	var/death_message = "falls limp and stops moving..."
	var/death_message_range = 2
	var/knockout_message = "has been knocked unconscious!"
	var/halloss_message = "slumps to the ground, too weak to continue fighting."
	var/halloss_message_self = "You're in too much pain to keep going..."

	// Environment tolerance/life processes vars.
	var/reagent_tag                                   //Used for metabolizing reagents.
	var/breath_pressure = 16                          // Minimum partial pressure safe for breathing, kPa
	var/breath_type = "oxygen"                        // Non-oxygen gas breathed, if any.
	var/poison_type = "phoron"                        // Poisonous air.
	var/exhale_type = "carbon_dioxide"                // Exhaled gas type.
	var/breath_vol_mul = 1 							  // The fraction of air used, relative to the default carbon breath volume (1/2 L)
	var/breath_eff_mul = 1 								  // The efficiency of breathing, relative to the default carbon breath efficiency (1/6)
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
	var/breathing_sound = 'sound/voice/monkey.ogg'    // If set, this mob will have a breathing sound.
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
	var/health_hud_intensity = 1

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

	var/gluttonous = 0            // Can eat some mobs. Values can be GLUT_TINY, GLUT_SMALLER, GLUT_ANYTHING, GLUT_ITEM_TINY, GLUT_ITEM_NORMAL, GLUT_ITEM_ANYTHING, GLUT_PROJECTILE_VOMIT
	var/stomach_capacity = 5      // How much stuff they can stick in their stomach
	var/allowed_eat_types = TYPE_ORGANIC
	var/max_nutrition_factor = 1	//Multiplier on maximum nutrition
	var/nutrition_loss_factor = 1	//Multiplier on passive nutrition losses

	var/max_hydration_factor = 1	//Multiplier on maximum thirst
	var/hydration_loss_factor = 1	//Multiplier on passive thirst losses

	                              // Determines the organs that the species spawns with and
	var/list/has_organ = list(    // which required-organ checks are conducted.
		BP_HEART =    /obj/item/organ/internal/heart,
		BP_LUNGS =    /obj/item/organ/internal/lungs,
		BP_LIVER =    /obj/item/organ/internal/liver,
		BP_KIDNEYS =  /obj/item/organ/internal/kidneys,
		BP_STOMACH =  /obj/item/organ/internal/stomach,
		BP_BRAIN =    /obj/item/organ/internal/brain,
		BP_APPENDIX = /obj/item/organ/internal/appendix,
		BP_EYES =     /obj/item/organ/internal/eyes
		)
	var/vision_organ              // If set, this organ is required for vision. Defaults to BP_EYES if the species has them.
	var/breathing_organ           // If set, this organ is required to breathe. Defaults to BP_LUNGS if the species has them.

	var/list/has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
		)

	// Bump vars
	var/bump_flag = HUMAN	// What are we considered to be when bumped?
	var/push_flags = ~HEAVY	// What can we push?
	var/swap_flags = ~HEAVY	// What can we swap place with?

	var/pass_flags = 0

	var/obj/effect/decal/cleanable/blood/tracks/move_trail = /obj/effect/decal/cleanable/blood/tracks/footprints // What marks are left when walking

	var/default_h_style = "Bald"
	var/default_f_style = "Shaved"

	var/list/allowed_citizenships = list(CITIZENSHIP_BIESEL, CITIZENSHIP_SOL, CITIZENSHIP_COALITION, CITIZENSHIP_ELYRA, CITIZENSHIP_ERIDANI, CITIZENSHIP_DOMINIA)
	var/list/allowed_religions = list(RELIGION_NONE, RELIGION_OTHER, RELIGION_CHRISTIANITY, RELIGION_ISLAM, RELIGION_JUDAISM, RELIGION_HINDU, RELIGION_BUDDHISM, RELIGION_MOROZ, RELIGION_TRINARY, RELIGION_SCARAB)
	var/default_citizenship = CITIZENSHIP_BIESEL
	var/zombie_type	//What zombie species they become
	var/list/character_color_presets

/datum/species/proc/get_eyes(var/mob/living/carbon/human/H)
	return

/datum/species/New()
	if(hud_type)
		hud = new hud_type()
	else
		hud = new()

	//If the species has eyes, they are the default vision organ
	if(!vision_organ && has_organ[BP_EYES])
		vision_organ = BP_EYES

	// Same, but for lungs.
	if (!breathing_organ && has_organ[BP_LUNGS])
		breathing_organ = BP_LUNGS

	unarmed_attacks = list()
	for(var/u_type in unarmed_types)
		unarmed_attacks += new u_type()

/datum/species/proc/get_station_variant()
	return name

/datum/species/proc/get_bodytype()
	if(!bodytype)
		bodytype = name
	return bodytype

/datum/species/proc/get_surgery_overlay_icon(var/mob/living/carbon/human/H)
	return 'icons/mob/surgery.dmi'

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
				to_chat(H, "<span class='danger'>[pick(cold_discomfort_strings)]</span>")
		if("heat")
			if(covered)
				to_chat(H, "<span class='danger'>[pick(heat_discomfort_strings)]</span>")

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

/datum/species/proc/tap(var/mob/living/carbon/human/H,var/mob/living/target)
	var/t_his = "their"
	switch(target.gender)
		if(MALE)
			t_his = "his"
		if(FEMALE)
			t_his = "her"
	var/t_him = "them"
	switch(target.gender)
		if(MALE)
			t_him = "him"
		if(FEMALE)
			t_him = "her"

	if(H.on_fire)
		target.fire_stacks += 1
		target.IgniteMob()
		H.visible_message("<span class='danger'>[H] taps [target], setting [t_him] ablaze!</span>", \
						"<span class='warning'>You tap [target], setting [t_him] ablaze!</span>")
		msg_admin_attack("[key_name(H)] spread fire to [target.name] ([target.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[H.x];Y=[H.y];Z=[H.z]'>JMP</a>)",ckey=key_name(H),ckey_target=key_name(target))
	else
		H.visible_message("<span class='notice'>[H] taps [target] to get [t_his] attention!</span>", \
						"<span class='notice'>You tap [target] to get [t_his] attention!</span>")

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
	H.eat_types = allowed_eat_types
	if(!kpg)
		if(islesserform(H))
			H.dna.SetSEState(MONKEYBLOCK,1)
		else
			H.dna.SetSEState(MONKEYBLOCK,0)
	if(!H.client || !H.client.prefs || !H.client.prefs.gender)
		H.gender = pick(default_genders)

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
	var/list/vision = H.get_accumulated_vision_handlers()
	H.update_sight()
	H.sight |= get_vision_flags(H)
	H.sight |= H.equipment_vision_flags
	H.sight |= vision[1]

	if(H.stat == DEAD)
		return 1

	if(!H.druggy)
		H.see_in_dark = (H.sight == (SEE_TURFS|SEE_MOBS|SEE_OBJS)) ? 8 : min(darksight + H.equipment_darkness_modifier, 8)
		if(H.seer && locate(/obj/effect/rune/see_invisible) in get_turf(H))
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
	if((H.get_shock() >= 10) && prob(H.get_shock() *2))
		H.flash_pain()

	if ((H.get_shock() + H.getOxyLoss()) >= (exhaust_threshold * 0.8))
		H.m_intent = "walk"
		H.hud_used.move_intent.update_move_icon(H)
		to_chat(H, span("danger", "You're too exhausted to run anymore!"))
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

/datum/species/proc/get_species_tally(var/mob/living/carbon/human/H)
	return 0

/datum/species/proc/equip_later_gear(var/mob/living/carbon/human/H) //this handles anything not covered by survival gear, it is only called after everything else is equiped to the mob
	return

/datum/species/proc/get_cloning_variant()
	return name

/datum/species/proc/handle_death_check(var/mob/living/carbon/human/H)
	return FALSE

/datum/species/proc/get_digestion_product()
	return "nutriment"

/datum/species/proc/can_commune()
	return FALSE

/datum/species/proc/handle_despawn()
	return
/*
	Datum-based species. Should make for much cleaner and easier to maintain race code.
*/

/datum/species

	// Descriptors and strings.
	var/name                                             // Species name.
	var/name_plural                                      // Pluralized name (since "[name]s" is not always valid)
	var/hide_name = FALSE                                // If TRUE, the species' name won't be visible on examine.
	var/short_name                                       // Shortened form of the name, for code use. Must be exactly 3 letter long, and all lowercase
	var/category_name                                    // a name for this overarching species, ie 'Human', 'Skrell', 'IPC'. only used in character creation
	var/blurb = "A completely nondescript species."      // A brief lore summary for use in the chargen screen.
	var/bodytype
	var/age_min = 18
	var/age_max = 85
	var/economic_modifier = 0
	var/list/default_genders = list(MALE, FEMALE)
	var/list/selectable_pronouns = list(MALE, FEMALE, PLURAL)

	// Icon/appearance vars.
	var/canvas_icon = 'icons/mob/base_32.dmi'                  // Used to blend parts and icons onto this, to avoid clipping issues.
	var/icobase = 'icons/mob/human_races/human/r_human.dmi'    // Normal icon set.
	var/deform = 'icons/mob/human_races/human/r_def_human.dmi' // Mutated icon set.
	var/skeleton_icon = 'icons/mob/human_races/r_skeleton.dmi'
	var/preview_icon = 'icons/mob/human_races/human/human_preview.dmi'
	var/bandages_icon

	var/talk_bubble_icon

	// Damage overlay and masks.
	var/damage_overlays = 'icons/mob/human_races/masks/dam_human.dmi'
	var/damage_mask = 'icons/mob/human_races/masks/dam_mask_human.dmi'
	var/blood_mask = 'icons/mob/human_races/masks/blood_human.dmi'
	var/onfire_overlay = 'icons/mob/burning/burning_generic.dmi'

	var/prone_icon                                       // If set, draws this from icobase when mob is prone.
	var/icon_x_offset = 0
	var/icon_y_offset = 0
	var/floating_chat_x_offset = null
	var/eyes = "eyes_s"                                  // Icon for eyes.
	var/eyes_icons = 'icons/mob/human_face/eyes.dmi'     // DMI file for eyes, mostly for none 32x32 species.
	var/has_floating_eyes                                // Eyes will overlay over darkness (glow)
	var/eyes_icon_blend = ICON_ADD                       // The icon blending mode to use for eyes.
	var/blood_type = "blood"
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
	var/short_sighted
	var/bald = 0

	// Light
	var/light_range = null
	var/light_power = null
	var/light_color = null

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
	var/standing_jump_range = 2
	var/list/maneuvers = list(/decl/maneuver/leap)

	var/pain_mod =      1                    // Pain multiplier
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
	var/injection_mod = 1                    // Multiplicative time modifier on syringe injections

	var/vision_flags = DEFAULT_SIGHT         // Same flags as glasses.
	var/inherent_eye_protection              // If set, this species has this level of inherent eye protection.
	var/eyes_are_impermeable = FALSE         // If TRUE, this species' eyes are not damaged by phoron.
	var/break_cuffs = FALSE                   //used in resist.dm to check if they can break hand/leg cuffs
	var/natural_climbing = FALSE             //If true, the species always succeeds at climbing.
	var/climb_coeff = 1.25                   //The coefficient to the climbing speed of the individual = 60 SECONDS * climb_coeff

	// Death vars.
	var/respawn_type = CREW
	var/meat_type = /obj/item/reagent_containers/food/snacks/meat/human
	var/gibber_type = /obj/effect/gibspawner/human
	var/single_gib_type = /obj/effect/decal/cleanable/blood/gibs
	var/remains_type = /obj/effect/decal/remains/xeno
	var/dust_remains_type =  /obj/effect/decal/remains/xeno/burned
	var/gibbed_anim = "gibbed-h"
	var/death_sound
	var/death_message = "falls limp and stops moving..."
	var/death_message_range = 2
	var/knockout_message = "has been knocked unconscious!"
	var/halloss_message = "slumps to the ground, too weak to continue fighting."
	var/halloss_message_self = "You're in too much pain to keep going..."
	var/list/pain_messages = list("It hurts so much", "You really need some painkillers", "Dear god, the pain") // passive message displayed to user when injured
	var/list/pain_item_drop_cry = list("screams in pain and ", "lets out a sharp cry and ", "cries out and ")

	// External Organ Pain Damage
	var/organ_low_pain_message = "<b>Your %PARTNAME% hurts.</b>"
	var/organ_med_pain_message = "<b><font size=3>Your %PARTNAME% hurts badly!</font></b>"
	var/organ_high_pain_message = "<b><font size=3>Your %PARTNAME% is screaming out in pain!</font></b>"

	var/organ_low_burn_message = "<span class='danger'>Your %PARTNAME% burns.</span>"
	var/organ_med_burn_message = "<span class='danger'><font size=3>Your %PARTNAME% burns horribly!</font></span>"
	var/organ_high_burn_message = "<span class='danger'><font size=4>Your %PARTNAME% feels like it's on fire!</font></span>"

	var/list/stutter_verbs = list("stammers", "stutters")

	// Environment tolerance/life processes vars.
	var/reagent_tag                                   //Used for metabolizing reagents.
	var/breath_pressure = 16                          // Minimum partial pressure safe for breathing, kPa
	var/breath_type = GAS_OXYGEN                        // Non-oxygen gas breathed, if any.
	var/poison_type = GAS_PHORON                        // Poisonous air.
	var/exhale_type = GAS_CO2                // Exhaled gas type.
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

	// Order matters, higher pain level should be higher up
	var/list/pain_emotes_with_pain_level = list(
		list(/decl/emote/audible/scream, /decl/emote/audible/whimper, /decl/emote/audible/moan, /decl/emote/audible/cry) = 70,
		list(/decl/emote/audible/grunt, /decl/emote/audible/groan, /decl/emote/audible/moan) = 40,
		list(/decl/emote/audible/grunt, /decl/emote/audible/groan) = 10,
	)

	// HUD data vars.
	var/datum/hud_data/hud
	var/hud_type
	var/health_hud_intensity = 1
	var/healths_x // set this to specify where exactly the healths HUD element appears
	var/healths_overlay_x = 0 // set this to tweak where the overlays on top of the healths HUD element goes

	var/list/equip_overlays
	var/list/equip_adjust

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

	// Pulse modifiers
	var/low_pulse = 40
	var/norm_pulse = 60
	var/fast_pulse = 90
	var/v_fast_pulse = 120
	var/max_pulse = 160

	// Blood pressure modifiers
	var/bp_base_systolic = 120
	var/bp_base_disatolic = 80

	// Hearing sensitivity
	var/hearing_sensitivity = HEARING_NORMAL

	// Eating & nutrition related stuff
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

	var/list/natural_armor

	// Bump vars
	var/bump_flag = HUMAN	// What are we considered to be when bumped?
	var/push_flags = ~HEAVY	// What can we push?
	var/swap_flags = ~HEAVY	// What can we swap place with?

	var/pass_flags = 0

	var/obj/effect/decal/cleanable/blood/tracks/move_trail = /obj/effect/decal/cleanable/blood/tracks/footprints/barefoot // What marks are left when walking

	var/default_h_style = "Bald"
	var/default_f_style = "Shaved"
	var/default_g_style = "None"

	var/list/possible_cultures = list(
		/decl/origin_item/culture/unknown
	)

	var/zombie_type	//What zombie species they become
	var/list/character_color_presets
	var/bodyfall_sound = /decl/sound_category/bodyfall_sound //default, can be used for species specific falling sounds
	var/footsound = /decl/sound_category/blank_footsteps //same as above but for footsteps without shoes

	var/list/alterable_internal_organs = list(BP_HEART, BP_EYES, BP_LUNGS, BP_LIVER, BP_KIDNEYS, BP_STOMACH, BP_APPENDIX) //what internal organs can be changed in character setup
	var/list/possible_external_organs_modifications = list("Normal","Amputated","Prosthesis")

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
		if((clothes.body_parts_covered & UPPER_TORSO) && (clothes.body_parts_covered & LOWER_TORSO) && !clothes.no_overheat)
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
	if(H.bad_external_organs)     H.bad_external_organs.Cut()
	if(H.bad_internal_organs)     H.bad_internal_organs.Cut()

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
			E.robotize(E.robotize_type)
		for(var/obj/item/organ/I in H.internal_organs)
			I.robotize(I.robotize_type)

	if(isvaurca(H))
		for (var/obj/item/organ/external/E in H.organs)
			if ((E.status & ORGAN_CUT_AWAY) || (E.status & ORGAN_DESTROYED))
				continue
			E.status |= ORGAN_ADV_ROBOT
		for(var/obj/item/organ/I in H.internal_organs)
			I.status |= ORGAN_ADV_ROBOT

	if(natural_armor)
		H.AddComponent(/datum/component/armor, natural_armor)

/datum/species/proc/tap(var/mob/living/carbon/human/H,var/mob/living/target)
	if(H.on_fire)
		target.fire_stacks += 1
		target.IgniteMob()
		H.visible_message("<span class='danger'>[H] taps [target], setting [target.get_pronoun("his")] ablaze!</span>", \
						"<span class='warning'>You tap [target], setting [target.get_pronoun("him")] ablaze!</span>")
		msg_admin_attack("[key_name(H)] spread fire to [target.name] ([target.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[H.x];Y=[H.y];Z=[H.z]'>JMP</a>)",ckey=key_name(H),ckey_target=key_name(target))
	else
		H.visible_message("<span class='notice'>[H] taps [target] to get [target.get_pronoun("his")] attention!</span>", \
						"<span class='notice'>You tap [target] to get [target.get_pronoun("his")] attention!</span>")

/datum/species/proc/remove_inherent_verbs(var/mob/living/carbon/human/H)
	if(inherent_verbs)
		for(var/verb_path in inherent_verbs)
			H.verbs -= verb_path

	if(inherent_spells)
		for(var/spell_path in inherent_spells)
			for(var/spell/spell in H.spell_list)
				if(istype(spell, spell_path))
					H.remove_spell(spell)
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
		H.pronouns = H.gender

/datum/species/proc/handle_death(var/mob/living/carbon/human/H, var/gibbed = 0) //Handles any species-specific death events (such as dionaea nymph spawns).
	return

// Only used for alien plasma weeds atm, but could be used for Dionaea later.
/datum/species/proc/handle_environment_special(var/mob/living/carbon/human/H)
	return

// Used to update alien icons for aliens.
/datum/species/proc/handle_login_special(var/mob/living/carbon/human/H)
	if(has_autohiss && H.client)
		H.client.autohiss_mode = H.client.prefs.autohiss_setting

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
	if(H.machine && H.machine.check_eye(H) >= 0 && H.client.eye != H)
		// we inherit sight flags from the machine
		H.sight &= ~(get_vision_flags(H))
		H.sight &= ~(H.equipment_vision_flags)
		H.sight &= ~(vision[1])
	else
		H.set_sight(H.sight|get_vision_flags(H)|H.equipment_vision_flags|vision[1])

	if(H.stat == DEAD)
		return 1

	if(!H.druggy)
		H.set_see_in_dark((H.sight == (SEE_TURFS|SEE_MOBS|SEE_OBJS)) ? 8 : min(darksight + H.equipment_darkness_modifier, 8))
		if(H.seer)
			var/obj/effect/rune/R = locate(/obj/effect/rune) in get_turf(H)
			if(R && R.type == /datum/rune/see_invisible)
				H.set_see_invisible(SEE_INVISIBLE_CULT)
		if(H.see_invisible != SEE_INVISIBLE_CULT && H.equipment_see_invis)
			H.set_see_invisible(min(H.see_invisible, H.equipment_see_invis))

	if(H.equipment_tint_total >= TINT_BLIND)
		H.eye_blind = max(H.eye_blind, 1)

	if(!H.client)//no client, no screen to update
		return 1

	H.set_fullscreen(H.eye_blind, "blind", /obj/screen/fullscreen/blind)
	H.set_fullscreen(H.stat == UNCONSCIOUS, "blackout", /obj/screen/fullscreen/blackout)

	if(config.welder_vision)
		if(H.equipment_tint_total)
			H.overlay_fullscreen("welder", /obj/screen/fullscreen/impaired, H.equipment_tint_total, 0.5 SECONDS)
		else
			H.clear_fullscreen("welder")
	var/how_nearsighted = get_how_nearsighted(H)
	H.set_fullscreen(how_nearsighted, "nearsighted", /obj/screen/fullscreen/oxy, how_nearsighted)
	H.set_fullscreen(H.eye_blurry, "blurry", /obj/screen/fullscreen/blurry)

	if(H.druggy)
		H.client.screen += global_hud.druggy
	if(H.druggy > 5)
		H.add_client_color(/datum/client_color/oversaturated)
	else
		H.remove_client_color(/datum/client_color/oversaturated)

	for(var/overlay in H.equipment_overlays)
		H.client.screen |= overlay

	var/obj/item/organ/internal/eyes/night/NE = H.internal_organs_by_name[BP_EYES]
	if(istype(NE) && NE.night_vision && NE.can_change_invisible())
		H.set_see_invisible(SEE_INVISIBLE_NOLIGHTING)

	return 1

/datum/species/proc/get_how_nearsighted(var/mob/living/carbon/human/H)
	var/prescriptions = short_sighted
	if(H.disabilities & NEARSIGHTED)
		prescriptions += 7
	if(H.equipment_prescription)
		prescriptions -= H.equipment_prescription
	return Clamp(prescriptions, 0, 7)

// pre_move is set to TRUE when the mob checks whether it's even possible to move, so resources aren't drained until after the move completes
// once the mob moves and its loc actually changes, the pre_move is set to FALSE and all the proper resources are drained
/datum/species/proc/handle_sprint_cost(var/mob/living/carbon/human/H, var/cost, var/pre_move)
	if (!H.exhaust_threshold)
		return 1 // Handled.

	cost += H.getOxyLoss() * 0.1 //The less oxygen we get, the more we strain.
	cost *= H.sprint_cost_factor
	if(H.is_drowsy())
		cost *= 1.25
	if (H.stamina == -1)
		log_debug("Error: Species with special sprint mechanics has not overridden cost function.")
		return 0

	var/obj/item/organ/internal/augment/calf_override/C = H.internal_organs_by_name[BP_AUG_CALF_OVERRIDE]
	if(C && !C.is_broken())
		cost = 0
		if(!pre_move)
			C.do_run_act()

	var/remainder = 0
	if (H.stamina > cost)
		if(!pre_move)
			H.stamina -= cost
			H.hud_used.move_intent.update_move_icon(H)
		return 1
	else if (H.stamina > 0)
		remainder = cost - H.stamina
		if(!pre_move)
			H.stamina = 0
	else
		remainder = cost

	if(!pre_move && (H.disabilities & ASTHMA))
		H.adjustOxyLoss(remainder*0.15)

	if(!pre_move && (H.disabilities & COUGHING))
		H.adjustHalLoss(remainder*0.1)

	if(!pre_move && breathing_organ && has_organ[breathing_organ])
		var/obj/item/organ/O = H.internal_organs_by_name[breathing_organ]
		if(O.is_bruised())
			H.adjustOxyLoss(remainder*0.15)
			H.adjustHalLoss(remainder*0.25)
		H.adjustOxyLoss(remainder * 0.2) //Keeping oxyloss small when out of stamina to prevent old issue where running until exhausted sometimes gave you brain damage.

	var/shock = H.get_shock()
	if(!pre_move)
		H.adjustHalLoss(remainder*0.3)
		H.updatehealth()
		if((shock >= 10) && prob(shock *2))
			H.flash_pain(shock)

	if((shock + H.getOxyLoss()*2) >= (exhaust_threshold * 0.8))
		H.m_intent = M_WALK
		H.hud_used.move_intent.update_move_icon(H)
		to_chat(H, SPAN_DANGER("You're too exhausted to run anymore!"))
		H.flash_pain(shock)
		return 0

	if(!pre_move)
		H.hud_used.move_intent.update_move_icon(H)
	return 1

/datum/species/proc/get_light_color(mob/living/carbon/human/H)
	return

/datum/species/proc/can_breathe_water()
	return FALSE

/datum/species/proc/handle_trail(var/mob/living/carbon/human/H, var/turf/T)
	var/list/trail_info = list()
	if(H.shoes)
		var/obj/item/clothing/shoes/S = H.shoes
		if(istype(S))
			S.handle_movement(T, H.m_intent == M_RUN ? TRUE : FALSE)
			if(S.track_footprint)
				if(S.blood_DNA)
					trail_info["footprint_DNA"] = S.blood_DNA
				trail_info["footprint_color"] = S.blood_color
				S.track_footprint--
	else
		if(H.track_footprint)
			if(H.feet_blood_DNA)
				trail_info["footprint_DNA"] = H.feet_blood_DNA
			trail_info["footprint_color"] = H.footprint_color
			H.track_footprint--

	return trail_info

/datum/species/proc/deploy_trail(var/mob/living/carbon/human/H, var/turf/T)
	var/list/trail_info = handle_trail(H, T)
	if(length(trail_info))
		var/track_path = trail_info["footprint_type"]
		T.add_tracks(track_path ? track_path : H.species.get_move_trail(H), trail_info["footprint_DNA"], H.dir, 0, trail_info["footprint_color"]) // Coming
		var/turf/simulated/from = get_step(H, reverse_direction(H.dir))
		if(istype(from))
			from.add_tracks(track_path ? track_path : H.species.get_move_trail(H), trail_info["footprint_DNA"], 0, H.dir, trail_info["footprint_color"]) // Going

/datum/species/proc/get_move_trail(var/mob/living/carbon/human/H)
	if(H.lying)
		return /obj/effect/decal/cleanable/blood/tracks/body
	else if(H.shoes || (H.wear_suit && (H.wear_suit.body_parts_covered & FEET)))
		var/obj/item/clothing/shoes
		if(H.wear_suit && (H.wear_suit.body_parts_covered & FEET))
			shoes = H.wear_suit
			. = shoes.move_trail
		if(H.shoes && !.)
			shoes = H.shoes
			. = shoes.move_trail
	if(!.)
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
	H.g_style = H.species.default_g_style
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
	return /decl/reagent/nutriment

/datum/species/proc/can_commune()
	return FALSE

/datum/species/proc/has_psi_potential()
	return TRUE

/datum/species/proc/handle_despawn()
	return

/datum/species/proc/handle_strip(var/mob/user, var/mob/living/carbon/human/H, var/action)
	return

/datum/species/proc/get_strip_info(var/reference)
	return ""

/datum/species/proc/get_pain_emote(var/mob/living/carbon/human/H, var/pain_power)
	if(flags & NO_PAIN)
		return
	for(var/pain_emotes in pain_emotes_with_pain_level)
		var/pain_level = pain_emotes_with_pain_level[pain_emotes]
		if(pain_power >= pain_level)
			// This assumes that if a pain-level has been defined it also has a list of emotes to go with it
			var/decl/emote/E = decls_repository.get_decl(pick(pain_emotes))
			return E.key

/datum/species/proc/get_injection_modifier()
	return injection_mod

/datum/species/proc/is_naturally_insulated()
	return FALSE

/datum/species/proc/bypass_food_fullness(var/mob/living/carbon/human/H) //proc used to see if the species can eat more than their nutrition value allows
	return FALSE

// the records var is so that untagged shells can appear human
/datum/species/proc/get_species(var/reference, var/mob/living/carbon/human/H, var/records)
	if(reference)
		return src
	return name

// prevents EMP damage if return it returns TRUE
/datum/species/proc/handle_emp_act(var/mob/living/carbon/human/H, var/severity)
	return FALSE

/datum/species/proc/handle_movement_tally(var/mob/living/carbon/human/H)
	var/tally = 0
	if(istype(H.buckled_to, /obj/structure/bed/stool/chair/office/wheelchair))
		for(var/organ_name in list(BP_L_HAND,BP_R_HAND,BP_L_ARM,BP_R_ARM))
			var/obj/item/organ/external/E = H.get_organ(organ_name)
			if(!E || E.is_stump())
				tally += 4
			else if(E.status & ORGAN_SPLINTED)
				tally += 0.5
			else if(E.status & ORGAN_BROKEN)
				tally += 1.5
	else
		for(var/organ_name in list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG))
			var/obj/item/organ/external/E = H.get_organ(organ_name)
			if(!E || E.is_stump())
				tally += 4
			else if((E.status & ORGAN_BROKEN) || (E.tendon_status() & TENDON_CUT))
				tally += 1.5
			else if((E.status & ORGAN_SPLINTED) || (E.tendon_status() & TENDON_BRUISED))
				tally += 0.5
	return tally

/datum/species/proc/handle_stance_damage(var/mob/living/carbon/human/H, var/damage_only = FALSE)
	var/static/support_limbs = list(
		BP_L_LEG = BP_R_LEG,
		BP_L_FOOT = BP_R_FOOT
	)

	var/has_opposite_limb = FALSE
	var/stance_damage = 0
	for(var/limb_tag in list(BP_L_LEG, BP_L_FOOT, BP_R_LEG, BP_R_FOOT))
		var/obj/item/organ/external/E = H.organs_by_name[limb_tag]
		if(!E || (E.status & (ORGAN_MUTATED|ORGAN_DEAD)) || E.is_stump()) //should just be !E.is_usable() here but dislocation screws that up.
			has_opposite_limb = H.get_organ(support_limbs[limb_tag])
			if(!has_opposite_limb)
				stance_damage += 10 //No walking for you with no supporting limb, buddy.
				break
			else
				stance_damage += 2
		else if (E.is_malfunctioning())
			//malfunctioning only happens intermittently so treat it as a missing limb when it procs
			stance_damage += 2
			if(!damage_only && prob(10))
				H.visible_message(SPAN_WARNING("\The [H]'s [E.name] [pick("twitches", "shudders")] and sparks!"))
				spark(H, 5)
		else if (E.is_broken() || !E.is_usable())
			stance_damage += 1
		else if (ORGAN_IS_DISLOCATED(E))
			stance_damage += 0.5

	// Canes and crutches help you stand (if the latter is ever added)
	// One cane mitigates a broken leg+foot, or a missing foot.
	// No double caning allowed, sorry. Canes also don't work if you're missing a functioning pair of feet or legs.
	if(has_opposite_limb)
		var/obj/item/cane/C = H.get_type_in_hands(/obj/item/cane)
		if(C?.can_support)
			stance_damage -=2

	return stance_damage

/datum/species/proc/can_hold_s_store(var/obj/item/I)
	return FALSE

/datum/species/proc/can_double_fireman_carry()
	return FALSE

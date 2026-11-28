/singleton/quirk_category
	var/name = "Miscellaneous"
	var/sort_order = 0

/singleton/quirk_category/physical
	name = "Physical"
	sort_order = 1

/singleton/quirk_category/sensory
	name = "Sensory"
	sort_order = 2

/singleton/quirk_category/mental
	name = "Mental"
	sort_order = 3

/singleton/quirk_category/psionic
	name = "Psionic"
	sort_order = 4

/**
 * A character quirk prototype.
 *
 * Override on_spawn() for arbitrary behavior such as changing mob variables or
 * editing skill components. Simple component- and element-backed quirks can set
 * component_type or element_type without overriding the proc.
 */
/singleton/quirk
	var/name = "Unnamed Quirk"
	var/description = "No description provided."
	var/category = /singleton/quirk_category/physical
	/// Positive costs spend points; negative costs grant points (only for quirks that substantially penalize every role at all times).
	var/point_cost = 0
	/// Slots may only have a zero or positive cost.
	var/slot_cost = 1
	/// Optional list of values presented as a selector when this quirk is chosen.
	var/list/selections
	/// Names used by the retired disability preference, for automatic migration.
	var/list/legacy_names = list()
	/// Optional convenience hooks. Quirks are not required to use any of these.
	var/component_type
	var/element_type
	var/background_trait
	/// Origin or culture paths that receive this quirk for 0 points and 0 slots.
	var/list/free_origins = list()

/**
 * Returns whether this quirk may be selected for the supplied character
 * preferences. Override this to inspect culture, origin, citizenship, species,
 * or any other character preference.
 *
 * For example, a Dominian-only quirk can compare preferences.culture against
 * the string form of /singleton/origin_item/culture/dominia.
 */
/singleton/quirk/proc/can_select(datum/preferences/preferences)
	return TRUE

/// Message shown when can_select() rejects this quirk.
/singleton/quirk/proc/get_unavailable_reason(datum/preferences/preferences)
	return "This quirk is unavailable with your current character preferences."

/// Returns TRUE if the character's origin or culture grants this quirk for free.
/singleton/quirk/proc/is_free_for_background(datum/preferences/preferences)
	if(!preferences)
		return FALSE
	var/origin_path = text2path(preferences.origin)
	var/culture_path = text2path(preferences.culture)
	if(length(free_origins) && ((origin_path in free_origins) || (culture_path in free_origins)))
		return TRUE
	if(background_trait)
		var/singleton/origin_item/origin = GET_SINGLETON(origin_path)
		var/singleton/origin_item/culture = GET_SINGLETON(culture_path)
		if((background_trait in origin?.origin_traits) || (background_trait in culture?.origin_traits))
			return TRUE
	return FALSE

/// Returns the point cost for this quirk given the character's current preferences.
/singleton/quirk/proc/get_point_cost(datum/preferences/preferences)
	return is_free_for_background(preferences) ? 0 : point_cost

/// Returns the slot cost for this quirk given the character's current preferences.
/singleton/quirk/proc/get_slot_cost(datum/preferences/preferences)
	return is_free_for_background(preferences) ? 0 : slot_cost

/// Returns the description shown in character setup for this quirk.
/singleton/quirk/proc/get_description(datum/preferences/preferences)
	if(is_free_for_background(preferences))
		return "[description] (Free from your character's background.)"
	return description

/*
 * Skill modifications
 *
 * Reserved for the later skill-modifier implementation. This hook is
 * intentionally not called yet.
 */
/singleton/quirk/proc/modify_skills(mob/character, selection)
	return

/singleton/quirk/proc/on_spawn(mob/character, selection)
	if(!character)
		return
	if(component_type)
		character.AddComponent(component_type)
	if(element_type)
		character.AddElement(element_type)
	if(background_trait)
		ADD_TRAIT(character, background_trait, TRAIT_SOURCE_QUIRK)

/**
 * Late chargen hook fired after equipment, loadout items, custom items,
 * augments, and organ replacements have finished spawning.
 * Use this for direct modifications to spawned organs, limbs, or gear.
 */
/singleton/quirk/proc/on_post_spawn(mob/character, selection)
	return

/// Adjusts skill_level on all skill components matching skill_flag by delta.
/singleton/quirk/proc/modify_skill_domain_levels(mob/living/carbon/human/character, skill_flag, delta)
	if(!character)
		return
	var/list/seen_components = list()
	for(var/singleton/skill/skill as anything in SSskills.all_skills)
		var/component_type = skill.component_type
		if(!component_type || !(skill.skill_flags & skill_flag) || (component_type in seen_components))
			continue
		seen_components[component_type] = TRUE
		var/datum/component/skill/skill_comp = character.LoadComponent(component_type, SKILL_LEVEL_UNFAMILIAR)
		if(istype(skill_comp))
			skill_comp.skill_level += delta

/singleton/quirk/nearsighted
	name = "Nearsightedness"
	description = "Without prescription glasses your vision is impaired."
	category = /singleton/quirk_category/sensory
	legacy_names = list("Nearsightedness")

/singleton/quirk/nearsighted/on_spawn(mob/living/carbon/human/character, selection)
	..()
	character.disabilities |= NEARSIGHTED
	if(character.dna)
		character.dna.SetSEState(GLASSESBLOCK, 1, 0)

/singleton/quirk/nearsighted/on_post_spawn(mob/living/carbon/human/character, selection)
	if(character.glasses)
		var/obj/item/clothing/glasses/worn_glasses = character.glasses
		worn_glasses.prescription = 7
	else
		character.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(character), slot_glasses, TRUE)

/singleton/quirk/stutter
	name = "Stuttering"
	description = "You have a chronic stutter and involuntarily repeat sounds."
	category = /singleton/quirk_category/mental
	legacy_names = list("Stuttering")

/singleton/quirk/stutter/on_spawn(mob/living/carbon/human/character, selection)
	character.disabilities |= STUTTERING

/singleton/quirk/deuteranopia
	name = "Deuteranopia"
	description = "You have difficulty perceiving green."
	category = /singleton/quirk_category/sensory
	legacy_names = list("Deuteranopia")

/singleton/quirk/deuteranopia/on_spawn(mob/living/carbon/human/character, selection)
	character.add_client_color(/datum/client_color/deuteranopia, TRUE)

/singleton/quirk/protanopia
	name = "Protanopia"
	description = "You have difficulty perceiving red."
	category = /singleton/quirk_category/sensory
	legacy_names = list("Protanopia")

/singleton/quirk/protanopia/on_spawn(mob/living/carbon/human/character, selection)
	character.add_client_color(/datum/client_color/protanopia, TRUE)

/singleton/quirk/tritanopia
	name = "Tritanopia"
	description = "You have difficulty perceiving blue and yellow."
	category = /singleton/quirk_category/sensory
	legacy_names = list("Tritanopia")

/singleton/quirk/tritanopia/on_spawn(mob/living/carbon/human/character, selection)
	character.add_client_color(/datum/client_color/tritanopia, TRUE)

/singleton/quirk/total_colorblind
	name = "Total Colorblindness"
	description = "You cannot see color, only black, white, and shades of gray."
	category = /singleton/quirk_category/sensory
	legacy_names = list("Total Colorblindness")

/singleton/quirk/total_colorblind/on_spawn(mob/living/carbon/human/character, selection)
	character.add_client_color(/datum/client_color/monochrome, TRUE)

/singleton/quirk/deaf
	name = "Deafness"
	description = "You are unable to perceive sound."
	category = /singleton/quirk_category/sensory
	legacy_names = list("Deafness")

/singleton/quirk/deaf/on_spawn(mob/living/carbon/human/character, selection)
	character.sdisabilities |= DEAF

/singleton/quirk/asthma
	name = "Asthma"
	description = "You are prone to inflammation in the lungs."
	legacy_names = list("Asthma")

/singleton/quirk/asthma/on_spawn(mob/living/carbon/human/character, selection)
	character.disabilities |= ASTHMA
	if(character.max_stamina)
		character.max_stamina *= 0.8
		character.stamina = character.max_stamina

/singleton/quirk/hemophilia
	name = "Hemophilia"
	description = "Your blood lacks clotting factors, causing wounds to take twice as long to stop bleeding."
	element_type = /datum/element/hemophilia
	legacy_names = list("Hemophilia")
	var/trait_type = TRAIT_DISABILITY_HEMOPHILIA

/singleton/quirk/hemophilia/on_spawn(mob/living/carbon/human/character, selection)
	..()
	ADD_TRAIT(character, trait_type, DISABILITY_TRAIT)

/singleton/quirk/hemophilia/major
	name = "Major Hemophilia"
	description = "Your blood lacks all clotting factors, causing wounds to never stop bleeding."
	element_type = /datum/element/hemophilia/major
	legacy_names = list("Major Hemophilia")
	trait_type = TRAIT_DISABILITY_HEMOPHILIA_MAJOR

ABSTRACT_TYPE(/singleton/quirk/organ_scarring)
	name = "Organ Scarring"
	var/affected_organ

/singleton/quirk/organ_scarring/on_post_spawn(mob/living/carbon/human/character, selection)
	var/obj/item/organ/internal/affecting = character.internal_organs_by_name[affected_organ]
	if(affecting)
		affecting.set_max_damage(initial(affecting.max_damage) * 0.5)

#define ORGAN_QUIRK(ORGAN_PATH, ORGAN_NAME, ORGAN_TAG, DESCRIPTION) \
/singleton/quirk/organ_scarring/##ORGAN_PATH { \
	name = "Scarred Organ: " + ##ORGAN_NAME; \
	description = DESCRIPTION; \
	affected_organ = ##ORGAN_TAG; \
	legacy_names = list("Scarred Organ: " + ##ORGAN_NAME); \
}

ORGAN_QUIRK(brain, "Brain", BP_BRAIN, "Your Brain is permanently scarred, halving its health and imposing a -0.5 rank penalty to all mental skills.")
/singleton/quirk/organ_scarring/brain
	point_cost = -2

/singleton/quirk/organ_scarring/brain/on_post_spawn(mob/living/carbon/human/character, selection)
	..()
	modify_skill_domain_levels(character, SKILL_FLAG_MENTAL, -0.5)
ORGAN_QUIRK(eyes, "Eyes", BP_EYES, "Your Eyes are permanently scarred and have reduced health.")
ORGAN_QUIRK(heart, "Heart", BP_HEART, "Your Heart is permanently scarred, reducing its health, pumping efficiency, blood regeneration, and resistance to fibrillation.")
/singleton/quirk/organ_scarring/heart
	point_cost = -1

/singleton/quirk/organ_scarring/heart/on_post_spawn(mob/living/carbon/human/character, selection)
	..()
	var/obj/item/organ/internal/heart/heart = character?.internal_organs_by_name[BP_HEART]
	if(!istype(heart))
		return
	heart.fibrillation_stop_risk *= 1.5
	heart.shock_stage_for_fibrillation *= 0.8
	heart.blood_regen_modifier *= 0.9
	heart.base_pump_rate *= 0.9
	heart.thready_pump_modifier *= 1.5
ORGAN_QUIRK(lungs, "Lungs", BP_LUNGS, "Your Lungs are permanently scarred and have reduced health.")
ORGAN_QUIRK(liver, "Liver", BP_LIVER, "Your Liver is permanently scarred, reducing its health and impairing its ability to filter toxins and reagents.")
/singleton/quirk/organ_scarring/liver/element_type = /datum/element/liver_scarring
ORGAN_QUIRK(kidneys, "Kidneys", BP_KIDNEYS, "Your Kidneys are permanently scarred and have reduced health.")
ORGAN_QUIRK(stomach, "Stomach", BP_STOMACH, "Your Stomach is permanently scarred and has reduced health.")
ORGAN_QUIRK(appendix, "Appendix", BP_APPENDIX, "Your Appendix is permanently scarred and has reduced health.")

#undef ORGAN_QUIRK

ABSTRACT_TYPE(/singleton/quirk/broken)
	name = "Broken Limb"
	var/affected_limb

#define BROKEN_QUIRK(LIMB_PATH, LIMB_NAME, LIMB_TAG, ELEMENT_TYPE) \
/singleton/quirk/broken/##LIMB_PATH { \
	name = "Broken Limb: " + ##LIMB_NAME; \
	description = "Your " + ##LIMB_NAME + " suffers from a permanent injury that impairs your physical capabilities."; \
	affected_limb = ##LIMB_TAG; \
	element_type = ##ELEMENT_TYPE; \
	legacy_names = list("Broken Limb: " + ##LIMB_NAME); \
}

BROKEN_QUIRK(left_arm, "Left Arm", BP_L_ARM, /datum/element/limb_injury/upper/arm)
BROKEN_QUIRK(right_arm, "Right Arm", BP_R_ARM, /datum/element/limb_injury/upper/arm)
BROKEN_QUIRK(left_hand, "Left Hand", BP_L_HAND, /datum/element/limb_injury/upper/hand)
BROKEN_QUIRK(right_hand, "Right Hand", BP_R_HAND, /datum/element/limb_injury/upper/hand)
BROKEN_QUIRK(left_leg, "Left Leg", BP_L_LEG, /datum/element/limb_injury/lower/leg)
BROKEN_QUIRK(right_leg, "Right Leg", BP_R_LEG, /datum/element/limb_injury/lower/leg)
BROKEN_QUIRK(left_foot, "Left Foot", BP_L_FOOT, /datum/element/limb_injury/lower/foot)
BROKEN_QUIRK(right_foot, "Right Foot", BP_R_FOOT, /datum/element/limb_injury/lower/foot)

#undef BROKEN_QUIRK

/singleton/quirk/psi_sensitivity
	name = "Psi-sensitivity"
	description = "Your natural sensitivity to psychic phenomena differs from the norm."
	category = /singleton/quirk_category/psionic
	selections = list("High", "Low")
	legacy_names = list("High Psi-sensitivity", "Low Psi-sensitivity")

/singleton/quirk/psi_sensitivity/on_spawn(mob/character, selection)
	if(selection == "High")
		character.AddComponent(HIGH_PSI_SENSITIVITY_COMPONENT)
	else if(selection == "Low")
		character.AddComponent(LOW_PSI_SENSITIVITY_COMPONENT)

/singleton/quirk/photosensitivity
	name = "Photosensitivity"
	description = "Bright light causes pain and degraded vision without eye protection."
	category = /singleton/quirk_category/sensory
	element_type = /datum/element/light_sensitivity
	legacy_names = list("Photosensitivity")

/singleton/quirk/nyctophobia
	name = "Nyctophobia"
	description = "You have a fear of the dark."
	category = /singleton/quirk_category/mental
	element_type = /datum/element/dark_afraid
	legacy_names = list("Nyctophobia")

/singleton/quirk/frail
	name = "Frail"
	description = "You have a weaker physical build, reducing your carrying capacity, melee impact, and resistance to being overpowered."
	category = /singleton/quirk_category/physical
	point_cost = 0
	element_type = /datum/element/frail

/singleton/quirk/hand_tremors
	name = "Hand Tremors"
	description = "Your hands shake persistently, hurting your aim with firearms and surgical precision while periodically spasming and forcing you to drop held items."
	category = /singleton/quirk_category/physical
	component_type = /datum/component/hand_tremors
	point_cost = -1

/singleton/quirk/steady_hands
	name = "Steady Hands"
	description = "Your hands are unusually steady, improving firearm accuracy and surgical speed and precision."
	category = /singleton/quirk_category/physical
	point_cost = 3
	element_type = /datum/element/steady_hands

/singleton/quirk/iron_stomach
	name = "Iron Stomach"
	description = "Your digestive system is unusually resilient, letting your liver filter toxins faster and preventing involuntary vomiting from incompatible or unpalatable food."
	category = /singleton/quirk_category/physical
	point_cost = 1
	element_type = /datum/element/liver_scarring/iron_stomach

/singleton/quirk/green_thumb
	name = "Green Thumb"
	description = "You have a knack for tending plants, harvesting faster and with higher yields."
	category = /singleton/quirk_category/mental
	point_cost = 1
	element_type = /datum/element/green_thumb

/singleton/quirk/butcher_instinct
	name = "Butcher's Instinct"
	description = "You know how to break down carcasses cleanly, yielding extra meat and parts."
	category = /singleton/quirk_category/mental
	point_cost = 1
	element_type = /datum/element/butcher_instinct

/singleton/quirk/athletic
	name = "Athletic"
	description = "You have a strong, well-trained build, increasing your carrying capacity, melee impact, and unarmed prowess."
	category = /singleton/quirk_category/physical
	point_cost = 3
	element_type = /datum/element/frail/athletic

/singleton/quirk/strong_heart
	name = "Strong Heart"
	description = "Your heart is exceptionally resilient, improving blood regeneration, pumping efficiency, and resistance to fibrillation."
	category = /singleton/quirk_category/physical
	point_cost = 2

/singleton/quirk/strong_heart/on_post_spawn(mob/living/carbon/human/character, selection)
	var/obj/item/organ/internal/heart/heart = character?.internal_organs_by_name[BP_HEART]
	if(!istype(heart))
		return
	heart.set_max_damage(initial(heart.max_damage) * 1.25)
	heart.fibrillation_stop_risk *= 0.7
	heart.shock_stage_for_fibrillation *= 1.15
	heart.blood_regen_modifier *= 1.1
	heart.base_pump_rate *= 1.1

/singleton/quirk/quick_clotting
	name = "Quick Clotting"
	description = "Your blood clots rapidly, reducing bloodloss from cuts and arterial wounds."
	category = /singleton/quirk_category/physical
	point_cost = 2
	element_type = /datum/element/hemophilia/quick_clotting

/singleton/quirk/high_lung_capacity
	name = "High Lung Capacity"
	description = "Your lungs are unusually resilient, granting extra stamina and increased lung health."
	category = /singleton/quirk_category/physical
	point_cost = 5

/singleton/quirk/high_lung_capacity/on_spawn(mob/living/carbon/human/character, selection)
	..()
	if(character.max_stamina)
		character.max_stamina *= 1.2
		character.stamina = character.max_stamina

/singleton/quirk/high_lung_capacity/on_post_spawn(mob/living/carbon/human/character, selection)
	var/obj/item/organ/internal/lungs = character?.internal_organs_by_name[BP_LUNGS]
	if(lungs)
		lungs.set_max_damage(initial(lungs.max_damage) * 1.25)

/singleton/quirk/sharp_mind
	name = "Sharp Mind"
	description = "You are quick to grasp complex subjects, gaining a +0.15 rank bonus to all mental skills."
	category = /singleton/quirk_category/mental
	point_cost = 6 // Intentionally requires a substantial negative quirk to pair with it.
	slot_cost = 3

/singleton/quirk/sharp_mind/on_post_spawn(mob/living/carbon/human/character, selection)
	modify_skill_domain_levels(character, SKILL_FLAG_MENTAL, 0.15)

/singleton/quirk/peak_physicality
	name = "Peak Physicality"
	description = "Your body is conditioned to its limits, gaining a +0.5 rank bonus to all physical skills."
	category = /singleton/quirk_category/physical
	point_cost = 6 // Intentionally requires a substantial negative quirk to pair with it.
	slot_cost = 3

/singleton/quirk/peak_physicality/can_select(datum/preferences/preferences)
	return !(/singleton/quirk/pathetic in preferences?.quirks)

/singleton/quirk/peak_physicality/get_unavailable_reason(datum/preferences/preferences)
	return "Cannot be combined with Pathetic."

/singleton/quirk/peak_physicality/on_post_spawn(mob/living/carbon/human/character, selection)
	modify_skill_domain_levels(character, SKILL_FLAG_PHYSICAL, 0.5)

/singleton/quirk/pathetic
	name = "Pathetic"
	description = "Your body is severely out of condition, imposing a -1.0 rank penalty to all physical skills."
	category = /singleton/quirk_category/physical
	point_cost = -1

/singleton/quirk/pathetic/can_select(datum/preferences/preferences)
	return !(/singleton/quirk/peak_physicality in preferences?.quirks)

/singleton/quirk/pathetic/get_unavailable_reason(datum/preferences/preferences)
	return "Cannot be combined with Peak Physicality."

/singleton/quirk/pathetic/on_post_spawn(mob/living/carbon/human/character, selection)
	modify_skill_domain_levels(character, SKILL_FLAG_PHYSICAL, -1.0)

/singleton/quirk/will_to_die
	name = "Will To Die"
	description = "Inverts your Tenacity skill into a penalty instead of a bonus, granting quirk points equal to the points spent in Tenacity."
	category = /singleton/quirk_category/mental

/singleton/quirk/will_to_die/proc/get_tenacity_points(datum/preferences/preferences)
	if(!preferences)
		return 0
	var/tenacity_level = preferences.skills?[/singleton/skill/tenacity]
	if(!tenacity_level)
		return 0
	var/singleton/skill/tenacity = GET_SINGLETON(/singleton/skill/tenacity)
	return tenacity?.get_cost(tenacity_level) || 0

/singleton/quirk/will_to_die/can_select(datum/preferences/preferences)
	return get_tenacity_points(preferences) > 0

/singleton/quirk/will_to_die/get_unavailable_reason(datum/preferences/preferences)
	return "Requires at least 1 point spent in Tenacity."

/singleton/quirk/will_to_die/get_point_cost(datum/preferences/preferences)
	return -get_tenacity_points(preferences)

/singleton/quirk/will_to_die/on_post_spawn(mob/living/carbon/human/character, selection)
	var/datum/component/skill/tenacity/tenacity = character?.GetComponent(TENACITY_SKILL_COMPONENT)
	if(istype(tenacity))
		tenacity.bonus_min_efficiency_per_rank *= -1
		tenacity.bonus_effective_bv_per_rank *= -1
		tenacity.bonus_pulse_mod_per_rank *= -1
		tenacity.bonus_bleed_resist_per_rank *= -1
		tenacity.bonus_arterial_resist_per_rank *= -1

/singleton/quirk/sanguine
	name = "Sanguine"
	description = "Your mood swings to greater extremes, increasing both maximum morale bonuses and penalties by 50%."
	category = /singleton/quirk_category/mental
	// Points disparity between Sanguine and Saturnine is intentional, Sanguine is dramatically more impactful.
	point_cost = 3

/singleton/quirk/sanguine/can_select(datum/preferences/preferences)
	return !(/singleton/quirk/saturnine in preferences?.quirks)

/singleton/quirk/sanguine/get_unavailable_reason(datum/preferences/preferences)
	return "Cannot be combined with Saturnine."

/singleton/quirk/sanguine/on_post_spawn(mob/living/carbon/human/character, selection)
	var/datum/component/morale/morale = character?.GetComponent(MORALE_COMPONENT)
	morale?.scale_contributions(1.5)

/singleton/quirk/saturnine
	name = "Saturnine"
	description = "Your temperament stays muted, tightening both maximum morale bonuses and penalties by 50%."
	category = /singleton/quirk_category/mental
	point_cost = -1

/singleton/quirk/saturnine/can_select(datum/preferences/preferences)
	return !(/singleton/quirk/sanguine in preferences?.quirks)

/singleton/quirk/saturnine/get_unavailable_reason(datum/preferences/preferences)
	return "Cannot be combined with Sanguine."

/singleton/quirk/saturnine/on_post_spawn(mob/living/carbon/human/character, selection)
	var/datum/component/morale/morale = character?.GetComponent(MORALE_COMPONENT)
	morale?.scale_contributions(0.5)

/singleton/quirk/cold_resistance
	name = "Cold Acclimatization"
	description = "You are acclimatised to cold environments and suffer less from low temperatures."
	category = /singleton/quirk_category/physical
	point_cost = 1
	background_trait = TRAIT_ORIGIN_COLD_RESISTANCE

/singleton/quirk/heat_resistance
	name = "Heat Acclimatization"
	description = "You are acclimatised to hot environments and suffer less from high temperatures."
	category = /singleton/quirk_category/physical
	point_cost = 1
	background_trait = TRAIT_ORIGIN_HOT_RESISTANCE

/singleton/quirk/alcohol_resistance
	name = "Alcohol Tolerance"
	description = "You have a high tolerance to alcoholic drinks."
	category = /singleton/quirk_category/physical
	point_cost = 1
	background_trait = TRAIT_ORIGIN_ALCOHOL_RESISTANCE

/singleton/quirk/drug_resistance
	name = "Drug Tolerance"
	description = "You have a higher tolerance to recreational drugs."
	category = /singleton/quirk_category/physical
	point_cost = 1
	background_trait = TRAIT_ORIGIN_DRUG_RESISTANCE

/singleton/quirk/toxin_resistance
	name = "Toxin Resistance"
	description = "Your body has a heightened resistance to toxins."
	category = /singleton/quirk_category/physical
	point_cost = 2
	background_trait = TRAIT_ORIGIN_TOX_RESISTANCE

/singleton/quirk/pain_resistance
	name = "Pain Tolerance"
	description = "You are more resistant to pain than the average person."
	category = /singleton/quirk_category/physical
	point_cost = 2
	background_trait = TRAIT_ORIGIN_PAIN_RESISTANCE

/singleton/quirk/stamina_bonus
	name = "Endurance"
	description = "You have slightly higher stamina reserves."
	category = /singleton/quirk_category/physical
	point_cost = 1
	background_trait = TRAIT_ORIGIN_STAMINA_BONUS

/singleton/quirk/ignore_capsaicin
	name = "Spice Tolerance"
	description = "You are unaffected by spicy foods and capsaicin."
	category = /singleton/quirk_category/sensory
	point_cost = 1
	background_trait = TRAIT_ORIGIN_IGNORE_CAPSAICIN

/singleton/quirk/rad_resistance
	name = "Radiation Resistance"
	description = "You have a minor innate resistance to radiation."
	category = /singleton/quirk_category/physical
	point_cost = 2
	free_origins = list(
		/singleton/origin_item/origin/gadpathur,
		/singleton/origin_item/origin/gadpathur_exile,
		/singleton/origin_item/origin/queendom,
		/singleton/origin_item/origin/wastelander
	)

/singleton/quirk/rad_resistance/on_spawn(mob/character, selection)
	..()
	character?.AddComponent(/datum/component/armor, list(RAD = ARMOR_RAD_MINOR))

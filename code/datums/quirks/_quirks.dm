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
	/// Positive costs spend points; negative costs grant points.
	var/point_cost = 0
	/// Slots may only have a zero or positive cost.
	var/slot_cost = 1
	/// Optional list of values presented as a selector when this quirk is chosen.
	var/list/selections
	/// Names used by the retired disability preference, for automatic migration.
	var/list/legacy_names = list()
	/// Optional convenience hooks. Quirks are not required to use either.
	var/component_type
	var/element_type

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

/singleton/quirk/nearsighted
	name = "Nearsightedness"
	description = "Without prescription glasses your vision is impaired."
	category = /singleton/quirk_category/sensory
	point_cost = -1
	legacy_names = list("Nearsightedness")

/singleton/quirk/nearsighted/on_spawn(mob/living/carbon/human/character, selection)
	character.disabilities |= NEARSIGHTED
	if(character.dna)
		character.dna.SetSEState(GLASSESBLOCK, 1, 0)
	if(character.glasses)
		var/obj/item/clothing/glasses/worn_glasses = character.glasses
		worn_glasses.prescription = 7
	else
		character.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(character), slot_glasses, TRUE)

/singleton/quirk/stutter
	name = "Stuttering"
	description = "You have a chronic stutter and involuntarily repeat sounds."
	category = /singleton/quirk_category/mental
	point_cost = -1
	legacy_names = list("Stuttering")

/singleton/quirk/stutter/on_spawn(mob/living/carbon/human/character, selection)
	character.disabilities |= STUTTERING

/singleton/quirk/deuteranopia
	name = "Deuteranopia"
	description = "You have difficulty perceiving green."
	category = /singleton/quirk_category/sensory
	point_cost = -1
	legacy_names = list("Deuteranopia")

/singleton/quirk/deuteranopia/on_spawn(mob/living/carbon/human/character, selection)
	character.add_client_color(/datum/client_color/deuteranopia, TRUE)

/singleton/quirk/protanopia
	name = "Protanopia"
	description = "You have difficulty perceiving red."
	category = /singleton/quirk_category/sensory
	point_cost = -1
	legacy_names = list("Protanopia")

/singleton/quirk/protanopia/on_spawn(mob/living/carbon/human/character, selection)
	character.add_client_color(/datum/client_color/protanopia, TRUE)

/singleton/quirk/tritanopia
	name = "Tritanopia"
	description = "You have difficulty perceiving blue and yellow."
	category = /singleton/quirk_category/sensory
	point_cost = -1
	legacy_names = list("Tritanopia")

/singleton/quirk/tritanopia/on_spawn(mob/living/carbon/human/character, selection)
	character.add_client_color(/datum/client_color/tritanopia, TRUE)

/singleton/quirk/total_colorblind
	name = "Total Colorblindness"
	description = "You cannot see color, only black, white, and shades of gray."
	category = /singleton/quirk_category/sensory
	point_cost = -1
	legacy_names = list("Total Colorblindness")

/singleton/quirk/total_colorblind/on_spawn(mob/living/carbon/human/character, selection)
	character.add_client_color(/datum/client_color/monochrome, TRUE)

/singleton/quirk/deaf
	name = "Deafness"
	description = "You are unable to perceive sound."
	category = /singleton/quirk_category/sensory
	point_cost = -2
	legacy_names = list("Deafness")

/singleton/quirk/deaf/on_spawn(mob/living/carbon/human/character, selection)
	character.sdisabilities |= DEAF

/singleton/quirk/asthma
	name = "Asthma"
	description = "You are prone to inflammation in the lungs."
	point_cost = -1
	legacy_names = list("Asthma")

/singleton/quirk/asthma/on_spawn(mob/living/carbon/human/character, selection)
	character.disabilities |= ASTHMA
	if(character.max_stamina)
		character.max_stamina *= 0.8
		character.stamina = character.max_stamina

/singleton/quirk/hemophilia
	name = "Hemophilia"
	description = "Your blood lacks clotting factors, causing wounds to take twice as long to stop bleeding."
	point_cost = -1
	legacy_names = list("Hemophilia")
	var/trait_type = TRAIT_DISABILITY_HEMOPHILIA

/singleton/quirk/hemophilia/on_spawn(mob/living/carbon/human/character, selection)
	ADD_TRAIT(character, trait_type, DISABILITY_TRAIT)

/singleton/quirk/hemophilia/major
	name = "Major Hemophilia"
	description = "Your blood lacks all clotting factors, causing wounds to never stop bleeding."
	point_cost = -2
	legacy_names = list("Major Hemophilia")
	trait_type = TRAIT_DISABILITY_HEMOPHILIA_MAJOR

ABSTRACT_TYPE(/singleton/quirk/organ_scarring)
	name = "Organ Scarring"
	point_cost = -1
	var/affected_organ

/singleton/quirk/organ_scarring/on_spawn(mob/living/carbon/human/character, selection)
	var/obj/item/organ/internal/affecting = character.internal_organs_by_name[affected_organ]
	if(affecting)
		affecting.set_max_damage(initial(affecting.max_damage) * 0.5)

#define ORGAN_QUIRK(ORGAN_PATH, ORGAN_NAME, ORGAN_TAG) \
/singleton/quirk/organ_scarring/##ORGAN_PATH { \
	name = "Scarred Organ: " + ##ORGAN_NAME; \
	description = "Your " + ##ORGAN_NAME + " is permanently scarred and has reduced health."; \
	affected_organ = ##ORGAN_TAG; \
	legacy_names = list("Scarred Organ: " + ##ORGAN_NAME); \
}

ORGAN_QUIRK(brain, "Brain", BP_BRAIN)
ORGAN_QUIRK(eyes, "Eyes", BP_EYES)
ORGAN_QUIRK(lungs, "Lungs", BP_LUNGS)
ORGAN_QUIRK(liver, "Liver", BP_LIVER)
ORGAN_QUIRK(kidneys, "Kidneys", BP_KIDNEYS)
ORGAN_QUIRK(stomach, "Stomach", BP_STOMACH)
ORGAN_QUIRK(appendix, "Appendix", BP_APPENDIX)

#undef ORGAN_QUIRK

ABSTRACT_TYPE(/singleton/quirk/broken)
	name = "Broken Limb"
	point_cost = -1
	var/affected_limb

/singleton/quirk/broken/on_spawn(mob/living/carbon/human/character, selection)
	var/obj/item/organ/external/affecting = character.get_organ(affected_limb)
	if(affecting)
		affecting.fracture(silent = TRUE)
		affecting.status |= ORGAN_SPLINTED

#define BROKEN_QUIRK(LIMB_PATH, LIMB_NAME, LIMB_TAG) \
/singleton/quirk/broken/##LIMB_PATH { \
	name = "Broken Limb: " + ##LIMB_NAME; \
	description = "Your " + ##LIMB_NAME + " begins the round broken and splinted."; \
	affected_limb = ##LIMB_TAG; \
	legacy_names = list("Broken Limb: " + ##LIMB_NAME); \
}

BROKEN_QUIRK(left_arm, "Left Arm", BP_L_ARM)
BROKEN_QUIRK(right_arm, "Right Arm", BP_R_ARM)
BROKEN_QUIRK(left_hand, "Left Hand", BP_L_HAND)
BROKEN_QUIRK(right_hand, "Right Hand", BP_R_HAND)
BROKEN_QUIRK(left_leg, "Left Leg", BP_L_LEG)
BROKEN_QUIRK(right_leg, "Right Leg", BP_R_LEG)
BROKEN_QUIRK(left_foot, "Left Foot", BP_L_FOOT)
BROKEN_QUIRK(right_foot, "Right Foot", BP_R_FOOT)

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
	point_cost = -1
	element_type = /datum/element/light_sensitivity
	legacy_names = list("Photosensitivity")

/singleton/quirk/nyctophobia
	name = "Nyctophobia"
	description = "You have a fear of the dark."
	category = /singleton/quirk_category/mental
	point_cost = -1
	element_type = /datum/element/dark_afraid
	legacy_names = list("Nyctophobia")

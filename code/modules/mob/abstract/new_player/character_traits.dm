//Character trait system. Currently geared only for disabilities but a refactor to make it trait neutral would be trivial.

/datum/character_disabilities
	var/name = "Enigma"
	var/desc = "This trait was not meant to be seen by mortal minds."

/datum/character_disabilities/proc/apply_self(var/mob/living/carbon/human/H)
	return

/datum/character_disabilities/nearsighted
	name = "Nearsightedness"
	desc = "Without prescription glasses your vision is impaired."

/datum/character_disabilities/nearsighted/apply_self(var/mob/living/carbon/human/H)
	H.disabilities |= NEARSIGHTED

/datum/character_disabilities/stutter
	name = "Stuttering"
	desc = "You have a chronic case of stuttering, repeating sounds involuntarily."

/datum/character_disabilities/stutter/apply_self(var/mob/living/carbon/human/H)
	H.disabilities |= STUTTERING

/datum/character_disabilities/deuteranomaly
	name = "Deuteranopia"
	desc = "You have difficulty perceiving green."

/datum/character_disabilities/deuteranomaly/apply_self(var/mob/living/carbon/human/H)
	H.add_client_color(/datum/client_color/deuteranopia, TRUE)

/datum/character_disabilities/protanopia
	name = "Protanopia"
	desc = "You have difficulty perceiving red."

/datum/character_disabilities/protanopia/apply_self(var/mob/living/carbon/human/H)
	H.add_client_color(/datum/client_color/protanopia, TRUE)

/datum/character_disabilities/tritanopia
	name = "Tritanopia"
	desc = "You have difficulty perceiving green and yellow."

/datum/character_disabilities/tritanopia/apply_self(var/mob/living/carbon/human/H)
	H.add_client_color(/datum/client_color/tritanopia, TRUE)

/datum/character_disabilities/total_colorblind
	name = "Total Colorblindness"
	desc = "You cannot see color, only black, white, and shades of gray."

/datum/character_disabilities/total_colorblind/apply_self(var/mob/living/carbon/human/H)
	H.add_client_color(/datum/client_color/monochrome, TRUE)

/datum/character_disabilities/deaf
	name = "Deafness"
	desc = "You are unable to percieve sound."

/datum/character_disabilities/deaf/apply_self(var/mob/living/carbon/human/H)
	H.sdisabilities |= DEAF

/datum/character_disabilities/asthma
	name = "Asthma"
	desc = "You are prone to inflammation in the lungs."

/datum/character_disabilities/asthma/apply_self(var/mob/living/carbon/human/H)
	H.disabilities |= ASTHMA
	if(H.max_stamina)
		H.max_stamina *= 0.8
		H.stamina = H.max_stamina

// ALLERGIES

/datum/character_disabilities/allergy
	abstract_type = /datum/character_disabilities/allergy

	name = "Abstract Allergy"
	/// A string, only used in the description building
	var/allergen = "allergy"
	/// This takes a TRAIT_ALLERGY_* type trait, and assigns it to the character on apply_self
	var/trait_type

/datum/character_disabilities/allergy/New()
	..()
	desc = "You are allergic to [allergen]. Consuming it will cause you to go into anaphylactic shock."

/datum/character_disabilities/allergy/apply_self(var/mob/living/carbon/human/H)
	ADD_TRAIT(H, trait_type, DISABILITY_TRAIT)


/datum/character_disabilities/allergy/blueberry
	name = "Minor Blueberry Allergy"
	allergen = "blueberries"
	trait_type = TRAIT_ALLERGY_BLUEBERRY_MINOR

/datum/character_disabilities/allergy/blueberry/major
	name = "Major Blueberry Allergy"
	trait_type = TRAIT_ALLERGY_BLUEBERRY_MAJOR

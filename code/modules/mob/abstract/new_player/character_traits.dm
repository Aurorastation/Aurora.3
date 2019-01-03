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
	H.disabilities |= STUTTER

/datum/character_disabilities/deuteranomaly
	name = "Deuteranopia"
	desc = "You have difficulty perceiving green."

/datum/character_disabilities/deuteranomaly/apply_self(var/mob/living/carbon/human/H)
	H.add_client_color(/datum/client_color/deuteranopia)

/datum/character_disabilities/protanopia
	name = "Protanopia"
	desc = "You have difficulty perceiving red."

/datum/character_disabilities/protanopia/apply_self(var/mob/living/carbon/human/H)
	H.add_client_color(/datum/client_color/protanopia)

/datum/character_disabilities/tritanopia
	name = "Tritanopia"
	desc = "You have difficulty perceiving green and yellow."

/datum/character_disabilities/tritanopia/apply_self(var/mob/living/carbon/human/H)
	H.add_client_color(/datum/client_color/tritanopia)

/datum/character_disabilities/mute
	name = "Muteness"
	desc = "You are unable to form coherent speech."

/datum/character_disabilities/mute/apply_self(var/mob/living/carbon/human/H)
	H.sdisabilities |= MUTE

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
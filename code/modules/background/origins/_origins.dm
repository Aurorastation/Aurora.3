/singleton/origin_item
	var/name = "generic origin item"
	var/desc = DESC_PARENT
	var/important_information //Big red text. Should only be used if not following it would incur a bwoink.
	var/list/origin_traits = list()
	/// Format for the following list: "Characters from this origin: [list entry], [list entry]."
	/// One list item per trait.
	var/list/origin_traits_descriptions = list()

/singleton/origin_item/culture
	name = "generic culture"
	var/list/singleton/origin_item/origin/possible_origins = list()

/singleton/origin_item/origin
	name = "generic origin"
	var/list/datum/accent/possible_accents = list()
	var/list/datum/citizenship/possible_citizenships = list()
	var/list/datum/religion/possible_religions = list()

/singleton/origin_item/proc/on_apply(var/mob/living/carbon/human/H)
	for(var/trait in origin_traits)
		ADD_TRAIT(H, trait, CULTURE_TRAIT)

/singleton/origin_item/proc/on_remove(var/mob/living/carbon/human/H)
	for(var/trait in origin_traits)
		REMOVE_TRAIT(H, trait, CULTURE_TRAIT)

/mob/living/carbon/human/proc/set_culture(var/singleton/origin_item/OI)
	var/singleton/origin_item/culture/old_culture = culture
	if(!istype(OI))
		crash_with("Invalid culture supplied: [OI]!")
	culture = OI
	if(old_culture && culture != old_culture)
		old_culture.on_remove(src)
	OI.on_apply(src)

/mob/living/carbon/human/proc/set_origin(var/singleton/origin_item/OI)
	var/singleton/origin_item/origin/old_origin = origin
	if(!istype(OI))
		crash_with("Invalid origin supplied: [OI]!")
	origin = OI
	if(old_origin && origin != old_origin)
		old_origin.on_remove(src)
	OI.on_apply(src)


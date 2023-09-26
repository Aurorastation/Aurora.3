/singleton/origin_item
	var/name = "generic origin item"
	var/desc = DESC_PARENT
	var/important_information //Big red text. Should only be used if not following it would incur a bwoink.
	var/list/origin_traits = list()
	/// Format for the following list: "Characters from this origin: [list entry], [list entry]."
	/// One list item per trait.
	var/list/origin_traits_descriptions = list()
	var/list/origin_augs = list() //For origins that will spawn with augments. Currently used for the C'thur and K'lax origins and cultures.

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

	for(var/augment in origin_augs)
		var/obj/item/organ/A = new augment(H)
		var/obj/item/organ/external/affected = H.get_organ(A.parent_organ)
		A.replaced(H, affected)
		H.update_body()
